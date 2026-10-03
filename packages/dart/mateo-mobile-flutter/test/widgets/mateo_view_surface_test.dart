import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  testWidgets('when outside its view slot, it should explain the required owner', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: .ltr,
        child: MateoViewSurface(child: SizedBox.shrink()),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('when a reusable surface is nested, it should keep padding local through view updates', (tester) async {
    const nestedKey = ValueKey('nested');
    const childKey = ValueKey('child');
    for (final pagePadding in [20.0, 40.0]) {
      await tester.pumpWidget(
        Directionality(
          textDirection: .rtl,
          child: MateoView(
            padding: EdgeInsets.all(pagePadding),
            header: const MateoViewHeader(principal: SizedBox(height: 30)),
            footer: const MateoViewFooter(principal: SizedBox(height: 40)),
            surface: const MateoViewSurface(
              color: Color(0xFF123456),
              child: MateoSurface(
                key: nestedKey,
                color: Color(0xFF123456),
                padding: EdgeInsetsDirectional.fromSTEB(7, 11, 13, 17),
                child: SizedBox(key: childKey),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final nested = tester.getRect(find.byKey(nestedKey));
      final child = tester.getRect(find.byKey(childKey));
      expect(child.topLeft - nested.topLeft, const Offset(13, 11));
      expect(nested.bottomRight - child.bottomRight, const Offset(7, 17));
    }
  });
}
