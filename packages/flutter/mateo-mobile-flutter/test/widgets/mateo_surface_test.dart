import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../test_app.dart';

void main() {
  group('MateoSurface', () {
    test('defines conservative ordinary and scrollable defaults', () {
      const ordinary = MateoSurface(child: SizedBox());
      const scrollable = MateoSurface.scrollable(child: SizedBox());

      expect(ordinary.boundaryEffect, isNull);
      expect(ordinary.elevation, 0);
      expect(ordinary.borderRadius, BorderRadius.zero);
      expect(scrollable.boundaryEffect, const MateoBoundaryEffect.fade());
      expect(
        scrollable.keyboardViewportBehavior,
        MateoSurfaceKeyboardViewportBehavior.resize,
      );
    });

    test('rejects elevation outside the Mateo range', () {
      expect(
        () => MateoSurface(child: const SizedBox(), elevation: -0.1),
        throwsAssertionError,
      );
      expect(
        () => MateoSurface(child: const SizedBox(), elevation: 2.1),
        throwsAssertionError,
      );
    });

    testWidgets('sizes naturally in loose constraints', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: MateoSurface(
            key: ValueKey('surface'),
            child: SizedBox(width: 120, height: 80),
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const ValueKey('surface'))),
        const Size(120, 80),
      );
    });

    testWidgets('expands under tight constraints', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: SizedBox(
            width: 240,
            height: 160,
            child: MateoSurface(
              key: ValueKey('surface'),
              child: SizedBox(),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const ValueKey('surface'))),
        const Size(240, 160),
      );
    });

    testWidgets('nested ordinary surfaces preserve intrinsic sizing', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: Center(
            child: MateoSurface(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: IntrinsicWidth(
                  child: MateoSurface(
                    key: ValueKey('nested-surface'),
                    child: SizedBox(width: 120, height: 48),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byKey(const ValueKey('nested-surface'))),
        const Size(120, 48),
      );
    });

    testWidgets('owns color, radius, clipping, and fractional elevation', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: SizedBox(
            width: 240,
            height: 160,
            child: MateoSurface(
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(28)),
              elevation: 1.5,
              child: SizedBox.expand(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(MateoSurface),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, Colors.amber);
      expect(decoration.borderRadius, BorderRadius.circular(28));
      expect(decoration.boxShadow, isNotEmpty);
      expect(container.clipBehavior, Clip.antiAlias);
    });

    testWidgets('resolves boundary depth from its local extent', (
      tester,
    ) async {
      await _pumpBoundedSurface(
        tester,
        height: 400,
        surface: const MateoSurface(
          boundaryEffect: MateoBoundaryEffect.fade(),
          child: SizedBox.expand(),
        ),
      );

      expect(
        _surfaceBoundaryFadeExtents(tester),
        const [64, 64],
      );
    });

    testWidgets('preserves a clear center on a small two-sided surface', (
      tester,
    ) async {
      await _pumpBoundedSurface(
        tester,
        height: 120,
        surface: const MateoSurface(
          boundaryEffect: MateoBoundaryEffect.fade(),
          child: SizedBox.expand(),
        ),
      );

      expect(
        _surfaceBoundaryFadeExtents(tester),
        const [40, 40],
      );
    });

    testWidgets('uses an alpha mask for a translucent surface', (
      tester,
    ) async {
      await _pumpBoundedSurface(
        tester,
        height: 240,
        surface: const MateoSurface(
          color: Color(0x80FFFFFF),
          boundaryEffect: MateoBoundaryEffect.fade(
            top: true,
            bottom: false,
          ),
          child: SizedBox.expand(),
        ),
      );

      expect(find.byType(ShaderMask), findsOneWidget);
      expect(_surfaceBoundaryFadeFinder('top'), findsNothing);
      expect(_surfaceBoundaryFadeFinder('bottom'), findsNothing);
      expect(
        tester.widget<ShaderMask>(find.byType(ShaderMask)).blendMode,
        BlendMode.dstIn,
      );
    });

    testWidgets('keeps boundary effects pointer-transparent and semantic-free', (
      tester,
    ) async {
      var taps = 0;
      final semantics = tester.ensureSemantics();
      await _pumpBoundedSurface(
        tester,
        height: 240,
        surface: MateoSurface(
          boundaryEffect: const MateoBoundaryEffect.fade(),
          child: Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => taps += 1,
              child: Semantics(
                button: true,
                label: 'Content action',
                child: const SizedBox(width: 120, height: 64),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.bySemanticsLabel('Content action'));
      expect(taps, 1);
      expect(find.bySemanticsLabel('Content action'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('fade', caseSensitive: false)),
        findsNothing,
      );
      semantics.dispose();
    });

    testWidgets('fills short scrollable content so flex children work', (
      tester,
    ) async {
      await _pumpBoundedSurface(
        tester,
        height: 300,
        surface: const MateoSurface.scrollable(
          boundaryEffect: null,
          child: Column(
            children: [
              Text('Start'),
              Spacer(),
              Text('End', key: ValueKey('end')),
            ],
          ),
        ),
      );

      expect(tester.getBottomRight(find.byKey(const ValueKey('end'))).dy, 450);
      expect(_primaryController(tester).position.maxScrollExtent, 0);
    });

    testWidgets('scrolls only when managed content overflows', (tester) async {
      await _pumpBoundedSurface(
        tester,
        height: 300,
        surface: const MateoSurface.scrollable(
          boundaryEffect: null,
          child: SizedBox(height: 900),
        ),
      );

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -180));
      await tester.pump();
      expect(_primaryController(tester).offset, greaterThan(0));
    });

    testWidgets('publishes its private controller as the primary controller', (
      tester,
    ) async {
      await _pumpBoundedSurface(
        tester,
        height: 300,
        surface: const MateoSurface.scrollable(
          boundaryEffect: null,
          child: SizedBox(height: 900),
        ),
      );

      final scrollView = tester.widget<CustomScrollView>(
        find.byType(CustomScrollView),
      );
      expect(scrollView.primary, isTrue);
      expect(_primaryController(tester).hasClients, isTrue);
    });

    testWidgets('requires bounded vertical constraints for managed scrolling', (
      tester,
    ) async {
      final errors = <Object>[];
      final previousErrorHandler = FlutterError.onError;
      FlutterError.onError = (details) => errors.add(details.exception);
      addTearDown(() => FlutterError.onError = previousErrorHandler);
      await tester.pumpWidget(
        const TestApp(
          child: UnconstrainedBox(
            constrainedAxis: Axis.horizontal,
            child: MateoSurface.scrollable(
              boundaryEffect: null,
              child: SizedBox(height: 100),
            ),
          ),
        ),
      );

      expect(
        errors.whereType<FlutterError>().map((error) => error.message),
        contains(contains('requires bounded height')),
      );
    });

    testWidgets('grows and shrinks boundary depth with scroll position', (
      tester,
    ) async {
      await _pumpBoundedSurface(
        tester,
        height: 300,
        surface: const MateoSurface.scrollable(
          child: SizedBox(height: 900),
        ),
      );
      await tester.pump();

      final top = tester.renderObject<RenderProxyBox>(
        _surfaceBoundaryRevealFinder('top'),
      );
      final bottom = tester.renderObject<RenderProxyBox>(
        _surfaceBoundaryRevealFinder('bottom'),
      );
      expect(top.paintsChild(top.child!), isFalse);
      expect(bottom.paintsChild(bottom.child!), isTrue);

      _primaryController(tester).jumpTo(300);
      await tester.pump();
      expect(top.paintsChild(top.child!), isTrue);

      _primaryController(tester).jumpTo(
        _primaryController(tester).position.maxScrollExtent,
      );
      await tester.pump();
      expect(bottom.paintsChild(bottom.child!), isFalse);
    });

    testWidgets('maps matched geometry to the fixed internal Morph policy', (
      tester,
    ) async {
      const duration = Duration(milliseconds: 420);
      const curve = Curves.easeIn;
      await _pumpBoundedSurface(
        tester,
        height: 200,
        surface: const MateoSurface(
          animation: MateoSurfaceAnimation.matchedGeometry(
            id: 'surface',
            duration: duration,
            curve: curve,
          ),
          child: Text('Resting endpoint'),
        ),
      );

      final morph = tester.widget<Morph>(find.byType(Morph));
      expect(morph.tag, 'surface');
      expect(morph.duration, duration);
      expect(morph.curve, curve);
      expect(morph.watchDestination, isTrue);
      expect(morph.switchThreshold, 0.5);
      expect(morph.flightDelegate, isNotNull);
      expect(morph.switchTransition, isNull);



      expect(find.text('Resting endpoint'), findsOneWidget);
    });

    testWidgets('completes matched geometry immediately under reduced motion', (
      tester,
    ) async {
      await _pumpBoundedSurface(
        tester,
        height: 200,
        disableAnimations: true,
        surface: const MateoSurface(
          animation: MateoSurfaceAnimation.matchedGeometry(
            id: 'reduced-motion-surface',
            duration: Duration(milliseconds: 420),
          ),
          child: Text('Final content'),
        ),
      );

      expect(tester.widget<Morph>(find.byType(Morph)).duration, Duration.zero);
      expect(find.text('Final content'), findsOneWidget);
    });
  });
}

Finder _surfaceBoundaryFadeFinder(String position) {
  return find.byKey(ValueKey('mateo_surface_boundary_fade_$position'));
}

Finder _surfaceBoundaryRevealFinder(String position) {
  return find.byKey(ValueKey('mateo_surface_boundary_reveal_$position'));
}

List<double> _surfaceBoundaryFadeExtents(WidgetTester tester) {
  return ['top', 'bottom']
      .map(
        (position) => tester.getSize(_surfaceBoundaryFadeFinder(position)).height,
      )
      .toList();
}

Future<void> _pumpBoundedSurface(
  WidgetTester tester, {
  required double height,
  required MateoSurface surface,
  bool disableAnimations = false,
}) async {
  await tester.pumpWidget(
    TestApp(
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: SizedBox(width: 320, height: height, child: surface),
      ),
    ),
  );
}

ScrollController _primaryController(WidgetTester tester) {
  return PrimaryScrollController.of(
    tester.element(find.byType(CustomScrollView)),
  );
}
