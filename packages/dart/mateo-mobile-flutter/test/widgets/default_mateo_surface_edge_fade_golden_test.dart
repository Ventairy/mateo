import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/default_mateo_surface_edge_fade/default_mateo_surface_edge_fade.dart';

Future<void> main() async {
  await goldenTest(
    'when default surface fades vary in size and selected edges, it should preserve proportional balanced transitions',
    fileName: 'default_mateo_surface_edge_fade',
    builder: () {
      final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
      final scenarios = <(String, double, Set<MateoEdgeEffectSide>, bool)>[
        ('Tiny', 8, {.top, .bottom}, false),
        ('Compact', 80, {.top, .bottom}, false),
        ('Top', 240, {.top}, false),
        ('Bottom', 240, {.bottom}, false),
        ('Both', 240, {.top, .bottom}, false),
        ('Rounded host', 240, {.top, .bottom}, true),
        ('Tall', 400, {.top, .bottom}, false),
        ('No sides', 240, {}, false),
      ];
      return MateoTheme(
        data: theme,
        child: GoldenTestGroup(
          columns: 4,
          children: [
            for (final mask in [false, true])
              for (final (name, height, sides, rounded) in scenarios)
                GoldenTestScenario(
                  name: '${mask ? 'Mask' : 'Overlay'}: $name',
                  child: Padding(
                    padding: const .all(12),
                    child: SizedBox(
                      width: 180,
                      height: height,
                      child: ClipRRect(
                        borderRadius: .circular(rounded ? 24 : 0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [theme.colorScheme.accent, theme.colorScheme.background]),
                          ),
                          child: DefaultMateoSurfaceEdgeFade(
                            surfaceColor: mask
                                ? theme.colorScheme.background.withValues(alpha: 0)
                                : theme.colorScheme.background,
                            sides: sides,
                            child: RepaintBoundary(
                              child: ColoredBox(
                                color: theme.colorScheme.background,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 28,
                                      child: ColoredBox(
                                        color: theme.colorScheme.inverse.background,
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          for (var index = 0; index < 10; index++)
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment: .centerLeft,
                                                      child: Text(
                                                        'Content $index',
                                                        style: TextStyle(
                                                          color: theme.colorScheme.text.primary,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height < 10 ? .1 : 1,
                                                    child: ColoredBox(
                                                      color: theme.colorScheme.inverse.background,
                                                      child: const SizedBox.expand(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      );
    },
  );
}
