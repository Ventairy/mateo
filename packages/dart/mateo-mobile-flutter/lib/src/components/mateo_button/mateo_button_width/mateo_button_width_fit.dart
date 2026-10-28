part of 'mateo_button_width.dart';

/// A fit width request for a labeled button.
final class MateoButtonWidthFit extends MateoButtonWidth {
  /// Creates a fit width request.
  const MateoButtonWidthFit() : super._();

  /// Whether both values describe the same width request.
  @override
  bool operator ==(Object other) => other is MateoButtonWidthFit;

  /// The hash of this width request.
  @override
  int get hashCode => Object.hash(MateoButtonWidthFit, null);
}
