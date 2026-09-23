import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/app_test_router_delegate.dart';

void main() {
  final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
  late BuildContext context;
  Future<void> mount(WidgetTester tester, {Widget? child, bool reducedMotion = false, bool router = false}) async {
    final home = Builder(
      builder: (value) {
        context = value;
        return child ?? const SizedBox.expand();
      },
    );
    Widget wrap(BuildContext context, Widget? child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: reducedMotion),
      child: child!,
    );
    await tester.pumpWidget(
      router
          ? MateoApp.router(
              theme: theme,
              builder: wrap,
              routerConfig: RouterConfig<Object>(routerDelegate: AppTestRouterDelegate(home: home)),
            )
          : MateoApp(theme: theme, builder: wrap, home: home),
    );
    await tester.pumpAndSettle();
  }

  void show({
    String message = 'Saved',
    MateoToastStatus status = .success,
    Duration? duration = const Duration(seconds: 10),
    bool dismissible = true,
    Widget? icon,
    VoidCallback? onPressed,
  }) => showMateoToast(
    context: context,
    toast: MateoToast(message: message, status: status, icon: icon, onPressed: onPressed),
    duration: duration,
    dismissible: dismissible,
  );

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  Finder getToast() => find.byType(MateoToast);
  double opacity(WidgetTester tester) {
    final fade = tester.widget<FadeTransition>(
      find.ancestor(of: getToast(), matching: find.byType(FadeTransition)).first,
    );
    return fade.opacity.value;
  }

  for (final router in [false, true]) {
    testWidgets('when shown in ${router ? 'router' : 'home'} app, it should render and replace one toast', (
      tester,
    ) async {
      await mount(tester, router: router);
      show();
      await settle(tester);
      expect(find.text('Saved'), findsOneWidget);
      show(message: 'Replacement');
      await settle(tester);
      expect(getToast(), findsOneWidget);
      expect(find.text('Saved'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });
  }

  for (final router in [false, true]) {
    testWidgets('programmatic dismissal in ${router ? 'router' : 'home'} app should animate out once', (tester) async {
      await mount(tester, router: router);
      dismissMateoToast(context: context);
      show();
      await settle(tester);
      dismissMateoToast(context: context);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(opacity(tester), inExclusiveRange(0, 1));
      final progress = opacity(tester);
      dismissMateoToast(context: context);
      await tester.pump();
      expect(opacity(tester), progress);
      await tester.pump(const Duration(milliseconds: 101));
      await tester.pump();
      expect(getToast(), findsNothing);
      dismissMateoToast(context: context);
      await tester.pump(const Duration(seconds: 20));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('programmatic dismissal before the first frame should cancel the toast', (tester) async {
    await mount(tester);
    show();
    dismissMateoToast(context: context);
    await settle(tester);
    expect(getToast(), findsNothing);
    show(message: 'Later');
    await settle(tester);
    expect(find.text('Later'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('programmatic dismissal with reduced motion should remove immediately', (tester) async {
    await mount(tester, reducedMotion: true);
    show(dismissible: false);
    await tester.pump();
    dismissMateoToast(context: context);
    await tester.pump();
    expect(getToast(), findsNothing);
  });

  for (final dismissible in [false, true]) {
    testWidgets('programmatic dismissal should release an active touch with dismissible $dismissible', (tester) async {
      await mount(tester);
      show(dismissible: dismissible, duration: const Duration(seconds: 1));
      await settle(tester);
      final gesture = await tester.startGesture(tester.getCenter(getToast()));
      await tester.pump(const Duration(seconds: 2));
      dismissMateoToast(context: context);
      await settle(tester);
      expect(getToast(), findsNothing);
      await gesture.up();
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('programmatic dismissal during entry should remove the toast', (tester) async {
    await mount(tester);
    show();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    dismissMateoToast(context: context);
    await settle(tester);
    expect(getToast(), findsNothing);
  });

  testWidgets('programmatic dismissal should cancel a waiting replacement without restarting exit', (tester) async {
    await mount(tester);
    show();
    await settle(tester);
    show(message: 'Waiting');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final progress = opacity(tester);
    dismissMateoToast(context: context);
    await tester.pump();
    expect(opacity(tester), progress);
    await tester.pump(const Duration(milliseconds: 101));
    await tester.pump();
    expect(getToast(), findsNothing);
    await tester.pump(const Duration(seconds: 20));
    expect(getToast(), findsNothing);
  });

  testWidgets('a show request during programmatic dismissal should still appear', (tester) async {
    await mount(tester);
    show();
    await settle(tester);
    dismissMateoToast(context: context);
    show(message: 'Later');
    await settle(tester);
    expect(find.text('Saved'), findsNothing);
    expect(find.text('Later'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  for (final reducedMotion in [false, true]) {
    testWidgets('programmatic dismissal while paused should finish on resume with reduced motion $reducedMotion', (
      tester,
    ) async {
      await mount(tester, reducedMotion: reducedMotion);
      show();
      await settle(tester);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      show(message: 'Waiting');
      dismissMateoToast(context: context);
      await tester.pump(const Duration(seconds: 20));
      expect(find.text('Saved'), findsOneWidget);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settle(tester);
      expect(getToast(), findsNothing);
    });
  }

  testWidgets('programmatic dismissal outside a Mateo app should explain the required context', (tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (value) {
          context = value;
          return const SizedBox();
        },
      ),
    );
    expect(
      () => dismissMateoToast(context: context),
      throwsA(
        isA<FlutterError>().having(
          (error) => error.message,
          'message',
          'dismissMateoToast requires a context below MateoApp or MateoApp.router.',
        ),
      ),
    );
  });

  for (final status in MateoToastStatus.values) {
    testWidgets('when status is ${status.name}, it should use its semantic colors and matching icon or indicator', (
      tester,
    ) async {
      await mount(tester);
      show(status: status);
      await settle(tester);
      final expected = switch (status) {
        MateoToastStatus.error => (theme.colorScheme.toast.error, MateoIconData.exclamationCircle),
        MateoToastStatus.warning => (theme.colorScheme.toast.warning, MateoIconData.exclamationTriangle),
        MateoToastStatus.info => (theme.colorScheme.toast.info, MateoIconData.circleInfo),
        MateoToastStatus.loading => (theme.colorScheme.toast.loading, null),
        MateoToastStatus.success => (theme.colorScheme.toast.success, MateoIconData.circleCheck),
      };
      final surface = tester.widget<MateoSurface>(
        find.descendant(of: getToast(), matching: find.byType(MateoSurface)).first,
      );
      expect(surface.color, expected.$1.background);
      final backgroundLuminance = expected.$1.background.computeLuminance();
      expect(
        (expected.$1.foreground.computeLuminance() + 0.05) / (backgroundLuminance + 0.05),
        greaterThanOrEqualTo(4.5),
      );
      expect((expected.$1.icon.computeLuminance() + 0.05) / (backgroundLuminance + 0.05), greaterThanOrEqualTo(3));
      expect(tester.widget<Text>(find.text('Saved')).style!.color, expected.$1.foreground);
      if (expected.$2 case final expectedIcon?) {
        expect(
          tester.widget<MateoIcon>(find.descendant(of: getToast(), matching: find.byType(MateoIcon))).icon,
          expectedIcon,
        );
        expect(find.descendant(of: getToast(), matching: find.byType(MateoLoadingIndicator)), findsNothing);
      } else {
        final indicator = find.descendant(of: getToast(), matching: find.byType(MateoLoadingIndicator));
        expect(indicator, findsOneWidget);
        expect(find.descendant(of: getToast(), matching: find.byType(MateoIcon)), findsNothing);
        expect(
          tester.getSize(find.descendant(of: indicator, matching: find.byType(SizedBox)).first),
          const Size(22, 22),
        );
      }
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('when a custom icon is supplied, it should inherit toast size and color without a builder API', (
    tester,
  ) async {
    await mount(tester);
    show(
      icon: Builder(
        builder: (context) {
          expect(MateoIconScope.of(context).size, 28);
          expect(MateoIconScope.of(context).color, theme.colorScheme.toast.success.icon);
          return const MateoIcon(.cross);
        },
      ),
    );
    await settle(tester);
    expect(tester.widget<MateoIcon>(find.byType(MateoIcon)).icon, MateoIconData.cross);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('when loading has a custom icon, it should replace the indicator', (tester) async {
    await mount(tester);
    show(status: .loading, icon: const MateoIcon(.cross));
    await settle(tester);
    expect(find.byType(MateoLoadingIndicator), findsNothing);
    expect(tester.widget<MateoIcon>(find.byType(MateoIcon)).icon, MateoIconData.cross);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('when tapped above a control, it should dismiss and consume the touch', (tester) async {
    var underlyingTaps = 0;
    await mount(
      tester,
      child: GestureDetector(behavior: .opaque, onTap: () => underlyingTaps++, child: const SizedBox.expand()),
    );
    show();
    await settle(tester);
    await tester.tap(getToast());
    await settle(tester);
    expect(getToast(), findsNothing);
    expect(underlyingTaps, 0);
  });

  testWidgets('when embedded directly, a completed tap should call onPressed and leave the toast mounted', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      MateoTheme(
        data: theme,
        child: Directionality(
          textDirection: .ltr,
          child: Center(
            child: MateoToast(message: 'Open details', status: .info, onPressed: () => presses++),
          ),
        ),
      ),
    );
    final gesture = await tester.startGesture(tester.getCenter(getToast()));
    expect(presses, 0);
    await gesture.up();
    await tester.pump();
    expect(presses, 1);
    expect(getToast(), findsOneWidget);
  });

  for (final dismissible in [false, true]) {
    testWidgets('a hosted press should call onPressed once with dismissible $dismissible', (tester) async {
      var presses = 0;
      await mount(tester);
      show(dismissible: dismissible, onPressed: () => presses++);
      await settle(tester);
      await tester.tap(getToast());
      expect(presses, 1);
      await settle(tester);
      expect(getToast(), dismissible ? findsNothing : findsOneWidget);
      expect(presses, 1);
    });
  }

  testWidgets('a hosted press should allow its callback to show a replacement toast', (tester) async {
    var presses = 0;
    await mount(tester);
    show(
      onPressed: () {
        presses++;
        show(message: 'Next');
      },
    );
    await settle(tester);
    await tester.tap(getToast());
    await settle(tester);
    expect(presses, 1);
    expect(find.text('Saved'), findsNothing);
    expect(find.text('Next'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a hosted non-dismissible press should call onPressed without dismissing with reduced motion', (
    tester,
  ) async {
    var presses = 0;
    await mount(tester, reducedMotion: true);
    show(dismissible: false, onPressed: () => presses++);
    await tester.pump();
    await tester.tap(getToast());
    await tester.pump();
    expect(presses, 1);
    expect(getToast(), findsOneWidget);
  });

  testWidgets('swipes, cancelled touches, timeouts, and programmatic dismissal should not call onPressed', (
    tester,
  ) async {
    var presses = 0;
    await mount(tester);
    show(onPressed: () => presses++);
    await settle(tester);
    await tester.drag(getToast(), const Offset(0, -60));
    await settle(tester);
    expect(presses, 0);

    show(onPressed: () => presses++);
    await settle(tester);
    final gesture = await tester.startGesture(tester.getCenter(getToast()));
    await gesture.cancel();
    await settle(tester);
    expect(presses, 0);

    dismissMateoToast(context: context);
    await settle(tester);
    expect(presses, 0);

    show(duration: const Duration(seconds: 1), onPressed: () => presses++);
    await settle(tester);
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);
    expect(getToast(), findsNothing);
    expect(presses, 0);
  });

  testWidgets('when touched outside the toast, it should leave underlying controls interactive', (tester) async {
    var taps = 0;
    await mount(
      tester,
      child: GestureDetector(behavior: .opaque, onTap: () => taps++, child: const SizedBox.expand()),
    );
    show();
    await settle(tester);
    await tester.tapAt(const Offset(400, 400));
    expect(taps, 1);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('when non-dismissible, it should resist touch dismissal but still time out', (tester) async {
    await mount(tester);
    show(dismissible: false, duration: const Duration(seconds: 2));
    await settle(tester);
    await tester.tap(getToast());
    await settle(tester);
    await tester.drag(getToast(), const Offset(0, -100));
    await settle(tester);
    expect(getToast(), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await settle(tester);
    expect(getToast(), findsNothing);
  });

  testWidgets('when the timeout occurs during a hold, it should wait for release', (tester) async {
    await mount(tester);
    show(duration: const Duration(seconds: 1));
    await settle(tester);
    final gesture = await tester.startGesture(tester.getCenter(getToast()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final scale = tester.widget<ScaleTransition>(
      find.ancestor(of: getToast(), matching: find.byType(ScaleTransition)).first,
    );
    expect(scale.scale.value, closeTo(0.985, 0.0001));
    await tester.pump(const Duration(seconds: 2));
    expect(getToast(), findsOneWidget);
    await gesture.up();
    await settle(tester);
    expect(getToast(), findsNothing);
  });

  testWidgets('when an upward swipe dismisses, it should continue fading from the dragged progress', (tester) async {
    await mount(tester);
    show();
    await settle(tester);
    final gesture = await tester.startGesture(tester.getCenter(getToast()));
    await gesture.moveBy(const Offset(0, -14));
    await tester.pump();
    final draggedOpacity = opacity(tester);
    expect(draggedOpacity, lessThan(1));
    await gesture.up();
    await tester.pump();
    expect(opacity(tester), lessThanOrEqualTo(draggedOpacity));
    await settle(tester);
    expect(getToast(), findsNothing);
  });

  for (final offset in [const Offset(100, 0), const Offset(0, 100)]) {
    testWidgets('when dragging toward $offset, it should move with resistance and return', (tester) async {
      await mount(tester);
      show();
      await settle(tester);
      final rest = tester.getCenter(getToast());
      final gesture = await tester.startGesture(rest);
      await gesture.moveBy(offset);
      await tester.pump();
      final travel = tester.getCenter(getToast()) - rest;
      expect(travel.distance, greaterThan(0));
      expect(travel.distance, lessThan(7));
      await gesture.up();
      await settle(tester);
      expect(tester.getCenter(getToast()), rest);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('when a drag is cancelled, it should restore the toast without dismissing', (tester) async {
    await mount(tester);
    show();
    await settle(tester);
    final gesture = await tester.startGesture(tester.getCenter(getToast()));
    await gesture.moveBy(const Offset(0, -30));
    await gesture.cancel();
    await settle(tester);
    expect(getToast(), findsOneWidget);
    expect(opacity(tester), 1);
    await tester.pumpWidget(const SizedBox());
  });

  for (final message in ['Hi', 'A' * 70, 'A' * 200]) {
    final milliseconds = message.length == 2
        ? 2500
        : message.length == 70
        ? 5000
        : 8000;
    testWidgets('when reading ${message.length} characters, it should use the bounded reading time', (tester) async {
      await mount(tester);
      show(message: message, duration: null);
      await tester.pump();
      await tester.pump(Duration(milliseconds: milliseconds - 1));
      expect(getToast(), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1));
      await settle(tester);
      expect(getToast(), findsNothing);
    });
  }

  for (final stage in ['entering', 'exiting', 'dragging']) {
    testWidgets('when replaced while $stage, it should dispose the old toast without affecting its replacement', (
      tester,
    ) async {
      await mount(tester);
      show();
      await tester.pump();
      TestGesture? gesture;
      if (stage != 'entering') await settle(tester);
      if (stage == 'exiting') await tester.tap(getToast());
      if (stage == 'dragging') {
        gesture = await tester.startGesture(tester.getCenter(getToast()));
        await gesture.moveBy(const Offset(0, -20));
      }
      show(message: 'New');
      await settle(tester);
      await gesture?.up();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('New'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 20));
      expect(tester.takeException(), isNull);
    });
  }

  for (final exiting in [false, true]) {
    testWidgets('when paused during ${exiting ? 'exit' : 'entry'}, it should resume the transition', (tester) async {
      await mount(tester);
      show(duration: const Duration(seconds: 2));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      if (exiting) {
        await settle(tester);
        await tester.tap(getToast());
        await tester.pump(const Duration(milliseconds: 50));
      }
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump(const Duration(seconds: 5));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settle(tester);
      expect(getToast(), exiting ? findsNothing : findsOneWidget);
      if (!exiting) {
        expect(opacity(tester), 1);
        await tester.pump(const Duration(seconds: 2));
        await settle(tester);
        expect(getToast(), findsNothing);
      }
    });
  }

  testWidgets('when motion is reduced, it should appear and dismiss immediately without press scaling', (tester) async {
    await mount(tester, reducedMotion: true);
    show();
    await tester.pump();
    expect(opacity(tester), 1);
    await tester.tap(getToast());
    await tester.pump();
    expect(getToast(), findsNothing);
  });

  testWidgets('when loading is announced, it should expose one full-message live region', (tester) async {
    final semantics = tester.ensureSemantics();
    await mount(tester);
    show(message: 'A complete announcement', status: .loading);
    await settle(tester);
    final nodes = find.byWidgetPredicate((widget) => widget is Semantics && widget.properties.liveRegion == true);
    expect(nodes, findsOneWidget);
    expect(tester.widget<Semantics>(nodes).properties.label, 'A complete announcement');
    expect(tester.widget<Semantics>(nodes).excludeSemantics, isTrue);
    await tester.pumpWidget(const SizedBox());
    semantics.dispose();
  });

  testWidgets('an embedded onPressed toast should expose a button action to accessibility', (tester) async {
    final semantics = tester.ensureSemantics();
    var presses = 0;
    await tester.pumpWidget(
      MateoTheme(
        data: theme,
        child: Directionality(
          textDirection: .ltr,
          child: Center(
            child: MateoToast(message: 'Open details', status: .info, onPressed: () => presses++),
          ),
        ),
      ),
    );
    final node = tester.getSemantics(getToast());
    expect(node, matchesSemantics(label: 'Open details', isButton: true, isLiveRegion: true, hasTapAction: true));
    tester.renderObject(getToast()).owner!.semanticsOwner!.performAction(node.id, SemanticsAction.tap);
    await tester.pump();
    expect(presses, 1);
    expect(getToast(), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('a hosted non-dismissible accessibility action should invoke onPressed without dismissing', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var presses = 0;
    await mount(tester);
    show(message: 'Open details', dismissible: false, onPressed: () => presses++);
    await settle(tester);
    final node = tester.getSemantics(getToast());
    expect(node, matchesSemantics(label: 'Open details', isButton: true, isLiveRegion: true, hasTapAction: true));
    tester.renderObject(getToast()).owner!.semanticsOwner!.performAction(node.id, SemanticsAction.tap);
    expect(presses, 1);
    await settle(tester);
    expect(getToast(), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('when no host exists, it should explain the required app setup', (tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (value) {
          context = value;
          return const SizedBox();
        },
      ),
    );
    expect(
      show,
      throwsA(isA<FlutterError>().having((error) => error.toString(), 'message', contains('MateoApp'))),
    );
  });
  testWidgets('when navigation adds an overlay after a toast, it should remain below the toast', (tester) async {
    await mount(tester);
    show();
    await settle(tester);
    var overlayTaps = 0;
    final entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: GestureDetector(
          behavior: .opaque,
          onTap: () => overlayTaps++,
          child: ColoredBox(color: theme.palette.white),
        ),
      ),
    );
    Overlay.of(context).insert(entry);
    await tester.pump();
    await tester.tap(getToast());
    await settle(tester);
    expect(getToast(), findsNothing);
    expect(overlayTaps, 0);
    entry
      ..remove()
      ..dispose();
  });

  testWidgets('when called inside local scopes, it should retain theme, direction, and text scaling', (tester) async {
    final localTheme = theme.copyWith(accentColor: const Color(0xFFFF0000));
    await mount(
      tester,
      child: MateoTheme(
        data: localTheme,
        child: Directionality(
          textDirection: .rtl,
          child: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: Builder(
              builder: (value) {
                context = value;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      ),
    );
    show(
      icon: Builder(
        builder: (value) {
          expect(MateoTheme.of(value), localTheme);
          expect(Directionality.of(value), TextDirection.rtl);
          expect(MediaQuery.textScalerOf(value).scale(10), 15);
          return const MateoIcon(.cross);
        },
      ),
    );
    await settle(tester);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('when safe areas change, it should reposition below the current top inset', (tester) async {
    tester.view.padding = const FakeViewPadding(top: 40);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetDevicePixelRatio);
    await mount(tester);
    show();
    await settle(tester);
    final initialTop = tester.getTopLeft(getToast()).dy;
    expect(initialTop, greaterThanOrEqualTo(40));
    tester.view.padding = const FakeViewPadding(top: 60);
    await tester.pump();
    expect(tester.getTopLeft(getToast()).dy, initialTop + 20);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('when rendered directly, it should use the Mateo capsule and truncate only visible text', (tester) async {
    final message = 'A long message that needs more than two lines to explain what happened. ' * 4;
    await mount(
      tester,
      child: Center(
        child: SizedBox(
          width: 260,
          child: MateoToast(message: message, status: .error),
        ),
      ),
    );
    final decoration =
        tester
                .widget<DecoratedBox>(find.descendant(of: getToast(), matching: find.byType(DecoratedBox)).first)
                .decoration
            as ShapeDecoration;
    expect(decoration.shape, const MateoRoundedShapeBorder.capsule());
    final text = tester.widget<Text>(find.text(message));
    expect(text.maxLines, 2);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(decoration.shadows, MateoElevation(level: 2).toShadowList(palette: theme.palette));
  });

  testWidgets('when a second pointer arrives, it should leave the first pointer in control', (tester) async {
    await mount(tester);
    show(dismissible: false, duration: const Duration(seconds: 1));
    await settle(tester);
    final first = await tester.startGesture(tester.getCenter(getToast()), pointer: 1);
    final second = await tester.startGesture(tester.getCenter(getToast()), pointer: 2);
    await second.up();
    await tester.pump(const Duration(seconds: 2));
    expect(getToast(), findsOneWidget);
    await first.up();
    await settle(tester);
    expect(getToast(), findsNothing);
  });

  testWidgets('when multiple toasts are requested before a frame, it should show only the latest', (tester) async {
    await mount(tester);
    show(message: 'First');
    show(message: 'Second');
    show(message: 'Last');
    await settle(tester);
    expect(getToast(), findsOneWidget);
    expect(find.text('Last'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a held pointer is cancelled after timeout, it should dismiss once', (tester) async {
    await mount(tester);
    show(duration: const Duration(seconds: 1));
    await settle(tester);
    final gesture = await tester.startGesture(tester.getCenter(getToast()));
    await tester.pump(const Duration(seconds: 2));
    await gesture.cancel();
    await settle(tester);
    expect(getToast(), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when replacing a visible toast, it should finish the exit before the new entrance', (tester) async {
    await mount(tester);
    show(message: 'Old');
    await settle(tester);
    show(message: 'New');
    await tester.pump();
    expect(find.text('Old'), findsOneWidget);
    expect(find.text('New'), findsNothing);
    await tester.pump(const Duration(milliseconds: 110));
    expect(opacity(tester), greaterThan(0));
    expect(opacity(tester), lessThan(1));
    expect(find.text('New'), findsNothing);
    await tester.pump(const Duration(milliseconds: 171));
    await tester.pump();
    expect(find.text('Old'), findsNothing);
    expect(find.text('New'), findsOneWidget);
    expect(opacity(tester), 0);
    await tester.pump(const Duration(milliseconds: 140));
    expect(opacity(tester), greaterThan(0));
    expect(opacity(tester), lessThan(1));
    await tester.pump(const Duration(milliseconds: 140));
    expect(opacity(tester), 1);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('when more messages arrive during exit, it should keep only the latest without restarting exit', (
    tester,
  ) async {
    await mount(tester);
    show(message: 'Old');
    await settle(tester);
    show(message: 'Skipped');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 110));
    final progress = opacity(tester);
    show(message: 'Latest');
    await tester.pump();
    expect(opacity(tester), progress);
    await tester.pump(const Duration(milliseconds: 171));
    await tester.pump();
    expect(find.text('Latest'), findsOneWidget);
    expect(find.text('Skipped'), findsNothing);
    await settle(tester);
    expect(opacity(tester), 1);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('when replacing a held non-dismissible toast, it should switch without waiting for release', (
    tester,
  ) async {
    await mount(tester);
    show(message: 'Old', dismissible: false);
    await settle(tester);
    final gesture = await tester.startGesture(tester.getCenter(getToast()));
    show(message: 'New');
    await settle(tester);
    expect(find.text('Old'), findsNothing);
    expect(find.text('New'), findsOneWidget);
    await gesture.up();
    await settle(tester);
    expect(find.text('New'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });

  testWidgets('when switching with reduced motion, it should replace immediately', (tester) async {
    await mount(tester, reducedMotion: true);
    show(message: 'Old');
    await tester.pump();
    show(message: 'New');
    await tester.pump();
    expect(find.text('Old'), findsNothing);
    expect(find.text('New'), findsOneWidget);
    expect(opacity(tester), 1);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('when a toast waits for an exit, it should receive its full reading duration after mounting', (
    tester,
  ) async {
    await mount(tester);
    show(message: 'Old');
    await settle(tester);
    show(message: 'New', duration: const Duration(seconds: 1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 281));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 999));
    expect(find.text('New'), findsOneWidget);
    expect(opacity(tester), 1);
    await tester.pump(const Duration(milliseconds: 1));
    await settle(tester);
    expect(getToast(), findsNothing);
  });

  testWidgets('when the app pauses during a handoff, it should resume the exit and then show the waiting toast', (
    tester,
  ) async {
    await mount(tester);
    show(message: 'Old');
    await settle(tester);
    show(message: 'New');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Old'), findsOneWidget);
    expect(find.text('New'), findsNothing);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await settle(tester);
    expect(find.text('New'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('when disposed with a waiting toast, it should discard both messages cleanly', (tester) async {
    await mount(tester);
    show();
    await settle(tester);
    show(message: 'Waiting');
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 20));
    expect(getToast(), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when dragging upward, it should resist small movement and stay visible through a long drag', (
    tester,
  ) async {
    await mount(tester);
    show();
    await settle(tester);
    final rest = tester.getTopLeft(getToast()).dy;
    final gesture = await tester.startGesture(tester.getCenter(getToast()));
    await gesture.moveBy(const Offset(0, -30));
    await tester.pump();
    expect(opacity(tester), inExclusiveRange(0.65, 0.75));
    expect(rest - tester.getTopLeft(getToast()).dy, inExclusiveRange(0, 10));
    await gesture.moveBy(const Offset(0, -300));
    await tester.pump();
    expect(opacity(tester), greaterThan(0));
    await gesture.up();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 199));
    expect(getToast(), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2));
    await tester.pump();
    expect(getToast(), findsNothing);
  });

  testWidgets('when a small slow drag passes the distance threshold, it should dismiss', (tester) async {
    await mount(tester);
    show();
    await settle(tester);
    final gesture = await tester.startGesture(tester.getCenter(getToast()));
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.moveBy(const Offset(0, -10), timeStamp: Duration(milliseconds: (i + 1) * 100));
    }
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.up(timeStamp: const Duration(milliseconds: 500));
    await settle(tester);
    expect(getToast(), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('when a resisted drag reverses or is regrabbed, it should preserve its visible position', (tester) async {
    await mount(tester);
    show();
    await settle(tester);
    final rest = tester.getTopLeft(getToast()).dy;
    final gesture = await tester.startGesture(tester.getCenter(getToast()));
    await gesture.moveBy(const Offset(0, -160));
    await tester.pump();
    await gesture.moveBy(const Offset(0, 160));
    await tester.pump();
    expect(tester.getTopLeft(getToast()).dy, closeTo(rest, 0.001));
    await gesture.moveBy(const Offset(0, -60));
    await tester.pump();
    await gesture.cancel();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final before = tester.getTopLeft(getToast()).dy;
    final next = await tester.startGesture(tester.getCenter(getToast()));
    await tester.pump();
    expect(tester.getTopLeft(getToast()).dy, closeTo(before, 0.001));
    await next.moveBy(const Offset(0, -20));
    await tester.pump();
    expect(tester.getTopLeft(getToast()).dy, lessThan(before));
    await next.cancel();
    await settle(tester);
    expect(tester.getTopLeft(getToast()).dy, closeTo(rest, 0.001));
    await tester.pumpWidget(const SizedBox());
  });

  for (final travel in [30.0, 80.0, 300.0]) {
    testWidgets('when swiping $travel pixels, it should use the full tap dismissal timing and curve', (tester) async {
      await mount(tester);
      show();
      await settle(tester);
      await tester.tap(getToast());
      await tester.pump();
      final tapSamples = <double>[];
      for (var i = 0; i < 3; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        tapSamples.add(opacity(tester));
      }
      await tester.pumpWidget(const SizedBox());
      await mount(tester);
      show();
      await settle(tester);
      final gesture = await tester.startGesture(tester.getCenter(getToast()));
      for (var i = 0; i < 3; i++) {
        await gesture.moveBy(Offset(0, -travel / 3), timeStamp: Duration(milliseconds: (i + 1) * 10));
        await tester.pump(const Duration(milliseconds: 10));
      }
      final releaseOpacity = opacity(tester);
      final releaseTop = tester.getTopLeft(getToast()).dy;
      await gesture.up(timeStamp: const Duration(milliseconds: 31));
      await tester.pump();
      expect(opacity(tester), closeTo(releaseOpacity, 0.001));
      expect(tester.getTopLeft(getToast()).dy, closeTo(releaseTop, 0.001));
      for (final sample in tapSamples) {
        await tester.pump(const Duration(milliseconds: 50));
        expect(opacity(tester) / releaseOpacity, closeTo(sample, 0.001));
      }
      await tester.pump(const Duration(milliseconds: 49));
      expect(getToast(), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 2));
      await tester.pump();
      expect(getToast(), findsNothing);
    });
  }
  for (final entering in [true, false]) {
    testWidgets(
      'when ${entering ? 'entering' : 'dismissing'}, it should decelerate continuously into a settled landing',
      (tester) async {
        await mount(tester);
        show();
        await tester.pump();
        if (!entering) {
          await settle(tester);
          await tester.tap(getToast());
          await tester.pump();
        }
        const duration = 200;
        final samples = <double>[0];
        for (var millisecond = 1; millisecond < duration; millisecond++) {
          await tester.pump(const Duration(milliseconds: 1));
          samples.add(entering ? opacity(tester) : 1 - opacity(tester));
        }
        samples.add(1);
        for (var i = 1; i < samples.length; i++) {
          expect(samples[i], inInclusiveRange(0, 1));
          expect(samples[i], greaterThanOrEqualTo(samples[i - 1]));
        }
        // Once the spring has gained speed, it must never accelerate again,
        // including where the spring joins its finite settling segment.
        for (var i = (duration * 0.25).ceil(); i < duration - 1; i++) {
          final step = samples[i] - samples[i - 1];
          final nextStep = samples[i + 1] - samples[i];
          expect(nextStep, lessThanOrEqualTo(step + 1e-10));
        }
        expect(1 - samples[duration - 1], lessThan(0.00001));
        final landingAcceleration = 1 - 2 * samples[duration - 1] + samples[duration - 2];
        expect(landingAcceleration.abs(), lessThan(0.00004));
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
  for (final scenario in const [
    (name: 'a sparse short flick', moves: [Offset(0, -30)], spacing: 60, releaseDelay: 1, dismiss: true),
    (
      name: 'a flick with a brief release delay',
      moves: [Offset(0, -10), Offset(0, -10), Offset(0, -10)],
      spacing: 20,
      releaseDelay: 80,
      dismiss: true,
    ),
    (name: 'a diagonal upward flick', moves: [Offset(20, -30)], spacing: 60, releaseDelay: 1, dismiss: true),
    (name: 'a flick followed by a hold', moves: [Offset(0, -30)], spacing: 60, releaseDelay: 250, dismiss: true),
    (
      name: 'a flick reversed downward',
      moves: [Offset(0, -30), Offset(0, 10)],
      spacing: 30,
      releaseDelay: 1,
      dismiss: true,
    ),
    (name: 'a mostly horizontal flick', moves: [Offset(60, -20)], spacing: 30, releaseDelay: 1, dismiss: true),
    (name: 'a deliberate slow drag', moves: [Offset(0, -45)], spacing: 300, releaseDelay: 250, dismiss: true),
  ]) {
    testWidgets('when performing ${scenario.name}, it should ${scenario.dismiss ? 'dismiss' : 'return to rest'}', (
      tester,
    ) async {
      await mount(tester);
      show();
      await settle(tester);
      final gesture = await tester.startGesture(tester.getCenter(getToast()));
      var elapsed = Duration.zero;
      for (final offset in scenario.moves) {
        final interval = Duration(milliseconds: scenario.spacing);
        elapsed += interval;
        await tester.pump(interval);
        await gesture.moveBy(offset, timeStamp: elapsed);
      }
      final releaseDelay = Duration(milliseconds: scenario.releaseDelay);
      await tester.pump(releaseDelay);
      await gesture.up(timeStamp: elapsed + releaseDelay);
      await settle(tester);
      expect(getToast(), scenario.dismiss ? findsNothing : findsOneWidget);
      if (!scenario.dismiss) expect(opacity(tester), 1);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
