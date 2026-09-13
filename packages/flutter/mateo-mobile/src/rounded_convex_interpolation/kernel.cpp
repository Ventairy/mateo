#include "kernel.h"
#include <cstdlib>

// Mateo rounded convex interpolation follows its foundation and approved
// motion samples. Flutter owns endpoint capture
// and painting; this kernel owns prepared numeric data and contour evaluation.
#include <algorithm>
#include <memory>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <climits>
#include <limits>
#include <stdexcept>
#include <string>
#include <vector>
#include <future>
#include <thread>
#ifdef __linux__
#include <sched.h>
#endif

namespace mateo {
constexpr double PI = 3.141592653589793238462643383279502884;
constexpr double TAU = 2 * PI;
constexpr int N = 512, M = 256;
struct P {
  double x = 0, y = 0;
};
static_assert(sizeof(P) == 2 * sizeof(double), "C ABI requires interleaved coordinates");
inline P operator+(P a, P b) { return {a.x + b.x, a.y + b.y}; }
inline P operator-(P a, P b) { return {a.x - b.x, a.y - b.y}; }
inline P operator*(P a, double s) { return {a.x * s, a.y * s}; }
inline P operator/(P a, double s) { return {a.x / s, a.y / s}; }
inline double dot(P a, P b) { return a.x * b.x + a.y * b.y; }
inline double cross(P a, P b) { return a.x * b.y - a.y * b.x; }
inline double length(P a) { return std::hypot(a.x, a.y); }
inline double angle(P a) {
  double v = std::atan2(a.y, a.x);
  return v < 0 ? v + TAU : v;
}
inline double positive(double a, double b, double t, double minimum = 1e-12) {
  if (t >= 0 && t <= 1) return (1 - t) * a + t * b;
  a = std::max(minimum, a);
  b = std::max(minimum, b);
  double x = t < 0 ? a : b, z = (b - a) * (t < 0 ? t : t - 1);
  if (z >= 0) return x + z;
  double q = -z / x;
  return x / (1 + q + q * q);
}
inline double dimension(double a, double b, double t) {
  if (t >= 0 && t <= 1) return (1 - t) * a + t * b;
  double x = t < 0 ? a : b, relative = (b - a) * (t < 0 ? t : t - 1) / x;
  if (!std::isfinite(relative)) return std::numeric_limits<double>::quiet_NaN();
  double ratio = relative / .2;
  double s = std::abs(ratio) <= 1
                 ? relative / std::sqrt(1 + ratio * ratio)
                 : std::copysign(.2, relative) / std::sqrt(1 + (1 / ratio) * (1 / ratio));
  return s >= 0 ? x * (1 + s) : x / (1 - s + s * s);
}
inline double curveProgress(double t) {
  auto f = [](double u) { return u + .9 * u * u * u * (4 - 7 * u + 3 * u * u); };
  if (t < 0) return .02 * std::tanh(5 * t);
  if (t < .25) return .25 * (1 - f(1 - 4 * t));
  if (t <= .75) return t;
  if (t <= 1) return .75 + .25 * f(4 * t - 3);
  return 1 + .02 * std::tanh(5 * (t - 1));
}
struct Bounds {
  double x0 = std::numeric_limits<double>::infinity(), y0 = x0, x1 = -x0, y1 = -x0;
  void add(P p) {
    if (!std::isfinite(p.x) || !std::isfinite(p.y))
      throw std::runtime_error("Nonfinite boundary coordinate");
    x0 = std::min(x0, p.x);
    x1 = std::max(x1, p.x);
    y0 = std::min(y0, p.y);
    y1 = std::max(y1, p.y);
  }
  P center() const { return {(x0 + x1) / 2, (y0 + y1) / 2}; }
};
void fit(std::vector<P>& points, double width = 1, double height = 1) {
  Bounds b;
  for (P p : points) b.add(p);
  if (!(b.x1 > b.x0 && b.y1 > b.y0)) throw std::runtime_error("Collapsed bounds");
  P c = b.center();
  double w = b.x1 - b.x0, h = b.y1 - b.y0;
  if (!std::isfinite(w) || !std::isfinite(h) || !std::isfinite(width) || !std::isfinite(height) ||
      width <= 0 || height <= 0)
    throw std::runtime_error("Unrepresentable fitted bounds");
  for (P& p : points) p = {(p.x - c.x) * width / w, (p.y - c.y) * height / h};
}
struct Shape {
  double width, height, anchor;
  std::array<double, N> turns, speeds;
  std::array<double, M> gaps;
  Shape(double width, double height)
      : width(width), height(height), anchor(0), turns{}, speeds{}, gaps{} {}
  explicit Shape(const double* p) : width(p[0]), height(p[1]), anchor(p[2]) {
    if (!(width > 0 && height > 0))
      throw std::runtime_error("Positive endpoint dimensions required");
    for (int i = 0; i < N; i++) {
      turns[i] = p[3 + i];
      speeds[i] = p[3 + N + i];
    }
    for (int i = 0; i < M; i++) gaps[i] = p[3 + 2 * N + i];
  }
};
using Cubic = std::array<P, 4>;
P bezier(const Cubic& c, double t) {
  double u = 1 - t;
  return c[0] * (u * u * u) + c[1] * (3 * u * u * t) + c[2] * (3 * u * t * t) + c[3] * (t * t * t);
}
void roots(double a, double b, double c, std::vector<double>& result) {
  result.clear();
  if (a == 0) {
    if (b != 0) result.push_back(-c / b);
    return;
  }
  double disc = b * b - 4 * a * c;
  if (disc < 0) return;
  double q = -.5 * (b + (b < 0 ? -1 : 1) * std::sqrt(disc));
  if (q == 0) {
    result.push_back(0);
    return;
  }
  result.push_back(q / a);
  result.push_back(c / q);
}
struct Edge {
  double angle, length;
};
struct PairEdge {
  P direction;
  double a, b;
};
struct Line {
  double angle;
  P normal;
  double h;
};
struct MixEdge {
  double angle;
  P delta;
};

void orderAngleChain(std::vector<MixEdge>& edges, std::size_t begin, std::size_t end) {
  if (end - begin < 2) return;
  std::size_t first = begin;
  for (std::size_t i = begin + 1; i < end; i++)
    if (edges[i].angle < edges[first].angle) first = i;
  bool ordered = first == begin || edges[begin].angle != edges[end - 1].angle;
  double previous = edges[first].angle;
  std::size_t cursor = first;
  for (std::size_t i = 1; ordered && i < end - begin; i++) {
    if (++cursor == end) cursor = begin;
    if (edges[cursor].angle < previous) ordered = false;
    previous = edges[cursor].angle;
  }
  if (ordered)
    std::rotate(edges.begin() + begin, edges.begin() + first, edges.begin() + end);
  else
    std::stable_sort(edges.begin() + begin, edges.begin() + end,
                     [](const MixEdge& a, const MixEdge& b) { return a.angle < b.angle; });
}

struct Workspace {
  std::array<double, N> turns{}, speeds{};
  std::array<P, N> directions{};
  std::array<double, N + 1> cumulative{};
  std::array<P, M> controls{};
  std::array<Cubic, M> cubics{};
  std::vector<P> polygon, points, compacted, opened;
  std::vector<Line> lines, unique, queue;
  std::vector<MixEdge> mixedEdges;
  std::vector<double> quadraticRoots;
  std::vector<unsigned char> keep;
  std::vector<std::pair<int, int>> stack;
  bool busy = false;
  Workspace() {
    polygon.reserve(N);
    points.reserve(M * 4);
    compacted.reserve(M * 4);
    opened.reserve(4096);
    lines.reserve(M * 4);
    unique.reserve(M * 4);
    queue.reserve(M * 4);
    mixedEdges.reserve(8192);
    quadraticRoots.reserve(2);
    stack.reserve(M * 4);
    keep.reserve(M * 4);
  }
};
struct WorkspacePool {
  std::vector<std::unique_ptr<Workspace>> values;
  Workspace& acquire() {
    for (auto& value : values)
      if (!value->busy) {
        value->busy = true;
        return *value;
      }
    values.push_back(std::make_unique<Workspace>());
    values.back()->busy = true;
    return *values.back();
  }
};
WorkspacePool& threadWorkspaces() {
  thread_local WorkspacePool pool;
  return pool;
}

class Kernel {
  Shape a, b;
  bool rounded;
  std::vector<PairEdge> pair;
  std::vector<P> mixed;
  Workspace* activeWorkspace = nullptr;
  std::array<P, 64> supportDirections{};
  double minimum = 1e-12;
  Workspace& work() { return *activeWorkspace; }
  struct Operation {
    Kernel& kernel;
    Workspace* owned = nullptr;
    explicit Operation(Kernel& k) : kernel(k) {
      if (!k.activeWorkspace) {
        owned = &threadWorkspaces().acquire();
        k.activeWorkspace = owned;
      }
    }
    ~Operation() {
      if (owned) {
        kernel.activeWorkspace = nullptr;
        owned->busy = false;
      }
    }
  };

  static std::vector<Edge> endpointEdges(const double* data, int count, double minimum) {
    std::vector<Edge> result;
    result.reserve(count);
    for (int i = 0; i < count; i++) {
      std::size_t ii = static_cast<std::size_t>(i), j = (ii + 1) % static_cast<std::size_t>(count);
      P d = {data[2 * j] - data[2 * ii], data[2 * j + 1] - data[2 * ii + 1]};
      double size = length(d);
      if (!std::isfinite(size)) throw std::runtime_error("Unrepresentable endpoint edge");
      if (size >= minimum) result.push_back({angle(d), size});
    }
    std::stable_sort(result.begin(), result.end(),
                     [](const Edge& a, const Edge& b) { return a.angle < b.angle; });
    return result;
  }
  void physical(double t, std::vector<P>& output) {
    double q = t < 0 ? .08 * std::tanh(t / .08) : t > 1 ? 1 + .08 * std::tanh((t - 1) / .08) : t;
    P mean{};
    double sum = 0;
    for (const auto& e : pair) {
      double w = positive(e.a, e.b, q, minimum);
      mean = mean + e.direction * w;
      sum += w;
    }
    mean = mean / sum;
    output.clear();
    P p{};
    for (const auto& e : pair) {
      double w = positive(e.a, e.b, q, minimum);
      output.push_back(p);
      p = p + (e.direction - mean) * w;
    }
    fit(output);
  }
  void reconstruct(double t, double width, double height) {
    double g = curveProgress(t), sum = 0, weight = 0;
    for (int i = 0; i < N; i++) {
      work().turns[i] = positive(a.turns[i], b.turns[i], g);
      work().speeds[i] = positive(a.speeds[i], b.speeds[i], g);
      sum += work().turns[i];
      weight += work().speeds[i];
    }
    double theta = (1 - g) * a.anchor + g * b.anchor;
    P mean{};
    for (int i = 0; i < N; i++) {
      work().directions[i] = {std::cos(theta), std::sin(theta)};
      mean = mean + work().directions[i] * work().speeds[i];
      theta += TAU * work().turns[i] / sum;
    }
    mean = mean / weight;
    work().polygon.clear();
    P p{};
    for (int i = 0; i < N; i++) {
      work().polygon.push_back(p);
      p = p + (work().directions[i] - mean) * work().speeds[i];
    }
    double longest = std::max(width, height);
    fit(work().polygon, width / longest, height / longest);
    work().cumulative[0] = 0;
    for (int i = 0; i < N; i++)
      work().cumulative[i + 1] =
          work().cumulative[i] + length(work().polygon[(i + 1) % N] - work().polygon[i]);
    double gapSum = 0;
    std::array<double, M> gaps{};
    for (int i = 0; i < M; i++) {
      gaps[i] = positive(a.gaps[i], b.gaps[i], g);
      gapSum += gaps[i];
    }
    int edge = 0;
    double arc = 0;
    for (int i = 0; i < M; i++) {
      double target = arc * work().cumulative[N];
      while (edge < N - 1 && work().cumulative[edge + 1] <= target) edge++;
      double fraction = (target - work().cumulative[edge]) /
                        (work().cumulative[edge + 1] - work().cumulative[edge]);
      work().controls[i] =
          work().polygon[edge] * (1 - fraction) + work().polygon[(edge + 1) % N] * fraction;
      arc += gaps[i] / gapSum;
    }
    for (int i = 0; i < M; i++) {
      P p0 = work().controls[(i + M - 1) % M], p1 = work().controls[i],
        p2 = work().controls[(i + 1) % M], p3 = work().controls[(i + 2) % M];
      work().cubics[i] = {(p0 + p1 * 4 + p2) / 6, (p1 * 2 + p2) / 3, (p1 + p2 * 2) / 3,
                          (p1 + p2 * 4 + p3) / 6};
    }
    Bounds bounds;
    for (const Cubic& c : work().cubics) {
      bounds.add(c[0]);
      bounds.add(c[3]);
      for (int coordinate = 0; coordinate < 2; coordinate++) {
        double p[4];
        for (int i = 0; i < 4; i++) p[i] = coordinate ? c[i].y : c[i].x;
        roots(-p[0] + 3 * p[1] - 3 * p[2] + p[3], 2 * (p[0] - 2 * p[1] + p[2]), p[1] - p[0],
              work().quadraticRoots);
        for (double v : work().quadraticRoots)
          if (v > 0 && v < 1) bounds.add(bezier(c, v));
      }
    }
    P center = bounds.center();
    double w = bounds.x1 - bounds.x0, h = bounds.y1 - bounds.y0;
    for (Cubic& c : work().cubics)
      for (P& p : c) p = {(p.x - center.x) / w, (p.y - center.y) / h};
    work().points.clear();
    for (const Cubic& c : work().cubics)
      for (int j = 0; j < 4; j++) {
        P p = bezier(c, j / 4.);
        work().points.push_back({p.x * width, p.y * height});
      }
  }
  double distance(P p, P a, P b) {
    P d = b - a;
    double denominator = length(d);
    double f = denominator ? std::clamp(dot(p - a, d) / (denominator * denominator), 0., 1.) : 0;
    return length(p - a - d * f);
  }
  void compact(double error) {
    const int n = static_cast<int>(work().points.size());
    std::array<int, 4> anchor{0, 0, 0, 0};
    for (int i = 1; i < n; i++) {
      if (work().points[i].x < work().points[anchor[0]].x) anchor[0] = i;
      if (work().points[i].x > work().points[anchor[1]].x) anchor[1] = i;
      if (work().points[i].y < work().points[anchor[2]].y) anchor[2] = i;
      if (work().points[i].y > work().points[anchor[3]].y) anchor[3] = i;
    }
    double extent = std::max(work().points[anchor[1]].x - work().points[anchor[0]].x,
                             work().points[anchor[3]].y - work().points[anchor[2]].y);
    bool scaledSafe = std::isfinite(extent) && extent <= 1e76;
    std::sort(anchor.begin(), anchor.end());
    auto end = std::unique(anchor.begin(), anchor.end());
    int count = static_cast<int>(end - anchor.begin());
    work().keep.assign(n, 0);
    work().stack.clear();
    for (int i = 0; i < count; i++) {
      work().keep[anchor[i]] = 1;
      work().stack.push_back({anchor[i], anchor[(i + 1) % count] + (i == count - 1 ? n : 0)});
    }
    while (!work().stack.empty()) {
      auto range = work().stack.back();
      work().stack.pop_back();
      double maximum = error * error;
      int index = -1;
      P start = work().points[range.first % n], delta = work().points[range.second % n] - start;
      double denominator = length(delta), denominatorSquared = denominator * denominator;
      if (!std::isfinite(denominatorSquared) || !std::isfinite(maximum) || maximum == 0) {
        double originalMaximum = error;
        for (int i = range.first + 1; i < range.second; i++) {
          double d = distance(work().points[i % n], start, start + delta);
          if (d > originalMaximum) {
            originalMaximum = d;
            index = i;
          }
        }
      } else {
        double scaledMaximum = maximum * denominatorSquared;
        int cursor = (range.first + 1) % n;
        if (scaledSafe && std::isfinite(scaledMaximum) && scaledMaximum > 0) {
          for (int i = range.first + 1; i < range.second; i++) {
            P relative = work().points[cursor] - start;
            if (++cursor == n) cursor = 0;
            double projection = dot(relative, delta), squared;
            if (projection <= 0)
              squared = dot(relative, relative) * denominatorSquared;
            else if (projection >= denominatorSquared) {
              P residual = relative - delta;
              squared = dot(residual, residual) * denominatorSquared;
            } else {
              double area = cross(relative, delta);
              squared = area * area;
            }
            if (squared > scaledMaximum) {
              scaledMaximum = squared;
              index = i;
            }
          }
        } else {
          for (int i = range.first + 1; i < range.second; i++) {
            P relative = work().points[cursor] - start;
            if (++cursor == n) cursor = 0;
            double f =
                denominator ? std::clamp(dot(relative, delta) / denominatorSquared, 0., 1.) : 0;
            P residual = relative - delta * f;
            double squared = dot(residual, residual);
            if (squared > maximum) {
              maximum = squared;
              index = i;
            }
          }
        }
      }
      if (index >= 0) {
        work().keep[index % n] = 1;
        work().stack.push_back({range.first, index});
        work().stack.push_back({index, range.second});
      }
    }
    work().compacted.clear();
    for (int i = 0; i < n; i++)
      if (work().keep[i]) work().compacted.push_back(work().points[i]);
  }
  static bool intersection(const Line& a, const Line& b, P& p) {
    double det = cross(a.normal, b.normal);
    if (std::abs(det) < 1e-12) return false;
    p = {(a.h * b.normal.y - a.normal.y * b.h) / det, (a.normal.x * b.h - a.h * b.normal.x) / det};
    if (!std::isfinite(p.x) || !std::isfinite(p.y))
      throw std::runtime_error("Unrepresentable inset intersection");
    return true;
  }
  static bool excludes(const Line& line, const Line& a, const Line& b) {
    P p;
    return !intersection(a, b, p) || dot(line.normal, p) < line.h - 1e-11;
  }
  void opening(double requested) {
    work().opened.clear();
    if (requested < 1e-6) {
      work().opened = work().points;
      return;
    }
    compact(std::min(.003, requested * .003));
    work().lines.clear();
    double area = 0;
    P centroid{};
    for (std::size_t i = 0; i < work().compacted.size(); i++) {
      P p = work().compacted[i], q = work().compacted[(i + 1) % work().compacted.size()], d = q - p;
      double size = length(d), c = cross(p, q);
      area += c;
      centroid = centroid + (p + q) * c;
      if (size < 1e-9) continue;
      P normal = {-d.y / size, d.x / size};
      work().lines.push_back({angle(normal), normal, dot(normal, p)});
    }
    if (!(area > 0) || !std::isfinite(area) || !std::isfinite(centroid.x) ||
        !std::isfinite(centroid.y) || work().lines.size() < 3)
      throw std::runtime_error("Nonconvex opening input");
    centroid = centroid / (3 * area);
    double available = std::numeric_limits<double>::infinity();
    for (const Line& l : work().lines)
      available = std::min(available, dot(l.normal, centroid) - l.h);
    if (!std::isfinite(available) || available <= 0 || !std::isfinite(requested))
      throw std::runtime_error("Unrepresentable inset radius");
    double radius = std::min(requested, .9 * available);
    if (radius < 1e-6) {
      work().opened = work().points;
      return;
    }
    std::stable_sort(work().lines.begin(), work().lines.end(),
                     [](const Line& a, const Line& b) { return a.angle < b.angle; });
    work().unique.clear();
    for (Line l : work().lines) {
      l.h += radius;
      if (!work().unique.empty() && l.angle - work().unique.back().angle < 1e-9)
        work().unique.back().h = std::max(work().unique.back().h, l.h);
      else
        work().unique.push_back(l);
    }
    if (work().unique.size() > 1 &&
        work().unique.front().angle + TAU - work().unique.back().angle < 1e-9) {
      work().unique.front().h = std::max(work().unique.front().h, work().unique.back().h);
      work().unique.pop_back();
    }
    work().queue.clear();
    std::size_t first = 0;
    for (const Line& line : work().unique) {
      while (work().queue.size() - first > 1 &&
             excludes(line, work().queue[work().queue.size() - 2], work().queue.back()))
        work().queue.pop_back();
      while (work().queue.size() - first > 1 &&
             excludes(line, work().queue[first], work().queue[first + 1]))
        first++;
      work().queue.push_back(line);
    }
    while (
        work().queue.size() - first > 2 &&
        excludes(work().queue[first], work().queue[work().queue.size() - 2], work().queue.back()))
      work().queue.pop_back();
    while (work().queue.size() - first > 2 &&
           excludes(work().queue.back(), work().queue[first], work().queue[first + 1]))
      first++;
    std::size_t count = work().queue.size() - first;
    if (count < 3) throw std::runtime_error("Collapsed inset");
    for (std::size_t i = 0; i < count; i++) {
      const Line& a = work().queue[first + i];
      const Line& b = work().queue[first + (i + 1) % count];
      P center;
      if (!intersection(a, b, center)) throw std::runtime_error("Parallel inset supports");
      double theta = std::fmod(a.angle + PI, TAU), turn = b.angle - a.angle;
      if (turn < 0) turn += TAU;
      int steps = std::max(1, static_cast<int>(std::ceil(turn / .04)));
      for (int j = 0; j <= steps; j++) {
        if (j == 0)
          work().opened.push_back(center - a.normal * radius);
        else if (j == steps)
          work().opened.push_back(center - b.normal * radius);
        else {
          double v = theta + turn * j / steps;
          work().opened.push_back(center + P{std::cos(v), std::sin(v)} * radius);
        }
      }
    }
  }
  void mix(double width, double height) {
    fit(work().points, width, height);
    fit(work().opened, width, height);
    auto& edges = work().mixedEdges;
    edges.clear();
    auto append = [&](const std::vector<P>& input, double weight) {
      for (std::size_t i = 0; i < input.size(); i++) {
        P d = (input[(i + 1) % input.size()] - input[i]) * weight;
        if (length(d) > std::min(1e-12, std::max(width, height) * 1e-12))
          edges.push_back({angle(d), d});
      }
    };
    append(work().points, .7);
    std::size_t split = edges.size();
    append(work().opened, .3);
    orderAngleChain(edges, 0, split);
    orderAngleChain(edges, split, edges.size());
    mixed.clear();
    P p{};
    std::size_t i = 0, j = split;
    while (i < split || j < edges.size()) {
      bool left = j == edges.size() || (i < split && edges[i].angle <= edges[j].angle);
      P delta = left ? edges[i++].delta : edges[j++].delta;
      mixed.push_back(p);
      p = p + delta;
    }
    fit(mixed);
  }
  void support(const std::vector<P>& p, std::array<double, 64>& result) {
    std::size_t vertex = 0, n = p.size();
    for (std::size_t i = 1; i < n; i++)
      if (p[i].x > p[vertex].x) vertex = i;
    for (int k = 0; k < 64; k++) {
      P direction = supportDirections[k];
      double value = dot(p[vertex], direction);
      for (std::size_t i = 0; i < n; i++) {
        std::size_t next = (vertex + 1) % n;
        double following = dot(p[next], direction);
        if (following < value - 1e-13) break;
        vertex = next;
        value = following;
      }
      result[k] = value;
    }
  }
  void rawSupports(double t, std::array<double, 64>& result) {
    if (t == 0 || t == 1) {
      physical(t, work().points);
      support(work().points, result);
      return;
    }
    double w = dimension(a.width, b.width, t), h = dimension(a.height, b.height, t),
           g = curveProgress(t);
    reconstruct(t, w, h);
    opening(.36 * std::min(w, h) * std::abs(4 * g * (1 - g)));
    // Keep the canonical RDP, half-planes, sampled arcs, and each component fit.
    // Support distributes over Minkowski addition; no merged edge path is needed.
    fit(work().points, w, h);
    fit(work().opened, w, h);
    for (P& p : work().points) {
      p.x /= w;
      p.y /= h;
    }
    for (P& p : work().opened) {
      p.x /= w;
      p.y /= h;
    }
    std::array<double, 64> original{}, rounded{};
    support(work().points, original);
    support(work().opened, rounded);
    for (int i = 0; i < 64; i++) result[i] = .7 * original[i] + .3 * rounded[i];
  }
  void prepareMovement() {
    unsigned concurrency = std::thread::hardware_concurrency();
#ifdef __linux__
    cpu_set_t available;
    CPU_ZERO(&available);
    if (sched_getaffinity(0, sizeof(available), &available) == 0)
      concurrency = static_cast<unsigned>(CPU_COUNT(&available));
#endif
    const unsigned requestedWorkers = concurrency > 1 ? std::min(3u, concurrency - 1) : 0;
    std::vector<std::array<double, 64>> sampled;
    std::array<std::unique_ptr<Kernel>, 3> contexts;
    unsigned workers = 0;
    // Parallel storage is optional. A memory-constrained caller retains the
    // ordinary serial calculation rather than failing for extra workspaces.
    if (requestedWorkers) {
      try {
        sampled.resize(257);
        for (unsigned i = 0; i < requestedWorkers; i++) {
          contexts[i] = std::make_unique<Kernel>(*this);
          workers++;
        }
      } catch (const std::bad_alloc&) {
        for (auto& context : contexts) context.reset();
        workers = 0;
        std::vector<std::array<double, 64>>().swap(sampled);
      }
    }
    if (workers) {
      try {
        auto sample = [&](Kernel* context, unsigned chunk) {
          Operation operation(*context);
          int start = static_cast<int>(257 * chunk / (workers + 1));
          int end = static_cast<int>(257 * (chunk + 1) / (workers + 1));
          for (int i = start; i < end; i++) context->rawSupports(i / 256., sampled[i]);
        };
        // Futures die first on every exit path, joining workers before the sample
        // closure, numeric contexts, or sample matrix can end their lifetimes.
        std::array<std::future<void>, 3> tasks;
        unsigned launched = 0;
        for (unsigned i = 0; i < workers; i++) {
          try {
            tasks[i] = std::async(std::launch::async, [sample, context = contexts[i].get(),
                                                       chunk = i + 1] { sample(context, chunk); });
            launched++;
          } catch (const std::system_error&) {
            break;
          } catch (const std::bad_alloc&) {
            break;
          }
        }
        sample(this, 0);
        for (unsigned i = launched + 1; i <= workers; i++) sample(this, i);
        for (unsigned i = 0; i < launched; i++) tasks[i].get();
      } catch (const std::bad_alloc&) {
        // The future array has already joined every worker before releasing any
        // shared state. Retry the complete calculation with the caller workspace.
        for (auto& context : contexts) context.reset();
        workers = 0;
        std::vector<std::array<double, 64>>().swap(sampled);
      }
    }
    std::array<double, 64> previous{}, values{};
    std::vector<double> cumulative(257);
    double total = 0;
    for (int i = 0; i < 257; i++) {
      if (workers)
        values = sampled[i];
      else
        rawSupports(i / 256., values);
      if (i) {
        double squared = 0;
        for (int j = 0; j < 64; j++) {
          double d = values[j] - previous[j];
          squared += d * d;
        }
        total += std::sqrt(squared / 64);
      }
      cumulative[i] = total;
      previous = values;
    }
    if (total < 1e-9) {
      mapX = {0, 1};
      mapY = {0, 1};
      mapSlopes = {1, 1};
      return;
    }
    for (int i = 0; i < 257; i++) {
      double x = cumulative[i] / total, y = i / 256.;
      if (!mapX.empty() && x - mapX.back() < 1e-12) {
        mapY.back() = y;
      } else {
        mapX.push_back(x);
        mapY.push_back(y);
      }
    }
    mapX.front() = mapY.front() = 0;
    mapX.back() = mapY.back() = 1;
    std::vector<double> h, d;
    for (std::size_t i = 1; i < mapX.size(); i++) {
      h.push_back(mapX[i] - mapX[i - 1]);
      d.push_back((mapY[i] - mapY[i - 1]) / h.back());
    }
    auto end = [](double h0, double h1, double d0, double d1) {
      return std::max(0., std::min(3 * d0, ((2 * h0 + h1) * d0 - h0 * d1) / (h0 + h1)));
    };
    mapSlopes.push_back(d.size() > 1 ? end(h[0], h[1], d[0], d[1]) : d[0]);
    for (std::size_t i = 1; i + 1 < mapX.size(); i++) {
      double w1 = 2 * h[i] + h[i - 1], w2 = h[i] + 2 * h[i - 1];
      mapSlopes.push_back(d[i - 1] * d[i] <= 0 ? 0 : (w1 + w2) / (w1 / d[i - 1] + w2 / d[i]));
    }
    std::size_t i = d.size() - 1;
    mapSlopes.push_back(d.size() > 1 ? end(h[i], h[i - 1], d[i], d[i - 1]) : d[0]);
  }

 public:
  std::vector<double> mapX, mapY, mapSlopes;
  // Copy only prepared numeric data. A workspace lease belongs to its thread
  // and must never cross into a parallel preparation clone.
  Kernel(const Kernel& other)
      : a(other.a),
        b(other.b),
        rounded(other.rounded),
        pair(other.pair),
        supportDirections(other.supportDirections),
        minimum(other.minimum),
        mapX(other.mapX),
        mapY(other.mapY),
        mapSlopes(other.mapSlopes) {}
  bool canReverse() const {
    // Reusing the reversed movement map is a bounded numerical optimization.
    // Very large, very small, or thin shapes use independent preparation.
    double smallest = std::min({a.width, a.height, b.width, b.height});
    double largest = std::max({a.width, a.height, b.width, b.height});
    if (smallest < .25 || largest > 4096 || largest / smallest > 256) return false;
    if (rounded) {
      if (mapX.size() != 257) return false;
      for (std::size_t i = 1; i < mapX.size(); i++)
        if (mapX[i] - mapX[i - 1] < 1e-10) return false;
    }
    return true;
  }
  Kernel(const Kernel& other, bool reverse) : Kernel(other) {
    if (!reverse) return;
    std::swap(a, b);
    for (auto& edge : pair) std::swap(edge.a, edge.b);
    for (auto& x : mapX) x = 1 - x;
    for (auto& y : mapY) y = 1 - y;
    std::reverse(mapX.begin(), mapX.end());
    std::reverse(mapY.begin(), mapY.end());
    std::reverse(mapSlopes.begin(), mapSlopes.end());
  }

 private:
  void preparePhysical(const double* pa, int na, const double* pb, int nb) {
    minimum = std::min(1e-12, std::max({a.width, a.height, b.width, b.height}) * 1e-12);
    auto ea = endpointEdges(pa, na, std::min(1e-10, std::max(a.width, a.height) * 1e-12));
    auto eb = endpointEdges(pb, nb, std::min(1e-10, std::max(b.width, b.height) * 1e-12));
    std::size_t i = 0, j = 0;
    pair.reserve(ea.size() + eb.size());
    while (i < ea.size() || j < eb.size()) {
      double aa = i < ea.size() ? ea[i].angle : std::numeric_limits<double>::infinity(),
             ab = j < eb.size() ? eb[j].angle : std::numeric_limits<double>::infinity();
      if (std::abs(aa - ab) < 1e-10) {
        pair.push_back({{std::cos(aa), std::sin(aa)}, ea[i].length, eb[j].length});
        i++;
        j++;
      } else if (aa < ab) {
        pair.push_back({{std::cos(aa), std::sin(aa)}, ea[i].length, 0});
        i++;
      } else {
        pair.push_back({{std::cos(ab), std::sin(ab)}, 0, eb[j].length});
        j++;
      }
    }
    if (pair.empty()) throw std::runtime_error("Empty endpoint edge chain");
  }

 public:
  Kernel(double aw, double ah, double bw, double bh, const double* pa, int na, const double* pb,
         int nb)
      : a(aw, ah), b(bw, bh), rounded(false) {
    preparePhysical(pa, na, pb, nb);
  }
  Kernel(const double* da, const double* db, const double* pa, int na, const double* pb, int nb,
         bool rounds)
      : a(da), b(db), rounded(rounds) {
    preparePhysical(pa, na, pb, nb);
    if (rounded) {
      for (int k = 0; k < 64; k++) {
        double angle = TAU * k / 64;
        supportDirections[k] = {std::cos(angle), std::sin(angle)};
      }
      Operation operation(*this);
      prepareMovement();
    }
  }
  const std::vector<P>& raw(double t) {
    if (!std::isfinite(t)) throw std::runtime_error("Nonfinite raw progress");
    if (!rounded || t == 0 || t == 1) {
      physical(t, mixed);
      return mixed;
    }
    Operation operation(*this);
    double w = dimension(a.width, b.width, t), h = dimension(a.height, b.height, t),
           g = curveProgress(t);
    reconstruct(t, w, h);
    opening(.36 * std::min(w, h) * std::abs(4 * g * (1 - g)));
    mix(w, h);
    return mixed;
  }
  double progress(double t) const {
    if (!rounded) return t;
    if (t <= 0) return mapSlopes.front() * t;
    if (t >= 1) return 1 + mapSlopes.back() * (t - 1);
    std::size_t b = std::upper_bound(mapX.begin(), mapX.end(), t) - mapX.begin(), a = b - 1;
    double h = mapX[b] - mapX[a], u = (t - mapX[a]) / h;
    return (2 * u * u * u - 3 * u * u + 1) * mapY[a] +
           (u * u * u - 2 * u * u + u) * h * mapSlopes[a] + (-2 * u * u * u + 3 * u * u) * mapY[b] +
           (u * u * u - u * u) * h * mapSlopes[b];
  }
  std::size_t retainedBytes() const {
    return sizeof(Kernel) + pair.capacity() * sizeof(PairEdge) + mixed.capacity() * sizeof(P) +
           (mapX.capacity() + mapY.capacity() + mapSlopes.capacity()) * sizeof(double);
  }
  const std::vector<P>& frame(double t) {
    if (!std::isfinite(t)) throw std::runtime_error("Nonfinite progress");
    if (rounded && t != 0 && t != 1) return raw(progress(t));
    physical(t, mixed);
    return mixed;
  }
};
}  // namespace mateo
namespace {
thread_local char lastError[512] = {};
void setError(const char* message) noexcept {
  std::size_t i = 0;
  for (; i < sizeof(lastError) - 1 && message[i]; i++) lastError[i] = message[i];
  lastError[i] = 0;
}
void validateDescriptor(const double* p, std::size_t size) {
  if (!p || size < 1283) throw std::invalid_argument("Descriptor requires 1283 doubles");
  for (std::size_t i = 0; i < 1283; i++)
    if (!std::isfinite(p[i])) throw std::invalid_argument("Descriptor must be finite");
  if (p[0] <= 0 || p[1] <= 0) throw std::invalid_argument("Positive endpoint dimensions required");
  double turn = 0, speed = 0, gap = 0;
  for (int i = 0; i < 512; i++) {
    if (p[3 + i] <= 0 || p[515 + i] <= 0)
      throw std::invalid_argument("Positive prepared turns and speeds required");
    turn += p[3 + i];
    speed += p[515 + i];
  }
  for (int i = 0; i < 256; i++) {
    if (p[1027 + i] <= 0) throw std::invalid_argument("Positive prepared arc gaps required");
    gap += p[1027 + i];
  }
  if (!std::isfinite(turn) || !std::isfinite(speed) || !std::isfinite(gap))
    throw std::invalid_argument("Unrepresentable prepared totals");
}
void validatePolygon(const double* p, int count, std::size_t capacity) {
  if (!p || count < 3 || static_cast<std::size_t>(count) > capacity / 2)
    throw std::invalid_argument("Endpoint polygon buffer is too short");
  for (std::size_t i = 0; i < static_cast<std::size_t>(count) * 2; i++)
    if (!std::isfinite(p[i])) throw std::invalid_argument("Endpoint polygon must be finite");
}
mateo::Kernel& checkedHandle(void* handle) {
  if (!handle) throw std::invalid_argument("Null kernel handle");
  return *static_cast<mateo::Kernel*>(handle);
}
}  // namespace
extern "C" {
void* mateo_create_physical_checked(double aw, double ah, double bw, double bh, const double* pa,
                                    int na, std::size_t pacap, const double* pb, int nb,
                                    std::size_t pbcap) {
  try {
    for (double dimension : {aw, ah, bw, bh})
      if (!std::isfinite(dimension) || dimension <= 0)
        throw std::invalid_argument("Positive finite endpoint dimensions required");
    validatePolygon(pa, na, pacap);
    validatePolygon(pb, nb, pbcap);
    return new mateo::Kernel(aw, ah, bw, bh, pa, na, pb, nb);
  } catch (const std::exception& e) {
    setError(e.what());
    return nullptr;
  }
}
void* mateo_create_checked(const double* a, std::size_t alen, const double* b, std::size_t blen,
                           const double* pa, int na, std::size_t pacap, const double* pb, int nb,
                           std::size_t pbcap, int rounded) {
  try {
    validateDescriptor(a, alen);
    validateDescriptor(b, blen);
    validatePolygon(pa, na, pacap);
    validatePolygon(pb, nb, pbcap);
    if (rounded != 0 && rounded != 1)
      throw std::invalid_argument("Rounded flag must be zero or one");
    return new mateo::Kernel(a, b, pa, na, pb, nb, rounded != 0);
  } catch (const std::exception& e) {
    setError(e.what());
    return nullptr;
  }
}
const double* mateo_frame(void* handle, double t, int* count) {
  try {
    if (!count) throw std::invalid_argument("Null vertex count output");
    *count = 0;
    const auto& p = checkedHandle(handle).frame(t);
    if (p.size() > INT_MAX) throw std::runtime_error("Too many output vertices");
    *count = static_cast<int>(p.size());
    return reinterpret_cast<const double*>(p.data());
  } catch (const std::exception& e) {
    setError(e.what());
    if (count) *count = 0;
    return nullptr;
  }
}
std::size_t mateo_retained_bytes(void* handle) {
  return handle ? static_cast<mateo::Kernel*>(handle)->retainedBytes() : 0;
}
void* mateo_reverse(void* handle) {
  try {
    auto& kernel = checkedHandle(handle);
    if (!kernel.canReverse()) return nullptr;
    return new mateo::Kernel(kernel, true);
  } catch (const std::exception& e) {
    setError(e.what());
    return nullptr;
  }
}
void mateo_destroy(void* handle) { delete static_cast<mateo::Kernel*>(handle); }
const char* mateo_error() { return lastError; }
}

extern "C" {
void* mateo_allocate(size_t count, size_t size) { return std::calloc(count, size); }
void mateo_release(void* pointer) { std::free(pointer); }
}
