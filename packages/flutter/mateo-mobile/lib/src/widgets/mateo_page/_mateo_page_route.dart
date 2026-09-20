part of 'mateo_page.dart';

final class _MateoPageRoute<T> extends BaseMateoPageRoute<T> {
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
  Duration get transitionDuration =>
      reducedMotion ? .zero : transitionDurations?.forward ?? _builder.transitionDuration;
  @override
  Duration get reverseTransitionDuration =>
      reducedMotion ? .zero : transitionDurations?.reverse ?? _builder.reverseTransitionDuration;
  @override
  bool get popGestureEnabled => defaultTargetPlatform != .iOS && super.popGestureEnabled;
  @override
  DelegatedTransitionBuilder get delegatedTransition => _buildOutgoing;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return nextRoute is ModalRoute<dynamic> &&
        nextRoute.delegatedTransition != null &&
        super.canTransitionTo(nextRoute);
  }

  Widget? _buildOutgoing(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    bool allowSnapshotting,
    Widget? child,
  ) {
    if (!shouldAnimateSecondary) return child;
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
    final view = !shouldAnimateSecondary
        ? child
        : _builder.buildTransitions(
            this,
            context,
            shouldAnimatePrimary ? animation : kAlwaysCompleteAnimation,
            secondaryAnimation,
            child,
          );
    if (defaultTargetPlatform != .android) return view;
    return _MateoPredictiveBackGestureDetector(route: this, child: view);
  }
}
