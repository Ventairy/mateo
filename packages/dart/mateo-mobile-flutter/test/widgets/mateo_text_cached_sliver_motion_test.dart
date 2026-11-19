import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

const ValueKey<String> _viewportKey = ValueKey('fixed-size text rail');

Widget _rail({
  required ValueNotifier<String> text,
  required ValueNotifier<Size> viewport,
  required ScrollController scroll,
  required int labelRow,
  required double rowHeight,
}) => Localizations(
  locale: const Locale('pt', 'BR'),
  delegates: const [DefaultWidgetsLocalizations.delegate],
  child: Center(
    child: ValueListenableBuilder(
      valueListenable: viewport,
      child: ListView.builder(
        controller: scroll,
        padding: EdgeInsets.zero,
        itemCount: 30,
        itemExtent: rowHeight,
        scrollCacheExtent: const ScrollCacheExtent.pixels(1800),
        itemBuilder: (context, index) => index == labelRow
            ? Align(
                alignment: Alignment.centerLeft,
                child: ValueListenableBuilder(
                  valueListenable: text,
                  builder: (context, value, _) => MateoText(
                    value,
                    presentation: const .interface(fontSize: .custom(14)),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
      builder: (context, size, list) => SizedBox(
        key: _viewportKey,
        width: size.width,
        height: size.height,
        child: list,
      ),
    ),
  ),
);

String _nativeText(WidgetTester tester) =>
    tester.renderObject<RenderParagraph>(find.byType(RichText, skipOffstage: false)).text.toPlainText();

class _CorrectingScrollController extends ScrollController {
  new() : super(initialScrollOffset: 540);

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) =>
      _CorrectingScrollPosition(
        physics: physics,
        context: context,
        oldPosition: oldPosition,
        initialPixels: initialScrollOffset,
      );
}

class _CorrectingScrollPosition extends ScrollPositionWithSingleContext {
  new({required super.physics, required super.context, super.oldPosition, super.initialPixels});

  double? pendingCorrection;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    final correction = pendingCorrection;
    if (correction == null) return super.applyContentDimensions(minScrollExtent, maxScrollExtent);
    pendingCorrection = null;
    correctPixels(correction);
    return false;
  }
}

void main() {
  testWidgets('late reveal releases every atlas image after the old digit has exited', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    tester.view.devicePixelRatio = 3;
    tester.view.physicalSize = const Size(1080, 1728);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final created = <ui.Image>[];
    final disposed = Set<ui.Image>.identity();
    ui.Image.onCreate = created.add;
    ui.Image.onDispose = disposed.add;
    addTearDown(() {
      ui.Image.onCreate = null;
      ui.Image.onDispose = null;
    });

    final text = ValueNotifier('1111 itens');
    final viewport = ValueNotifier(const Size(360, 360));
    final scroll = ScrollController();
    await tester.pumpWidget(_rail(text: text, viewport: viewport, scroll: scroll, labelRow: 8, rowHeight: 60));
    text.value = '1112 itens';
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(_nativeText(tester), '1111 itens');
    expect(created, isEmpty);

    scroll.jumpTo(480);
    await tester.pump(const Duration(milliseconds: 8));
    expect(_nativeText(tester), '1112 itens');
    expect(created, isNotEmpty);
    await tester.pumpAndSettle();
    expect(disposed, unorderedEquals(created));
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(disposed, unorderedEquals(created));
    text.dispose();
    viewport.dispose();
    scroll.dispose();
  }, semanticsEnabled: false);

  testWidgets('a viewport correction reveals the latest native text on its first frame', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final text = ValueNotifier('1111 itens');
    final viewport = ValueNotifier(const Size(160, 60));
    final scroll = ScrollController(initialScrollOffset: 540);
    await tester.pumpWidget(_rail(text: text, viewport: viewport, scroll: scroll, labelRow: 25, rowHeight: 20));
    text.value = '1112 itens';
    await tester.pump();
    expect(_nativeText(tester), '1111 itens');
    await tester.pump(const Duration(milliseconds: 116));

    viewport.value = const Size(161, 120);
    text.value = '1113 itens';
    await tester.pump(const Duration(milliseconds: 16));
    expect(scroll.offset, 480);
    expect(_nativeText(tester), '1113 itens');
    final top = tester.getTopLeft(find.byKey(_viewportKey)).dy;
    final labelTop = tester.getTopLeft(find.byType(RichText)).dy;
    expect(labelTop, inInclusiveRange(top + 20, top + 25));
    await tester.pumpAndSettle();
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    text.dispose();
    viewport.dispose();
    scroll.dispose();
  }, semanticsEnabled: false);

  testWidgets('when a custom scroll offset corrects during layout, it should reveal the latest text', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final scroll = _CorrectingScrollController();
    final text = ValueNotifier('1111 itens');
    final cacheExtent = ValueNotifier<double>(600);
    addTearDown(scroll.dispose);
    addTearDown(text.dispose);
    addTearDown(cacheExtent.dispose);

    final sliver = SliverFixedExtentList(
      itemExtent: 20,
      delegate: SliverChildBuilderDelegate(
        (context, index) => index == 25
            ? ValueListenableBuilder(
                valueListenable: text,
                builder: (context, value, _) => MateoText(value, presentation: const .interface(fontSize: .custom(14))),
              )
            : const SizedBox.shrink(),
        childCount: 30,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        addSemanticIndexes: false,
      ),
    );
    await tester.pumpWidget(
      Localizations(
        locale: const Locale('pt', 'BR'),
        delegates: const [DefaultWidgetsLocalizations.delegate],
        child: Center(
          child: SizedBox(
            width: 160,
            height: 60,
            child: Scrollable(
              controller: scroll,
              viewportBuilder: (context, position) => ValueListenableBuilder(
                valueListenable: cacheExtent,
                child: sliver,
                builder: (context, extent, child) => Viewport(
                  key: _viewportKey,
                  offset: position,
                  scrollCacheExtent: ScrollCacheExtent.pixels(extent),
                  slivers: [child!],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final label = find.byType(RichText, skipOffstage: false);
    final paragraph = tester.renderObject<RenderParagraph>(label);
    final constraints = paragraph.constraints;
    expect(scroll.offset, 540);
    expect(_nativeText(tester), '1111 itens');

    text.value = '1112 itens';
    await tester.pump();

    var notifications = 0;
    scroll.addListener(() => notifications++);
    (scroll.position as _CorrectingScrollPosition).pendingCorrection = 480;
    cacheExtent.value = 601; // Request layout without changing the viewport or row size.
    await tester.pump(const Duration(milliseconds: 17));

    expect(scroll.offset, 480);
    expect(notifications, 0);
    expect(tester.widget(find.byType(SliverFixedExtentList)), same(sliver));
    expect(tester.renderObject(label), same(paragraph));
    expect(paragraph.constraints, constraints);
    expect(tester.getTopLeft(label).dy, tester.getTopLeft(find.byKey(_viewportKey)).dy + 20);
    expect(_nativeText(tester), '1112 itens');
    await tester.pumpAndSettle();
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpWidget(const SizedBox.shrink());
  }, semanticsEnabled: false);
}
