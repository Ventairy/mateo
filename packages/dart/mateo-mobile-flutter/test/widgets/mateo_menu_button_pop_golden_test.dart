import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  await AlchemistConfig.runWithConfig(
    config: AlchemistConfig.current().copyWith(ciGoldensConfig: const CiGoldensConfig(obscureText: false)),
    run: () async {
      for (final stage in ['mid_flight', 'open', 'exiting', 'closed']) {
        final navigators = <GlobalKey<NavigatorState>>[];
        await goldenTest(
          'when menu buttons are $stage, it should preserve the trigger and panel transition',
          fileName: 'mateo_menu_button_pop_$stage',
          pumpBeforeTest: (tester) async {
            await tester.pumpAndSettle();
            for (final button in tester.widgetList<MateoButton>(find.byType(MateoButton)).toList()) {
              button.onPressed!();
            }
            await tester.pump();
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 100));
            if (stage != 'mid_flight') await tester.pumpAndSettle();
            if (stage == 'closed' || stage == 'exiting') {
              for (final navigator in navigators) {
                navigator.currentState!.pop();
              }
              if (stage == 'exiting') {
                await tester.pump();
                await tester.pump(const Duration(milliseconds: 60));
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
                    name: icon ? 'header action' : 'list action',
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
                          child: Builder(
                            builder: (context) {
                              final button = MateoMenuButton(
                                animation: const .pop(),
                                buttonPresentation: icon
                                    ? .icon(
                                        icon: Row(
                                          mainAxisSize: .min,
                                          children: [
                                            for (var dot = 0; dot < 3; dot++)
                                              Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: Container(
                                                  width: 4,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    color: DefaultTextStyle.of(context).style.color,
                                                    shape: .circle,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        variant: .secondary,
                                      )
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
                              );
                              return MateoView(
                                header: icon
                                    ? MateoViewHeader(principal: const Text('Details'), trailing: button)
                                    : null,
                                surface: MateoViewSurface(
                                  child: icon
                                      ? const SizedBox.expand()
                                      : Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Row(
                                            children: [
                                              const Expanded(child: Text('Saved item')),
                                              button,
                                            ],
                                          ),
                                        ),
                                ),
                              );
                            },
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
