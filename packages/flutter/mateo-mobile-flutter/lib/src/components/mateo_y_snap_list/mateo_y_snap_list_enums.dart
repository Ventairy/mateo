part of 'mateo_y_snap_list.dart';

/// Directional list action emitted by [MateoYSnapList].
enum MateoYSnapListAction {
  /// Down swipe that goes to the previous item.
  previous,

  /// Up swipe that advances to the next item.
  next,
}

/// Discrete list events that [MateoYSnapListController] can broadcast to
/// notification listeners.
///
/// Register a listener via [MateoYSnapListController.addNotificationListener]
/// to react to list actions from any trigger source (swipe gesture,
/// controller method, pagination auto-advance, etc.).
enum MateoYSnapListNotification {
  /// The list committed to advancing to the next item.
  ///
  /// Fired once per successful next-item commit, whether triggered by a
  /// swipe, [MateoYSnapListController.next], or automatic navigation after a
  /// load-more completes from await mode. Does not fire when the commit is
  /// canceled, snapped back, or the list is already at the terminal page.
  nextItem,
}

enum _MateoYSnapListAwaitPhase { inactive, deciding, dragging, waiting }
