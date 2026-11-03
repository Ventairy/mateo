import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

class MateoSurfaceCaretFixture {
  final focusNode = FocusNode();
  final textController = TextEditingController(text: 'Draft');
  final navigatorKey = GlobalKey<NavigatorState>();
  final footerHeight = ValueNotifier<double>(56);
  late final ValueNotifier<({FocusNode focusNode, TextEditingController textController, bool enabled})> inputBinding =
      ValueNotifier((focusNode: focusNode, textController: textController, enabled: true));

  Future<void> mount(
    WidgetTester tester, {
    MateoTextInputPresentation presentation = const .general(variant: .filled),
    bool avoidBottomInset = true,
    bool standalone = false,
    bool sheet = false,
    Widget Function(Widget content)? wrapContent,
  }) async {
    addTearDown(focusNode.dispose);
    addTearDown(textController.dispose);
    addTearDown(footerHeight.dispose);
    addTearDown(inputBinding.dispose);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.viewPadding = const FakeViewPadding(top: 24, bottom: 34);
    tester.view.padding = const FakeViewPadding(top: 24, bottom: 34);
    addTearDown(tester.view.reset);
    final content = Column(
      children: [
        const SizedBox(height: 520),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: ValueListenableBuilder(
            valueListenable: inputBinding,
            builder: (_, binding, child) => MateoTextInput(
              key: const ValueKey('input'),
              placeholder: 'Message',
              presentation: presentation,
              focusNode: binding.focusNode,
              controller: binding.textController,
              autofocus: false,
              onChanged: binding.enabled ? (_) {} : null,
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
    await tester.pumpWidget(
      MateoApp(
        navigatorKey: navigatorKey,
        theme: MateoThemeData.light(accentColor: MateoPalette().red[9], onAccent: MateoPalette().white),
        home: sheet
            ? const SizedBox()
            : standalone
            ? MateoSurface.scrollable(
                width: const .fill(),
                height: const .fill(),
                padding: const .all(20),
                child: content,
              )
            : MateoView(
                avoidBottomInset: avoidBottomInset,
                header: const MateoViewHeader(principal: SizedBox(height: 40)),
                footer: MateoViewFooter(
                  principal: ValueListenableBuilder<double>(
                    valueListenable: footerHeight,
                    builder: (_, height, child) => SizedBox(key: const ValueKey('footer'), height: height),
                  ),
                ),
                surface: MateoViewSurface.scrollable(
                  padding: const .all(20),
                  child: wrapContent?.call(content) ?? content,
                ),
              ),
      ),
    );
    await tester.pumpAndSettle();
    if (sheet) {
      unawaited(
        showMateoSheet<void>(
          context: navigatorKey.currentContext!,
          view: MateoSheetView(
            surface: MateoSheetViewSurface.scrollable(child: content),
            footer: const MateoSheetViewFooter(principal: SizedBox(key: ValueKey('footer'), height: 56)),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }
  }

  Future<void> focus(WidgetTester tester) async {
    inputBinding.value.focusNode.requestFocus();
    await tester.pumpAndSettle();
  }

  Future<void> keyboard(WidgetTester tester, double height) async {
    tester.view.viewInsets = FakeViewPadding(bottom: height);
    tester.view.padding = FakeViewPadding(top: 24, bottom: height == 0 ? 34 : 0);
    await tester.pumpAndSettle();
  }

  Rect get caretRect {
    final editor = inputBinding.value.focusNode.context!.findAncestorStateOfType<EditableTextState>()!;
    return MatrixUtils.transformRect(
      editor.renderEditable.getTransformTo(null),
      editor.renderEditable.getLocalRectForCaret(inputBinding.value.textController.selection.extent),
    );
  }

  ScrollController scrollController(WidgetTester tester) =>
      tester.widget<CustomScrollView>(find.byType(CustomScrollView).first).controller!;
}
