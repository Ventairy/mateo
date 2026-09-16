part of 'mateo_page.dart';

final class _MateoPageRoute<T> extends _MateoPageRouteBase<T> {
  _MateoPageRoute({
    required super.page,
    required super.reducedMotion,
  }) : _builder = MateoPageTransitionsBuilder(transition: page.transition!) {
    // Validate even when reduced motion removes the route timing.
    _builder.transitionDuration;
  }

  MateoPageTransitionsBuilder _builder;

  void _updateBuilder() {
    if (page.transition == _builder.transition) return;
    _builder = MateoPageTransitionsBuilder(transition: page.transition!);
    // Validate even when reduced motion removes the route timing.
    _builder.transitionDuration;
  }

  @override
  void changedInternalState() {
    _updateBuilder();
    super.changedInternalState();
  }

  @override
  Duration get transitionDuration => reducedMotion ? .zero : _builder.transitionDuration;
  @override
  Duration get reverseTransitionDuration => reducedMotion ? .zero : _builder.reverseTransitionDuration;
  @override
  bool get popGestureEnabled => defaultTargetPlatform != .iOS && super.popGestureEnabled;
  @override
  DelegatedTransitionBuilder get delegatedTransition => _buildOutgoing;

  Widget? _buildOutgoing(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    bool allowSnapshotting,
    Widget? child,
  ) {
    if (reducedMotion) return child;
    return _builder.delegatedTransition(context, animation, secondaryAnimation, allowSnapshotting, child) ?? child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      Semantics(scopesRoute: true, explicitChildNodes: true, child: page.child);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    updateMotion(context);
    final view = reducedMotion ? child : _builder.buildTransitions(this, context, animation, secondaryAnimation, child);
    if (defaultTargetPlatform != .android) return view;
    return _MateoPredictiveBackGestureDetector(route: this, child: view);
  }

  NavigatorState? _gestureNavigator;
  AnimationStatusListener? _gestureStatusListener;

  @override
  void handleStartBackGesture({double progress = 0}) {
    _gestureNavigator = navigator;
    super.handleStartBackGesture(progress: progress);
  }

  @override
  void handleCancelBackGesture() {
    if (isCurrent) controller?.forward();
    _settleGesture();
  }

  @override
  void handleCommitBackGesture() {
    // Navigator.pop reverses from the current controller value. The framework's
    // default predictive handler subsequently resets it to one, which would jump.
    if (isCurrent) navigator?.pop();
    _settleGesture();
  }

  void _settleGesture() {
    if (!(controller?.isAnimating ?? false)) {
      _stopGesture();
      return;
    }
    final previousListener = _gestureStatusListener;
    if (previousListener != null) controller?.removeStatusListener(previousListener);
    _gestureStatusListener = (status) {
      if (!status.isAnimating) _stopGesture();
    };
    controller?.addStatusListener(_gestureStatusListener!);
  }

  void _stopGesture() {
    final listener = _gestureStatusListener;
    if (listener != null) controller?.removeStatusListener(listener);
    _gestureStatusListener = null;
    final owner = _gestureNavigator;
    _gestureNavigator = null;
    if (owner != null && owner.mounted && owner.userGestureInProgress) owner.didStopUserGesture();
  }

  @override
  void dispose() {
    _stopGesture();
    super.dispose();
  }
}
