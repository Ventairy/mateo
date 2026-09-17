import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_view/base_mateo_view.dart';

class _RouteHost {
  final navigator = GlobalKey<NavigatorState>();
  final media = ValueNotifier<MediaQueryData>(
    const MediaQueryData(
      size: Size(800, 600),
      viewPadding: .only(bottom: 34),
      padding: .only(bottom: 34),
    ),
  );
  final mode = ValueNotifier<bool>(true);
  final visible = ValueNotifier<bool>(true);
  final observed = <String, MediaQueryData>{};

  void setInset(double inset) => media.value = media.value.copyWith(
    viewInsets: .only(bottom: inset),
    padding: .only(bottom: (34 - inset).clamp(0, 34)),
  );

  Widget view(String name, {bool avoid = true}) => MateoView(
    key: ValueKey(name),
    avoidBottomInset: avoid,
    footer: MateoViewFooter(
      principal: Builder(
        builder: (context) => Padding(
          padding: .only(bottom: MediaQuery.viewPaddingOf(context).bottom - MediaQuery.paddingOf(context).bottom),
          child: SizedBox(key: ValueKey('$name-footer'), height: 40),
        ),
      ),
    ),
    overlay: Builder(
      builder: (context) {
        observed['$name-overlay'] = MediaQuery.of(context);
        return const SizedBox();
      },
    ),
    surface: MateoViewSurface.scrollable(
      edgeEffect: .fade(at: const [.bottom]),
      color: const Color(0xFFFFFFFF),
      child: Builder(
        builder: (context) {
          observed[name] = MediaQuery.of(context);
          return SizedBox(key: ValueKey('$name-content'), height: 900);
        },
      ),
    ),
  );

  Future<void> mount(WidgetTester tester) async {
    addTearDown(media.dispose);
    addTearDown(mode.dispose);
    addTearDown(visible.dispose);
    await tester.pumpWidget(
      MateoApp(
        navigatorKey: navigator,
        theme: MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white),
        builder: (_, child) => ValueListenableBuilder(
          valueListenable: media,
          child: child,
          builder: (_, value, child) => MediaQuery(data: value, child: child!),
        ),
        home: ValueListenableBuilder(
          valueListenable: visible,
          builder: (_, shown, child) => shown
              ? ValueListenableBuilder(
                  valueListenable: mode,
                  builder: (_, value, child) => view('feed', avoid: value),
                )
              : const SizedBox(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> cover(WidgetTester tester) async {
    navigator.currentState!.push(
      PageRouteBuilder<void>(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, animation, secondaryAnimation) => view('post'),
      ),
    );
    await tester.pumpAndSettle();
  }

  double footerInset(WidgetTester tester, String name) => MateoViewLayoutScope.maybeOf(
    tester.element(find.byKey(ValueKey('$name-content'))),
  )!.footer!.bottomInset;
}

void main() {
  for (final mode in [true, false]) {
    testWidgets('when covered with avoidance $mode, it should honor the boolean regardless of route coverage', (
      tester,
    ) async {
      final host = _RouteHost()..mode.value = mode;
      await host.mount(tester);
      final scrollFinder = find.descendant(
        of: find.byKey(const ValueKey('feed')),
        matching: find.byType(CustomScrollView),
      );
      final controller = tester.widget<CustomScrollView>(scrollFinder).controller!..jumpTo(100);
      await tester.pumpAndSettle();
      await host.cover(tester);
      for (final inset in [200.0, 280.0, 0.0]) {
        host.setInset(inset);
        await tester.pumpAndSettle();
        expect(host.observed['feed']!.viewInsets.bottom, inset);
        expect(host.observed['feed-overlay']!.viewInsets.bottom, inset);
        expect(host.footerInset(tester, 'feed'), mode ? inset : 0);
        expect(host.footerInset(tester, 'post'), inset);
        expect(tester.widget<CustomScrollView>(scrollFinder).controller, same(controller));
        expect(controller.offset, 100);
      }
    });
  }

  testWidgets('when returning during dismissal, it should resume live bottom media while retaining other updates', (
    tester,
  ) async {
    final host = _RouteHost();
    await host.mount(tester);
    host.setInset(180);
    await tester.pumpAndSettle();
    await host.cover(tester);
    host.setInset(260);
    host.media.value = host.media.value.copyWith(
      padding: const .only(top: 12),
      viewPadding: const .only(top: 12, bottom: 48),
      textScaler: const .linear(1.5),
      disableAnimations: true,
    );
    await tester.pumpAndSettle();
    expect(host.observed['feed']!.viewInsets.bottom, 260);
    expect(host.observed['feed']!.viewPadding.bottom, 48);
    expect(host.observed['feed']!.padding.top, 12);
    expect(host.observed['feed']!.textScaler.scale(10), 15);
    expect(host.observed['feed']!.disableAnimations, isTrue);
    host.navigator.currentState!.pop();
    await tester.pump();
    expect(host.observed['feed']!.viewInsets.bottom, 260);
    host.setInset(0);
    await tester.pump(const Duration(milliseconds: 16));
    expect(host.observed['feed']!.viewInsets.bottom, 0);
    await tester.pumpAndSettle();
  });

  testWidgets('when switching modes while covered, it should apply the boolean immediately', (
    tester,
  ) async {
    final host = _RouteHost();
    await host.mount(tester);
    await host.cover(tester);
    host.setInset(240);
    final scrollFinder = find.descendant(
      of: find.byKey(const ValueKey('feed')),
      matching: find.byType(CustomScrollView),
    );
    final controller = tester.widget<CustomScrollView>(scrollFinder).controller!;
    for (final mode in [true, false, true]) {
      host.mode.value = mode;
      await tester.pumpAndSettle();
      expect(host.footerInset(tester, 'feed'), mode ? 240 : 0);
      expect(host.observed['feed']!.viewInsets.bottom, 240);
      expect(tester.widget<CustomScrollView>(scrollFinder).controller, same(controller));
    }
  });

  testWidgets('when a popup covers the view, it should keep following live insets', (tester) async {
    final host = _RouteHost();
    await host.mount(tester);
    host.navigator.currentState!.push(
      RawDialogRoute<void>(
        pageBuilder: (_, animation, secondaryAnimation) => const SizedBox(),
      ),
    );
    await tester.pumpAndSettle();
    host.setInset(220);
    await tester.pumpAndSettle();
    expect(host.observed['feed']!.viewInsets.bottom, 220);
    host.navigator.currentState!.pop();
    await tester.pump();
    expect(host.observed['feed']!.viewInsets.bottom, 220);
    await tester.pumpAndSettle();
  });

  testWidgets('when an interactive back gesture is canceled, the covered view should keep following live insets', (
    tester,
  ) async {
    final host = _RouteHost();
    await host.mount(tester);
    final route = CupertinoPageRoute<void>(builder: (_) => host.view('post'));
    host.navigator.currentState!.push(route);
    await tester.pumpAndSettle();
    host.setInset(240);
    await tester.pumpAndSettle();
    final gesture = await tester.startGesture(const Offset(1, 300));
    await gesture.moveTo(const Offset(120, 300));
    await tester.pump(const Duration(milliseconds: 300));
    expect(host.navigator.currentState!.userGestureInProgress, isTrue);
    host.setInset(280);
    await tester.pump();
    expect(host.observed['feed']!.viewInsets.bottom, 280);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(route.isCurrent, isTrue);
    expect(host.observed['feed']!.viewInsets.bottom, 280);
    host.navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(host.observed['feed']!.viewInsets.bottom, 280);
  });

  testWidgets('when first mounted behind another route, it should use the live inset', (tester) async {
    final host = _RouteHost()..visible.value = false;
    await host.mount(tester);
    await host.cover(tester);
    host.setInset(250);
    host.visible.value = true;
    await tester.pumpAndSettle();
    expect(host.observed['feed']!.viewInsets.bottom, 250);
    expect(host.observed['feed']!.padding.bottom, 0);
    host.visible.value = false;
    await tester.pump();
    host.setInset(0);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
