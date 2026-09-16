part of 'show_mateo_menu.dart';

class _MateoMenuRoute extends PopupRoute<MateoMenuOptionsPresentationItem> {
  _MateoMenuRoute({
    required this.menu,
    required this.surfaceAnimation,
    required this.placement,
    required this.reducedMotion,
    required this.theme,
    required this.textStyle,
    required this.direction,
    required this.anchorBounds,
    this.exitTransition,
  }) : super(requestFocus: true);

  final MateoMenu menu;
  final MateoSurfaceAnimation surfaceAnimation;
  final MateoMenuPlacement placement;
  final MateoMenuExitTransition? exitTransition;
  final bool reducedMotion;
  final MateoThemeData theme;
  final TextStyle textStyle;
  final TextDirection direction;
  final Rect anchorBounds;
  bool _selected = false;
  bool _isExiting = false;

  @override
  Duration get transitionDuration => reducedMotion
      ? Duration.zero
      : switch (surfaceAnimation) {
          MateoSurfaceAnimationTransform(:final duration) => duration,
          MateoSurfaceAnimationNone() || MateoSurfaceAnimationPop() => Duration.zero,
        };

  @override
  Duration get reverseTransitionDuration {
    return reducedMotion ? Duration.zero : exitTransition?.duration ?? transitionDuration;
  }

  @override
  bool didPop(MateoMenuOptionsPresentationItem? result) {
    final accepted = super.didPop(result);
    if (accepted) _isExiting = true;
    return accepted;
  }

  Widget _buildExitTransition(Animation<double> animation, Widget child) {
    final transition = exitTransition;
    if (reducedMotion || transition == null) return child;
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return transition.builder(context, _isExiting ? animation : kAlwaysCompleteAnimation, child!);
      },
    );
  }

  @override
  Color? get barrierColor => null;
  @override
  bool get barrierDismissible => true;
  @override
  String? get barrierLabel => null;

  FutureOr<void> _select(MateoMenuOptionsPresentationItem item) {
    if (_selected || !isCurrent) return Future<void>.value();
    _selected = true;
    navigator!.pop(item);
    return menu.onItemPressed!(item);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      Directionality(
        textDirection: direction,
        child: MateoTheme(
          data: theme,
          child: DefaultTextStyle(
            style: textStyle,
            child: CallbackShortcuts(
              bindings: {const SingleActivator(LogicalKeyboardKey.escape): () => navigator?.maybePop()},
              child: Focus(
                autofocus: true,
                child: _MateoMenuOverlay(
                  route: this,
                  child: _buildExitTransition(
                    animation,
                    MateoSurfaceScope(
                      animation: surfaceAnimation,
                      child: MateoMenu(
                        key: menu.key,
                        presentation: menu.presentation,
                        onItemPressed: menu.onItemPressed == null ? null : _select,
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
