import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/components/mateo_button/mateo_button_appearance_scope.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _content({required bool sheet, required MateoButtonPresentation presentation}) {
  final button = MateoButton(presentation: presentation, onPressed: () {});
  if (sheet) {
    return MateoSheetView(
      header: MateoSheetViewHeader(principal: const Text('Details'), trailing: button),
      surface: const MateoSheetViewSurface(child: SizedBox(height: 80)),
    );
  }
  return MateoView(
    header: MateoViewHeader(principal: const Text('Details'), trailing: button),
    surface: const MateoViewSurface(child: SizedBox(height: 80)),
  );
}

Widget _host(Widget child) => MateoApp(
  theme: _theme,
  home: SizedBox(width: 360, height: 400, child: child),
);

Finder _buttonSurface() => find.descendant(of: find.byType(MateoButton), matching: find.byType(MateoSurface));

ShapeDecoration _buttonDecoration(WidgetTester tester) =>
    tester
            .widget<DecoratedBox>(
              find.descendant(
                of: _buttonSurface(),
                matching: find.byWidgetPredicate(
                  (widget) => widget is DecoratedBox && widget.decoration is ShapeDecoration,
                ),
              ),
            )
            .decoration
        as ShapeDecoration;

void main() {
  for (final sheet in [false, true]) {
    for (final iconOnly in [false, true]) {
      testWidgets(
        'when a ${sheet ? 'sheet' : 'view'} header contains an omitted ${iconOnly ? 'icon' : 'label'} appearance, it should use the base header defaults',
        (tester) async {
          final presentation = iconOnly
              ? const MateoButtonPresentation.icon(icon: MateoIcon(.cross), semanticLabel: 'Close')
              : const MateoButtonPresentation.label(label: 'Close', width: .fit);
          await tester.pumpWidget(
            _host(
              MateoButtonAppearanceScope(
                variant: .tertiary,
                elevation: 2,
                size: .mini,
                child: _content(sheet: sheet, presentation: presentation),
              ),
            ),
          );
          await tester.pumpAndSettle();

          final colors = MateoButtonVariant.primary.base.resolveColorScheme(_theme.colorScheme.buttons);
          expect(tester.getSize(_buttonSurface()).height, MateoButtonSize.small.height);
          expect(tester.widget<MateoSurface>(_buttonSurface()).color, colors.background);
          expect(tester.widget<MateoPress>(find.byType(MateoPress)).animation, MateoPressAnimationType.scale);
          expect(_buttonDecoration(tester).shadows, MateoElevation(level: 1).toShadowList(palette: _theme.palette));
        },
      );
    }
  }

  testWidgets('when a header button sets its appearance explicitly, it should override the base header defaults', (
    tester,
  ) async {
    const presentation = MateoButtonPresentation.label(
      label: 'Close',
      variant: .tertiary,
      elevation: 2,
      size: .mini,
      width: .fit,
    );
    await tester.pumpWidget(_host(_content(sheet: false, presentation: presentation)));
    await tester.pumpAndSettle();

    final colors = MateoButtonVariant.tertiary.resolveColorScheme(_theme.colorScheme.buttons);
    expect(tester.getSize(_buttonSurface()).height, MateoButtonSize.mini.height);
    expect(tester.widget<MateoSurface>(_buttonSurface()).color, colors.background);
    expect(tester.widget<MateoPress>(find.byType(MateoPress)).animation, MateoPressAnimationType.scaleFade);
    expect(_buttonDecoration(tester).shadows, MateoElevation(level: 2).toShadowList(palette: _theme.palette));
  });
}
