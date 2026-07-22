part of 'mateo_bottom_sheet.dart';

class _MateoBottomSheetScrimDragSurface<T> extends StatefulWidget {
  const _MateoBottomSheetScrimDragSurface({
    required this.route,
    required this.child,
  });

  final _MateoBottomSheetRoute<T> route;
  final Widget child;

  @override
  State<_MateoBottomSheetScrimDragSurface<T>> createState() =>
      _MateoBottomSheetScrimDragSurfaceState<T>();
}

class _MateoBottomSheetScrimDragSurfaceState<T>
    extends State<_MateoBottomSheetScrimDragSurface<T>> {
  int? _activePointer;
  bool _isDragActive = false;
  double _accumulatedPointerX = 0;
  double _accumulatedPointerY = 0;
  double _closingProgress = 0;
  double _dragOriginPointerY = 0;
  double _sheetHeight = 0;
  VelocityTracker? _velocityTracker;

  bool _hasClearDownwardIntent() {
    final horizontalDistance = _accumulatedPointerX.abs();
    final verticalDistance = _accumulatedPointerY.abs();

    return verticalDistance >=
            _MateoBottomSheetRoute._directionMinIntentDistance &&
        verticalDistance > horizontalDistance &&
        _accumulatedPointerY > 0;
  }

  bool _startDrag(PointerMoveEvent event) {
    if (!_hasClearDownwardIntent()) return false;

    final sheetHeight = widget.route._sheetHeight;
    if (sheetHeight <= 0 || !widget.route.startInteractiveDismiss()) {
      return false;
    }

    _isDragActive = true;
    _sheetHeight = sheetHeight;
    _closingProgress = 1 - widget.route.transitionValue;
    _dragOriginPointerY = _accumulatedPointerY - event.delta.dy;
    return true;
  }

  void _updateDragProgress() {
    if (_sheetHeight <= 0) return;

    final rawClosingDistance = _accumulatedPointerY - _dragOriginPointerY;
    _closingProgress = (rawClosingDistance / _sheetHeight).clamp(0, 1);
    widget.route.updateInteractiveDismiss(closingProgress: _closingProgress);
  }

  bool _shouldCommitDrag(Velocity velocity) {
    if (velocity.isSwipeDown(
      minVelocity: _MateoBottomSheetRoute._dismissMinVelocity,
    )) {
      return true;
    }
    if (velocity.isSwipeUp(
      minVelocity: _MateoBottomSheetRoute._dismissMinVelocity,
    )) {
      return false;
    }
    return _closingProgress >= _MateoBottomSheetRoute._commitThreshold;
  }

  void _finishDrag({required Velocity velocity}) {
    if (!_isDragActive) {
      _resetGestureState();
      return;
    }

    final shouldCommit = _shouldCommitDrag(velocity);
    _resetGestureState();
    if (shouldCommit) {
      unawaited(widget.route.commitInteractiveDismiss());
      return;
    }

    unawaited(widget.route.cancelInteractiveDismiss());
  }

  void _cancelDrag() {
    final wasDragActive = _isDragActive;
    _resetGestureState();
    if (!wasDragActive) return;

    unawaited(widget.route.cancelInteractiveDismiss());
  }

  void _resetGestureState() {
    _isDragActive = false;
    _accumulatedPointerX = 0;
    _accumulatedPointerY = 0;
    _closingProgress = 0;
    _dragOriginPointerY = 0;
    _sheetHeight = 0;
    _velocityTracker = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_activePointer != null) return;

    _activePointer = event.pointer;
    _accumulatedPointerX = 0;
    _accumulatedPointerY = 0;
    _velocityTracker = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.position);
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_activePointer != event.pointer) return;

    _velocityTracker?.addPosition(event.timeStamp, event.position);
    _accumulatedPointerX += event.delta.dx;
    _accumulatedPointerY += event.delta.dy;
    if (!_isDragActive) {
      if (!_startDrag(event)) return;
    }

    _updateDragProgress();
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_activePointer != event.pointer) return;

    _velocityTracker?.addPosition(event.timeStamp, event.position);
    final velocity = _velocityTracker?.getVelocity() ?? Velocity.zero;
    _activePointer = null;
    _finishDrag(velocity: velocity);
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_activePointer != event.pointer) return;

    _activePointer = null;
    _cancelDrag();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      behavior: HitTestBehavior.deferToChild,
      child: widget.child,
    );
  }
}
