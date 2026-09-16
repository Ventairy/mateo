"""Portable reference for the rounded-shape interpolation foundation."""
from dataclasses import dataclass
from math import isfinite
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
from tools.rounded_shape.reference import outline as rounded_outline


@dataclass(frozen=True)
class Frame:
    """Visible shape dimensions and fitted radius, in logical units."""

    width: float
    height: float
    radius: float


def endpoint(width, height, radius):
    """Fit the requested radius to positive endpoint bounds."""
    if not isfinite(radius) or radius < 0:
        raise ValueError('Radius must be finite and nonnegative.')
    if not all(isfinite(v) and v > 0 for v in (width, height)):
        raise ValueError('Interpolation needs positive finite dimensions.')
    r = min(radius, width / 2, height / 2)
    return Frame(width, height, r)


def _validate(frame):
    w, h, r = frame.width, frame.height, frame.radius
    if not all(isfinite(v) for v in (w, h, r)) or min(w, h) <= 0 or r < 0:
        raise ValueError('Invalid rounded-shape frame.')
    if r > min(w, h) / 2:
        raise ValueError('Radius must fit the rounded shape.')


def _lerp(a, b, t):
    """Linear interpolation and extrapolation without motion resistance."""
    if a == b:
        return a
    if 0 <= t <= 1:
        return (1 - t) * a + t * b
    return a + (b - a) * t


def interpolate(source, destination, progress):
    """Morph resting triples or previous Frames directly, including retargets.

    A triple is (width, height, requested radius). A Frame retains only visible
    width, height, and effective radius when an animation is interrupted.
    """
    if not isfinite(progress):
        raise ValueError('Progress must be finite.')
    a = source if isinstance(source, Frame) else endpoint(*source)
    b = destination if isinstance(destination, Frame) else endpoint(*destination)
    _validate(a)
    _validate(b)
    t = progress
    if t == 0 or a == b:
        return a
    if t == 1:
        return b
    w, h = _lerp(a.width, b.width, t), _lerp(a.height, b.height, t)
    if not all(isfinite(v) and v > 0 for v in (w, h)):
        raise ValueError('Progress produces unrepresentable dimensions.')
    radius = _lerp(a.radius, b.radius, t)
    if not isfinite(radius):
        raise ValueError('Progress produces an unrepresentable radius.')
    r = min(max(0., radius), w / 2, h / 2)
    frame = Frame(w, h, r)
    _validate(frame)
    return frame


def outline(frame):
    """Draw the canonical rounded shape from the three visible values."""
    _validate(frame)
    return rounded_outline(frame.width, frame.height, frame.radius)
