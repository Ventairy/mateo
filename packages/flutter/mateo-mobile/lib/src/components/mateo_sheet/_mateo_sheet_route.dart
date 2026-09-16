part of 'show_mateo_sheet.dart';

class _MateoSheetRoute<T> extends PopupRoute<T> {
  _MateoSheetRoute({
    required this.view,
    required this.from,
    required this.theme,
    required this.textStyle,
    required this.direction,
    required this.reducedMotion,
  }) : super(requestFocus: true);

  final MateoSheetView view;
  final MateoSheetSource from;
  final MateoThemeData theme;
  final TextStyle textStyle;
  final TextDirection direction;
  final bool reducedMotion;
  late final CurvedAnimation _movement;
  late final _stackEntry = _MateoSheetStackEntry(source: from, vsync: navigator!, reducedMotion: reducedMotion);
  Route<dynamic>? _coveringRoute;
  bool _hasSheetBelow = false;
  bool _disposed = false;

  void _updateProgress() {
    _stackEntry.progress = _movement.value;
    _stackEntry.changed();
  }

  void _updatePosition(Offset offset, double directionalFraction) {
    _stackEntry.dismissProgress = directionalFraction;
    _stackEntry.changed();
  }

  @override
  void didChangePrevious(Route<dynamic>? previousRoute) {
    super.didChangePrevious(previousRoute);
    _hasSheetBelow = previousRoute is _MateoSheetRoute;
    changedInternalState();
  }

  @override
  void didChangeNext(Route<dynamic>? nextRoute) {
    super.didChangeNext(nextRoute);
    _coveringRoute = nextRoute;
    _stackEntry.covered = nextRoute != null;
    _stackEntry.next = nextRoute is _MateoSheetRoute ? nextRoute._stackEntry : null;
    _stackEntry.changed();
  }

  @override
  void didPopNext(Route<dynamic> nextRoute) {
    super.didPopNext(nextRoute);
    // Input follows navigation ownership; the frame can keep restoring below.
    _stackEntry.covered = false;

    if (nextRoute is _MateoSheetRoute && identical(_stackEntry.next, nextRoute._stackEntry)) {
      _stackEntry.restore();
    }

    _stackEntry.changed();
    if (nextRoute is! TransitionRoute) return;
    _coveringRoute = nextRoute;
    unawaited(
      nextRoute.completed.then((_) {
        if (_disposed || !identical(_coveringRoute, nextRoute)) return;
        _coveringRoute = null;
        _stackEntry.covered = false;
        _stackEntry.next = null;
        _stackEntry.changed();
      }),
    );
  }

  @override
  void install() {
    super.install();
    _movement = CurvedAnimation(parent: animation!, curve: from._curve, reverseCurve: from._reverseCurve);
    _movement.addListener(_updateProgress);
    _updateProgress();
  }

  @override
  Color? get barrierColor => _hasSheetBelow ? null : theme.colorScheme.sheet.scrim;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => reducedMotion ? .zero : from._duration;

  @override
  Duration get reverseTransitionDuration => reducedMotion ? .zero : from._reverseDuration;

  bool _dismiss() {
    if (!isCurrent || navigator == null) return false;
    navigator!.pop();
    return true;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      Directionality(
        textDirection: direction,
        child: MateoTheme(
          data: theme,
          child: DefaultTextStyle(
            style: textStyle,
            child: _MateoSheetStackScope(stackEntry: _stackEntry, child: view),
          ),
        ),
      );

  BoxConstraints _layoutConstraints(BoxConstraints viewport) => switch (from) {
    .bottom => BoxConstraints(maxHeight: viewport.maxHeight * from._maxExtentFraction),
  };

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final safePadding = MediaQuery.paddingOf(context);

        _stackEntry.availableSize = Size(
          math.max(0, constraints.maxWidth - safePadding.horizontal),
          math.max(0, constraints.maxHeight - safePadding.vertical),
        );

        final draggableSheet = _MateoSheetDrag(
          from: from,
          onDismiss: _dismiss,
          onPositionChanged: _updatePosition,
          child: SafeArea(
            child: Padding(
              padding: from._margin,
              child: ConstrainedBox(
                constraints: _layoutConstraints(constraints),
                child: child,
              ),
            ),
          ),
        );

        final sheet = Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: reducedMotion),
            child: draggableSheet,
          ),
        );

        if (reducedMotion) return Align(alignment: from._sheetAlignment, child: sheet);

        return Align(
          alignment: from._sheetAlignment,
          child: SlideTransition(
            position: Tween<Offset>(begin: from._beginOffset, end: .zero).animate(_movement),
            child: sheet,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _disposed = true;

    _movement
      ..removeListener(_updateProgress)
      ..dispose();

    _stackEntry.dispose();
    super.dispose();
  }
}
