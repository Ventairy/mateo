part of 'mateo_widget_transition.dart';

/// Phase of a [MateoWidgetTransition] transition sequence.
enum _MateoWidgetTransitionPhase {
  /// No transition is running; the current widget is displayed statically.
  idle,

  /// The current (old) widget is animating out.
  exit,

  /// The target (new) widget is animating in.
  enter,
}
