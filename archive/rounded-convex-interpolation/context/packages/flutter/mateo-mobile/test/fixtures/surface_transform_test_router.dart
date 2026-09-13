import 'package:flutter/widgets.dart';
import 'package:mateo_mobile_draft/mateo_mobile.dart';

import 'surface_transform_test_widgets.dart';

/// A router-owned navigator with its own surface observer.
class SurfaceTransformTestRouter extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  /// Creates a router starting at [home].
  SurfaceTransformTestRouter({required this.home});

  /// The initial route's content.
  final Widget home;

  /// The observer retained for this navigator.
  final observer = MateoNavigatorObserver();

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(Object configuration) async {}

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    observers: [observer],
    onGenerateRoute: (settings) => surfaceTransformRoute(home),
  );
}
