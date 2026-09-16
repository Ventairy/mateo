part of 'mateo_menu_button.dart';

@immutable
final class _MateoMenuSession {
  const _MateoMenuSession({
    required this.items,
    required this.triggerBounds,
    required this.morphTag,
    required this.textDirection,
    required this.animation,
    required this.disableAnimations,
    required this.onSelected,
    required this.onSourceReturned,
    required this.onDismiss,
    required this.isCurrent,
  });

  final List<MateoMenuItem> items;
  final ValueListenable<Rect> triggerBounds;
  final Object morphTag;
  final TextDirection textDirection;
  final Animation<double> animation;
  final bool disableAnimations;
  final ValueChanged<MateoMenuItem> onSelected;
  final VoidCallback onSourceReturned;
  final VoidCallback onDismiss;
  final bool Function() isCurrent;
}
