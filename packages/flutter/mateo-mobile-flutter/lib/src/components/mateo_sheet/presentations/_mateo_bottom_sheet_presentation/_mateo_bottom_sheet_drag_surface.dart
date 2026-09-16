part of '../../mateo_sheet.dart';

class _MateoBottomSheetDragSurface<T> extends StatefulWidget {
  const _MateoBottomSheetDragSurface({
    required this.route,
    required this.presentation,
    required this.child,
  }) : _isScrim = false;

  const _MateoBottomSheetDragSurface.scrim({
    required this.route,
    required this.presentation,
    required this.child,
  }) : _isScrim = true;

  final _MateoSheetRoute<T> route;
  final _MateoBottomSheetPresentation presentation;
  final Widget child;
  final bool _isScrim;

  @override
  State<_MateoBottomSheetDragSurface<T>> createState() => _MateoBottomSheetDragSurfaceState<T>();
}

class _MateoBottomSheetDragSurfaceState<T> extends State<_MateoBottomSheetDragSurface<T>> {
  static const _directionMinIntentDistance = 10;
  static const double _dismissMinVelocity = 100;
  static const _commitThreshold = 0.5;

  double _dismissDistance(Offset movement) =>
      movement.dx * _MateoBottomSheetPresentation._exitDirection.dx +
      movement.dy * _MateoBottomSheetPresentation._exitDirection.dy;

  bool _hasDismissIntent(Offset movement) =>
      _dismissDistance(movement) >= _directionMinIntentDistance && movement.dy.abs() > movement.dx.abs();

  bool _shouldCommitDrag(Velocity velocity, double progress) {
    if (velocity.isSwipeDown(minVelocity: _dismissMinVelocity)) return true;
    if (velocity.isSwipeUp(minVelocity: _dismissMinVelocity)) return false;
    return progress >= _commitThreshold;
  }

  _MateoBottomSheetScroll? _scroll;
  int? _pointer;
  VelocityTracker? _velocity;
  Offset _pointerTravel = Offset.zero;
  double? _dragOrigin;
  double _dragExtent = 0;
  double _closingProgress = 0;
  bool _reducedMotion = false;

  @override
  void initState() {
    super.initState();
    if (!widget._isScrim) _scroll = _MateoBottomSheetScroll();
  }

  void _pointerDown(PointerDownEvent event) {
    if (_pointer != null || !widget.presentation.draggable) return;

    _pointer = event.pointer;
    _pointerTravel = Offset.zero;
    _reducedMotion = MediaQuery.disableAnimationsOf(context);
    _velocity = VelocityTracker.withKind(event.kind)..addPosition(event.timeStamp, event.position);
    _scroll?.startPointer();
  }

  void _pointerMove(PointerMoveEvent event) {
    if (_pointer != event.pointer) return;

    _velocity?.addPosition(event.timeStamp, event.position);
    _pointerTravel += event.delta;
    if (_dragOrigin == null && !_startDrag(event)) return;

    _closingProgress = ((_dismissDistance(_pointerTravel) - _dragOrigin!) / _dragExtent).clamp(0, 1);
    widget.route.updateInteractiveDismiss(closingProgress: _closingProgress);
    _scroll?.restore();
  }

  bool _startDrag(PointerMoveEvent event) {
    if (!_hasDismissIntent(_pointerTravel)) return false;
    if (!(_scroll?.canDismiss ?? true)) return false;

    _dragExtent = widget._isScrim ? widget.route._dragExtent : (context.size ?? Size.zero).height;
    if (_dragExtent <= 0 || !widget.route.startInteractiveDismiss()) return false;

    _dragOrigin = _dismissDistance(_pointerTravel - event.delta);
    if (!_reducedMotion) _scroll?.hold();
    return true;
  }

  void _pointerUp(PointerUpEvent event) {
    if (_pointer != event.pointer) return;

    _velocity?.addPosition(event.timeStamp, event.position);
    final wasDragging = _dragOrigin != null;
    final shouldCommit = _shouldCommitDrag(
      _velocity?.getVelocity() ?? Velocity.zero,
      _closingProgress,
    );
    _reset();
    if (!wasDragging) return;

    if (shouldCommit) {
      unawaited(widget.route.commitInteractiveDismiss());
    } else {
      unawaited(widget.route.cancelInteractiveDismiss());
    }
  }

  void _pointerCancel(PointerCancelEvent event) {
    if (_pointer != event.pointer) return;

    final wasDragging = _dragOrigin != null;
    _reset();
    if (wasDragging) unawaited(widget.route.cancelInteractiveDismiss());
  }

  void _reset() {
    _pointer = null;
    _velocity = null;
    _pointerTravel = Offset.zero;
    _dragOrigin = null;
    _dragExtent = 0;
    _closingProgress = 0;
    _scroll?.endPointer();
  }

  @override
  void dispose() {
    _scroll?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scroll = _scroll;
    final dragSurface = Listener(
      onPointerDown: _pointerDown,
      onPointerMove: _pointerMove,
      onPointerUp: _pointerUp,
      onPointerCancel: _pointerCancel,
      child: scroll == null
          ? widget.child
          : NotificationListener<ScrollMetricsNotification>(
              onNotification: scroll.handleMetrics,
              child: NotificationListener<ScrollNotification>(
                onNotification: scroll.handleNotification,
                child: widget.child,
              ),
            ),
    );

    if (widget._isScrim || !widget.presentation.resistance) return dragSurface;

    return MateoDragResistance(
      top: true,
      bottom: !widget.presentation.draggable,
      child: dragSurface,
    );
  }
}
