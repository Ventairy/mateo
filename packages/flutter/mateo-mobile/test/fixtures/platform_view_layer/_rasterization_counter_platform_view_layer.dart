part of 'platform_view_layer_fixture.dart';

class _RasterizationCounterPlatformViewLayer extends PlatformViewLayer {
  _RasterizationCounterPlatformViewLayer({required super.rect, required this.onRasterizationCheck}) : super(viewId: 0);

  final VoidCallback onRasterizationCheck;

  @override
  bool supportsRasterization() {
    onRasterizationCheck();
    return super.supportsRasterization();
  }
}
