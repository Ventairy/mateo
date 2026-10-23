import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/components/mateo_text/mateo_text.dart' show MateoTextScope;

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _header({
  required bool sheet,
  required Widget leading,
  required Widget principal,
  required Widget trailing,
}) {
  if (sheet) {
    return MateoSheetView(
      header: MateoSheetViewHeader(
        presentation: .custom(leading: leading, principal: principal, trailing: trailing),
      ),
      surface: const MateoSheetViewSurface(child: SizedBox(height: 80)),
    );
  }
  return MateoView(
    header: MateoViewHeader(leading: leading, principal: principal, trailing: trailing),
    surface: const MateoViewSurface(child: SizedBox(height: 80)),
  );
}

Widget _host(Widget child) => MateoApp(
  theme: _theme,
  home: MateoTextScope(
    fontSize: 31,
    fontWeight: .w300,
    height: 1.5,
    child: SizedBox(width: 360, height: 400, child: child),
  ),
);

Widget _probe(String slot) => MateoText(slot, key: ValueKey(slot), presentation: const .interface());

void main() {
  for (final sheet in [false, true]) {
    testWidgets('when both sides exist, ${sheet ? 'sheet' : 'view'} principal text defaults to centered', (
      tester,
    ) async {
      for (final direction in TextDirection.values) {
        for (final alignment in <TextAlign?>[null, .start]) {
          await tester.pumpWidget(
            _host(
              Directionality(
                textDirection: direction,
                child: _header(
                  sheet: sheet,
                  leading: const MateoText('Back', presentation: .interface()),
                  principal: MateoText(
                    'Title',
                    presentation: .interface(
                      textAlign: alignment,
                    ),
                  ),
                  trailing: const MateoText('Longer action', presentation: .interface()),
                ),
              ),
            ),
          );
          final principal = tester.widget<RichText>(
            find.descendant(
              of: find.text('Title'),
              matching: find.byType(RichText),
            ),
          );
          expect(principal.textAlign, alignment ?? TextAlign.center);
          final leading = tester.widget<RichText>(
            find.descendant(
              of: find.text('Back'),
              matching: find.byType(RichText),
            ),
          );
          expect(leading.textAlign, TextAlign.start);
        }
      }
    });

    testWidgets('when a ${sheet ? 'sheet' : 'view'} header contains text, every slot should inherit the title style', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          _header(
            sheet: sheet,
            leading: _probe('leading'),
            principal: _probe('principal'),
            trailing: _probe('trailing'),
          ),
        ),
      );

      for (final slot in ['leading', 'principal', 'trailing']) {
        final style = tester
            .widget<RichText>(find.descendant(of: find.byKey(ValueKey(slot)), matching: find.byType(RichText)))
            .text
            .style!;
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.fontFamily, MateoTypography.interfaceFontFamily);
        expect(style.letterSpacing, -0.32);
        expect(style.color, _theme.colorScheme.text.primary);
        expect(style.height, 1.5);
      }
    });

    testWidgets('when ${sheet ? 'sheet' : 'view'} header text supplies a style, it should override the defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          _header(
            sheet: sheet,
            leading: const SizedBox.shrink(),
            principal: const MateoText(
              'principal',
              key: ValueKey('explicit-text'),
              presentation: .interface(fontSize: 23, fontWeight: .w400, color: Color(0xFF123456), height: 1.5),
            ),
            trailing: const SizedBox.shrink(),
          ),
        ),
      );

      final text = tester.widget<RichText>(
        find.descendant(of: find.byKey(const ValueKey('explicit-text')), matching: find.byType(RichText)),
      );
      expect(text.text.style?.fontSize, 23);
      expect(text.text.style?.fontWeight, FontWeight.w400);
      expect(text.text.style?.color, const Color(0xFF123456));
      expect(text.text.style?.fontFamily, MateoTypography.interfaceFontFamily);
      expect(text.text.style?.letterSpacing, -0.46);
      expect(text.text.style?.height, 1.5);
    });
  }
}
