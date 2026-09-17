import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  testWidgets('when principal is omitted, it should lay out side slots and an empty slot', (tester) async {
    for (final direction in TextDirection.values) {
      for (final hasSides in [true, false]) {
        await tester.pumpWidget(
          Directionality(
            textDirection: direction,
            child: _inView(
              MateoViewHeader(
                leading: hasSides ? const SizedBox(key: ValueKey('optional-leading'), width: 32, height: 40) : null,
                trailing: hasSides ? const SizedBox(width: 48, height: 24) : null,
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        final bounds = tester.getRect(find.byType(MateoViewHeader));
        expect(bounds.height, hasSides ? 40 : 0);
        if (hasSides) {
          final leading = tester.getRect(find.byKey(const ValueKey('optional-leading')));
          expect(
            direction == TextDirection.ltr ? leading.left : leading.right,
            direction == TextDirection.ltr ? bounds.left : bounds.right,
          );
        }
      }
    }
  });

  testWidgets('when used outside its view slot, it should explain the required owner', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: .ltr,
        child: MateoViewHeader(principal: SizedBox.shrink()),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  Widget host(Widget child, {double width = 320, TextDirection direction = TextDirection.ltr}) => Directionality(
    textDirection: direction,
    child: Center(
      child: SizedBox(width: width, child: child),
    ),
  );
  const principal = SizedBox(key: ValueKey('principal'), width: 60, height: 24);
  const leading = SizedBox(key: ValueKey('leading'), width: 32, height: 40);
  const trailing = SizedBox(key: ValueKey('trailing'), width: 72, height: 32);

  testWidgets('when side slots differ, it should keep the principal truly centered', (tester) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        host(
          _inView(const MateoViewHeader(principal: principal, leading: leading, trailing: trailing)),
          direction: direction,
        ),
      );
      final bounds = tester.getRect(find.byType(MateoViewHeader));
      expect(bounds.height, 40);
      expect(tester.getCenter(find.byKey(const ValueKey('principal'))).dx, bounds.center.dx);
      for (final key in ['leading', 'principal', 'trailing']) {
        expect(tester.getCenter(find.byKey(ValueKey(key))).dy, bounds.top + 20);
      }
      expect(
        tester.getTopLeft(find.byKey(ValueKey(direction == TextDirection.ltr ? 'leading' : 'trailing'))).dx,
        bounds.left,
      );
    }
  });

  testWidgets('when side slots are absent, it should reserve no unnecessary gaps', (tester) async {
    await tester.pumpWidget(host(_inView(const MateoViewHeader(principal: SizedBox(width: 500, height: 24)))));
    expect(tester.getSize(find.byType(MateoViewHeader)), const Size(320, 24));
    expect(tester.getSize(find.byWidgetPredicate((widget) => widget is SizedBox && widget.width == 500)).width, 320);
    await tester.pumpWidget(host(_inView(const MateoViewHeader(principal: principal, leading: leading))));
    expect(
      tester.getCenter(find.byKey(const ValueKey('principal'))).dx,
      tester.getCenter(find.byType(MateoViewHeader)).dx,
    );
  });

  testWidgets('when width is narrow, it should constrain slots without overlapping them', (tester) async {
    for (final width in [120.0, 50.0, 20.0]) {
      await tester.pumpWidget(
        host(
          _inView(const MateoViewHeader(principal: principal, leading: leading, trailing: trailing)),
          width: width,
        ),
      );
      expect(tester.takeException(), isNull);
      final middle = tester.getRect(find.byKey(const ValueKey('principal')));
      expect(middle.width, greaterThanOrEqualTo(0));
      expect(middle.left, greaterThanOrEqualTo(tester.getRect(find.byKey(const ValueKey('leading'))).right));
      expect(middle.right, lessThanOrEqualTo(tester.getRect(find.byKey(const ValueKey('trailing'))).left));
    }
  });

  testWidgets('when text scales, it should grow naturally from the header title style', (tester) async {
    double? original;
    for (final scale in [1.0, 2.0]) {
      await tester.pumpWidget(
        host(
          MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: _inView(
              const MateoViewHeader(principal: Text('A longer heading that wraps', textAlign: .center)),
            ),
          ),
        ),
      );
      final height = tester.getSize(find.byType(MateoViewHeader)).height;
      if (original != null) expect(height, greaterThan(original));
      original = height;
    }
  });

  testWidgets('when controls have semantics, it should preserve their labels and tap actions', (tester) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpWidget(
      host(
        _inView(
          MateoViewHeader(
            principal: principal,
            leading: GestureDetector(
              behavior: .opaque,
              onTap: () => taps++,
              child: Semantics(label: 'Back', button: true, child: const SizedBox(width: 40, height: 40)),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.bySemanticsLabel('Back'));
    expect(taps, 1);
    expect(find.bySemanticsLabel('Back'), findsOneWidget);
    semantics.dispose();
  });
  testWidgets('when its view reaches unsafe edges, it should avoid them', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(800, 600), padding: EdgeInsets.only(top: 24, left: 18)),
          child: Align(
            alignment: .topLeft,
            child: SizedBox(width: 300, child: _inView(const MateoViewHeader(principal: principal))),
          ),
        ),
      ),
    );
    expect(tester.getTopLeft(find.byKey(const ValueKey('principal'))), const Offset(138, 24));
  });
}

Widget _inView(MateoViewHeader header) => MateoView(
  padding: EdgeInsets.zero,
  header: header,
  surface: const MateoViewSurface(color: Color(0x00000000), child: SizedBox.shrink()),
);
