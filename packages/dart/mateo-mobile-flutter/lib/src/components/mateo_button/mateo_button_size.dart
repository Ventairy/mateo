/// The shared surface sizes of a Mateo button.
enum MateoButtonSize {
  /// A compact surface for contextual actions.
  mini(height: 40),

  /// A comfortable surface for grouped actions in content.
  small(height: 48),

  /// A generous surface for standalone actions.
  standard(height: 56);

  const MateoButtonSize({required this.height});

  /// The minimum label surface height and the icon surface diameter.
  final double height;
}
