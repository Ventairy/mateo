/// The surface sizes of a Mateo text input.
enum MateoTextInputSize {
  /// A comfortable surface for grouped inputs in content.
  small(
    height: 50,
    fontSize: 15,
    leadingIconSize: 28,
    trailingIconSize: 23,
    lineHeight: 20,
    leadingPadding: 12,
    trailingPadding: 12,
  ),

  /// A generous surface for standalone inputs.
  standard(
    height: 57,
    fontSize: 16,
    leadingIconSize: 30,
    trailingIconSize: 25,
    lineHeight: 24,
    leadingPadding: 14,
    trailingPadding: 14,
  );

  const MateoTextInputSize({
    required this.height,
    required this.fontSize,
    required this.leadingIconSize,
    required this.trailingIconSize,
    required this.lineHeight,
    required this.leadingPadding,
    required this.trailingPadding,
  });

  /// The minimum surface height.
  final double height;

  /// The entered text and placeholder font size.
  final double fontSize;

  /// The leading icon's square size.
  final double leadingIconSize;

  /// The trailing icon's square size.
  final double trailingIconSize;

  /// The inset between the leading edge and its icon.
  final double leadingPadding;

  /// The inset between the trailing edge and its icon or text.
  final double trailingPadding;

  /// The text line height in logical pixels before text scaling.
  final double lineHeight;
}
