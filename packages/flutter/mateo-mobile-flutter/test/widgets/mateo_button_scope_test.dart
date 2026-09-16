import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';
import 'package:mateo_mobile_old/src/components/mateo_button/mateo_button.dart' show MateoButton, MateoButtonScope;

import '../test_app.dart';

void main() {
  testWidgets('when the background and presentation change during an action, it should retain the pending lifecycle', (
    tester,
  ) async {
    final pending = Completer<void>();
    var presses = 0;
    MateoButtonState? resolved;
    const buttonKey = ValueKey('base');
    const backgroundKey = ValueKey('background');
    final label = MateoButtonPresentation.label(
      label: 'Save',
      variant: MateoButtonVariant.primary.base,
      elevation: 1,
    );
    final icon = MateoButtonPresentation.icon(
      semanticLabel: 'Save',
      variant: MateoButtonVariant.primary.base,
      elevation: 1,
      hitAreaSize: 70,
      iconBuilder: (state) => Icon(Icons.save, color: state.foregroundColor),
    );

    Future<void> pump(MateoButtonPresentation presentation, Color color) => tester.pumpWidget(
      TestApp(
        child: Center(
          child: MateoButtonScope(
            backgroundBuilder: (state, child) {
              resolved = state;
              return ColoredBox(key: backgroundKey, color: color, child: child);
            },
            child: MateoButton(
              key: buttonKey,
              presentation: presentation,
              onPressed: () {
                presses++;
                return pending.future;
              },
            ),
          ),
        ),
      ),
    );

    await pump(label, Colors.orange);
    final originalState = tester.state(find.byKey(buttonKey));
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await pump(icon, Colors.blue);
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.state(find.byKey(buttonKey)), same(originalState));
    expect(resolved!.isLoading, isTrue);
    expect(resolved!.isInteractive, isFalse);
    expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
    expect(tester.getSize(find.byKey(buttonKey)), const Size(70, 70));
    expect(tester.getSize(find.byKey(backgroundKey)), const Size(53, 53));
    expect(tester.widget<ColoredBox>(find.byKey(backgroundKey)).color, Colors.blue);
    expect(resolved!.elevation, 1);
    await tester.tap(find.byKey(buttonKey));
    expect(presses, 1);

    pending.complete();
    await tester.pumpAndSettle();
    expect(find.byType(MateoCircularLoadingIndicator), findsNothing);
    expect(find.byIcon(Icons.save), findsOneWidget);
    expect(resolved!.isInteractive, isTrue);
    expect(tester.getSize(find.byKey(backgroundKey)), const Size(53, 53));
  });
}
