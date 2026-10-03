// Fixed variant configuration belongs in its constructor.
// ignore_for_file: avoid_field_initializers_in_const_classes

part of 'mateo_menu_button_animation.dart';

/// Shows an adjacent menu using the surface pop entrance.
final class MateoMenuButtonAnimationPop extends MateoMenuButtonAnimation {
  /// Creates a pop menu style.
  const MateoMenuButtonAnimationPop()
    : duration = const Duration(milliseconds: 400),
      curve = Curves.easeOutBack,
      exitDuration = const Duration(milliseconds: 210),
      exitCurve = Curves.easeInCubic,
      super._();

  /// The duration of the menu surface entrance.
  final Duration duration;

  /// The easing of the menu surface entrance.
  final Curve curve;

  /// The duration of the menu dismissal.
  final Duration exitDuration;

  /// The easing of the menu dismissal.
  final Curve exitCurve;
}
