import 'dart:async';
import 'dart:ui' show Tristate;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/mateo_surface_scope.dart';

import '../fixtures/surface_transform_targets.dart';
import '../fixtures/surface_transform_test_widgets.dart';

Widget host(Widget child, {TextDirection direction = TextDirection.ltr, double scale = 1}) => Directionality(
  textDirection: direction,
  child: MediaQuery(
    data: MediaQueryData(size: const Size(800, 600), textScaler: TextScaler.linear(scale)),
    child: MateoTheme(
      data: surfaceTransformTheme,
      child: Center(child: child),
    ),
  ),
);
void main() {
  for (final density in MateoMenuDensity.values) {
    for (final withBackground in [false, true]) {
      testWidgets(
        'when $density leading content ${withBackground ? 'has a background' : 'has no background'}, it should size wrapped icons accordingly',
        (tester) async {
          Future<void> show({double? explicitSize}) => tester.pumpWidget(
            host(
              MateoMenu(
                presentation: .options(
                  density: density,
                  items: [
                    MateoMenuOptionsPresentationItem(
                      leading: Padding(
                        padding: const EdgeInsets.all(2),
                        child: MateoIcon(
                          .cross,
                          size: explicitSize,
                          backgroundColor: withBackground ? surfaceTransformTheme.colorScheme.background : null,
                        ),
                      ),
                      principal: const Text('Option'),
                    ),
                  ],
                ),
              ),
            ),
          );
          await show();
          final expected = density == MateoMenuDensity.standard
              ? (withBackground ? 44.0 : 38.0)
              : (withBackground ? 34.0 : 30.0);
          expect(tester.getSize(find.byType(MateoIcon)), Size.square(expected));
          await show(explicitSize: 22);
          expect(tester.getSize(find.byType(MateoIcon)), const Size.square(22));
        },
      );
    }
  }
  testWidgets('when a menu inherits surface animation, it should isolate nested surfaces and react to scope changes', (
    tester,
  ) async {
    final inherited = MateoSurfaceAnimation.transform(
      target: surfaceTransformTarget('menu-scope'),
    );
    final menu = MateoMenu(
      presentation: .options(
        items: [
          const MateoMenuOptionsPresentationItem(
            principal: MateoSurface(child: SizedBox(width: 40, height: 40)),
          ),
        ],
      ),
    );
    for (final animation in [inherited, const MateoSurfaceAnimation.none()]) {
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          home: Center(
            child: MateoSurfaceScope(animation: animation, child: menu),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final surfaces = tester.widgetList<BaseMateoSurface>(find.byType(BaseMateoSurface)).toList();
      expect(surfaces.first.animation, same(animation));
      expect(surfaces.last.animation, const MateoSurfaceAnimation.none());
    }
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        home: Center(child: menu),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widgetList<BaseMateoSurface>(find.byType(BaseMateoSurface)).map((surface) => surface.animation),
      everyElement(const MateoSurfaceAnimation.none()),
    );
    expect(tester.takeException(), isNull);
  });

  test('when options are empty, it should reject the presentation', () {
    expect(() => MateoMenuPresentation.options(items: const []), throwsArgumentError);
  });
  testWidgets('snapshot preserves content and natural sizing', (tester) async {
    final items = [const MateoMenuOptionsPresentationItem(principal: Text('Original'))];
    final presentation = MateoMenuPresentation.options(items: items);
    items.clear();
    await tester.pumpWidget(host(MateoMenu(presentation: presentation)));
    expect(find.text('Original'), findsOneWidget);
    expect(tester.getSize(find.byType(MateoSurface)).height, 56 + MateoMenuDensity.standard.verticalPadding * 2);
    expect(tester.getSize(find.byType(MateoSurface)).width, lessThan(300));
  });
  for (final density in MateoMenuDensity.values) {
    testWidgets('when $density has short content, it should fit content and fill available width', (tester) async {
      Widget menu({MateoMenuWidth width = .fit}) => MateoMenu(
        presentation: .options(
          density: density,
          width: width,
          items: [const MateoMenuOptionsPresentationItem(principal: Text('Go'))],
        ),
      );
      await tester.pumpWidget(host(menu()));
      expect(tester.getSize(find.byType(MateoSurface)).width, lessThan(192));
      for (final direction in TextDirection.values) {
        await tester.pumpWidget(host(menu(), direction: direction));
        final panel = tester.getRect(find.byType(MateoSurface));
        final label = tester.getRect(find.text('Go'));
        final trailing = direction == TextDirection.ltr ? panel.right - label.right : label.left - panel.left;
        expect(trailing, density.horizontalPadding + (density == MateoMenuDensity.compact ? 12 : 16));
      }
      await tester.pumpWidget(host(menu(width: .fill)));
      expect(tester.getSize(find.byType(MateoSurface)).width, 760);
      await tester.pumpWidget(host(SizedBox(width: 160, child: menu(width: .fill))));
      expect(tester.getSize(find.byType(MateoSurface)).width, 160);
      expect(tester.takeException(), isNull);
    });
    testWidgets('when $density reaches device edges, it should cap width and wrap content', (tester) async {
      Future<void> show(double deviceWidth) => tester.pumpWidget(
        host(
          MediaQuery(
            data: MediaQueryData(size: Size(deviceWidth, 600)),
            child: MateoMenu(
              presentation: .options(
                density: density,
                items: [
                  const MateoMenuOptionsPresentationItem(
                    principal: Text('A long menu option that wraps within the available device width'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await show(320);
      expect(tester.getSize(find.byType(MateoSurface)).width, 280);
      await show(200);
      expect(tester.getSize(find.byType(MateoSurface)).width, 160);
      expect(tester.takeException(), isNull);
    });
    testWidgets('when $density has multiple items, it should add a tappable gap only between them', (tester) async {
      const firstKey = ValueKey('first-content');
      const lastKey = ValueKey('last-content');
      const first = MateoMenuOptionsPresentationItem(principal: SizedBox(key: firstKey, width: 60, height: 60));
      const last = MateoMenuOptionsPresentationItem(principal: SizedBox(key: lastKey, width: 60, height: 60));
      final selected = <MateoMenuOptionsPresentationItem>[];
      Future<void> show(List<MateoMenuOptionsPresentationItem> items) => tester.pumpWidget(
        host(
          MateoMenu(
            presentation: .options(density: density, items: items),
            onItemPressed: selected.add,
          ),
        ),
      );
      await show([first, last]);
      final panel = tester.getRect(find.byType(MateoSurface));
      final firstContent = tester.getRect(find.byKey(firstKey));
      final lastContent = tester.getRect(find.byKey(lastKey));
      expect(firstContent.top - panel.top, density.verticalPadding);
      expect(panel.bottom - lastContent.bottom, density.verticalPadding);
      expect(lastContent.top - firstContent.bottom, density == MateoMenuDensity.compact ? 8 : 16);
      await tester.tapAt(Offset(panel.center.dx, firstContent.bottom + 3));
      await tester.pumpAndSettle();
      await tester.tapAt(Offset(panel.center.dx, lastContent.top - 3));
      await tester.pumpAndSettle();
      expect(selected, [first, last]);
      await show([first]);
      expect(tester.getSize(find.byType(MateoSurface)).height, 60 + density.verticalPadding * 2);
    });
    for (final supporting in [0, 1, 2]) {
      testWidgets(
        'when $density has supporting content in position $supporting, it should use the larger gap for its density',
        (
          tester,
        ) async {
          await tester.pumpWidget(
            host(
              MateoMenu(
                presentation: .options(
                  density: density,
                  items: [
                    for (var index = 0; index < 2; index++)
                      MateoMenuOptionsPresentationItem(
                        principal: const SizedBox(width: 60, height: 60),
                        supporting: supporting == index || supporting == 2 ? const SizedBox(height: 10) : null,
                      ),
                  ],
                ),
              ),
            ),
          );
          final contentHeight = supporting == 2 ? 144 : 132;
          expect(
            tester.getSize(find.byType(MateoSurface)).height,
            contentHeight + density.verticalPadding * 2 + (density == MateoMenuDensity.compact ? 12 : 24),
          );
        },
      );
    }
    testWidgets('$density panel insets and all row padding activate the owning item', (tester) async {
      const first = MateoMenuOptionsPresentationItem(principal: Text('First'));
      const last = MateoMenuOptionsPresentationItem(principal: Text('Last'));
      final selected = <MateoMenuOptionsPresentationItem>[];
      await tester.pumpWidget(
        host(
          MateoMenu(
            presentation: .options(density: density, items: [first, last]),
            onItemPressed: selected.add,
          ),
        ),
      );
      final panel = tester.getRect(find.byType(MateoSurface));
      final rows = find.byType(MateoPress);
      final top = tester.getRect(rows.first);
      final bottom = tester.getRect(rows.last);
      expect(
        panel.height,
        (density == MateoMenuDensity.compact ? 48 : 56) * 2 +
            density.verticalPadding * 2 +
            (density == MateoMenuDensity.compact ? 8 : 16),
      );
      expect(top.bottom, bottom.top);
      for (final point in [
        Offset(panel.center.dx, panel.top + 1),
        Offset(panel.left + 1, top.center.dy),
        Offset(panel.right - 1, top.center.dy),
        Offset(panel.center.dx, top.bottom - 1),
        Offset(panel.center.dx, bottom.top + 1),
        Offset(panel.left + 1, bottom.center.dy),
        Offset(panel.center.dx, panel.bottom - 1),
      ]) {
        await tester.tapAt(point);
        await tester.pumpAndSettle();
      }
      expect(selected, [first, first, first, first, last, last, last]);
      selected.clear();
      await tester.tapAt(panel.topLeft + const Offset(1, 1));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('missing callback disables semantics and action', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        host(
          MateoMenu(
            presentation: .options(
              items: [const MateoMenuOptionsPresentationItem(principal: Text('Disabled'))],
            ),
          ),
        ),
      );
      expect(tester.getSemantics(find.byType(MateoPress)).flagsCollection.isEnabled, Tristate.isFalse);
      expect(tester.widget<MateoPress>(find.byType(MateoPress)).onPressed, isNull);
    } finally {
      semantics.dispose();
    }
  });
  testWidgets('async callback receives exact item without locking selection', (tester) async {
    const item = MateoMenuOptionsPresentationItem(principal: Text('Select'));
    final pending = Completer<void>();
    final selected = <MateoMenuOptionsPresentationItem>[];
    await tester.pumpWidget(
      host(
        MateoMenu(
          presentation: .options(items: [item]),
          onItemPressed: (value) {
            selected.add(value);
            return pending.future;
          },
        ),
      ),
    );
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    expect(selected, [item, item]);
    expect(find.byType(MateoLoadingIndicator), findsNothing);
    pending.complete();
    await tester.pumpAndSettle();
  });
  for (final direction in TextDirection.values) {
    testWidgets('$direction large text and optional content grow naturally', (tester) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 220,
            child: MateoMenu(
              presentation: .options(
                items: [
                  const MateoMenuOptionsPresentationItem(
                    leading: SizedBox(key: ValueKey('leading'), width: 24, height: 24),
                    principal: Text('Long principal content wraps naturally'),
                    supporting: Text('Supporting'),
                  ),
                  const MateoMenuOptionsPresentationItem(
                    leading: SizedBox(key: ValueKey('single-line-leading'), width: 24, height: 24),
                    principal: Text('One'),
                  ),
                  const MateoMenuOptionsPresentationItem(supporting: Text('Supporting alone')),
                  const MateoMenuOptionsPresentationItem(leading: SizedBox(width: 30, height: 60)),
                  const MateoMenuOptionsPresentationItem(),
                ],
              ),
              onItemPressed: (_) {},
            ),
          ),
          direction: direction,
          scale: 1.5,
        ),
      );
      expect(tester.getSize(find.byType(MateoPress).first).height, greaterThan(56));
      final leading = tester.getCenter(find.byKey(const ValueKey('leading')));
      final principalFinder = find.text('Long principal content wraps naturally');
      final text = tester.getCenter(principalFinder);
      expect(direction == .ltr ? leading.dx < text.dx : leading.dx > text.dx, isTrue);
      final principal = tester.renderObject<RenderParagraph>(principalFinder);
      final firstCharacterBox = principal
          .getBoxesForSelection(const TextSelection(baseOffset: 0, extentOffset: 1))
          .single;
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('leading'))).dy,
        closeTo(principal.localToGlobal(Offset(0, firstCharacterBox.top)).dy, 0.1),
      );
      expect(
        tester.getCenter(find.byKey(const ValueKey('single-line-leading'))).dy,
        tester.getCenter(find.text('One')).dy,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
