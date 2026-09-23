import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
  await AlchemistConfig.runWithConfig(
    config: AlchemistConfig.current().copyWith(
      ciGoldensConfig: const CiGoldensConfig(obscureText: false, renderShadows: true),
      goldenTestTheme: GoldenTestTheme(
        backgroundColor: theme.palette.white,
        borderColor: theme.palette.neutral[3],
        nameTextStyle: TextStyle(
          fontFamily: MateoTypography.fontFamily,
          fontSize: 12,
          color: theme.colorScheme.text.primary,
        ),
      ),
    ),
    run: () async {
      await goldenTest(
        'when rendering statuses and content variations, it should preserve the toast treatment with Mateo capsules',
        fileName: 'mateo_toast_states',
        builder: () => MateoTheme(
          data: theme,
          child: GoldenTestGroup(
            columns: 2,
            children: [
              for (final status in MateoToastStatus.values)
                GoldenTestScenario(
                  name: status.name,
                  child: SizedBox(
                    width: 390,
                    height: 160,
                    child: MediaQuery(
                      data: const MediaQueryData(disableAnimations: true),
                      child: Center(
                        child: MateoToast(message: 'Changes saved', status: status),
                      ),
                    ),
                  ),
                ),
              for (final scenario in [
                (
                  name: 'Two lines',
                  message: 'Nao foi possivel carregar agora',
                  scale: 1.0,
                  direction: TextDirection.ltr,
                  icon: null,
                ),
                (
                  name: 'Truncated',
                  message: 'Tente novamente em alguns segundos. ' * 8,
                  scale: 1.0,
                  direction: TextDirection.ltr,
                  icon: null,
                ),
                (
                  name: 'Custom icon',
                  message: 'Connection restored',
                  scale: 1.0,
                  direction: TextDirection.ltr,
                  icon: const MateoIcon(.cross),
                ),
                (name: 'Large text', message: 'Changes saved', scale: 2.0, direction: TextDirection.ltr, icon: null),
                (name: 'RTL', message: 'Changes saved', scale: 1.0, direction: TextDirection.rtl, icon: null),
              ])
                GoldenTestScenario(
                  name: scenario.name,
                  child: SizedBox(
                    width: 390,
                    height: 180,
                    child: Directionality(
                      textDirection: scenario.direction,
                      child: MediaQuery(
                        data: MediaQueryData(textScaler: TextScaler.linear(scenario.scale)),
                        child: Center(
                          child: SizedBox(
                            width: 280,
                            child: MateoToast(message: scenario.message, status: .error, icon: scenario.icon),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

      for (final milliseconds in [60, 140, 180, 200]) {
        await goldenTest(
          'when entering at $milliseconds milliseconds, it should fade and slide the complete capsule',
          fileName: 'mateo_toast_enter_$milliseconds',
          pumpBeforeTest: (tester) async {
            await tester.pump();
            await tester.pump(Duration(milliseconds: milliseconds));
            final fade = tester.widget<FadeTransition>(
              find.ancestor(of: find.byType(MateoToast), matching: find.byType(FadeTransition)).first,
            );
            if (milliseconds < 200) {
              expect(fade.opacity.value, inExclusiveRange(0, 1));
            } else {
              expect(fade.opacity.value, 1);
            }
          },
          builder: () {
            var shown = false;
            return GoldenTestGroup(
              children: [
                GoldenTestScenario(
                  name: 'Entrance $milliseconds ms',
                  child: SizedBox(
                    width: 390,
                    height: 180,
                    child: MateoApp(
                      theme: theme,
                      home: Builder(
                        builder: (context) {
                          if (!shown) {
                            shown = true;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!context.mounted) return;
                              showMateoToast(
                                context: context,
                                toast: const MateoToast(message: 'Changes saved', status: .success),
                                duration: const Duration(seconds: 30),
                              );
                            });
                          }
                          return const SizedBox.expand();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }

      for (final phase in ['outgoing', 'incoming']) {
        late BuildContext toastContext;
        await goldenTest(
          'when switching during the $phase phase, it should show only that toast in motion',
          fileName: 'mateo_toast_switch_$phase',
          pumpBeforeTest: (tester) async {
            showMateoToast(
              context: toastContext,
              toast: const MateoToast(message: 'Saving finished', status: .success),
            );
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 280));
            showMateoToast(
              context: toastContext,
              toast: const MateoToast(message: 'Your backup is ready', status: .info),
            );
            await tester.pump();
            if (phase == 'outgoing') {
              await tester.pump(const Duration(milliseconds: 110));
              expect(find.text('Saving finished'), findsOneWidget);
              expect(find.text('Your backup is ready'), findsNothing);
            } else {
              await tester.pump(const Duration(milliseconds: 281));
              await tester.pump();
              await tester.pump(const Duration(milliseconds: 140));
              expect(find.text('Saving finished'), findsNothing);
              expect(find.text('Your backup is ready'), findsOneWidget);
            }
            final fade = tester.widget<FadeTransition>(
              find.ancestor(of: find.byType(MateoToast), matching: find.byType(FadeTransition)).first,
            );
            expect(fade.opacity.value, greaterThan(0));
            expect(fade.opacity.value, lessThan(1));
          },
          builder: () => GoldenTestGroup(
            children: [
              GoldenTestScenario(
                name: 'Switch: $phase',
                child: SizedBox(
                  width: 390,
                  height: 180,
                  child: MateoApp(
                    theme: theme,
                    home: Builder(
                      builder: (context) {
                        toastContext = context;
                        return const SizedBox.expand();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}
