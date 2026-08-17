part of '../mateo_page.dart';

enum _MateoPageTransitionFamily { native, wash, push }

_MateoPageTransitionFamily _transitionFamilyOf(
  MateoPageTransition? transition,
) {
  return switch (transition) {
    null => _MateoPageTransitionFamily.native,
    _MateoWashPageTransition() => _MateoPageTransitionFamily.wash,
    _MateoPushPageTransition() => _MateoPageTransitionFamily.push,
  };
}

abstract class _MateoPageRoute<T> extends PageRoute<T> {
  _MateoPageRoute({
    required MateoPage<T> page,
    required this.disableAnimations,
  }) : _lastPage = page,
       super(settings: page);

  final bool disableAnimations;
  MateoPage<T> _lastPage;

  MateoPage<T> get _page => settings as MateoPage<T>;

  Widget buildContent(BuildContext context) => _page.child;

  String? get title => _page.title;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  bool get allowSnapshotting => _page.allowSnapshotting;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  String get debugLabel {
    final name = _page.name;
    return name == null ? super.debugLabel : '${super.debugLabel}($name)';
  }

  @override
  void changedInternalState() {
    final updatedPage = _page;
    if (!identical(updatedPage, _lastPage)) {
      final previousPage = _lastPage;
      _lastPage = updatedPage;
      _didUpdatePage(previousPage, updatedPage);
    }
    super.changedInternalState();
  }

  void _didUpdatePage(MateoPage<T> previousPage, MateoPage<T> updatedPage) {}
}

final class _MateoMaterialPageRoute<T> extends _MateoPageRoute<T> with MaterialRouteTransitionMixin<T> {
  _MateoMaterialPageRoute({
    required super.page,
    required super.disableAnimations,
  });

  @override
  Duration get transitionDuration => disableAnimations ? Duration.zero : super.transitionDuration;

  @override
  Duration get reverseTransitionDuration => disableAnimations ? Duration.zero : super.reverseTransitionDuration;
}

final class _MateoCupertinoPageRoute<T> extends _MateoPageRoute<T> with CupertinoRouteTransitionMixin<T> {
  _MateoCupertinoPageRoute({
    required super.page,
    required super.disableAnimations,
  });

  @override
  Duration get transitionDuration => disableAnimations ? Duration.zero : super.transitionDuration;

  @override
  Duration get reverseTransitionDuration => disableAnimations ? Duration.zero : super.reverseTransitionDuration;

  @override
  DelegatedTransitionBuilder? get delegatedTransition =>
      fullscreenDialog ? null : CupertinoPageTransition.delegatedTransition;
}

final class _MateoTransitionPageRoute<T> extends _MateoPageRoute<T> {
  _MateoTransitionPageRoute({
    required super.page,
    required this.transition,
    required this.platform,
    required super.disableAnimations,
  });

  MateoPageTransition transition;
  final TargetPlatform platform;

  Widget? _enteringChild;
  bool? _enteringUsesLinearProgress;
  late Widget _enteringTransition;
  Widget? _outgoingChild;
  bool? _outgoingUsesLinearProgress;
  late Widget _outgoingTransition;
  late final DelegatedTransitionBuilder? _delegatedTransition = switch (transition) {
    _MateoWashPageTransition() => null,
    _MateoPushPageTransition() => _buildPushDelegatedTransition,
  };

  @override
  Duration get transitionDuration => disableAnimations ? Duration.zero : transition.duration;

  @override
  Duration get reverseTransitionDuration => disableAnimations ? Duration.zero : transition.reverseDuration;

  @override
  bool get popGestureEnabled => platform != TargetPlatform.iOS && super.popGestureEnabled;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return transition is _MateoPushPageTransition && super.canTransitionFrom(previousRoute);
  }

  @override
  DelegatedTransitionBuilder? get delegatedTransition => _delegatedTransition;

  @override
  void _didUpdatePage(
    MateoPage<T> previousPage,
    MateoPage<T> updatedPage,
  ) {
    transition = updatedPage.transition!;
    _enteringChild = null;
    _outgoingChild = null;

    final animationController = controller;
    if (animationController != null) {
      animationController
        ..duration = transitionDuration
        ..reverseDuration = reverseTransitionDuration;
    }
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: buildContent(context),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (disableAnimations) return child;

    final useLinearProgress = popGestureInProgress;
    if (identical(_enteringChild, child) && _enteringUsesLinearProgress == useLinearProgress) {
      return _enteringTransition;
    }

    _enteringChild = child;
    _enteringUsesLinearProgress = useLinearProgress;
    final transitionView = switch (transition) {
      _MateoWashPageTransition(:final direction) => _MateoWashPageTransitionView(
        animation: animation,
        direction: direction,
        allowSnapshotting: allowSnapshotting,
        useLinearProgress: useLinearProgress,
        child: child,
      ),
      _MateoPushPageTransition(:final direction) => _MateoPushPageTransitionView(
        animation: animation,
        direction: direction,
        outgoing: false,
        fadeIntoDestination: true,
        allowSnapshotting: allowSnapshotting,
        useLinearProgress: useLinearProgress,
        child: child,
      ),
    };
    return _enteringTransition = platform == TargetPlatform.android
        ? _MateoPredictiveBackGestureDetector(
            route: this,
            child: transitionView,
          )
        : transitionView;
  }

  Widget? _buildPushDelegatedTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    bool allowSnapshotting,
    Widget? child,
  ) {
    if (child == null) return null;

    final push = transition as _MateoPushPageTransition;
    final useLinearProgress = popGestureInProgress;
    if (identical(_outgoingChild, child) && _outgoingUsesLinearProgress == useLinearProgress) {
      return _outgoingTransition;
    }

    _outgoingChild = child;
    _outgoingUsesLinearProgress = useLinearProgress;
    return _outgoingTransition = _MateoPushPageTransitionView(
      animation: secondaryAnimation,
      direction: push.direction,
      outgoing: true,
      fadeIntoDestination: false,
      allowSnapshotting: allowSnapshotting,
      useLinearProgress: useLinearProgress,
      child: child,
    );
  }
}
