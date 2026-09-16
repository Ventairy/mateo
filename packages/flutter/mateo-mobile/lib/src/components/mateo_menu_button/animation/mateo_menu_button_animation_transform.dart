// Fixed variant configuration belongs in its constructor.
// ignore_for_file: avoid_field_initializers_in_const_classes

part of 'mateo_menu_button_animation.dart';

/// An animation style that transforms the trigger into the menu panel.
final class MateoMenuButtonAnimationTransform extends MateoMenuButtonAnimation {
  /// Creates a transform animation style.
  const MateoMenuButtonAnimationTransform()
    : duration = const Duration(milliseconds: 230),
      curve = const Cubic(0.35, 1, 0.35, 1),
      buttonContentEffects = const [.crossfade(curve: Interval(0, 0.35, curve: Curves.easeOut))],
      menuContentEffects = const [.crossfade(curve: Interval(0, 0.3, curve: Curves.easeOut))],
      super._();

  /// The duration of the surface transform.
  final Duration duration;

  /// The easing of the moving surface geometry.
  final Curve curve;

  /// The content effects for flights leaving the trigger.
  final List<MateoSurfaceTransformAnimationContentEffect> buttonContentEffects;

  /// The content effects for flights leaving the menu.
  final List<MateoSurfaceTransformAnimationContentEffect> menuContentEffects;
}
