part of '../base_mateo_view_surface.dart';

class _MateoViewSurfaceEdgeFadePainter extends MateoEdgeFadePainter {
  _MateoViewSurfaceEdgeFadePainter({
    required super.color,
    required super.resolveBands,
    required this.view,
    required Listenable repaint,
  }) : super(signal: repaint, bands: []);

  final MateoViewLayoutScope view;

  @override
  Size bandSize(Size size, MateoEdgeFadeBand band) {
    // Only the contextual footer treatment ends above the obstruction.
    // The surface, viewport, and other edge fades retain their full bounds.
    if (band.edge != AxisDirection.down || !view.hasFooter) return size;
    return Size(size.width, (size.height - view.footer!.bottomInset).clamp(0, double.infinity));
  }
}
