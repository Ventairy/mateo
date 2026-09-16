part of 'mateo_sheet.dart';

class _MateoSheetRoute<T> extends PopupRoute<T> {
  _MateoSheetRoute({
    required this.child,
    required this.capturedThemes,
    required this.barrierColor,
    required this.barrierLabel,
    required this.disableAnimations,
    required this.presentation,
    required this.shouldDismiss,
  });

  final Widget child;
  final CapturedThemes capturedThemes;
  final bool disableAnimations;
  final MateoSheetPresentation presentation;
  final MateoSheetShouldDismiss? shouldDismiss;
  final GlobalKey _sheetMeasurementKey = GlobalKey(
    debugLabel: 'mateo_sheet_measurement',
  );
  bool _dragging = false;
  bool _checkingDismissal = false;
  MateoSheetDismissSource? _dismissSource;
  late _MateoSheetStack _stack;
  bool _joinedStack = false;
  bool _openedContextually = false;
  bool _leavingStack = false;
  bool _returning = false;
  _MateoSheetRoute<Object?>? _previousSheet;
  AnimationController? _surfaceMotion;

  @override
  void didChangePrevious(Route<dynamic>? previousRoute) {
    super.didChangePrevious(previousRoute);
    final previousSheet = previousRoute is _MateoSheetRoute<Object?> ? previousRoute : null;
    if (_joinedStack && !identical(_previousSheet, previousSheet)) _stack.revision++;
    _previousSheet = previousSheet;
    if (!_joinedStack) {
      _stack = _previousSheet?._stack ?? _MateoSheetStack();
      _openedContextually = _previousSheet != null;
      _stack.add(this);
      _joinedStack = true;
      if (_openedContextually && !disableAnimations) {
        controller!.duration = presentation._morphDuration;
        // Route adjacency arrives after didPush starts the entrance clock.
        // Restart it before the first frame using the contextual duration.
        controller!.forward();
      }
    }
    controller?.reverseDuration = reverseTransitionDuration;
  }

  AnimationController get _dragController => _openedContextually ? _ensureSurfaceMotion() : controller!;

  AnimationController _ensureSurfaceMotion() => _surfaceMotion ??= AnimationController(
    vsync: navigator!,
    value: 1,
    duration: disableAnimations ? Duration.zero : presentation._entranceDuration,
    reverseDuration: disableAnimations ? Duration.zero : presentation._dismissDuration,
  );

  double get _dragExtent {
    final renderObject = _sheetMeasurementKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return 0;

    return renderObject.size.height;
  }

  bool startInteractiveDismiss() {
    final routeController = controller;
    if (!isCurrent || routeController == null || _dragging || _stack.isDeciding || _leavingStack || _returning) {
      return false;
    }
    if (routeController.status != AnimationStatus.completed) return false;

    _dragging = true;
    _dragController.stop(canceled: false);
    if (_openedContextually) _stack.updateDismissalAnimation(_dragController);
    return true;
  }

  void updateInteractiveDismiss({required double closingProgress}) {
    final routeController = _dragController;
    if (!_dragging || disableAnimations) {
      return;
    }

    routeController.value = 1 - closingProgress;
  }

  Future<void> cancelInteractiveDismiss() async {
    if (_dragging) await _settleDrag(1);
  }

  Future<void> _settleDrag(double target) async {
    try {
      if (disableAnimations) {
        _dragController.value = target;
      } else if (target == 1) {
        await _dragController
            .animateTo(1, duration: presentation._dismissDuration, curve: presentation._settleCurve)
            .orCancel;
      } else {
        await _dragController
            .animateBack(0, duration: presentation._dismissDuration, curve: presentation._settleCurve)
            .orCancel;
      }
    } on TickerCanceled {
      // Navigation can dispose the route while a drag is settling.
    } finally {
      _stopInteractiveDismiss();
    }
  }

  Future<void> commitInteractiveDismiss() async {
    final routeController = controller;
    final routeNavigator = navigator;
    if (!_dragging || routeController == null || routeNavigator == null) {
      return;
    }

    if (_openedContextually) {
      try {
        await _stack.dismissFrom(this, MateoSheetDismissSource.drag);
      } finally {
        if (_dragging && isActive && navigator != null) {
          if (isCurrent) {
            await cancelInteractiveDismiss();
          } else {
            _surfaceMotion!.value = 1;
            _stopInteractiveDismiss();
          }
        }
      }
      return;
    }

    await requestDismiss(MateoSheetDismissSource.drag);
    if (isCurrent) {
      await cancelInteractiveDismiss();
      return;
    }

    await _settleDrag(0);
  }

  Future<bool> requestDismiss(MateoSheetDismissSource source) async {
    if (!isCurrent || _checkingDismissal || _stack.isDeciding || _leavingStack) return false;

    if (_previousSheet != null && (source.isTapOutside || source.isDrag)) {
      return _stack.dismissFrom(this, source);
    }

    _dismissSource = source;
    try {
      return await navigator?.maybePop<T>() ?? false;
    } finally {
      _dismissSource = null;
    }
  }

  Future<void> _leaveStack() async {
    _leavingStack = true;
    _stack.updateDismissalAnimation(_ensureSurfaceMotion());
    if (!disableAnimations) {
      await _surfaceMotion!
          .animateBack(
            0,
            duration: presentation._dismissDuration,
            curve: presentation._stackExitCurve(_dragging),
          )
          .orCancel;
    }
  }

  void _cancelStackExit() {
    _leavingStack = false;
    if (navigator == null) return;
    _surfaceMotion!.value = 1;
    _stack.updateDismissalAnimation(null);
  }

  void _prepareDragReturn() {
    _returning = true;
    _ensureSurfaceMotion().value = 0;
    _stack.updateDismissalAnimation(_surfaceMotion);
  }

  Future<void> _returnAfterDrag() async {
    try {
      await SchedulerBinding.instance.endOfFrame;
      await SchedulerBinding.instance.endOfFrame;
      if (!isCurrent || navigator == null) return;
      if (disableAnimations) {
        _surfaceMotion!.value = 1;
      } else {
        await _surfaceMotion!
            .animateTo(1, duration: presentation._entranceDuration, curve: presentation._stackReturnCurve)
            .orCancel;
      }
    } on TickerCanceled {
      return;
    } finally {
      if (navigator != null) {
        _surfaceMotion!.value = 1;
        _returning = false;
        if (identical(_stack.dismissalAnimation, _surfaceMotion)) _stack.updateDismissalAnimation(null);
      }
    }
  }

  @override
  Future<RoutePopDisposition> willPop() async {
    if (_stack.isDeciding || _leavingStack) return RoutePopDisposition.doNotPop;

    return _dismissDisposition(_dismissSource ?? MateoSheetDismissSource.systemBack);
  }

  Future<RoutePopDisposition> _dismissDisposition(MateoSheetDismissSource dismissSource) async {
    if (_checkingDismissal) return RoutePopDisposition.doNotPop;
    final dismissDecision = shouldDismiss;
    _checkingDismissal = true;
    try {
      if (dismissDecision != null) {
        if (!await dismissDecision(dismissSource)) {
          return RoutePopDisposition.doNotPop;
        }
      }

      // Navigator.maybePop still uses this asynchronous hook before the
      // synchronous popDisposition API, so it is required for an async gate.
      // ignore: deprecated_member_use
      return await super.willPop();
    } finally {
      _checkingDismissal = false;
    }
  }

  void _stopInteractiveDismiss() {
    if (!_dragging) return;

    _dragging = false;
    if (_openedContextually && !_leavingStack && navigator != null) _stack.updateDismissalAnimation(null);
  }

  Animation<double> get _surfaceAnimation {
    if (_leavingStack || _returning || (_openedContextually && _dragging)) return _ensureSurfaceMotion();
    if (_previousSheet != null) return const AlwaysStoppedAnimation(1);
    return animation!;
  }

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  bool get barrierDismissible => true;

  @override
  Widget buildModalBarrier() {
    return AnimatedBuilder(
      animation: _stack,
      builder: (context, _) => presentation._buildModalBarrier(this),
    );
  }

  @override
  Curve get barrierCurve => presentation._barrierCurve;

  @override
  Duration get transitionDuration => disableAnimations
      ? Duration.zero
      : _openedContextually
      ? presentation._morphDuration
      : presentation._entranceDuration;

  @override
  Duration get reverseTransitionDuration => disableAnimations
      ? Duration.zero
      : _previousSheet != null
      ? presentation._morphDuration
      : presentation._dismissDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => capturedThemes.wrap(presentation._build(this));

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final current = ModalRoute.isCurrentOf(context) ?? isCurrent;
    return ExcludeFocus(
      excluding: !current,
      child: ExcludeSemantics(
        excluding: !current,
        child: IgnorePointer(ignoring: !current, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _dragging = false;
    _surfaceMotion?.dispose();
    if (_joinedStack) _stack.remove(this);
    super.dispose();
  }
}
