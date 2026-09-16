import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_view/base_mateo_view.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  Widget host(Widget view) => MateoTheme(
    data: surfaceTransformTheme,
    child: Directionality(
      textDirection: .ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Align(child: SizedBox(width: 300, height: 400, child: view)),
      ),
    ),
  );
  for (final header in [false, true]) {
    for (final footer in [false, true]) {
      testWidgets('when header is $header and footer is $footer, it should reserve each padded edge once', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(
            MateoView(
              padding: const EdgeInsets.fromLTRB(10, 30, 20, 50),
              header: header ? const MateoViewHeader(principal: SizedBox(height: 15)) : null,
              footer: footer ? const MateoViewFooter(principal: SizedBox(height: 25)) : null,
              surface: const MateoViewSurface(child: SizedBox.expand(key: ValueKey('content'))),
            ),
          ),
        );
        final view = tester.getRect(find.byType(MateoView));
        final content = tester.getRect(find.byKey(const ValueKey('content')));
        expect(content.top - view.top, header ? 65 : 30);
        expect(view.bottom - content.bottom, footer ? 95 : 50);
        await tester.pumpAndSettle();
        expect(tester.getRect(find.byKey(const ValueKey('content'))), content);
      });
    }
  }
  testWidgets(
    'when padding and slots change while scrolled, it should preserve state and reserve the final bottom edge',
    (tester) async {
      ScrollableState? previousScroll;
      Element? previousContent;
      for (final footer in [false, true, false]) {
        await tester.pumpWidget(
          host(
            MateoView(
              padding: EdgeInsets.only(top: 30, bottom: footer ? 70 : 50),
              footer: footer ? const MateoViewFooter(principal: SizedBox(height: 25)) : null,
              surface: const MateoViewSurface.scrollable(child: SizedBox(key: ValueKey('content'), height: 1200)),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
        final content = tester.element(find.byKey(const ValueKey('content')));
        if (previousScroll != null) {
          expect(scroll, same(previousScroll));
          expect(content, same(previousContent));
          expect(scroll.position.pixels, 100);
        }
        scroll.position.jumpTo(scroll.position.maxScrollExtent);
        await tester.pump();
        final bounds = tester.getRect(find.byType(MateoView));
        expect(bounds.bottom - tester.getRect(find.byKey(const ValueKey('content'))).bottom, footer ? 115 : 50);
        scroll.position.jumpTo(100);
        previousScroll = scroll;
        previousContent = content;
      }
    },
  );
  testWidgets('when fitted content is bottom aligned, it should include view clearance and explicit surface padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const Align(
          child: BaseMateoView(
            fitHeight: true,
            padding: EdgeInsets.only(top: 30, bottom: 50),
            surface: MateoViewSurface(
              alignment: .bottomCenter,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(key: ValueKey('content'), height: 60),
            ),
          ),
        ),
      ),
    );
    final bounds = tester.getRect(find.byType(BaseMateoView));
    final content = tester.getRect(find.byKey(const ValueKey('content')));
    expect(bounds.height, 150);
    expect(content.top - bounds.top, 35);
    expect(bounds.bottom - content.bottom, 55);
  });
}
