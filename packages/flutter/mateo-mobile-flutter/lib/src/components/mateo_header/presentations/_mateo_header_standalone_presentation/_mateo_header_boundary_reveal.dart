part of '../../mateo_header.dart';

final class _MateoHeaderBoundaryReveal extends SingleChildRenderObjectWidget {
  const _MateoHeaderBoundaryReveal({
    required this.repaint,
    required this.maximumExtent,
    required this.resolveExtent,
    required super.child,
    super.key,
  });

  final Listenable? repaint;
  final double maximumExtent;
  final double Function(double maximumExtent) resolveExtent;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMateoHeaderBoundaryReveal(
      repaint: repaint,
      maximumExtent: maximumExtent,
      resolveExtent: resolveExtent,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMateoHeaderBoundaryReveal renderObject,
  ) {
    renderObject
      ..repaint = repaint
      ..maximumExtent = maximumExtent
      ..resolveExtent = resolveExtent;
  }
}
