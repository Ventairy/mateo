import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show FadeForwardsPageTransitionsBuilder, PredictiveBackPageTransitionsBuilder;
import 'package:flutter/services.dart';

import '../../bases/base_mateo_page_route/base_mateo_page_route.dart';
import '../../components/mateo_page_transition/mateo_page_transition.dart';
import '../../components/mateo_page_transition/mateo_page_transitions_builder.dart';
import '../../theme/mateo_theme.dart';

part '_mateo_android_page_route.dart';
part '_mateo_ios_page_route.dart';
part '_mateo_page_route.dart';
part '_mateo_predictive_back_gesture_detector.dart';

/// A Flutter page with native navigation or explicit Mateo motion.
///
/// Works inside MateoApp and MateoApp.router without another component theme.
/// Explicit transitions support Android predictive back and omit iOS edge-swipe.
///
/// ```dart
/// const MateoPage<void>(transition: .slide(), child: Text('Details'))
/// ```
class MateoPage<T> extends Page<T> {
  /// Creates a page with [child] as its route content.
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

  /// The content of the destination.
  final Widget child;

  /// The explicit Mateo motion, or null for automatic behavior.
  final MateoPageTransition? transition;

  /// The title used by native iOS navigation.
  final String? title;

  /// Whether inactive route content stays in memory.
  final bool maintainState;

  /// Whether the destination is presented as a full-screen dialog.
  final bool fullscreenDialog;

  /// Whether transitions may capture route content for rendering.
  final bool allowSnapshotting;

  @override
  bool canUpdate(Page<dynamic> other) {
    return super.canUpdate(other) && other is MateoPage && transition.runtimeType == other.transition.runtimeType;
  }

  @override
  PageRoute<T> createRoute(BuildContext context) {
    final reducedMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (transition != null) {
      return _MateoPageRoute<T>(page: this, reducedMotion: reducedMotion);
    }

    if (defaultTargetPlatform == .iOS) {
      return _MateoIosPageRoute<T>(page: this, reducedMotion: reducedMotion);
    }

    return _MateoAndroidPageRoute<T>(
      page: this,
      reducedMotion: reducedMotion,
      backgroundColor: MateoTheme.of(context).colorScheme.background,
    );
  }
}
