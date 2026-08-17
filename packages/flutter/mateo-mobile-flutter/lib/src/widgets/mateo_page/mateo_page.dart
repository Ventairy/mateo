import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

part 'mateo_page_transition.dart';
part 'mateo_page_transition_direction.dart';
part 'routes/_mateo_page_route.dart';
part 'routes/_mateo_predictive_back_gesture_detector.dart';
part 'transitions/_mateo_push_page_transition.dart';
part 'transitions/_mateo_wash_page_transition.dart';
part 'transitions/shared/_mateo_cubic_curve.dart';
part 'transitions/shared/_mateo_transition_color_cache.dart';

/// A platform-aware page configuration for Mateo routes.
///
/// [MateoPage] creates a native Cupertino route on iOS and a native Material
/// route on Android when [transition] is omitted. Supply a
/// [MateoPageTransition] to replace the native motion with a Mateo transition.
///
/// The type parameter `T` is the result type returned when the route is popped.
///
/// ```dart
/// MateoPage<void>(
///   child: JobView(jobId: jobId),
///   transition: MateoPageTransition.wash(),
/// )
/// ```
///
/// When the platform requests reduced motion, explicit Mateo transitions show
/// [child] immediately. Native transitions continue to follow Flutter's
/// platform accessibility behavior.
///
/// See also:
///  * [MateoPageTransition], the available explicit Mateo page transitions.
///  * [MaterialPage], Flutter's native Material page configuration.
///  * [CupertinoPage], Flutter's native Cupertino page configuration.
class MateoPage<T> extends Page<T> {
  /// Creates a platform-aware Mateo page.
  ///
  /// The [child] is the route content. When [transition] is `null`, iOS uses
  /// native Cupertino navigation and Android uses native Material navigation.
  ///
  /// The [title] supplies the previous-page title used by Cupertino navigation
  /// bars. [maintainState], [fullscreenDialog], and [allowSnapshotting] retain
  /// their Flutter route meanings.
  const MateoPage({
    required this.child,
    this.transition,
    this.title,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = true,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    super.canPop,
    super.onPopInvoked,
  });

  /// The content displayed by the route.
  final Widget child;

  /// The explicit Mateo transition used instead of native platform motion.
  ///
  /// When this is `null`, [MateoPage] uses native Cupertino motion on iOS and
  /// native Material motion on Android.
  ///
  /// When updating a page in [Navigator.pages], direction, duration, and
  /// snapshotting changes within the same transition family update the
  /// existing route. Switching between native, wash, and push
  /// transitions replaces the route because each family has different motion
  /// and gesture behavior.
  final MateoPageTransition? transition;

  /// The title used by Cupertino navigation bars for the previous page.
  ///
  /// Material routes and explicit Mateo transitions do not use this value.
  final String? title;

  /// Whether the route remains in memory while it is inactive.
  final bool maintainState;

  /// Whether the route is presented as a full-screen dialog.
  final bool fullscreenDialog;

  /// Whether route transitions may snapshot the entering and exiting pages.
  final bool allowSnapshotting;

  /// Whether this page can update [other] without replacing its route.
  ///
  /// Pages with the same [Page.key] reuse their route while they remain in the
  /// same transition family. Changing between native, wash, and push
  /// transitions creates the route required by the new family.
  @override
  bool canUpdate(Page<dynamic> other) {
    return super.canUpdate(other) &&
        other is MateoPage<dynamic> &&
        _transitionFamilyOf(transition) == _transitionFamilyOf(other.transition);
  }

  /// The route that presents this page using native or explicit Mateo motion.
  ///
  /// The platform is resolved from [ThemeData.platform]. Explicit transitions
  /// are disabled when [MediaQuery.disableAnimationsOf] is `true`.
  @override
  Route<T> createRoute(BuildContext context) {
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final platform = Theme.of(context).platform;

    if (transition case final transition?) {
      return _MateoTransitionPageRoute<T>(
        page: this,
        transition: transition,
        platform: platform,
        disableAnimations: disableAnimations,
      );
    }

    if (platform == TargetPlatform.iOS) {
      return _MateoCupertinoPageRoute<T>(
        page: this,
        disableAnimations: disableAnimations,
      );
    }

    return _MateoMaterialPageRoute<T>(
      page: this,
      disableAnimations: disableAnimations,
    );
  }
}
