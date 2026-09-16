part of 'mateo_page.dart';

abstract class _MateoPageRouteBase<T> extends PageRoute<T> {
  _MateoPageRouteBase({required MateoPage<T> page, required this.reducedMotion}) : super(settings: page);

  bool reducedMotion;
  bool _disposed = false;
  bool _settlementScheduled = false;
  MateoPage<T> get page => settings as MateoPage<T>;
  Widget buildContent(BuildContext context) => page.child;
  String? get title => page.title;
  @override
  bool get maintainState => page.maintainState;
  @override
  bool get fullscreenDialog => page.fullscreenDialog;
  @override
  bool get allowSnapshotting => page.allowSnapshotting;
  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;

  @override
  void changedExternalState() {
    super.changedExternalState();
    _updateTiming();
  }

  @override
  void changedInternalState() {
    super.changedInternalState();
    _updateTiming();
  }

  void updateMotion(BuildContext context) {
    final disabled = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disabled == reducedMotion) return;
    reducedMotion = disabled;
    _updateTiming();
    if (!disabled || _settlementScheduled) return;
    _settlementScheduled = true;
    // Route completion can rebuild Navigator; defer it beyond the current build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _settlementScheduled = false;
      if (_disposed || !reducedMotion || !isActive || popGestureInProgress) return;
      final animationController = controller;
      if (animationController == null || !animationController.isAnimating) return;
      animationController.value = animationController.status == .reverse ? 0 : 1;
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _updateTiming() {
    controller
      ?..duration = transitionDuration
      ..reverseDuration = reverseTransitionDuration;
  }
}
