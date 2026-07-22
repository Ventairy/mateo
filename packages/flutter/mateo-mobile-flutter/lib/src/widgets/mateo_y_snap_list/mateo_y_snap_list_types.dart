part of 'mateo_y_snap_list.dart';

/// Called when a [MateoYSnapList] item completes a navigation action.
typedef MateoYSnapListItemCallback<T> = void Function(T item, int index);

/// Lazily provides the item at [index] for a [MateoYSnapList].
typedef MateoYSnapListItemProvider<T> = T Function(int index);

/// Builds a stable identity key for an item in a [MateoYSnapList].
typedef MateoYSnapListItemKeyBuilder<T> = Object Function(T item, int index);

/// Builds the widget for a [MateoYSnapList] item.
typedef MateoYSnapListItemBuilder<T> =
    Widget Function(BuildContext context, T item, int index);

/// Called as the [MateoYSnapList] swipe position changes.
typedef MateoYSnapListProgressCallback =
    void Function({
      required MateoYSnapListAction action,
      required double percentage,
    });

/// Called when [MateoYSnapList] needs more items.
typedef MateoYSnapListLoadMoreCallback = Future<void> Function();

/// Builds the load-more error card shown by [MateoYSnapList].
typedef MateoYSnapListLoadMoreErrorBuilder =
    Widget Function(BuildContext context, VoidCallback retry);

/// Item source used by [MateoYSnapList].
typedef MateoYSnapListItems<T> = ({
  int count,
  MateoYSnapListItemProvider<T> provider,
  MateoYSnapListItemKeyBuilder<T>? keyBuilder,
});
