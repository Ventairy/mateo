import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  await goldenTest(
    'when icons have circular backgrounds, it should preserve spacing and supplied foreground colors at each size',
    fileName: 'mateo_icon_background',
    builder: () => MateoTheme(
      data: surfaceTransformTheme,
      child: GoldenTestGroup(
        columns: 3,
        children: [
          for (final size in [20.0, 24.0, 48.0])
            for (final (background, foreground) in [
              (surfaceTransformTheme.colorScheme.accent, surfaceTransformTheme.colorScheme.onAccent),
              (surfaceTransformTheme.palette.neutral[2], surfaceTransformTheme.palette.black),
              (
                surfaceTransformTheme.colorScheme.inverse.background,
                surfaceTransformTheme.colorScheme.inverse.onBackground,
              ),
            ])
              GoldenTestScenario(
                name: '$size / ${background.toARGB32()}',
                child: Padding(
                  padding: const .all(16),
                  child: Row(
                    mainAxisSize: .min,
                    spacing: 12,
                    children: [
                      for (final icon in [
                        MateoIconData.arrowUp,
                        MateoIconData.cross,
                        MateoIconData.paperPlaneUpRight,
                        MateoIconData.gear,
                      ])
                        MateoIcon(icon, size: size, color: foreground, backgroundColor: background),
                    ],
                  ),
                ),
              ),
        ],
      ),
    ),
  );
}
