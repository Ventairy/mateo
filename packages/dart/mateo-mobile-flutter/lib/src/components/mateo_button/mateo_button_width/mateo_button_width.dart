import 'package:flutter/foundation.dart';

part 'mateo_button_width_fill.dart';
part 'mateo_button_width_fit.dart';

/// The requested total width of a labeled button, including its padding.
@immutable
sealed class MateoButtonWidth {
  const MateoButtonWidth._();

  /// Creates width that fills the available extent, optionally capped by [maxWidth].
  const factory MateoButtonWidth.fill({double? maxWidth}) = MateoButtonWidthFill;

  /// Creates content-sized width within the parent's constraints.
  const factory MateoButtonWidth.fit() = MateoButtonWidthFit;
}
