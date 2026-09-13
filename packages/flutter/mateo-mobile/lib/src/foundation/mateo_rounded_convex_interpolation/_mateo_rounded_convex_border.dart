part of 'mateo_rounded_convex_interpolation.dart';

final class _MateoRoundedConvexBorder extends ShapeBorder {
  _MateoRoundedConvexBorder.lazy(
    this._path, {
    required this.size,
    required Float64List Function() capture,
    required this.pathTolerance,
    Path Function(Rect)? transform,
  }) : _cache = _MateoRoundedConvexBorderCache()
         ..capture = capture
         ..transform = transform;

  final Size size;
  final Path _path;
  final double pathTolerance;
  final _MateoRoundedConvexBorderCache _cache;

  Float64List get _points {
    final cached = _cache.points;
    if (cached != null) return cached;
    final points = _cache.capture!();
    _cache.points = points;
    _cache.capture = null;
    _cache.transform = null;
    return points;
  }

  MateoRoundedConvexDescription prepare(Size size) {
    final cached = _cache.prepared;
    if (cached != null && cached.size == size) return cached.description;
    if (!size.width.isFinite ||
        !size.height.isFinite ||
        size.width < 1e-37 ||
        size.height < 1e-37 ||
        size.longestSide > 3.4e38) {
      throw ArgumentError.value(
        size,
        'size',
        'Both endpoint dimensions must be positive and finite.',
      );
    }
    final description = (
      width: size.width,
      height: size.height,
      angle: 0.0,
      turns: Float64List(0),
      speeds: Float64List(0),
      spacings: Float64List(0),
      outline: MateoRoundedConvexEndpoint.fromFrame(
        _points,
        size.width,
        size.height,
      ),
    );
    _cache.prepared = (size: size, description: description);
    return description;
  }

  Path _createPath(Rect rect) => mateoRoundedConvexNativePath(_points, rect, tolerance: pathTolerance);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    if (!rect.isFinite ||
        rect.isEmpty ||
        rect.longestSide > 3.4e38 ||
        rect.left.abs() > 3.4e38 ||
        rect.top.abs() > 3.4e38 ||
        rect.right.abs() > 3.4e38 ||
        rect.bottom.abs() > 3.4e38) {
      return Path();
    }
    // The paired frame size is the usual fill/clip request. Its owned native
    // data needs neither another transform nor a second cached native wrapper.
    if (rect.left == 0 && rect.top == 0 && rect.width == size.width && rect.height == size.height) {
      return Path.from(_path);
    }
    final transformed = _cache.transformed;
    if (transformed != null && transformed.bounds == rect) return Path.from(transformed.path);
    // A fill and its clip share the native path data until a caller mutates its
    // own copy. Cache one bounds request, without accumulating layout variants.
    final path = rect.size == size ? _path.shift(rect.topLeft) : _cache.transform?.call(rect) ?? _createPath(rect);
    _cache.transformed = (bounds: rect, path: Path.from(path));
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}
