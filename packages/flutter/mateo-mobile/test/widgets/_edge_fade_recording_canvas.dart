part of 'base_mateo_edge_fade_test.dart';

class _EdgeFadeRecordingCanvas extends Fake implements Canvas {
  final List<ui.Shader?> shaders = [];

  @override
  void drawRect(Rect rect, Paint paint) => shaders.add(paint.shader);
}
