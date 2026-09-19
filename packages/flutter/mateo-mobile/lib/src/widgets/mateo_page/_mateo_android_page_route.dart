part of 'mateo_page.dart';

final class _MateoAndroidPageRoute<T> extends BaseMateoPageRoute<T> {
  _MateoAndroidPageRoute({
    required super.page,
    required super.reducedMotion,
    required Color backgroundColor,
  }) : _builder = PredictiveBackPageTransitionsBuilder(fallbackColor: backgroundColor),
       _primaryTransitionDisabledBuilder = FadeForwardsPageTransitionsBuilder(backgroundColor: backgroundColor);

  final PredictiveBackPageTransitionsBuilder _builder;
  final FadeForwardsPageTransitionsBuilder _primaryTransitionDisabledBuilder;

  @override
  Duration get transitionDuration => shouldAnimatePrimary ? _builder.transitionDuration : .zero;

  @override
  Duration get reverseTransitionDuration => shouldAnimatePrimary ? _builder.reverseTransitionDuration : .zero;

  @override
  DelegatedTransitionBuilder? get delegatedTransition => _builder.delegatedTransition;

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
    if (!shouldAnimateSecondary) return child;

    if (shouldAnimatePrimary) {
      return _builder.buildTransitions(this, context, animation, secondaryAnimation, child);
    }
    return _MateoPredictiveBackGestureDetector(
      route: this,
      child: _primaryTransitionDisabledBuilder.buildTransitions(
        this,
        context,
        const AlwaysStoppedAnimation<double>(1),
        secondaryAnimation,
        child,
      ),
    );
  }
}
