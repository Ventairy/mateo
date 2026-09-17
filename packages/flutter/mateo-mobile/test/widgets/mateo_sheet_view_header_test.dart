import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  late BuildContext launcher;

  Future<void> host(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    TextDirection direction = .ltr,
    bool reducedMotion = false,
  }) async {
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        locale: locale,
        supportedLocales: const [Locale('en'), Locale('pt')],
        home: Directionality(
          textDirection: direction,
          child: MediaQuery(
            data: MediaQueryData(disableAnimations: reducedMotion),
            child: Builder(
              builder: (context) {
                launcher = context;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  const closeView = MateoSheetView(
    header: MateoSheetViewHeader(presentation: .closeButton()),
    surface: MateoSheetViewSurface(child: SizedBox(height: 180)),
  );

  for (final locale in const [Locale('en'), Locale('pt')]) {
    for (final direction in TextDirection.values) {
      testWidgets('when using $locale and $direction, the close button should localize and follow the trailing edge', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        await host(tester, locale: locale, direction: direction);
        unawaited(showMateoSheet<void>(context: launcher, view: closeView));
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel(locale.languageCode == 'en' ? 'Close' : 'Fechar'), findsOneWidget);
        final header = tester.getRect(find.byType(MateoSheetViewHeader));
        final button = tester.getRect(find.byType(MateoButton));
        expect(
          button.center.dx,
          direction == .ltr ? greaterThan(header.center.dx) : lessThan(header.center.dx),
        );
        expect(button.size, const Size(48, 48));
        await tester.tap(find.byType(MateoButton));
        await tester.pumpAndSettle();
        expect(find.byType(MateoSheetView), findsNothing);
        semantics.dispose();
      });
    }
  }

  for (final allowed in [false, true]) {
    testWidgets('when dismissal returns $allowed, the close button should await it and ignore repeated presses', (
      tester,
    ) async {
      await host(tester);
      final decision = Completer<bool>();
      final requests = <MateoSheetDismissSource>[];
      unawaited(
        showMateoSheet<void>(
          context: launcher,
          view: closeView,
          shouldDismiss: (source) {
            requests.add(source);
            return decision.future;
          },
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MateoButton));
      await tester.pump();
      await tester.tap(find.byType(MateoButton));
      await tester.pump();
      expect(requests, [MateoSheetDismissSource.closeButton]);
      expect(find.byType(MateoSheetView), findsOneWidget);
      decision.complete(allowed);
      await tester.pumpAndSettle();
      expect(find.byType(MateoSheetView), allowed ? findsNothing : findsOneWidget);
    });
  }

  testWidgets('when sheets are stacked, the close button should only dismiss the top sheet', (tester) async {
    await host(tester);
    unawaited(showMateoSheet<void>(context: launcher, view: closeView));
    await tester.pumpAndSettle();
    unawaited(showMateoSheet<void>(context: tester.element(find.byType(MateoSheetView)), view: closeView));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(MateoButton).last);
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsOneWidget);
    await tester.tap(find.byType(MateoButton));
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNothing);
  });

  for (final reducedMotion in [false, true]) {
    for (final whitespace in [false, true]) {
      testWidgets(
        'when whitespace=$whitespace and reducedMotion=$reducedMotion, the handle should dismiss scrolled content',
        (
          tester,
        ) async {
          await host(tester, reducedMotion: reducedMotion);
          final requests = <MateoSheetDismissSource>[];
          unawaited(
            showMateoSheet<void>(
              context: launcher,
              shouldDismiss: (source) {
                requests.add(source);
                return true;
              },
              view: const MateoSheetView(
                header: MateoSheetViewHeader(presentation: .handle()),
                surface: MateoSheetViewSurface.scrollable(child: SizedBox(height: 1500)),
              ),
            ),
          );
          await tester.pumpAndSettle();
          tester.state<ScrollableState>(find.byType(Scrollable).first).position.jumpTo(150);
          await tester.pumpAndSettle();
          final header = tester.getRect(find.byType(MateoSheetViewHeader));
          expect(tester.getRect(find.byType(InteractiveSwipeDismissHandle)), header);
          final handleVisual = find.descendant(
            of: find.byType(MateoSheetViewHeader),
            matching: find.byType(DecoratedBox),
          );
          expect(tester.getSize(handleVisual), const Size(50, 7));
          expect(
            (tester.widget<DecoratedBox>(handleVisual).decoration as ShapeDecoration).color,
            surfaceTransformTheme.colorScheme.sheet.handle,
          );
          final start = whitespace ? header.topLeft + const Offset(3, 3) : tester.getCenter(handleVisual);
          await tester.dragFrom(start, const Offset(0, 300));
          await tester.pumpAndSettle();
          expect(requests, [MateoSheetDismissSource.drag]);
          expect(find.byType(MateoSheetView), findsNothing);
        },
      );
    }
  }

  for (final cancel in [false, true]) {
    testWidgets('when ${cancel ? 'canceled' : 'vetoed'}, the handle should restore its position', (tester) async {
      await host(tester);
      final requests = <MateoSheetDismissSource>[];
      unawaited(
        showMateoSheet<void>(
          context: launcher,
          shouldDismiss: (source) {
            requests.add(source);
            return false;
          },
          view: const MateoSheetView(
            header: MateoSheetViewHeader(presentation: .handle()),
            surface: MateoSheetViewSurface(child: SizedBox(height: 180)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final header = tester.getRect(find.byType(MateoSheetViewHeader));
      final gesture = await tester.startGesture(header.center);
      await gesture.moveBy(const Offset(0, 120));
      await tester.pump();
      if (cancel) {
        await gesture.cancel();
      } else {
        await gesture.up();
      }
      await tester.pumpAndSettle();
      expect(find.byType(MateoSheetView), findsOneWidget);
      expect(tester.getRect(find.byType(MateoSheetViewHeader)), header);
      expect(requests, cancel ? isEmpty : [MateoSheetDismissSource.drag]);
    });
  }
}
