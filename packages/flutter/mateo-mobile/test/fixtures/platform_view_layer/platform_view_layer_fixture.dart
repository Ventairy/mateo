import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

part '_render_platform_view_layer_fixture.dart';
part '_rasterization_counter_platform_view_layer.dart';

/// Paints a native platform layer and counts attempts to rasterize it.
class PlatformViewLayerFixture extends LeafRenderObjectWidget {
  /// Creates a native-layer fixture without registering a platform view.
  const PlatformViewLayerFixture({required this.onPaint, required this.onRasterizationCheck, super.key});

  /// Records native layer painting.
  final VoidCallback onPaint;

  /// Records attempts to check whether the native layer can be captured.
  final VoidCallback onRasterizationCheck;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderPlatformViewLayerFixture(
    onPaint: onPaint,
    onRasterizationCheck: onRasterizationCheck,
  );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderPlatformViewLayerFixture)
      ..onPaint = onPaint
      ..onRasterizationCheck = onRasterizationCheck;
  }
}
