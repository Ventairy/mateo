part of 'mateo_page.dart';

final class _MateoIosPageRoute<T> extends BaseMateoPageRoute<T> with CupertinoRouteTransitionMixin<T> {
  _MateoIosPageRoute({required super.page, required super.reducedMotion});

  @override
  Duration get transitionDuration => reducedMotion ? .zero : transitionDurations?.forward ?? super.transitionDuration;
  @override
  Duration get reverseTransitionDuration =>
      reducedMotion ? .zero : transitionDurations?.reverse ?? super.reverseTransitionDuration;
  @override
  DelegatedTransitionBuilder? get delegatedTransition =>
      fullscreenDialog ? null : CupertinoPageTransition.delegatedTransition;
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    updateMotion(context);
    if (!shouldAnimateSecondary) return child;
    return super.buildTransitions(
      context,
      shouldAnimatePrimary ? animation : const AlwaysStoppedAnimation<double>(1),
      secondaryAnimation,
      child,
    );
  }
}
