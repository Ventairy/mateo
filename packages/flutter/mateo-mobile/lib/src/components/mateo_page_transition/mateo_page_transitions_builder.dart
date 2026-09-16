import 'package:flutter/widgets.dart';

import 'mateo_page_transition.dart';

/// A Flutter route adapter for a Mateo page transition.
///
/// Use MateoPage for complete navigation integration. An application-owned
/// PageRoute can forward its durations, buildTransitions, and delegatedTransition
/// to this builder. That route owns gestures and reduced-motion controller timing.
/// Keep the builder for the lifetime of its configuration; it holds no route state.
class MateoPageTransitionsBuilder extends PageTransitionsBuilder {
  /// Creates a route adapter for [transition].
  const MateoPageTransitionsBuilder({required this.transition});

  /// The Mateo motion interpreted by this builder.
  final MateoPageTransition transition;

  void _validate() {
    if (transition.duration.isNegative) {
      throw ArgumentError.value(transition.duration, 'duration', 'Must be nonnegative.');
    }
    if (transition.reverseDuration.isNegative) {
      throw ArgumentError.value(transition.reverseDuration, 'reverseDuration', 'Must be nonnegative.');
    }
  }

  @override
  Duration get transitionDuration {
    _validate();
    return transition.duration;
  }

  @override
  Duration get reverseTransitionDuration {
    _validate();
    return transition.reverseDuration;
  }

  @override
  DelegatedTransitionBuilder get delegatedTransition => _buildOutgoing;

  Widget? _buildOutgoing(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    bool allowSnapshotting,
    Widget? child,
  ) {
    if (child == null) return null;
    return transition.buildOutgoing(
      animation: secondaryAnimation,
      allowSnapshotting: allowSnapshotting,
      child: child,
    );
  }

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    _validate();
    final incoming = transition.buildIncoming(
      animation: animation,
      allowSnapshotting: route.allowSnapshotting,
      child: child,
    );
    // Flutter suppresses this secondary animation when another builder delegates
    // its outgoing treatment. It remains necessary when two routes share a builder.
    return _buildOutgoing(context, animation, secondaryAnimation, route.allowSnapshotting, incoming)!;
  }
}
