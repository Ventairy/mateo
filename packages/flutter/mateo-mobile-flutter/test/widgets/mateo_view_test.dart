import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoView', () {
    testWidgets('keeps its surface full size beneath fixed slots', (
      tester,
    ) async {
      await _pumpView(
        tester,
        header: const SizedBox(key: ValueKey('header'), height: 44),
        footer: const SizedBox(key: ValueKey('footer'), height: 48),
        surface: const MateoSurface(
          key: ValueKey('surface'),
          child: SizedBox(key: ValueKey('content')),
        ),
      );

      expect(
        tester.getRect(find.byKey(const ValueKey('surface'))),
        const Rect.fromLTWH(0, 0, 360, 640),
      );
      expect(
        tester.getRect(find.byKey(const ValueKey('content'))),
        const Rect.fromLTRB(0, 86, 360, 556),
      );
      expect(
        tester.getRect(find.byKey(const ValueKey('header'))),
        const Rect.fromLTWH(20, 42, 320, 44),
      );
      expect(
        tester.getRect(find.byKey(const ValueKey('footer'))),
        const Rect.fromLTWH(20, 556, 320, 48),
      );
    });

    testWidgets('lets ordinary content extend behind selected slots', (
      tester,
    ) async {
      await _pumpView(
        tester,
        extendContentBehindHeader: true,
        extendContentBehindFooter: true,
        header: const SizedBox(height: 44),
        footer: const SizedBox(height: 48),
        surface: const MateoSurface(
          child: SizedBox(key: ValueKey('content')),
        ),
      );

      expect(
        tester.getRect(find.byKey(const ValueKey('content'))),
        const Rect.fromLTWH(0, 0, 360, 640),
      );
    });

    testWidgets('replaces automatic insets with explicit padding', (
      tester,
    ) async {
      await _pumpView(
        tester,
        viewPadding: const EdgeInsets.fromLTRB(44, 30, 10, 24),
        padding: const EdgeInsets.fromLTRB(8, 10, 12, 14),
        header: const SizedBox(key: ValueKey('header'), height: 44),
        footer: const SizedBox(key: ValueKey('footer'), height: 48),
        surface: const MateoSurface(
          child: SizedBox(key: ValueKey('content')),
        ),
      );

      expect(
        tester.getRect(find.byKey(const ValueKey('header'))),
        const Rect.fromLTWH(8, 10, 340, 44),
      );
      expect(
        tester.getRect(find.byKey(const ValueKey('content'))),
        const Rect.fromLTRB(8, 54, 348, 578),
      );
      expect(
        tester.getRect(find.byKey(const ValueKey('footer'))),
        const Rect.fromLTWH(8, 578, 340, 48),
      );
    });

    testWidgets('lays the app overlay across the complete view', (
      tester,
    ) async {
      await _pumpView(
        tester,
        header: const SizedBox(height: 44),
        surface: const MateoSurface(child: SizedBox.expand()),
        overlay: const ColoredBox(
          key: ValueKey('overlay'),
          color: Colors.green,
        ),
      );

      expect(
        tester.getRect(find.byKey(const ValueKey('overlay'))),
        const Rect.fromLTWH(0, 0, 360, 640),
      );
    });

    testWidgets('leaves descendant scrolling owned by an ordinary surface', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await _pumpView(
        tester,
        surface: MateoSurface(
          child: ListView(
            controller: controller,
            children: const [SizedBox(height: 1200)],
          ),
        ),
      );

      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pump();

      expect(controller.offset, greaterThan(0));
      expect(find.byType(CustomScrollView), findsNothing);
    });

    testWidgets('keeps managed scrolling clear of slots at rest', (
      tester,
    ) async {
      await _pumpView(
        tester,
        header: const SizedBox(height: 44),
        footer: const SizedBox(height: 48),
        surface: const MateoSurface.scrollable(
          boundaryEffect: null,
          child: SizedBox(key: ValueKey('content'), height: 900),
        ),
      );

      expect(
        tester.getTopLeft(find.byKey(const ValueKey('content'))).dy,
        86,
      );
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pump();
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('content'))).dy,
        lessThan(86),
      );
    });

    testWidgets('applies the surface keyboard viewport policy', (
      tester,
    ) async {
      Future<double> viewportHeight(
        MateoSurfaceKeyboardViewportBehavior behavior,
      ) async {
        await _pumpView(
          tester,
          keyboardInset: 180,
          surface: MateoSurface.scrollable(
            boundaryEffect: null,
            keyboardViewportBehavior: behavior,
            child: const SizedBox(height: 900),
          ),
        );
        return tester.getSize(find.byType(CustomScrollView)).height;
      }

      expect(
        await viewportHeight(MateoSurfaceKeyboardViewportBehavior.resize),
        460,
      );
      expect(
        await viewportHeight(
          MateoSurfaceKeyboardViewportBehavior.extendBehind,
        ),
        640,
      );
    });
  });
}

Future<void> _pumpView(
  WidgetTester tester, {
  required MateoSurface surface,
  Widget? header,
  Widget? footer,
  Widget? overlay,
  EdgeInsetsGeometry? padding,
  EdgeInsets viewPadding = const EdgeInsets.only(top: 30, bottom: 24),
  double keyboardInset = 0,
  bool extendContentBehindHeader = false,
  bool extendContentBehindFooter = false,
}) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: mateoTestTheme,
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(360, 640),
          padding: viewPadding,
          viewPadding: viewPadding,
          viewInsets: EdgeInsets.only(bottom: keyboardInset),
        ),
        child: MateoView(
          surface: surface,
          header: header,
          footer: footer,
          overlay: overlay,
          padding: padding,
          extendContentBehindHeader: extendContentBehindHeader,
          extendContentBehindFooter: extendContentBehindFooter,
        ),
      ),
    ),
  );
  await tester.pump();
}
