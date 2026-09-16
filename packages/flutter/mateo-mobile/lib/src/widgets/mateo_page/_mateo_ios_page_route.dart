part of 'mateo_page.dart';

final class _MateoIosPageRoute<T> extends _MateoPageRouteBase<T> with CupertinoRouteTransitionMixin<T> {
  _MateoIosPageRoute({required super.page, required super.reducedMotion});

  @override
  Duration get transitionDuration => reducedMotion ? .zero : super.transitionDuration;
  @override
  Duration get reverseTransitionDuration => reducedMotion ? .zero : super.reverseTransitionDuration;
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
    if (reducedMotion) return child;
    return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}
