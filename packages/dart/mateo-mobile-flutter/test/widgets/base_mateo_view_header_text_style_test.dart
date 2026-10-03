import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

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
  home: DefaultTextStyle.merge(
    style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w300, height: 1.5),
    child: SizedBox(width: 360, height: 400, child: child),
  ),
);

Widget _probe(String slot, Map<String, TextStyle> styles) => Builder(
  builder: (context) {
    styles[slot] = DefaultTextStyle.of(context).style;
    return Text(slot);
  },
);

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
                  leading: const Text('Back'),
                  principal: Text('Title', textAlign: alignment),
                  trailing: const Text('Longer action'),
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
      final styles = <String, TextStyle>{};
      await tester.pumpWidget(
        _host(
          _header(
            sheet: sheet,
            leading: _probe('leading', styles),
            principal: _probe('principal', styles),
            trailing: _probe('trailing', styles),
          ),
        ),
      );

      expect(styles.keys, containsAll(['leading', 'principal', 'trailing']));
      for (final style in styles.values) {
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.fontFamily, MateoTypography.fontFamily);
        expect(style.letterSpacing, MateoTypography.letterSpacing);
        expect(style.color, _theme.colorScheme.text.primary);
        expect(style.height, 1.5);
      }
    });

    testWidgets('when ${sheet ? 'sheet' : 'view'} header text supplies a style, it should override the defaults', (
      tester,
    ) async {
      const explicitStyle = TextStyle(fontSize: 23, fontWeight: FontWeight.w400, color: Color(0xFF123456));
      await tester.pumpWidget(
        _host(
          _header(
            sheet: sheet,
            leading: const SizedBox.shrink(),
            principal: const Text('principal', key: ValueKey('explicit-text'), style: explicitStyle),
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
      expect(text.text.style?.fontFamily, MateoTypography.fontFamily);
      expect(text.text.style?.letterSpacing, MateoTypography.letterSpacing);
      expect(text.text.style?.height, 1.5);
    });
  }
}
