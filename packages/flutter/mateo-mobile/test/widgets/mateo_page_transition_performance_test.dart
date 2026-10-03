import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/app_test_counter.dart';
import '../fixtures/layout_counter.dart';
import '../fixtures/paint_counter.dart';
import '../fixtures/platform_view_layer/platform_view_layer_fixture.dart';

const ValueKey<String> _captureKey = ValueKey('transition capture');
const ValueKey<String> _destinationKey = ValueKey('destination content');
const ValueKey<String> _actionKey = ValueKey('destination action');
final _theme = MateoThemeData.light(accentColor: const Color(0xFF7551FF), onAccent: const Color(0xFFFFFFFF));

void main() {
  for (final direction in MateoPageTransitionDirection.values) {
    _testWidgets(
      'when push travels $direction and returns, static pages should retain their build, layout, and paint',
      (
        tester,
      ) async {
        final sourceCounts = _counts();
        final destinationCounts = _counts();
        final flight = await _pumpFlight(
          tester,
          transition: .push(direction: direction),
          source: _countedContent(counts: sourceCounts, color: _theme.colorScheme.background),
          destination: _countedContent(counts: destinationCounts, color: _theme.colorScheme.accent),
        );
        await _pumpFrames(tester, 2);
        final openingSource = Map<String, int>.of(sourceCounts);
        final openingDestination = Map<String, int>.of(destinationCounts);
        expect(openingSource.values, everyElement(greaterThan(0)));
        expect(openingDestination.values, everyElement(greaterThan(0)));

        await _pumpFrames(tester, 8);
        expect(sourceCounts, openingSource);
        expect(destinationCounts, openingDestination);

        await tester.pumpAndSettle();
        flight.navigator.pop();
        await tester.pump();
        await _pumpFrames(tester, 2);
        final returningSource = Map<String, int>.of(sourceCounts);
        final returningDestination = Map<String, int>.of(destinationCounts);
        await _pumpFrames(tester, 8);
        expect(sourceCounts, returningSource);
        expect(destinationCounts, returningDestination);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );

    _testWidgets(
      'when push travels $direction, its source blend should sample the matching patterned destination edge',
      (
        tester,
      ) async {
        const sourceColor = Color(0xFF000000);
        final samples = switch (direction) {
          .up => (first: const Offset(100, 100), second: const Offset(300, 100), colors: _topEdgeColors),
          .down => (first: const Offset(100, 500), second: const Offset(300, 500), colors: _bottomEdgeColors),
          .left => (first: const Offset(100, 150), second: const Offset(100, 450), colors: _leftEdgeColors),
          .right => (first: const Offset(300, 150), second: const Offset(300, 450), colors: _rightEdgeColors),
        };
        final transition = MateoPageTransitionPush(direction: direction);
        final flight = await _pumpFlight(
          tester,
          transition: transition,
          source: const ColoredBox(color: sourceColor),
          destination: _patternedDestination(),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(flight.route.animation!.value, 0.5);
        final alpha = (transition.curve.transform(0.5) * 255).round();
        expect(
          await _pixelColor(tester, samples.first),
          Color(Color.alphaBlend(samples.colors.first.withAlpha(alpha), sourceColor).toARGB32()),
        );
        expect(
          await _pixelColor(tester, samples.second),
          Color(Color.alphaBlend(samples.colors.second.withAlpha(alpha), sourceColor).toARGB32()),
        );
        await tester.pumpAndSettle();
      },
    );
  }

  _testWidgets(
    'when push opens and returns, it should capture two page textures once per flight and share the entering edge',
    (
      tester,
    ) async {
      await _trackImages((created, disposed) async {
        final flight = await _pumpFlight(
          tester,
          transition: const .push(),
          destination: ColoredBox(color: _theme.colorScheme.accent),
        );
        await _pumpFrames(tester, 10);
        final openingEdges = created.where(_isEdgeImage).toList();
        final openingPages = created.where(_isFullPageImage).toList();
        expect(openingEdges, isEmpty);
        expect(openingPages, hasLength(3));
        expect(_textures(openingPages), hasLength(2));
        expect(disposed.where(_isEdgeImage), isEmpty);
        expect(disposed.where(_isFullPageImage), isEmpty);

        await tester.pumpAndSettle();
        expect(disposed.where(_isEdgeImage), orderedEquals(openingEdges));
        expect(disposed.where(_isFullPageImage), unorderedEquals(openingPages));
        flight.navigator.pop();
        await tester.pump();
        await _pumpFrames(tester, 10);
        final allEdges = created.where(_isEdgeImage).toList();
        final allPages = created.where(_isFullPageImage).toList();
        expect(allEdges, isEmpty);
        expect(allPages, hasLength(6));
        expect(_textures(allPages), hasLength(4));
        expect(disposed.where(_isEdgeImage), orderedEquals(openingEdges));
        expect(disposed.where(_isFullPageImage), unorderedEquals(openingPages));

        await tester.pumpAndSettle();
        expect(disposed.where(_isEdgeImage), orderedEquals(allEdges));
        expect(disposed.where(_isFullPageImage), unorderedEquals(allPages));
        await tester.pumpWidget(const SizedBox());
      });
    },
  );

  _testWidgets(
    'when push disables snapshotting, updated content should paint live without page or edge captures',
    (
      tester,
    ) async {
      const initialColor = Color(0xFF0055FF);
      const updatedColor = Color(0xFFFFB000);
      final contentColor = ValueNotifier(initialColor);
      addTearDown(contentColor.dispose);
      await _trackImages((created, disposed) async {
        final readbacks = <int>{};
        bool isPageCapture(_ImageCapture image) => _isPageImage(image) && !readbacks.contains(image.identity);
        await _pumpFlight(
          tester,
          transition: const .push(),
          allowSnapshotting: false,
          destination: ValueListenableBuilder<Color>(
            valueListenable: contentColor,
            builder: (_, color, _) => ColoredBox(key: _destinationKey, color: color),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(await _pixelColor(tester, const Offset(200, 550), onReadback: readbacks.add), initialColor);
        expect(created.where(_isEdgeImage), isEmpty);
        expect(created.where(isPageCapture), isEmpty);

        contentColor.value = updatedColor;
        await tester.pump(const Duration(milliseconds: 16));
        expect(await _pixelColor(tester, const Offset(200, 550), onReadback: readbacks.add), updatedColor);
        await _pumpFrames(tester, 6);
        expect(created.where(_isEdgeImage), isEmpty);
        expect(created.where(isPageCapture), isEmpty);
        await tester.pumpAndSettle();
        expect(disposed.where(_isEdgeImage), isEmpty);
        expect(disposed.where(isPageCapture), isEmpty);
        await tester.pumpWidget(const SizedBox());
      });
    },
  );

  _testWidgets(
    'when snapshotted push content changes, it should remain frozen until landing and then show the update',
    (
      tester,
    ) async {
      const initialColor = Color(0xFF0055FF);
      const updatedColor = Color(0xFFFFB000);
      final contentColor = ValueNotifier(initialColor);
      addTearDown(contentColor.dispose);
      await _trackImages((created, disposed) async {
        final readbacks = <int>{};
        bool isPageCapture(_ImageCapture image) => _isFullPageImage(image) && !readbacks.contains(image.identity);
        await _pumpFlight(
          tester,
          transition: const .push(),
          destination: ValueListenableBuilder<Color>(
            valueListenable: contentColor,
            builder: (_, color, _) => ColoredBox(key: _destinationKey, color: color),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(await _pixelColor(tester, const Offset(200, 550), onReadback: readbacks.add), initialColor);
        expect(created.where(isPageCapture), hasLength(3));
        expect(_textures(created.where(isPageCapture)), hasLength(2));

        contentColor.value = updatedColor;
        await tester.pump(const Duration(milliseconds: 16));
        expect(await _pixelColor(tester, const Offset(200, 550), onReadback: readbacks.add), initialColor);
        await _pumpFrames(tester, 6);
        expect(created.where(isPageCapture), hasLength(3));
        expect(_textures(created.where(isPageCapture)), hasLength(2));
        expect(disposed.where(isPageCapture), isEmpty);
        await tester.pumpAndSettle();
        expect(await _pixelColor(tester, const Offset(200, 550), onReadback: readbacks.add), updatedColor);
        expect(disposed.where(isPageCapture), unorderedEquals(created.where(isPageCapture)));
        await tester.pumpWidget(const SizedBox());
      });
    },
  );

  _testWidgets('when push contains a native platform layer, it should retain live painting and stop capture retries', (
    tester,
  ) async {
    var nativePaints = 0;
    var rasterizationChecks = 0;
    await _trackImages((created, disposed) async {
      final flight = await _pumpFlight(
        tester,
        transition: const .push(),
        sourceAllowSnapshotting: false,
        destination: PlatformViewLayerFixture(
          onPaint: () => nativePaints++,
          onRasterizationCheck: () => rasterizationChecks++,
        ),
      );
      await _pumpFrames(tester, 2);
      expect(nativePaints, greaterThan(0));
      expect(rasterizationChecks, greaterThan(0));
      expect(_hasPlatformViewLayer(tester.binding.renderViews.single.debugLayer), isTrue);
      final openingChecks = rasterizationChecks;
      await _pumpFrames(tester, 8);
      expect(rasterizationChecks, openingChecks);
      expect(created, isEmpty);
      await tester.pumpAndSettle();

      flight.navigator.pop();
      await tester.pump();
      await _pumpFrames(tester, 2);
      expect(rasterizationChecks, greaterThan(openingChecks));
      final returningChecks = rasterizationChecks;
      await _pumpFrames(tester, 8);
      expect(rasterizationChecks, returningChecks);
      expect(created, isEmpty);
      await tester.pumpAndSettle();
      expect(disposed, isEmpty);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  });

  _testWidgets('when push viewport or pixel density changes, it should refresh captures once and release old images', (
    tester,
  ) async {
    await _trackImages((created, disposed) async {
      await _pumpFlight(
        tester,
        transition: const .push(),
        destination: ColoredBox(color: _theme.colorScheme.accent),
      );
      await _pumpFrames(tester, 2);
      final initialPages = created.where(_isPageImage).toList();
      expect(initialPages, hasLength(3));
      expect(_textures(initialPages), hasLength(2));

      tester.view.physicalSize = const Size(480, 720);
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 16));
      final resizedPages = created.where((image) => image.width == 480 && image.height == 720).toList();
      expect(resizedPages, hasLength(3));
      expect(_textures(resizedPages), hasLength(2));
      expect(disposed.where(_isPageImage), unorderedEquals(initialPages));
      await _pumpFrames(tester, 3);
      expect(created.where(_isPageImage), hasLength(6));
      expect(_textures(created.where(_isPageImage)), hasLength(4));

      tester.view
        ..devicePixelRatio = 2
        ..physicalSize = const Size(960, 1440);
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 16));
      final denserPages = created.where((image) => image.width == 960 && image.height == 1440).toList();
      expect(denserPages, hasLength(3));
      expect(_textures(denserPages), hasLength(2));
      expect(disposed.where(_isPageImage), unorderedEquals([...initialPages, ...resizedPages]));
      await _pumpFrames(tester, 3);
      expect(created.where(_isPageImage), hasLength(9));
      expect(_textures(created.where(_isPageImage)), hasLength(6));

      await tester.pumpAndSettle();
      expect(disposed, unorderedEquals(created));
      await tester.pumpWidget(const SizedBox());
    });
  });

  _testWidgets('when a push route is removed during capture, it should release every image without landing first', (
    tester,
  ) async {
    await _trackImages((created, disposed) async {
      final flight = await _pumpFlight(
        tester,
        transition: const .push(),
        destination: ColoredBox(color: _theme.colorScheme.accent),
      );
      await _pumpFrames(tester, 2);
      expect(created.where(_isPageImage), hasLength(3));
      expect(_textures(created.where(_isPageImage)), hasLength(2));
      expect(created.where(_isEdgeImage), isEmpty);
      flight.navigator.removeRoute(flight.route);
      await tester.pumpAndSettle();
      expect(disposed, unorderedEquals(created));
      expect(flight.navigator.userGestureInProgress, isFalse);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  });

  _testWidgets('when a same-key push disables snapshots during motion, it should retain route and interactive state', (
    tester,
  ) async {
    _configureView(tester);
    const source = MateoPage<void>(
      key: ValueKey('source page'),
      transition: .push(),
      child: SizedBox.expand(),
    );
    const destinationKey = ValueKey('destination page');
    const counter = AppTestCounter();
    final pages = ValueNotifier<List<Page<void>>>([source]);
    addTearDown(pages.dispose);
    await _trackImages((created, disposed) async {
      await tester.pumpWidget(
        MateoApp(
          theme: _theme,
          home: ValueListenableBuilder<List<Page<void>>>(
            valueListenable: pages,
            builder: (_, value, _) => Navigator(
              pages: value,
              onDidRemovePage: (page) => pages.value = [...pages.value]..remove(page),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      pages.value = [source, const MateoPage<void>(key: destinationKey, transition: .push(), child: counter)];
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      final originalRoute = ModalRoute.of(tester.element(find.byType(AppTestCounter)));
      final originalState = tester.state(find.byType(AppTestCounter));
      await tester.tap(find.text('Count: 0'));
      await tester.pump();
      expect(find.text('Count: 1'), findsOneWidget);
      expect(created.where(_isPageImage), hasLength(3));
      expect(_textures(created.where(_isPageImage)), hasLength(2));
      pages.value = [
        source,
        const MateoPage<void>(key: destinationKey, transition: .push(), allowSnapshotting: false, child: counter),
      ];
      await tester.pump();
      expect(ModalRoute.of(tester.element(find.byType(AppTestCounter))), same(originalRoute));
      expect(tester.state(find.byType(AppTestCounter)), same(originalState));
      expect(find.text('Count: 1'), findsOneWidget);
      expect(disposed.where(_isEdgeImage), isEmpty);
      expect(disposed.where(_isPageImage), hasLength(2));
      await _pumpFrames(tester, 3);
      expect(created.where(_isPageImage), hasLength(3));
      await tester.pumpAndSettle();
      expect(disposed, unorderedEquals(created));
      await tester.tap(find.text('Count: 1'));
      await tester.pump();
      expect(find.text('Count: 2'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  });

  _testWidgets('when push is dragged back, its accessibility bounds should follow each translated position', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      final flight = await _pumpFlight(
        tester,
        transition: const .push(direction: .left),
        destination: _actionContent(onTap: () {}),
      );
      await tester.pumpAndSettle();
      flight.route.handleStartBackGesture(progress: 1);
      for (final progress in [0.8, 0.6]) {
        flight.route.handleUpdateBackGestureProgress(progress: progress);
        await tester.pump();
        final visibleBounds = tester.getRect(find.byKey(_actionKey));
        final node = tester.getSemantics(find.bySemanticsLabel('Destination action'));
        final semanticBounds = _globalSemanticBounds(node);
        expect(semanticBounds.left, closeTo(visibleBounds.left, 1e-8));
        expect(semanticBounds.top, closeTo(visibleBounds.top, 1e-8));
        expect(semanticBounds.size, visibleBounds.size);
      }
      flight.route.handleCancelBackGesture();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  _testWidgets('when a push adapter moves a control, taps should follow its painted position', (tester) async {
    final controller = AnimationController(vsync: tester, value: 1);
    final route = PageRouteBuilder<void>(pageBuilder: (_, _, _) => const SizedBox());
    addTearDown(controller.dispose);
    addTearDown(route.dispose);
    var taps = 0;
    _configureView(tester);
    await tester.pumpWidget(
      MateoApp(
        theme: _theme,
        home: Builder(
          builder: (context) =>
              const MateoPageTransitionsBuilder(
                transition: .push(direction: .left),
              ).buildTransitions(
                route,
                context,
                controller,
                kAlwaysDismissedAnimation,
                _actionContent(onTap: () => taps++),
              ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (final progress in [0.8, 0.6]) {
      controller.value = progress;
      await tester.pump();
      await tester.tapAt(tester.getCenter(find.byKey(_actionKey)));
    }
    expect(taps, 2);
    await tester.pumpWidget(const SizedBox());
  });

  _testWidgets(
    'when push adapter animation changes on consecutive frames, semantics should follow without rebuilding',
    (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final controller = AnimationController(vsync: tester, value: 1);
      final route = PageRouteBuilder<void>(allowSnapshotting: false, pageBuilder: (_, _, _) => const SizedBox());
      addTearDown(controller.dispose);
      addTearDown(route.dispose);
      var adapterBuilds = 0;
      try {
        _configureView(tester);
        await tester.pumpWidget(
          MateoApp(
            theme: _theme,
            home: Builder(
              builder: (context) {
                adapterBuilds++;
                return const MateoPageTransitionsBuilder(transition: .push(direction: .left)).buildTransitions(
                  route,
                  context,
                  controller,
                  kAlwaysDismissedAnimation,
                  _actionContent(onTap: () {}),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        final initialBuilds = adapterBuilds;
        for (final progress in [0.8, 0.6]) {
          controller.value = progress;
          await tester.pump();
          final visibleBounds = tester.getRect(find.byKey(_actionKey));
          final node = tester.getSemantics(find.bySemanticsLabel('Destination action'));
          final semanticBounds = _globalSemanticBounds(node);
          expect(adapterBuilds, initialBuilds);
          expect(semanticBounds.left, closeTo(visibleBounds.left, 1e-8));
          expect(semanticBounds.top, closeTo(visibleBounds.top, 1e-8));
          expect(semanticBounds.size, visibleBounds.size);
        }
        await tester.pumpWidget(const SizedBox());
      } finally {
        semantics.dispose();
      }
    },
  );

  _testWidgets('when wash opens and returns, it should capture its full page once per flight', (tester) async {
    await _trackImages((created, disposed) async {
      final flight = await _pumpFlight(
        tester,
        transition: const .wash(),
        destination: ColoredBox(color: _theme.colorScheme.accent),
      );
      await _pumpFrames(tester, 10);
      final openingSnapshots = created.where(_isFullPageImage).toList();
      expect(openingSnapshots, hasLength(1));
      expect(disposed.where(_isFullPageImage), isEmpty);
      await tester.pumpAndSettle();
      expect(disposed.where(_isFullPageImage), orderedEquals(openingSnapshots));

      flight.navigator.pop();
      await tester.pump();
      await _pumpFrames(tester, 10);
      final allSnapshots = created.where(_isFullPageImage).toList();
      expect(allSnapshots, hasLength(2));
      await tester.pumpAndSettle();
      expect(disposed.where(_isFullPageImage), orderedEquals(allSnapshots));
      await tester.pumpWidget(const SizedBox());
    });
  });
}

void _testWidgets(String description, WidgetTesterCallback callback) {
  testWidgets(description, (tester) async {
    final previousPlatform = debugDefaultTargetPlatformOverride;
    debugDefaultTargetPlatformOverride = .android;
    try {
      await callback(tester);
    } finally {
      debugDefaultTargetPlatformOverride = previousPlatform;
    }
  });
}

Map<String, int> _counts() => {'builds': 0, 'layouts': 0, 'paints': 0};

const ({Color first, Color second}) _topEdgeColors = (first: Color(0xFFFF0000), second: Color(0xFF0000FF));
const ({Color first, Color second}) _bottomEdgeColors = (first: Color(0xFF00FF00), second: Color(0xFFFF00FF));
const ({Color first, Color second}) _leftEdgeColors = (first: Color(0xFF00FFFF), second: Color(0xFFFFFF00));
const ({Color first, Color second}) _rightEdgeColors = (first: Color(0xFFFF8000), second: Color(0xFF8000FF));

Widget _patternedDestination() => Stack(
  fit: .expand,
  children: [
    const ColoredBox(color: Color(0xFFFFFFFF)),
    Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 1,
      child: Row(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(child: ColoredBox(color: _topEdgeColors.first)),
          Expanded(child: ColoredBox(color: _topEdgeColors.second)),
        ],
      ),
    ),
    Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 1,
      child: Row(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(child: ColoredBox(color: _bottomEdgeColors.first)),
          Expanded(child: ColoredBox(color: _bottomEdgeColors.second)),
        ],
      ),
    ),
    Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      width: 1,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(child: ColoredBox(color: _leftEdgeColors.first)),
          Expanded(child: ColoredBox(color: _leftEdgeColors.second)),
        ],
      ),
    ),
    Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      width: 1,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(child: ColoredBox(color: _rightEdgeColors.first)),
          Expanded(child: ColoredBox(color: _rightEdgeColors.second)),
        ],
      ),
    ),
  ],
);

Widget _countedContent({required Map<String, int> counts, required Color color}) => Builder(
  builder: (_) {
    counts['builds'] = counts['builds']! + 1;
    return LayoutCounter(
      onLayout: () => counts['layouts'] = counts['layouts']! + 1,
      child: CustomPaint(
        painter: PaintCounter(onPaint: () => counts['paints'] = counts['paints']! + 1, color: color),
        child: const SizedBox.expand(),
      ),
    );
  },
);

Widget _actionContent({required VoidCallback onTap}) => Center(
  child: Semantics(
    container: true,
    label: 'Destination action',
    button: true,
    onTap: onTap,
    child: GestureDetector(
      excludeFromSemantics: true,
      behavior: .opaque,
      onTap: onTap,
      child: const SizedBox(key: _actionKey, width: 48, height: 48),
    ),
  ),
);

void _configureView(WidgetTester tester) {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = const Size(400, 600);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

Future<({NavigatorState navigator, PageRoute<void> route})> _pumpFlight(
  WidgetTester tester, {
  required MateoPageTransition transition,
  required Widget destination,
  Widget? source,
  bool allowSnapshotting = true,
  bool? sourceAllowSnapshotting,
}) async {
  _configureView(tester);
  final navigatorKey = GlobalKey<NavigatorState>();
  await tester.pumpWidget(
    MateoApp(
      theme: _theme,
      builder: (_, child) => RepaintBoundary(key: _captureKey, child: child),
      home: Builder(
        builder: (context) => Navigator(
          key: navigatorKey,
          onGenerateRoute: (_) => MateoPage<void>(
            transition: transition,
            allowSnapshotting: sourceAllowSnapshotting ?? allowSnapshotting,
            child: source ?? ColoredBox(color: _theme.colorScheme.background),
          ).createRoute(context),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final navigator = navigatorKey.currentState!;
  final route = MateoPage<void>(
    transition: transition,
    allowSnapshotting: allowSnapshotting,
    child: destination,
  ).createRoute(navigator.context);
  navigator.push(route);
  await tester.pump();
  return (navigator: navigator, route: route);
}

Future<void> _pumpFrames(WidgetTester tester, int count) async {
  for (var frame = 0; frame < count; frame++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

typedef _ImageCapture = ({int identity, int textureIdentity, int width, int height});

bool _isEdgeImage(_ImageCapture image) => image.width == 1 || image.height == 1;
bool _isFullPageImage(_ImageCapture image) => image.width == 400 && image.height == 600;
bool _isPageImage(_ImageCapture image) => image.width > 1 && image.height > 1;
Set<int> _textures(Iterable<_ImageCapture> images) => images.map((image) => image.textureIdentity).toSet();

Future<void> _trackImages(Future<void> Function(List<_ImageCapture>, List<_ImageCapture>) run) async {
  final created = <_ImageCapture>[];
  final disposed = <_ImageCapture>[];
  final handles = <ui.Image>[];
  final previousCreate = ui.Image.onCreate;
  final previousDispose = ui.Image.onDispose;
  ui.Image.onCreate = (image) {
    final identity = identityHashCode(image);
    var textureIdentity = identity;
    for (var index = 0; index < handles.length; index++) {
      if (image.isCloneOf(handles[index])) {
        textureIdentity = created[index].textureIdentity;
        break;
      }
    }
    handles.add(image);
    created.add((identity: identity, textureIdentity: textureIdentity, width: image.width, height: image.height));
    previousCreate?.call(image);
  };
  ui.Image.onDispose = (image) {
    final identity = identityHashCode(image);
    disposed.add(
      created.firstWhere(
        (capture) => capture.identity == identity,
        orElse: () => (identity: identity, textureIdentity: identity, width: image.width, height: image.height),
      ),
    );
    previousDispose?.call(image);
  };
  try {
    await run(created, disposed);
  } finally {
    ui.Image.onCreate = previousCreate;
    ui.Image.onDispose = previousDispose;
  }
}

Future<Color> _pixelColor(WidgetTester tester, Offset position, {void Function(int)? onReadback}) async =>
    (await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_captureKey));
      final image = await boundary.toImage();
      onReadback?.call(identityHashCode(image));
      try {
        final bytes = (await image.toByteData(format: .rawRgba))!;
        final offset = (position.dy.floor() * image.width + position.dx.floor()) * 4;
        return Color.fromARGB(
          bytes.getUint8(offset + 3),
          bytes.getUint8(offset),
          bytes.getUint8(offset + 1),
          bytes.getUint8(offset + 2),
        );
      } finally {
        image.dispose();
      }
    }))!;

Rect _globalSemanticBounds(SemanticsNode node) {
  var transform = Matrix4.identity();
  SemanticsNode? current = node;
  while (current != null) {
    if (current.transform != null) transform = current.transform!.clone()..multiply(transform);
    current = current.parent;
  }
  return MatrixUtils.transformRect(transform, node.rect);
}

bool _hasPlatformViewLayer(Layer? layer) {
  if (layer is PlatformViewLayer) return true;
  if (layer is! ContainerLayer) return false;
  var child = layer.firstChild;
  while (child != null) {
    if (_hasPlatformViewLayer(child)) return true;
    child = child.nextSibling;
  }
  return false;
}
