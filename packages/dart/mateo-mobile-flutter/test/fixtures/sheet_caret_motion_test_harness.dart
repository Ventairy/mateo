import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import 'surface_transform_test_widgets.dart';

class SheetCaretMotionTestHarness {
  new({
    this.contentHeight = 240,
    this.textScale = 1,
    this.reducedMotion = false,
    this.inputAtBottom = false,
    this.avoidBottomInset = true,
  });

  final double contentHeight;
  final double textScale;
  final bool reducedMotion;
  final bool inputAtBottom;
  final bool avoidBottomInset;
  final navigatorKey = GlobalKey<NavigatorState>();
  late final ValueNotifier<MediaQueryData> media = ValueNotifier(
    MediaQueryData(
      size: const Size(390, 844),
      padding: const EdgeInsets.only(top: 47),
      viewPadding: const EdgeInsets.only(top: 47, bottom: 34),
      viewInsets: const EdgeInsets.only(bottom: 336),
      textScaler: TextScaler.linear(textScale),
      reduceMotion: reducedMotion,
    ),
  );
  late BuildContext _launcher;

  Widget get app => MateoApp(
    navigatorKey: navigatorKey,
    theme: surfaceTransformTheme,
    builder: (context, child) => ValueListenableBuilder(
      valueListenable: media,
      builder: (context, value, _) => MediaQuery(data: value, child: child!),
    ),
    home: Builder(
      builder: (context) {
        _launcher = context;
        return const SizedBox.expand();
      },
    ),
  );

  Future<void> pump(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1
      ..viewInsets = const FakeViewPadding(bottom: 336);
    addTearDown(tester.view.reset);
    addTearDown(dispose);
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
  }

  void open() => unawaited(
    showMateoSheet<void>(
      context: _launcher,
      avoidBottomInset: avoidBottomInset,
      view: MateoSheetView(
        key: const ValueKey('caret_motion_sheet'),
        reserveHeaderSpace: false,
        header: const MateoSheetViewHeader(presentation: .closeButton()),
        surface: .scrollable(
          padding: const .all(32),
          child: SizedBox(
            height: contentHeight,
            child: Align(
              alignment: inputAtBottom ? .bottomLeft : .topLeft,
              child: MateoTextInput(
                placeholder: 'Phone number',
                presentation: const .phone(size: .large),
                onChanged: (_) {},
              ),
            ),
          ),
        ),
        footer: MateoSheetViewFooter(
          principal: MateoButton(
            key: const ValueKey('caret_motion_continue'),
            presentation: .label(label: 'Continue', variant: .primary.neutral, width: const .fill()),
            onPressed: () {},
          ),
        ),
      ),
    ),
  );

  void dispose() => media.dispose();
}
