part of 'mateo_tap.dart';

/// Tap feedback animation variants supported by [MateoTap].
enum MateoTapAnimationType {
  /// No visual feedback on press; fires [MateoTap.onPressed] immediately.
  none,

  /// Scales down while pressed.
  scale,

  /// Scales down and fades while pressed.
  scaleFade,
}
