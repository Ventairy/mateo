import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';
import 'package:mateo_mobile_old/src/components/mateo_button/mateo_button.dart' show MateoButton, MateoButtonScope;
import 'package:mateo_mobile_old/src/foundation/mateo_elevation.dart';

import '../test_app.dart';

final _colorScheme = MateoColorScheme.light();

void main() {
  testWidgets('when an icon button is pressed, it should use its variant feedback', (tester) async {
    for (final variant in <MateoButtonVariant>[
      MateoButtonVariant.primary,
      MateoButtonVariant.secondary,
      MateoButtonVariant.tertiary,
    ]) {
      await tester.pumpWidget(
        TestApp(
          child: Center(
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: variant,
                iconBuilder: (_) => const Icon(Icons.add),
              ),
              onPressed: () {},
            ),
          ),
        ),
      );
      final button = find.byType(MateoButton);
      final tap = find.descendant(of: button, matching: find.byType(MateoTap));
      expect(
        tester.widget<MateoTap>(tap).animation,
        variant == MateoButtonVariant.tertiary ? MateoTapAnimationType.scaleFade : MateoTapAnimationType.scale,
      );
      final gesture = await tester.startGesture(tester.getCenter(button));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      final scale = tester.widget<ScaleTransition>(
        find.descendant(of: tap, matching: find.byType(ScaleTransition)).first,
      );
      expect(scale.scale.value, lessThan(1));
      await gesture.up();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('when the semantic label is omitted, it should preserve child icon semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      TestApp(
        child: MateoButton(
          presentation: MateoButtonPresentation.icon(
            variant: MateoButtonVariant.primary,
            iconBuilder: (_) => const Icon(Icons.add, semanticLabel: 'Add'),
          ),
          onPressed: () {},
        ),
      ),
    );
    expect(find.bySemanticsLabel('Add'), findsOneWidget);
    expect(tester.widget<MateoTap>(find.byType(MateoTap)).semanticLabel, isNull);
    semantics.dispose();
  });

  testWidgets('when an icon action fails, it should propagate the error and restore activation', (tester) async {
    final pending = Completer<void>();
    await tester.pumpWidget(
      TestApp(
        child: Center(
          child: MateoButton(
            presentation: MateoButtonPresentation.icon(
              semanticLabel: 'Save',
              variant: MateoButtonVariant.primary,
              iconBuilder: (_) => const Icon(Icons.save),
            ),
            onPressed: () => pending.future,
          ),
        ),
      ),
    );
    final callback = tester.widget<MateoTap>(find.byType(MateoTap)).onPressed!;
    final result = Future<void>.sync(() => callback(Future<void>.value()));
    final error = StateError('Save failed');
    final expectation = expectLater(result, throwsA(same(error)));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(const Duration(milliseconds: 350));
    pending.completeError(error);
    await tester.pumpAndSettle();
    await expectation;
    expect(tester.widget<MateoTap>(find.byType(MateoTap)).onPressed, isNotNull);
    expect(find.byType(MateoCircularLoadingIndicator), findsNothing);
  });

  testWidgets('when disposed during an icon action, completion should not update disposed state', (tester) async {
    final pending = Completer<void>();
    await tester.pumpWidget(
      TestApp(
        child: Center(
          child: MateoButton(
            presentation: MateoButtonPresentation.icon(
              semanticLabel: 'Save',
              variant: MateoButtonVariant.primary,
              iconBuilder: (_) => const Icon(Icons.save),
            ),
            onPressed: () => pending.future,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(MateoButton));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpWidget(const SizedBox.shrink());
    pending.complete();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when icon loading has custom dimensions, its diameter and colors should stay within the surface', (
    tester,
  ) async {
    for (final dimensions in [(55.0, 27.0, 35.0), (30.0, 27.0, 18.0), (8.0, 2.0, 0.0)]) {
      await tester.pumpWidget(
        TestApp(
          child: Center(
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                semanticLabel: 'Save',
                variant: MateoButtonVariant.primary.base,
                elevation: 1,
                buttonSize: dimensions.$1,
                iconSize: dimensions.$2,
                colorScheme: mateoTestColorScheme.buttons.primary.accent.copyWith(foregroundDisabled: Colors.purple),
                iconBuilder: (_) => const Icon(Icons.save),
              ),
              isLoading: true,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      final loader = tester.widget<MateoCircularLoadingIndicator>(find.byType(MateoCircularLoadingIndicator));
      expect(loader.size, dimensions.$3);
      expect(loader.color, Colors.purple);
      expect(loader.trackColor, Colors.purple.withValues(alpha: 0.24));
      expect(_circleSize(tester), Size.square(dimensions.$1));
      final decoration =
          tester
                  .widget<DecoratedBox>(
                    find
                        .descendant(
                          of: find.byType(MateoButton),
                          matching: find.byType(DecoratedBox),
                        )
                        .first,
                  )
                  .decoration
              as BoxDecoration;
      expect(decoration.boxShadow, MateoElevation.toShadows(elevation: 1, palette: mateoTestPalette));
    }
  });

  testWidgets('when an icon action is pending, it should keep its size and semantics while loading', (tester) async {
    final pending = Completer<void>();
    var calls = 0;
    await tester.pumpWidget(
      TestApp(
        child: Center(
          child: MateoButton(
            presentation: MateoButtonPresentation.icon(
              semanticLabel: 'Add',
              variant: MateoButtonVariant.primary,
              iconBuilder: (state) => Icon(Icons.add, semanticLabel: 'Duplicate', color: state.foregroundColor),
            ),
            onPressed: () {
              calls++;
              return pending.future;
            },
          ),
        ),
      ),
    );
    final semantics = tester.ensureSemantics();

    expect(find.bySemanticsLabel('Add'), findsOneWidget);
    expect(find.bySemanticsLabel('Duplicate'), findsNothing);
    await tester.tap(find.byType(MateoButton));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
    expect(_circleSize(tester), const Size(53, 53));
    expect(tester.widget<MateoTap>(find.byType(MateoTap)).onPressed, isNull);
    pending.complete();
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byType(MateoCircularLoadingIndicator), findsNothing);
    semantics.dispose();
  });

  testWidgets('when presentations switch during a pending action, it should preserve loading and the callback', (
    tester,
  ) async {
    final pending = Completer<void>();
    final icon = MateoButtonPresentation.icon(
      semanticLabel: 'Add',
      variant: MateoButtonVariant.primary,
      iconBuilder: (_) => const Icon(Icons.add),
    );
    Future<void> pump(MateoButtonPresentation presentation, {bool loading = false}) => tester.pumpWidget(
      TestApp(
        child: Center(
          child: MateoButton(
            presentation: presentation,
            isLoading: loading,
            onPressed: () => pending.future,
          ),
        ),
      ),
    );
    await pump(icon);
    await tester.tap(find.byType(MateoButton));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(const Duration(milliseconds: 350));
    await pump(const MateoButtonPresentation.label(label: 'Save', variant: MateoButtonVariant.primary));
    expect(find.byType(MateoDotsLoadingIndicator), findsOneWidget);
    await pump(icon, loading: true);
    expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
    pending.complete();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
    await pump(icon);
    await tester.pumpAndSettle();
    expect(find.byType(MateoCircularLoadingIndicator), findsNothing);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('when icon colors change, it should retain elevation and preserve custom backgrounds', (
    tester,
  ) async {
    final presentation = MateoButtonPresentation.icon(
      semanticLabel: 'Float',
      variant: MateoButtonVariant.primary.base,
      elevation: 1,
      iconBuilder: (state) => Icon(Icons.add, color: state.foregroundColor),
    );
    Future<void> pump(Color color, {bool custom = false}) => tester.pumpWidget(
      TestApp(
        theme: mateoTestTheme.copyWith(
          extensions: [
            mateoTestThemeData.copyWith(
              colorScheme: mateoTestColorScheme.copyWith(
                buttons: mateoTestColorScheme.buttons.copyWith(
                  primary: mateoTestColorScheme.buttons.primary.copyWith(
                    base: mateoTestColorScheme.buttons.primary.base.copyWith(background: color, foreground: color),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Center(
          child: custom
              ? MateoButtonScope(
                  backgroundBuilder: (state, child) {
                    expect(state.borderRadius, BorderRadius.circular(26.5));
                    return DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.orange),
                      child: child,
                    );
                  },
                  child: MateoButton(presentation: presentation, onPressed: () {}),
                )
              : MateoButton(
                  presentation: presentation,
                  onPressed: () {},
                ),
        ),
      ),
    );
    for (final color in [Colors.red, Colors.blue]) {
      await pump(color);
      await tester.pumpAndSettle();
      expect(_circleColor(tester), color);
      expect(tester.widget<Icon>(find.byIcon(Icons.add)).color, color);
      final decoration =
          tester
                  .widget<DecoratedBox>(
                    find.descendant(of: find.byType(MateoButton), matching: find.byType(DecoratedBox)).first,
                  )
                  .decoration
              as BoxDecoration;
      expect(decoration.boxShadow, MateoElevation.toShadows(elevation: 1, palette: mateoTestPalette));
    }
    await pump(Colors.blue, custom: true);
    await tester.pumpAndSettle();
    final decoration =
        tester
                .widget<DecoratedBox>(
                  find.descendant(of: find.byType(MateoButton), matching: find.byType(DecoratedBox)).first,
                )
                .decoration
            as BoxDecoration;
    expect(decoration.color, Colors.orange);
    expect(decoration.boxShadow, isNull);
  });

  testWidgets('when reduced motion is enabled, icon loading should replace content immediately', (tester) async {
    await tester.pumpWidget(
      TestApp(
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Center(
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                semanticLabel: 'Add',
                variant: MateoButtonVariant.primary,
                iconBuilder: (_) => const Icon(Icons.add),
              ),
              isLoading: true,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
    expect(_circleSize(tester), const Size(53, 53));
  });

  group('MateoButton icon presentation', () {
    testWidgets('when tapped, it should call onPressed', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        TestApp(
          child: MateoButton(
            presentation: MateoButtonPresentation.icon(
              variant: MateoButtonVariant.primary,
              iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
              semanticLabel: 'Action',
            ),
            onPressed: () => tapCount += 1,
          ),
        ),
      );

      await tester.tap(find.byType(MateoButton));
      await tester.pump(const Duration(milliseconds: 800));

      expect(tapCount, equals(1));
    });

    testWidgets('when disabled, it should expose disabled semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoButton(
            presentation: MateoButtonPresentation.icon(
              variant: MateoButtonVariant.primary,
              iconBuilder: (state) => Icon(Icons.lock, size: state.iconSize),
              semanticLabel: 'Action',
            ),
          ),
        ),
      );

      final semantics = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(MateoButton),
          matching: find.byWidgetPredicate((widget) => widget is Semantics && widget.properties.button == true),
        ),
      );

      expect(semantics.properties.enabled, isFalse);
    });

    testWidgets(
      'when semanticLabel is provided, it should expose the accessibility label',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                semanticLabel: 'Search',
                iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
              ),
              onPressed: () {},
            ),
          ),
        );

        final semantics = tester.widget<Semantics>(
          find.descendant(
            of: find.byType(MateoButton),
            matching: find.byWidgetPredicate((widget) => widget is Semantics && widget.properties.button == true),
          ),
        );

        expect(semantics.properties.label, 'Search');
      },
    );

    testWidgets('when rendered, it should not add visible label text', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoButton(
            presentation: MateoButtonPresentation.icon(
              variant: MateoButtonVariant.primary,
              semanticLabel: 'Search',
              iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
            ),
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
          () => MateoButton(
            presentation: MateoButtonPresentation.icon(
              variant: MateoButtonVariant.primary,
              buttonSize: 0,
              iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
              semanticLabel: 'Action',
            ),
          ),
          throwsAssertionError,
        );
      },
    );

    testWidgets(
      'when iconSize is not positive, it should reject the invalid dimension',
      (tester) async {
        expect(
          () => MateoButton(
            presentation: MateoButtonPresentation.icon(
              variant: MateoButtonVariant.primary,
              iconSize: 0,
              iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
              semanticLabel: 'Action',
            ),
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
          child: MateoButton(
            presentation: MateoButtonPresentation.icon(
              variant: MateoButtonVariant.primary,
              iconBuilder: (state) => Icon(Icons.lock, size: state.iconSize),
              semanticLabel: 'Action',
            ),
          ),
        ),
      );

      expect(
        _circleColor(tester),
        equals(_colorScheme.buttons.primary.accent.backgroundDisabled),
      );
    });

    testWidgets(
      'when disabled background color is customized, it should use the provided color',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                iconBuilder: (state) => Icon(Icons.lock, size: state.iconSize),
                semanticLabel: 'Action',
                colorScheme: mateoTestColorScheme.buttons.primary.accent.copyWith(
                  backgroundDisabled: mateoTestPalette.neutral[5],
                ),
              ),
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
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
                semanticLabel: 'Action',
              ),
              onPressed: () {},
            ),
          ),
        );

        expect(_circleSize(tester), equals(const Size(53, 53)));
      },
    );

    testWidgets(
      'when button size is customized, it should use the provided size',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                buttonSize: 64,
                iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
                semanticLabel: 'Action',
              ),
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
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                iconBuilder: (state) {
                  resolvedIconSize = state.iconSize;
                  return Icon(Icons.search, size: state.iconSize);
                },
                semanticLabel: 'Action',
              ),
              onPressed: () {},
            ),
          ),
        );

        expect(resolvedIconSize, equals(22));
      },
    );

    testWidgets(
      'when icon size is customized, it should pass the size to iconBuilder',
      (tester) async {
        double? resolvedIconSize;

        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                iconSize: 30,
                iconBuilder: (state) {
                  resolvedIconSize = state.iconSize;
                  return Icon(Icons.search, size: state.iconSize);
                },
                semanticLabel: 'Action',
              ),
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
          child: MateoButton(
            presentation: MateoButtonPresentation.icon(
              variant: MateoButtonVariant.primary,
              iconSize: 30,
              iconBuilder: (state) => Container(
                width: 10,
                height: 20,
                color: mateoTestColorScheme.background,
              ),
              semanticLabel: 'Action',
            ),
            onPressed: () {},
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const Key('mateo_button_icon_box'))),
        equals(const Size(30, 30)),
      );
    });

    testWidgets(
      'when icon does not use recommended color, it should keep the icon color unset',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                iconBuilder: (state) => Icon(Icons.search, size: state.iconSize),
                semanticLabel: 'Action',
              ),
              onPressed: () {},
            ),
          ),
        );

        expect(tester.widget<Icon>(find.byIcon(Icons.search)).color, isNull);
      },
    );

    testWidgets(
      'when disabled, it should pass the themed disabled foreground to iconBuilder',
      (tester) async {
        Color? resolvedForegroundColor;

        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                iconBuilder: (state) {
                  resolvedForegroundColor = state.foregroundColor;
                  return Icon(Icons.lock, size: state.iconSize);
                },
                semanticLabel: 'Action',
              ),
            ),
          ),
        );

        expect(
          resolvedForegroundColor,
          equals(
            _colorScheme.buttons.primary.accent.foregroundDisabled,
          ),
        );
      },
    );

    testWidgets(
      'when disabled background is customized, it should pass the themed foreground independently of the custom background to iconBuilder',
      (tester) async {
        Color? resolvedForegroundColor;

        await tester.pumpWidget(
          TestApp(
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                iconBuilder: (state) {
                  resolvedForegroundColor = state.foregroundColor;
                  return Icon(Icons.lock, size: state.iconSize);
                },
                semanticLabel: 'Action',
                colorScheme: mateoTestColorScheme.buttons.primary.accent.copyWith(
                  backgroundDisabled: mateoTestPalette.neutral[5],
                ),
              ),
            ),
          ),
        );

        expect(
          resolvedForegroundColor,
          equals(
            _colorScheme.buttons.primary.accent.foregroundDisabled,
          ),
        );
      },
    );
  });
}

Size _circleSize(WidgetTester tester) => tester.getSize(find.byKey(const Key('mateo_button_container')));

Color? _circleColor(WidgetTester tester) =>
    (tester
                .widget<DecoratedBox>(
                  find.descendant(of: find.byType(MateoButton), matching: find.byType(DecoratedBox)).first,
                )
                .decoration
            as BoxDecoration)
        .color;
