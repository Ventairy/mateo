part of 'base_mateo_edge_fade.dart';

class _BaseMateoEdgeFadeBandPaint {
  MateoEdgeFadeProfile? _profile;
  Color? _color;
  AxisDirection? _edge;
  late LinearGradient _gradient;
  Rect? _bounds;
  final Paint _paint = Paint();

  void paint(Canvas canvas, Size size, MateoEdgeFadeBand band, Color? color) {
    if (_profile != band.profile || _color != color || _edge != band.edge) {
      _profile = band.profile;
      _color = color;
      _edge = band.edge;
      _gradient = LinearGradient(
        begin: switch (band.edge) {
          .up => .topCenter,
          .down => .bottomCenter,
          .left => .centerLeft,
          .right => .centerRight,
        },
        end: switch (band.edge) {
          .up => .bottomCenter,
          .down => .topCenter,
          .left => .centerRight,
          .right => .centerLeft,
        },
        stops: band.profile.stops,
        colors: [
          for (final visibility in band.profile.visibility)
            (color ?? const Color(0xFFFFFFFF)).withValues(alpha: 1 - visibility),
        ],
      );
      _bounds = null;
    }
    final bounds = switch (band.edge) {
      .up => Rect.fromLTWH(0, 0, size.width, band.extent),
      .down => Rect.fromLTWH(0, size.height - band.extent, size.width, band.extent),
      .left => Rect.fromLTWH(0, 0, band.extent, size.height),
      .right => Rect.fromLTWH(size.width - band.extent, 0, band.extent, size.height),
    };
    if (_bounds != bounds) {
      _bounds = bounds;
      _paint.shader = _gradient.createShader(bounds);
    }
    _paint.blendMode = color == null ? .dstOut : .srcOver;
    // Crop only the treatment. The host owns clipping of its content.
    canvas.drawRect(bounds.intersect(Offset.zero & size), _paint);
  }
}
