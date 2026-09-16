part of '../../mateo_header.dart';

final class _MateoHeaderViewContent extends SlottedMultiChildRenderObjectWidget<_MateoHeaderViewSlot, RenderBox> {
  const _MateoHeaderViewContent({
    required this.title,
    required this.spacing,
    required this.centerTitle,
    required this.textDirection,
    this.leading,
    this.trailing,
  });

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final bool centerTitle;
  final double spacing;
  final TextDirection textDirection;

  @override
  Iterable<_MateoHeaderViewSlot> get slots => _MateoHeaderViewSlot.values;

  @override
  Widget? childForSlot(_MateoHeaderViewSlot slot) => switch (slot) {
    .leading => leading,
    .title => title,
    .trailing => trailing,
  };

  @override
  _RenderMateoHeaderViewContent createRenderObject(BuildContext context) => _RenderMateoHeaderViewContent(
    spacing: spacing,
    centerTitle: centerTitle,
    textDirection: textDirection,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderMateoHeaderViewContent renderObject) {
    renderObject
      ..spacing = spacing
      ..centerTitle = centerTitle
      ..textDirection = textDirection;
  }
}
