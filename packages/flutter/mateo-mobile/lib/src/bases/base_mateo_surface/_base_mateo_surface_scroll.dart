part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceScroll extends StatefulWidget {
  const _BaseMateoSurfaceScroll({required this.controller, required this.child});

  final _BaseMateoSurfaceScrollController controller;
  final Widget child;

  @override
  State<_BaseMateoSurfaceScroll> createState() => _BaseMateoSurfaceScrollState();
}

class _BaseMateoSurfaceScrollState extends State<_BaseMateoSurfaceScroll> {
  // Long eager content keeps its initial recordings. Short content removes the
  // individual surface layers once its first dimensions are available.
  bool _retainSurfaceLayers = true;

  bool _updateDimensions(ScrollMetricsNotification notification) {
    if (notification.depth != 0) return false;
    final metrics = notification.metrics;
    final viewportExtent = metrics.viewportDimension;
    final contentExtent = metrics.maxScrollExtent - metrics.minScrollExtent + viewportExtent;
    if (!viewportExtent.isFinite || viewportExtent <= 0 || !contentExtent.isFinite) return false;
    widget.controller.updateDimensions(metrics);
    final retainSurfaceLayers = contentExtent > viewportExtent * 3;
    if (_retainSurfaceLayers != retainSurfaceLayers) setState(() => _retainSurfaceLayers = retainSurfaceLayers);
    return false;
  }

  @override
  Widget build(BuildContext context) => NotificationListener<ScrollMetricsNotification>(
    onNotification: _updateDimensions,
    child: CustomScrollView(
      controller: widget.controller,
      primary: false,
      clipBehavior: Clip.none,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: RepaintBoundary(
            child: _BaseMateoSurfaceRepaintScope(
              controller: _retainSurfaceLayers ? widget.controller : null,
              child: widget.child,
            ),
          ),
        ),
      ],
    ),
  );
}
