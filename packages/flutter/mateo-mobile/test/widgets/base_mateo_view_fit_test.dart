import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_view/base_mateo_view.dart';

import '../fixtures/surface_transform_test_widgets.dart';

const ValueKey<String> _viewKey = ValueKey('view');
const ValueKey<String> _contentKey = ValueKey('content');
const ValueKey<String> _headerKey = ValueKey('header');
const ValueKey<String> _footerKey = ValueKey('footer');

Widget _host(
  Widget child, {
  BoxConstraints constraints = const BoxConstraints(maxWidth: 300, maxHeight: 400),
  MediaQueryData media = const MediaQueryData(),
}) => MateoTheme(
  data: surfaceTransformTheme,
  child: Directionality(
    textDirection: .ltr,
    child: MediaQuery(
      data: media,
      child: Align(
        alignment: .bottomLeft,
        child: ConstrainedBox(constraints: constraints, child: child),
      ),
    ),
  ),
);

MateoView _view({
  bool header = false,
  bool footer = false,
  double contentHeight = 60,
  Alignment? alignment,
  Widget? overlay,
  bool scrollable = false,
}) => MateoView(
  key: _viewKey,
  header: header
      ? const MateoViewHeader(
          padding: .zero,
          principal: SizedBox(key: _headerKey, height: 30),
        )
      : null,
  footer: footer
      ? const MateoViewFooter(
          padding: .zero,
          principal: SizedBox(key: _footerKey, height: 40),
        )
      : null,
  overlay: overlay,
  surface: scrollable
      ? MateoViewSurface.scrollable(
          child: SizedBox(key: _contentKey, height: contentHeight),
        )
      : MateoViewSurface(
          alignment: alignment,
          padding: const .symmetric(horizontal: 10, vertical: 5),
          child: SizedBox(key: _contentKey, height: contentHeight),
        ),
);

BaseMateoView _fittedView({required MateoView child, bool fitHeight = true}) => BaseMateoView(
  key: child.key,
  padding: child.padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  fitHeight: fitHeight && !child.surface.isScrollable,
  surface: child.surface,
  header: child.header,
  footer: child.footer,
  overlay: child.overlay,
);

void main() {
  testWidgets('when switching between fit and fill, it should preserve content state', (tester) async {
    final contentKey = GlobalKey();
    Element? previous;
    for (final fitHeight in [true, false, true]) {
      await tester.pumpWidget(
        _host(
          _fittedView(
            fitHeight: fitHeight,
            child: MateoView(
              key: _viewKey,
              surface: MateoViewSurface(child: SizedBox(key: contentKey, height: 30)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      if (previous != null) expect(contentKey.currentContext, same(previous));
      previous = contentKey.currentContext! as Element;
      expect(tester.getSize(find.byKey(_viewKey)).height, fitHeight ? 54 : 400);
    }
  });

  for (final header in [false, true]) {
    for (final footer in [false, true]) {
      testWidgets(
        'when fitting with header $header and footer $footer, it should include content and each clearance once',
        (tester) async {
          await tester.pumpWidget(
            _host(
              _fittedView(
                child: _view(header: header, footer: footer),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final bounds = tester.getRect(find.byKey(_viewKey));
          expect(bounds.size, Size(300, 70 + (header ? 50 : 12) + (footer ? 60 : 12)));
          final content = tester.getRect(find.byKey(_contentKey));
          expect(content.height, 60);
          expect(content.top - bounds.top, 5 + (header ? 50 : 12));
          if (footer) expect(tester.getRect(find.byKey(_footerKey)).bottom, bounds.bottom);
          await tester.pumpAndSettle();
          expect(tester.getRect(find.byKey(_viewKey)), bounds);
        },
      );
    }
  }

  testWidgets('when first fitting fixed slots, it should include their clearance before the next frame', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_fittedView(child: _view(header: true, footer: true))));
    expect(tester.getSize(find.byKey(_viewKey)).height, 180);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(_viewKey)).height, 180);
  });

  testWidgets('when reading clearance during content layout, it should provide the current cached slot measurements', (
    tester,
  ) async {
    final measurements = <EdgeInsets>[];
    for (final headerHeight in [30.0, 70.0]) {
      await tester.pumpWidget(
        _host(
          _fittedView(
            child: MateoView(
              header: MateoViewHeader(
                padding: .zero,
                principal: SizedBox(height: headerHeight),
              ),
              footer: const MateoViewFooter(padding: .zero, principal: SizedBox(height: 40)),
              surface: MateoViewSurface(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    measurements.add(MateoViewLayoutScope.maybeOf(context)!.obstructionInsets);
                    return const SizedBox(height: 60);
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(measurements.last, EdgeInsets.only(top: headerHeight + 20, bottom: 60));
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('when fitting empty or aligned content, it should not expand the surface height', (tester) async {
    for (final alignment in [null, Alignment.center, Alignment.bottomRight]) {
      for (final height in [0.0, 60.0]) {
        await tester.pumpWidget(
          _host(
            _fittedView(
              child: _view(contentHeight: height, alignment: alignment),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.getSize(find.byKey(_viewKey)).height, height + 34);
      }
    }
  });

  testWidgets('when parent height is limited or has a minimum, it should respect those constraints', (tester) async {
    for (final height in [20.0, 600.0]) {
      await tester.pumpWidget(
        _host(
          _fittedView(
            child: _view(contentHeight: height),
          ),
          constraints: const BoxConstraints(minHeight: 100, maxHeight: 200, maxWidth: 300),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(_viewKey)).height, height == 20 ? 100 : 200);
    }
  });

  testWidgets('when content or fixed slots change, it should settle at the new fitted height', (tester) async {
    for (final height in [60.0, 130.0, 20.0]) {
      await tester.pumpWidget(
        _host(
          _fittedView(
            child: _view(contentHeight: height, header: height != 20, footer: height == 130),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byKey(_viewKey)).height,
        height + 10 + (height != 20 ? 50 : 12) + (height == 130 ? 60 : 12),
      );
    }
  });

  testWidgets('when an overlay is supplied, it should follow fitted bounds and receive taps without sizing the view', (
    tester,
  ) async {
    var taps = 0;
    const overlayKey = ValueKey('overlay');
    await tester.pumpWidget(
      _host(
        _fittedView(
          child: _view(
            overlay: GestureDetector(
              key: overlayKey,
              behavior: .opaque,
              onTap: () => taps++,
              child: const SizedBox(height: 1000),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(_viewKey)).height, 94);
    expect(tester.getRect(find.byKey(overlayKey)), tester.getRect(find.byKey(_viewKey)));
    await tester.tap(find.byKey(overlayKey));
    expect(taps, 1);
  });

  testWidgets('when the surface scrolls or content requests expansion, it should retain filling behavior', (
    tester,
  ) async {
    for (final surface in [
      const MateoViewSurface.scrollable(child: SizedBox(height: 60)),
      const MateoViewSurface(
        child: Column(children: [Expanded(child: SizedBox())]),
      ),
    ]) {
      await tester.pumpWidget(
        _host(
          _fittedView(
            child: MateoView(key: _viewKey, surface: surface),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(_viewKey)), const Size(300, 400));
    }
  });

  testWidgets('when fitting under safe-area insets, it should keep content clear and settle without oscillation', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        _fittedView(child: _view(header: true, footer: true)),
        media: const MediaQueryData(size: Size(800, 600), padding: .only(top: 24, bottom: 18)),
      ),
    );
    await tester.pumpAndSettle();
    final bounds = tester.getRect(find.byKey(_viewKey));
    expect(
      tester.getRect(find.byKey(_contentKey)).top,
      greaterThanOrEqualTo(tester.getRect(find.byKey(_headerKey)).bottom + 20),
    );
    expect(
      tester.getRect(find.byKey(_contentKey)).bottom,
      lessThanOrEqualTo(tester.getRect(find.byKey(_footerKey)).top - 20),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(tester.getRect(find.byKey(_viewKey)), bounds);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('when text scale increases, it should grow a content-sized column', (tester) async {
    double previousHeight = 0;
    for (final scale in [1.0, 2.0]) {
      await tester.pumpWidget(
        _host(
          _fittedView(
            child: const MateoView(
              key: _viewKey,
              surface: MateoViewSurface(
                child: Column(mainAxisSize: .min, children: [Text('A short message'), Text('More detail')]),
              ),
            ),
          ),
          media: MediaQueryData(textScaler: TextScaler.linear(scale)),
        ),
      );
      await tester.pumpAndSettle();
      final height = tester.getSize(find.byKey(_viewKey)).height;
      expect(height, greaterThan(previousHeight));
      previousHeight = height;
    }
  });
}
