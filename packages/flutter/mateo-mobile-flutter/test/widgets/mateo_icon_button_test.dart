import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

final _colorScheme = MateoColorScheme.light();

void main() {
  group('MateoIconButton', () {
    testWidgets('when tapped, it should call onPressed', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        TestApp(
          child: MateoIconButton(
            iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
            onPressed: () => tapCount += 1,
          ),
        ),
      );

      await tester.tap(find.byType(MateoIconButton));
      await tester.pump(const Duration(milliseconds: 800));

      expect(tapCount, equals(1));
    });

    testWidgets('when disabled, it should expose disabled semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoIconButton(
            iconBuilder: (state) => Icon(Icons.lock, size: state.iconSize),
          ),
        ),
      );

      final semantics = tester.widget<Semantics>(
        find.byKey(const Key('mateo_icon_button_semantics')),
      );

      expect(semantics.properties.enabled, isFalse);
    });

    testWidgets(
      'when semanticLabel is provided, it should expose the accessibility label',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoIconButton(
              semanticLabel: 'Search',
              iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
              onPressed: () {},
            ),
          ),
        );

        expect(
          tester
              .widget<Semantics>(
                find.byKey(const Key('mateo_icon_button_semantics')),
              )
              .properties
              .label,
          'Search',
        );
      },
    );

    testWidgets('when rendered, it should not add visible label text', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoIconButton(
            semanticLabel: 'Search',
            iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Buscar'), findsNothing);
    });

    testWidgets(
      'when buttonSize is not positive, it should reject the invalid dimension',
      (tester) async {
        expect(
          () => MateoIconButton(
            buttonSize: 0,
            iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
          ),
          throwsAssertionError,
        );
      },
    );

    testWidgets(
      'when iconSize is not positive, it should reject the invalid dimension',
      (tester) async {
        expect(
          () => MateoIconButton(
            iconSize: 0,
            iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
          ),
          throwsAssertionError,
        );
      },
    );

    testWidgets('when disabled, it should use the disabled background color', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoIconButton(
            iconBuilder: (state) => Icon(Icons.lock, size: state.iconSize),
          ),
        ),
      );

      expect(
        _circleColor(tester),
        equals(_colorScheme.buttons.accent.primary.backgroundDisabled),
      );
    });

    testWidgets(
      'when disabled background color is customized, it should use the provided color',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoIconButton(
              disabledBackgroundColor: mateoTestPalette.neutral[5],
              iconBuilder: (state) => Icon(Icons.lock, size: state.iconSize),
            ),
          ),
        );

        expect(_circleColor(tester), equals(mateoTestPalette.neutral[5]));
      },
    );

    testWidgets(
      'when button size is not customized, it should use the default size',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoIconButton(
              iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
              onPressed: () {},
            ),
          ),
        );

        expect(_circleSize(tester), equals(const Size(55, 55)));
      },
    );

    testWidgets(
      'when button size is customized, it should use the provided size',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoIconButton(
              buttonSize: 64,
              iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
              onPressed: () {},
            ),
          ),
        );

        expect(_circleSize(tester), equals(const Size(64, 64)));
      },
    );

    testWidgets(
      'when icon size is not customized, it should pass the default size to iconBuilder',
      (tester) async {
        double? resolvedIconSize;

        await tester.pumpWidget(
          TestApp(
            child: MateoIconButton(
              iconBuilder: (state) {
                resolvedIconSize = state.iconSize;
                return Icon(Icons.search, size: state.iconSize);
              },
              onPressed: () {},
            ),
          ),
        );

        expect(resolvedIconSize, equals(27));
      },
    );

    testWidgets(
      'when icon size is customized, it should pass the size to iconBuilder',
      (tester) async {
        double? resolvedIconSize;

        await tester.pumpWidget(
          TestApp(
            child: MateoIconButton(
              iconSize: 30,
              iconBuilder: (state) {
                resolvedIconSize = state.iconSize;
                return Icon(Icons.search, size: state.iconSize);
              },
              onPressed: () {},
            ),
          ),
        );

        expect(resolvedIconSize, equals(30));
      },
    );

    testWidgets('when icon size is customized, it should size the icon slot', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoIconButton(
            iconSize: 30,
            iconBuilder: (state) => Container(
              width: 10,
              height: 20,
              color: mateoTestColorScheme.background,
            ),
            onPressed: () {},
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const Key('mateo_icon_button_icon_box'))),
        equals(const Size(30, 30)),
      );
    });

    testWidgets(
      'when icon does not use recommended color, it should keep the icon color unset',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoIconButton(
              iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
              onPressed: () {},
            ),
          ),
        );

        expect(tester.widget<Icon>(find.byIcon(Icons.search)).color, isNull);
      },
    );

    testWidgets(
      'when disabled, it should pass a darker disabled background color to iconBuilder',
      (tester) async {
        Color? resolvedForegroundColor;

        await tester.pumpWidget(
          TestApp(
            child: MateoIconButton(
              iconBuilder: (state) {
                resolvedForegroundColor = state.recommendedIconColor;
                return Icon(Icons.lock, size: state.iconSize);
              },
            ),
          ),
        );

        expect(
          resolvedForegroundColor,
          equals(
            Color.lerp(
              _colorScheme.buttons.accent.primary.backgroundDisabled,
              mateoTestTheme.colorScheme.shadow,
              0.28,
            ),
          ),
        );
      },
    );

    testWidgets(
      'when disabled background is customized, it should pass a darker custom color to iconBuilder',
      (tester) async {
        Color? resolvedForegroundColor;

        await tester.pumpWidget(
          TestApp(
            child: MateoIconButton(
              disabledBackgroundColor: mateoTestPalette.neutral[5],
              iconBuilder: (state) {
                resolvedForegroundColor = state.recommendedIconColor;
                return Icon(Icons.lock, size: state.iconSize);
              },
            ),
          ),
        );

        expect(
          resolvedForegroundColor,
          equals(
            Color.lerp(
              mateoTestPalette.neutral[5],
              mateoTestTheme.colorScheme.shadow,
              0.28,
            ),
          ),
        );
      },
    );
  });
}

Size _circleSize(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.byKey(const Key('mateo_icon_button_circle')),
  );
  return Size(
    container.constraints!.maxWidth,
    container.constraints!.maxHeight,
  );
}

Color? _circleColor(WidgetTester tester) {
  return (tester
              .widget<Container>(
                find.byKey(const Key('mateo_icon_button_circle')),
              )
              .decoration!
          as BoxDecoration)
      .color;
}
