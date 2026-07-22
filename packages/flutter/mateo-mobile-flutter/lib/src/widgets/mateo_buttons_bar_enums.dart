part of 'mateo_buttons_bar.dart';

/// Direction used by [MateoButtonsBar] to arrange its items.
///
/// The enum exists even while only one direction is supported so the public API
/// can grow without changing the constructor shape.
enum MateoButtonsBarOrientation {
  /// Places button widgets horizontally in a single row.
  row,
}

/// Width sizing behavior used by [MateoButtonsBar].
///
/// This enum controls width only. Height is either the natural padded item
/// height or a height supplied through `MateoButtonsBar.constraints`.
enum MateoButtonsBarFit {
  /// Sizes the bar to the width of its padded items.
  fitItems,

  /// Expands the bar to the finite available maximum width.
  ///
  /// The maximum can come from the parent layout or from
  /// `MateoButtonsBar.constraints`. If no finite maximum width is available,
  /// `MateoButtonsBar` throws a [FlutterError].
  expand,
}
