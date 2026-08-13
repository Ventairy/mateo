part of 'mateo_bottom_sheet.dart';

class _MateoBottomSheetRoute<T> extends PopupRoute<T> {
  _MateoBottomSheetRoute({
    required this.child,
    required this.capturedThemes,
    required this.barrierColor,
    required this.barrierLabel,
    required this.disableAnimations,
    required this.scrollable,
    required this.draggable,
    required this.resistance,
    required this.shouldDismiss,
  }) : _scrollableController = scrollable
           ? DraggableScrollableController()
           : null;

  static const double _directionMinIntentDistance = 10;
  static const double _dismissMinVelocity = 100;
  static const double _commitThreshold = 0.5;
  static const double _maximumHeightFraction = 0.85;
  static const double _initialScrollableHeightFraction = 1 / 3;
  static const double _extentTolerance = 0.001;

  final Widget child;
  final CapturedThemes capturedThemes;
  final bool disableAnimations;
  final bool scrollable;
  final bool draggable;
  final bool resistance;
  final MateoBottomSheetShouldDismiss? shouldDismiss;
  final DraggableScrollableController? _scrollableController;
  final GlobalKey _sheetMeasurementKey = GlobalKey(
    debugLabel: 'mateo_bottom_sheet_measurement',
  );
  bool _isInteractiveDismissActive = false;
  bool _isDismissDecisionActive = false;
  bool _hasNavigatorUserGesture = false;
  MateoBottomSheetDismissSource? _pendingDismissSource;

  double get transitionValue => controller?.value ?? 1;

  double get _initialScrollableExtent =>
      _initialScrollableHeightFraction / _maximumHeightFraction;

  bool get _canDismissFromCurrentSheetExtent {
    final scrollableController = _scrollableController;
    if (scrollableController == null) return true;
    if (!scrollableController.isAttached) return false;

    return scrollableController.size <=
        _initialScrollableExtent + _extentTolerance;
  }

  double get _sheetHeight {
    final renderObject = _sheetMeasurementKey.currentContext
        ?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return 0;

    return renderObject.size.height;
  }

  bool startInteractiveDismiss() {
    final routeController = controller;
    if (!isCurrent || routeController == null || _isInteractiveDismissActive) {
      return false;
    }
    if (routeController.status != AnimationStatus.completed) return false;

    _isInteractiveDismissActive = true;
    navigator?.didStartUserGesture();
    _hasNavigatorUserGesture = true;
    routeController.stop(canceled: false);
    return true;
  }

  void updateInteractiveDismiss({required double closingProgress}) {
    final routeController = controller;
    if (!_isInteractiveDismissActive ||
        routeController == null ||
        disableAnimations) {
      return;
    }

    routeController.value = 1 - closingProgress;
  }

  Future<void> cancelInteractiveDismiss() async {
    final routeController = controller;
    if (!_isInteractiveDismissActive || routeController == null) return;

    if (disableAnimations) {
      routeController.value = 1;
      _stopInteractiveDismiss();
      return;
    }

    final animation = routeController.animateTo(
      1,
      duration: reverseTransitionDuration,
      curve: Curves.easeOutCubic,
    );
    _stopUserGestureWhenAnimationEnds(routeController);
    await animation;
  }

  Future<void> commitInteractiveDismiss() async {
    final routeController = controller;
    final routeNavigator = navigator;
    if (!_isInteractiveDismissActive ||
        routeController == null ||
        routeNavigator == null) {
      return;
    }

    await requestDismiss(MateoBottomSheetDismissSource.drag);
    if (isCurrent) {
      await cancelInteractiveDismiss();
      return;
    }

    if (disableAnimations) {
      _stopInteractiveDismiss();
      return;
    }

    routeController.stop(canceled: false);
    final animation = routeController.animateBack(
      0,
      duration: reverseTransitionDuration,
      curve: Curves.easeOutCubic,
    );
    _stopUserGestureWhenAnimationEnds(routeController);
    await animation;
  }

  Future<bool> requestDismiss(MateoBottomSheetDismissSource source) async {
    if (!isCurrent || _isDismissDecisionActive) return false;

    _pendingDismissSource = source;
    try {
      return await navigator?.maybePop<T>() ?? false;
    } finally {
      _pendingDismissSource = null;
    }
  }

  @override
  Future<RoutePopDisposition> willPop() async {
    if (_isDismissDecisionActive) return RoutePopDisposition.doNotPop;

    final dismissSource =
        _pendingDismissSource ?? MateoBottomSheetDismissSource.systemBack;
    final dismissDecision = shouldDismiss;
    _isDismissDecisionActive = true;
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
      _isDismissDecisionActive = false;
    }
  }

  void _deferStopInteractiveDismiss() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => _stopInteractiveDismiss(),
    );
  }

  void _stopUserGestureWhenAnimationEnds(AnimationController routeController) {
    if (!routeController.isAnimating) {
      _deferStopInteractiveDismiss();
      return;
    }

    void listener(AnimationStatus status) {
      if (status.isAnimating) return;

      routeController.removeStatusListener(listener);
      _stopInteractiveDismiss();
    }

    routeController.addStatusListener(listener);
  }

  void _stopInteractiveDismiss() {
    if (!_isInteractiveDismissActive) return;

    _isInteractiveDismissActive = false;
    if (!_hasNavigatorUserGesture) return;

    _hasNavigatorUserGesture = false;
    navigator?.didStopUserGesture();
  }

  Widget buildSheetTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    if (disableAnimations) return child;

    return _MateoBottomSheetTransition(
      key: const Key('mateo_bottom_sheet_transition'),
      animation: animation,
      isInteractive: () => _isInteractiveDismissActive,
      child: child,
    );
  }

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  bool get barrierDismissible => true;

  @override
  Widget buildModalBarrier() {
    final color = animation!.drive(
      ColorTween(
        begin: barrierColor.withValues(alpha: 0),
        end: barrierColor,
      ).chain(CurveTween(curve: barrierCurve)),
    );

    return _MateoBottomSheetScrimDragSurface<T>(
      route: this,
      child: AnimatedModalBarrier(
        color: color,
        dismissible: barrierDismissible,
        semanticsLabel: barrierLabel,
        barrierSemanticsDismissible: semanticsDismissible,
        onDismiss: () => unawaited(
          requestDismiss(MateoBottomSheetDismissSource.tapOutside),
        ),
      ),
    );
  }

  @override
  Curve get barrierCurve => Curves.easeOutCubic;

  @override
  Duration get transitionDuration =>
      disableAnimations ? Duration.zero : const Duration(milliseconds: 270);

  @override
  Duration get reverseTransitionDuration =>
      disableAnimations ? Duration.zero : const Duration(milliseconds: 230);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final sheet = capturedThemes.wrap(
      _MateoBottomSheetSurface(route: this, animation: animation, child: child),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: sheet,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }

  @override
  void dispose() {
    _stopInteractiveDismiss();
    _scrollableController?.dispose();
    super.dispose();
  }
}
