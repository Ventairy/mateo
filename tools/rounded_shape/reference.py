"""Evaluate the rounded-shape foundation with Python's standard library."""

import math


COEFFICIENTS = {
    "extent": 1.5286649465560913,
    "shoulder_angle": 0.4188790204786391,
}


def effective_radius(width, height, radius):
    if not math.isfinite(radius) or radius < 0:
        raise ValueError("Radius must be finite and nonnegative")
    if not all(math.isfinite(v) and v > 0 for v in (width, height)):
        return None
    return min(radius, width / 2, height / 2)


def axis_parameters(dimension, radius):
    """Return the corner extent and shoulder construction in radius units."""
    extent = min(COEFFICIENTS["extent"], (dimension / 2) / radius)
    fraction = (extent - 1) / (COEFFICIENTS["extent"] - 1)
    angle = COEFFICIENTS["shoulder_angle"] * fraction
    tangent = math.tan(angle / 2)
    return dict(extent=extent, fraction=fraction, angle=angle, tangent=tangent,
                b=1 - tangent / 4 + 3 * tangent ** 3 / 4,
                c=1 - tangent,
                sine=2 * tangent / (1 + tangent * tangent),
                rise=2 * tangent * tangent / (1 + tangent * tangent))


def top_right_segments(width, height, radius):
    """Return a top shoulder, exact circular arc, and right shoulder."""
    x = axis_parameters(width, radius)
    y = axis_parameters(height, radius)
    top = [(width - radius * x["extent"], 0),
           (width - radius * x["b"], 0),
           (width - radius * x["c"], 0),
           (width - radius + radius * x["sine"], radius * x["rise"])]
    right = [(width - radius * y["rise"], radius - radius * y["sine"]),
             (width, radius * y["c"]),
             (width, radius * y["b"]),
             (width, radius * y["extent"])]
    segments = []
    if x["angle"] > 0:
        segments.append(dict(kind="C", points=top))
    segments.append(dict(kind="A", points=[top[-1], right[0]],
                         center=(width - radius, radius), radius=radius,
                         startAngle=-math.pi / 2 + x["angle"], endAngle=-y["angle"]))
    if y["angle"] > 0:
        segments.append(dict(kind="C", points=right))
    return segments


def outline(width, height, radius, origin=(0.0, 0.0)):
    """Return clockwise move, line, cubic, circular-arc, and close commands."""
    r = effective_radius(width, height, radius)
    ox, oy = origin
    if r is None or not all(math.isfinite(v) for v in (ox, oy, ox + width, oy + height)):
        return []
    if r == 0:
        return [
            {"kind": "M", "points": [[ox, oy]]},
            {"kind": "L", "points": [[ox + width, oy]]},
            {"kind": "L", "points": [[ox + width, oy + height]]},
            {"kind": "L", "points": [[ox, oy + height]]},
            {"kind": "Z", "points": []},
        ]

    tr = top_right_segments(width, height, r)
    transforms = [
        (True, lambda x, y: (x, height - y), lambda a, b: (-b, -a)),
        (False, lambda x, y: (width - x, height - y), lambda a, b: (a + math.pi, b + math.pi)),
        (True, lambda x, y: (width - x, y), lambda a, b: (math.pi - b, math.pi - a)),
        (False, lambda x, y: (x, y), lambda a, b: (a, b)),
    ]
    elements = [dict(kind="M", points=[(width, height / 2)])]
    for reverse, transform, angles in transforms:
        for index, segment in enumerate(reversed(tr) if reverse else tr):
            points = [transform(*p) for p in (reversed(segment["points"]) if reverse else segment["points"])]
            if index == 0:
                elements.append(dict(kind="L", points=[points[0]]))
            command = dict(kind=segment["kind"], points=points[1:])
            if segment["kind"] == "A":
                start, end = angles(segment["startAngle"], segment["endAngle"])
                command.update(center=transform(*segment["center"]), radius=r,
                               startAngle=start, endAngle=end)
            elements.append(command)
    elements.append(dict(kind="Z", points=[]))
    for element in elements:
        element["points"] = [[ox + x, oy + y] for x, y in element["points"]]
        if element["kind"] == "A":
            x, y = element["center"]
            element["center"] = [ox + x, oy + y]
    return elements


def cubic_point(controls, t):
    u = 1 - t
    weights = (u ** 3, 3 * u * u * t, 3 * u * t * t, t ** 3)
    return tuple(sum(weight * p[axis] for weight, p in zip(weights, controls)) for axis in (0, 1))


def segment_point(segment, t):
    if segment["kind"] == "C":
        return cubic_point(segment["points"], t)
    if t == 0 or t == 1:
        return tuple(segment["points"][int(t)])
    angle = (1 - t) * segment["startAngle"] + t * segment["endAngle"]
    x, y = segment["center"]
    r = segment["radius"]
    return x + r * math.cos(angle), y + r * math.sin(angle)


def svg_path(elements):
    parts = []
    for element in elements:
        points = " ".join(f"{x:.17g},{y:.17g}" for x, y in element["points"])
        if element["kind"] == "A":
            r = element["radius"]
            parts.append(f"A{r:.17g},{r:.17g} 0 0 1 {points}")
        else:
            parts.append(element["kind"] + points)
    return " ".join(parts)


def main():
    from artifacts import write
    from verify import verify

    write()
    verify()


if __name__ == "__main__":
    main()
