part of 'mateo_menu_button.dart';

/// An item displayed inside a [MateoMenuButton] menu.
///
/// [title] is always visible. [description] adds supporting text beneath it,
/// and [leadingIconBuilder] adds a consumer-sized visual before the text. When
/// [onPressed] is null, the complete row is shown disabled and ignores input.
@immutable
class MateoMenuItem {
  /// Creates an item for a Mateo menu button.
  const MateoMenuItem({
    required this.title,
    this.leadingIconBuilder,
    this.description,
    this.onPressed,
  }) : assert(
         title != '',
         'MateoMenuItem requires a non-empty title.',
       ),
       assert(
         description == null || description != '',
         'MateoMenuItem description must be null or non-empty.',
       );

  /// Non-empty visible title and accessibility label for this item.
  final String title;

  /// Optional builder for the complete leading icon visual.
  ///
  /// The supplied [MateoMenuItemState] contains the resolved item colors
  /// and enabled state. The returned widget controls its own size.
  final MateoMenuItemLeadingIconBuilder? leadingIconBuilder;

  /// Optional non-empty supporting text shown beneath [title].
  final String? description;

  /// Handles selection after the menu starts closing.
  ///
  /// When null, this item is disabled. The callback receives a future that
  /// completes after the menu closes and focus is restored.
  final MateoMenuItemCallback? onPressed;
}
