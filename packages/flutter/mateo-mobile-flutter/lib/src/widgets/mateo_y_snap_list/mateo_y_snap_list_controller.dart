part of 'mateo_y_snap_list.dart';

/// Controls a [MateoYSnapList] from parent code.
///
/// Call [dispose] when the controller itself is no longer needed.
class MateoYSnapListController {
  _MateoYSnapListControllerClient? _client;

  final List<void Function(MateoYSnapListNotification)> _notificationListeners =
      [];

  /// Whether this controller is attached to a [MateoYSnapList].
  bool get hasClients => _client != null;

  /// Advances to the next item.
  Future<bool> next() {
    return _client?.nextFromController() ?? Future<bool>.value(false);
  }

  /// Goes back to the previous item.
  Future<bool> previous() {
    return _client?.previousFromController() ?? Future<bool>.value(false);
  }

  /// Registers [listener] to receive [MateoYSnapListNotification] events from
  /// the attached list.
  ///
  /// Listeners are notified whenever the list commits to a discrete action
  /// (for example, advancing to the next item). The same listener can be
  /// added only once; duplicate registrations are ignored.
  ///
  /// Call [removeNotificationListener] when the listener should stop
  /// receiving events — typically in [State.dispose] of the owning widget.
  void addNotificationListener(
    void Function(MateoYSnapListNotification) listener,
  ) {
    if (!_notificationListeners.contains(listener)) {
      _notificationListeners.add(listener);
    }
  }

  /// Removes a previously registered [listener].
  ///
  /// Has no effect if [listener] was never added or already removed. Safe to
  /// call during a notification dispatch (the list is iterated over a copy).
  void removeNotificationListener(
    void Function(MateoYSnapListNotification) listener,
  ) {
    _notificationListeners.remove(listener);
  }

  /// Releases resources held by this controller.
  ///
  /// Clears all notification listeners and detaches from any attached list.
  /// Call this when the controller is no longer needed — typically in
  /// [State.dispose] of the owning widget or in a Riverpod
  /// `ref.onDispose` callback.
  ///
  /// Safe to call multiple times; subsequent calls are no-ops.
  void dispose() {
    _notificationListeners.clear();
    _client = null;
  }

  void _attach(_MateoYSnapListControllerClient client) {
    if (_client != null && !identical(_client, client)) {
      throw FlutterError(
        'A MateoYSnapListController can only be attached to one MateoYSnapList at a time.',
      );
    }

    _client = client;
  }

  void _detach(_MateoYSnapListControllerClient client) {
    if (identical(_client, client)) _client = null;
  }

  void _notify(MateoYSnapListNotification notification) {
    for (final listener in _notificationListeners.toList()) {
      listener(notification);
    }
  }
}

abstract interface class _MateoYSnapListControllerClient {
  Future<bool> nextFromController();
  Future<bool> previousFromController();
}
