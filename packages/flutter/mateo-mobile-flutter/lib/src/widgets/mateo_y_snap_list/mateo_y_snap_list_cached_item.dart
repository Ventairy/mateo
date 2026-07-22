part of 'mateo_y_snap_list.dart';

@immutable
class _MateoYSnapListCachedItem<T> {
  const _MateoYSnapListCachedItem({
    required this.item,
    required this.itemKey,
    required this.index,
    required this.child,
  });

  final T item;
  final Object itemKey;
  final int index;
  final Widget child;
}
