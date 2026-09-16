part of 'base_mateo_view_header.dart';

final class _RenderMateoViewHeaderContent extends RenderBox
    with SlottedContainerRenderObjectMixin<_MateoViewHeaderSlot, RenderBox> {
  _RenderMateoViewHeaderContent({required this._textDirection});

  static const double _spacing = 16;

  TextDirection _textDirection;

  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  RenderBox? get _leading => childForSlot(.leading);
  RenderBox? get _principal => childForSlot(.principal);
  RenderBox? get _trailing => childForSlot(.trailing);

  @override
  Iterable<RenderBox> get children => [?_leading, ?childForSlot(.principal), ?_trailing];

  ({Size size, double leadingSpace, double trailingSpace}) _layoutChildren(
    BoxConstraints constraints,
    ChildLayouter layoutChild,
  ) {
    final looseConstraints = constraints.loosen();
    assert(constraints.hasBoundedWidth, 'MateoViewHeader requires a bounded width.');
    final sideConstraints = looseConstraints.copyWith(
      maxWidth: math.max(0, constraints.maxWidth / 2 - _spacing),
    );
    final leadingSize = _leading == null ? Size.zero : layoutChild(_leading!, sideConstraints);
    final trailingSize = _trailing == null ? Size.zero : layoutChild(_trailing!, sideConstraints);
    final leadingSpace = _leading == null ? 0.0 : leadingSize.width + _spacing;
    final trailingSpace = _trailing == null ? 0.0 : trailingSize.width + _spacing;
    final reservedWidth = math.max(leadingSpace, trailingSpace) * 2;
    final principalSize = _principal == null
        ? Size.zero
        : layoutChild(
            _principal!,
            constraints.hasBoundedWidth
                ? looseConstraints.copyWith(maxWidth: math.max(0, constraints.maxWidth - reservedWidth))
                : looseConstraints,
          );

    return (
      size: constraints.constrain(
        Size(
          constraints.hasBoundedWidth ? constraints.maxWidth : principalSize.width + reservedWidth,
          math.max(principalSize.height, math.max(leadingSize.height, trailingSize.height)),
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

    if (_principal != null) _positionChild(_principal!, (size.width - _principal!.size.width) / 2);
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
    for (final child in [?_trailing, ?_principal, ?_leading]) {
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
