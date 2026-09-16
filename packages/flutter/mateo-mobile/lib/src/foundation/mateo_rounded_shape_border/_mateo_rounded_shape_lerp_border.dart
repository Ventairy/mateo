part of 'mateo_rounded_shape_border.dart';

final class _MateoRoundedShapeLerpBorder extends ShapeBorder {
  const _MateoRoundedShapeLerpBorder({required this.begin, required this.end, required this.progress});

  final MateoRoundedShapeBorder begin;
  final MateoRoundedShapeBorder end;
  final double progress;

  @override
  EdgeInsetsGeometry get dimensions => .zero;

  @override
  ShapeBorder scale(double t) =>
      _MateoRoundedShapeLerpBorder(begin: begin.scale(t), end: end.scale(t), progress: progress);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty || !rect.isFinite || !rect.width.isFinite || !rect.height.isFinite) return Path();
    return MateoRoundedShapeBorder.lerp(
      begin: (radius: begin.resolveRadius(rect.size), size: rect.size),
      end: (radius: end.resolveRadius(rect.size), size: rect.size),
      progress: progress,
    ).border.getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}
