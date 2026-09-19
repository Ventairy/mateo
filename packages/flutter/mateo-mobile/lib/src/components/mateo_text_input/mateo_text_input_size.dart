/// The surface sizes of a Mateo text input.
enum MateoTextInputSize {
  /// A comfortable surface for grouped inputs in content.
  small(
    height: 50,
    leadingIconSize: 28,
    trailingIconSize: 23,
    leadingPadding: 12,
    trailingPadding: 12,
  ),

  /// A generous surface for standalone inputs.
  standard(
    height: 57,
    leadingIconSize: 30,
    trailingIconSize: 25,
    leadingPadding: 14,
    trailingPadding: 14,
  ),

  /// A prominent input supported by the plain treatment only.
  large(
    height: 57,
    leadingIconSize: 32,
    trailingIconSize: 25,
    leadingPadding: 14,
    trailingPadding: 14,
  );

  const MateoTextInputSize({
    required this.height,
    required this.leadingIconSize,
    required this.trailingIconSize,
    required this.leadingPadding,
    required this.trailingPadding,
  });

  /// The minimum surface height.
  final double height;

  /// The leading icon's square size.
  final double leadingIconSize;

  /// The trailing icon's square size.
  final double trailingIconSize;

  /// The inset between the leading edge and its icon.
  final double leadingPadding;

  /// The inset between the trailing edge and its icon or text.
  final double trailingPadding;
}
