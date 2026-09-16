part of 'base_mateo_view.dart';

class _RenderMateoViewLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  _RenderMateoViewLayout({
    required this._layout,
    required this._fitHeight,
    required this._reserveHeaderSpace,
  });

  _MateoViewLayoutData _layout;
  _MateoViewLayoutData get layoutData => _layout;

  set layoutData(_MateoViewLayoutData value) {
    _layout = value;
    // Slot presence and measurements can change within the same data instance.
    markNeedsLayout();
  }

  bool _fitHeight;
  bool get fitHeight => _fitHeight;
  set fitHeight(bool value) {
    if (_fitHeight == value) return;
    _fitHeight = value;
    markNeedsLayout();
  }

  bool _reserveHeaderSpace;

  bool get reserveHeaderSpace => _reserveHeaderSpace;

  set reserveHeaderSpace(bool value) {
    if (_reserveHeaderSpace == value) return;
    _reserveHeaderSpace = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) child.parentData = MultiChildLayoutParentData();
  }

  RenderBox? _childFor(_MateoViewSlot id) {
    var child = firstChild;
    while (child != null) {
      final data = child.parentData! as MultiChildLayoutParentData;
      if (data.id == id) return child;
      child = data.nextSibling;
    }
    return null;
  }

  void _position(RenderBox child, Offset offset) => (child.parentData! as MultiChildLayoutParentData).offset = offset;

  @override
  void performLayout() {
    final width = constraints.maxWidth;
    final header = _childFor(_MateoViewSlot.header)!;
    final footer = _childFor(_MateoViewSlot.footer)!;
    final surface = _childFor(_MateoViewSlot.surface)!;
    final slotConstraints = BoxConstraints.tightFor(width: width);
    header.layout(slotConstraints, parentUsesSize: true);
    _layout.header?.height = header.size.height;
    footer.layout(slotConstraints, parentUsesSize: true);
    _layout.footer?.height = footer.size.height;
    _layout.reserveHeaderSpace = _reserveHeaderSpace;
    _layout.updateObstructionInsets();
    _position(header, .zero);
    _position(surface, .zero);

    final surfaceConstraints = _fitHeight
        ? BoxConstraints(
            minWidth: width,
            maxWidth: width,
            minHeight: constraints.minHeight,
            maxHeight: constraints.maxHeight,
          )
        : BoxConstraints.tight(constraints.biggest);
    surface.layout(surfaceConstraints, parentUsesSize: true);
    size = constraints.constrain(surface.size);
    _position(footer, Offset(0, size.height - footer.size.height));
    final overlay = _childFor(_MateoViewSlot.overlay);
    if (overlay != null) {
      overlay.layout(BoxConstraints.tight(size));
      _position(overlay, .zero);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _layout.resolveObstructionInsets();
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    _layout.resolveObstructionInsets();
    return defaultHitTestChildren(result, position: position);
  }
}
