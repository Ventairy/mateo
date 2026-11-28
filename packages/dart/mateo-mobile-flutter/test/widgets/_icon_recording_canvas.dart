part of 'mateo_icon_test.dart';

class _IconRecordingCanvas extends Fake implements Canvas {
  final List<Color> colors = [];

  @override
  void drawPath(Path path, Paint paint) => colors.add(paint.color);

  @override
  void drawOval(Rect rect, Paint paint) => colors.add(paint.color);

  @override
  void drawRRect(RRect rect, Paint paint) => colors.add(paint.color);

  @override
  void save() {}

  @override
  void saveLayer(Rect? bounds, Paint paint) {}

  @override
  void clipRect(Rect rect, {ClipOp clipOp = ClipOp.intersect, bool doAntiAlias = true}) {}

  @override
  void restore() {}

  @override
  void scale(double sx, [double? sy]) {}

  @override
  void translate(double dx, double dy) {}

  @override
  void rotate(double radians) {}

  @override
  void transform(Float64List matrix4) {}

  @override
  void clipPath(Path path, {bool doAntiAlias = true}) {}
}
