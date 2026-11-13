part of 'mateo_icon_background.dart';

/// A circular icon background displaying a custom widget.
final class MateoIconBackgroundCustom extends MateoIconBackground {
  /// Creates a background displaying the supplied [child].
  const new({required this.child}) : super._();

  /// The custom widget displayed behind the icon artwork.
  final Widget child;
}
