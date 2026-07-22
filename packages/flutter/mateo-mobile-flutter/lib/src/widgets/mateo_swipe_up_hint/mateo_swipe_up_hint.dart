import 'package:flutter/material.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/gen/lotties.g.dart';

/// A Mateo animated hint showing a hand swiping upward on a phone screen.
///
/// Renders a looping animation: a neutral phone body, a hand
/// pointer that swipes up the phone's face, an up-arrow that slides upward,
/// and a touch ripple that expands from the contact point.
///
///
///
/// ```dart
/// MateoSwipeUpHint()
/// MateoSwipeUpHint(size: 200)
/// MateoSwipeUpHint(
///   size: 200,
///   phoneColor: Color(0xFF1F1F1F),
///   accentColor: Color(0xFF4A5CFF),
/// )
/// ```
///
class MateoSwipeUpHint extends StatelessWidget {
  /// Creates a Mateo Mobile swipe-up hint.
  const MateoSwipeUpHint({
    super.key,
    this.height = 120.0,
    this.phoneColor,
    this.accentColor,
  });

  /// Height of the widget in logical pixels.
  final double height;

  /// Override color for the phone body.
  ///
  /// When `null`, defaults to neutral step 12 from the active [MateoTheme].
  final Color? phoneColor;

  /// Override color for the hand, arrow, and ripple (the accent elements).
  ///
  /// When `null`, defaults to neutral step 3 from the active [MateoTheme].
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final neutral = context.mateo.palette.neutral;
    final phone = phoneColor ?? neutral[12];
    final hand = accentColor ?? neutral[3];

    return $Lotties.swipeUpPhoneAnimation(
      height: height,
      color1: hand,
      color2: phone,
      progress: MediaQuery.disableAnimationsOf(context) ? 0.3 : null,
    );
  }
}
