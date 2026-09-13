#include "path.h"

// Packed path construction for painting; captured contours retain their exact coordinates.
#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <new>
#include <utility>
#include <vector>
namespace {
struct P {
  float x, y;
};
static_assert(sizeof(P) == 2 * sizeof(float));
struct Builder {
  std::vector<P> input, output, compact;
  std::vector<std::size_t> indices, anchors;
  std::vector<unsigned char> keep;
  std::vector<std::pair<std::size_t, std::size_t>> stack;
  std::size_t retainedBytes() const {
    return sizeof(Builder) +
           (input.capacity() + output.capacity() + compact.capacity()) * sizeof(P) +
           (indices.capacity() + anchors.capacity()) * sizeof(std::size_t) +
           keep.capacity() * sizeof(unsigned char) +
           stack.capacity() * sizeof(std::pair<std::size_t, std::size_t>);
  }
  static bool same(P a, P b) { return a.x == b.x && a.y == b.y; }
  static double cross(P a, P b, P c) {
    double ax = double(b.x) - a.x, ay = double(b.y) - a.y, bx = double(c.x) - b.x,
           by = double(c.y) - b.y;
    float fax = ax, fay = ay, fbx = bx, fby = by;
    float first = fax * fby, second = fay * fbx;
    if (!std::isfinite(first) || !std::isfinite(second) || (first == 0 && ax * by != 0) ||
        (second == 0 && ay * bx != 0))
      return ax * by - ay * bx;
    return float(first - second);
  }
  void hull(const std::vector<P>& p, std::vector<P>& out) {
    std::size_t start = 0, n = p.size();
    for (std::size_t i = 1; i < n; i++)
      if (p[i].x < p[start].x || (p[i].x == p[start].x && p[i].y < p[start].y)) start = i;
    indices.clear();
    for (std::size_t j = 0; j <= n; j++) {
      std::size_t i = (start + j) % n;
      if (!indices.empty() && same(p[indices.back()], p[i])) continue;
      while (indices.size() >= 2 &&
             cross(p[indices[indices.size() - 2]], p[indices.back()], p[i]) <= 0)
        indices.pop_back();
      indices.push_back(i);
    }
    if (indices.size() > 1 && same(p[indices.back()], p[indices.front()])) indices.pop_back();
    out.clear();
    for (auto i : indices) out.push_back(p[i]);
  }
  void simplify(double tolerance) {
    const auto& p = output;
    const std::size_t n = p.size();
    anchors.clear();
    for (int axis = 0; axis < 2; axis++)
      for (int sign : {-1, 1}) {
        std::size_t best = 0;
        for (std::size_t i = 1; i < n; i++)
          if (sign * double(axis ? p[i].y : p[i].x) > sign * double(axis ? p[best].y : p[best].x))
            best = i;
        anchors.push_back(best);
      }
    std::sort(anchors.begin(), anchors.end());
    anchors.erase(std::unique(anchors.begin(), anchors.end()), anchors.end());
    keep.assign(n, 0);
    stack.clear();
    for (std::size_t i = 0; i < anchors.size(); i++) {
      keep[anchors[i]] = 1;
      stack.push_back(
          {anchors[i], anchors[(i + 1) % anchors.size()] + (i + 1 == anchors.size() ? n : 0)});
    }
    while (!stack.empty()) {
      const auto range = stack.back();
      stack.pop_back();
      std::size_t best = 0;
      double maximum = tolerance * tolerance;
      const auto a = p[range.first % n], b = p[range.second % n];
      double dx = double(b.x) - a.x, dy = double(b.y) - a.y, len2 = dx * dx + dy * dy;
      for (std::size_t i = range.first + 1; i < range.second; i++) {
        const auto q = p[i % n];
        double px = double(q.x) - a.x, py = double(q.y) - a.y,
               f = len2 ? std::clamp((px * dx + py * dy) / len2, 0., 1.) : 0.;
        double ex = px - dx * f, ey = py - dy * f, dist = ex * ex + ey * ey;
        if (dist > maximum) {
          maximum = dist;
          best = i;
        }
      }
      if (best) {
        keep[best % n] = 1;
        stack.push_back({range.first, best});
        stack.push_back({best, range.second});
      }
    }
    compact.clear();
    for (std::size_t i = 0; i < n; i++)
      if (keep[i]) compact.push_back(p[i]);
    hull(compact, input);
    output.swap(input);
  }
  const std::vector<P>& prepare(const double* p, std::size_t n, double left, double top,
                                double width, double height, double tolerance) {
    input.resize(n);
    for (std::size_t i = 0; i < n; i++)
      input[i] = {float(left + (p[2 * i] + .5) * width), float(top + (p[2 * i + 1] + .5) * height)};
    hull(input, output);
    if (tolerance > 0 && output.size() > 4) simplify(tolerance);
    return output;
  }
};
}  // namespace
extern "C" {
void* mateo_path_create() {
  try {
    return new Builder();
  } catch (...) {
    return nullptr;
  }
}
void mateo_path_destroy(void* handle) { delete static_cast<Builder*>(handle); }
std::size_t mateo_path_retained_bytes(void* handle) {
  return handle ? static_cast<Builder*>(handle)->retainedBytes() : 0;
}
const float* mateo_path_prepare(void* handle, const double* points, int count, double left,
                                double top, double width, double height, double tolerance,
                                int* outputCount) {
  if (outputCount) *outputCount = 0;
  if (!handle || !points || !outputCount || count < 3 || !std::isfinite(left) ||
      !std::isfinite(top) || !std::isfinite(width) || !std::isfinite(height) ||
      !(width > 0 && height > 0) || !std::isfinite(tolerance) || tolerance < 0)
    return nullptr;
  try {
    const auto& p = static_cast<Builder*>(handle)->prepare(points, std::size_t(count), left, top,
                                                           width, height, tolerance);
    *outputCount = int(p.size());
    return reinterpret_cast<const float*>(p.data());
  } catch (...) {
    return nullptr;
  }
}
}
