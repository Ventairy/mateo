import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
  await AlchemistConfig.runWithConfig(
    config: AlchemistConfig.current().copyWith(
      ciGoldensConfig: const CiGoldensConfig(obscureText: false),
      goldenTestTheme: GoldenTestTheme(
        backgroundColor: theme.colorScheme.background,
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
        'when resting, it should show enabled and disabled positions in both directions',
        fileName: 'mateo_toggle_states',
        builder: () => MateoTheme(
          data: theme,
          child: GoldenTestGroup(
            columns: 4,
            children: [
              for (final direction in TextDirection.values)
                for (final enabled in [true, false])
                  for (final value in [false, true])
                    GoldenTestScenario(
                      name: '${direction.name} ${enabled ? 'Enabled' : 'Disabled'} ${value ? 'On' : 'Off'}',
                      child: Padding(
                        padding: const .all(24),
                        child: Directionality(
                          textDirection: direction,
                          child: _Toggle(value: value, enabled: enabled),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
      for (final milliseconds in [60, 131, 260, 400]) {
        await goldenTest(
          'when moving at $milliseconds ms, it should retain its pill and coordinated colors',
          fileName: 'mateo_toggle_motion_$milliseconds',
          pumpBeforeTest: (tester) async {
            await tester.pumpAndSettle();
            for (final state in tester.stateList<_ToggleState>(find.byType(_Toggle))) {
              unawaited(state.controller.toggle());
            }
            await tester.pump();
            await tester.pump(Duration(milliseconds: milliseconds));
          },
          builder: () => MateoTheme(
            data: theme,
            child: GoldenTestGroup(
              columns: 2,
              children: [
                for (final value in [false, true])
                  GoldenTestScenario(
                    name: '${value ? 'Turning off' : 'Turning on'} • $milliseconds ms',
                    child: Padding(
                      padding: const .all(24),
                      child: _Toggle(value: value, enabled: true),
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    },
  );
}

class _Toggle extends StatefulWidget {
  const _Toggle({required this.value, required this.enabled});
  final bool value;
  final bool enabled;
  @override
  State<_Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<_Toggle> {
  late final controller = MateoToggleController(value: widget.value);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MateoToggle(controller: controller, onChanged: widget.enabled ? (_) {} : null);
}
