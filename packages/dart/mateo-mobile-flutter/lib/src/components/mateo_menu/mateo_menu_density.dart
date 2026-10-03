/// Shared sizing and content padding for Mateo menu presentations.
enum MateoMenuDensity {
  /// Compact padding for contextual choices.
  compact(horizontalPadding: 18, verticalPadding: 16),

  /// Comfortable padding for everyday choices.
  standard(horizontalPadding: 26, verticalPadding: 22);

  const MateoMenuDensity({required this.horizontalPadding, required this.verticalPadding});

  /// The padding on either horizontal side of content.
  final double horizontalPadding;

  /// The menu inset above the first row and below the last row.
  ///
  /// This does not control spacing between rows.
  final double verticalPadding;

  /// The minimum space between the menu and either horizontal device edge.
  double get screenEdgeInset => 20;
}
