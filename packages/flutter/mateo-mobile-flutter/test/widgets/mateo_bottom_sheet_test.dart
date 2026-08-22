import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

dynamic _findResistanceTransformRenderObject(WidgetTester tester) {
  return tester.renderObject(find.byType(MateoDragResistance));
}

void main() {
  group('MateoBottomSheet', () {
    testWidgets(
      'when showing compact content, it should fit the sheet to the content',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();

        expect(
          tester.getSize(find.byKey(_BottomSheetTestApp.surfaceKey)).height,
          lessThan(200),
        );
      },
    );

    testWidgets(
      'when content exceeds the viewport, it should cap the sheet height at 85 percent',
      (tester) async {
        await _pumpBottomSheetApp(tester, child: const SizedBox(height: 1000));
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();

        expect(
          tester.getSize(find.byKey(_BottomSheetTestApp.surfaceKey)).height,
          closeTo(680, 0.01),
        );
      },
    );

    testWidgets(
      'when scrolling is enabled, it should start the sheet at one third of the available viewport',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          scrollable: true,
          child: const _ScrollableSheetContent(),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();

        expect(
          tester.getSize(find.byKey(_BottomSheetTestApp.surfaceKey)).height,
          closeTo(800 / 3, 0.01),
        );
      },
    );

    testWidgets(
      'when scrolling is enabled with the keyboard visible, it should start at one third of the remaining viewport',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          scrollable: true,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            viewInsets: EdgeInsets.only(bottom: 300),
          ),
          child: const _ScrollableSheetContent(),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();

        expect(
          tester.getSize(find.byKey(_BottomSheetTestApp.surfaceKey)).height,
          closeTo(500 / 3, 0.01),
        );
      },
    );

    testWidgets(
      'when scrolling upward before the sheet is fully expanded, it should expand without moving the content',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          scrollable: true,
          child: const _ScrollableSheetContent(),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final surfaceFinder = find.byKey(_BottomSheetTestApp.surfaceKey);
        final initialHeight = tester.getSize(surfaceFinder).height;
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -120));
        await tester.pumpAndSettle();
        final scrollPosition = tester.state<ScrollableState>(find.byType(Scrollable)).position;

        expect(
          (
            tester.getSize(surfaceFinder).height > initialHeight,
            scrollPosition.pixels,
          ),
          (true, 0),
        );
      },
    );

    testWidgets(
      'when dragging scrollable content upward, it should expand the sheet',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          scrollable: true,
          child: const _ScrollableSheetContent(),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final surfaceFinder = find.byKey(_BottomSheetTestApp.surfaceKey);
        final initialHeight = tester.getSize(surfaceFinder).height;
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -120));
        await tester.pumpAndSettle();

        expect(
          tester.getSize(surfaceFinder).height,
          greaterThan(initialHeight),
        );
      },
    );

    testWidgets(
      'when scrolling upward after the sheet reaches its maximum height, it should scroll the content',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          scrollable: true,
          child: const _ScrollableSheetContent(),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(CustomScrollView)),
        );
        await gesture.moveBy(const Offset(0, -500));
        await tester.pump();
        await gesture.moveBy(const Offset(0, -200));
        await gesture.up();
        await tester.pumpAndSettle();
        final scrollPosition = tester.state<ScrollableState>(find.byType(Scrollable)).position;

        expect(
          (
            (tester.getSize(find.byKey(_BottomSheetTestApp.surfaceKey)).height - 680).abs() < 0.01,
            scrollPosition.pixels > 0,
          ),
          (true, true),
        );
      },
    );

    testWidgets(
      'when dragging downward from an expanded sheet with content at the top, it should collapse before dismissing',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          scrollable: true,
          child: const _ScrollableSheetContent(),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(CustomScrollView), const Offset(0, 180));
        await tester.pumpAndSettle();

        expect(
          (
            find.byKey(_BottomSheetTestApp.surfaceKey).evaluate().length,
            tester.getSize(find.byKey(_BottomSheetTestApp.surfaceKey)).height < 680,
          ),
          (1, true),
        );
      },
    );

    testWidgets(
      'when dragging downward with scrolled content, it should return the content to the top before collapsing the sheet',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          scrollable: true,
          child: const _ScrollableSheetContent(),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final upwardGesture = await tester.startGesture(
          tester.getCenter(find.byType(CustomScrollView)),
        );
        await upwardGesture.moveBy(const Offset(0, -500));
        await tester.pump();
        await upwardGesture.moveBy(const Offset(0, -200));
        await upwardGesture.up();
        await tester.pumpAndSettle();
        final downwardGesture = await tester.startGesture(
          tester.getCenter(find.byType(CustomScrollView)),
        );
        await downwardGesture.moveBy(const Offset(0, 200));
        await tester.pump();
        await downwardGesture.moveBy(const Offset(0, 100));
        await downwardGesture.up();
        await tester.pumpAndSettle();
        final scrollPosition = tester.state<ScrollableState>(find.byType(Scrollable)).position;

        expect(
          (
            scrollPosition.pixels,
            tester.getSize(find.byKey(_BottomSheetTestApp.surfaceKey)).height < 680,
          ),
          (0, true),
        );
      },
    );

    testWidgets(
      'when dragging downward from the initial scrollable height, it should dismiss the sheet',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          scrollable: true,
          child: const _ScrollableSheetContent(),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(CustomScrollView), const Offset(0, 360));
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets(
      'when the keyboard is visible, it should cap height against the remaining viewport',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            viewInsets: EdgeInsets.only(bottom: 300),
          ),
          child: const SizedBox(height: 1000),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();

        expect(
          tester.getSize(find.byKey(_BottomSheetTestApp.surfaceKey)).height,
          closeTo(425, 0.01),
        );
      },
    );

    testWidgets(
      'when shown without system insets, it should keep 12 pixels from the physical edges',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final sheetRect = tester.getRect(
          find.byKey(_BottomSheetTestApp.surfaceKey),
        );

        expect(
          (sheetRect.left, sheetRect.right, sheetRect.bottom),
          (12, 388, 788),
        );
      },
    );

    testWidgets(
      'when Android reports a 48 pixel bottom safe area, it should keep the sheet above it',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            padding: EdgeInsets.only(bottom: 48),
            viewPadding: EdgeInsets.only(bottom: 48),
            systemGestureInsets: EdgeInsets.only(bottom: 48),
          ),
          platform: TargetPlatform.android,
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final sheetRect = tester.getRect(
          find.byKey(_BottomSheetTestApp.surfaceKey),
        );

        expect(sheetRect.bottom, 740);
      },
    );

    testWidgets(
      'when a bottom sheet opens and closes, it should use light navigation icons only while open',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        final beforeOpening = tester
            .widgetList<AnnotatedRegion<SystemUiOverlayStyle>>(
              find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
            )
            .map((region) => region.value.systemNavigationBarIconBrightness)
            .toList();
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final whileOpen = tester
            .widgetList<AnnotatedRegion<SystemUiOverlayStyle>>(
              find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
            )
            .map((region) => region.value.systemNavigationBarIconBrightness)
            .toList();
        Navigator.of(
          tester.element(find.byKey(_BottomSheetTestApp.surfaceKey)),
        ).pop();
        await tester.pumpAndSettle();
        final afterClosing = tester
            .widgetList<AnnotatedRegion<SystemUiOverlayStyle>>(
              find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
            )
            .map((region) => region.value.systemNavigationBarIconBrightness)
            .toList();

        expect(
          [beforeOpening, whileOpen, afterClosing],
          [
            <Brightness?>[Brightness.dark],
            <Brightness?>[Brightness.dark, Brightness.light],
            <Brightness?>[Brightness.dark],
          ],
        );
      },
    );

    testWidgets(
      'when an iOS bottom sheet opens, it should request light navigation icons',
      (tester) async {
        await _pumpBottomSheetApp(tester, platform: TargetPlatform.iOS);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final whileOpen = tester
            .widgetList<AnnotatedRegion<SystemUiOverlayStyle>>(
              find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
            )
            .map((region) => region.value.systemNavigationBarIconBrightness)
            .toList();

        expect(whileOpen, [Brightness.dark, Brightness.light]);
      },
    );

    testWidgets(
      'when the Android bottom safe area moves the sheet upward, it should keep the standard content bottom padding',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            padding: EdgeInsets.only(bottom: 48),
            viewPadding: EdgeInsets.only(bottom: 48),
            systemGestureInsets: EdgeInsets.only(bottom: 48),
          ),
          platform: TargetPlatform.android,
          child: const SizedBox(
            key: _BottomSheetTestApp.contentKey,
            width: double.infinity,
            height: 40,
          ),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final contentRect = tester.getRect(
          find.byKey(_BottomSheetTestApp.contentKey),
        );

        expect(contentRect.bottom, 720);
      },
    );

    testWidgets(
      'when Android reports a 24 pixel gesture safe area, it should keep the sheet above it',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            padding: EdgeInsets.only(bottom: 24),
            viewPadding: EdgeInsets.only(bottom: 24),
            systemGestureInsets: EdgeInsets.only(bottom: 24),
          ),
          platform: TargetPlatform.android,
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final sheetRect = tester.getRect(
          find.byKey(_BottomSheetTestApp.surfaceKey),
        );

        expect(sheetRect.bottom, 764);
      },
    );

    testWidgets(
      'when iOS system insets exceed content padding, it should keep the child inside the safe area',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            padding: EdgeInsets.only(left: 28, bottom: 34),
          ),
          child: const SizedBox(
            key: _BottomSheetTestApp.contentKey,
            width: double.infinity,
            height: 40,
          ),
          platform: TargetPlatform.iOS,
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final contentRect = tester.getRect(
          find.byKey(_BottomSheetTestApp.contentKey),
        );

        expect((contentRect.left, contentRect.bottom), (40, 754));
      },
    );

    testWidgets(
      'when shown, it should use the active bottom-sheet background token',
      (tester) async {
        final scheme = MateoColorScheme.light();
        final custom = scheme.copyWith(
          bottomSheet: scheme.bottomSheet.copyWith(
            background: MateoPalette().accent[3],
          ),
        );
        await _pumpBottomSheetApp(tester, colorScheme: custom);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final material = tester.widget<Material>(
          find.byKey(_BottomSheetTestApp.surfaceKey),
        );

        expect(material.color, custom.bottomSheet.background);
      },
    );

    testWidgets(
      'when shown on an iPhone with a large safe area, it should use continuous corners with adaptive bottom radii',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            viewPadding: EdgeInsets.only(top: 62, bottom: 34),
          ),
          platform: TargetPlatform.iOS,
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final clip = tester.widget<ClipRSuperellipse>(
          find.byType(ClipRSuperellipse),
        );

        expect(
          clip.borderRadius,
          const BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        );
      },
    );

    testWidgets(
      'when the platform reports display corners, it should keep the sheet bottom corners concentric with its margin',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            displayCornerRadii: BorderRadius.only(
              bottomLeft: Radius.circular(55),
              bottomRight: Radius.circular(60),
            ),
          ),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final clip = tester.widget<ClipRSuperellipse>(
          find.byType(ClipRSuperellipse),
        );

        expect(
          clip.borderRadius,
          const BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
            bottomLeft: Radius.circular(43),
            bottomRight: Radius.circular(48),
          ),
        );
      },
    );

    testWidgets(
      'when shown, it should overlay a cross close button at the top right',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final surfaceRect = tester.getRect(
          find.byKey(_BottomSheetTestApp.surfaceKey),
        );
        final closeButtonRect = tester.getRect(
          find.byKey(_BottomSheetTestApp.closeButtonKey),
        );

        expect(
          (
            closeButtonRect.top - surfaceRect.top,
            surfaceRect.right - closeButtonRect.right,
            closeButtonRect.size,
            tester.getSize(
              find.byKey(const Key('mateo_floating_action_button_visual')),
            ),
            tester.getSize(
              find.byKey(const Key('mateo_floating_action_button_icon_box')),
            ),
            find.byKey(_BottomSheetTestApp.closeIconKey).evaluate().length,
          ),
          (
            20,
            20,
            const Size.square(44),
            const Size.square(44),
            const Size.square(16),
            1,
          ),
        );
      },
    );

    testWidgets(
      'when content reaches the top right, it should continue behind the close button',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          child: const SizedBox(
            key: _BottomSheetTestApp.contentKey,
            width: double.infinity,
            height: 80,
          ),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final contentRect = tester.getRect(
          find.byKey(_BottomSheetTestApp.contentKey),
        );
        final closeButtonRect = tester.getRect(
          find.byKey(_BottomSheetTestApp.closeButtonKey),
        );

        expect(contentRect.overlaps(closeButtonRect), isTrue);
      },
    );

    testWidgets(
      'when the close button is tapped, it should dismiss the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_BottomSheetTestApp.closeButtonKey));
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets(
      'when the close-button dismissal is denied, it should keep the sheet open',
      (tester) async {
        MateoBottomSheetDismissSource? requestedSource;
        await _pumpBottomSheetApp(
          tester,
          shouldDismiss: (source) {
            requestedSource = source;
            return false;
          },
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_BottomSheetTestApp.closeButtonKey));
        await tester.pumpAndSettle();

        expect(
          (
            requestedSource,
            find.byKey(_BottomSheetTestApp.surfaceKey).evaluate().length,
          ),
          (MateoBottomSheetDismissSource.closeButton, 1),
        );
      },
    );

    testWidgets(
      'when an asynchronous close-button decision is pending, it should wait and ignore repeated dismissal attempts',
      (tester) async {
        final decision = Completer<bool>();
        var decisionCount = 0;
        await _pumpBottomSheetApp(
          tester,
          shouldDismiss: (source) {
            decisionCount += 1;
            return decision.future;
          },
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_BottomSheetTestApp.closeButtonKey));
        await tester.pump();
        await tester.tap(find.byKey(_BottomSheetTestApp.closeButtonKey));
        await tester.pump();

        expect(
          (
            decisionCount,
            find.byKey(_BottomSheetTestApp.surfaceKey).evaluate().length,
          ),
          (1, 1),
        );

        decision.complete(true);
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets(
      'when exposed to assistive technology, the close button should use the localized close label',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final button = tester.widget<Semantics>(
          find.byKey(const Key('mateo_floating_action_button_semantics')),
        );

        expect(button.properties.label, 'Close');
      },
    );

    testWidgets(
      'when shown, it should use the Mateo overlay scrim behind the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final barrier = tester.widget<ModalBarrier>(
          find.byType(ModalBarrier).last,
        );

        expect(barrier.color, MateoColorScheme.light().overlay.scrim);
      },
    );

    testWidgets(
      'when animations are enabled, it should isolate the complete sheet with a repaint boundary',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();

        final repaintBoundaries = find.descendant(
          of: find.byType(MateoDragResistance),
          matching: find.byType(RepaintBoundary),
        );

        expect(
          repaintBoundaries.evaluate().map((element) => (element.renderObject! as RenderBox).size).toList(),
          contains(tester.getSize(find.byKey(_BottomSheetTestApp.surfaceKey))),
        );
      },
    );

    testWidgets(
      'when animations are enabled, it should update the transition in paint without rebuilding transform widgets',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pump();
        final transition = find.byKey(
          const Key('mateo_bottom_sheet_transition'),
        );

        expect(
          (
            find
                .descendant(
                  of: transition,
                  matching: find.byType(AnimatedBuilder),
                )
                .evaluate()
                .length,
            find
                .descendant(
                  of: transition,
                  matching: find.byType(FractionalTranslation),
                )
                .evaluate()
                .length,
            find.descendant(of: transition, matching: find.byType(Transform)).evaluate().length,
          ),
          (0, 0, 0),
        );
      },
    );

    testWidgets(
      'when the entrance begins, it should start one sheet height below and slightly scaled down',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pump();

        expect(_transitionState(tester), (
          scale: 0.96,
          verticalTranslation: 1.0,
        ));
      },
    );

    testWidgets(
      'when animations are enabled, it should present in 270 ms and dismiss in 230 ms',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final route = ModalRoute.of(
          tester.element(find.text('Opportunity details')),
        )!;

        expect(
          (route.transitionDuration, route.reverseTransitionDuration),
          (
            const Duration(milliseconds: 270),
            const Duration(milliseconds: 230),
          ),
        );
      },
    );

    testWidgets(
      'when dismissal is one quarter complete, it should ease one eighth offscreen',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_BottomSheetTestApp.closeButtonKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 58));

        expect(
          _transitionState(tester).verticalTranslation,
          closeTo(0.125, 0.02),
        );
      },
    );

    testWidgets(
      'when the entrance finishes, it should settle fully visible at its resting transform',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();

        expect(_transitionState(tester), (
          scale: 1.0,
          verticalTranslation: 0.0,
        ));
      },
    );

    testWidgets(
      'when reduced motion is enabled, it should show without transition wrappers',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            disableAnimations: true,
          ),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pump();

        expect(
          find.byKey(const Key('mateo_bottom_sheet_transition')),
          findsNothing,
        );
      },
    );

    testWidgets('when tapping the backdrop, it should dismiss the sheet', (
      tester,
    ) async {
      await _pumpBottomSheetApp(tester);
      await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(200, 100));
      await tester.pumpAndSettle();

      expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
    });

    testWidgets(
      'when only close-button dismissal is allowed, it should deny an outside tap and allow the close button',
      (tester) async {
        final requestedSources = <MateoBottomSheetDismissSource>[];
        await _pumpBottomSheetApp(
          tester,
          shouldDismiss: (source) {
            requestedSources.add(source);
            return source == MateoBottomSheetDismissSource.closeButton;
          },
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(200, 100));
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsOneWidget);

        await tester.tap(find.byKey(_BottomSheetTestApp.closeButtonKey));
        await tester.pumpAndSettle();

        expect(requestedSources, [
          MateoBottomSheetDismissSource.tapOutside,
          MateoBottomSheetDismissSource.closeButton,
        ]);
        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets(
      'when dragging the backdrop downward, it should move the sheet by the same finger distance',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final surfaceFinder = find.byKey(_BottomSheetTestApp.surfaceKey);
        final restingBottom = tester.getBottomRight(surfaceFinder).dy;
        final gesture = await tester.startGesture(const Offset(200, 100));
        await gesture.moveBy(const Offset(0, 40));
        await tester.pump();

        expect(
          tester.getBottomRight(surfaceFinder).dy - restingBottom,
          closeTo(40, 0.001),
        );
        await gesture.cancel();
      },
    );

    testWidgets(
      'when swiping the backdrop downward, it should dismiss the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(const Offset(200, 100));
        await gesture.moveBy(const Offset(0, 360));
        await gesture.up();
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets('when drag dismissal is denied, it should restore the sheet', (
      tester,
    ) async {
      MateoBottomSheetDismissSource? requestedSource;
      await _pumpBottomSheetApp(
        tester,
        shouldDismiss: (source) {
          requestedSource = source;
          return false;
        },
      );
      await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(const Offset(200, 100));
      await gesture.moveBy(const Offset(0, 360));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(
        (requestedSource, _transitionState(tester).verticalTranslation),
        (MateoBottomSheetDismissSource.drag, 0),
      );
    });

    testWidgets(
      'when swiping the backdrop downward at one hundred fifty pixels per second below halfway, it should dismiss the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.flingFrom(
          const Offset(200, 100),
          const Offset(0, 40),
          150,
        );
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets(
      'when dragging the backdrop downward a short distance, it should restore the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(const Offset(200, 100));
        await gesture.moveBy(const Offset(0, 20));
        await gesture.up();
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsOneWidget);
      },
    );

    testWidgets(
      'when dragging the backdrop horizontally, it should keep the sheet fully open',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(const Offset(200, 100));
        await gesture.moveBy(const Offset(100, 0));
        await tester.pump();

        expect(_transitionState(tester).verticalTranslation, 0);
        await gesture.cancel();
      },
    );

    testWidgets(
      'when the system cancels a backdrop drag, it should restore the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(const Offset(200, 100));
        await gesture.moveBy(const Offset(0, 80));
        await gesture.cancel();
        await tester.pumpAndSettle();

        expect(_transitionState(tester).verticalTranslation, 0);
      },
    );

    testWidgets(
      'when reduced motion is enabled and the backdrop swipe crosses halfway, it should dismiss the sheet',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            disableAnimations: true,
          ),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(const Offset(200, 100));
        await gesture.moveBy(const Offset(0, 360));
        await gesture.up();
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets(
      'when a pop is vetoed after a backdrop swipe, it should restore the sheet',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          child: const PopScope(
            canPop: false,
            child: Text('Protected information'),
          ),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(const Offset(200, 100));
        await gesture.moveBy(const Offset(0, 360));
        await gesture.up();
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsOneWidget);
      },
    );

    testWidgets('when using system back, it should dismiss the sheet', (
      tester,
    ) async {
      await _pumpBottomSheetApp(tester);
      await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
    });

    testWidgets(
      'when system-back dismissal is denied, it should keep the sheet open',
      (tester) async {
        MateoBottomSheetDismissSource? requestedSource;
        await _pumpBottomSheetApp(
          tester,
          shouldDismiss: (source) {
            requestedSource = source;
            return false;
          },
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();

        expect(
          (
            requestedSource,
            find.byKey(_BottomSheetTestApp.surfaceKey).evaluate().length,
          ),
          (MateoBottomSheetDismissSource.systemBack, 1),
        );
      },
    );

    testWidgets(
      'when exposed to assistive technology, it should provide a dismiss action',
      (tester) async {
        final semantics = tester.ensureSemantics();
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final semanticsData = tester.getSemantics(find.byKey(_BottomSheetTestApp.surfaceKey)).getSemanticsData();

        expect(semanticsData.hasAction(SemanticsAction.dismiss), isTrue);
        semantics.dispose();
      },
    );

    testWidgets(
      'when accessibility dismissal is denied, it should keep the sheet open',
      (tester) async {
        final semantics = tester.ensureSemantics();
        MateoBottomSheetDismissSource? requestedSource;
        await _pumpBottomSheetApp(
          tester,
          shouldDismiss: (source) {
            requestedSource = source;
            return false;
          },
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final semanticsNode = tester.getSemantics(
          find.byKey(_BottomSheetTestApp.surfaceKey),
        );
        tester.platformDispatcher.onSemanticsActionEvent!(
          SemanticsActionEvent(
            type: SemanticsAction.dismiss,
            viewId: tester.view.viewId,
            nodeId: semanticsNode.id,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          (
            requestedSource,
            find.byKey(_BottomSheetTestApp.surfaceKey).evaluate().length,
          ),
          (MateoBottomSheetDismissSource.accessibilityAction, 1),
        );
        semantics.dispose();
      },
    );

    testWidgets(
      'when dragging downward, it should drive route progress by the same fraction of the sheet height',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final surfaceFinder = find.byKey(_BottomSheetTestApp.surfaceKey);
        final restingBottom = tester.getBottomRight(surfaceFinder).dy;
        final gesture = await tester.startGesture(
          tester.getCenter(surfaceFinder),
        );
        await gesture.moveBy(const Offset(0, 40));
        await tester.pump();

        expect(
          tester.getBottomRight(surfaceFinder).dy - restingBottom,
          closeTo(40, 0.001),
        );
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging upward during an active downward drag, it should restore progress along the same vertical rail',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final surfaceFinder = find.byKey(_BottomSheetTestApp.surfaceKey);
        final restingBottom = tester.getBottomRight(surfaceFinder).dy;
        final gesture = await tester.startGesture(
          tester.getCenter(surfaceFinder),
        );
        await gesture.moveBy(const Offset(0, 100));
        await gesture.moveBy(const Offset(0, -40));
        await tester.pump();

        expect(
          tester.getBottomRight(surfaceFinder).dy - restingBottom,
          closeTo(60, 0.001),
        );
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging horizontally before any downward intent, it should keep the sheet fully open',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(80, 0));
        await tester.pump();

        expect(_transitionState(tester).verticalTranslation, 0);
        await gesture.cancel();
      },
    );

    testWidgets(
      'when a downward swipe on still content begins with slight sideways finger movement, it should move the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(12, 0));
        await gesture.moveBy(const Offset(0, 80));
        await tester.pump();

        expect(_transitionState(tester).verticalTranslation, greaterThan(0));
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging the sheet right, it should move with strong resistance',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(120, 0));
        await tester.pump();
        final renderObject = _findResistanceTransformRenderObject(tester);

        expect(
          renderObject.currentResistanceOffset.dx,
          allOf(greaterThan(0), lessThan(7)),
        );
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging the sheet left, it should move with strong resistance',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(-120, 0));
        await tester.pump();
        final renderObject = _findResistanceTransformRenderObject(tester);

        expect(
          renderObject.currentResistanceOffset.dx,
          allOf(lessThan(0), greaterThan(-7)),
        );
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging non-scrollable content upward, it should move the sheet with top-edge resistance',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(0, -120));
        await tester.pump();
        final renderObject = _findResistanceTransformRenderObject(tester);

        expect(
          renderObject.currentResistanceOffset.dy,
          allOf(lessThan(0), greaterThan(-7)),
        );
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging scrollable content upward, it should expand without adding top-edge resistance',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          scrollable: true,
          child: const _ScrollableSheetContent(),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(CustomScrollView)),
        );
        await gesture.moveBy(const Offset(0, -120));
        await tester.pump();
        final renderObject = _findResistanceTransformRenderObject(tester);

        expect(renderObject.currentResistanceOffset.dy, 0);
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging downward to dismiss, it should not add resistance to the route movement',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(0, 80));
        await tester.pump();
        final renderObject = _findResistanceTransformRenderObject(tester);

        expect(renderObject.currentResistanceOffset.dy, 0);
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging is disabled, it should resist a downward sheet drag without requesting dismissal',
      (tester) async {
        var dismissalRequestCount = 0;
        await _pumpBottomSheetApp(
          tester,
          draggable: false,
          shouldDismiss: (source) {
            dismissalRequestCount += 1;
            return true;
          },
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(0, 120));
        await tester.pump();
        final renderObject = _findResistanceTransformRenderObject(tester);

        expect(
          (
            _transitionState(tester).verticalTranslation,
            renderObject.currentResistanceOffset.dy > 0,
            dismissalRequestCount,
          ),
          (0, true, 0),
        );
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging is disabled on a scrollable sheet, it should resist upward movement without expanding or scrolling',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          scrollable: true,
          draggable: false,
          child: const _ScrollableSheetContent(),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final surfaceFinder = find.byKey(_BottomSheetTestApp.surfaceKey);
        final initialHeight = tester.getSize(surfaceFinder).height;
        final scrollable = tester.state<ScrollableState>(
          find.byType(Scrollable),
        );
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(CustomScrollView)),
        );
        await gesture.moveBy(const Offset(0, -120));
        await tester.pump();
        final renderObject = _findResistanceTransformRenderObject(tester);

        expect(
          (
            tester.getSize(surfaceFinder).height,
            scrollable.position.pixels,
            renderObject.currentResistanceOffset.dy < 0,
          ),
          (initialHeight, 0, true),
        );
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging is disabled, it should ignore a scrim drag without requesting dismissal',
      (tester) async {
        var dismissalRequestCount = 0;
        await _pumpBottomSheetApp(
          tester,
          draggable: false,
          shouldDismiss: (source) {
            dismissalRequestCount += 1;
            return true;
          },
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(const Offset(200, 100));
        await gesture.moveBy(const Offset(0, 360));
        await gesture.up();
        await tester.pumpAndSettle();

        expect(
          (_transitionState(tester).verticalTranslation, dismissalRequestCount),
          (0, 0),
        );
      },
    );

    testWidgets(
      'when reversing a downward drag past the resting edge, it should restore the route and apply top-edge resistance',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(0, 80));
        await gesture.moveBy(const Offset(0, -120));
        await tester.pump();
        final renderObject = _findResistanceTransformRenderObject(tester);

        expect(
          (
            _transitionState(tester).verticalTranslation,
            renderObject.currentResistanceOffset.dy < 0,
          ),
          (0, true),
        );
        await gesture.cancel();
      },
    );

    testWidgets(
      'when releasing a resisted drag, it should ease the sheet back to rest',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(120, 0));
        await gesture.up();
        await tester.pumpAndSettle();
        final renderObject = _findResistanceTransformRenderObject(tester);

        expect(renderObject.currentResistanceOffset, Offset.zero);
      },
    );

    testWidgets(
      'when reduced motion is enabled and the sheet is dragged sideways, it should bypass the resistance transform',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            disableAnimations: true,
          ),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(120, 0));
        await tester.pump();
        final renderObject = _findResistanceTransformRenderObject(tester);

        expect(renderObject, isA<RenderPointerListener>());
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging farther than the sheet height, it should clamp route progress at fully dismissed',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final surfaceFinder = find.byKey(_BottomSheetTestApp.surfaceKey);
        final sheetHeight = tester.getSize(surfaceFinder).height;
        final gesture = await tester.startGesture(
          tester.getCenter(surfaceFinder),
        );
        await gesture.moveBy(Offset(0, sheetHeight * 2));
        await tester.pump();

        expect(_transitionState(tester).verticalTranslation, 1);
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging downward, it should keep the sheet surface opaque',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(0, 40));
        await tester.pump();

        expect(
          find.ancestor(
            of: find.byKey(_BottomSheetTestApp.surfaceKey),
            matching: find.byType(Opacity),
          ),
          findsNothing,
        );
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging downward, it should fade the modal scrim with route progress',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final restingBarrier = tester.widget<ModalBarrier>(
          find.byType(ModalBarrier).last,
        );
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(0, 40));
        await tester.pump();
        final draggedBarrier = tester.widget<ModalBarrier>(
          find.byType(ModalBarrier).last,
        );

        expect(draggedBarrier.color!.a, lessThan(restingBarrier.color!.a));
        await gesture.cancel();
      },
    );

    testWidgets(
      'when dragging non-scrollable content downward, it should dismiss the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byKey(_BottomSheetTestApp.surfaceKey),
          const Offset(0, 360),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets(
      'when releasing a short slow drag, it should restore the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(0, 20));
        await tester.pump(const Duration(milliseconds: 300));
        await gesture.up();
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsOneWidget);
      },
    );

    testWidgets(
      'when releasing downward quickly below halfway, it should dismiss the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.fling(
          find.byKey(_BottomSheetTestApp.surfaceKey),
          const Offset(0, 40),
          1000,
        );
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets(
      'when swiping the sheet downward at one hundred fifty pixels per second below halfway, it should dismiss the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final surfaceFinder = find.byKey(_BottomSheetTestApp.surfaceKey);
        await tester.fling(surfaceFinder, const Offset(0, 40), 150);
        await tester.pumpAndSettle();

        expect(surfaceFinder, findsNothing);
      },
    );

    testWidgets(
      'when releasing upward quickly beyond halfway, it should restore the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final surfaceFinder = find.byKey(_BottomSheetTestApp.surfaceKey);
        final sheetHeight = tester.getSize(surfaceFinder).height;
        final gesture = await tester.startGesture(
          tester.getCenter(surfaceFinder),
        );
        await gesture.moveBy(Offset(0, sheetHeight * 0.8));
        await tester.pump(const Duration(milliseconds: 500));
        await gesture.moveBy(const Offset(0, -20));
        await tester.pump(const Duration(milliseconds: 10));
        await gesture.moveBy(const Offset(0, -20));
        await gesture.up();
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsOneWidget);
      },
    );

    testWidgets(
      'when the system cancels an active drag, it should restore the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(0, 80));
        await gesture.cancel();
        await tester.pumpAndSettle();

        expect(_transitionState(tester).verticalTranslation, 0);
      },
    );

    testWidgets(
      'when a cancelled drag finishes restoring, it should release navigator gesture ownership',
      (tester) async {
        await _pumpBottomSheetApp(tester);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_BottomSheetTestApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(0, 80));
        await gesture.cancel();
        await tester.pumpAndSettle();
        final navigator = tester.state<NavigatorState>(find.byType(Navigator));

        expect(navigator.userGestureInProgress, isFalse);
      },
    );

    testWidgets(
      'when reduced motion is enabled and a downward drag crosses halfway, it should dismiss without visible drag motion',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            disableAnimations: true,
          ),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byKey(_BottomSheetTestApp.surfaceKey),
          const Offset(0, 360),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets(
      'when a pop is vetoed after a committed drag, it should restore the sheet',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          child: const PopScope(
            canPop: false,
            child: Text('Protected information'),
          ),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byKey(_BottomSheetTestApp.surfaceKey),
          const Offset(0, 360),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsOneWidget);
      },
    );

    testWidgets(
      'when scrollable content is away from the top, dragging down should keep the sheet open',
      (tester) async {
        await _pumpBottomSheetApp(tester, child: const _LongSheetContent());
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView), const Offset(0, 180));
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsOneWidget);
      },
    );

    testWidgets(
      'when resistance is disabled, it should let consumer-provided scrolling run without a resistance transform',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          resistance: false,
          child: const _LongSheetContent(physics: BouncingScrollPhysics()),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final listFinder = find.byType(ListView);
        final scrollable = tester.state<ScrollableState>(
          find.descendant(of: listFinder, matching: find.byType(Scrollable)),
        );
        await tester.drag(listFinder, const Offset(0, -120));
        await tester.pumpAndSettle();

        expect(
          (
            scrollable.position.pixels > 0,
            find.byType(MateoDragResistance).evaluate().length,
          ),
          (true, 0),
        );
      },
    );

    testWidgets(
      'when dragging and resistance are disabled, it should keep direct sheet drags completely stationary',
      (tester) async {
        await _pumpBottomSheetApp(tester, draggable: false, resistance: false);
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final surfaceFinder = find.byKey(_BottomSheetTestApp.surfaceKey);
        final restingRect = tester.getRect(surfaceFinder);
        final gesture = await tester.startGesture(
          tester.getCenter(surfaceFinder),
        );
        await gesture.moveBy(const Offset(120, 120));
        await tester.pump();

        expect(
          (
            tester.getRect(surfaceFinder),
            _transitionState(tester).verticalTranslation,
            find.byType(MateoDragResistance).evaluate().length,
          ),
          (restingRect, 0, 0),
        );
        await gesture.cancel();
      },
    );

    testWidgets(
      'when scrollable content is at the top, dragging down should dismiss the sheet',
      (tester) async {
        await _pumpBottomSheetApp(tester, child: const _LongSheetContent());
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView), const Offset(0, 380));
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets(
      'when scrollable content fits the sheet, dragging down should dismiss the sheet',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          child: const _FittingScrollableSheetContent(),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView), const Offset(0, 380));
        await tester.pumpAndSettle();

        expect(find.byKey(_BottomSheetTestApp.surfaceKey), findsNothing);
      },
    );

    testWidgets(
      'when dragging fast through content to the top and continuing downward, it should keep the sheet open',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          child: const _LongSheetContent(physics: BouncingScrollPhysics()),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(ListView)),
        );
        for (var index = 0; index < 8; index++) {
          await gesture.moveBy(const Offset(0, -50));
          await tester.pump();
        }
        for (var index = 0; index < 16; index++) {
          await gesture.moveBy(const Offset(0, 50));
          await tester.pump();
        }

        expect(_transitionState(tester).verticalTranslation, 0);
        await gesture.up();
      },
    );

    testWidgets(
      'when the fast-scroll cooldown expires and the user drags downward, it should move the sheet',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          child: const _LongSheetContent(physics: ClampingScrollPhysics()),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView), const Offset(0, -1000));
        await tester.pumpAndSettle();
        await tester.timedDrag(
          find.byType(ListView),
          const Offset(0, 1000),
          const Duration(milliseconds: 80),
        );
        await tester.pump(const Duration(milliseconds: 150));
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(ListView)),
        );
        await gesture.moveBy(const Offset(0, 80));
        await tester.pump();

        expect(_transitionState(tester).verticalTranslation, greaterThan(0));
        await gesture.cancel();
      },
    );

    testWidgets(
      'when content has stopped after returning to the top, a fresh downward swipe should move the sheet immediately',
      (tester) async {
        await _pumpBottomSheetApp(
          tester,
          child: const _LongSheetContent(physics: ClampingScrollPhysics()),
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView), const Offset(0, -1000));
        await tester.pumpAndSettle();
        await tester.fling(find.byType(ListView), const Offset(0, 1000), 3000);
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(ListView)),
        );
        await gesture.moveBy(const Offset(0, 80));
        await tester.pump();

        expect(_transitionState(tester).verticalTranslation, greaterThan(0));
        await gesture.cancel();
      },
    );

    testWidgets(
      'when the child closes with a result, it should complete show with that result',
      (tester) async {
        Future<int?>? result;
        await _pumpBottomSheetApp(
          tester,
          onShow: (context) {
            result = MateoBottomSheet.show<int>(
              context,
              child: const _ResultSheetContent(),
            );
          },
        );
        await tester.tap(find.byKey(_BottomSheetTestApp.openButtonKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_BottomSheetTestApp.resultButtonKey));
        await tester.pumpAndSettle();

        expect(await result, 42);
      },
    );
  });
}

({double scale, double verticalTranslation}) _transitionState(
  WidgetTester tester,
) {
  final dynamic transition = tester.renderObject(
    find.byKey(const Key('mateo_bottom_sheet_transition')),
  );

  return (
    scale: transition.currentScale as double,
    verticalTranslation: transition.currentVerticalTranslation as double,
  );
}

Future<void> _pumpBottomSheetApp(
  WidgetTester tester, {
  MediaQueryData mediaQueryData = const MediaQueryData(size: Size(400, 800)),
  Widget child = const Text('Opportunity details'),
  bool scrollable = false,
  bool draggable = true,
  bool resistance = true,
  TargetPlatform? platform,
  MateoColorScheme? colorScheme,
  MateoBottomSheetShouldDismiss? shouldDismiss,
  void Function(BuildContext context)? onShow,
}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = mediaQueryData.size
    ..padding = FakeViewPadding(
      left: mediaQueryData.padding.left,
      top: mediaQueryData.padding.top,
      right: mediaQueryData.padding.right,
      bottom: mediaQueryData.padding.bottom,
    )
    ..viewPadding = FakeViewPadding(
      left: mediaQueryData.viewPadding.left,
      top: mediaQueryData.viewPadding.top,
      right: mediaQueryData.viewPadding.right,
      bottom: mediaQueryData.viewPadding.bottom,
    )
    ..viewInsets = FakeViewPadding(
      left: mediaQueryData.viewInsets.left,
      top: mediaQueryData.viewInsets.top,
      right: mediaQueryData.viewInsets.right,
      bottom: mediaQueryData.viewInsets.bottom,
    );
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    _BottomSheetTestApp(
      mediaQueryData: mediaQueryData,
      sheetChild: child,
      scrollable: scrollable,
      draggable: draggable,
      resistance: resistance,
      platform: platform,
      colorScheme: colorScheme,
      shouldDismiss: shouldDismiss,
      onShow: onShow,
    ),
  );
  await tester.pumpAndSettle();
}

class _BottomSheetTestApp extends StatelessWidget {
  const _BottomSheetTestApp({
    required this.mediaQueryData,
    required this.sheetChild,
    required this.scrollable,
    required this.draggable,
    required this.resistance,
    required this.platform,
    required this.colorScheme,
    this.shouldDismiss,
    this.onShow,
  });

  static const openButtonKey = Key('open_bottom_sheet');
  static const resultButtonKey = Key('close_with_result');
  static const contentKey = Key('bottom_sheet_content');
  static const closeButtonKey = Key('mateo_bottom_sheet_close_button');
  static const closeIconKey = Key('mateo_bottom_sheet_close_icon');
  static const surfaceKey = Key('mateo_bottom_sheet_surface');

  final MediaQueryData mediaQueryData;
  final Widget sheetChild;
  final bool scrollable;
  final bool draggable;
  final bool resistance;
  final TargetPlatform? platform;
  final MateoColorScheme? colorScheme;
  final MateoBottomSheetShouldDismiss? shouldDismiss;
  final void Function(BuildContext context)? onShow;

  @override
  Widget build(BuildContext context) {
    final baseTheme = MateoTheme.light();
    final customColorScheme = colorScheme;
    final theme = customColorScheme == null
        ? baseTheme
        : baseTheme.copyWith(
            extensions: [
              baseTheme.extension<MateoThemeData>()!.copyWith(
                colorScheme: customColorScheme,
              ),
            ],
          );

    return MaterialApp(
      theme: theme.copyWith(platform: platform),
      builder: (context, child) => MediaQuery(
        data: mediaQueryData,
        child: child ?? const SizedBox.shrink(),
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                key: openButtonKey,
                onPressed: () {
                  final show = onShow;
                  if (show != null) {
                    show(context);
                    return;
                  }

                  MateoBottomSheet.show<void>(
                    context,
                    scrollable: scrollable,
                    draggable: draggable,
                    resistance: resistance,
                    shouldDismiss: shouldDismiss,
                    child: sheetChild,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LongSheetContent extends StatelessWidget {
  const _LongSheetContent({this.physics});

  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: physics,
      itemCount: 30,
      itemBuilder: (context, index) => SizedBox(height: 60, child: Text('Opportunity $index')),
    );
  }
}

class _FittingScrollableSheetContent extends StatelessWidget {
  const _FittingScrollableSheetContent();

  @override
  Widget build(BuildContext context) {
    return ListView(children: const [SizedBox(height: 50)]);
  }
}

class _ResultSheetContent extends StatelessWidget {
  const _ResultSheetContent();

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      key: _BottomSheetTestApp.resultButtonKey,
      onPressed: () => Navigator.of(context).pop(42),
      child: const Text('Choose'),
    );
  }
}

class _ScrollableSheetContent extends StatelessWidget {
  const _ScrollableSheetContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        30,
        (index) => SizedBox(height: 60, child: Text('Opportunity $index')),
      ),
    );
  }
}
