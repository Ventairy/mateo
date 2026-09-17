import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_view/base_mateo_view.dart';

class _KeyboardHost {
  _KeyboardHost(this.safeBottom, {this.fitHeight = false});

  final double safeBottom;
  final bool fitHeight;
  final ValueNotifier<({double keyboard, double footerHeight, int footerKey, bool present, bool offstage})>
  configuration = ValueNotifier((
    keyboard: 0.0,
    footerHeight: 56.0,
    footerKey: 0,
    present: true,
    offstage: false,
  ));

  Future<void> mount(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(configuration.dispose);
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: ValueListenableBuilder(
          valueListenable: configuration,
          builder: (_, value, child) => MediaQuery(
            data: MediaQueryData(
              size: const Size(390, 844),
              viewPadding: .only(bottom: safeBottom),
              padding: .only(bottom: (safeBottom - value.keyboard).clamp(0, safeBottom)),
              viewInsets: .only(bottom: value.keyboard),
            ),
            child: Offstage(
              offstage: value.offstage,
              child: Align(
                child: Builder(
                  builder: (context) {
                    final view = MateoView(
                      avoidBottomInset: false,
                      footer: value.present
                          ? MateoViewFooter(
                              key: ValueKey(value.footerKey),
                              padding: .only(
                                bottom:
                                    14 +
                                    (fitHeight
                                        ? MediaQuery.viewPaddingOf(context).bottom -
                                              MediaQuery.paddingOf(context).bottom
                                        : 0),
                              ),
                              leading: SizedBox(width: 56, height: value.footerHeight),
                            )
                          : null,
                      surface: MateoViewSurface(
                        color: MateoPalette().white,
                        padding: .zero,
                        child: fitHeight
                            ? const SizedBox(height: 180, key: ValueKey('content'))
                            : const SizedBox.expand(key: ValueKey('content')),
                      ),
                    );
                    if (!fitHeight) return view;
                    return BaseMateoView(fitHeight: true, surface: view.surface, footer: view.footer);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  double height(WidgetTester tester) =>
      tester.getSize(find.byKey(const ValueKey('content'), skipOffstage: false)).height;
}

void main() {
  testWidgets('when a fitted view changes keyboard padding, it should preserve content and restore fitted bounds', (
    tester,
  ) async {
    final host = _KeyboardHost(34, fitHeight: true);
    await host.mount(tester);
    final resting = host.height(tester);
    final fittedHeight = tester.getSize(find.byType(BaseMateoView)).height;
    final samples = <double>[];
    for (final keyboard in [8.0, 20.0, 34.0, 335.0, 29.734, 21.647, 8.115, 0.0]) {
      host.configuration.value = (keyboard: keyboard, footerHeight: 56, footerKey: 0, present: true, offstage: false);
      await tester.pump(const Duration(milliseconds: 16));
      samples.add(host.height(tester) - resting);
    }
    await tester.pumpAndSettle();
    samples.add(host.height(tester) - resting);
    expect(samples, everyElement(closeTo(0, .001)));
    expect(tester.getSize(find.byType(BaseMateoView)).height, fittedHeight);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
  for (final safeBottom in [0.0, 18.0, 34.0, 48.0]) {
    testWidgets(
      'when keyboard animates with bottom inset $safeBottom, it should preserve compensated content each frame',
      (tester) async {
        final host = _KeyboardHost(safeBottom);
        await host.mount(tester);
        final resting = host.height(tester);
        final samples = <double>[];
        for (final fraction in [
          0.1,
          0.3,
          0.65,
          0.9,
          1.0,
          2.0,
          10.0,
          2.0,
          1.0,
          .875,
          .637,
          .461,
          .332,
          .239,
          .122,
          .087,
          .044,
          .031,
          .022,
          .015,
          0.0,
        ]) {
          host.configuration.value = (
            keyboard: fraction * (safeBottom == 0 ? 34 : safeBottom),
            footerHeight: 56,
            footerKey: 0,
            present: true,
            offstage: false,
          );
          await tester.pump(const Duration(milliseconds: 16));
          samples.add(host.height(tester) - resting);
        }
        await tester.pumpAndSettle();
        samples.add(host.height(tester) - resting);
        await tester.pumpWidget(const SizedBox());
        expect(samples, everyElement(closeTo(0, .001)));
      },
    );
  }

  testWidgets('when footer content changes without safe-area changes, it should resize content in the same frame', (
    tester,
  ) async {
    final host = _KeyboardHost(34);
    await host.mount(tester);
    final resting = host.height(tester);
    final samples = <double>[];
    for (final height in [96.0, 36.0, 56.0]) {
      host.configuration.value = (keyboard: 0, footerHeight: height, footerKey: 0, present: true, offstage: false);
      await tester.pump();
      samples.add(host.height(tester) - resting);
    }
    expect(samples, [-40, 20, 0]);
  });

  testWidgets(
    'when keyboard and footer content change together, it should resolve the current content without oscillation',
    (tester) async {
      final host = _KeyboardHost(34);
      await host.mount(tester);
      final resting = host.height(tester);
      host.configuration.value = (keyboard: 335, footerHeight: 96, footerKey: 0, present: true, offstage: false);
      await tester.pumpAndSettle();
      expect((host.height(tester) - resting, tester.binding.hasScheduledFrame), (-40, false));
    },
  );

  testWidgets('when footer is removed and replaced during keyboard changes, it should discard its old clearance', (
    tester,
  ) async {
    final host = _KeyboardHost(34);
    await host.mount(tester);
    final resting = host.height(tester);
    host.configuration.value = (keyboard: 335, footerHeight: 56, footerKey: 0, present: false, offstage: false);
    await tester.pumpAndSettle();
    final removedHeight = host.height(tester);
    host.configuration.value = (keyboard: 0, footerHeight: 96, footerKey: 1, present: true, offstage: false);
    await tester.pumpAndSettle();
    expect((removedHeight - resting, host.height(tester) - resting), (104, -40));
  });

  testWidgets('when keyboard changes while offstage, it should resolve clearance before the view returns', (
    tester,
  ) async {
    final host = _KeyboardHost(34);
    await host.mount(tester);
    final resting = host.height(tester);
    host.configuration.value = (keyboard: 335, footerHeight: 56, footerKey: 0, present: true, offstage: true);
    await tester.pumpAndSettle();
    host.configuration.value = (keyboard: 0, footerHeight: 56, footerKey: 0, present: true, offstage: false);
    await tester.pump();
    expect(host.height(tester), resting);
  });

  testWidgets('when a keyed footer is replaced with the keyboard changing, it should measure the replacement', (
    tester,
  ) async {
    final host = _KeyboardHost(34);
    await host.mount(tester);
    final resting = host.height(tester);
    host.configuration.value = (keyboard: 335, footerHeight: 96, footerKey: 1, present: true, offstage: false);
    await tester.pumpAndSettle();
    expect(host.height(tester) - resting, -40);
    host.configuration.value = (keyboard: 0, footerHeight: 36, footerKey: 2, present: true, offstage: false);
    await tester.pumpAndSettle();
    expect(host.height(tester) - resting, 20);
  });

  testWidgets('when disposed after a safe-area update, it should stop further layout work safely', (
    tester,
  ) async {
    final host = _KeyboardHost(34);
    await host.mount(tester);
    host.configuration.value = (keyboard: 335, footerHeight: 56, footerKey: 0, present: true, offstage: false);
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
