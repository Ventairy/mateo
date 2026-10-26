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
  MateoPageTransitionPush? _outgoingPush;

  void _updateBuilder() {
    if (page.transition == _builder.transition) return;
    _builder = MateoPageTransitionsBuilder(transition: page.transition!);
    // Validate even when reduced motion removes the route timing.
    _builder.transitionDuration;
  }

  @override
  void didChangeNext(Route<dynamic>? nextRoute) {
    // A departing route still drives secondaryAnimation during its reverse.
    // Keep its configuration until another route actually covers this one.
    if (nextRoute != null) _updateOutgoingPush(nextRoute);
    super.didChangeNext(nextRoute);
  }

  @override
  void didPopNext(Route<dynamic> nextRoute) {
    _updateOutgoingPush(nextRoute);
    super.didPopNext(nextRoute);
  }

  void _updateOutgoingPush(Route<dynamic> nextRoute) {
    _outgoingPush = switch (nextRoute) {
      _MateoPageRoute(_builder: MateoPageTransitionsBuilder(:final MateoPageTransitionPush transition)) => transition,
      _ => null,
    };
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
    // Custom Mateo sources already own a persistent outgoing host. Returning
    // their composed content avoids Flutter inserting/removing another host.
    if (ModalRoute.of(context) is _MateoPageRoute || !shouldAnimateSecondary) return child;
    return _builder.delegatedTransition(context, animation, secondaryAnimation, allowSnapshotting, child) ?? child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      Semantics(scopesRoute: true, explicitChildNodes: true, child: buildContent(context));

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    updateMotion(context);
    final incoming = _builder.transition.buildIncoming(
      animation: shouldAnimatePrimary ? animation : kAlwaysCompleteAnimation,
      allowSnapshotting: allowSnapshotting,
      child: child,
    );
    // Only push moves the departing page. Keep its host mounted even when
    // inactive so changing the covering transition never reparents content.
    final view = (_outgoingPush ?? const MateoPageTransitionPush()).buildOutgoing(
      animation: shouldAnimateSecondary && _outgoingPush != null ? this.secondaryAnimation! : kAlwaysDismissedAnimation,
      allowSnapshotting: shouldAnimateSecondary && _outgoingPush != null && allowSnapshotting && animation.isCompleted,
      child: incoming,
    );
    if (defaultTargetPlatform != .android) return view;
    return _MateoPredictiveBackGestureDetector(route: this, child: view);
  }
}
