part of '../mateo_toast.dart';

class _MateoToastSlideWidget extends SingleChildRenderObjectWidget {
  const _MateoToastSlideWidget({required this.position, required super.child});

  final Animation<Offset>? position;

  @override
  _RenderMateoToastSlide createRenderObject(BuildContext context) {
    return _RenderMateoToastSlide(position: position);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMateoToastSlide renderObject,
  ) {
    renderObject.position = position;
  }
}
