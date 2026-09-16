part of 'mateo_color_scheme.dart';

/// Semantic colors for a Mateo text-input variant.
@immutable
class MateoTextFieldVariantColorScheme {
  /// Creates the complete color contract for a text-input variant.
  ///
  /// Surface roles may be transparent when a variant does not render a
  /// background, or icon.
  const MateoTextFieldVariantColorScheme({
    required this.background,
    required this.backgroundDisabled,
    required this.text,
    required this.textDisabled,
    required this.placeholderResting,
    required this.placeholderDisabled,
    required this.iconResting,
    required this.iconFocused,
    required this.iconDisabled,
    required this.caret,
    required this.selectionHighlight,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoTextFieldVariantColorScheme.lerp(
    MateoTextFieldVariantColorScheme a,
    MateoTextFieldVariantColorScheme b,
    double t,
  ) => MateoTextFieldVariantColorScheme(
    background: Color.lerp(a.background, b.background, t)!,
    backgroundDisabled: Color.lerp(
      a.backgroundDisabled,
      b.backgroundDisabled,
      t,
    )!,
    text: Color.lerp(a.text, b.text, t)!,
    textDisabled: Color.lerp(a.textDisabled, b.textDisabled, t)!,
    placeholderResting: Color.lerp(
      a.placeholderResting,
      b.placeholderResting,
      t,
    )!,
    placeholderDisabled: Color.lerp(
      a.placeholderDisabled,
      b.placeholderDisabled,
      t,
    )!,
    iconResting: Color.lerp(a.iconResting, b.iconResting, t)!,
    iconFocused: Color.lerp(a.iconFocused, b.iconFocused, t)!,
    iconDisabled: Color.lerp(a.iconDisabled, b.iconDisabled, t)!,
    caret: Color.lerp(a.caret, b.caret, t)!,
    selectionHighlight: Color.lerp(
      a.selectionHighlight,
      b.selectionHighlight,
      t,
    )!,
  );

  /// Input surface color.
  final Color background;

  /// Input surface color while the input is disabled.
  final Color backgroundDisabled;

  /// Entered text color while the input is enabled.
  final Color text;

  /// Entered text color while the input is disabled.
  final Color textDisabled;

  /// Placeholder color while the input is enabled.
  final Color placeholderResting;

  /// Placeholder color while the input is disabled.
  final Color placeholderDisabled;

  /// Icon color while the input is resting.
  final Color iconResting;

  /// Icon color while the input is active.
  final Color iconFocused;

  /// Icon color while the input is disabled.
  final Color iconDisabled;

  /// Insertion-caret color.
  final Color caret;

  /// Text-selection highlight color.
  final Color selectionHighlight;

  /// {@macro mateo_color_scheme_copy_with}
  MateoTextFieldVariantColorScheme copyWith({
    Color? background,
    Color? backgroundDisabled,
    Color? text,
    Color? textDisabled,
    Color? placeholder,
    Color? placeholderDisabled,
    Color? icon,
    Color? iconActive,
    Color? iconDisabled,
    Color? caret,
    Color? selectionHighlight,
  }) => MateoTextFieldVariantColorScheme(
    background: background ?? this.background,
    backgroundDisabled: backgroundDisabled ?? this.backgroundDisabled,
    text: text ?? this.text,
    textDisabled: textDisabled ?? this.textDisabled,
    placeholderResting: placeholder ?? placeholderResting,
    placeholderDisabled: placeholderDisabled ?? this.placeholderDisabled,
    iconResting: icon ?? iconResting,
    iconFocused: iconActive ?? iconFocused,
    iconDisabled: iconDisabled ?? this.iconDisabled,
    caret: caret ?? this.caret,
    selectionHighlight: selectionHighlight ?? this.selectionHighlight,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoTextFieldVariantColorScheme &&
          background == other.background &&
          backgroundDisabled == other.backgroundDisabled &&
          text == other.text &&
          textDisabled == other.textDisabled &&
          placeholderResting == other.placeholderResting &&
          placeholderDisabled == other.placeholderDisabled &&
          iconResting == other.iconResting &&
          iconFocused == other.iconFocused &&
          iconDisabled == other.iconDisabled &&
          caret == other.caret &&
          selectionHighlight == other.selectionHighlight;

  @override
  int get hashCode => Object.hashAll([
    background,
    backgroundDisabled,

    text,
    textDisabled,
    placeholderResting,
    placeholderDisabled,
    iconResting,
    iconFocused,
    iconDisabled,
    caret,
    selectionHighlight,
  ]);
}
