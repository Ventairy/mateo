part of 'mateo_swipe_deck.dart';

/// Mutable visual state for the card stack during drag and animation.
@immutable
class _MateoSwipeDeckCardDragState {
  const _MateoSwipeDeckCardDragState({
    required this.offset,
    required this.action,
    required this.currentIndex,
  });

  final Offset offset;
  final MateoSwipeDeckAction action;
  final int currentIndex;

  @override
  bool operator ==(Object other) =>
      other is _MateoSwipeDeckCardDragState &&
      other.offset == offset &&
      other.action == action &&
      other.currentIndex == currentIndex;

  @override
  int get hashCode => Object.hash(offset, action, currentIndex);
}
