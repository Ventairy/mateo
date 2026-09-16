part of '../mateo_button.dart';

/// The content and visual treatment mounted by a Mateo button.
@immutable
sealed class MateoButtonPresentation extends StatefulWidget {
  const MateoButtonPresentation._();

  /// Creates a labeled button with optional supporting icons.
  const factory MateoButtonPresentation.label({
    required String label,
    MateoButtonVariant? variant,
    MateoButtonColorScheme? colorScheme,
    MateoButtonSize size,
    MateoButtonWidth width,
    MateoButtonAlignment alignment,
    double elevation,
    Widget? leadingIcon,
    Widget? trailingIcon,
  }) = _MateoLabelButtonPresentation;

  /// Creates a circular action without labels.
  const factory MateoButtonPresentation.icon({
    required Widget icon,
    MateoButtonVariant? variant,
    MateoButtonColorScheme? colorScheme,
    MateoButtonSize size,
    double elevation,
    String? semanticLabel,
  }) = _MateoIconButtonPresentation;

  /// The semantic emphasis and color treatment of this action.
  ///
  /// When omitted, the button uses the contextual default, currently
  /// [MateoButtonVariant.primary].
  MateoButtonVariant? get variant;

  /// The optional colors replacing the variant's theme treatment.
  ///
  /// When omitted, colors follow the nearest Mateo theme
  MateoButtonColorScheme? get colorScheme;

  /// The button's coordinated space and content proportions.
  MateoButtonSize get size;

  /// The surface's lift from its surroundings, using Mateo elevation.
  double get elevation;
}
