import 'package:flutter/foundation.dart' show FlutterTimeline;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderFlex, debugProfileLayoutsEnabled;
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

const _triggerKey = Key('performance menu trigger');
const _surfaceKey = ValueKey('mateo_menu_button_menu_surface');
const _frame = Duration(milliseconds: 16);

void main() {
  for (final preset in [
    (name: 'action', isContext: false, presentation: const MateoMenuPresentation.action()),
    (name: 'context', isContext: true, presentation: const MateoMenuPresentation.context()),
  ]) {
    testWidgets('when ${preset.name} animates, it should keep custom icon construction and layout bounded', (
      tester,
    ) async {
      final work = _MenuWork();
      await _mount(tester, preset.presentation, work);
      work.reset();
      await tester.tap(find.byKey(_triggerKey));
      await tester.pump();
      await tester.pump();
      final initialLayouts = work.layouts;
      await _frames(tester, 24);
      expect(find.byKey(_surfaceKey), findsOneWidget);
      expect(work.builds, 3);
      expect(work.layouts, initialLayouts);
      expect(work.paints, lessThanOrEqualTo(preset.isContext ? 3 : 9));
      expect(work.rebuilds['AnimatedBuilder'] ?? 0, lessThanOrEqualTo(2));

      work.reset();
      await tester.tapAt(const Offset(1, 1));
      await _frames(tester, 24);
      expect(find.byKey(_surfaceKey), findsNothing);
      expect(work.builds, 0);
      expect(work.layouts, 0);
      expect(work.paints, lessThanOrEqualTo(preset.isContext ? 0 : 3));
      expect(work.rebuilds['AnimatedBuilder'] ?? 0, lessThanOrEqualTo(1));
    });

    testWidgets('when ${preset.name} is idle, it should schedule no frames or rebuild, lay out, or repaint icons', (
      tester,
    ) async {
      final work = _MenuWork();
      await _mount(tester, preset.presentation, work);
      await tester.tap(find.byKey(_triggerKey));
      await tester.pumpAndSettle();
      work.reset();
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(tester.binding.transientCallbackCount, 0);
      await _frames(tester, 10);
      expect(work.builds, 0);
      expect(work.layouts, 0);
      expect(work.paints, 0);
      expect(work.rebuilds, isEmpty);
      expect(tester.binding.hasScheduledFrame, isFalse);
      await tester.tapAt(const Offset(1, 1));
      await tester.pumpAndSettle();
      work.reset();
      await _frames(tester, 10);
      expect(work.builds, 0);
      expect(work.layouts, 0);
      expect(work.paints, 0);
      expect(work.rebuilds, isEmpty);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets(
      'when an item is selected from ${preset.name}, it should retain its content through press and closing',
      (
        tester,
      ) async {
        final work = _MenuWork();
        var selections = 0;
        var closed = false;
        await _mount(
          tester,
          preset.presentation,
          work,
          onAction: (closing) async {
            selections++;
            await closing;
            closed = true;
          },
        );
        await tester.tap(find.byKey(_triggerKey));
        await tester.pumpAndSettle();
        work.reset();
        final paragraphLayoutCalls = await _paragraphLayoutCalls(() async {
          await tester.tap(find.text('Action 0'));
          expect(selections, 1);
          expect(closed, isFalse);
          await _frames(tester, 24);
        });

        expect(closed, isTrue);
        expect(find.byKey(_surfaceKey), findsNothing);
        expect(work.builds, 0);
        expect(work.created, 3);
        expect(work.disposed, 3);
        expect(work.layouts, 0);
        expect(paragraphLayoutCalls, 0);
        // Keep action feedback within the measured paint cost before optimization.
        expect(work.paints, lessThanOrEqualTo(preset.isContext ? 15 : 3));
        expect(tester.binding.hasScheduledFrame, isFalse);
        expect(tester.binding.transientCallbackCount, 0);
      },
    );

    testWidgets('when ${preset.name} opens repeatedly, it should create and release each icon once per session', (
      tester,
    ) async {
      final work = _MenuWork();
      await _mount(tester, preset.presentation, work);
      for (var session = 0; session < 3; session++) {
        await tester.tap(find.byKey(_triggerKey));
        await _frames(tester, 24);
        await tester.tapAt(const Offset(1, 1));
        await _frames(tester, 24);
        expect(work.builds, 3 * (session + 1));
        expect(work.created, 3 * (session + 1));
        expect(work.disposed, work.created);
      }
      expect(work.paints, lessThanOrEqualTo(preset.isContext ? 9 : 36));
    });
  }

  testWidgets(
    'when an open context trigger moves, it should preserve existing icon widgets and measure only as needed',
    (
      tester,
    ) async {
      final work = _MenuWork();
      final position = ValueNotifier(const Offset(310, 350));
      addTearDown(position.dispose);
      await _mount(tester, const MateoMenuPresentation.context(), work, position: position);
      await tester.tap(find.byKey(_triggerKey));
      await tester.pumpAndSettle();
      work.reset();
      final paragraphLayoutCalls = await _paragraphLayoutCalls(() async {
        for (var step = 0; step < 8; step++) {
          position.value = Offset(310, 350 + step * 3);
          await tester.pump();
          await tester.pump();
        }
      });
      expect(paragraphLayoutCalls, 0);
      expect(work.builds, 0);
      expect(work.layouts, 0);
      expect(work.paints, 0);
      expect(work.created, 3);
      expect(work.disposed, 0);
    },
  );

  testWidgets(
    'when custom context icon dimensions change, it should invalidate fitted measurement without rebuilding actions',
    (
      tester,
    ) async {
      final work = _MenuWork();
      final iconSize = ValueNotifier(const Size(32, 32));
      addTearDown(iconSize.dispose);
      await _mount(tester, const MateoMenuPresentation.context(), work, iconSize: iconSize);
      await tester.tap(find.byKey(_triggerKey));
      await tester.pumpAndSettle();
      final originalSize = tester.getSize(find.byKey(_surfaceKey));
      work.reset();
      iconSize.value = const Size(80, 50);
      await tester.pumpAndSettle();
      final largerSize = tester.getSize(find.byKey(_surfaceKey));
      expect(largerSize.width, greaterThan(originalSize.width));
      expect(largerSize.height, greaterThan(originalSize.height));
      expect(work.builds, 0);
      expect(work.layouts, 3);
      iconSize.value = const Size(32, 32);
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(_surfaceKey)), originalSize);
      expect(work.builds, 0);
      expect(work.layouts, 6);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'when the context viewport narrows, it should invalidate fitted width while retaining its action snapshot',
    (
      tester,
    ) async {
      final work = _MenuWork();
      await _mount(tester, const MateoMenuPresentation.context(), work);
      await tester.tap(find.byKey(_triggerKey));
      await tester.pumpAndSettle();
      final originalWidth = tester.getSize(find.byKey(_surfaceKey)).width;
      tester.view.physicalSize = const Size(200, 800);
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(_surfaceKey)).width, lessThan(originalWidth));
      expect(tester.getSize(find.byKey(_surfaceKey)).width, lessThanOrEqualTo(176));
      expect(work.builds, 3);
      expect(work.created, 3);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'when context text scale grows, it should invalidate natural measurement without replacing icon widgets',
    (
      tester,
    ) async {
      final work = _MenuWork();
      await _mount(tester, const MateoMenuPresentation.context(), work);
      await tester.tap(find.byKey(_triggerKey));
      await tester.pumpAndSettle();
      final originalHeight = tester.getSize(find.byKey(_surfaceKey)).height;
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(_surfaceKey)).height, greaterThan(originalHeight));
      expect(work.builds, 3);
      expect(work.created, 3);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('when context content is measured dry, it should preserve its live layout and action alignment', (
    tester,
  ) async {
    final work = _MenuWork();
    await _mount(tester, const MateoMenuPresentation.context(), work);
    await tester.tap(find.byKey(_triggerKey));
    await tester.pumpAndSettle();
    final content = tester.renderObject<RenderFlex>(
      find
          .descendant(
            of: find.byKey(_surfaceKey),
            matching: find.byWidgetPredicate((widget) => widget is MultiChildRenderObjectWidget),
          )
          .first,
    );
    final liveSize = content.size;
    final liveConstraints = content.constraints;
    final liveAlignment = content.crossAxisAlignment;
    final liveBaseline = content.getDryBaseline(liveConstraints, TextBaseline.alphabetic);
    work.reset();

    final looseSize = content.getDryLayout(BoxConstraints(maxWidth: liveSize.width + 60));
    final narrowSize = content.getDryLayout(BoxConstraints.tightFor(width: liveSize.width - 30));
    expect(looseSize.width, lessThanOrEqualTo(liveSize.width + 60));
    expect(narrowSize.width, liveSize.width - 30);
    expect(narrowSize.height, greaterThanOrEqualTo(liveSize.height));
    expect(
      content.getDryBaseline(BoxConstraints(maxWidth: liveSize.width + 60), TextBaseline.alphabetic),
      liveBaseline,
    );
    expect(content.getDryLayout(liveConstraints), liveSize);
    expect(content.getDryBaseline(liveConstraints, TextBaseline.alphabetic), liveBaseline);
    expect(content.crossAxisAlignment, liveAlignment);
    expect(content.size, liveSize);
    expect(content.debugNeedsLayout, isFalse);

    await tester.pump();
    expect(work.layouts, 0);
    expect(work.paints, 0);
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _frames(WidgetTester tester, int count) async {
  for (var frame = 0; frame < count; frame++) {
    await tester.pump(_frame);
  }
}

Future<int> _paragraphLayoutCalls(Future<void> Function() action) async {
  final previousProfiling = debugProfileLayoutsEnabled;
  final previousCollection = FlutterTimeline.debugCollectionEnabled;
  debugProfileLayoutsEnabled = true;
  FlutterTimeline.debugCollectionEnabled = true;
  FlutterTimeline.debugReset();
  try {
    await action();
    // Flutter records layout entry, including calls that take its fast path.
    return FlutterTimeline.debugCollect().getAggregated('RenderParagraph').count;
  } finally {
    debugProfileLayoutsEnabled = previousProfiling;
    FlutterTimeline.debugCollectionEnabled = previousCollection;
    FlutterTimeline.debugReset();
  }
}

Future<void> _mount(
  WidgetTester tester,
  MateoMenuPresentation presentation,
  _MenuWork work, {
  ValueNotifier<Offset>? position,
  ValueNotifier<Size>? iconSize,
  Future<void> Function(Future<void>)? onAction,
}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = const Size(400, 800);
  addTearDown(tester.view.reset);
  final previousObserver = debugOnRebuildDirtyWidget;
  debugOnRebuildDirtyWidget = (element, builtOnce) {
    previousObserver?.call(element, builtOnce);
    final name = element.widget.runtimeType.toString();
    if (name.startsWith('_MateoActionMenu') || name.startsWith('_MateoContextMenu') || name == 'MateoMenuButton') {
      work.rebuilds.update(name, (count) => count + 1, ifAbsent: () => 1);
    } else if (name == 'AnimatedBuilder' || name == 'LayoutBuilder') {
      element.visitAncestorElements((ancestor) {
        if (ancestor.widget is MateoMenuPresentation) {
          work.rebuilds.update(name, (count) => count + 1, ifAbsent: () => 1);
          return false;
        }
        return true;
      });
    }
  };
  addTearDown(() => debugOnRebuildDirtyWidget = previousObserver);
  final button = MateoMenuButton(
    key: _triggerKey,
    menuPresentation: presentation,
    buttonPresentation: MateoButtonPresentation.icon(
      semanticLabel: 'More',
      variant: MateoButtonVariant.primary.base,
      elevation: 1,
      iconBuilder: (state) => Icon(Icons.more_horiz, size: state.iconSize, color: state.foregroundColor),
    ),
    items: [
      for (var index = 0; index < 3; index++)
        MateoMenuItem(
          title: 'Action $index',
          description: 'A descriptive action',
          leadingIconBuilder: (_) {
            work.builds++;
            final icon = _CostlyIcon(work);
            return iconSize == null
                ? icon
                : ValueListenableBuilder<Size>(
                    valueListenable: iconSize,
                    child: icon,
                    builder: (_, value, child) => SizedBox.fromSize(size: value, child: child),
                  );
          },
          onPressed: onAction ?? (_) {},
        ),
    ],
  );
  Widget place(Offset offset) => Stack(
    children: [Positioned(left: offset.dx, top: offset.dy, child: button)],
  );
  await tester.pumpWidget(
    TestApp(
      child: position == null
          ? place(const Offset(310, 350))
          : ValueListenableBuilder<Offset>(valueListenable: position, builder: (_, value, _) => place(value)),
    ),
  );
  await tester.pumpAndSettle();
}

class _MenuWork {
  int builds = 0;
  int layouts = 0;
  int paints = 0;
  int created = 0;
  int disposed = 0;
  final rebuilds = <String, int>{};

  void reset() {
    builds = 0;
    layouts = 0;
    paints = 0;
    rebuilds.clear();
  }
}

class _CostlyIcon extends LeafRenderObjectWidget {
  const _CostlyIcon(this.work);
  final _MenuWork work;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderCostlyIcon(work);
}

class _RenderCostlyIcon extends RenderBox {
  _RenderCostlyIcon(this.work) {
    work.created++;
  }

  final _MenuWork work;

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.constrain(const Size(32, 32));

  @override
  double? computeDryBaseline(BoxConstraints constraints, TextBaseline baseline) => null;

  @override
  void performLayout() {
    work.layouts++;
    size = constraints.constrain(const Size(32, 32));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    work.paints++;
    final paint = Paint()..color = Colors.white;
    // Represent consumer artwork whose drawing should be retained during motion.
    for (var dot = 0; dot < 128; dot++) {
      context.canvas.drawCircle(offset + Offset((dot % 16) * 2, (dot ~/ 16) * 4), 0.8, paint);
    }
  }

  @override
  void dispose() {
    work.disposed++;
    super.dispose();
  }
}
