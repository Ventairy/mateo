part of 'base_mateo_view_footer.dart';

final class _MateoViewFooterContent extends SlottedMultiChildRenderObjectWidget<_MateoViewFooterSlot, RenderBox> {
  const _MateoViewFooterContent({
    required this.textDirection,
    this.principal,
    this.leading,
    this.trailing,
  });

  final Widget? principal;
  final Widget? leading;
  final Widget? trailing;
  final TextDirection textDirection;

  @override
  Iterable<_MateoViewFooterSlot> get slots => _MateoViewFooterSlot.values;

  @override
  Widget? childForSlot(_MateoViewFooterSlot slot) => switch (slot) {
    .leading => leading,
    .principal => principal,
    .trailing => trailing,
  };

  @override
  _RenderMateoViewFooterContent createRenderObject(BuildContext context) => _RenderMateoViewFooterContent(
    textDirection: textDirection,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderMateoViewFooterContent renderObject) {
    renderObject.textDirection = textDirection;
  }
}
