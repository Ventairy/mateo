part of 'mateo_color_scheme.dart';

/// The semantic color treatments for Mateo text inputs.
@immutable
final class MateoTextInputsColorScheme {
  const MateoTextInputsColorScheme._({required this.filled});

  /// The filled treatments.
  final MateoFilledTextInputColorScheme filled;

  /// Whether every color role equals the other scheme.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MateoTextInputsColorScheme && filled == other.filled;

  /// The hash of this scheme's color roles.
  @override
  int get hashCode => filled.hashCode;
}
