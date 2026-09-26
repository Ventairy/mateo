part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceDecorationPainter extends BoxPainter {
  _BaseMateoSurfaceDecorationPainter(this.decoration, super.onChanged)
    : _fillPaint = Paint()..color = decoration.color!,
      _shadowPaints = [
        for (final shadow in decoration.shadows!) shadow.toPaint(),
      ];

  // The native blur approximation is pixel-validated through this radius.
  // Larger shoulders retain their exact contour instead of scaling the error.
  static const double _maximumApproximatedShadowRadius = 48;
  static const _maximumCachedShadowPaths = 64;
  static final _shadowPathCache = <({Rect bounds, double radius}), Path>{};

  final _BaseMateoSurfaceDecoration decoration;
  final Paint _fillPaint;
  final List<Paint> _shadowPaints;
  Size? _size;
  late Path _fillPath;
  late List<({RRect bounds, Path? outline})> _shadowGeometry;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size!;
    if (size != _size) {
      _size = size;
      final bounds = Offset.zero & size;
      _fillPath = decoration.shape.getOuterPath(bounds);
      _shadowGeometry = [
        for (var index = 0; index < decoration.shadows!.length; index++)
          _resolveShadowGeometry(
            bounds.shift(decoration.shadows![index].offset).inflate(decoration.shadows![index].spreadRadius),
            _shadowPaints[index],
          ),
      ];
    }
    // Moving the surface reuses its local outlines instead of rebuilding paths
    // for each paint offset. Retain only this size, not a history or bitmap.
    canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    for (var index = 0; index < _shadowGeometry.length; index++) {
      final geometry = _shadowGeometry[index];
      if (geometry.bounds.isEmpty) continue;
      if (geometry.outline case final outline?) {
        canvas.drawPath(outline, _shadowPaints[index]);
      } else {
        // Gaussian blur hides the small shoulder difference while the native
        // rounded-rectangle primitive enables shared analytic blur caches.
        // The visible fill, content clip and hit testing retain Mateo's outline.
        canvas.drawRRect(geometry.bounds, _shadowPaints[index]);
      }
    }
    canvas
      ..drawPath(_fillPath, _fillPaint)
      ..restore();
  }

  ({RRect bounds, Path? outline}) _resolveShadowGeometry(Rect bounds, Paint paint) {
    if (bounds.isEmpty || !bounds.isFinite || !bounds.width.isFinite || !bounds.height.isFinite) {
      return (bounds: RRect.zero, outline: null);
    }
    final shape = decoration.shape as MateoRoundedShapeBorder;
    final radius = shape.resolveRadius(bounds.size);
    final roundedBounds = RRect.fromRectAndRadius(bounds, Radius.circular(radius));
    final isCircle = bounds.width == bounds.height && radius == bounds.width / 2;
    if (paint.maskFilter != null && (radius <= _maximumApproximatedShadowRadius || isCircle)) {
      return (bounds: roundedBounds, outline: null);
    }
    // Unblurred shadows and large shoulders keep the exact shape. Private,
    // immutable paths also share native blur caches between equal surfaces.
    final key = (bounds: bounds, radius: radius);
    final cached = _shadowPathCache.remove(key);
    if (cached != null) {
      _shadowPathCache[key] = cached;
      return (bounds: roundedBounds, outline: cached);
    }
    final path = shape.getOuterPath(bounds);
    if (_shadowPathCache.length == _maximumCachedShadowPaths) {
      _shadowPathCache.remove(_shadowPathCache.keys.first);
    }
    _shadowPathCache[key] = path;
    return (bounds: roundedBounds, outline: path);
  }
}
