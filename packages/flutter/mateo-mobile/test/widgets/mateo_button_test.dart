import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _host(
  Widget child, {
  double width = 320,
  double textScale = 1,
  bool reducedMotion = false,
  bool tickerEnabled = true,
  TextDirection direction = .ltr,
  MateoThemeData? theme,
}) => Directionality(
  textDirection: direction,
  child: MediaQuery(
    data: MediaQueryData(textScaler: TextScaler.linear(textScale), disableAnimations: reducedMotion),
    child: MateoTheme(
      data: theme ?? _theme,
      child: TickerMode(
        enabled: tickerEnabled,
        child: Center(
          child: SizedBox(
            width: width,
            child: Center(child: child),
          ),
        ),
      ),
    ),
  ),
);

Finder _surface() => find.byWidgetPredicate((widget) => widget is DecoratedBox && widget.decoration is ShapeDecoration);

double _contentOpacity(WidgetTester tester) => tester
    .widgetList<FadeTransition>(find.byType(FadeTransition))
    .singleWhere((widget) => widget.alwaysIncludeSemantics)
    .opacity
    .value;

Future<void> _activate(WidgetTester tester) async {
  final action = tester.widget<MateoPress>(find.byType(MateoPress)).onPressed;
  if (action != null) await action(Future<void>.value());
}

void main() {
  for (final (size, height, iconSize, iconButtonIconSize, fontSize) in [
    (MateoButtonSize.mini, 40.0, 16.0, 22.0, 14.0),
    (MateoButtonSize.small, 48.0, 20.0, 26.0, 15.0),
    (MateoButtonSize.standard, 56.0, 24.0, 30.0, 16.0),
  ]) {
    testWidgets('when $size is chosen, label and icon surfaces should share its height and scoped icons', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          MateoButton(
            presentation: .label(
              label: 'Publish',
              variant: .primary,
              size: size,
              trailingIcon: const MateoIcon(.cross),
            ),
            onPressed: () {},
          ),
        ),
      );
      expect(tester.getSize(_surface()).height, closeTo(height, 0.01));
      expect(tester.getSize(find.byType(MateoIcon)), Size.square(iconSize));
      expect(tester.widget<Text>(find.text('Publish')).style!.fontSize, fontSize);
      expect(tester.getSize(find.byType(MateoPress)).height, size == .mini ? 48 : height);
      await tester.pumpWidget(
        _host(
          MateoButton(
            presentation: .icon(icon: const MateoIcon(.cross), variant: .primary, size: size),
            onPressed: () {},
          ),
        ),
      );
      expect(tester.getSize(_surface()), Size.square(height));
      expect(tester.getSize(find.byType(MateoIcon)), Size.square(iconButtonIconSize));
      expect(tester.getSize(find.byType(MateoPress)), Size.square(size == .mini ? 48 : height));
    });

    testWidgets('when a $size label exceeds its width, it should shrink onto one line without resizing icons', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          MateoButton(
            presentation: .label(
              label: 'Publicar oportunidade para minha comunidade',
              variant: .primary,
              size: size,
              leadingIcon: const MateoIcon(.plusSignal),
              trailingIcon: const MateoIcon(.paperPlaneUpRight),
            ),
            onPressed: () {},
          ),
          width: 200,
          textScale: 2,
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(_surface()).height, height);
      final paragraph = tester.renderObject<RenderParagraph>(find.text('Publicar oportunidade para minha comunidade'));
      expect(paragraph.didExceedMaxLines, isFalse);
      expect(paragraph.maxLines, 1);
      expect(paragraph.softWrap, isFalse);
      final paintedWidth =
          paragraph.localToGlobal(Offset(paragraph.size.width, 0)).dx - paragraph.localToGlobal(Offset.zero).dx;
      expect(paintedWidth, lessThan(paragraph.size.width));
      for (final icon in tester.widgetList<MateoIcon>(find.byType(MateoIcon))) {
        expect(tester.getSize(find.byWidget(icon)), Size.square(iconSize));
      }
      expect(
        tester
            .getRect(_surface())
            .contains(tester.getBottomRight(find.text('Publicar oportunidade para minha comunidade'))),
        isTrue,
      );
    });
  }

  testWidgets('when defaults are used, label and icon buttons should retain null and use the primary treatment', (
    tester,
  ) async {
    for (final (presentation, iconOnly) in <(MateoButtonPresentation, bool)>[
      (const .label(label: 'Save'), false),
      (const .icon(icon: MateoIcon(.cross)), true),
    ]) {
      expect(presentation.variant, isNull);
      await tester.pumpWidget(
        _host(
          MateoButton(presentation: presentation, onPressed: () {}),
        ),
      );
      expect(tester.getSize(_surface()).height, 56);
      if (iconOnly) {
        expect(MateoIconScope.of(tester.element(find.byType(MateoIcon))).color, _theme.colorScheme.onAccent);
      } else {
        expect(tester.getSize(_surface()).width, 320);
        expect(tester.widget<Text>(find.text('Save')).style!.color, _theme.colorScheme.onAccent);
      }
      expect(presentation.size, isNull);
      expect(presentation.elevation, isNull);
      expect(tester.widget<MateoSurface>(find.byType(MateoSurface)).color, _theme.colorScheme.accent);
      final decoration = tester.widget<DecoratedBox>(_surface()).decoration as ShapeDecoration;
      expect(decoration.shadows, isEmpty);
      expect(tester.widget<MateoPress>(find.byType(MateoPress)).animation, MateoPressAnimationType.scale);
    }
  });

  testWidgets('when fill is explicit, the surface should occupy the available width', (tester) async {
    await tester.pumpWidget(
      _host(
        const MateoButton(
          presentation: .label(label: 'Save', variant: .primary, width: .fill),
        ),
      ),
    );
    expect(tester.getSize(_surface()).width, 320);
  });

  for (final size in MateoButtonSize.values) {
    testWidgets('when fitting $size content, icons should contribute to width even in a Row', (tester) async {
      final widths = <double>[];
      for (final iconCount in [0, 1, 2]) {
        final button = MateoButton(
          presentation: .label(
            label: 'Save changes',
            variant: .primary,
            size: size,
            width: .fit,
            leadingIcon: iconCount > 0 ? const MateoIcon(.cross) : null,
            trailingIcon: iconCount > 1 ? const MateoIcon(.cross) : null,
          ),
        );
        await tester.pumpWidget(_host(button));
        final bounds = tester.getSize(_surface());
        widths.add(bounds.width);
        expect(bounds.width, lessThan(320));
        expect(bounds.height, size.height);
        expect(tester.getSize(find.byType(MateoPress)).height, greaterThanOrEqualTo(48));
        await tester.pumpWidget(_host(Row(children: [button])));
        expect(tester.takeException(), isNull);
        expect(tester.getSize(_surface()), bounds);
      }
      expect(widths[1], greaterThan(widths[0]));
      expect(widths[2] - widths[1], closeTo(widths[1] - widths[0], 0.001));
    });
  }

  testWidgets('when fit is constrained, long labels should scale and tight parents should win', (tester) async {
    const button = MateoButton(
      presentation: .label(
        label: 'Publicar oportunidade para minha comunidade',
        variant: .primary,
        width: .fit,
        leadingIcon: MateoIcon(.cross),
        trailingIcon: MateoIcon(.cross),
      ),
    );
    await tester.pumpWidget(_host(button, width: 200, textScale: 2));
    expect(tester.takeException(), isNull);
    expect(tester.getSize(_surface()).width, 200);
    final paragraph = tester.renderObject<RenderParagraph>(find.text('Publicar oportunidade para minha comunidade'));
    final paintedWidth =
        paragraph.localToGlobal(Offset(paragraph.size.width, 0)).dx - paragraph.localToGlobal(Offset.zero).dx;
    expect(paintedWidth, lessThan(paragraph.size.width));
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 300,
          child: MateoButton(
            presentation: .label(label: 'Save', variant: .primary, width: .fit),
          ),
        ),
      ),
    );
    expect(tester.getSize(_surface()).width, 300);
  });

  for (final width in [MateoButtonWidth.fill]) {
    for (final reducedMotion in [false, true]) {
      testWidgets('when $width loading changes with reduced motion $reducedMotion, bounds should stay stable', (
        tester,
      ) async {
        Widget button({required bool loading}) => _host(
          MateoButton(
            presentation: .label(label: 'I', variant: .primary, width: width, size: .mini),
            isLoading: loading,
            onPressed: () {},
          ),
          reducedMotion: reducedMotion,
        );
        await tester.pumpWidget(button(loading: true));
        final surfaceBounds = tester.getRect(_surface());
        final pressBounds = tester.getRect(find.byType(MateoPress));
        for (final loading in [false, true, false]) {
          await tester.pumpWidget(button(loading: loading));
          for (var frame = 0; frame < 3; frame++) {
            await tester.pump(const Duration(milliseconds: 20));
            expect(tester.getRect(_surface()), surfaceBounds);
            expect(tester.getRect(find.byType(MateoPress)), pressBounds);
          }
        }
        await tester.pumpAndSettle();
        expect(tester.getRect(_surface()), surfaceBounds);
        expect(tester.getRect(find.byType(MateoPress)), pressBounds);
      });
    }
  }

  for (final (size, padding, indicatorHeight) in [
    (MateoButtonSize.mini, 16.0, 12.0),
    (MateoButtonSize.small, 20.0, 14.0),
    (MateoButtonSize.standard, 24.0, 16.0),
  ]) {
    testWidgets('when a fitted $size button loads, its width should settle around the dots', (tester) async {
      final semantics = tester.ensureSemantics();
      for (final label in ['I', 'Save changes']) {
        Widget button({required bool loading}) => _host(
          MateoButton(
            presentation: .label(
              label: label,
              variant: .primary,
              size: size,
              width: .fit,
              leadingIcon: label == 'I' ? null : const MateoIcon(.checkmark),
              trailingIcon: label == 'I' ? null : const MateoIcon(.cross),
            ),
            onPressed: () {},
            isLoading: loading,
          ),
        );
        await tester.pumpWidget(button(loading: false));
        final restingSize = tester.getSize(_surface());
        final pressHeight = tester.getSize(find.byType(MateoPress)).height;
        await tester.pumpWidget(button(loading: true));
        expect(tester.getSize(_surface()), restingSize);
        final dotsSize = tester.getSize(find.byType(MateoLoadingIndicator));
        expect(dotsSize.height, indicatorHeight);
        final loadingWidth = dotsSize.width + padding * 2;
        var previousWidth = restingSize.width;
        for (var frame = 0; frame < 80; frame++) {
          await tester.pump(const Duration(milliseconds: 10));
          final surfaceSize = tester.getSize(_surface());
          expect(surfaceSize.height, restingSize.height);
          expect(tester.getSize(find.byType(MateoPress)).height, pressHeight);
          expect(tester.getSize(find.byType(MateoPress)).width, surfaceSize.width);
          if (restingSize.width > loadingWidth) {
            expect(surfaceSize.width, inInclusiveRange(loadingWidth - 0.001, previousWidth));
          } else {
            expect(surfaceSize.width, inInclusiveRange(previousWidth, loadingWidth + 0.001));
          }
          previousWidth = surfaceSize.width;
          if (frame == 23) {
            final remaining = (surfaceSize.width - loadingWidth) / (restingSize.width - loadingWidth);
            expect(remaining, closeTo(0.048, 0.002));
          }
        }
        expect(tester.getSize(_surface()).width, closeTo(loadingWidth, 0.001));
        expect(tester.getSemantics(find.byType(MateoPress)).label, label);
        expect(tester.getSemantics(find.byType(MateoPress)).rect.size, tester.getSize(find.byType(MateoPress)));
        await tester.pumpWidget(button(loading: false));
        expect(tester.widget<MateoPress>(find.byType(MateoPress)).onPressed, isNotNull);
        await tester.pumpAndSettle();
        expect(tester.getSize(_surface()), restingSize);
        expect(tester.binding.transientCallbackCount, 0);
      }
      semantics.dispose();
    });
  }

  testWidgets('when fitted loading reverses, it should preserve position and velocity then settle softly', (
    tester,
  ) async {
    Widget button({required bool loading}) => _host(
      MateoButton(
        presentation: const .label(label: 'Save changes', variant: .primary, width: .fit),
        onPressed: () {},
        isLoading: loading,
      ),
    );
    await tester.pumpWidget(button(loading: false));
    final restingWidth = tester.getSize(_surface()).width;
    await tester.pumpWidget(button(loading: true));
    await tester.pump(const Duration(milliseconds: 59));
    final before = tester.getSize(_surface()).width;
    await tester.pump(const Duration(milliseconds: 1));
    final reversedAt = tester.getSize(_surface()).width;
    await tester.pumpWidget(button(loading: false));
    expect(tester.getSize(_surface()).width, closeTo(reversedAt, 0.000001));
    await tester.pump(const Duration(milliseconds: 1));
    final after = tester.getSize(_surface()).width;
    expect(after - reversedAt, closeTo(reversedAt - before, 0.1));
    expect(after, lessThan(reversedAt));
    for (final loading in [true, false, true, false]) {
      await tester.pump(const Duration(milliseconds: 35));
      final width = tester.getSize(_surface()).width;
      await tester.pumpWidget(button(loading: loading));
      expect(tester.getSize(_surface()).width, closeTo(width, 0.000001));
    }
    await tester.pump(const Duration(milliseconds: 400));
    final nearEnd = tester.getSize(_surface()).width;
    await tester.pump(const Duration(milliseconds: 16));
    expect((tester.getSize(_surface()).width - nearEnd).abs(), lessThan(0.1));
    await tester.pumpAndSettle();
    expect(tester.getSize(_surface()).width, restingWidth);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('when fitted loading starts mounted or motion is disabled, its size should update immediately', (
    tester,
  ) async {
    Widget button({required bool loading, bool reduced = false, bool ticking = true}) => _host(
      MateoButton(
        presentation: const .label(label: 'Save changes', variant: .primary, width: .fit),
        onPressed: () {},
        isLoading: loading,
      ),
      reducedMotion: reduced,
      tickerEnabled: ticking,
    );
    await tester.pumpWidget(button(loading: true));
    final loadingSize = tester.getSize(_surface());
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getSize(_surface()), loadingSize);
    await tester.pumpWidget(button(loading: false, reduced: true));
    final restingSize = tester.getSize(_surface());
    expect(restingSize.width, greaterThan(loadingSize.width));
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpWidget(button(loading: true, reduced: true));
    expect(tester.getSize(_surface()), loadingSize);
    expect(tester.binding.transientCallbackCount, 0);
    for (final ticking in [false, true]) {
      await tester.pumpWidget(button(loading: false));
      await tester.pump(const Duration(milliseconds: 40));
      await tester.pumpWidget(button(loading: false, ticking: ticking, reduced: ticking));
      expect(tester.getSize(_surface()), restingSize);
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pumpWidget(button(loading: true, ticking: ticking, reduced: ticking));
      expect(tester.getSize(_surface()), loadingSize);
      expect(tester.binding.transientCallbackCount, 0);
    }
  });

  testWidgets('when fitted loading is in a Row or constrained, it should retain native sizing and contain content', (
    tester,
  ) async {
    for (final alignment in MateoButtonAlignment.values) {
      for (final tight in [false, true]) {
        Widget button({required bool loading}) => _host(
          Row(
            children: [
              SizedBox(
                width: tight ? 200 : null,
                child: IntrinsicHeight(
                  child: MateoButton(
                    presentation: .label(
                      label: tight ? 'Publicar oportunidade para minha comunidade' : 'Save',
                      variant: .primary,
                      width: .fit,
                      alignment: alignment,
                      leadingIcon: const MateoIcon(.checkmark),
                    ),
                    onPressed: () {},
                    isLoading: loading,
                  ),
                ),
              ),
            ],
          ),
          textScale: 2,
          direction: .rtl,
        );
        await tester.pumpWidget(button(loading: false));
        final width = tester.getSize(_surface()).width;
        await tester.pumpWidget(button(loading: true));
        for (var frame = 0; frame < 20; frame++) {
          await tester.pump(const Duration(milliseconds: 20));
          expect(tester.takeException(), isNull);
          final bounds = tester.getRect(_surface());
          if (tight) expect(bounds.width, width);
          final text = tester.renderObject<RenderBox>(
            find.text(tight ? 'Publicar oportunidade para minha comunidade' : 'Save'),
          );
          final rect = MatrixUtils.transformRect(text.getTransformTo(null), Offset.zero & text.size);
          expect(bounds.inflate(0.01).contains(rect.topLeft), isTrue);
          expect(bounds.inflate(0.01).contains(rect.bottomRight), isTrue);
        }
      }
    }
  });

  testWidgets('when a fitted async action completes, expansion should not delay interactivity', (tester) async {
    final pending = Completer<void>();
    await tester.pumpWidget(
      _host(
        MateoButton(
          presentation: const .label(label: 'Save changes', variant: .primary, width: .fit),
          onPressed: () => pending.future,
        ),
      ),
    );
    final restingWidth = tester.getSize(_surface()).width;
    final action = _activate(tester);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(tester.getSize(_surface()).width, lessThan(restingWidth));
    pending.complete();
    await action;
    await tester.pump();
    expect(tester.widget<MateoPress>(find.byType(MateoPress)).onPressed, isNotNull);
    expect(tester.getSize(_surface()).width, lessThan(restingWidth));
    await tester.pumpAndSettle();
    expect(tester.getSize(_surface()).width, restingWidth);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('when filling a wide parent, content should honor each alignment', (tester) async {
    final lefts = <double>[];
    for (final alignment in MateoButtonAlignment.values) {
      await tester.pumpWidget(
        _host(
          MateoButton(
            presentation: .label(label: 'Save', variant: .primary, alignment: alignment),
            onPressed: () {},
          ),
        ),
      );
      expect(tester.getSize(_surface()).width, 320);
      expect(tester.getSize(_surface()).height, 56);
      lefts.add(tester.getTopLeft(find.text('Save')).dx);
    }
    expect(lefts[0], lessThan(lefts[1]));
    expect(lefts[1], lessThan(lefts[2]));
  });

  testWidgets('when filling an Expanded row or using intrinsic height, it should use native layout', (tester) async {
    await tester.pumpWidget(
      _host(
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: MateoButton(
                  presentation: const .label(label: 'Save', variant: .primary),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(_surface()).height, 56);
    expect(tester.getSize(_surface()).width, 320);
  });

  testWidgets('when reading RTL, leading and trailing icons should follow the reading direction', (tester) async {
    await tester.pumpWidget(
      _host(
        MateoButton(
          presentation: const .label(
            label: 'نشر',
            variant: .primary,
            leadingIcon: MateoIcon(.plusSignal, key: ValueKey('leading')),
            trailingIcon: MateoIcon(.cross, key: ValueKey('trailing')),
          ),
          onPressed: () {},
        ),
        direction: .rtl,
      ),
    );
    expect(
      tester.getCenter(find.byKey(const ValueKey('leading'))).dx,
      greaterThan(tester.getCenter(find.text('نشر')).dx),
    );
    expect(
      tester.getCenter(find.byKey(const ValueKey('trailing'))).dx,
      lessThan(tester.getCenter(find.text('نشر')).dx),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('when tapping the extra mini region, it should activate the same named button', (tester) async {
    final semantics = tester.ensureSemantics();
    var calls = 0;
    await tester.pumpWidget(
      _host(
        MateoButton(
          presentation: .icon(
            icon: const MateoIcon(.cross),
            semanticLabel: 'Close',
            variant: .primary.base,
            size: .mini,
          ),
          onPressed: () => calls++,
        ),
      ),
    );
    final target = tester.getRect(find.byType(MateoPress));
    expect(tester.getSemantics(find.byType(MateoPress)).rect.size, const Size.square(48));
    expect(tester.getSemantics(find.byType(MateoPress)).label, 'Close');
    await tester.tapAt(target.topLeft + const Offset(1, 1));
    await tester.pumpAndSettle();
    expect(calls, 1);
    semantics.dispose();
  });

  testWidgets('when mini targets are adjacent, their extra regions should not overlap', (tester) async {
    final calls = [0, 0];
    await tester.pumpWidget(
      _host(
        Row(
          mainAxisSize: .min,
          children: [
            for (var index = 0; index < 2; index++)
              MateoButton(
                presentation: const .icon(icon: MateoIcon(.cross), variant: .primary, size: .mini),
                onPressed: () => calls[index]++,
              ),
          ],
        ),
      ),
    );
    final first = tester.getRect(find.byType(MateoPress).at(0));
    final second = tester.getRect(find.byType(MateoPress).at(1));
    expect(first.overlaps(second), isFalse);
    await tester.tapAt(Offset(first.right - 1, first.center.dy));
    await tester.pumpAndSettle();
    expect(calls, [1, 0]);
    await tester.tapAt(Offset(second.left + 1, second.center.dy));
    await tester.pumpAndSettle();
    expect(calls, [1, 1]);
  });

  testWidgets('when labels contain icons, the label should supply the only accessible name', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        MateoButton(
          presentation: .label(
            label: 'Save',
            variant: .primary,
            leadingIcon: Semantics(label: 'Decorative', child: const MateoIcon(.cross)),
          ),
          onPressed: () {},
        ),
      ),
    );
    expect(tester.getSemantics(find.byType(MateoPress)).label, 'Save');
    expect(find.bySemanticsLabel('Decorative'), findsNothing);
    semantics.dispose();
  });

  testWidgets('when icon semantics are inherited, loading should retain the action name', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        MateoButton(
          presentation: .icon(
            icon: Semantics(label: 'Close', child: const MateoIcon(.cross)),
            variant: .primary,
          ),
          isLoading: true,
        ),
        reducedMotion: true,
      ),
    );
    expect(find.bySemanticsLabel('Close'), findsOneWidget);
    expect(_contentOpacity(tester), 0);
    expect(tester.widget<MateoPress>(find.byType(MateoPress)).onPressed, isNull);
    semantics.dispose();
  });

  for (final iconOnly in [false, true]) {
    testWidgets(
      'when ${iconOnly ? 'icon' : 'label'} colors are supplied, it should use them across states and themes',
      (tester) async {
        final colors = MateoButtonColorScheme(
          background: _theme.palette.green[9],
          foreground: _theme.palette.neutral[1],
          backgroundDisabled: _theme.palette.green[3],
          foregroundDisabled: _theme.palette.neutral[9],
        );
        for (final enabled in [true, false]) {
          for (final loading in [false, true]) {
            final presentation = iconOnly
                ? MateoButtonPresentation.icon(icon: const MateoIcon(.cross), variant: .primary, colorScheme: colors)
                : MateoButtonPresentation.label(
                    label: 'Save',
                    trailingIcon: const MateoIcon(.cross),
                    variant: .primary,
                    colorScheme: colors,
                  );
            await tester.pumpWidget(
              _host(
                MateoButton(presentation: presentation, onPressed: enabled ? () {} : null, isLoading: loading),
                reducedMotion: true,
                theme: _theme.copyWith(accentColor: _theme.palette.red[9]),
              ),
            );
            final foreground = enabled ? colors.foreground : colors.foregroundDisabled;
            expect(presentation.colorScheme, same(colors));
            expect(
              tester.widget<MateoSurface>(find.byType(MateoSurface)).color,
              enabled ? colors.background : colors.backgroundDisabled,
            );
            expect(MateoIconScope.of(tester.element(find.byType(MateoIcon))).color, foreground);
            if (!iconOnly) expect(tester.widget<Text>(find.text('Save')).style!.color, foreground);
            if (loading) {
              final loader = find.descendant(
                of: find.byType(MateoLoadingIndicator),
                matching: find.byType(CustomPaint),
              );
              final dynamic painter = tester.widget<CustomPaint>(loader).painter;
              // Inspect the private painter without exposing it as public API.
              // ignore: avoid_dynamic_calls
              expect(painter.color, foreground);
            }
          }
        }
        await tester.pumpWidget(
          _host(
            MateoButton(
              presentation: iconOnly
                  ? const .icon(icon: MateoIcon(.cross), variant: .primary)
                  : const .label(label: 'Save', variant: .primary),
              onPressed: () {},
            ),
          ),
        );
        expect(
          tester.widget<MateoSurface>(find.byType(MateoSurface)).color,
          _theme.colorScheme.accent,
        );
      },
    );
  }

  testWidgets('when theme and enabled state change, const icons should inherit the matching foreground', (
    tester,
  ) async {
    const presentation = MateoButtonPresentation.label(
      label: 'Save',
      variant: .primary,
      trailingIcon: MateoIcon(.cross),
    );
    for (final (theme, enabled) in [
      (_theme, true),
      (MateoThemeData.light(accentColor: const Color(0xFF008060), onAccent: MateoPalette().white), true),
      (_theme, false),
    ]) {
      await tester.pumpWidget(
        _host(
          MateoButton(presentation: presentation, onPressed: enabled ? () {} : null),
          theme: theme,
        ),
      );
      final scope = MateoIconScope.of(tester.element(find.byType(MateoIcon)));
      expect(scope.color, enabled ? theme.colorScheme.onAccent : theme.palette.neutral[9]);
      expect(tester.widget<Text>(find.text('Save')).style!.color, scope.color);
      expect(
        tester.widget<MateoSurface>(find.byType(MateoSurface)).color,
        enabled ? theme.colorScheme.accent : theme.palette.neutral[4],
      );
    }
  });

  testWidgets('when an icon explicitly overrides the scope, it should retain its supplied dimensions', (tester) async {
    await tester.pumpWidget(
      _host(
        MateoButton(
          presentation: .icon(
            icon: MateoIcon(.cross, size: 18, color: _theme.palette.black),
            variant: .primary,
          ),
          onPressed: () {},
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoIcon)), const Size.square(18));
  });

  for (final variant in [
    MateoButtonVariant.primary,
    MateoButtonVariant.primary.neutral,
    MateoButtonVariant.primary.base,
    MateoButtonVariant.secondary,
    MateoButtonVariant.secondary.neutral,
    MateoButtonVariant.tertiary,
  ]) {
    testWidgets('when $variant is selected, it should preserve sizing and use its theme color roles', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          MateoButton(
            presentation: .label(label: 'Save', variant: variant, size: .small, elevation: 1),
            onPressed: () {},
          ),
        ),
      );
      expect(tester.getSize(_surface()).height, 48);
      final decoration = tester.widget<DecoratedBox>(_surface()).decoration as ShapeDecoration;
      expect(decoration.shadows, MateoElevation(level: 1).toShadowList(palette: _theme.palette));
      final colors = variant.resolveColorScheme(_theme.colorScheme.buttons);
      expect(tester.widget<MateoSurface>(find.byType(MateoSurface)).color, colors.background);
      expect(tester.widget<Text>(find.text('Save')).style!.color, colors.foreground);
      final background = Color.alphaBlend(
        tester.widget<MateoSurface>(find.byType(MateoSurface)).color!,
        _theme.colorScheme.background,
      ).computeLuminance();
      final foreground = tester.widget<Text>(find.text('Save')).style!.color!.computeLuminance();
      final ratio = foreground > background
          ? (foreground + 0.05) / (background + 0.05)
          : (background + 0.05) / (foreground + 0.05);
      // Secondary accent uses the product's step-9 seed, which does not
      // guarantee 4.5:1 contrast against its tinted background.
      if (variant != MateoButtonVariant.secondary) {
        expect(ratio, greaterThanOrEqualTo(4.5));
      }
      expect(
        tester.widget<MateoPress>(find.byType(MateoPress)).animation,
        variant is MateoTertiaryButtonVariant ? MateoPressAnimationType.scaleFade : MateoPressAnimationType.scale,
      );
    });
  }

  testWidgets('when an action is synchronous, it should not show loading', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      _host(
        MateoButton(
          presentation: const .label(label: 'Save', variant: .primary),
          onPressed: () => calls++,
        ),
      ),
    );
    await _activate(tester);
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(_contentOpacity(tester), 1);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('when a future finishes before the delay, it should block duplicate activation without flashing', (
    tester,
  ) async {
    final pending = Completer<void>();
    var calls = 0;
    await tester.pumpWidget(
      _host(
        MateoButton(
          presentation: const .label(label: 'Save', variant: .primary),
          onPressed: () {
            calls++;
            return pending.future;
          },
        ),
      ),
    );
    final originalAction = tester.widget<MateoPress>(find.byType(MateoPress)).onPressed!;
    final action = _activate(tester);
    await originalAction(Future<void>.value());
    await tester.pump(const Duration(milliseconds: 30));
    expect(calls, 1);
    expect(_contentOpacity(tester), 1);
    expect(tester.widget<MateoPress>(find.byType(MateoPress)).onPressed, isNull);
    pending.complete();
    await action;
    await tester.pumpAndSettle();
    expect(_contentOpacity(tester), 1);
  });

  testWidgets('when an action loads and returns, its bounds and accessible name should stay stable', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final pending = Completer<void>();
    await tester.pumpWidget(
      _host(
        MateoButton(
          presentation: const .label(label: 'I', variant: .primary, size: .mini),
          onPressed: () => pending.future,
        ),
      ),
    );
    final bounds = tester.getRect(_surface());
    final action = _activate(tester);
    await tester.pump(const Duration(milliseconds: 50));
    for (var frame = 0; frame < 12; frame++) {
      await tester.pump(const Duration(milliseconds: 20));
      expect(tester.getRect(_surface()), bounds);
    }
    expect(_contentOpacity(tester), 0);
    expect(tester.getSemantics(find.byType(MateoPress)).label, 'I');
    pending.complete();
    await action;
    for (var frame = 0; frame < 12; frame++) {
      await tester.pump(const Duration(milliseconds: 20));
      expect(tester.getRect(_surface()), bounds);
    }
    expect(_contentOpacity(tester), 1);
    expect(tester.binding.transientCallbackCount, 0);
    semantics.dispose();
  });

  testWidgets('when the loading indicator is larger than the icon, it should retain its own dimensions', (
    tester,
  ) async {
    Widget button({required bool loading}) => _host(
      MateoButton(
        presentation: const .icon(icon: MateoIcon(.cross, size: 12), variant: .primary),
        onPressed: () {},
        isLoading: loading,
      ),
      reducedMotion: true,
    );
    await tester.pumpWidget(button(loading: false));
    final bounds = tester.getRect(find.byType(MateoPress));
    expect(tester.getSize(find.byType(MateoIcon)), const Size.square(12));
    await tester.pumpWidget(button(loading: true));
    final paint = find.descendant(of: find.byType(MateoLoadingIndicator), matching: find.byType(CustomPaint));
    final box = tester.renderObject<RenderBox>(paint);
    final origin = box.localToGlobal(Offset.zero);
    final edge = box.localToGlobal(Offset(box.size.width, box.size.height));
    expect(edge.dx - origin.dx, 24);
    expect(edge.dy - origin.dy, 24);
    expect(tester.getCenter(paint), bounds.center);
    expect(tester.getRect(find.byType(MateoPress)), bounds);
    expect(tester.getSize(find.byType(MateoIcon)), const Size.square(12));
    await tester.pumpWidget(button(loading: false));
    expect(tester.getRect(find.byType(MateoPress)), bounds);
  });

  testWidgets('when icon loading reverses, it should scale and fade continuously without changing its target', (
    tester,
  ) async {
    Widget button({required bool loading, bool reduced = false}) => _host(
      MateoButton(
        presentation: const .icon(icon: MateoIcon(.cross), variant: .primary, semanticLabel: 'Close'),
        onPressed: () {},
        isLoading: loading,
      ),
      reducedMotion: reduced,
    );
    Finder iconScale() => find.ancestor(of: find.byType(MateoIconScope), matching: find.byType(ScaleTransition)).first;
    Finder activityScale() =>
        find.ancestor(of: find.byType(MateoLoadingIndicator), matching: find.byType(ScaleTransition)).first;
    await tester.pumpWidget(button(loading: false));
    final bounds = tester.getRect(find.byType(MateoPress));
    expect(tester.widget<ScaleTransition>(iconScale()).scale.value, 1);
    await tester.pumpWidget(button(loading: true));
    await tester.pump(const Duration(milliseconds: 60));
    final scale = tester.widget<ScaleTransition>(iconScale()).scale.value;
    expect(scale, inExclusiveRange(0.8, 1));
    expect(tester.widget<ScaleTransition>(activityScale()).scale.value, inExclusiveRange(0.8, 1));
    expect(_contentOpacity(tester), inExclusiveRange(0, 1));
    expect(tester.getRect(find.byType(MateoPress)), bounds);
    await tester.pumpWidget(button(loading: false));
    expect(tester.widget<ScaleTransition>(iconScale()).scale.value, scale);
    await tester.pumpAndSettle();
    expect(tester.widget<ScaleTransition>(iconScale()).scale.value, 1);
    expect(find.byType(MateoLoadingIndicator), findsNothing);
    await tester.pumpWidget(button(loading: true, reduced: true));
    expect(tester.widget<ScaleTransition>(activityScale()).scale.value, 1);
    expect(tester.widget<ScaleTransition>(iconScale()).scale.value, 1);
    expect(_contentOpacity(tester), 0);
    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.getRect(find.byType(MateoPress)), bounds);
  });

  testWidgets('when label loading reverses, it should scale and fade continuously without changing its target', (
    tester,
  ) async {
    Widget button({required bool loading, bool reduced = false}) => _host(
      MateoButton(
        presentation: const .label(label: 'Save changes', leadingIcon: MateoIcon(.cross), variant: .primary),
        onPressed: () {},
        isLoading: loading,
      ),
      reducedMotion: reduced,
    );
    Finder iconScale() => find.ancestor(of: find.byType(MateoIconScope), matching: find.byType(ScaleTransition)).first;
    Finder activityScale() =>
        find.ancestor(of: find.byType(MateoLoadingIndicator), matching: find.byType(ScaleTransition)).first;
    await tester.pumpWidget(button(loading: false));
    final bounds = tester.getRect(find.byType(MateoPress));
    expect(tester.widget<ScaleTransition>(iconScale()).scale.value, 1);
    await tester.pumpWidget(button(loading: true));
    await tester.pump(const Duration(milliseconds: 60));
    final scale = tester.widget<ScaleTransition>(iconScale()).scale.value;
    expect(scale, inExclusiveRange(0.8, 1));
    expect(tester.widget<ScaleTransition>(activityScale()).scale.value, inExclusiveRange(0.8, 1));
    expect(_contentOpacity(tester), inExclusiveRange(0, 1));
    expect(tester.getRect(find.byType(MateoPress)), bounds);
    await tester.pumpWidget(button(loading: false));
    expect(tester.widget<ScaleTransition>(iconScale()).scale.value, scale);
    await tester.pumpAndSettle();
    expect(tester.widget<ScaleTransition>(iconScale()).scale.value, 1);
    expect(find.byType(MateoLoadingIndicator), findsNothing);
    await tester.pumpWidget(button(loading: true, reduced: true));
    expect(tester.widget<ScaleTransition>(activityScale()).scale.value, 1);
    expect(tester.widget<ScaleTransition>(iconScale()).scale.value, 1);
    expect(_contentOpacity(tester), 0);
    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.getRect(find.byType(MateoPress)), bounds);
  });

  testWidgets('when manual and async loading overlap, neither should clear the other', (tester) async {
    final pending = Completer<void>();
    Widget button({required bool loading}) => _host(
      MateoButton(
        presentation: const .label(label: 'Save', variant: .primary),
        onPressed: () => pending.future,
        isLoading: loading,
      ),
      reducedMotion: true,
    );
    await tester.pumpWidget(button(loading: false));
    final action = _activate(tester);
    await tester.pumpWidget(button(loading: true));
    expect(_contentOpacity(tester), 0);
    await tester.pumpWidget(button(loading: false));
    expect(_contentOpacity(tester), 0);
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pumpWidget(button(loading: false));
    expect(_contentOpacity(tester), 0);
    await tester.pumpWidget(button(loading: true));
    pending.complete();
    await action;
    await tester.pump();
    expect(_contentOpacity(tester), 0);
    await tester.pumpWidget(button(loading: false));
    expect(_contentOpacity(tester), 1);
  });

  testWidgets('when manual loading reverses mid-fade, the transition should continue from its current appearance', (
    tester,
  ) async {
    Widget button({required bool loading}) => _host(
      MateoButton(
        presentation: const .label(label: 'Save', variant: .primary),
        onPressed: () {},
        isLoading: loading,
      ),
    );
    await tester.pumpWidget(button(loading: false));
    await tester.pumpWidget(button(loading: true));
    await tester.pump(const Duration(milliseconds: 60));
    final during = _contentOpacity(tester);
    expect(during, inExclusiveRange(0, 1));
    await tester.pumpWidget(button(loading: false));
    expect(_contentOpacity(tester), during);
    await tester.pumpAndSettle();
    expect(_contentOpacity(tester), 1);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('when a future fails, the error should propagate and the button should become usable again', (
    tester,
  ) async {
    final pending = Completer<void>();
    await tester.pumpWidget(
      _host(
        MateoButton(
          presentation: const .label(label: 'Save', variant: .primary),
          onPressed: () => pending.future,
        ),
      ),
    );
    final action = _activate(tester);
    final expectation = expectLater(action, throwsStateError);
    await tester.pump(const Duration(milliseconds: 80));
    pending.completeError(StateError('Save failed'));
    await expectation;
    await tester.pumpAndSettle();
    expect(_contentOpacity(tester), 1);
    expect(tester.widget<MateoPress>(find.byType(MateoPress)).onPressed, isNotNull);
  });

  testWidgets('when disposed during pending work, completion should not update disposed state', (tester) async {
    final pending = Completer<void>();
    await tester.pumpWidget(
      _host(
        MateoButton(
          presentation: const .label(label: 'Save', variant: .primary),
          onPressed: () => pending.future,
        ),
      ),
    );
    final action = _activate(tester);
    await tester.pump(const Duration(milliseconds: 80));
    await tester.pumpWidget(const SizedBox());
    pending.complete();
    await action;
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('when motion is reduced or tickers are disabled, loading should stay visible without scheduling frames', (
    tester,
  ) async {
    const button = MateoButton(
      presentation: .icon(icon: MateoIcon(.cross), variant: .primary),
      isLoading: true,
    );
    for (final reduced in [true, false]) {
      await tester.pumpWidget(_host(button, reducedMotion: reduced, tickerEnabled: reduced));
      await tester.pump();
      expect(_contentOpacity(tester), 0);
      expect(tester.binding.transientCallbackCount, 0);
    }
  });

  testWidgets('when the app becomes inactive, the activity ticker should pause until resumed', (tester) async {
    await tester.pumpWidget(
      _host(
        const MateoButton(
          presentation: .icon(icon: MateoIcon(.cross), variant: .primary),
          isLoading: true,
        ),
      ),
    );
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    tester.binding.handleAppLifecycleStateChanged(.inactive);
    await tester.pump();
    expect(tester.binding.transientCallbackCount, 0);
    tester.binding.handleAppLifecycleStateChanged(.resumed);
    await tester.pump();
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    await tester.pumpWidget(const SizedBox());
  });
}
