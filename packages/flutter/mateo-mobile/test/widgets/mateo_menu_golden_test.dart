import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  await goldenTest(
    'options menus preserve density and content hierarchy',
    fileName: 'mateo_menu',
    builder: () => MateoTheme(
      data: surfaceTransformTheme,
      child: GoldenTestGroup(
        columns: 2,
        children: [
          for (final density in MateoMenuDensity.values)
            for (final disabled in [false, true])
              GoldenTestScenario(
                name: '${density.name} ${disabled ? 'disabled' : 'enabled'}',
                child: SizedBox(
                  width: 260,
                  child: MateoMenu(
                    presentation: .options(
                      density: density,
                      items: [
                        const MateoMenuOptionsPresentationItem(leading: MateoIcon(.cross), principal: Text('Close')),
                        const MateoMenuOptionsPresentationItem(
                          principal: Text('View details'),
                          supporting: Text('More about this item'),
                        ),
                        MateoMenuOptionsPresentationItem(
                          leading: MateoIcon(
                            .paperPlaneUpRight,
                            backgroundColor: surfaceTransformTheme.colorScheme.background,
                            color: surfaceTransformTheme.colorScheme.menus.options.background,
                          ),
                          principal: const Text('Share with someone'),
                        ),
                      ],
                    ),
                    onItemPressed: disabled ? null : (_) {},
                  ),
                ),
              ),
        ],
      ),
    ),
  );
}
