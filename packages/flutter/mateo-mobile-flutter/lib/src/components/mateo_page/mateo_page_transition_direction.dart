part of 'mateo_page.dart';

/// The physical travel direction of a Mateo page transition.
///
/// Directions are physical screen directions and do not change in
/// right-to-left layouts.
enum MateoPageTransitionDirection {
  /// Upward travel that starts beyond the bottom edge.
  up,

  /// Downward travel that starts beyond the top edge.
  down,

  /// Leftward travel that starts beyond the right edge.
  left,

  /// Rightward travel that starts beyond the left edge.
  right,
}
