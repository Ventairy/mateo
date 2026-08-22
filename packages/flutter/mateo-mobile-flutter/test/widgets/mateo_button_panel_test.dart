import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoButtonPanel', () {
    test('when buttons is empty, it should assert', () {
      expect(() => MateoButtonPanel(buttons: const []), throwsAssertionError);
    });

    testWidgets(
      'when buttons are provided, it should preserve their order and grow vertically',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButtonPanel(
              buttons: const [
                MateoButton(
                  label: 'First',
                  variant: MateoButtonVariant.primary,
                ),
                MateoButton(
                  label: 'Second',
                  variant: MateoButtonVariant.secondary,
                ),
              ],
            ),
          ),
        );

        final buttons = tester
            .widgetList<MateoButton>(
              find.descendant(
                of: find.byType(MateoButtonPanel),
                matching: find.byType(MateoButton),
              ),
            )
            .toList();
        final firstRect = tester.getRect(find.text('First'));
        final secondRect = tester.getRect(find.text('Second'));

        expect(buttons.map((button) => button.label), ['First', 'Second']);
        expect(firstRect.top, lessThan(secondRect.top));
      },
    );

    testWidgets(
      'when buttons have different widths, it should preserve their fit and center them with exact spacing',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButtonPanel(
              buttons: const [
                MateoButton(
                  label: 'A much wider action',
                  variant: MateoButtonVariant.primary,
                ),
                MateoButton(
                  label: 'Short',
                  variant: MateoButtonVariant.secondary,
                ),
              ],
            ),
          ),
        );

        final panelRect = tester.getRect(find.byType(MateoButtonPanel));
        final buttonRects = find
            .descendant(
              of: find.byType(MateoButtonPanel),
              matching: find.byType(MateoButton),
            )
            .evaluate()
            .map(
              (element) => tester.getRect(
                find.byElementPredicate((value) => value == element),
              ),
            )
            .toList();
        final firstRect = buttonRects[0];
        final secondRect = buttonRects[1];

        expect(firstRect.width, greaterThan(secondRect.width));
        expect(firstRect.center.dx, closeTo(secondRect.center.dx, 0.001));
        expect(firstRect.left - panelRect.left, equals(8));
        expect(panelRect.right - firstRect.right, equals(8));
        expect(firstRect.top - panelRect.top, equals(8));
        expect(secondRect.top - firstRect.bottom, equals(8));
        expect(panelRect.bottom - secondRect.bottom, equals(8));
      },
    );

    testWidgets(
      'when rendered, it should use the approved surface decoration',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButtonPanel(
              buttons: const [
                MateoButton(
                  label: 'Continue',
                  variant: MateoButtonVariant.primary,
                ),
              ],
            ),
          ),
        );

        final decoratedBox = tester.widget<DecoratedBox>(
          find
              .descendant(
                of: find.byType(MateoButtonPanel),
                matching: find.byType(DecoratedBox),
              )
              .first,
        );
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border! as Border;
        final shadow = decoration.boxShadow!.single;

        expect(
          decoration.color,
          equals(mateoTestColorScheme.buttonPanel.background),
        );
        expect(
          decoration.borderRadius,
          equals(const BorderRadius.all(Radius.circular(36))),
        );
        expect(
          border.top.color,
          equals(mateoTestColorScheme.buttonPanel.border),
        );
        expect(border.top.width, equals(1));
        expect(shadow.color, equals(mateoTestColorScheme.buttonPanel.shadow));
        expect(shadow.blurRadius, equals(41));
        expect(shadow.spreadRadius, equals(0));
        expect(shadow.offset, equals(Offset.zero));
      },
    );

    testWidgets(
      'when the theme overrides button panel colors, it should use every override',
      (tester) async {
        const customColors = MateoButtonPanelColorScheme(
          background: Color(0xFFF0E8FF),
          border: Color(0xFF6D4AFF),
          shadow: Color(0x661D0A3D),
        );
        final customTheme = mateoTestTheme.copyWith(
          extensions: [
            MateoThemeData(
              colorScheme: mateoTestColorScheme.copyWith(
                buttonPanel: customColors,
              ),
              palette: mateoTestPalette,
            ),
          ],
        );

        await tester.pumpWidget(
          TestApp(
            theme: customTheme,
            child: MateoButtonPanel(
              buttons: const [
                MateoButton(
                  label: 'Continue',
                  variant: MateoButtonVariant.primary,
                ),
              ],
            ),
          ),
        );

        final decoratedBox = tester.widget<DecoratedBox>(
          find
              .descendant(
                of: find.byType(MateoButtonPanel),
                matching: find.byType(DecoratedBox),
              )
              .first,
        );
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border! as Border;

        expect(decoration.color, customColors.background);
        expect(border.top.color, customColors.border);
        expect(decoration.boxShadow!.single.color, customColors.shadow);
      },
    );
  });
}
