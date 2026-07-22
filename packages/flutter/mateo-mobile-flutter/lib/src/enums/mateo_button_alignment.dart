/// Controls the horizontal alignment of Mateo Mobile button foreground content (label
/// and icons).
///
/// Only has a visible effect when the button uses `fit = expand`, since a
/// shrink-wrapped button is exactly as wide as its content.
enum MateoButtonAlignment {
  /// Aligns content to the left edge of the button.
  left,

  /// Centers content horizontally within the button.
  center,

  /// Aligns content to the right edge of the button.
  right,
}
