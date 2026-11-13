import 'package:flutter/widgets.dart';

part 'mateo_icon_background_colored.dart';
part 'mateo_icon_background_custom.dart';

/// A decorative circular background behind a Mateo icon.
@immutable
sealed class MateoIconBackground {
  const new _();

  /// Fills the background with a solid [color].
  const factory colored({required Color color}) = MateoIconBackgroundColored;

  /// Fills the background with [child], clipped to the icon's circle.
  ///
  /// The child receives the background's tight bounds. Configure image fitting
  /// on the child; its gestures and semantics are excluded by the icon.
  const factory custom({required Widget child}) = MateoIconBackgroundCustom;
}
