import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoSelect layout', () {
    testWidgets('when opening animates, it should keep option layouts unchanged between frames', (tester) async {
      final layouts = <String, int>{};
      await _pumpSelect(tester, layouts: layouts);

      await tester.tap(find.text('Fixed price'));
      await tester.pump();
      await tester.pump();
      await tester.pump();

      await _expectStableLayouts(tester, layouts);
      await tester.pumpAndSettle();
    });

    testWidgets('when a new selection closes, it should keep option layouts unchanged between frames', (tester) async {
      final layouts = <String, int>{};
      await _pumpSelect(tester, layouts: layouts);
      await tester.tap(find.text('Fixed price'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Range'));
      await tester.pump();
      await tester.pump();
      await tester.pump();

      await _expectStableLayouts(tester, layouts);
      await tester.pumpAndSettle();
      expect(find.text('Range'), findsOneWidget);
    });

    testWidgets('when content, text scale, or viewport changes, it should measure the current compact menu', (
      tester,
    ) async {
      late StateSetter rebuild;
      var flexibleTitle = 'Flexible';
      var textScale = 1.0;
      await _pumpHost(
        tester,
        child: StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
              child: _select(flexibleTitle: flexibleTitle),
            );
          },
        ),
      );

      Future<double> openWidth() async {
        await tester.tap(find.text('Fixed price'));
        await tester.pumpAndSettle();
        return tester.getSize(find.byType(SingleChildScrollView)).width;
      }

      Future<void> dismiss() async {
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
      }

      final initialWidth = await openWidth();
      expect(initialWidth, lessThan(376));
      await dismiss();

      expect(await openWidth(), initialWidth);
      await dismiss();

      rebuild(() => flexibleTitle = 'Choose a different price');
      await tester.pump();
      final widerContent = await openWidth();
      expect(widerContent, greaterThan(initialWidth));
      expect(widerContent, lessThanOrEqualTo(376));
      await dismiss();

      rebuild(() => textScale = 1.3);
      await tester.pump();
      final largerText = await openWidth();
      expect(largerText, greaterThan(widerContent));
      expect(largerText, lessThanOrEqualTo(376));
      await dismiss();

      tester.view.physicalSize = const Size(260, 800);
      await tester.pumpAndSettle();
      final narrowerViewport = await openWidth();
      expect(narrowerViewport, lessThan(largerText));
      expect(narrowerViewport, lessThanOrEqualTo(236));
      expect(tester.takeException(), isNull);
    });
  });
}

Future<void> _expectStableLayouts(WidgetTester tester, Map<String, int> layouts) async {
  expect(layouts.keys, containsAll(['fixed', 'range', 'flexible']));
  expect(layouts.values, everyElement(greaterThan(0)));
  final initialLayouts = Map<String, int>.of(layouts);
  final menuRenderObjects = <String>{};
  void recordMenuRenderObject(RenderObject renderObject) {
    menuRenderObjects.add(renderObject.toStringShort());
    renderObject.visitChildren(recordMenuRenderObject);
  }

  recordMenuRenderObject(tester.renderObject(find.byType(SingleChildScrollView)));
  expect(tester.hasRunningAnimations, isTrue);
  final previousDebugPrint = debugPrint;
  final previousDebugPrintLayouts = debugPrintLayouts;
  final layoutMessages = <String>[];
  debugPrintLayouts = true;
  debugPrint = (message, {wrapWidth}) {
    if (message == null || !message.startsWith('Laying out')) {
      previousDebugPrint(message, wrapWidth: wrapWidth);
      return;
    }
    // The framework may update its overlay anchor layout each frame.
    if (message.contains('RenderIntrinsicWidth') || menuRenderObjects.any(message.contains))
      layoutMessages.add(message);
  };
  try {
    for (var frame = 0; frame < 6; frame += 1) {
      await tester.pump(const Duration(milliseconds: 16));
      expect(layouts, initialLayouts, reason: 'Animation frame $frame must only update the rendered movement.');
    }
  } finally {
    debugPrint = previousDebugPrint;
    debugPrintLayouts = previousDebugPrintLayouts;
  }
  expect(
    layoutMessages,
    isEmpty,
    reason: 'The menu contents must not repeat layout or intrinsic measurement on animation frames.',
  );
  expect(tester.hasRunningAnimations, isTrue);
}

Future<void> _pumpSelect(WidgetTester tester, {required Map<String, int> layouts}) =>
    _pumpHost(tester, child: _select(layouts: layouts));

Future<void> _pumpHost(WidgetTester tester, {required Widget child}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = const Size(400, 800);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: mateoTestTheme,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

MateoSelect<String> _select({Map<String, int>? layouts, String flexibleTitle = 'Flexible'}) => MateoSelect<String>(
  initialValue: 'fixed',
  presentation: const MateoSelectPresentation.neutral(),
  onSelected: (value, animation) {},
  options: [
    for (final (value, title) in [('fixed', 'Fixed price'), ('range', 'Range'), ('flexible', flexibleTitle)])
      MateoSelectOption(
        value: value,
        title: title,
        iconBuilder: (state) => _LayoutProbe(
          onLayout: () => layouts?.update(value, (count) => count + 1, ifAbsent: () => 1),
          child: Icon(Icons.attach_money, size: state.iconSize, color: state.recommendedIconColor),
        ),
      ),
  ],
);

class _LayoutProbe extends SingleChildRenderObjectWidget {
  const _LayoutProbe({required this.onLayout, required super.child});

  final VoidCallback onLayout;

  @override
  _RenderLayoutProbe createRenderObject(BuildContext context) => _RenderLayoutProbe(onLayout);

  @override
  void updateRenderObject(BuildContext context, _RenderLayoutProbe renderObject) => renderObject.onLayout = onLayout;
}

class _RenderLayoutProbe extends RenderProxyBox {
  _RenderLayoutProbe(this.onLayout);

  VoidCallback onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout();
  }
}
