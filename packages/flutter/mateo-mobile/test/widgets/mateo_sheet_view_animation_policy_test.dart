import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/foundation/mateo_sheet_to_view_transition/mateo_sheet_to_view_transition.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  const destinationKey = ValueKey('destination surface');
  void testPolicy(String description, WidgetTesterCallback callback) {
    testWidgets(description, (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await callback(tester);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  }

  Future<NavigatorState> mount(WidgetTester tester, {Widget home = const Text('Home'), bool morphs = true}) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MorphScope(
        enabled: morphs,
        child: MateoApp(
          theme: surfaceTransformTheme,
          navigatorKey: navigator,
          builder: (_, child) => RepaintBoundary(key: const ValueKey('policy capture'), child: child),
          home: home,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return navigator.currentState!;
  }

  Future<NavigatorState> openSheet(
    WidgetTester tester, {
    bool morphs = true,
  }) async {
    final navigator = await mount(tester, morphs: morphs);
    unawaited(
      showMateoSheet<void>(
        context: tester.element(find.text('Home')),
        maxExtent: 380,
        view: const MateoSheetView(
          surface: MateoSheetViewSurface(
            child: SizedBox(height: 200, child: Text('Sheet')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return navigator;
  }

  Widget view(MateoViewAnimation? animation, {Widget child = const Text('Destination')}) => MateoView(
    padding: .zero,
    animation: animation,
    surface: MateoViewSurface(key: destinationKey, child: child),
  );

  PageRoute<void> push(NavigatorState navigator, Widget child, {MateoPageTransition? transition}) {
    final route = MateoPage<void>(transition: transition, child: child).createRoute(navigator.context);
    navigator.push(route);
    return route;
  }

  Future<void> start(WidgetTester tester) async {
    await tester.pump();
    await tester.pump();
    await tester.pump();
  }

  ({double scale, double opacity}) entrance(WidgetTester tester, Finder surface) {
    final finder = find.descendant(of: surface, matching: find.byType(Motion)).first;
    final motion = tester.widget<Motion>(finder);
    final content = tester.renderObject(find.byKey(motion.child.key!));
    final renderObject = tester.renderObject(finder);
    return (
      scale: content.getTransformTo(renderObject).entry(0, 0),
      opacity:
          renderObject.toDiagnosticsNode().getProperties().firstWhere((property) => property.name == 'opacity').value!
              as double,
    );
  }

  Matcher matchesSize(Size expected) => isA<Size>()
      .having((size) => size.width, 'width', closeTo(expected.width, .000001))
      .having((size) => size.height, 'height', closeTo(expected.height, .000001));

  List<Positioned> flightLayers(WidgetTester tester) {
    final flight = tester.widget<DecoratedBox>(surfaceFlight);
    return ((flight.child! as ClipPath).child! as Stack).children.cast<Positioned>();
  }

  for (final explicit in [false, true]) {
    testPolicy(
      'when editable content lands after an automatic transform with explicit motion=$explicit, it should repaint live text',
      (tester) async {
        final controller = TextEditingController();
        final focus = FocusNode();
        final changes = <String>[];
        final semantics = tester.ensureSemantics();
        addTearDown(controller.dispose);
        addTearDown(focus.dispose);
        try {
          final navigator = await openSheet(tester);
          push(
            navigator,
            view(
              explicit ? MateoViewAnimation.transform(target: MateoTransformTarget()) : null,
              child: Align(
                alignment: .topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: MateoTextInput(
                    placeholder: 'Name',
                    presentation: const .search(variant: .filled),
                    autofocus: false,
                    controller: controller,
                    focusNode: focus,
                    onChanged: changes.add,
                  ),
                ),
              ),
            ),
            transition: explicit ? const .wash() : null,
          );
          await tester.pumpAndSettle();
          final region = tester.getRect(find.byType(EditableText));
          Future<List<int>> textPixels() async {
            final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(const ValueKey('policy capture')));
            final image = await boundary.toImage();
            try {
              final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
              final origin = boundary.globalToLocal(region.topLeft);
              final left = origin.dx.round();
              final top = origin.dy.round();
              final width = region.width.floor();
              final height = region.height.floor();
              return [
                for (var row = top; row < top + height; row++)
                  ...bytes.sublist((row * image.width + left) * 4, (row * image.width + left + width) * 4),
              ];
            } finally {
              image.dispose();
            }
          }

          final emptyPixels = (await tester.runAsync(textPixels))!;
          controller.text = 'Emily Long Contact Name';
          await tester.pumpAndSettle();
          final updatedPixels = (await tester.runAsync(textPixels))!;
          final programmaticText = tester.getSemantics(find.byType(EditableText)).getSemanticsData().value;
          await tester.tap(find.byType(EditableText));
          await tester.pump();
          final focused = focus.hasFocus;
          await tester.enterText(find.byType(EditableText), 'Zoe');
          await tester.pump();
          final typedText = tester.getSemantics(find.byType(EditableText)).getSemanticsData().value;
          focus.unfocus();
          await tester.pumpAndSettle();
          final typedPixels = (await tester.runAsync(textPixels))!;
          expect(
            [
              listEquals(emptyPixels, updatedPixels),
              listEquals(updatedPixels, typedPixels),
              programmaticText,
              typedText,
              focused,
              changes,
            ],
            [
              false,
              false,
              'Emily Long Contact Name',
              'Zoe',
              true,
              ['Zoe'],
            ],
          );
        } finally {
          semantics.dispose();
        }
      },
    );
  }

  testPolicy(
    'when automatic motion wins, it should ignore explicit timing shape and content effects in both directions',
    (
      tester,
    ) async {
      final target = MateoTransformTarget(duration: const Duration(seconds: 2), curve: Curves.linear);
      final animation = MateoViewAnimation.transform(
        target: target,
        shape: const .rounded(radius: 8),
        contentEffects: const [],
      );
      final navigator = await openSheet(tester);
      final sourceSize = tester.getSize(find.byType(MateoSheetViewSurface));
      final route = push(navigator, view(animation));
      await start(tester);
      final destinationSize = tester.getSize(find.byKey(destinationKey));
      final results = <Object>[];
      for (final returning in [false, true]) {
        if (returning) {
          navigator.pop();
          await start(tester);
        }
        await tester.pump(const Duration(milliseconds: 160));
        final shape = surfaceTransformAnimationFlightDecoration(tester).shape;
        final bounds = tester.getSize(surfaceFlight);
        final layers = flightLayers(tester);
        expectSurfaceOutline(
          shape.getOuterPath(Offset.zero & bounds),
          const MateoRoundedShapeBorder(radius: 42).getOuterPath(Offset.zero & bounds),
        );
        results.add([
          layers.map((layer) => Size(layer.width!, layer.height!)).toList(),
          route.transitionDuration,
        ]);
        await tester.pumpAndSettle();
      }
      expect(results, [
        [
          [matchesSize(sourceSize), matchesSize(destinationSize)],
          kSheetToViewTransformAnimation.duration,
        ],
        [
          [matchesSize(destinationSize), matchesSize(sourceSize)],
          kSheetToViewTransformAnimation.duration,
        ],
      ]);
    },
  );

  testPolicy('when ordinary views share an explicit target, it should use their shape effects and timing', (
    tester,
  ) async {
    final target = MateoTransformTarget(duration: const Duration(seconds: 2), curve: Curves.linear);
    final animation = MateoViewAnimation.transform(
      target: target,
      shape: const .rounded(radius: 8),
      contentEffects: const [],
    );
    final navigator = await mount(tester, home: view(animation, child: const Text('Source')));
    final firstMorph = tester.widget<Morph>(find.byType(Morph));
    final explicitTarget = firstMorph.targets[1];
    push(navigator, view(animation));
    await start(tester);
    await tester.pump(const Duration(milliseconds: 500));
    final shape = surfaceTransformAnimationFlightDecoration(tester).shape;
    final destinationMorph = tester.widget<Morph>(
      find.ancestor(of: find.text('Destination'), matching: find.byType(Morph)),
    );
    expect(
      (
        shape is MateoRoundedShapeBorder ? shape.resolveRadius(tester.getSize(surfaceFlight)) : null,
        flightLayers(tester).length,
        identical(destinationMorph.targets[1], explicitTarget),
        explicitTarget.duration,
        explicitTarget.curve,
        explicitTarget.status.value,
      ),
      (8.0, 1, true, const Duration(seconds: 2), Curves.linear, MorphTagStatus.flying),
    );
    await tester.pumpAndSettle();
  });

  testPolicy(
    'when ordinary surfaces are nested in a view, it should preserve none and pop without automatic registration',
    (
      tester,
    ) async {
      const plainKey = ValueKey('plain nested');
      const popKey = ValueKey('pop nested');
      final visible = ValueNotifier(false);
      addTearDown(visible.dispose);
      await mount(
        tester,
        home: view(
          null,
          child: ValueListenableBuilder<bool>(
            valueListenable: visible,
            builder: (_, showPop, _) => Column(
              children: [
                const MateoSurface(key: plainKey, animation: .none(), child: Text('Plain')),
                if (showPop)
                  const MateoSurface(
                    key: popKey,
                    animation: .pop(duration: Duration(seconds: 2), curve: Curves.linear),
                    child: Text('Nested entrance'),
                  ),
              ],
            ),
          ),
        ),
      );
      visible.value = true;
      await tester.pump();
      final initial = entrance(tester, find.byKey(popKey));
      await tester.pump(const Duration(seconds: 1));
      expect(
        (
          find.descendant(of: find.byKey(plainKey), matching: find.byType(Morph)).evaluate().length,
          find.descendant(of: find.byKey(popKey), matching: find.byType(Morph)).evaluate().length,
          find.text('Plain').hitTestable().evaluate().length,
          initial,
          entrance(tester, find.byKey(popKey)),
        ),
        (0, 0, 1, (scale: .75, opacity: 0.0), (scale: .875, opacity: .5)),
      );
      await tester.pumpAndSettle();
    },
  );

  for (final retainSource in [false, true]) {
    testPolicy(
      'when a nested ordinary transform has retained source=$retainSource, it should animate',
      (
        tester,
      ) async {
        final target = MateoTransformTarget(duration: const Duration(seconds: 1), curve: Curves.linear);
        final expanded = ValueNotifier(false);
        addTearDown(expanded.dispose);
        await mount(
          tester,
          home: view(
            null,
            child: ValueListenableBuilder<bool>(
              valueListenable: expanded,
              builder: (_, value, _) => Stack(
                children: [
                  if (!value || retainSource)
                    Align(
                      child: MateoSurface(
                        key: const ValueKey('source'),
                        width: const .custom(100),
                        height: const .custom(100),
                        animation: .transform(target: target, shape: const .rounded(radius: 6)),
                        child: const Text('Nested transform'),
                      ),
                    ),
                  if (value)
                    Align(
                      child: MateoSurface(
                        key: const ValueKey('destination'),
                        width: const .custom(200),
                        height: const .custom(200),
                        animation: .transform(target: target, shape: const .rounded(radius: 6)),
                        child: const Text('Nested transform'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
        expanded.value = true;
        await start(tester);
        expect(surfaceFlight, findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pump(const Duration(milliseconds: 500));
        final shape = surfaceTransformAnimationFlightDecoration(tester).shape;
        expect(
          (
            tester.getSize(surfaceFlight),
            shape is MateoRoundedShapeBorder ? shape.resolveRadius(tester.getSize(surfaceFlight)) : null,
          ),
          (const Size(150, 150), 6.0),
        );
        await tester.pumpAndSettle();
      },
    );
  }
}
