part of 'show_mateo_menu.dart';

class _MateoMenuRoute extends PopupRoute<MateoMenuOptionsPresentationItem> {
  _MateoMenuRoute({
    required this.menu,
    required this.surfaceAnimation,
    required this.placement,
    required this.reducedMotion,
    required this.theme,
    required this.capturedThemes,
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
  final CapturedThemes capturedThemes;
  final TextDirection direction;
  final Rect anchorBounds;
  bool _selected = false;
  bool _isExiting = false;

  @override
  Duration get transitionDuration => reducedMotion
      ? Duration.zero
      : switch (surfaceAnimation) {
          MateoSurfaceAnimationTransform(:final duration) => _routeDuration(duration),
          MateoSurfaceAnimationNone() || MateoSurfaceAnimationPop() => Duration.zero,
        };

  @override
  Duration get reverseTransitionDuration {
    if (reducedMotion) return Duration.zero;
    final exitDuration = exitTransition?.duration;
    if (exitDuration != null) return exitDuration;
    return switch (surfaceAnimation) {
      MateoSurfaceAnimationTransform(:final reverseDuration) => _routeDuration(reverseDuration),
      MateoSurfaceAnimationNone() || MateoSurfaceAnimationPop() => transitionDuration,
    };
  }

  Duration _routeDuration(MateoTransformDuration duration) => switch (duration) {
    MateoTransformDurationAuto() => MateoTransformTarget.defaultDuration,
    MateoTransformDurationCustom(:final duration) => duration,
  };

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

  Future<void> _select(MateoMenuOptionsPresentationItem item) async {
    if (_selected || !isCurrent) return;
    _selected = true;
    navigator!.pop(item);
    // Navigation from the action must not interrupt the closing morph capture.
    // Pop menus and reduced motion can deliver the action immediately.
    if (!reducedMotion && surfaceAnimation is MateoSurfaceAnimationTransform) await completed;
    await menu.onItemPressed!(item);
  }

  Widget _buildMenu() {
    final content = MateoSurfaceScope(
      animation: surfaceAnimation,
      child: MateoMenu(
        key: menu.key,
        presentation: menu.presentation,
        onItemPressed: menu.onItemPressed == null ? null : _select,
      ),
    );
    return surfaceAnimation is MateoSurfaceAnimationPop ? MateoMenuPopOverlayScope(child: content) : content;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      Directionality(
        textDirection: direction,
        child: MateoTheme(
          data: theme,
          child: capturedThemes.wrap(
            CallbackShortcuts(
              bindings: {const SingleActivator(LogicalKeyboardKey.escape): () => navigator?.maybePop()},
              child: Focus(
                autofocus: true,
                child: _MateoMenuOverlay(
                  route: this,
                  child: _buildExitTransition(
                    animation,
                    _buildMenu(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
