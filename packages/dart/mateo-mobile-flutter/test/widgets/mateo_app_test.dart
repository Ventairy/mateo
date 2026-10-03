import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/app_test_counter.dart';
import '../fixtures/app_test_navigator_observer.dart';
import '../fixtures/app_test_router_delegate.dart';
import '../fixtures/app_test_widgets_delegate.dart';

void main() {
  final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

  testWidgets('when rendering home, it should install Mateo and Flutter defaults without Material', (tester) async {
    await tester.pumpWidget(
      MateoApp(
        theme: theme,
        title: 'Mateo test',
        home: Builder(
          builder: (context) {
            expect(MateoTheme.of(context), theme);
            expect(DefaultTextStyle.of(context).style.fontFamily, MateoTypography.fontFamily);
            expect(DefaultTextStyle.of(context).style.letterSpacing, MateoTypography.letterSpacing);
            expect(DefaultTextStyle.of(context).style.color, theme.colorScheme.text.primary);
            expect(Localizations.localeOf(context), const Locale('en', 'US'));
            expect(Directionality.of(context), TextDirection.ltr);
            expect(ModalRoute.of(context)?.settings.name, '/');
            expect(FocusScope.of(context), isNotNull);
            return const Text('Home');
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.byType(WidgetsApp), findsOneWidget);
    expect(find.byType(SafeArea), findsNothing);
    expect(find.byType(CheckedModeBanner), findsNothing);
    expect(tester.widget<Title>(find.byType(Title)).title, 'Mateo test');
    expect(tester.widget<Title>(find.byType(Title)).color, theme.colorScheme.accent);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when wrapping navigation, it should expose localization and theme to builder and overlays', (
    tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    var builderCalled = false;
    var overlayBuilt = false;
    await tester.pumpWidget(
      MateoApp(
        theme: theme,
        navigatorKey: navigatorKey,
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
        builder: (context, child) {
          builderCalled = true;
          expect(MateoTheme.of(context), theme);
          expect(Localizations.localeOf(context), const Locale('pt', 'BR'));
          expect(MediaQuery.of(context), isNotNull);
          expect(child, isNotNull);
          return KeyedSubtree(key: const ValueKey('app-wrapper'), child: child!);
        },
        home: const Text('Home'),
      ),
    );
    final entry = OverlayEntry(
      builder: (context) {
        overlayBuilt = true;
        expect(MateoTheme.of(context), theme);
        expect(Localizations.localeOf(context), const Locale('pt', 'BR'));
        expect(DefaultTextStyle.of(context).style.fontFamily, MateoTypography.fontFamily);
        return const Positioned(left: 0, top: 0, child: Text('Overlay'));
      },
    );
    navigatorKey.currentState!.overlay!.insert(entry);
    await tester.pump();
    expect(builderCalled, isTrue);
    expect(overlayBuilt, isTrue);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Overlay'), findsOneWidget);
    entry
      ..remove()
      ..dispose();
    await tester.pump();
  });

  testWidgets('when pushing and popping, it should notify observers and preserve route state across theme changes', (
    tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final observer = AppTestNavigatorObserver();
    Widget app(MateoThemeData data) =>
        MateoApp(theme: data, navigatorKey: navigatorKey, navigatorObservers: [observer], home: const Text('Home'));
    await tester.pumpWidget(app(theme));
    final navigator = navigatorKey.currentState!;
    final root = observer.pushed.single as PageRoute<dynamic>;
    expect(root.settings.name, '/');
    expect(root.transitionDuration, Duration.zero);
    expect(root.reverseTransitionDuration, Duration.zero);
    navigator.push<void>(
      PageRouteBuilder<void>(
        transitionDuration: .zero,
        reverseTransitionDuration: .zero,
        pageBuilder: (context, animation, secondaryAnimation) => const AppTestCounter(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Count: 0'));
    await tester.pump();
    final updated = theme.copyWith(accentColor: const Color(0xFF00A86B));
    await tester.pumpWidget(app(updated));
    expect(navigatorKey.currentState, same(navigator));
    expect(find.text('Count: 1'), findsOneWidget);
    expect(MateoTheme.of(tester.element(find.byType(AppTestCounter))), updated);
    expect(observer.pushed, hasLength(2));
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(observer.popped, hasLength(1));
  });

  testWidgets('when using RouterConfig, it should preserve the router and handle system back', (tester) async {
    var builderCalled = false;
    final delegate = AppTestRouterDelegate(
      home: Builder(
        builder: (context) {
          expect(MateoTheme.maybeOf(context), isNotNull);
          expect(DefaultTextStyle.of(context).style.fontFamily, MateoTypography.fontFamily);
          expect(Directionality.of(context), TextDirection.ltr);
          return const AppTestCounter();
        },
      ),
    );
    addTearDown(delegate.dispose);
    final router = RouterConfig<Object>(routerDelegate: delegate, backButtonDispatcher: RootBackButtonDispatcher());
    Widget app(MateoThemeData data) => MateoApp.router(
      theme: data,
      routerConfig: router,
      builder: (context, child) {
        builderCalled = true;
        expect(MateoTheme.of(context), data);
        return child!;
      },
    );
    await tester.pumpWidget(app(theme));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Count: 0'));
    await tester.pump();
    final navigator = delegate.navigatorKey.currentState;
    delegate.showDetails();
    await tester.pumpAndSettle();
    expect(find.text('Router details'), findsOneWidget);
    final updated = theme.copyWith(onAccent: MateoPalette().black);
    await tester.pumpWidget(app(updated));
    expect(delegate.navigatorKey.currentState, same(navigator));
    expect(find.text('Router details'), findsOneWidget);
    expect(MateoTheme.of(tester.element(find.text('Router details'))), updated);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Count: 1'), findsOneWidget);
    expect(builderCalled, isTrue);
  });

  testWidgets('when restoring the app, it should restore state in the root route', (tester) async {
    await tester.pumpWidget(MateoApp(theme: theme, restorationScopeId: 'app', home: const AppTestCounter()));
    await tester.tap(find.text('Count: 0'));
    await tester.pump();
    await tester.restartAndRestore();
    expect(find.text('Count: 1'), findsOneWidget);
  });

  testWidgets('when selecting a supported RTL locale, it should provide global widget localization', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ar')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      MateoApp(
        theme: theme,
        supportedLocales: const [Locale('en', 'US'), Locale('ar')],
        home: Builder(
          builder: (context) {
            expect(Localizations.localeOf(context), const Locale('ar'));
            expect(Directionality.of(context), TextDirection.rtl);
            expect(WidgetsLocalizations.of(context).textDirection, TextDirection.rtl);
            return const Text('مرحبا');
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when providing a consumer delegate, it should take precedence over widget defaults', (tester) async {
    await tester.pumpWidget(
      MateoApp(
        theme: theme,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [AppTestWidgetsDelegate()],
        home: Builder(
          builder: (context) {
            expect(Localizations.localeOf(context), const Locale('ar'));
            expect(Directionality.of(context), TextDirection.ltr);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  });

  testWidgets('when providing a locale resolver, it should use its selected locale', (tester) async {
    var resolved = false;
    await tester.pumpWidget(
      MateoApp(
        theme: theme,
        supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
        localeListResolutionCallback: (locales, supported) {
          resolved = true;
          return supported.last;
        },
        home: Builder(
          builder: (context) {
            expect(Localizations.localeOf(context), const Locale('pt', 'BR'));
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(resolved, isTrue);
  });

  testWidgets('when platform media settings change, it should preserve accessibility and insets', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 24, bottom: 16);
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
      disableAnimations: true,
      accessibleNavigation: true,
      boldText: true,
    );
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    void inspect(BuildContext context) {
      final media = MediaQuery.of(context);
      expect(media.padding.top, 24);
      expect(media.padding.bottom, 16);
      expect(media.textScaler.scale(10), 16);
      expect(media.disableAnimations, isTrue);
      expect(media.accessibleNavigation, isTrue);
      expect(media.boldText, isTrue);
    }

    await tester.pumpWidget(
      MateoApp(
        theme: theme,
        builder: (context, child) {
          inspect(context);
          return child!;
        },
        home: Builder(
          builder: (context) {
            inspect(context);
            return const Text('Media');
          },
        ),
      ),
    );
  });

  testWidgets('when using the dark fallback, it should keep dark symbols and a light background', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final fallback = MateoThemeData.dark(accentColor: theme.colorScheme.accent, onAccent: theme.colorScheme.onAccent);
    await tester.pumpWidget(MateoApp(theme: fallback, home: const SizedBox.shrink()));
    final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
    );
    expect(region.value.statusBarColor, const Color(0x00000000));
    expect(region.value.systemNavigationBarColor, const Color(0x00000000));
    expect(region.value.systemNavigationBarDividerColor, const Color(0x00000000));
    expect(region.value.statusBarIconBrightness, Brightness.dark);
    expect(region.value.systemNavigationBarIconBrightness, Brightness.dark);
    expect(region.value.statusBarBrightness, Brightness.light);
    expect(region.value.systemStatusBarContrastEnforced, isFalse);
    expect(region.value.systemNavigationBarContrastEnforced, isFalse);
    expect((region.child! as ColoredBox).color, fallback.colorScheme.background);
    expect(tester.getSize(find.byWidget(region)), tester.view.physicalSize / tester.view.devicePixelRatio);
  });

  testWidgets('when a screen supplies system styling, it should override the root annotation', (tester) async {
    tester.view.padding = const FakeViewPadding(top: 24, bottom: 16);
    addTearDown(tester.view.resetPadding);
    await tester.pumpWidget(
      MateoApp(
        theme: theme,
        home: const AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: SizedBox.expand(),
        ),
      ),
    );
    await tester.pump();
    expect(SystemChrome.latestStyle?.statusBarIconBrightness, Brightness.light);
    expect(SystemChrome.latestStyle?.systemNavigationBarIconBrightness, Brightness.light);
  });

  testWidgets('when a shortcut is invoked, it should dispatch the configured action', (tester) async {
    var invoked = false;
    await tester.pumpWidget(
      MateoApp(
        theme: theme,
        shortcuts: const {SingleActivator(LogicalKeyboardKey.keyK): ActivateIntent()},
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              invoked = true;
              return null;
            },
          ),
        },
        home: const Focus(autofocus: true, child: Text('Keyboard')),
      ),
    );
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    expect(invoked, isTrue);
  });

  testWidgets('when enabling the debug banner, it should expose the requested debug indicator', (tester) async {
    await tester.pumpWidget(MateoApp(theme: theme, debugShowCheckedModeBanner: true, home: const SizedBox.shrink()));
    expect(find.byType(CheckedModeBanner), findsOneWidget);
  });
}
