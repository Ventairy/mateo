import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/base_mateo_edge_fade.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _host(Widget child, {double textScale = 1, TextDirection direction = .ltr}) => MateoApp(
  theme: _theme,
  home: Directionality(
    textDirection: direction,
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: Center(
        child: RepaintBoundary(
          key: const ValueKey('inputCapture'),
          child: SizedBox(width: 320, child: child),
        ),
      ),
    ),
  ),
);

void main() {
  for (final variant in [MateoTextInputVariant.filled.neutral, MateoTextInputVariant.filled.base]) {
    for (final enabled in [false, true]) {
      testWidgets('when $variant is elevated and enabled=$enabled, it should use theme colors and shared shadows', (
        tester,
      ) async {
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              autofocus: false,
              placeholder: 'Search',
              presentation: .search(variant: variant, elevation: 0.75),
              onChanged: enabled ? (_) {} : null,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final surfaceFinder = find.descendant(of: find.byType(MateoTextInput), matching: find.byType(MateoSurface));
        final surface = tester.widget<MateoSurface>(surfaceFinder);
        final colors = variant.resolveColorScheme(_theme.colorScheme.textInputs);
        final background = enabled ? colors.background : colors.backgroundDisabled;
        expect(surface.color, background);
        expect(surface.elevation, MateoElevation(level: 0.75));
        final fade = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
        expect(fade.color, background);
        final decoration = tester
            .widgetList<DecoratedBox>(find.descendant(of: surfaceFinder, matching: find.byType(DecoratedBox)))
            .map((widget) => widget.decoration)
            .whereType<ShapeDecoration>()
            .first;
        expect(decoration.shadows, MateoElevation(level: 0.75).toShadowList(palette: _theme.palette));
        expect(tester.takeException(), isNull);
      });
    }
  }
  for (final elevation in [-1.0, 2.1, double.nan, double.infinity]) {
    testWidgets('when input elevation is $elevation, it should reject the invalid level', (tester) async {
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            autofocus: false,
            placeholder: 'Search',
            presentation: .search(variant: .filled, elevation: elevation),
            onChanged: (_) {},
          ),
        ),
      );
      expect(tester.takeException(), isArgumentError);
    });
  }

  for (final direction in TextDirection.values) {
    testWidgets('when ${direction.name} text is pulled past either edge, it should bounce back without editing', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'Coffee shops and bakeries nearby with outdoor seating');
      final changes = <String>[];
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            autofocus: false,
            placeholder: 'Search',
            controller: controller,
            presentation: const .search(variant: .filled),
            onChanged: changes.add,
          ),
          direction: direction,
        ),
      );
      await tester.pumpAndSettle();
      final scroll = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).scrollController!;
      for (final end in [false, true]) {
        final boundary = end ? scroll.position.maxScrollExtent : scroll.position.minScrollExtent;
        scroll.jumpTo(boundary);
        await tester.pump();
        final gesture = await tester.startGesture(tester.getCenter(find.byType(EditableText)));
        await gesture.moveBy(Offset(end ? -80 : 80, 0));
        await tester.pump(const Duration(milliseconds: 100));
        await gesture.moveBy(Offset(end ? -20 : 20, 0));
        await tester.pump(const Duration(milliseconds: 100));
        expect(scroll.offset, end ? greaterThan(boundary) : lessThan(boundary));
        await gesture.up();
        await tester.pumpAndSettle();
        expect(scroll.offset, closeTo(boundary, 0.1));
      }
      expect(controller.text, 'Coffee shops and bakeries nearby with outdoor seating');
      expect(changes, isEmpty);
      expect(tester.takeException(), isNull);
    }, variant: const TargetPlatformVariant({TargetPlatform.iOS, TargetPlatform.android}));
  }

  for (final externalFocus in [false, true]) {
    testWidgets('when mounted with ${externalFocus ? 'external' : 'owned'} focus, it should autofocus by default', (
      tester,
    ) async {
      final focus = externalFocus ? FocusNode() : null;
      addTearDown(() => focus?.dispose());
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            placeholder: 'Search',
            presentation: const .search(variant: .filled),
            focusNode: focus,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isTrue);
    });
  }
  for (final enabled in [false, true]) {
    testWidgets(
      'when ${enabled ? 'autofocus is false' : 'disabled with autofocus'}, it should remain unfocused on mount',
      (tester) async {
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              placeholder: 'Search',
              presentation: const .search(variant: .filled),
              autofocus: !enabled,
              onChanged: enabled ? (_) {} : null,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isFalse);
      },
    );
  }

  for (final direction in TextDirection.values) {
    for (final size in MateoTextInputSize.values) {
      testWidgets('when $size $direction text does not overflow, fades should stop at the actual text insets', (
        tester,
      ) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              autofocus: false,
              placeholder: 'Search',
              controller: controller,
              presentation: .search(variant: .filled, size: size),
              onChanged: (_) {},
            ),
            direction: direction,
          ),
        );
        for (final text in ['', 'Short']) {
          controller.text = text;
          await tester.pumpAndSettle();
          final fadeFinder = find.byType(BaseMateoEdgeFade);
          final fade = tester.widget<BaseMateoEdgeFade>(fadeFinder);
          final field = tester.getRect(fadeFinder);
          final viewport = tester.getRect(find.byType(EditableText));
          final bands = fade.resolveBands(field.size);
          expect(
            bands.singleWhere((band) => band.edge == AxisDirection.left).extent,
            closeTo(viewport.left - field.left, 0.01),
          );
          expect(
            bands.singleWhere((band) => band.edge == AxisDirection.right).extent,
            closeTo(field.right - viewport.right, 0.01),
          );
        }
      });
    }
  }

  for (final direction in TextDirection.values) {
    for (final size in MateoTextInputSize.values) {
      testWidgets('when $size $direction text is selected, its highlight should continue through both fades', (
        tester,
      ) async {
        final controller = TextEditingController(text: 'Coffee shops and bakeries nearby with outdoor seating');
        final focus = FocusNode();
        addTearDown(controller.dispose);
        addTearDown(focus.dispose);
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              autofocus: false,
              placeholder: 'Search',
              controller: controller,
              focusNode: focus,
              presentation: .search(variant: .filled, size: size),
              onChanged: (_) {},
            ),
            direction: direction,
          ),
        );
        focus.requestFocus();
        await tester.pumpAndSettle();
        controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
        await tester.pumpAndSettle();
        final scroll = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).scrollController!;
        final middle = scroll.position.maxScrollExtent / 2;
        scroll.jumpTo(middle);
        await tester.pump();
        final editable = tester.state<EditableTextState>(find.byType(EditableText)).renderEditable;
        final viewport = tester.getRect(find.byType(EditableText));
        final box = editable.getBoxesForSelection(controller.selection).first;
        final sampleY = editable.localToGlobal(Offset(0, box.top + 1)).dy;
        final points = [Offset(viewport.left - 2, sampleY), Offset(viewport.right + 2, sampleY)];
        Future<List<int>> pixels() async {
          final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(const ValueKey('inputCapture')));
          final image = await boundary.toImage();
          final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
          final result = <int>[];
          for (final point in points) {
            final local = boundary.globalToLocal(point);
            final index = (local.dy.floor() * image.width + local.dx.floor()) * 4;
            result.addAll(bytes.sublist(index, index + 4));
          }
          image.dispose();
          return result;
        }

        final selected = (await tester.runAsync(pixels))!;
        controller.selection = const TextSelection.collapsed(offset: 0);
        await tester.pumpAndSettle();
        scroll.jumpTo(middle);
        await tester.pump();
        final unselected = (await tester.runAsync(pixels))!;
        expect(selected.sublist(0, 4), isNot(unselected.sublist(0, 4)));
        expect(selected.sublist(4), isNot(unselected.sublist(4)));
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets(
    'when text is long pressed, it should retain native word selection',
    (tester) async {
      final controller = TextEditingController(text: 'Coffee shops nearby');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            autofocus: false,
            placeholder: 'Search',
            presentation: const .search(variant: .filled),
            controller: controller,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.longPress(find.byType(EditableText));
      await tester.pumpAndSettle();
      expect(controller.selection.isValid, isTrue);
      expect(controller.selection.isCollapsed, isFalse);
      expect(tester.takeException(), isNull);
    },
    variant: const TargetPlatformVariant({TargetPlatform.iOS, TargetPlatform.android}),
  );

  for (final focused in [false, true]) {
    for (final direction in TextDirection.values) {
      testWidgets(
        'when ${focused ? 'focused' : 'unfocused'} ${direction.name} text is dragged, it should scroll in both directions without editing',
        (tester) async {
          final controller = TextEditingController(text: 'Coffee shops and bakeries nearby with outdoor seating');
          final changes = <String>[];
          addTearDown(controller.dispose);
          await tester.pumpWidget(
            _host(
              MateoTextInput(
                autofocus: false,
                placeholder: 'Search',
                presentation: const .search(variant: .filled),
                controller: controller,
                onChanged: changes.add,
              ),
              direction: direction,
            ),
          );
          if (focused) {
            final bounds = tester.getRect(find.byType(EditableText));
            await tester.tapAt(Offset(bounds.left + 8, bounds.center.dy));
            await tester.pumpAndSettle(const Duration(milliseconds: 500));
          }
          final scroll = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).scrollController!
            ..jumpTo(0);
          await tester.pumpAndSettle();
          await tester.dragFrom(
            tester.getCenter(find.byType(EditableText)) + const Offset(45, 0),
            const Offset(-90, 0),
          );
          await tester.pumpAndSettle();
          final moved = scroll.offset;
          expect(moved, greaterThan(0));
          await tester.dragFrom(tester.getCenter(find.byType(EditableText)) - const Offset(45, 0), const Offset(90, 0));
          await tester.pumpAndSettle();
          expect(scroll.offset, lessThan(moved));
          expect(controller.text, 'Coffee shops and bakeries nearby with outdoor seating');
          expect(changes, isEmpty);
          expect(tester.takeException(), isNull);
        },
        variant: const TargetPlatformVariant({TargetPlatform.iOS, TargetPlatform.android}),
      );
    }
  }

  for (final direction in TextDirection.values) {
    testWidgets(
      'when ${direction.name} scrolling changes, it should grow and restore the edge fade from current metrics',
      (tester) async {
        final controller = TextEditingController(text: 'Coffee shops and bakeries nearby with outdoor seating');
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              autofocus: false,
              placeholder: 'Search',
              controller: controller,
              presentation: const .search(variant: .filled),
              onChanged: (_) {},
            ),
            direction: direction,
          ),
        );
        await tester.pumpAndSettle();
        final scroll = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).scrollController!;
        final fadeFinder = find.byType(BaseMateoEdgeFade);
        double leadingDepth() {
          final fade = tester.widget<BaseMateoEdgeFade>(fadeFinder);
          final edge = direction == .ltr ? AxisDirection.left : AxisDirection.right;
          return fade.resolveBands(tester.getSize(fadeFinder)).singleWhere((band) => band.edge == edge).extent;
        }

        final startsAtZero = direction == .ltr
            ? scroll.position.axisDirection == .right
            : scroll.position.axisDirection == .left;
        final origin = startsAtZero ? 0.0 : scroll.position.maxScrollExtent;
        final sign = startsAtZero ? 1.0 : -1.0;
        scroll.jumpTo(origin);
        await tester.pump();
        final iconBounds = tester.getRect(find.byType(MateoIcon).first);
        final resting = leadingDepth();
        final viewport = tester.getRect(find.byType(EditableText));
        final field = tester.getRect(fadeFinder);
        expect(resting, closeTo(direction == .ltr ? viewport.left - field.left : field.right - viewport.right, 0.01));
        scroll.jumpTo(origin + sign);
        await tester.pump();
        expect(tester.getRect(find.byType(MateoIcon).first), iconBounds);
        final partial = leadingDepth();
        expect(partial, greaterThan(resting));
        scroll.jumpTo(origin + sign * 8);
        await tester.pump();
        expect(leadingDepth(), greaterThan(partial));
        final fade = tester.widget<BaseMateoEdgeFade>(fadeFinder);
        for (final band in fade.resolveBands(tester.getSize(fadeFinder))) {
          // Text remains partly visible beneath the icons: no opaque plateau.
          expect(
            band.profile.visibility.skip(1).take(band.profile.visibility.length - 2),
            everyElement(allOf(greaterThan(0), lessThan(1))),
          );
        }
        scroll.jumpTo(origin);
        await tester.pump();
        expect(leadingDepth(), resting);
        controller.text = 'Short';
        await tester.pumpAndSettle();
        expect(scroll.position.maxScrollExtent, 0);
        expect(leadingDepth(), resting);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final direction in TextDirection.values) {
    testWidgets('when long ${direction.name} text is edited, it should keep the caret in the clear viewport', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            autofocus: false,
            placeholder: 'Search',
            controller: controller,
            presentation: const .search(variant: .filled),
            onChanged: (_) {},
          ),
          direction: direction,
        ),
      );
      await tester.enterText(
        find.byType(EditableText),
        direction == .ltr
            ? 'Coffee shops and bakeries nearby with outdoor seating'
            : 'المقاهي والمخابز القريبة مع أماكن للجلوس في الهواء الطلق',
      );
      await tester.pumpAndSettle();
      final editable = tester.state<EditableTextState>(find.byType(EditableText)).renderEditable;
      final caret = editable.getLocalRectForCaret(TextPosition(offset: controller.text.length));
      expect(caret.left, greaterThanOrEqualTo(-1));
      expect(caret.right, lessThanOrEqualTo(editable.size.width + 1));
      expect(tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).clipBehavior, Clip.none);
      await tester.tap(find.byType(MateoPress));
      await tester.pumpAndSettle();
      expect(controller.text, isEmpty);
      expect(find.byType(MateoPress), findsNothing);
      expect(editable.offset.pixels, 0);
      expect(tester.takeException(), isNull);
    });
  }

  for (final direction in TextDirection.values) {
    for (final size in MateoTextInputSize.values) {
      testWidgets('when clearing ${size.name} text in ${direction.name}, it should notify once and retain focus', (
        tester,
      ) async {
        final changes = <String>[];
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              autofocus: false,
              placeholder: 'Search',
              presentation: .search(variant: .filled, size: size),
              onChanged: changes.add,
            ),
            direction: direction,
          ),
        );
        expect(find.byType(MateoPress), findsNothing);
        await tester.enterText(find.byType(EditableText), 'Coffee nearby');
        await tester.pump();
        final editable = tester.widget<EditableText>(find.byType(EditableText));
        editable.controller.selection = const TextSelection(baseOffset: 2, extentOffset: 5);
        final icons = tester.widgetList<MateoIcon>(find.byType(MateoIcon)).toList();
        expect(icons.last.icon, MateoIconData.crossCircle);
        expect(icons.first.size, size.leadingIconSize);
        expect(icons.last.size, size.trailingIconSize);
        expect(icons.last.color, icons.first.color);
        final leadingX = tester.getCenter(find.byType(MateoIcon).first).dx;
        final trailingX = tester.getCenter(find.byType(MateoIcon).last).dx;
        expect(trailingX, direction == .ltr ? greaterThan(leadingX) : lessThan(leadingX));
        final textBounds = tester.getRect(find.byType(EditableText));
        final leadingBounds = tester.getRect(find.byType(MateoIcon).first);
        final trailingBounds = tester.getRect(find.byType(MateoIcon).last);
        expect(direction == .ltr ? textBounds.left - leadingBounds.right : leadingBounds.left - textBounds.right, 4);
        expect(direction == .ltr ? trailingBounds.left - textBounds.right : textBounds.left - trailingBounds.right, 4);
        expect(tester.widget<MateoPress>(find.byType(MateoPress)).semanticLabel, 'Clear');
        await tester.tap(find.byType(MateoPress));
        await tester.pumpAndSettle();
        expect(editable.controller.text, isEmpty);
        expect(editable.controller.selection, const TextSelection.collapsed(offset: 0));
        expect(changes, ['Coffee nearby', '']);
        expect(editable.focusNode.hasFocus, isTrue);
        expect(find.byType(MateoPress), findsNothing);
      });
    }
  }

  testWidgets('when a populated input is disabled, its clear action should leave the text unchanged', (tester) async {
    final controller = TextEditingController(text: 'Coffee');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Search',
          presentation: const .search(variant: .filled),
          controller: controller,
        ),
      ),
    );
    expect(tester.widget<MateoPress>(find.byType(MateoPress)).onPressed, isNull);
    await tester.tap(find.byType(MateoPress), warnIfMissed: false);
    await tester.pump();
    expect(controller.text, 'Coffee');
  });

  testWidgets('when text is entered and submitted, it should notify the core callbacks', (tester) async {
    final changes = <String>[];
    final submissions = <String>[];
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Search places',
          presentation: const .search(variant: .filled),
          onChanged: changes.add,
          onSubmitted: submissions.add,
        ),
      ),
    );
    expect(find.text('Search places'), findsOneWidget);
    expect(find.byType(MateoIcon), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'Coffee');
    await tester.testTextInput.receiveAction(.search);
    await tester.pump();
    expect(changes, ['Coffee']);
    expect(submissions, ['Coffee']);
    final placeholderVisibility = tester.widget<Visibility>(
      find.ancestor(of: find.text('Search places'), matching: find.byType(Visibility)).first,
    );
    expect(placeholderVisibility.visible, isFalse);
    expect(tester.takeException(), isNull);
  });

  for (final size in MateoTextInputSize.values) {
    testWidgets('when ${size.name} is used, it should align with its button height and grow for large text', (
      tester,
    ) async {
      final input = MateoTextInput(
        autofocus: false,
        placeholder: 'Search',
        presentation: .search(variant: .filled, size: size),
        onChanged: (_) {},
      );
      await tester.pumpWidget(_host(input));
      expect(tester.getSize(find.byType(MateoTextInput)).height, size.height);
      await tester.pumpWidget(_host(input, textScale: 3, direction: .rtl));
      expect(tester.getSize(find.byType(MateoTextInput)).height, greaterThan(size.height));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('when disabled, it should use unavailable colors and reject focus', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Search',
          focusNode: focus,
          presentation: const .search(variant: .filled),
        ),
      ),
    );
    await tester.tap(find.byType(MateoTextInput));
    await tester.pump();
    expect(focus.hasFocus, isFalse);
    final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));
    expect(field.enabled, isFalse);
    expect(field.style!.color, _theme.colorScheme.textInputs.filled.neutral.textDisabled);
    expect(field.placeholderStyle!.color, _theme.colorScheme.textInputs.filled.neutral.placeholderDisabled);
    for (final icon in tester.widgetList<MateoIcon>(find.byType(MateoIcon))) {
      expect(icon.color, _theme.colorScheme.textInputs.filled.neutral.iconDisabled);
    }
  });

  testWidgets('when the magnifier is tapped, it should focus the input', (tester) async {
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Search',
          presentation: const .search(variant: .filled),
          onChanged: (_) {},
        ),
      ),
    );
    await tester.tapAt(tester.getCenter(find.byType(MateoIcon).first));
    await tester.pump();
    expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isTrue);
  });

  testWidgets('when controllers are replaced, it should preserve ownership and adopt the current value', (
    tester,
  ) async {
    final first = TextEditingController(text: 'First');
    final second = TextEditingController(text: 'Second');
    final changes = <String>[];
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    Widget input(TextEditingController? controller) => _host(
      MateoTextInput(
        autofocus: false,
        placeholder: 'Search',
        presentation: const .search(variant: .filled),
        controller: controller,
        onChanged: changes.add,
      ),
    );
    await tester.pumpWidget(input(first));
    await tester.pumpWidget(input(second));
    expect(find.text('Second'), findsOneWidget);
    first.text = 'Detached';
    second.text = 'Updated';
    await tester.pump();
    expect(find.text('Updated'), findsOneWidget);
    expect(changes, isEmpty);
    await tester.pumpWidget(input(null));
    expect(tester.widget<EditableText>(find.byType(EditableText)).controller.text, 'Updated');
    await tester.pumpWidget(const SizedBox.shrink());
    first.text = 'Still owned';
    second.text = 'Still owned';
    expect(tester.takeException(), isNull);
  });
}
