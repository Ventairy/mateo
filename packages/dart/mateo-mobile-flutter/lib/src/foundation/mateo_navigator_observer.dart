import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart' show MorphMatchContext, MorphNavigatorObserver, MorphTarget;

import '../bases/base_mateo_page_route/base_mateo_page_route.dart';
import '../components/mateo_sheet/show_mateo_sheet.dart' show MateoSheetRoute;
import 'mateo_sheet_to_view_transition/mateo_sheet_to_view_transition.dart';

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

  @internal
  // Internal coordination is not part of the consumer API.
  // ignore: public_member_api_docs
  final sheetToViewMorphTarget = MorphTarget(
    tag: #mateoSheetToView,
    duration: kSheetToViewTransformAnimation.duration.value,
    reverseDuration: kSheetToViewTransformAnimation.reverseDuration.value,
    curve: kSheetToViewTransformAnimation.curve,
    reverseCurve: kSheetToViewTransformAnimation.reverseCurve,
    watchDestination: true,
    canMatch: _isSheetViewTransition,
  );

  static bool _isSheetViewTransition(MorphMatchContext match) => switch (match.operation) {
    .push => match.sourceRoute is MateoSheetRoute && match.destinationRoute is BaseMateoPageRoute,
    .pop => match.sourceRoute is BaseMateoPageRoute && match.destinationRoute is MateoSheetRoute,
    _ => false,
  };

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is BaseMateoPageRoute && previousRoute is MateoSheetRoute) {
      final durations = sheetToViewTransformDurations;
      route.useSurfaceTransition(
        sourceRoute: previousRoute,
        forwardDuration: durations.forward,
        reverseDuration: durations.reverse,
      );
    }
  }
}
