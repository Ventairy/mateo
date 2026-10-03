import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/components/mateo_button/mateo_button_appearance_scope.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _host(Widget child) => Directionality(
  textDirection: .ltr,
  child: MateoTheme(
    data: _theme,
    child: Center(
      child: SizedBox(width: 320, child: Center(child: child)),
    ),
  ),
);

Finder _surface() => find.byWidgetPredicate((widget) => widget is DecoratedBox && widget.decoration is ShapeDecoration);

void main() {
  testWidgets('when no scope exists, every appearance property should remain unresolved', (tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          final appearance = MateoButtonAppearanceScope.of(context);
          expect(appearance.variant, isNull);
          expect(appearance.elevation, isNull);
          expect(appearance.size, isNull);
          return const SizedBox();
        },
      ),
    );
  });

  testWidgets('when scopes nest and update, omitted properties should inherit independently', (tester) async {
    final elevation = ValueNotifier<double>(1);
    addTearDown(elevation.dispose);
    var builds = 0;
    late ({MateoButtonVariant? variant, double? elevation, MateoButtonSize? size}) appearance;
    final reader = Builder(
      builder: (context) {
        builds++;
        appearance = MateoButtonAppearanceScope.of(context);
        return const SizedBox();
      },
    );

    await tester.pumpWidget(
      MateoButtonAppearanceScope(
        variant: .secondary,
        size: .small,
        child: ValueListenableBuilder<double>(
          valueListenable: elevation,
          child: reader,
          builder: (context, value, child) => MateoButtonAppearanceScope(elevation: value, child: child!),
        ),
      ),
    );
    expect(appearance.variant, MateoButtonVariant.secondary);
    expect(appearance.elevation, 1);
    expect(appearance.size, MateoButtonSize.small);
    expect(builds, 1);

    elevation.value = 2;
    await tester.pump();
    expect(appearance.variant, MateoButtonVariant.secondary);
    expect(appearance.elevation, 2);
    expect(appearance.size, MateoButtonSize.small);
    expect(builds, 2);
  });

  for (final iconOnly in [false, true]) {
    testWidgets('when ${iconOnly ? 'icon' : 'label'} appearance is omitted, it should resolve from the scope', (
      tester,
    ) async {
      final colors = MateoButtonVariant.secondary.resolveColorScheme(_theme.colorScheme.buttons);
      final presentation = iconOnly
          ? const MateoButtonPresentation.icon(icon: MateoIcon(.cross))
          : const MateoButtonPresentation.label(label: 'Save');
      await tester.pumpWidget(
        _host(
          MateoButtonAppearanceScope(
            variant: .secondary,
            elevation: 1,
            size: .mini,
            child: MateoButton(presentation: presentation, onPressed: () {}),
          ),
        ),
      );

      expect(tester.getSize(_surface()).height, MateoButtonSize.mini.height);
      expect(tester.widget<MateoSurface>(find.byType(MateoSurface)).color, colors.background);
      expect(tester.widget<MateoPress>(find.byType(MateoPress)).animation, MateoPressAnimationType.scale);
      final decoration = tester.widget<DecoratedBox>(_surface()).decoration as ShapeDecoration;
      expect(decoration.shadows, MateoElevation(level: 1).toShadowList(palette: _theme.palette));
    });

    testWidgets('when ${iconOnly ? 'icon' : 'label'} appearance is explicit, it should override the scope', (
      tester,
    ) async {
      final colors = MateoButtonVariant.primary.resolveColorScheme(_theme.colorScheme.buttons);
      final presentation = iconOnly
          ? const MateoButtonPresentation.icon(
              icon: MateoIcon(.cross),
              variant: .primary,
              elevation: 1,
              size: .small,
            )
          : const MateoButtonPresentation.label(
              label: 'Save',
              variant: .primary,
              elevation: 1,
              size: .small,
            );
      await tester.pumpWidget(
        _host(
          MateoButtonAppearanceScope(
            variant: .tertiary,
            elevation: 2,
            size: .mini,
            child: MateoButton(presentation: presentation, onPressed: () {}),
          ),
        ),
      );

      expect(tester.getSize(_surface()).height, MateoButtonSize.small.height);
      expect(tester.widget<MateoSurface>(find.byType(MateoSurface)).color, colors.background);
      expect(tester.widget<MateoPress>(find.byType(MateoPress)).animation, MateoPressAnimationType.scale);
      final decoration = tester.widget<DecoratedBox>(_surface()).decoration as ShapeDecoration;
      expect(decoration.shadows, MateoElevation(level: 1).toShadowList(palette: _theme.palette));
    });
  }
}
