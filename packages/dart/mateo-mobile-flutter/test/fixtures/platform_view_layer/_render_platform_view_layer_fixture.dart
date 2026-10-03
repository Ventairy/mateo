part of 'platform_view_layer_fixture.dart';

class _RenderPlatformViewLayerFixture extends RenderBox {
  _RenderPlatformViewLayerFixture({required this.onPaint, required this.onRasterizationCheck});

  VoidCallback onPaint;
  VoidCallback onRasterizationCheck;

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  void performLayout() => size = constraints.biggest;

  @override
  void paint(PaintingContext context, Offset offset) {
    onPaint();
    context.addLayer(
      _RasterizationCounterPlatformViewLayer(
        rect: offset & size,
        onRasterizationCheck: onRasterizationCheck,
      ),
    );
  }
}
