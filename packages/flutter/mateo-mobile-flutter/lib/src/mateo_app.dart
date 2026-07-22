import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme/mateo_theme.dart';
import 'widgets/mateo_toast/mateo_toast.dart';

/// The Mateo Mobile application shell.
///
/// A replacement for [MaterialApp] that auto-configures the Mateo Mobile theme, system
/// UI overlay styling, and infrastructure used by Mateo Mobile components. Use
/// [MateoApp] for Navigator-based apps or [MateoApp.router] for Router-based
/// apps.
///
/// ```dart
/// MateoApp(
///   title: 'My App',
///   color: (
///     primary: Color(0xFFFF4A4B),
///     onPrimary: Color(0xFFFFFFFF),
///   ),
///   home: HomePage(),
/// )
/// ```
///
/// ```dart
/// MateoApp.router(
///   title: 'My App',
///   color: (
///     primary: Color(0xFFFF4A4B),
///     onPrimary: Color(0xFFFFFFFF),
///   ),
///   routerConfig: goRouter,
/// )
/// ```
///
/// See also:
///  * [MateoTheme], the default Mateo Mobile theme.
///  * [MaterialApp], the underlying Material application widget.
class MateoApp extends StatelessWidget {
  /// Creates a Mateo Mobile application shell that uses a [Navigator].
  ///
  /// The [color] record configures the primary palette and the foreground used
  /// on primary surfaces. Provide [home], [routes], [onGenerateRoute], or
  /// [builder] for app content.
  const MateoApp({
    required this.title,
    required this.color,
    super.key,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.onNavigationNotification,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.onGenerateTitle,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
  }) : routeInformationProvider = null,
       routeInformationParser = null,
       routerDelegate = null,
       backButtonDispatcher = null,
       routerConfig = null,
       _usesRouter = false;

  /// Creates a Mateo Mobile application shell that uses a [Router].
  ///
  /// The [color] record configures the primary palette and the foreground used
  /// on primary surfaces. The [routerConfig] and [routerDelegate] parameters
  /// must not both be null.
  const MateoApp.router({
    required this.title,
    required this.color,
    super.key,
    this.scaffoldMessengerKey,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.builder,
    this.onGenerateTitle,
    this.onNavigationNotification,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
  }) : assert(
         routerDelegate != null || routerConfig != null,
         'At least one of routerDelegate or routerConfig must be provided.',
       ),
       navigatorKey = null,
       home = null,
       routes = null,
       initialRoute = null,
       onGenerateRoute = null,
       onGenerateInitialRoutes = null,
       onUnknownRoute = null,
       navigatorObservers = null,
       _usesRouter = true;

  /// The key used to access the root [Navigator].
  final GlobalKey<NavigatorState>? navigatorKey;

  /// The key used to access the root [ScaffoldMessenger].
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// The widget displayed for the default route.
  final Widget? home;

  /// The table of named routes available to the [Navigator].
  final Map<String, WidgetBuilder>? routes;

  /// The name of the route displayed when the application starts.
  final String? initialRoute;

  /// The callback that generates routes not found in [routes].
  final RouteFactory? onGenerateRoute;

  /// The callback that generates the initial route stack.
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// The callback that generates a route when no other route matches.
  final RouteFactory? onUnknownRoute;

  /// The callback that receives navigation notifications.
  final NotificationListenerCallback<NavigationNotification>?
  onNavigationNotification;

  /// The observers notified when the [Navigator] changes its route stack.
  final List<NavigatorObserver>? navigatorObservers;

  /// The provider of route information for [MateoApp.router].
  final RouteInformationProvider? routeInformationProvider;

  /// The parser of route information for [MateoApp.router].
  final RouteInformationParser<Object>? routeInformationParser;

  /// The delegate that configures the [Router] navigation hierarchy.
  final RouterDelegate<Object>? routerDelegate;

  /// The dispatcher that handles back-button notifications.
  final BackButtonDispatcher? backButtonDispatcher;

  /// The complete routing configuration for [MateoApp.router].
  final RouterConfig<Object>? routerConfig;

  /// The builder that inserts widgets above the navigator or router.
  final TransitionBuilder? builder;

  /// The application description used by the operating system.
  final String? title;

  /// The callback that generates the application title from context.
  final GenerateAppTitle? onGenerateTitle;

  /// The package-level primary color configuration.
  ///
  /// `primary` seeds the primary and neutral palette scales. `onPrimary` is the
  /// foreground placed on primary surfaces, including primary button text and
  /// icons. Consumers must verify that the pair has sufficient contrast.
  final ({Color primary, Color onPrimary}) color;

  /// The locale used for localized widgets.
  final Locale? locale;

  /// The delegates that produce localized resources.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// The callback that resolves a locale from the platform locale list.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// The callback that resolves a locale from a single platform locale.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// The locales supported by the application.
  final Iterable<Locale> supportedLocales;

  /// Whether the Material baseline grid is displayed.
  final bool debugShowMaterialGrid;

  /// Whether the performance overlay is displayed.
  final bool showPerformanceOverlay;

  /// Whether raster-cached images are checkerboarded.
  final bool checkerboardRasterCacheImages;

  /// Whether offscreen layers are checkerboarded.
  final bool checkerboardOffscreenLayers;

  /// Whether the semantics debugger is displayed.
  final bool showSemanticsDebugger;

  /// Whether the checked-mode banner is displayed.
  final bool debugShowCheckedModeBanner;

  /// The shortcuts available to the application.
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// The actions available to the application.
  final Map<Type, Action<Intent>>? actions;

  /// The identifier used to restore application state.
  final String? restorationScopeId;

  final bool _usesRouter;

  static const SystemUiOverlayStyle _systemUiOverlayStyle =
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      );

  Widget _buildContent(BuildContext context, Widget? child) {
    final userContent =
        builder?.call(context, child) ?? child ?? const SizedBox.shrink();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiOverlayStyle,
      child: MateoToastMessenger(child: userContent),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_usesRouter) {
      return MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        routeInformationProvider: routeInformationProvider,
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate,
        routerConfig: routerConfig,
        backButtonDispatcher: backButtonDispatcher,
        title: title,
        onGenerateTitle: onGenerateTitle,
        onNavigationNotification: onNavigationNotification,
        color: color.primary,
        theme: _theme,
        themeMode: ThemeMode.light,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        debugShowMaterialGrid: debugShowMaterialGrid,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
        builder: _buildContent,
      );
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: home,
      routes: routes ?? const <String, WidgetBuilder>{},
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onUnknownRoute: onUnknownRoute,
      onNavigationNotification: onNavigationNotification,
      navigatorObservers: navigatorObservers ?? const <NavigatorObserver>[],
      builder: _buildContent,
      title: title ?? '',
      onGenerateTitle: onGenerateTitle,
      color: color.primary,
      theme: _theme,
      themeMode: ThemeMode.light,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      debugShowMaterialGrid: debugShowMaterialGrid,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
    );
  }

  ThemeData get _theme => MateoTheme.light(
    primaryColor: color.primary,
    onPrimary: color.onPrimary,
  );
}
