import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart' show MorphNavigatorObserver;

import '../bases/base_mateo_page_route/base_mateo_page_route.dart';
import '../components/mateo_sheet/show_mateo_sheet.dart' show MateoSheetRoute;

/// A navigator observer to guide Mateo needed route informations.
///
/// Retain one instance per [Navigator] and install it from the navigator's
/// first build. Router-managed and nested navigators each need their own
/// observer. MateoApp installs one for its own navigator automatically.
///
/// ```dart
/// final observer = MateoNavigatorObserver();
///
/// Widget buildNavigator(Widget home) => Navigator(
///   observers: [observer],
///   onGenerateRoute: (settings) => PageRouteBuilder<void>(
///     settings: settings,
///     pageBuilder: (context, animation, secondaryAnimation) => home,
///   ),
/// );
/// ```
class MateoNavigatorObserver extends MorphNavigatorObserver {
  /// Creates an observer for one navigator containing Mateo surfaces.
  MateoNavigatorObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is BaseMateoPageRoute && previousRoute is MateoSheetRoute) {
      route.disablePrimaryTransition();
    }
  }
}
