import 'package:flutter/animation.dart';

/// Visual feedback supported by Mateo press controls.
enum MateoPressAnimationType {
  /// Scales the content down while pressed.
  scale(pressedScale: 0.96),

  /// Scales and fades the content while pressed.
  scaleFade(pressedScale: 0.96, pressedOpacity: 0.4),

  /// Keeps the content unchanged while pressed.
  none(pressDuration: Duration.zero, releaseDuration: Duration.zero);

  const MateoPressAnimationType({
    this.pressedScale = 1,
    this.pressedOpacity = 1,
    this.pressDuration = const Duration(milliseconds: 150),
    this.releaseDuration = const Duration(milliseconds: 150),
  });

  /// The content's scale at the fully pressed state.
  final double pressedScale;

  /// The content's opacity at the fully pressed state.
  final double pressedOpacity;

  /// The time taken to reach the fully pressed state from rest.
  final Duration pressDuration;

  /// The time taken to return from the fully pressed state to rest.
  final Duration releaseDuration;

  /// The easing used to approach the pressed state.
  Curve get pressCurve => Curves.easeOutCubic;

  /// The easing used to restore the content's scale.
  Curve get releaseScaleCurve => Curves.linear;

  /// The easing used to restore the content's opacity.
  Curve get releaseOpacityCurve => Curves.easeOutCubic;
}
