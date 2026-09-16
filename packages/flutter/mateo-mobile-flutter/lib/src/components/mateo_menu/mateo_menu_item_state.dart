part of 'mateo_menu_button.dart';

/// Resolved colors and enabled state for one [MateoMenuItem].
@immutable
class MateoMenuItemState {
  /// Creates the resolved presentation state for one menu item.
  const MateoMenuItemState({
    required this.isEnabled,
    required this.iconColor,
    required this.titleColor,
    required this.descriptionColor,
  });

  /// Whether the item accepts activation.
  final bool isEnabled;

  /// Recommended color for custom item icons.
  final Color iconColor;

  /// Resolved item-title color.
  final Color titleColor;

  /// Resolved item-description color.
  final Color descriptionColor;
}

/// Builds an item icon from its resolved menu presentation state.
typedef MateoMenuItemLeadingIconBuilder = Widget Function(
  MateoMenuItemState state,
);

/// Handles selection of an enabled [MateoMenuItem].
///
/// The supplied future completes after the menu closes and its trigger is available again. Await it before navigation or another
/// disruptive operation, or ignore it when work should begin immediately.
typedef MateoMenuItemCallback = FutureOr<void> Function(
  Future<void> closeAnimation,
);
