import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart' show MorphNavigatorObserver;

import '../../components/mateo_toast/mateo_toast_host.dart' show MateoToastHost;
import '../../foundation/mateo_environment/mateo_environment.dart';
import '../../foundation/mateo_navigator_observer.dart';
import '../../theme/mateo_theme.dart';
import '../../theme/mateo_theme_data.dart';

/// The application root for a Mateo mobile app.
///
/// Provides navigation, the resolved [theme], widget localization, and a
/// background matching the theme.
/// chosen for the resolved appearance. Screens own their safe content insets
/// and any more specific system-bar annotations.
///
/// Use the home constructor for an app with a root page and imperative
/// navigation. Use [MateoApp.router] for declarative routing and deep links.
/// Updating the theme preserves the existing navigation state.
///
/// ```dart
/// MateoApp(
///   theme: MateoThemeData.light(
///     accentColor: const Color(0xFF4A5CFF),
///     onAccent: const Color(0xFFFFFFFF),
///   ),
///   home: const Center(child: Text('Hello, Mateo')),
/// )
/// ```
///
/// See also:
/// * [MateoTheme.of], for reading the theme inside routes and app builders.
class MateoApp extends StatefulWidget {
  /// Creates an app with [home] as its root route and the supplied [theme].
  ///
  /// Navigation starts at `/`. Subsequent routes supplied to the navigator
  /// own their transitions. Use [MateoApp.router] for deep-link handling.
  const MateoApp({
    required this.theme,
    required Widget this.home,
    super.key,
    this.title = '',
    this.builder,
    this.locale,
    this.supportedLocales = const [Locale('en', 'US')],
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.restorationScopeId,
    this.shortcuts,
    this.actions,
    this.debugShowCheckedModeBanner = false,
    this.navigatorKey,
    this.navigatorObservers = const [],
  }) : routerConfig = null;

  /// Creates an app with [routerConfig] and the supplied resolved [theme].
  ///
  /// The router owns its navigation keys, observers, route transitions, and
  /// deep-link policy. Retain the router configuration when rebuilding the app.
  ///
  /// ```dart
  /// Widget buildApp(MateoThemeData theme, RouterConfig<Object> router) {
  ///   return MateoApp.router(theme: theme, routerConfig: router);
  /// }
  /// ```
  const MateoApp.router({
    required this.theme,
    required RouterConfig<Object> this.routerConfig,
    super.key,
    this.title = '',
    this.builder,
    this.locale,
    this.supportedLocales = const [Locale('en', 'US')],
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.restorationScopeId,
    this.shortcuts,
    this.actions,
    this.debugShowCheckedModeBanner = false,
  }) : home = null,
       navigatorKey = null,
       navigatorObservers = const [];

  /// The resolved appearance applied throughout the app.
  ///
  /// This app does not select themes from platform brightness. Supply the
  /// appearance to use; the current dark theme factory resolves to light.
  final MateoThemeData theme;

  /// The root page for the home constructor, or null for a router app.
  final Widget? home;

  /// The routing configuration, or null for a home-based app.
  final RouterConfig<Object>? routerConfig;

  /// The application description used by the operating system.
  final String title;

  /// The builder for wrapping the navigator or router below app defaults.
  ///
  /// Its context has access to the theme, localization, and media settings.
  /// The supplied child is the navigation subtree and must be retained in the
  /// returned widget tree for navigation to continue working.
  final TransitionBuilder? builder;

  /// The requested locale, or null to use the platform's preferred locales.
  final Locale? locale;

  /// The nonempty list of supported locales, in fallback preference order.
  final Iterable<Locale> supportedLocales;

  /// The app's localization delegates, before the default widget delegate.
  ///
  /// Consumer delegates take precedence when they provide the same resource
  /// type. Mateo supplies global widget localization and text directionality.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// The optional resolver for the platform's preferred locale list.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// The identifier enabling Flutter state restoration for the app.
  final String? restorationScopeId;

  /// The keyboard shortcuts available throughout the app.
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// The actions associated with app-level shortcut intents.
  final Map<Type, Action<Intent>>? actions;

  /// Whether to show Flutter's debug banner in debug builds.
  final bool debugShowCheckedModeBanner;

  /// The root navigator key for the home constructor.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// The root navigator observers for the home constructor.
  final List<NavigatorObserver> navigatorObservers;

  @override
  State<MateoApp> createState() => _MateoAppState();
}

class _MateoAppState extends State<MateoApp> {
  final _navigatorObserver = MateoNavigatorObserver();

  List<NavigatorObserver> get _navigatorObservers =>
      widget.navigatorObservers.any((observer) => observer is MorphNavigatorObserver)
      ? widget.navigatorObservers
      : [_navigatorObserver, ...widget.navigatorObservers];

  static const _transparent = Color(0x00000000);

  Widget _buildContent(BuildContext context, Widget? child) {
    final symbolBrightness = widget.theme.brightness == Brightness.light ? Brightness.dark : Brightness.light;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: _transparent,
        statusBarBrightness: widget.theme.brightness,
        statusBarIconBrightness: symbolBrightness,
        systemNavigationBarColor: _transparent,
        systemNavigationBarDividerColor: _transparent,
        systemNavigationBarIconBrightness: symbolBrightness,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
      child: ColoredBox(
        color: widget.theme.colorScheme.background,
        child: MateoToastHost(
          child: Builder(builder: (context) => widget.builder?.call(context, child) ?? child!),
        ),
      ),
    );
  }

  static PageRoute<T> _buildHomeRoute<T>(RouteSettings settings, WidgetBuilder builder) => PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: .zero,
    reverseTransitionDuration: .zero,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
  );

  @override
  Widget build(BuildContext context) => MateoEnvironment(
    child: MateoTheme(
      data: widget.theme,
      child: widget.routerConfig != null
          ? WidgetsApp.router(
              routerConfig: widget.routerConfig,
              title: widget.title,
              color: widget.theme.colorScheme.accent,
              builder: _buildContent,
              locale: widget.locale,
              supportedLocales: widget.supportedLocales,
              localizationsDelegates: [...?widget.localizationsDelegates, GlobalWidgetsLocalizations.delegate],
              localeListResolutionCallback: widget.localeListResolutionCallback,
              restorationScopeId: widget.restorationScopeId,
              shortcuts: widget.shortcuts,
              actions: widget.actions,
              debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
            )
          : WidgetsApp(
              home: widget.home,
              initialRoute: Navigator.defaultRouteName,
              pageRouteBuilder: _buildHomeRoute,
              navigatorKey: widget.navigatorKey,
              navigatorObservers: _navigatorObservers,
              title: widget.title,
              color: widget.theme.colorScheme.accent,
              builder: _buildContent,
              locale: widget.locale,
              supportedLocales: widget.supportedLocales,
              localizationsDelegates: [...?widget.localizationsDelegates, GlobalWidgetsLocalizations.delegate],
              localeListResolutionCallback: widget.localeListResolutionCallback,
              restorationScopeId: widget.restorationScopeId,
              shortcuts: widget.shortcuts,
              actions: widget.actions,
              debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
            ),
    ),
  );
}
