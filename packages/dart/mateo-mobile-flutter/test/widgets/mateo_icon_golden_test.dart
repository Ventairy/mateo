import 'dart:io';
import 'dart:ui' as ui;

import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  await goldenTest(
    'when icons mix open strokes and enclosed bodies, it should preserve their optical balance',
    fileName: 'mateo_icon_optical_balance',
    builder: () => MateoTheme(
      data: surfaceTransformTheme,
      child: GoldenTestGroup(
        columns: 2,
        children: [
          for (final (group, icons) in [
            (
              'Separated silhouettes',
              [
                MateoIconData.discoBall,
                MateoIconData.eraser,
                MateoIconData.parkingSign,
                MateoIconData.runningFigure,
                MateoIconData.prayingFigure,
              ],
            ),
            (
              'Compact narrow bodies',
              [
                MateoIconData.magnifyingGlass,
                MateoIconData.heart,
                MateoIconData.popcorn,
                MateoIconData.parkingSign,
                MateoIconData.paperPlaneUpRight,
                MateoIconData.evPlug,
              ],
            ),
            (
              'Enclosed bodies',
              [
                MateoIconData.magnifyingGlass,
                MateoIconData.heart,
                MateoIconData.monkeyHead,
                MateoIconData.medicalCross,
                MateoIconData.numbers,
              ],
            ),
            (
              'Dates and local cavities',
              [
                MateoIconData.calendar,
                MateoIconData.clock,
                MateoIconData.parkingSign,
                MateoIconData.helicopterFront,
                MateoIconData.hookah,
              ],
            ),
            (
              'Settings',
              [
                MateoIconData.lifebuoy,
                MateoIconData.shieldLock,
                MateoIconData.scroll,
                MateoIconData.logout,
                MateoIconData.trash,
              ],
            ),
            (
              'Spread contours',
              [
                MateoIconData.arrowRotateClockwise,
                MateoIconData.bankBuilding,
                MateoIconData.intellectualProperty,
                MateoIconData.road,
                MateoIconData.sadMaskHappyMask,
                MateoIconData.stadium,
                MateoIconData.threeHorizontalLines,
              ],
            ),
          ])
            for (final size in [20.0, 40.0])
              GoldenTestScenario(
                name: '$group / ${size == 40 ? '40px badges' : '20px glyphs'}',
                child: Padding(
                  padding: const .all(16),
                  child: Row(
                    mainAxisSize: .min,
                    spacing: 12,
                    children: [
                      for (final icon in icons)
                        MateoIcon(
                          icon,
                          size: size,
                          color: size == 40
                              ? surfaceTransformTheme.colorScheme.onAccent
                              : surfaceTransformTheme.colorScheme.text.primary,
                          background: size == 40 ? .colored(color: surfaceTransformTheme.colorScheme.accent) : null,
                        ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    ),
  );

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
                        MateoIcon(
                          icon,
                          size: size,
                          color: foreground,
                          background: .colored(color: background),
                        ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    ),
  );
  final codec = await ui.instantiateImageCodec(File('test/fixtures/icon_background.png').readAsBytesSync());
  final image = (await codec.getNextFrame()).image;
  codec.dispose();
  tearDownAll(image.dispose);
  await goldenTest(
    'when a custom image fills the background, it should clip to a circle and preserve foreground spacing in both directions',
    fileName: 'mateo_icon_custom_background',
    builder: () => MateoTheme(
      data: surfaceTransformTheme,
      child: GoldenTestGroup(
        columns: 3,
        children: [
          for (final direction in TextDirection.values)
            for (final size in [20.0, 24.0, 48.0])
              GoldenTestScenario(
                name: '${direction.name} / $size',
                child: Directionality(
                  textDirection: direction,
                  child: Padding(
                    padding: const .all(16),
                    child: Row(
                      mainAxisSize: .min,
                      spacing: 12,
                      children: [
                        for (final icon in [MateoIconData.instagramLogo, MateoIconData.arrowLeft])
                          MateoIcon(
                            icon,
                            size: size,
                            color: surfaceTransformTheme.palette.white,
                            background: .custom(
                              child: RawImage(image: image, fit: .cover),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    ),
  );
}
