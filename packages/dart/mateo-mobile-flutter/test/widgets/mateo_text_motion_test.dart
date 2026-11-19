import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

const _label = ValueKey<String>('label');

Widget _host(
  String label, {
  bool reducedMotion = false,
  bool animationsDisabled = false,
  bool tickersEnabled = true,
  String? semanticsLabel,
  double width = 600,
  TextDirection direction = TextDirection.ltr,
  TextAlign? textAlign,
  Color? color,
  List<ui.FontFeature>? fontFeatures,
  int? maxLines,
  bool decorative = false,
}) => Directionality(
  textDirection: direction,
  child: MediaQuery(
    data: MediaQueryData(reduceMotion: reducedMotion, disableAnimations: animationsDisabled),
    child: TickerMode(
      enabled: tickersEnabled,
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: RepaintBoundary(
            key: _label,
            child: MateoText(
              label,
              presentation: decorative
                  ? const .decorative(variant: .rounded)
                  : .interface(
                      textAlign: textAlign,
                      color: color,
                      fontFeatures: fontFeatures,
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
              semanticsLabel: semanticsLabel,
            ),
          ),
        ),
      ),
    ),
  ),
);

Size _size(WidgetTester tester) => tester.getSize(find.byKey(_label));

void main() {
  for (final interval in [25, 60]) {
    testWidgets('an unchanged word keeps fading in during numeric updates every ${interval}ms', (tester) async {
      await tester.pumpWidget(_host('Enviando 100', reducedMotion: true));
      final paragraph = tester.renderObject<RenderParagraph>(find.byType(RichText));
      final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_label));
      final suffix = paragraph
          .getBoxesForSelection(const TextSelection(baseOffset: 6, extentOffset: 8))
          .single
          .toRect()
          .shift(paragraph.localToGlobal(Offset.zero, ancestor: boundary));
      final settledInk = await _suffixInk(tester, suffix);
      expect(settledInk, greaterThan(0));

      await tester.pumpWidget(_host('Enviar 100', reducedMotion: true));
      await tester.pumpWidget(_host('Enviar 100'));
      await tester.pumpWidget(_host('Enviando 100'));
      for (var elapsed = 5; elapsed <= 240; elapsed += 5) {
        await tester.pump(const Duration(milliseconds: 5));
        if (elapsed % interval == 0) {
          await tester.pumpWidget(_host('Enviando ${100 + elapsed ~/ interval}'));
        }
      }

      expect(tester.binding.transientCallbackCount, 1);
      expect(await _suffixInk(tester, suffix), greaterThan(settledInk * 0.5));
      await tester.pumpAndSettle();
    });
  }

  testWidgets('first mount and equal strings leave the native paragraph at rest', (tester) async {
    const text =
        'A long interface paragraph with static content. '
        'It can wrap and does not need animation work unless its text changes.';
    await tester.pumpWidget(_host(text, width: 160, semanticsLabel: 'Old paragraph'));
    final paragraph = tester.renderObject<RenderParagraph>(find.byType(RichText));
    expect(_size(tester), paragraph.size);
    expect(tester.binding.transientCallbackCount, 0);

    await tester.pumpWidget(_host(String.fromCharCodes(text.codeUnits), width: 160, semanticsLabel: 'Paragraph'));
    expect(tester.renderObject<RenderParagraph>(find.byType(RichText)), same(paragraph));
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('a countdown keeps a continuous width through an update and a reversal', (tester) async {
    await tester.pumpWidget(_host('10 segundos'));
    final initial = _size(tester);
    await tester.pumpWidget(_host('1 segundo'));
    expect(_size(tester), initial);
    expect(tester.binding.transientCallbackCount, 1);

    await tester.pump(const Duration(milliseconds: 64));
    final interrupted = _size(tester);
    final destination = tester.getSize(find.byType(RichText));
    expect(interrupted.width, greaterThan(destination.width));
    expect(interrupted.width, lessThan(initial.width));

    await tester.pumpWidget(_host('10 segundos'));
    expect(_size(tester), interrupted);
    await tester.pumpAndSettle();
    expect(_size(tester), initial);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('a retarget with deferred images starts moving on the next frame', (tester) async {
    await tester.pumpWidget(_host('100 segundos restantes'));
    await tester.pumpWidget(_host('1 segundo'));
    await tester.pump(const Duration(milliseconds: 64));
    final interruptedWidth = _size(tester).width;

    await tester.pumpWidget(_host('42 segundos para continuar'));
    expect(_size(tester).width, interruptedWidth);

    await tester.pump(const Duration(milliseconds: 16));
    expect(_size(tester).width, greaterThan(interruptedWidth));
    await tester.pumpAndSettle();
  });

  testWidgets('a countdown settles sooner when the remaining movement is subpixel on screen', (tester) async {
    for (final scale in [1.0, 24.0]) {
      Widget host(String data) => Transform.scale(scale: scale, alignment: Alignment.topLeft, child: _host(data));

      await tester.pumpWidget(host('10 segundos'));
      await tester.pumpWidget(host('1 segundo'));
      expect(tester.binding.transientCallbackCount, 1);

      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 284));
      final nativeSize = tester.getSize(find.byType(RichText));
      if (scale == 1) {
        expect(tester.binding.transientCallbackCount, 0);
        expect(_size(tester), nativeSize);
      } else {
        expect(tester.binding.transientCallbackCount, 1);
        expect(_size(tester).width, greaterThan(nativeSize.width));
      }

      await tester.pumpAndSettle();
      expect(_size(tester), nativeSize);
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('same-width updates repaint without laying out their parent on every tick', (tester) async {
    var layouts = 0;
    Widget host(String value) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Align(
          alignment: Alignment.topLeft,
          child: _LayoutProbe(
            onLayout: () => layouts++,
            child: MateoText(
              value,
              presentation: const .interface(fontFeatures: [.tabularFigures()]),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(host('10 segundos'));
    await tester.pumpWidget(host('11 segundos'));
    final layoutsAtStart = layouts;
    expect(tester.binding.transientCallbackCount, 1);

    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pumpAndSettle();
    expect(layouts, layoutsAtStart);
    expect(find.text('11 segundos'), findsOneWidget);
  });

  testWidgets('concurrent labels share a clock and settle from their own start times', (tester) async {
    const first = ValueKey<String>('first countdown');
    const second = ValueKey<String>('second countdown');
    Widget host(String firstValue, String secondValue) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MateoText(firstValue, key: first, presentation: const .interface()),
              MateoText(secondValue, key: second, presentation: const .interface()),
            ],
          ),
        ),
      ),
    );
    Size nativeSize(Key key) => tester.getSize(
      find.descendant(of: find.byKey(key), matching: find.byType(RichText)),
    );

    await tester.pumpWidget(host('10 segundos', '10 segundos'));
    await tester.pumpWidget(host('1 segundo', '10 segundos'));
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pumpWidget(host('1 segundo', '1 segundo'));
    expect(tester.binding.transientCallbackCount, 1);

    await tester.pump(const Duration(milliseconds: 220));
    expect(tester.getSize(find.byKey(first)), nativeSize(first));
    expect(tester.getSize(find.byKey(second)).width, greaterThan(nativeSize(second).width));
    expect(tester.binding.transientCallbackCount, 1);

    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('multiline replacements animate the height and expose the latest semantics throughout', (tester) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(_host('Pronto', semanticsLabel: 'Old'));
    final initial = _size(tester);
    await tester.pumpWidget(_host('Para enviar\nPronto', semanticsLabel: 'New'));
    expect(find.bySemanticsLabel('New'), findsOneWidget);
    expect(find.bySemanticsLabel('Old'), findsNothing);
    expect(_size(tester), initial);

    await tester.pump(const Duration(milliseconds: 64));
    expect(_size(tester).height, greaterThan(initial.height));
    expect(_size(tester).height, lessThan(tester.getSize(find.byType(RichText)).height));
    await tester.pumpAndSettle();
    expect(_size(tester), tester.getSize(find.byType(RichText)));
    semantics.dispose();
  });

  testWidgets('enabling reduced motion during a transition shows the latest native text immediately', (tester) async {
    await tester.pumpWidget(_host('10 segundos'));
    await tester.pumpWidget(_host('1 segundo'));
    await tester.pump(const Duration(milliseconds: 64));
    expect(tester.binding.transientCallbackCount, 1);

    await tester.pumpWidget(_host('1 segundo', reducedMotion: true));
    expect(_size(tester), tester.getSize(find.byType(RichText)));
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('selectable text keeps its native paragraph instead of scheduling a transition', (tester) async {
    final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
    Widget selectable(String text) => MateoApp(
      theme: theme,
      home: SelectableRegion(
        selectionControls: emptyTextSelectionControls,
        child: MateoText(text, presentation: const .interface()),
      ),
    );
    await tester.pumpWidget(selectable('Before'));
    await tester.pumpWidget(selectable('After'));
    expect(tester.binding.transientCallbackCount, 0);
    expect(find.text('After'), findsOneWidget);
  });

  testWidgets('wrapped bidirectional text updates with joined characters and emoji', (tester) async {
    const before = 'مرحبا 👩🏽‍💻\nTime 123';
    const after = 'Time 124\nمرحبا 👩🏽‍💻';
    await tester.pumpWidget(_host(before, width: 85, direction: TextDirection.rtl));
    await tester.pumpWidget(_host(after, width: 85, direction: TextDirection.rtl));
    expect(tester.binding.transientCallbackCount, 1);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text(after), findsOneWidget);
    expect(_size(tester), tester.getSize(find.byType(RichText)));
  });

  testWidgets('a wrapped update starts from the latest painted alignment and color', (tester) async {
    const before = 'Confira os\nseus dados';
    const after = 'Confira os\ndados salvos';
    Widget host(String text) => _host(
      text,
      width: 188,
      textAlign: TextAlign.right,
      color: const Color(0xFF4A5CFF),
    );

    await tester.pumpWidget(_host(before, width: 188));
    await tester.pumpWidget(host(before));
    expect(tester.renderObject<RenderParagraph>(find.byType(RichText)).didExceedMaxLines, isFalse);
    final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_label));
    final previousFrame = boundary.toImageSync();
    addTearDown(previousFrame.dispose);

    await tester.pumpWidget(host(after));
    expect(tester.binding.transientCallbackCount, 1);
    await expectLater(find.byKey(_label), matchesReferenceImage(previousFrame));

    await tester.pumpAndSettle();
    expect(find.text(after), findsOneWidget);
  });

  testWidgets('a paint-only color change immediately displays the latest native ink', (tester) async {
    const red = Color(0xffe83028);
    const blue = Color(0xff205ef2);
    const tabular = [ui.FontFeature.tabularFigures()];
    Widget host(String value, Color ink, {bool reducedMotion = false}) =>
        _host(value, color: ink, fontFeatures: tabular, reducedMotion: reducedMotion);

    await tester.pumpWidget(host('11 segundos', blue, reducedMotion: true));
    final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_label));
    final nativeBlue = boundary.toImageSync();
    addTearDown(nativeBlue.dispose);

    await tester.pumpWidget(host('10 segundos', red, reducedMotion: true));
    await tester.pumpWidget(host('10 segundos', red));
    await tester.pumpWidget(host('11 segundos', red));
    await tester.pump(const Duration(milliseconds: 90));
    expect(tester.binding.transientCallbackCount, 1);
    expect(_size(tester), tester.getSize(find.byType(RichText)));

    await tester.pumpWidget(host('11 segundos', blue));
    expect(tester.binding.transientCallbackCount, 0);
    await expectLater(find.byKey(_label), matchesReferenceImage(nativeBlue));
  });

  testWidgets('a truncated endpoint displays its native text and ends active motion', (tester) async {
    const long = 'A string too long to fit into an eighty pixel line';
    Widget host(String text, {bool reducedMotion = false}) =>
        _host(text, width: 80, maxLines: 1, reducedMotion: reducedMotion, semanticsLabel: 'Time remaining');

    await tester.pumpWidget(host(long, reducedMotion: true));
    final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_label));
    final nativeTruncation = boundary.toImageSync();
    addTearDown(nativeTruncation.dispose);

    await tester.pumpWidget(host('1s'));
    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.renderObject<RenderParagraph>(find.byType(RichText)).didExceedMaxLines, isFalse);

    await tester.pumpWidget(host('2s'));
    await tester.pump(const Duration(milliseconds: 60));
    expect(tester.binding.transientCallbackCount, 1);

    await tester.pumpWidget(host(long));
    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.renderObject<RenderParagraph>(find.byType(RichText)).didExceedMaxLines, isTrue);
    await expectLater(find.byKey(_label), matchesReferenceImage(nativeTruncation));
  });

  testWidgets('disabled tickers, disabled animations, decorative and truncated text update immediately', (
    tester,
  ) async {
    for (final host in <Widget Function(String)>[
      (text) => _host(text, tickersEnabled: false),
      (text) => _host(text, animationsDisabled: true),
      (text) => _host(text, decorative: true),
      (text) => _host(text, maxLines: 1, width: 80),
    ]) {
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(host('A string too long to fit into an eighty pixel line'));
      await tester.pumpWidget(host('New text'));
      expect(_size(tester), tester.getSize(find.byType(RichText)));
      expect(tester.binding.transientCallbackCount, 0);
    }
  });
}

class _LayoutProbe extends SingleChildRenderObjectWidget {
  const new({required this.onLayout, required super.child});

  final VoidCallback onLayout;

  @override
  _RenderLayoutProbe createRenderObject(BuildContext context) => _RenderLayoutProbe(onLayout);

  @override
  void updateRenderObject(BuildContext context, _RenderLayoutProbe renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderLayoutProbe extends RenderProxyBox {
  new(this.onLayout);

  VoidCallback onLayout;

  @override
  void performLayout() {
    onLayout();
    super.performLayout();
  }
}

Future<int> _suffixInk(WidgetTester tester, Rect suffix) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_label));
  final ink = await tester.runAsync(() async {
    final image = await boundary.toImage();
    try {
      final pixels = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
      var sum = 0;
      for (var y = suffix.top.ceil(); y < suffix.bottom.floor(); y++) {
        for (var x = suffix.left.ceil() + 1; x < suffix.right.floor() - 1; x++) {
          sum += pixels.getUint8((y * image.width + x) * 4 + 3);
        }
      }
      return sum;
    } finally {
      image.dispose();
    }
  });
  return ink!;
}
