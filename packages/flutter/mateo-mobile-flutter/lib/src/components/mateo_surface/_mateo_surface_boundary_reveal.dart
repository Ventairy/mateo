part of '../mateo_surface.dart';

final class _MateoSurfaceBoundaryReveal extends SingleChildRenderObjectWidget {
  const _MateoSurfaceBoundaryReveal({
    required this.repaint,
    required this.position,
    required this.maximumExtent,
    required this.resolveExtent,
    required super.child,
    super.key,
  });

  final Listenable? repaint;
  final _MateoSurfaceBoundaryPosition position;
  final double maximumExtent;
  final double Function(
    _MateoSurfaceBoundaryPosition position,
    double maximumExtent,
  )
  resolveExtent;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMateoSurfaceBoundaryReveal(
      repaint: repaint,
      position: position,
      maximumExtent: maximumExtent,
      resolveExtent: resolveExtent,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMateoSurfaceBoundaryReveal renderObject,
  ) {
    renderObject
      ..repaint = repaint
      ..position = position
      ..maximumExtent = maximumExtent
      ..resolveExtent = resolveExtent;
  }
}
