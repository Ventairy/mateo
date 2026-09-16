import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

final _colorScheme = MateoColorScheme.light();

void main() {
  testWidgets('when a consumer colors an icon, it should retain the shared foreground for text and loading', (
    tester,
  ) async {
    final presentation = MateoButtonPresentation.label(
      label: 'Search',
      variant: MateoButtonVariant.tertiary.neutral,
      leadingIconBuilder: (state) {
        expect(state.foregroundColor, mateoTestColorScheme.buttons.tertiary.neutral.foreground);
        return const Icon(Icons.search, color: Colors.orange);
      },
    );
    Future<void> pump(bool loading) => tester.pumpWidget(
      TestApp(
        child: Center(
          child: MateoButton(
            presentation: presentation,
            isLoading: loading,
            onPressed: () {},
          ),
        ),
      ),
    );
    await pump(false);
    expect(
      tester.widget<Text>(find.text('Search')).style!.color,
      mateoTestColorScheme.buttons.tertiary.neutral.foreground,
    );
    expect(tester.widget<Icon>(find.byIcon(Icons.search)).color, Colors.orange);
    await pump(true);
    await tester.pump(const Duration(milliseconds: 350));
    expect(
      tester.widget<MateoDotsLoadingIndicator>(find.byType(MateoDotsLoadingIndicator)).color,
      mateoTestColorScheme.buttons.tertiary.neutral.foreground,
    );
  });

  testWidgets('when replacing a presentation with another variant, it should resolve component defaults again', (
    tester,
  ) async {
    MateoButtonPresentation presentation(MateoButtonVariant variant, {EdgeInsetsGeometry? padding}) =>
        MateoButtonPresentation.label(
          label: 'Action',
          variant: variant,
          padding: padding,
          leadingIconBuilder: (_) => const Icon(Icons.add, key: Key('leading')),
          trailingIconBuilder: (_) => const Icon(Icons.close, key: Key('trailing')),
        );
    Future<void> pump(MateoButtonPresentation value) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoButton(presentation: value, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
    }

    EdgeInsetsGeometry padding() => tester.widget<Padding>(find.byKey(const Key('mateo_button_container'))).padding;
    double trailingGap() =>
        tester.getTopLeft(find.byKey(const Key('trailing'))).dx - tester.getTopRight(find.text('Action')).dx;
    await pump(presentation(MateoButtonVariant.primary));
    expect(padding(), const EdgeInsets.symmetric(horizontal: 24, vertical: 20));
    expect(tester.widget<Text>(find.text('Action')).style!.fontSize, 15);
    expect(trailingGap(), 10);
    await pump(presentation(MateoButtonVariant.tertiary));
    expect(padding(), EdgeInsets.zero);
    expect(tester.widget<Text>(find.text('Action')).style!.fontSize, 16);
    expect(trailingGap(), 10);
    await pump(
      presentation(
        MateoButtonVariant.tertiary,
        padding: const EdgeInsets.all(12),
      ),
    );
    expect(padding(), const EdgeInsets.all(12));
    expect(trailingGap(), 10);
  });

  testWidgets('when a tertiary action awaits a future, it should show loading and prevent duplicate presses', (
    tester,
  ) async {
    final pending = Completer<void>();
    var presses = 0;
    await tester.pumpWidget(
      TestApp(
        child: MateoButton(
          presentation: const MateoButtonPresentation.label(label: 'Action', variant: MateoButtonVariant.tertiary),
          onPressed: () {
            presses++;
            return pending.future;
          },
        ),
      ),
    );
    await tester.tap(find.text('Action'));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byType(MateoDotsLoadingIndicator), findsOneWidget);
    await tester.tap(find.byType(MateoButton));
    expect(presses, 1);
    pending.complete();
    await tester.pumpAndSettle();
    expect(find.byType(MateoDotsLoadingIndicator), findsNothing);
    expect(find.text('Action'), findsOneWidget);
  });

  group('MateoButton tertiary', () {
    testWidgets('when tapped, it should call onPressed', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        TestApp(
          child: MateoButton(
            presentation: MateoButtonPresentation.label(
              variant: MateoButtonVariant.tertiary,
              label: 'Ver oportunidades',
            ),
            onPressed: () => tapCount += 1,
          ),
        ),
      );

      await tester.tap(find.text('Ver oportunidades'));
      await tester.pump(const Duration(milliseconds: 800));

      expect(tapCount, equals(1));
    });

    testWidgets(
      'when enabled, it should wrap in MateoTap with scaleFade animation',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Ver oportunidades',
              ),
              onPressed: () {},
            ),
          ),
        );

        final animation = tester.widget<MateoTap>(
          find.descendant(
            of: find.byType(MateoButton),
            matching: find.byType(MateoTap),
          ),
        );

        expect(animation.onPressed, isNotNull);
        expect(animation.animation, equals(MateoTapAnimationType.scaleFade));
      },
    );

    testWidgets('when disabled, it should expose disabled semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: MateoButton(
            presentation: MateoButtonPresentation.label(
              variant: MateoButtonVariant.tertiary,
              label: 'Indisponivel',
            ),
          ),
        ),
      );

      final semantics = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(MateoButton),
          matching: find.byType(Semantics),
        ),
      );

      expect(semantics.properties.enabled, isFalse);
    });

    testWidgets(
      'when a leading icon is supplied, it should use the shared 10px gap',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Buscar',
                leadingIconBuilder: (state) => const Icon(Icons.search),
              ),
              onPressed: () {},
            ),
          ),
        );

        final padding = tester.widget<Padding>(
          find.descendant(of: find.byType(Row), matching: find.byType(Padding)),
        );

        expect(padding.padding, equals(const EdgeInsets.only(right: 10)));
      },
    );

    testWidgets(
      'when enabled, it should pass the recommended icon color to leadingIconBuilder',
      (tester) async {
        Color? recommendedIconColor;

        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Buscar',
                colorScheme: mateoTestColorScheme.buttons.tertiary.neutral.copyWith(
                  foreground: mateoTestColorScheme.buttons.primary.accent.background,
                ),
                leadingIconBuilder: (state) {
                  recommendedIconColor = state.foregroundColor;
                  return const Icon(Icons.search);
                },
              ),
              onPressed: () {},
            ),
          ),
        );

        expect(
          recommendedIconColor,
          equals(mateoTestColorScheme.buttons.primary.accent.background),
        );
      },
    );

    testWidgets(
      'when disabled, it should pass disabled state to leadingIconBuilder',
      (tester) async {
        bool? isEnabled;

        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Indisponivel',
                leadingIconBuilder: (state) {
                  isEnabled = state.isEnabled;
                  return const Icon(Icons.lock);
                },
              ),
            ),
          ),
        );

        expect(isEnabled, isFalse);
      },
    );

    testWidgets(
      'when disabled, it should pass the disabled color to leadingIconBuilder',
      (tester) async {
        Color? recommendedIconColor;

        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Indisponivel',
                leadingIconBuilder: (state) {
                  recommendedIconColor = state.foregroundColor;
                  return const Icon(Icons.lock);
                },
              ),
            ),
          ),
        );

        expect(
          recommendedIconColor,
          equals(_colorScheme.buttons.tertiary.neutral.foregroundDisabled),
        );
      },
    );

    testWidgets(
      'when a trailing icon is supplied, it should use the shared 10px gap',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Continuar',
                trailingIconBuilder: (state) => const Icon(Icons.arrow_forward),
              ),
              onPressed: () {},
            ),
          ),
        );

        final padding = tester.widget<Padding>(
          find.descendant(of: find.byType(Row), matching: find.byType(Padding)),
        );

        expect(padding.padding, equals(const EdgeInsets.only(left: 10)));
      },
    );

    testWidgets(
      'when both icons are provided, it should render three children in the row',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Distância',
                leadingIconBuilder: (state) => const Icon(Icons.near_me),
                trailingIconBuilder: (state) => const Icon(Icons.info_outline),
              ),
              onPressed: () {},
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.children.length, equals(3));
      },
    );

    testWidgets(
      'when both icons are provided, it should render the leading icon',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Distância',
                leadingIconBuilder: (state) => const Icon(Icons.near_me),
                trailingIconBuilder: (state) => const Icon(Icons.info_outline),
              ),
              onPressed: () {},
            ),
          ),
        );

        expect(find.byIcon(Icons.near_me), findsOneWidget);
      },
    );

    testWidgets(
      'when both icons are provided, it should render the trailing icon',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Distância',
                leadingIconBuilder: (state) => const Icon(Icons.near_me),
                trailingIconBuilder: (state) => const Icon(Icons.info_outline),
              ),
              onPressed: () {},
            ),
          ),
        );

        expect(find.byIcon(Icons.info_outline), findsOneWidget);
      },
    );
  });
}
