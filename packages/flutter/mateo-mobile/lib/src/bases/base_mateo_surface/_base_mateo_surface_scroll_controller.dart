part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceScrollController extends ScrollController {
  final leadingScrollDistance = ValueNotifier<double>(0);

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) =>
      _BaseMateoSurfaceScrollPosition(
        physics: physics,
        context: context,
        oldPosition: oldPosition,
        onDistanceChanged: (distance) => leadingScrollDistance.value = distance,
      );

  @override
  void detach(ScrollPosition position) {
    super.detach(position);
    if (!hasClients) leadingScrollDistance.value = 0;
  }

  @override
  void dispose() {
    leadingScrollDistance.dispose();
    super.dispose();
  }
}
