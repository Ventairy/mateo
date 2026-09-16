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
              MateoViewFooter(
                leading: hasSides ? const SizedBox(key: ValueKey('optional-leading'), width: 32, height: 40) : null,
                trailing: hasSides ? const SizedBox(width: 48, height: 24) : null,
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        final bounds = tester.getRect(find.byType(MateoViewFooter));
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
        child: MateoViewFooter(principal: SizedBox.shrink()),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  const principalKey = ValueKey('principal');
  const leadingKey = ValueKey('leading');
  const trailingKey = ValueKey('trailing');
  Widget host(
    Widget child, {
    double bottom = 600,
    double width = 300,
    double left = 0,
    double keyboard = 0,
    EdgeInsets safe = EdgeInsets.zero,
    TextDirection direction = TextDirection.ltr,
  }) => Directionality(
    textDirection: direction,
    child: MediaQuery(
      data: MediaQueryData(
        size: const Size(800, 600),
        padding: safe,
        viewInsets: .only(bottom: keyboard),
      ),
      child: Stack(
        children: [Positioned(left: left, bottom: 600 - bottom, width: width, height: bottom, child: child)],
      ),
    ),
  );
  final footer = _inView(
    const MateoViewFooter(
      principal: SizedBox(key: principalKey, width: 60, height: 24),
      leading: SizedBox(key: leadingKey, width: 32, height: 40),
      trailing: SizedBox(key: trailingKey, width: 72, height: 32),
    ),
  );

  testWidgets('when side slots differ, it should center the principal and follow reading direction', (tester) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(host(footer, direction: direction));
      expect(tester.getCenter(find.byKey(principalKey)), const Offset(150, 580));
      expect(tester.getSize(find.byType(MateoViewFooter)).height, 40);
      expect(tester.getTopLeft(find.byKey(direction == TextDirection.ltr ? leadingKey : trailingKey)).dx, 0);
    }
    for (final width in [120.0, 50.0, 20.0]) {
      await tester.pumpWidget(host(footer, width: width));
      expect(tester.takeException(), isNull);
      final principal = tester.getRect(find.byKey(principalKey));
      expect(principal.left, greaterThanOrEqualTo(tester.getRect(find.byKey(leadingKey)).right));
      expect(principal.right, lessThanOrEqualTo(tester.getRect(find.byKey(trailingKey)).left));
    }
  });

  testWidgets('when its view reaches system edges, it should avoid them', (tester) async {
    await tester.pumpWidget(
      host(
        _inView(
          const MateoViewFooter(
            principal: SizedBox(key: principalKey, width: 60, height: 30),
          ),
        ),
        safe: const .only(left: 18, bottom: 24),
      ),
    );
    expect(tester.getBottomLeft(find.byKey(principalKey)), const Offset(138, 576));
    await tester.pumpWidget(
      host(
        _inView(
          const MateoViewFooter(
            principal: SizedBox(key: principalKey, width: 60, height: 30),
          ),
        ),
        safe: const .only(right: 20, bottom: 24),
        left: 500,
      ),
    );
    expect(tester.getBottomLeft(find.byKey(principalKey)), const Offset(600, 576));
  });

  testWidgets('when above a keyboard, it should move only by the actual overlap and restore on dismissal', (
    tester,
  ) async {
    for (final bottom in [600.0, 450.0, 400.0, 300.0]) {
      await tester.pumpWidget(host(footer, bottom: bottom, keyboard: 200, safe: const .only(bottom: 24)));
      expect(tester.getBottomLeft(find.byKey(leadingKey)).dy, bottom > 400 ? 400 : bottom);
      await tester.pumpAndSettle();
      expect(tester.getBottomLeft(find.byKey(leadingKey)).dy, bottom > 400 ? 400 : bottom);
    }
    await tester.pumpWidget(host(footer, safe: const .only(bottom: 24)));
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(leadingKey)).dy, 576);
  });

  testWidgets('when the footer moves, it should preserve media data and interactive semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    MediaQueryData? observed;
    await tester.pumpWidget(
      host(
        _inView(
          MateoViewFooter(
            principal: Builder(
              builder: (context) {
                observed = MediaQuery.of(context);
                return GestureDetector(
                  onTap: () => taps++,
                  behavior: .opaque,
                  child: Semantics(
                    label: 'Continue',
                    button: true,
                    child: const SizedBox(key: principalKey, width: 80, height: 40),
                  ),
                );
              },
            ),
          ),
        ),
        keyboard: 200,
        safe: const .only(bottom: 24),
      ),
    );
    await tester.pumpAndSettle();
    expect(observed!.padding.bottom, 24);
    expect(observed!.viewInsets.bottom, 200);
    await tester.tap(find.byKey(principalKey));
    expect(taps, 1);
    expect(find.bySemanticsLabel('Continue'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('when supplied with custom padding, it should use it and grow with larger text', (tester) async {
    await tester.pumpWidget(
      host(
        _inView(
          const MateoViewFooter(
            padding: .fromLTRB(10, 5, 30, 15),
            principal: SizedBox(key: principalKey, width: double.infinity, height: 30),
          ),
        ),
      ),
    );
    expect(tester.getRect(find.byKey(principalKey)), const Rect.fromLTWH(10, 555, 260, 30));
    double? previous;
    for (final scale in [1.0, 2.0]) {
      await tester.pumpWidget(
        host(
          MediaQuery(
            data: MediaQueryData(size: const Size(800, 600), textScaler: TextScaler.linear(scale)),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 20),
              child: _inView(const MateoViewFooter(principal: Text('A longer footer that wraps'))),
            ),
          ),
          width: 160,
        ),
      );
      final height = tester.getSize(find.byType(MateoViewFooter)).height;
      if (previous != null) expect(height, greaterThan(previous));
      previous = height;
    }
  });
  testWidgets('when the keyboard consumes system padding, it should follow the keyboard and restore system clearance', (
    tester,
  ) async {
    for (final keyboard in [0.0, 200.0, 0.0]) {
      await tester.pumpWidget(
        Directionality(
          textDirection: .ltr,
          child: MediaQuery(
            data: MediaQueryData(
              size: const Size(800, 600),
              padding: .only(bottom: keyboard == 0 ? 24 : 0),
              viewPadding: const .only(bottom: 24),
              viewInsets: .only(bottom: keyboard),
            ),
            child: Align(
              alignment: .bottomLeft,
              child: SizedBox(
                width: 300,
                child: _inView(
                  const MateoViewFooter(
                    principal: SizedBox(key: principalKey, height: 30),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getBottomLeft(find.byKey(principalKey)).dy, keyboard == 0 ? 576 : 400);
    }
  });
}

Widget _inView(MateoViewFooter footer) => MateoView(
  padding: EdgeInsets.zero,
  footer: footer,
  surface: const MateoViewSurface(color: Color(0x00000000), child: SizedBox.shrink()),
);
