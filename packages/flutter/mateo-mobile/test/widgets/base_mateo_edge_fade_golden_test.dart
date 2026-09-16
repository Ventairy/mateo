import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/base_mateo_edge_fade.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/mateo_edge_fade_band.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/mateo_edge_fade_profile.dart';

Future<void> main() async {
  await goldenTest(
    'when rendering supplied fade bands, it should preserve profiles overlap and host clipping',
    fileName: 'base_mateo_edge_fade',
    builder: () {
      final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
      // Deliberately simple renderer inputs, not an authored Mateo fade curve.
      final linear = MateoEdgeFadeProfile(stops: const [0, 1], visibility: const [0, 1]);
      final bent = MateoEdgeFadeProfile(stops: const [0, .25, .75, 1], visibility: const [0, .05, .9, 1]);
      final scenarios = <(String, List<MateoEdgeFadeBand>, double, bool)>[
        ('Top', [.top(extent: 65, profile: linear)], 140, false),
        ('Bottom', [.bottom(extent: 65, profile: linear)], 140, false),
        ('Independent profiles', [.top(extent: 60, profile: linear), .bottom(extent: 60, profile: bent)], 140, false),
        ('Overlap', [.top(extent: 120, profile: linear), .bottom(extent: 120, profile: bent)], 140, false),
        ('Oversized', [.top(extent: 100, profile: bent)], 50, false),
        ('Host rounds corners', [.top(extent: 70, profile: bent), .bottom(extent: 70, profile: bent)], 140, true),
        ('Left', [.left(extent: 65, profile: linear)], 140, false),
        ('Right', [.right(extent: 65, profile: bent)], 140, false),
        ('Horizontal overlap', [.left(extent: 120, profile: linear), .right(extent: 120, profile: bent)], 140, false),
        (
          'All edges',
          [
            .top(extent: 60, profile: bent),
            .bottom(extent: 60, profile: bent),
            .left(extent: 60, profile: bent),
            .right(extent: 60, profile: bent),
          ],
          140,
          true,
        ),
        ('Empty', [], 140, false),
        ('Zero extent', [.top(extent: 0, profile: bent)], 140, false),
      ];
      return MateoTheme(
        data: theme,
        child: GoldenTestGroup(
          columns: 4,
          children: [
            for (final mask in [false, true])
              for (final (name, bands, height, rounded) in scenarios)
                GoldenTestScenario(
                  name: '${mask ? 'Mask' : 'Overlay'}: $name',
                  child: Padding(
                    padding: const .all(12),
                    child: SizedBox(
                      width: 160,
                      height: height,
                      child: ClipRRect(
                        borderRadius: .circular(rounded ? 24 : 0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [theme.colorScheme.accent, theme.colorScheme.background]),
                          ),
                          child: Builder(
                            builder: (_) {
                              final content = RepaintBoundary(
                                child: ColoredBox(
                                  color: theme.colorScheme.background,
                                  child: Column(
                                    children: [
                                      for (var index = 0; index < 5; index++)
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ColoredBox(
                                                  color: theme.colorScheme.inverse.background,
                                                  child: const SizedBox.expand(),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  'Content $index',
                                                  style: TextStyle(color: theme.colorScheme.text.primary),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                              return mask
                                  ? BaseMateoEdgeFade.mask(resolveBands: (_) => bands, child: content)
                                  : BaseMateoEdgeFade.overlay(
                                      color: theme.colorScheme.background,
                                      resolveBands: (_) => bands,
                                      child: content,
                                    );
                            },
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
