part of 'base_mateo_view_header.dart';

final class _MateoViewHeaderContent extends SlottedMultiChildRenderObjectWidget<_MateoViewHeaderSlot, RenderBox> {
  const _MateoViewHeaderContent({
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
  Iterable<_MateoViewHeaderSlot> get slots => _MateoViewHeaderSlot.values;

  @override
  Widget? childForSlot(_MateoViewHeaderSlot slot) => switch (slot) {
    .leading => leading,
    .principal => principal,
    .trailing => trailing,
  };

  @override
  _RenderMateoViewHeaderContent createRenderObject(BuildContext context) => _RenderMateoViewHeaderContent(
    textDirection: textDirection,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderMateoViewHeaderContent renderObject) {
    renderObject.textDirection = textDirection;
  }
}
