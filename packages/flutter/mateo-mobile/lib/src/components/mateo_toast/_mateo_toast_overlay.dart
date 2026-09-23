part of 'mateo_toast.dart';

class _MateoToastOverlay extends StatefulWidget {
  const _MateoToastOverlay({
    required this.toast,
    required this.duration,
    required this.dismissible,
    required this.padding,
    required this.onDismissed,
    super.key,
  });

  final MateoToast toast;
  final MateoToastDuration duration;
  final bool dismissible;
  final EdgeInsetsGeometry padding;
  final VoidCallback onDismissed;

  @override
  State<_MateoToastOverlay> createState() => _MateoToastOverlayState();
}

class _MateoToastOverlayState extends State<_MateoToastOverlay> with TickerProviderStateMixin, WidgetsBindingObserver {
  static const _appearDuration = Duration(milliseconds: 200);
  static const _dismissDuration = Duration(milliseconds: 200);
  static const _pressDuration = Duration(milliseconds: 300);
  static const _dragDismissOffset = 10.0;
  static const _dragDampingDistance = 72.0;
  static const _swipeDismissMinVelocity = 350.0;

  static const _swipeReleaseTolerance = Duration(milliseconds: 150);
  static const _slideFraction = 0.22;

  late final _visibility = AnimationController(vsync: this, duration: _appearDuration);
  final _dragInput = ValueNotifier<Offset?>(null);
  late final _press = AnimationController(vsync: this, duration: _pressDuration);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, -_slideFraction),
    end: .zero,
  ).animate(_visibility);
  late final Animation<double> _scale = Tween<double>(
    begin: 1,
    end: 0.985,
  ).animate(CurveTween(curve: Curves.easeOutCubic).animate(_press));
  Timer? _timer;
  VelocityTracker? _velocity;
  Duration? _lastPointerTime;
  Offset _lastMovementVelocity = .zero;
  int? _pointer;
  Offset? _pointerOrigin;
  double _dragOffsetY = 0;
  bool _dragged = false;
  bool _dismissing = false;
  bool _pendingTimeout = false;
  bool _paused = false;
  bool _reducedMotion = false;
  bool _started = false;

  Duration get _automaticReadingDuration {
    final characters = widget.toast.message.trim().length;
    return Duration(milliseconds: (characters / 14 * 1000).round().clamp(2500, 8000));
  }

  Duration? get _timeoutDuration => switch (widget.duration) {
    MateoToastDurationAuto() => _automaticReadingDuration,
    MateoToastDurationCustom(:final duration) => duration,
    MateoToastDurationUntilDismissed() => null,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (_started) return;
    _started = true;
    _restore();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = null;
    if (_timeoutDuration case final duration?) _timer = Timer(duration, _dismiss);
  }

  Future<void> _animateVisibility(double target) async {
    try {
      final duration = target == 0 ? _dismissDuration : _appearDuration;
      await _visibility
          .animateTo(
            target,
            duration: duration,
            curve: const _MateoToastCurve(),
          )
          .orCancel;
      if (mounted && _dismissing && !_paused) widget.onDismissed();
    } on TickerCanceled {
      // Replacement, another transition, or disposal owns the next frame.
    }
  }

  void _restore() {
    _dragOffsetY = 0;
    if (_paused) return;
    if (_reducedMotion) {
      _visibility.value = 1;
      return;
    }
    unawaited(_animateVisibility(1));
  }

  void dismiss() {
    if (_dismissing) return;
    _clearPointer();
    _pendingTimeout = false;
    _dismiss();
  }

  void _dismiss() {
    if (_dismissing) return;
    if (_pointer != null) {
      _pendingTimeout = true;
      return;
    }
    _dismissing = true;
    _timer?.cancel();
    if (_paused) return;
    if (_reducedMotion || _visibility.value <= 0) {
      widget.onDismissed();
      return;
    }
    unawaited(_animateVisibility(0));
  }

  void _setPressed(bool pressed) {
    if (_reducedMotion) return;
    if (pressed) {
      _press.forward();
    } else {
      _press.reverse();
    }
  }

  void _pointerDown(PointerDownEvent event) {
    if (!mounted || _pointer != null || _dismissing || _paused) return;
    _pointer = event.pointer;
    _pointerOrigin = event.position;
    _dragged = false;
    _dragOffsetY = -_dragDampingDistance * (1 / _visibility.value.clamp(1e-6, 1.0) - 1);
    _dragInput.value = Offset(0, _dragOffsetY);
    _velocity = VelocityTracker.withKind(event.kind)..addPosition(event.timeStamp, event.position);
    _lastPointerTime = event.timeStamp;
    _lastMovementVelocity = .zero;
    _visibility.stop();
    _setPressed(true);
  }

  void _pointerMove(PointerMoveEvent event) {
    if (!mounted || event.pointer != _pointer || _dismissing) return;
    _velocity?.addPosition(event.timeStamp, event.position);
    final elapsed = event.timeStamp - _lastPointerTime!;
    final estimatedVelocity = _velocity?.getVelocity().pixelsPerSecond ?? Offset.zero;
    _lastMovementVelocity = estimatedVelocity != Offset.zero
        ? estimatedVelocity
        : elapsed.inMicroseconds > 0
        ? event.delta * (Duration.microsecondsPerSecond / elapsed.inMicroseconds)
        : Offset.zero;
    if (event.delta.dy > 0) _lastMovementVelocity = .zero;
    _lastPointerTime = event.timeStamp;
    _dragged = _dragged || (event.position - _pointerOrigin!).distance > kTouchSlop;
    _dragOffsetY += event.delta.dy;
    _dragInput.value = (_dragInput.value ?? Offset.zero) + event.delta;
    if (!widget.dismissible || _reducedMotion) return;
    final upwardDistance = math.max(0, -_dragOffsetY);
    _visibility.value = 1 / (1 + upwardDistance / _dragDampingDistance);
  }

  void _clearPointer() {
    _pointer = null;
    _dragInput.value = null;
    _pointerOrigin = null;
    _velocity = null;
    _lastPointerTime = null;
    _lastMovementVelocity = .zero;
    _dragged = false;
    _setPressed(false);
  }

  void _pointerUp(PointerUpEvent event) {
    if (!mounted || event.pointer != _pointer) return;
    // A stationary pointer-up must not erase the flick just before it.
    final velocity = event.timeStamp - _lastPointerTime! <= _swipeReleaseTolerance
        ? _lastMovementVelocity
        : Offset.zero;
    final tapped = !_dragged;
    final upwardTravel = _pointerOrigin!.dy - event.position.dy;
    final swipeUp =
        upwardTravel >= kTouchSlop && velocity.dy <= -_swipeDismissMinVelocity && velocity.dy.abs() > velocity.dx.abs();
    final draggedToDismiss = upwardTravel >= _dragDismissOffset;
    _clearPointer();
    if (_pendingTimeout || (widget.dismissible && !tapped && (swipeUp || draggedToDismiss))) {
      _pendingTimeout = false;
      _dismiss();
      return;
    }
    if (tapped && (widget.dismissible || widget.toast.onPressed != null)) {
      scheduleMicrotask(() {
        if (mounted && !_dismissing) _restore();
      });
      return;
    }
    _restore();
  }

  void _pointerCancel(PointerCancelEvent event) {
    if (!mounted || event.pointer != _pointer) return;
    _clearPointer();
    if (_pendingTimeout) {
      _pendingTimeout = false;
      _dismiss();
      return;
    }
    _restore();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _paused = true;
      _timer?.cancel();
      _visibility.stop();
      _press.stop();
      _clearPointer();
      _press.value = 0;
      return;
    }
    if (state != AppLifecycleState.resumed || !_paused) return;
    _paused = false;
    if (_dismissing) {
      if (_reducedMotion) {
        widget.onDismissed();
      } else {
        unawaited(_animateVisibility(0));
      }
      return;
    }
    if (_pendingTimeout) {
      _pendingTimeout = false;
      _dismiss();
      return;
    }
    _restore();
    _startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _dragInput.dispose();
    _visibility.dispose();
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: AnimatedBuilder(
      animation: _visibility,
      builder: (context, child) => FadeTransition(
        opacity: AlwaysStoppedAnimation(_visibility.value.clamp(0.0, 1.0)),
        child: child,
      ),
      child: SlideTransition(
        position: _slide,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: widget.padding,
            child: Align(
              alignment: .topCenter,
              child: ValueListenableBuilder<Offset?>(
                valueListenable: _dragInput,
                builder: (context, dragOffset, child) => MateoDragResistance.driven(
                  resistance: .only(top: widget.dismissible ? 0 : 6, bottom: 6, left: 6, right: 6),
                  dragOffset: dragOffset,
                  child: child!,
                ),
                child: ScaleTransition(
                  scale: _reducedMotion ? const AlwaysStoppedAnimation<double>(1) : _scale,
                  alignment: .topLeft,
                  child: Listener(
                    behavior: .opaque,
                    onPointerDown: _pointerDown,
                    onPointerMove: _pointerMove,
                    onPointerUp: _pointerUp,
                    onPointerCancel: _pointerCancel,
                    child: _MateoToastHostScope(
                      dismissOnPress: widget.dismissible,
                      child: widget.toast,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
