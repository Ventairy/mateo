part of '../../mateo_header.dart';

final class _RenderMateoHeaderViewContent extends RenderBox
    with SlottedContainerRenderObjectMixin<_MateoHeaderViewSlot, RenderBox> {
  _RenderMateoHeaderViewContent({
    required this._spacing,
    required this._centerTitle,
    required this._textDirection,
  });

  double _spacing;
  bool _centerTitle;
  TextDirection _textDirection;

  double get spacing => _spacing;

  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  bool get centerTitle => _centerTitle;

  set centerTitle(bool value) {
    if (_centerTitle == value) return;
    _centerTitle = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  RenderBox? get _leading => childForSlot(.leading);
  RenderBox get _title => childForSlot(.title)!;
  RenderBox? get _trailing => childForSlot(.trailing);

  @override
  Iterable<RenderBox> get children => [?_leading, ?childForSlot(.title), ?_trailing];

  ({Size size, double leadingSpace, double trailingSpace}) _layoutChildren(
    BoxConstraints constraints,
    ChildLayouter layoutChild,
  ) {
    final looseConstraints = constraints.loosen();
    final leadingSize = _leading == null ? Size.zero : layoutChild(_leading!, looseConstraints);
    final trailingSize = _trailing == null ? Size.zero : layoutChild(_trailing!, looseConstraints);
    final leadingSpace = _leading == null ? 0.0 : leadingSize.width + spacing;
    final trailingSpace = _trailing == null ? 0.0 : trailingSize.width + spacing;
    final reservedWidth = centerTitle ? math.max(leadingSpace, trailingSpace) * 2 : leadingSpace + trailingSpace;
    final titleSize = layoutChild(
      _title,
      constraints.hasBoundedWidth
          ? looseConstraints.tighten(width: math.max(0, constraints.maxWidth - reservedWidth))
          : looseConstraints,
    );

    return (
      size: constraints.constrain(
        Size(
          constraints.hasBoundedWidth ? constraints.maxWidth : titleSize.width + reservedWidth,
          math.max(titleSize.height, math.max(leadingSize.height, trailingSize.height)),
        ),
      ),
      leadingSpace: leadingSpace,
      trailingSpace: trailingSpace,
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _layoutChildren(constraints, ChildLayoutHelper.dryLayoutChild).size;

  @override
  void performLayout() {
    final layout = _layoutChildren(constraints, ChildLayoutHelper.layoutChild);
    size = layout.size;

    final isLeftToRight = textDirection == TextDirection.ltr;
    final (left, right) = isLeftToRight ? (_leading, _trailing) : (_trailing, _leading);
    if (left != null) _positionChild(left, 0);
    if (right != null) _positionChild(right, size.width - right.size.width);

    var titleLeft = isLeftToRight ? layout.leadingSpace : size.width - layout.leadingSpace - _title.size.width;
    if (centerTitle) {
      final leftSpace = isLeftToRight ? layout.leadingSpace : layout.trailingSpace;
      final rightSpace = isLeftToRight ? layout.trailingSpace : layout.leadingSpace;
      titleLeft = ((size.width - _title.size.width) / 2).clamp(
        leftSpace,
        math.max(leftSpace, size.width - rightSpace - _title.size.width),
      );
    }
    _positionChild(_title, titleLeft);
  }

  void _positionChild(RenderBox child, double left) {
    (child.parentData! as BoxParentData).offset = Offset(left, (size.height - child.size.height) / 2);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      context.paintChild(child, offset + (child.parentData! as BoxParentData).offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final child in [?_trailing, _title, ?_leading]) {
      if (result.addWithPaintOffset(
        offset: (child.parentData! as BoxParentData).offset,
        position: position,
        hitTest: (result, position) => child.hitTest(result, position: position),
      )) {
        return true;
      }
    }
    return false;
  }
}
