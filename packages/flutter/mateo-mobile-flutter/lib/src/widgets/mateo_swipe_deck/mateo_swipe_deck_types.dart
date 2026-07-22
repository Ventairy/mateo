part of 'mateo_swipe_deck.dart';

/// Called when a [MateoSwipeDeck] item completes an action.
typedef MateoSwipeDeckItemCallback<T> = void Function(T item, int index);

/// Lazily provides the item at [index] for a [MateoSwipeDeck].
typedef MateoSwipeDeckItemProvider<T> = T Function(int index);

/// Builds the widget for a [MateoSwipeDeck] item.
typedef MateoSwipeDeckItemBuilder<T> =
    Widget Function(BuildContext context, T item, int index);

/// Called as the [MateoSwipeDeck] swipe position changes.
typedef MateoSwipeDeckProgressCallback =
    void Function({
      required MateoSwipeDeckAction action,
      required double percentage,
    });

/// Called when [MateoSwipeDeck] needs more items.
typedef MateoSwipeDeckLoadMoreCallback = Future<void> Function();

/// Builds the load-more error card shown by [MateoSwipeDeck].
typedef MateoSwipeDeckLoadMoreErrorBuilder =
    Widget Function(BuildContext context, VoidCallback retry);
