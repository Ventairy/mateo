import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  group('MateoDragResistance Golden Tests', () {
    goldenTest(
      'when resting around a button, it should match the approved golden',
      fileName: 'mateo_drag_resistance_resting',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'resting button',
            child: const _ResistanceGoldenApp(),
          ),
        ],
      ),
    );

    goldenTest(
      'when dragging a button sideways, it should match the approved resisted golden',
      fileName: 'mateo_drag_resistance_active',
      whilePerforming: (tester) async {
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_ResistanceGoldenApp.buttonKey)),
        );
        await gesture.moveBy(const Offset(120, 0));
        await tester.pump();
        return null;
      },
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'resisted button',
            child: const _ResistanceGoldenApp(),
          ),
        ],
      ),
    );
  });
}

class _ResistanceGoldenApp extends StatelessWidget {
  const _ResistanceGoldenApp();

  static const buttonKey = Key('resistance_golden_button');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 100,
      child: Center(
        child: MateoDragResistance(
          child: MateoButton(
            key: buttonKey,
            variant: MateoButtonVariant.primary,
            label: 'Continuar',
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
