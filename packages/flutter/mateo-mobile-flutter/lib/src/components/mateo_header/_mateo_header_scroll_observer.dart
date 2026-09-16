part of 'mateo_header.dart';

final class _MateoHeaderScrollObserver extends ChangeNotifier {
  ScrollController? _controller;
  ScrollNotificationObserverState? _notifications;
  ScrollPosition? _lastNotifyingPosition;

  void observe(ScrollController? controller, ScrollNotificationObserverState? notifications) {
    if (identical(_controller, controller) && identical(_notifications, notifications)) return;
    if (!identical(_controller, controller)) {
      _controller?.removeListener(notifyListeners);
      _controller = controller;
      _controller?.addListener(notifyListeners);
      _lastNotifyingPosition = null;
    }
    if (!identical(_notifications, notifications)) {
      _notifications?.removeListener(_handleNotification);
      _notifications = notifications;
      _notifications?.addListener(_handleNotification);
    }
    notifyListeners();
  }

  void _handleNotification(ScrollNotification notification) {
    final controller = _controller;
    if (controller == null) return;
    var source = notification.context?.findAncestorStateOfType<ScrollableState>();
    while (source != null && axisDirectionToAxis(source.axisDirection) != Axis.vertical) {
      source = source.context.findAncestorStateOfType<ScrollableState>();
    }
    if (source == null || !controller.positions.contains(source.position)) return;
    _lastNotifyingPosition = source.position;
    notifyListeners();
  }

  double resolveFadeExtent(double maximumExtent) {
    final controller = _controller;
    if (controller == null) return maximumExtent;
    final positions = controller.positions;
    ScrollPosition? scrollPosition;
    if (positions.length == 1) {
      scrollPosition = positions.first;
    } else if (positions.contains(_lastNotifyingPosition)) {
      scrollPosition = _lastNotifyingPosition;
    }
    if (scrollPosition == null || !scrollPosition.hasContentDimensions) return 0;
    if (!maximumExtent.isFinite || maximumExtent <= 0) return 0;
    final scrollableRange = scrollPosition.maxScrollExtent - scrollPosition.minScrollExtent;
    if (scrollableRange.isNaN || scrollableRange <= 0.5) return 0;
    final distance = axisDirectionIsReversed(scrollPosition.axisDirection)
        ? scrollPosition.extentAfter
        : scrollPosition.extentBefore;
    if (distance.isNaN || distance <= 0) return 0;
    if (distance.isInfinite) return maximumExtent;

    final progress = (distance / maximumExtent).clamp(0.0, 1.0);
    final remaining = 1 - progress;
    final remainingSquared = remaining * remaining;
    final remainingFourth = remainingSquared * remainingSquared;
    return maximumExtent * (1 - remainingFourth * remainingFourth);
  }

  @override
  void dispose() {
    _controller?.removeListener(notifyListeners);
    _notifications?.removeListener(_handleNotification);
    super.dispose();
  }
}
