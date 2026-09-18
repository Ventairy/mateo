import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  await goldenTest(
    'country flags retain their artwork across sizes and text directions',
    fileName: 'mateo_country_flag',
    builder: () => MateoTheme(
      data: surfaceTransformTheme,
      child: ColoredBox(
        color: surfaceTransformTheme.palette.white,
        child: GoldenTestGroup(
          columns: 2,
          children: [
            for (final direction in TextDirection.values)
              for (final size in [24.0, 38.0, 52.0])
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
                          for (final country in [
                            Country.unitedStates,
                            Country.brazil,
                            Country.antarctica,
                            Country.bouvetIsland,
                            Country.heardIslandAndMcDonaldIslands,
                          ])
                            MateoCountryFlag(country: country, size: size),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    ),
  );
}
