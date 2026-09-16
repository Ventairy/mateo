part of '../../mateo_sheet.dart';

class _MateoBottomSheetScroll {
  static const int _flingCooldownUs = 120 * 1000;
  static const _scrollAtTopTolerance = 0.5;
  static const _scrollAwayThreshold = 5;
  static const _fastScrollDeltaThreshold = 15;

  double _scrollEdge(ScrollMetrics metrics) => metrics.minScrollExtent;
  double _scrollDistanceFromEdge(ScrollMetrics metrics) => metrics.pixels - _scrollEdge(metrics);
  bool _isAtScrollEdge(ScrollMetrics metrics) =>
      metrics.maxScrollExtent <= metrics.minScrollExtent + _scrollAtTopTolerance ||
      _scrollDistanceFromEdge(metrics) <= _scrollAtTopTolerance;

  ScrollMetrics? _metrics;
  BuildContext? _scrollContext;
  ScrollPosition? _position;
  ScrollHoldController? _hold;
  bool _creatingHold = false;
  bool _keepAtEdge = false;
  bool _pointerIsDown = false;
  bool _wasAwayFromEdge = false;
  double _peakScrollDelta = 0;
  int? _flingReachedEdgeAt;

  int get _now => SchedulerBinding.instance.currentSystemFrameTimeStamp.inMicroseconds;

  bool get canDismiss {
    final metrics = _metrics;
    if (metrics != null && !_isAtScrollEdge(metrics)) return false;

    final reachedEdgeAt = _flingReachedEdgeAt;
    return reachedEdgeAt == null || _now - reachedEdgeAt >= _flingCooldownUs;
  }

  void startPointer() {
    if (_scrollContext?.mounted == false) {
      release();
      _scrollContext = null;
      _metrics = null;
      _position = null;
      _wasAwayFromEdge = false;
      _flingReachedEdgeAt = null;
    }
    _pointerIsDown = true;
  }

  void endPointer() {
    _pointerIsDown = false;
    _flingReachedEdgeAt = null;
    release();
  }

  bool handleMetrics(ScrollMetricsNotification notification) {
    if (notification.metrics.axis == Axis.vertical) {
      _metrics = notification.metrics;
      _scrollContext = notification.context;
    }
    return false;
  }

  bool handleNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    _metrics = notification.metrics;
    final scrollContext = notification.context;
    if (scrollContext != null) {
      _scrollContext = scrollContext;
      _usePosition(Scrollable.of(scrollContext).position);
    }
    restore();
    if (notification is ScrollUpdateNotification) _trackMovement(notification);
    return false;
  }

  void _trackMovement(ScrollUpdateNotification notification) {
    if (_pointerIsDown && _flingReachedEdgeAt != null) _flingReachedEdgeAt = _now;

    if (_scrollDistanceFromEdge(notification.metrics) > _scrollAwayThreshold) {
      _wasAwayFromEdge = true;
      _flingReachedEdgeAt = null;
      _peakScrollDelta = 0;
      return;
    }
    if (!_wasAwayFromEdge) return;

    _peakScrollDelta = math.max(_peakScrollDelta, (notification.scrollDelta ?? 0).abs());
    if (_flingReachedEdgeAt != null || !_isAtScrollEdge(notification.metrics)) return;

    _wasAwayFromEdge = false;
    if (notification.dragDetails == null || _peakScrollDelta > _fastScrollDeltaThreshold) {
      _flingReachedEdgeAt = _now;
    }
    _peakScrollDelta = 0;
  }

  void hold() {
    _keepAtEdge = true;
    _holdPosition();
  }

  void restore() {
    final position = _position;
    if (!_keepAtEdge || position == null) return;
    if (_scrollDistanceFromEdge(position) >= 0) return;

    position.correctPixels(_scrollEdge(position));
  }

  void release() {
    _keepAtEdge = false;
    _releaseHold();
  }

  void _usePosition(ScrollPosition position) {
    if (identical(position, _position)) return;

    _releaseHold();
    _position = position;
    if (_keepAtEdge) _holdPosition();
  }

  void _holdPosition() {
    final position = _position;
    if (position == null || _hold != null || _creatingHold) return;

    _creatingHold = true;
    try {
      _hold = position.hold(() => _hold = null);
    } finally {
      _creatingHold = false;
    }
  }

  void _releaseHold() {
    final hold = _hold;
    _hold = null;
    hold?.cancel();
  }
}
