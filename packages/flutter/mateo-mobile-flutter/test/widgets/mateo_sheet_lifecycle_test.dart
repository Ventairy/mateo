import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

const _surfaceKey = Key('mateo_sheet_surface');

void main() {
  testWidgets('when scrolled content is replaced by plain content, it should allow sheet dragging again', (
    tester,
  ) async {
    final context = await _pumpSheetHost(tester);
    final showList = ValueNotifier(true);
    final controller = ScrollController();
    addTearDown(showList.dispose);
    addTearDown(controller.dispose);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(resistance: false),
        child: ValueListenableBuilder<bool>(
          valueListenable: showList,
          builder: (context, visible, _) => SizedBox(
            height: 240,
            child: visible
                ? ListView.builder(
                    controller: controller,
                    itemExtent: 48,
                    itemCount: 40,
                    itemBuilder: (context, index) => Text('Item $index'),
                  )
                : const Text('Finished'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    controller.jumpTo(200);
    await tester.pumpAndSettle();
    expect(controller.offset, 200);

    showList.value = false;
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsNothing);
    final before = tester.getRect(find.byKey(_surfaceKey));
    final gesture = await tester.startGesture(before.center);
    await gesture.moveBy(const Offset(0, 50));
    await tester.pump();
    final during = tester.getRect(find.byKey(_surfaceKey));
    await gesture.cancel();
    await tester.pumpAndSettle();

    expect(during.top, greaterThan(before.top));
    expect(tester.takeException(), isNull);
  });

  for (final sheetCount in [1, 2]) {
    testWidgets(
      'when the navigator is disposed while a canceled ${sheetCount == 1 ? 'single' : 'contextual'} sheet drag settles, it should release its animations',
      (tester) async {
        final context = await _pumpSheetHost(tester);
        for (var index = 0; index < sheetCount; index++) {
          unawaited(
            MateoSheet.show<void>(
              context,
              presentation: const MateoSheetPresentation.bottom(resistance: false),
              child: SizedBox(height: 240, child: Text('Sheet $index')),
            ),
          );
          await tester.pumpAndSettle();
        }

        final before = tester.getRect(find.byKey(_surfaceKey).last);
        final gesture = await tester.startGesture(const Offset(200, 150));
        await gesture.moveBy(const Offset(0, 50));
        await tester.pump();
        await gesture.cancel();
        await tester.pump(const Duration(milliseconds: 50));
        expect(tester.getRect(find.byKey(_surfaceKey).last).top, greaterThan(before.top));

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();

        expect(find.byKey(_surfaceKey), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('when display corner geometry changes while open, it should update the sheet shape', (tester) async {
    final corners = ValueNotifier<BorderRadius>(
      const BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
    );
    addTearDown(corners.dispose);
    final context = await _pumpSheetHost(tester, corners: corners);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SizedBox(height: 240, child: Text('Details')),
      ),
    );
    await tester.pumpAndSettle();
    expect(_sheetRadius(tester).bottomLeft, const Radius.circular(48));

    corners.value = const BorderRadius.only(
      bottomLeft: Radius.circular(100),
      bottomRight: Radius.circular(90),
    );
    await tester.pumpAndSettle();

    expect(_sheetRadius(tester).bottomLeft, const Radius.circular(88));
    expect(_sheetRadius(tester).bottomRight, const Radius.circular(78));
    expect(tester.takeException(), isNull);
  });
}

BorderRadius _sheetRadius(WidgetTester tester) {
  final surface = tester.widget<Container>(find.byKey(_surfaceKey));
  return ((surface.decoration! as ShapeDecoration).shape as RoundedSuperellipseBorder).borderRadius as BorderRadius;
}

Future<BuildContext> _pumpSheetHost(WidgetTester tester, {ValueNotifier<BorderRadius>? corners}) async {
  await tester.binding.setSurfaceSize(const Size(400, 800));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  late BuildContext sheetContext;
  await tester.pumpWidget(
    MaterialApp(
      theme: mateoTestTheme,
      builder: (context, child) => corners == null
          ? child!
          : ValueListenableBuilder<BorderRadius>(
              valueListenable: corners,
              builder: (context, radius, _) => MediaQuery(
                data: MediaQueryData(size: MediaQuery.sizeOf(context), displayCornerRadii: radius),
                child: child!,
              ),
            ),
      home: Scaffold(
        body: Builder(
          builder: (context) {
            sheetContext = context;
            return const Text('Page');
          },
        ),
      ),
    ),
  );
  return sheetContext;
}
