import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';

import '../fixtures/menu_overlay_golden_scene.dart';

Future<void> main() async {
  await goldenTest(
    'when anchored menus open, it should honor caller-defined adjacent placement in RTL and fill',
    fileName: 'show_mateo_menu',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: [
        GoldenTestScenario(
          name: 'near top',
          child: const SizedBox(width: 360, height: 480, child: MenuOverlayGoldenScene(anchorTop: 24)),
        ),
        GoldenTestScenario(
          name: 'near bottom',
          child: const SizedBox(width: 360, height: 480, child: MenuOverlayGoldenScene(anchorTop: 400)),
        ),
        GoldenTestScenario(
          name: 'RTL',
          child: const SizedBox(width: 360, height: 480, child: MenuOverlayGoldenScene(anchorTop: 24, direction: .rtl)),
        ),
        GoldenTestScenario(
          name: 'fill',
          child: const SizedBox(width: 360, height: 480, child: MenuOverlayGoldenScene(anchorTop: 24, width: .fill)),
        ),
      ],
    ),
  );
}
