part of 'layout_counter.dart';

class _RenderLayoutCounter extends RenderProxyBox {
  new(this.onLayout);

  final VoidCallback onLayout;

  @override
  void performLayout() {
    onLayout();
    super.performLayout();
  }
}
