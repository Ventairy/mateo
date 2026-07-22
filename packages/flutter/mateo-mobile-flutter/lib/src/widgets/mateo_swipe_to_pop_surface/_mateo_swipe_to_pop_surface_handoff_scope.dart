part of 'mateo_swipe_to_pop_surface.dart';

class _MateoSwipeToPopSurfaceHandoffScope extends InheritedWidget {
  const _MateoSwipeToPopSurfaceHandoffScope({
    required this.state,
    required super.child,
  });

  final MateoSwipeToPopHandoffState? state;

  static MateoSwipeToPopHandoffState? maybeStateOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
          _MateoSwipeToPopSurfaceHandoffScope
        >()
        ?.state;
  }

  @override
  bool updateShouldNotify(_MateoSwipeToPopSurfaceHandoffScope oldWidget) {
    return state != oldWidget.state;
  }
}
