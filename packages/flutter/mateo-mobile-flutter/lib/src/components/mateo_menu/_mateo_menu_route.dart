part of 'mateo_menu_button.dart';

class _MateoMenuRoute extends PopupRoute<void> {
  _MateoMenuRoute({
    required List<MateoMenuItem> items,
    required this.presentation,
    required this.triggerBounds,
    required this.morphTag,
    required this.barrierColor,
    required this.textDirection,
    required this.capturedThemes,
    required this.barrierLabel,
    required this.disableAnimations,
  }) : items = List<MateoMenuItem>.unmodifiable(items);

  final List<MateoMenuItem> items;
  final MateoMenuPresentation presentation;
  final ValueListenable<Rect> triggerBounds;
  final Object morphTag;
  final TextDirection textDirection;
  final CapturedThemes capturedThemes;
  final bool disableAnimations;
  final _closed = Completer<void>();
  _MateoMenuSession? _session;
  bool _closing = false;

  _MateoMenuSession get _menuSession => _session ??= _MateoMenuSession(
    items: items,
    triggerBounds: triggerBounds,
    morphTag: morphTag,
    textDirection: textDirection,
    animation: animation!,
    disableAnimations: disableAnimations,
    onSelected: select,
    onSourceReturned: sourceReturned,
    onDismiss: () => navigator?.maybePop(),
    isCurrent: () => isCurrent,
  );

  void select(MateoMenuItem item) {
    if (_closing || !isCurrent || item.onPressed == null) return;
    navigator?.pop();
    final result = item.onPressed!(_closed.future);
    if (result is Future<void>) unawaited(result);
  }

  void sourceReturned() {
    if (_closing) _completeClosing();
  }

  void _completeClosing() {
    if (!_closed.isCompleted) _closed.complete();
  }

  @override
  bool didPop(void result) {
    if (!super.didPop(result)) return false;
    _closing = true;
    return true;
  }

  @override
  void dispose() {
    _completeClosing();
    super.dispose();
  }

  @override
  final String barrierLabel;

  @override
  bool get barrierDismissible => true;

  @override
  final Color barrierColor;

  @override
  Curve get barrierCurve => presentation._barrierCurve;

  @override
  Duration get transitionDuration => disableAnimations ? Duration.zero : presentation._openDuration;

  @override
  Duration get reverseTransitionDuration => disableAnimations ? Duration.zero : presentation._closeDuration;

  @override
  Widget buildModalBarrier() => presentation._buildModalBarrier(this);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      capturedThemes.wrap(
        Directionality(
          textDirection: textDirection,
          child: presentation._buildMenu(_menuSession),
        ),
      );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}
