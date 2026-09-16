part of 'mateo_button.dart';

/// The mounted visual presentation of a Mateo button.
@immutable
sealed class MateoButtonPresentation extends StatefulWidget {
  const MateoButtonPresentation._({super.key});

  /// Creates a labeled button with optional leading and trailing icons.
  ///
  /// The [elevation] defaults to zero and is resolved by Mateo when the
  /// complete button surface is painted.
  const factory MateoButtonPresentation.label({
    required String label,
    required MateoButtonVariant variant,
    double elevation,
    MateoButtonIconBuilder? leadingIconBuilder,
    MateoButtonIconBuilder? trailingIconBuilder,
    MateoButtonColorScheme? colorScheme,
    MateoButtonAlignment alignment,
    MateoButtonFit fit,
    EdgeInsetsGeometry? padding,
  }) = _MateoLabelButtonPresentation;

  /// Creates a circular icon button.
  ///
  /// The [elevation] defaults to zero and is resolved by Mateo when the
  /// complete button surface is painted.
  const factory MateoButtonPresentation.icon({
    required MateoIconButtonIconBuilder iconBuilder,
    required MateoButtonVariant variant,
    double elevation,
    String? semanticLabel,
    MateoButtonColorScheme? colorScheme,
    double buttonSize,
    double? hitAreaSize,
    double iconSize,
  }) = _MateoIconButtonPresentation;

  MateoButtonVariant get variant;

  /// Physical distance of this button surface from its surrounding content.
  double get elevation;

  MateoButtonColorScheme? get colorScheme;
  double? get _buttonSize;
  Duration get _contentTransitionDuration;
}
