"""Contract checks for the rounded-shape interpolation reference."""
from dataclasses import astuple
import math
from pathlib import Path
import random
import sys
import unittest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from tools.rounded_shape_interpolation import reference as ref
from tools.rounded_shape import reference as shape


class RoundedShapeInterpolationTests(unittest.TestCase):
    def assertFrameClose(self, a, b, relative=1e-11):
        for x, y in zip(astuple(a), astuple(b)):
            self.assertAlmostEqual(x, y, delta=max(a.width, a.height, b.width, b.height) * relative)

    def test_resting_endpoint_controls_match_rounded_shape(self):
        for w, h, r in [(500, 500, 72), (220, 220, 80), (300, 50, 25), (65, 50, 25), (96, 96, 999), (48, 144, 24), (1, 100, .5)]:
            actual = ref.outline(ref.endpoint(w, h, r))
            expected = shape.outline(w, h, r)
            self.assertEqual(len(actual), len(expected))
            for a, b in zip(actual, expected):
                self.assertEqual(a['kind'], b['kind'])
                if a['kind'] == 'A':
                    for key in ('radius', 'startAngle', 'endAngle'):
                        self.assertAlmostEqual(a[key], b[key], delta=1e-10)
                for p, q in zip(a['points'], b['points']):
                    for x, y in zip(p, q):
                        self.assertAlmostEqual(x, y, delta=1e-11 * max(w, h))

    def test_zero_radius_is_an_exact_rectangle(self):
        elements = ref.outline(ref.endpoint(144, 96, 0))
        self.assertEqual([e['kind'] for e in elements], ['M', 'L', 'L', 'L', 'Z'])
        self.assertEqual([tuple(e['points'][0]) for e in elements[:-1]], [(0, 0), (144, 0), (144, 96), (0, 96)])

    def test_size_and_effective_radius_interpolate_linearly(self):
        frame = ref.interpolate((96, 96, 999), (96, 96, 0), .5)
        self.assertEqual(frame, ref.Frame(96, 96, 24))
        pairs = [((144, 48, 24), (240, 280, 32)), ((200, 56, 28), (56, 200, 28)), ((96, 96, 48), (112, 112, 0))]
        for a, b in pairs:
            left, right = ref.endpoint(*a), ref.endpoint(*b)
            for t in (.01, .25, .5, .75, .99):
                actual = ref.interpolate(a, b, t)
                self.assertFrameClose(actual, ref.Frame(*((1-t)*x+t*y for x,y in zip(astuple(left),astuple(right)))))
                self.assertEqual(ref.outline(actual), shape.outline(actual.width, actual.height, actual.radius))

    def test_midpoint_uses_the_canonical_resting_shape(self):
        frame = ref.interpolate((200, 56, 28), (56, 200, 28), .5)
        self.assertEqual(frame, ref.Frame(128, 128, 28))
        self.assertEqual(ref.outline(frame), shape.outline(128, 128, 28))

    def test_linear_extrapolation_and_radius_fitting(self):
        for t, width, radius in [(-.1, 90, 0), (1.1, 210, 22), (1.5, 250, 30), (2, 300, 40), (100, 10100, 2000)]:
            self.assertFrameClose(ref.interpolate((100, 100, 0), (200, 200, 20), t), ref.Frame(width, width, radius))
        for t in (1.01, 1.2, 10000):
            self.assertEqual(ref.interpolate((100, 100, 20), (100, 100, 0), t).radius, 0)
        self.assertEqual(ref.interpolate((100, 100, 0), (100, 100, 20), 10000).radius, 50)
        fitted = ref.interpolate((200, 200, 0), (40, 40, 20), 1.2)
        self.assertEqual(fitted.radius, min(fitted.width, fitted.height) / 2)

    def test_extreme_finite_progress_keeps_representable_frames(self):
        frame = ref.interpolate((1, 100, 0), (2, 100, 0), 1e308)
        self.assertEqual(frame, ref.Frame(1e308, 100, 0))
        for t in (-1e308, 1e308):
            self.assertEqual(ref.interpolate((100, 100, 20), (100, 100, 20), t), ref.Frame(100, 100, 20))

    def test_randomized_bounds_symmetry_scale_and_stationarity(self):
        randomizer = random.Random(1931)
        for _ in range(1000):
            def example():
                return (10 ** randomizer.uniform(-2, 3), 10 ** randomizer.uniform(-2, 3), 10 ** randomizer.uniform(-3, 3))
            a, b = example(), example()
            t = randomizer.uniform(-.5, 1.5)
            if min(a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t) <= 0:
                for source, destination, progress in [(a, b, t), (b, a, 1 - t)]:
                    with self.assertRaises(ValueError):
                        ref.interpolate(source, destination, progress)
                continue
            frame = ref.interpolate(a, b, t)
            ref._validate(frame)
            self.assertFrameClose(frame, ref.interpolate(b, a, 1 - t))
            self.assertFrameClose(ref.interpolate(a, a, t), ref.endpoint(*a))
            factor = 10 ** randomizer.uniform(-2, 2)
            scaled = ref.interpolate(tuple(v * factor for v in a), tuple(v * factor for v in b), t)
            self.assertFrameClose(scaled, ref.Frame(*(v * factor for v in astuple(frame))))
            for element in ref.outline(frame):
                for x, y in element['points']:
                    self.assertGreaterEqual(x, -1e-10 * frame.width)
                    self.assertLessEqual(x, frame.width * (1 + 1e-10))
                    self.assertGreaterEqual(y, -1e-10 * frame.height)
                    self.assertLessEqual(y, frame.height * (1 + 1e-10))

    def test_retargeting_retains_the_visible_frame(self):
        for t in (-.1, .1, .5, .9, 1.1):
            current = ref.interpolate((144, 48, 24), (240, 280, 32), t)
            self.assertEqual(ref.interpolate(current, (56, 200, 28), 0), current)
            self.assertFrameClose(ref.interpolate(current, current, .73), current)
            ref._validate(ref.interpolate(current, (56, 200, 28), .000001))

    def test_endpoint_continuity_including_overshoot_and_sharp_corners(self):
        for a, b in [((144, 48, 24), (240, 280, 32)), ((96, 96, 48), (112, 112, 0))]:
            for t in (0., 1.):
                frame = ref.interpolate(a, b, t)
                for dt in (-1e-8, 1e-8):
                    self.assertFrameClose(frame, ref.interpolate(a, b, t + dt), relative=1e-7)

    def test_reject_invalid_input(self):
        for bad in [(0, 40, 20), (40, -1, 20), (40, 40, -1), (math.inf, 40, 20), (40, 40, math.nan)]:
            with self.assertRaises(ValueError):
                ref.interpolate(bad, (50, 50, 12), .5)
        for invalid in (ref.Frame(40, 40, 21), ref.Frame(40, 40, -1), ref.Frame(0, 40, 0)):
            with self.assertRaises(ValueError):
                ref.interpolate(invalid, (50, 50, 12), .5)
        with self.assertRaises(ValueError):
            ref.interpolate((1e308, 100, 0), (1.7e308, 100, 0), 100)
        for t in (-1, -2):
            with self.assertRaises(ValueError):
                ref.interpolate((100, 100, 0), (200, 200, 20), t)
        with self.assertRaises(ValueError):
            ref.interpolate((1e308, 1e308, 0), (1e308, 1e308, 5e307), 1e308)
        for t in (math.inf, -math.inf, math.nan):
            with self.assertRaises(ValueError):
                ref.interpolate((40, 40, 20), (50, 50, 12), t)


if __name__ == '__main__':
    unittest.main()
