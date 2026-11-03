import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import 'mateo_surface_caret_fixture.dart';

void main() {
  for (final presentation in <String, MateoTextInputPresentation>{
    'general': const .general(variant: .filled),
    'search': const .search(variant: .filled),
    'phone': const .phone(),
  }.entries) {
    testWidgets('when the keyboard opens for ${presentation.key}, it should reveal the caret above the fixed footer', (
      tester,
    ) async {
      final fixture = MateoSurfaceCaretFixture();
      await fixture.mount(tester, presentation: presentation.value);
      await fixture.focus(tester);
      await fixture.keyboard(tester, 326);
      expect(
        fixture.caretRect.bottom,
        lessThanOrEqualTo(tester.getTopLeft(find.byKey(const ValueKey('footer'))).dy - 19),
      );
      expect(fixture.focusNode.hasFocus, isTrue);
    });
  }

  testWidgets('when host keyboard avoidance is disabled, it should reveal the caret without moving the footer', (
    tester,
  ) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(tester, avoidBottomInset: false);
    final footer = tester.getRect(find.byKey(const ValueKey('footer')));
    await fixture.focus(tester);
    await fixture.keyboard(tester, 326);
    expect(fixture.caretRect.bottom, lessThanOrEqualTo(498));
    expect(tester.getRect(find.byKey(const ValueKey('footer'))), footer);
  });

  testWidgets('when a standalone surface is covered by the keyboard, it should provide enough scroll clearance', (
    tester,
  ) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(tester, standalone: true);
    await fixture.focus(tester);
    await fixture.keyboard(tester, 326);
    expect(fixture.caretRect.bottom, lessThanOrEqualTo(498));
  });

  testWidgets('when a sheet does not move for the keyboard, it should still reveal its focused caret', (tester) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(tester, sheet: true);
    await fixture.focus(tester);
    await fixture.keyboard(tester, 326);
    expect(fixture.caretRect.bottom, lessThanOrEqualTo(498));
  });

  testWidgets('when manually scrolling away, it should wait for an editing event before revealing again', (
    tester,
  ) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(tester);
    await fixture.focus(tester);
    await fixture.keyboard(tester, 326);
    final scrollController = fixture.scrollController(tester)..jumpTo(0);
    await tester.pumpAndSettle();
    expect(scrollController.offset, 0);
    expect(fixture.caretRect.bottom, greaterThan(518));
    fixture.textController.value = const TextEditingValue(
      text: 'Edited draft',
      selection: TextSelection.collapsed(offset: 4),
    );
    await tester.pumpAndSettle();
    expect(
      fixture.caretRect.bottom,
      lessThanOrEqualTo(tester.getTopLeft(find.byKey(const ValueKey('footer'))).dy - 19),
    );
  });

  testWidgets('when keyboard or footer height changes, it should reveal the caret using the new clearance', (
    tester,
  ) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(tester);
    await fixture.focus(tester);
    for (final height in [260.0, 360.0, 300.0]) {
      await fixture.keyboard(tester, height);
      expect(
        fixture.caretRect.bottom,
        lessThanOrEqualTo(tester.getTopLeft(find.byKey(const ValueKey('footer'))).dy - 19),
      );
    }
    fixture.footerHeight.value = 120;
    await tester.pumpAndSettle();
    expect(
      fixture.caretRect.bottom,
      lessThanOrEqualTo(tester.getTopLeft(find.byKey(const ValueKey('footer'))).dy - 19),
    );
  });

  testWidgets('when a caret is already visible, it should preserve the scroll position on selection changes', (
    tester,
  ) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(tester);
    await fixture.focus(tester);
    final scrollController = fixture.scrollController(tester);
    final offset = scrollController.offset;
    fixture.textController.selection = const TextSelection(baseOffset: 0, extentOffset: 2);
    await tester.pumpAndSettle();
    expect(scrollController.offset, offset);
  });

  testWidgets('when a caret is scrolled behind the header, editing should reveal it below the header', (tester) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(tester, wrapContent: (content) => Column(children: [content, const SizedBox(height: 700)]));
    await fixture.focus(tester);
    await fixture.keyboard(tester, 326);
    final scrollController = fixture.scrollController(tester);
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    await tester.pumpAndSettle();
    final headerBottom = tester.getBottomLeft(find.byType(MateoViewHeader)).dy;
    expect(fixture.caretRect.top, lessThan(headerBottom));
    fixture.textController.selection = const TextSelection.collapsed(offset: 0);
    await tester.pumpAndSettle();
    expect(fixture.caretRect.top, greaterThanOrEqualTo(headerBottom + 19));
  });

  testWidgets('when another route owns focus, it should preserve the covered surface scroll position', (tester) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(tester);
    await fixture.focus(tester);
    await fixture.keyboard(tester, 326);
    final scrollController = fixture.scrollController(tester);
    final offset = scrollController.offset;
    fixture.navigatorKey.currentState!.push(
      PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (_, animation, secondaryAnimation) => MateoView(
          surface: MateoViewSurface.scrollable(
            child: MateoTextInput(
              placeholder: 'Another input',
              presentation: const .general(variant: .filled),
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await fixture.keyboard(tester, 380);
    fixture.textController.selection = const TextSelection.collapsed(offset: 1);
    await tester.pumpAndSettle();
    expect(scrollController.offset, offset);
    expect(fixture.focusNode.hasFocus, isFalse);
  });

  testWidgets('when an input is removed with a reveal pending, it should detach without another scroll request', (
    tester,
  ) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(tester);
    await fixture.focus(tester);
    tester.view.viewInsets = const FakeViewPadding(bottom: 326);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when an input is in a nested scrollable surface, it should reveal through the nearest owner only', (
    tester,
  ) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(
      tester,
      wrapContent: (content) => SizedBox(
        height: 650,
        child: MateoSurface.scrollable(width: const .fill(), height: const .fill(), child: content),
      ),
    );
    await fixture.focus(tester);
    final controllers = tester
        .widgetList<CustomScrollView>(find.byType(CustomScrollView))
        .map((view) => view.controller!)
        .toList();
    final outerOffset = controllers.first.offset;
    await fixture.keyboard(tester, 326);
    expect(
      fixture.caretRect.bottom,
      lessThanOrEqualTo(tester.getTopLeft(find.byKey(const ValueKey('footer'))).dy - 19),
    );
    expect(controllers.first.offset, outerOffset);
    expect(controllers.last.offset, greaterThan(0));
    fixture.footerHeight.value = 120;
    await tester.pumpAndSettle();
    expect(
      fixture.caretRect.bottom,
      lessThanOrEqualTo(tester.getTopLeft(find.byKey(const ValueKey('footer'))).dy - 19),
    );
    expect(controllers.first.offset, outerOffset);
  });

  testWidgets('when controller and focus node are replaced, it should listen only to the current editor', (
    tester,
  ) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(tester);
    await fixture.focus(tester);
    await fixture.keyboard(tester, 326);
    final newFocusNode = FocusNode();
    final newTextController = TextEditingController(text: 'Replacement');
    addTearDown(newFocusNode.dispose);
    addTearDown(newTextController.dispose);
    fixture.inputBinding.value = (focusNode: newFocusNode, textController: newTextController, enabled: true);
    await tester.pumpAndSettle();
    await fixture.focus(tester);
    final scrollController = fixture.scrollController(tester)..jumpTo(0);
    await tester.pumpAndSettle();
    fixture.textController.text = 'Old controller';
    await tester.pumpAndSettle();
    expect(scrollController.offset, 0);
    newTextController.selection = const TextSelection(baseOffset: 0, extentOffset: 3);
    await tester.pumpAndSettle();
    expect(
      fixture.caretRect.bottom,
      lessThanOrEqualTo(tester.getTopLeft(find.byKey(const ValueKey('footer'))).dy - 19),
    );
  });

  testWidgets('when an active input is disabled, edits should no longer request caret scrolling', (tester) async {
    final fixture = MateoSurfaceCaretFixture();
    await fixture.mount(tester);
    await fixture.focus(tester);
    await fixture.keyboard(tester, 326);
    fixture.inputBinding.value = (focusNode: fixture.focusNode, textController: fixture.textController, enabled: false);
    await tester.pumpAndSettle();
    final scrollController = fixture.scrollController(tester)..jumpTo(0);
    await tester.pumpAndSettle();
    fixture.textController.text = 'Disabled';
    await tester.pumpAndSettle();
    expect(scrollController.offset, 0);
  });

  testWidgets('when text is enlarged and empty, it should reveal the caret with reduced motion', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final fixture = MateoSurfaceCaretFixture()..textController.clear();
    await fixture.mount(tester);
    await fixture.focus(tester);
    await fixture.keyboard(tester, 326);
    expect(
      fixture.caretRect.bottom,
      lessThanOrEqualTo(tester.getTopLeft(find.byKey(const ValueKey('footer'))).dy - 19),
    );
    expect(fixture.scrollController(tester).position.isScrollingNotifier.value, isFalse);
  });
}
