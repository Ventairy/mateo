import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_view/base_mateo_view.dart';

void main() {
  for (final unmountView in [false, true]) {
    testWidgets(
      'when ${unmountView ? 'the view unmounts' : 'its header is removed'}, it should dispose the header measurements',
      (tester) async {
        MateoViewLayoutScope? scope;
        Widget view({required bool hasHeader}) => Directionality(
          textDirection: .ltr,
          child: MateoView(
            header: hasHeader ? const MateoViewHeader(principal: SizedBox(height: 20)) : null,
            surface: MateoViewSurface(
              color: const Color(0xFFFFFFFF),
              child: Builder(
                builder: (context) {
                  scope = MateoViewLayoutScope.maybeOf(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        await tester.pumpWidget(view(hasHeader: true));
        final header = scope!.header!;
        await tester.pumpWidget(view(hasHeader: true));
        expect(scope!.header!.changes, same(header.changes));
        expect(scope!.header!.height, header.height);

        await tester.pumpWidget(unmountView ? const SizedBox() : view(hasHeader: false));
        expect(tester.takeException(), isNull);
        if (!unmountView) expect(scope!.header, isNull);

        // The shared notification no longer accepts observers after disposal.
        expect(() => header.changes.addListener(() {}), throwsFlutterError);
      },
    );
  }

  testWidgets('when a descendant reads view coordination, it should receive updates from its nearest view', (
    tester,
  ) async {
    MateoViewLayoutScope? outer;
    MateoViewLayoutScope? inner;
    var builds = 0;
    final observer = Builder(
      builder: (context) {
        outer = MateoViewLayoutScope.maybeOf(context);
        builds++;
        return const SizedBox();
      },
    );
    final nested = MateoView(
      padding: const .all(7),
      header: const MateoViewHeader(principal: SizedBox(height: 20)),
      surface: MateoViewSurface(
        color: const Color(0xFFFFFFFF),
        child: Builder(
          builder: (context) {
            inner = MateoViewLayoutScope.maybeOf(context);
            return const SizedBox();
          },
        ),
      ),
    );
    for (final padding in [12.0, 24.0]) {
      final before = builds;
      await tester.pumpWidget(
        Directionality(
          textDirection: .ltr,
          child: MateoView(
            padding: .all(padding),
            surface: MateoViewSurface(
              color: const Color(0xFFFFFFFF),
              child: Column(
                children: [
                  observer,
                  Expanded(child: nested),
                ],
              ),
            ),
          ),
        ),
      );
      expect(outer, isNotNull);
      expect(inner, isNotNull);
      expect(identical(outer, inner), isFalse);
      expect(outer!.padding, EdgeInsets.all(padding));
      expect(inner!.padding, const EdgeInsets.all(7));
      expect(outer!.header, isNull);
      expect(inner!.header, isNotNull);
      expect(builds, greaterThan(before));
    }
  });

  testWidgets('when outside a view, it should return no coordination', (tester) async {
    MateoViewLayoutScope? scope;
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          scope = MateoViewLayoutScope.maybeOf(context);
          return const SizedBox();
        },
      ),
    );
    expect(scope, isNull);
  });
}
