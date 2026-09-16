part of 'mateo_page.dart';

final class _MateoAndroidPageRoute<T> extends _MateoPageRouteBase<T> {
  _MateoAndroidPageRoute({
    required super.page,
    required super.reducedMotion,
    required Color backgroundColor,
  }) : _builder = PredictiveBackPageTransitionsBuilder(fallbackColor: backgroundColor);

  final PredictiveBackPageTransitionsBuilder _builder;

  @override
  Duration get transitionDuration => reducedMotion ? .zero : _builder.transitionDuration;

  @override
  Duration get reverseTransitionDuration => reducedMotion ? .zero : _builder.reverseTransitionDuration;

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
    if (reducedMotion) return child;
    return _builder.buildTransitions(this, context, animation, secondaryAnimation, child);
  }
}
