import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Future<void> main() async {
  await goldenTest(
    'when capsule proportions change, it should preserve smooth fills, clips, and shadows',
    fileName: 'mateo_rounded_shape_capsules',
    builder: () => MateoTheme(
      data: _theme,
      child: ColoredBox(
        color: _theme.colorScheme.background,
        child: GoldenTestGroup(
          columns: 3,
          children: [
            for (final ratio in [1.0, 1.15, 1.35, 1.6, 2.0, 3.5, 8.0])
              for (final height in [40.0, 48.0, 56.0])
                GoldenTestScenario(
                  name: '$ratio:1 / $height',
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: _theme.colorScheme.accent,
                        shape: const MateoRoundedShapeBorder.capsule(),
                        shadows: MateoElevation(level: 1).toShadowList(palette: _theme.palette),
                      ),
                      child: ClipPath(
                        clipper: const ShapeBorderClipper(shape: MateoRoundedShapeBorder.capsule()),
                        child: SizedBox(
                          width: ratio * height,
                          height: height,
                          child: Align(
                            alignment: .centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              heightFactor: 1,
                              child: ColoredBox(color: _theme.colorScheme.background),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    ),
  );
  await goldenTest(
    'when rounded surfaces change size and radius, it should retain flowing corners and clipped content',
    fileName: 'mateo_rounded_shape_radii',
    builder: () {
      final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
      return MateoTheme(
        data: theme,
        child: ColoredBox(
          color: theme.colorScheme.background,
          child: GoldenTestGroup(
            columns: 2,
            children: [
              for (final (width, height, radius) in [
                (96.0, 96.0, 24.0),
                (96.0, 96.0, 32.0),
                (360.0, 180.0, 24.0),
                (96.0, 96.0, 999.0),
              ])
                GoldenTestScenario(
                  name: '$width × $height / $radius',
                  child: Padding(
                    padding: const .all(24),
                    child: MateoSurface(
                      width: .custom(width),
                      height: .custom(height),
                      elevation: MateoElevation(level: .5),
                      shape: .rounded(radius: radius),
                      child: ColoredBox(color: theme.colorScheme.accent),
                    ),
                  ),
                ),
              GoldenTestScenario(
                name: 'View surface / 42',
                child: Directionality(
                  textDirection: .ltr,
                  child: SizedBox(
                    width: 360,
                    height: 420,
                    child: MateoView(
                      padding: .zero,
                      surface: MateoViewSurface(
                        shape: const .rounded(radius: 42),
                        child: ColoredBox(color: theme.colorScheme.accent),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
