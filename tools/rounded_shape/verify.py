"""Check rounded-shape geometry, continuity, and portable artifacts."""

import json
import math
import re

from artifacts import OUTPUT, ROOT, drawings, fixtures
from reference import COEFFICIENTS, axis_parameters, cubic_point, effective_radius, outline, segment_point, top_right_segments


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def de_casteljau(controls, t):
    values = [tuple(p) for p in controls]
    while len(values) > 1:
        values = [tuple((1 - t) * a + t * b for a, b in zip(p, q)) for p, q in zip(values, values[1:])]
    return values[0]


def derivatives(controls, t):
    u = 1 - t
    first = tuple(3 * (u * u * (controls[1][a] - controls[0][a]) +
                      2 * u * t * (controls[2][a] - controls[1][a]) +
                      t * t * (controls[3][a] - controls[2][a])) for a in (0, 1))
    second = tuple(6 * (u * (controls[2][a] - 2 * controls[1][a] + controls[0][a]) +
                       t * (controls[3][a] - 2 * controls[2][a] + controls[1][a])) for a in (0, 1))
    return first, second


def curvature(controls, t):
    first, second = derivatives(controls, t)
    return (first[0] * second[1] - first[1] * second[0]) / math.hypot(*first) ** 3


def quadratic_roots(a, b, c):
    if abs(a) < 1e-15:
        return [] if abs(b) < 1e-15 else [-c / b]
    discriminant = b * b - 4 * a * c
    if discriminant < 0:
        return []
    q = -0.5 * (b + math.copysign(math.sqrt(discriminant), b))
    return [-b / (2 * a)] if q == 0 else [q / a, c / q]


def support(segments, angle):
    """Maximize projection using cubic derivative roots and exact arc normals."""
    normal = math.cos(angle), math.sin(angle)
    result = -math.inf
    for segment in segments:
        parameters = [0, 1]
        if segment["kind"] == "C":
            z = [sum(a * b for a, b in zip(p, normal)) for p in segment["points"]]
            parameters += [t for t in quadratic_roots(-z[0] + 3*z[1] - 3*z[2] + z[3],
                                                     2*(z[0] - 2*z[1] + z[2]), z[1] - z[0]) if 0 < t < 1]
        elif segment["startAngle"] < angle < segment["endAngle"]:
            parameters.append((angle - segment["startAngle"]) / (segment["endAngle"] - segment["startAngle"]))
        result = max(result, *(sum(a * b for a, b in zip(segment_point(segment, t), normal)) for t in parameters))
    return result


def verify():
    document = (ROOT / "design-system/foundation/rounded-shape.md").read_text()
    for name, symbol in dict(extent="a", shoulder_angle="θ₀").items():
        match = re.search(r"\|\s*\*\*" + re.escape(symbol) + r"\*\*\s*\|\s*([0-9.]+)\s*\|", document)
        require(match is not None and float(match[1]) == COEFFICIENTS[name], f"Document coefficient mismatch: {name}")

    shapes = samples = circles = 0
    max_sample_error = max_circle_error = 0.0
    threshold = 1 / (2 * COEFFICIENTS["extent"])
    for height in (0.001, 50.0, 500.0, 1e6):
        for ratio in (1.0, 1.01, 1.2, 1.3, 2.0, 6.0, 100.0):
            for width, h in ((ratio * height, height), (height, ratio * height)):
                fractions = (0, 0.01, 0.125, 0.25, threshold - 1e-8, threshold,
                             threshold + 1e-8, 0.4, 0.49, 0.499999, 0.5, 2)
                for fraction in fractions:
                    requested = min(width, h) * fraction
                    r = effective_radius(width, h, requested)
                    elements = outline(width, h, requested)
                    tolerance = max(width, h) * 1e-12
                    require(elements[0]["kind"] == "M" and elements[-1]["kind"] == "Z", "Open outline")
                    for element in elements:
                        for x, y in element["points"]:
                            require(math.isfinite(x) and math.isfinite(y), "Nonfinite point")
                            require(-tolerance <= x <= width + tolerance and -tolerance <= y <= h + tolerance, "Control outside bounds")
                    if r:
                        require(sum(e["kind"] == "A" for e in elements) == 4, "Expected four circular arcs")
                        segments = top_right_segments(width, h, r)
                        for dimension in (width, h):
                            axis = axis_parameters(dimension, r)
                            require(1 <= axis["extent"] <= COEFFICIENTS["extent"], "Invalid extent")
                            require(axis["extent"] >= axis["b"] >= axis["c"], "Reversed shoulder controls")
                        for segment in segments:
                            for i in range(17):
                                t = i / 16
                                actual = segment_point(segment, t)
                                if segment["kind"] == "C":
                                    expected = de_casteljau(segment["points"], t)
                                    error = math.dist(actual, expected)
                                    require(error <= tolerance, "Independent cubic evaluation mismatch")
                                    max_sample_error = max(max_sample_error, error)
                                else:
                                    error = abs(math.dist(actual, segment["center"]) - r)
                                    require(error <= tolerance, "Arc is not circular")
                                    max_circle_error = max(max_circle_error, error)
                                samples += 1
                        if width == h and r == width / 2:
                            require(all(e["kind"] != "C" for e in elements), "Full circle retains a shoulder")
                            current = elements[0]["points"][0]
                            sweep = 0
                            for element in elements[1:]:
                                if element["kind"] == "L":
                                    require(element["points"][0] == current, "Full circle retains a straight side")
                                if element["kind"] == "A":
                                    require(element["center"] == [r, r], "Full circle has different arc centers")
                                    require(element["radius"] == r, "Full circle radius differs")
                                    sweep += element["endAngle"] - element["startAngle"]
                                if element["points"]:
                                    current = element["points"][-1]
                            require(abs(sweep - 2 * math.pi) < 1e-14, "Full circle does not cover one turn")
                            require(current == elements[0]["points"][0], "Full circle is not closed")
                            circles += 1
                    else:
                        require([e["kind"] for e in elements] == ["M", "L", "L", "L", "Z"], "Zero radius is not a rectangle")
                    moved = outline(width, h, requested, (17, -25))
                    for a, b in zip(elements, moved):
                        for (x, y), (mx, my) in zip(a["points"], b["points"]):
                            require(mx == x + 17 and my == y - 25, "Origin translation mismatch")
                        if a["kind"] == "A":
                            require(b["center"] == [a["center"][0] + 17, a["center"][1] - 25], "Arc center was not translated")
                    shapes += 1

    # Geometric checks use derivatives of the final controls, independent of
    # the formulas used to choose those controls.
    joins = 0
    max_curvature_error = max_tangent_error = 0.0
    for fraction in (0.0001, 0.001, 0.01, 0.1, 0.25, 0.5, 0.75, 1):
        dimension = 2 * (1 + fraction * (COEFFICIENTS["extent"] - 1))
        segments = top_right_segments(dimension, dimension, 1)
        top, arc, right = segments
        require(abs(curvature(top["points"], 0)) < 1e-12, "Top does not start with zero curvature")
        require(abs(curvature(right["points"], 1)) < 1e-12, "Right does not end with zero curvature")
        for segment, t, angle in ((top, 1, arc["startAngle"]), (right, 0, arc["endAngle"])):
            first, _ = derivatives(segment["points"], t)
            tangent = (-math.sin(angle), math.cos(angle))
            tangent_error = abs(first[0] * tangent[1] - first[1] * tangent[0]) / math.hypot(*first)
            curvature_error = abs(curvature(segment["points"], t) - 1)
            require(tangent_error < 2e-8, "Cubic and arc tangents differ")
            # A nearly collapsed shoulder's normal displacement is O(angle²).
            # Subtracting its final absolute coordinates loses that many bits.
            turn = axis_parameters(dimension, 1)["angle"]
            curvature_tolerance = max(2e-9, 8 * math.ulp(1.0) / turn ** 2)
            require(curvature_error < curvature_tolerance, "Cubic and arc curvatures differ")
            max_tangent_error = max(max_tangent_error, tangent_error)
            max_curvature_error = max(max_curvature_error, curvature_error)
            joins += 1
        for segment in (top, right):
            for i in range(101):
                require(curvature(segment["points"], i / 100) >= -1e-12, "Shoulder bends inward")

    directions = [-math.pi / 2 + j * math.pi / 128 for j in range(65)]
    progression_shapes = 0
    max_reversal = 0.0
    for ratio in [1 + i / 100 for i in range(51)] + [1.6, 2, 3, 6, 10, 100]:
        for width, height in ((ratio, 1), (1, ratio)):
            previous = None
            for i in range(1, 401):
                segments = top_right_segments(width, height, 0.5 * i / 400)
                values = [support(segments, angle) for angle in directions]
                if previous:
                    max_reversal = max(max_reversal, max(a - b for a, b in zip(values, previous)))
                previous = values
                progression_shapes += 1
    require(max_reversal < 1e-10, "Increasing radius moves the outline outward")

    # Check the limit separately; changing path segment count must not snap
    # the visible outline at full rounding or when one axis becomes square.
    limit_cases = 0
    max_limit_ratio = 0.0
    for width, height in ((1, 1), (1.001, 1), (1, 1.001), (1.3, 1), (1, 1.3), (6, 1)):
        endpoint = [support(top_right_segments(width, height, 0.5), a) for a in directions]
        previous_error = math.inf
        for exponent in range(2, 13):
            epsilon = 10 ** -exponent
            nearby = [support(top_right_segments(width, height, 0.5 * (1 - epsilon)), a) for a in directions]
            error = max(abs(a - b) for a, b in zip(nearby, endpoint))
            require(error <= previous_error + 1e-14, "Full-rounding limit diverges")
            require(error <= epsilon + 1e-13, "Full-rounding limit has a jump")
            max_limit_ratio = max(max_limit_ratio, error / epsilon)
            previous_error = error
            limit_cases += 1

    for radius in (-1, math.inf, -math.inf, math.nan):
        try:
            outline(100, 100, radius)
        except ValueError:
            pass
        else:
            raise AssertionError("Invalid radius accepted")
    for width, height, origin in ((0, 50, (0, 0)), (50, -1, (0, 0)), (math.inf, 50, (0, 0)), (50, 50, (math.nan, 0)), (1e308, 50, (1e308, 0))):
        require(outline(width, height, 12, origin) == [], "Invalid bounds have an outline")
    require(outline(96, 96, 999) == outline(96, 96, 48), "Radius clamp mismatch")

    saved = json.loads((OUTPUT / "reference.json").read_text())
    require(saved == fixtures(), "Reference JSON is out of date")
    for name, content in drawings().items():
        require((OUTPUT / name).read_text() == content, f"Reference drawing is out of date: {name}")

    result = dict(shapes=shapes, curveSamples=samples, exactCircleCases=circles,
                  maxCubicEvaluationError=max_sample_error, maxArcRadialError=max_circle_error,
                  checkedJoins=joins, maxJoinTangentError=max_tangent_error,
                  maxJoinRelativeCurvatureError=max_curvature_error,
                  radiusProgressionCases=progression_shapes, maxSupportReversal=max_reversal,
                  fullRoundingLimitCases=limit_cases, maxLimitErrorPerRadiusFraction=max_limit_ratio,
                  coefficients="match documentation", artifacts="reproducible")
    print(json.dumps(result, indent=2))
    return result


if __name__ == "__main__":
    verify()
