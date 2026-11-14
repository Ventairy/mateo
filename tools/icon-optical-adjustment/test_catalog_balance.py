"""Independent visual-size acceptance ranges for reported catalog regressions.

These ranges encode reviewed design expectations, not human-perception scores.
They supplement invariant and renderer tests; names never select model behavior.
"""

from functools import lru_cache
from pathlib import Path
import unittest

from adjust_icon_sizes import adjust_icon_size

ICONS = Path(__file__).resolve().parents[2] / "design-system/foundation/assets/icons/svg"
LOGOS = ICONS.parents[1] / "logos"


@lru_cache(maxsize=32)
def metrics(name):
    return adjust_icon_size((ICONS / f"{name}.svg").read_text())[1]


def painted_height(name):
    row = metrics(name)
    return (row["source_bounds"][3] - row["source_bounds"][1]) * row["scale"]


@lru_cache(maxsize=7)
def logo_metrics(name):
    return adjust_icon_size((LOGOS / f"{name}.svg").read_text())[1]


class CatalogBalanceTests(unittest.TestCase):
    def test_authored_color_telegram_has_enough_span_beside_the_black_envelope(self):
        ratio = logo_metrics("telegram")["extent"] / metrics("envelope")["extent"]
        self.assertGreater(ratio, 1.10)
        self.assertLess(ratio, 1.18)

    def test_mixed_catalog_review_keeps_color_marks_in_their_accepted_size_ranges(self):
        # Reviewed beside filled, open, narrow, and outlined icons at 16–28px,
        # bare and in circular/rounded containers. These are design guardrails,
        # not a claim that occupied span alone predicts perceived size.
        for name, lower, upper in (
            ("cataqui", 16.5, 17.5), ("gmail", 15.7, 16.8),
            ("google-messages", 16.5, 17.6), ("instagram", 16.8, 17.9),
            ("phone_by_google", 14.7, 15.8), ("telegram", 17.3, 18.4),
            ("whatsapp", 18.1, 19.2),
        ):
            with self.subTest(name=name):
                extent = logo_metrics(name)["extent"]
                self.assertGreater(extent, lower)
                self.assertLess(extent, upper)

    def test_separated_running_pose_keeps_up_with_the_praying_pose(self):
        ratio = painted_height("running-figure") / painted_height("praying-figure")
        self.assertGreater(ratio, 0.94)
        self.assertLess(ratio, 1.06)

    def test_decorated_ball_gives_its_main_body_enough_span_beside_the_eraser(self):
        ratio = metrics("disco-ball")["extent"] / metrics("eraser")["extent"]
        self.assertGreater(ratio, 1.15)
        self.assertLess(ratio, 1.23)

    def test_broad_body_support_does_not_over_enlarge_dense_or_connected_marks(self):
        for name, upper_extent in (
            ("eraser", 15.1), ("heart", 15.5), ("medical-cross", 15.5),
            ("asterisk", 14.6), ("phone", 14), ("wrench", 14.4),
        ):
            with self.subTest(name=name):
                self.assertLess(metrics(name)["extent"], upper_extent)

    def test_compact_narrow_objects_are_not_sized_like_spread_out_strokes(self):
        self.assertGreater(metrics("popcorn")["extent"], 16.2)
        self.assertGreater(metrics("ev-plug")["extent"], 19)
        self.assertLess(metrics("info")["extent"], 16)
        self.assertGreater(metrics("smartphone")["extent"], 16.5)

    def test_enclosed_head_is_not_dwarfed_by_the_neighboring_heart(self):
        self.assertGreaterEqual(painted_height("monkey-head") / painted_height("heart"), 0.96)
        self.assertLess(painted_height("monkey-head") / painted_height("heart"), 1.05)

    def test_calendar_and_clock_have_comparable_occupied_span(self):
        ratio = metrics("calendar")["extent"] / metrics("clock")["extent"]
        self.assertGreater(ratio, 0.96)
        self.assertLess(ratio, 1.04)

    def test_dense_number_tile_does_not_dominate_filled_circle(self):
        ratio = metrics("numbers")["extent"] / metrics("circle")["extent"]
        self.assertGreater(ratio, 0.93)
        self.assertLess(ratio, 1.03)

    def test_a_small_upper_cavity_does_not_push_a_tall_symbol_to_the_frame_limit(self):
        self.assertLess(metrics("parking-sign")["extent"], 16.8)
        self.assertLess(metrics("helicopter-front")["extent"], 16.5)
        self.assertLess(metrics("hookah")["extent"], 16)

    def test_open_logout_menu_and_road_do_not_regain_excessive_span(self):
        for name in ("logout", "road", "three-horizontal-lines"):
            with self.subTest(name=name):
                self.assertLess(metrics(name)["extent"], 15.5)

    def test_magnifier_supports_its_round_body_without_becoming_oversized(self):
        ratio = metrics("magnifying-glass")["extent"] / metrics("circle")["extent"]
        self.assertGreater(ratio, 1.01)
        self.assertLess(ratio, 1.11)

    def test_directional_chevrons_retain_their_optical_relationship(self):
        ratio = metrics("chevron-left")["extent"] / metrics("chevron-down")["extent"]
        self.assertGreater(ratio, 0.94)
        self.assertLess(ratio, 1)


if __name__ == "__main__":
    unittest.main()
