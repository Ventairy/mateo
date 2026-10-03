import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  await AlchemistConfig.runWithConfig(
    config: AlchemistConfig.current().copyWith(ciGoldensConfig: const CiGoldensConfig(obscureText: false)),
    run: () async {
      for (final stage in ['mid_flight', 'open', 'returning', 'closed']) {
        final navigators = <GlobalKey<NavigatorState>>[];
        await goldenTest(
          'when menu buttons are $stage, it should preserve the trigger and panel transition',
          fileName: 'mateo_menu_button_$stage',
          pumpBeforeTest: (tester) async {
            await tester.pumpAndSettle();
            for (final button in tester.widgetList<MateoButton>(find.byType(MateoButton)).toList()) {
              button.onPressed!();
            }
            await tester.pump();
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 100));
            if (stage != 'mid_flight') await tester.pumpAndSettle();
            if (stage == 'closed' || stage == 'returning') {
              for (final navigator in navigators) {
                navigator.currentState!.pop();
              }
              if (stage == 'returning') {
                await tester.pump();
                await tester.pump();
                await tester.pump(const Duration(milliseconds: 40));
              } else {
                await tester.pumpAndSettle();
              }
            }
          },
          builder: () {
            navigators.clear();
            return GoldenTestGroup(
              columns: 2,
              children: [
                for (final icon in [false, true])
                  GoldenTestScenario(
                    name: icon ? 'icon' : 'label',
                    child: SizedBox(
                      width: 360,
                      height: 480,
                      child: MateoApp(
                        navigatorKey: () {
                          final key = GlobalKey<NavigatorState>();
                          navigators.add(key);
                          return key;
                        }(),
                        theme: surfaceTransformTheme,
                        home: ColoredBox(
                          color: surfaceTransformTheme.colorScheme.background,
                          child: Center(
                            child: MateoMenuButton(
                              animation: const .transform(),
                              buttonPresentation: icon
                                  ? const .icon(icon: MateoIcon(.cross), variant: .secondary)
                                  : const .label(label: 'Options', variant: .secondary, width: .fit),
                              menuPresentation: .options(
                                items: const [
                                  MateoMenuOptionsPresentationItem(
                                    principal: Text('View details'),
                                    supporting: Text('More about this item'),
                                  ),
                                  MateoMenuOptionsPresentationItem(
                                    leading: MateoIcon(.paperPlaneUpRight),
                                    principal: Text('Share'),
                                  ),
                                ],
                              ),
                              onItemPressed: (_) {},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      }
    },
  );
}
