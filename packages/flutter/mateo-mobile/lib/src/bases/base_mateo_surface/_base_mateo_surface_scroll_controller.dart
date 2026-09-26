part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceScrollController extends ScrollController {
  final leadingScrollDistance = ValueNotifier<double>(0);
  final _dimensions = ValueNotifier<({double viewportExtent, double minimumScrollExtent, double maximumScrollExtent})?>(
    null,
  );

  Listenable get dimensionsChanges => _dimensions;

  void updateDimensions(ScrollMetrics metrics) {
    // Pixel changes also produce metrics notifications. Compare only layout
    // dimensions so ordinary scrolling does not dispatch this second signal.
    _dimensions.value = (
      viewportExtent: metrics.viewportDimension,
      minimumScrollExtent: metrics.minScrollExtent,
      maximumScrollExtent: metrics.maxScrollExtent,
    );
  }

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
    _dimensions.dispose();
    super.dispose();
  }
}
