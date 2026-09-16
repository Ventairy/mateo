part of '../../mateo_header.dart';

final class _MateoHeaderStandaloneContent
    extends SlottedMultiChildRenderObjectWidget<_MateoHeaderStandaloneSlot, RenderBox> {
  const _MateoHeaderStandaloneContent({
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
  Iterable<_MateoHeaderStandaloneSlot> get slots => _MateoHeaderStandaloneSlot.values;

  @override
  Widget? childForSlot(_MateoHeaderStandaloneSlot slot) => switch (slot) {
    .leading => leading,
    .title => title,
    .trailing => trailing,
  };

  @override
  _RenderMateoHeaderStandaloneContent createRenderObject(BuildContext context) => _RenderMateoHeaderStandaloneContent(
    spacing: spacing,
    centerTitle: centerTitle,
    textDirection: textDirection,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderMateoHeaderStandaloneContent renderObject) {
    renderObject
      ..spacing = spacing
      ..centerTitle = centerTitle
      ..textDirection = textDirection;
  }
}
