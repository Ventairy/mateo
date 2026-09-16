part of 'base_mateo_surface.dart';

class _RenderBaseMateoSurfaceContentLayout extends RenderShiftedBox {
  _RenderBaseMateoSurfaceContentLayout({
    required this._obstructionInsets,
    required this._obstructionInsetsChanges,
    required this._padding,
    required this._alignment,
  }) : super(null);

  EdgeInsets _layoutInsets = EdgeInsets.zero;
  EdgeInsets _paintedInsets = EdgeInsets.zero;
  bool _layoutScheduled = false;

  ValueGetter<EdgeInsets>? _obstructionInsets;
  ValueGetter<EdgeInsets>? get obstructionInsets => _obstructionInsets;
  set obstructionInsets(ValueGetter<EdgeInsets>? value) {
    _obstructionInsets = value;
    markNeedsLayout();
  }

  Listenable? _obstructionInsetsChanges;
  Listenable? get obstructionInsetsChanges => _obstructionInsetsChanges;
  set obstructionInsetsChanges(Listenable? value) {
    if (identical(_obstructionInsetsChanges, value)) return;
    if (attached) _obstructionInsetsChanges?.removeListener(_obstructionInsetsChanged);
    _obstructionInsetsChanges = value;
    if (attached) _obstructionInsetsChanges?.addListener(_obstructionInsetsChanged);
  }

  EdgeInsets _padding;
  EdgeInsets get padding => _padding;
  set padding(EdgeInsets value) {
    if (value == _padding) return;
    _padding = value;
    markNeedsLayout();
  }

  Alignment? _alignment;
  Alignment? get alignment => _alignment;
  set alignment(Alignment? value) {
    if (value == _alignment) return;
    _alignment = value;
    markNeedsLayout();
  }

  EdgeInsets get _insets => _obstructionInsets?.call() ?? EdgeInsets.zero;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _obstructionInsetsChanges?.addListener(_obstructionInsetsChanged);
  }

  @override
  void detach() {
    _obstructionInsetsChanges?.removeListener(_obstructionInsetsChanged);
    super.detach();
  }

  void _obstructionInsetsChanged() {
    final insets = _insets;
    if (_layoutScheduled) return;
    if (insets != _layoutInsets) {
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    } else if (insets != _paintedInsets) {
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  BoxConstraints _contentConstraints(BoxConstraints constraints, EdgeInsets insets) {
    final available = constraints.deflate(_padding + insets);
    return _alignment == null ? available : available.loosen();
  }

  double _remaining(double value, double occupied) => (value - occupied).clamp(0, double.infinity);

  @override
  double computeMinIntrinsicWidth(double height) =>
      child!.getMinIntrinsicWidth(_remaining(height, _insets.vertical + _padding.vertical)) +
      _padding.horizontal +
      _insets.horizontal;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      child!.getMaxIntrinsicWidth(_remaining(height, _insets.vertical + _padding.vertical)) +
      _padding.horizontal +
      _insets.horizontal;

  @override
  double computeMinIntrinsicHeight(double width) =>
      child!.getMinIntrinsicHeight(_remaining(width, _padding.horizontal + _insets.horizontal)) +
      _insets.vertical +
      _padding.vertical;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      child!.getMaxIntrinsicHeight(_remaining(width, _padding.horizontal + _insets.horizontal)) +
      _insets.vertical +
      _padding.vertical;

  Size _contentSize(BoxConstraints constraints, Size childSize, EdgeInsets insets) => constraints.constrain(
    Size(
      childSize.width + _padding.horizontal + insets.horizontal,
      childSize.height + _padding.vertical + insets.vertical,
    ),
  );

  Offset _contentOffset(EdgeInsets insets) {
    if (_alignment == null) return (_padding + insets).topLeft;
    // The current size still includes the insets used during layout. Do not
    // treat a receding obstruction as new alignment space until layout removes
    // that space too. Growing obstructions must still be avoided immediately.
    final reservedInsets = EdgeInsets.fromLTRB(
      insets.left.clamp(_layoutInsets.left, double.infinity),
      insets.top.clamp(_layoutInsets.top, double.infinity),
      insets.right.clamp(_layoutInsets.right, double.infinity),
      insets.bottom.clamp(_layoutInsets.bottom, double.infinity),
    );
    final minimum = (_padding + reservedInsets).topLeft;
    final available = Size(
      _remaining(size.width, _padding.horizontal),
      _remaining(size.height, _padding.vertical),
    );
    final preferred = _padding.topLeft + _alignment!.alongOffset((available - child!.size) as Offset);
    final maximum = Offset(
      size.width - _padding.right - reservedInsets.right - child!.size.width,
      size.height - _padding.bottom - reservedInsets.bottom - child!.size.height,
    );
    // Preserve authored alignment unless a reserved edge obstructs it. When
    // final placement leaves too little room, prioritize the leading edge
    // until the next layout can resize the child.
    double coordinate(double preferred, double minimum, double maximum, double start, double end) {
      if (start > 0 && preferred < minimum) return minimum;
      if (end > 0 && preferred > maximum) return maximum < minimum ? minimum : maximum;
      return preferred;
    }

    return Offset(
      coordinate(preferred.dx, minimum.dx, maximum.dx, reservedInsets.left, reservedInsets.right),
      coordinate(preferred.dy, minimum.dy, maximum.dy, reservedInsets.top, reservedInsets.bottom),
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final insets = _insets;
    return _contentSize(constraints, child!.getDryLayout(_contentConstraints(constraints, insets)), insets);
  }

  @override
  void performLayout() {
    _layoutInsets = _insets;
    child!.layout(_contentConstraints(constraints, _layoutInsets), parentUsesSize: true);
    size = _contentSize(constraints, child!.size, _layoutInsets);
    (child!.parentData! as BoxParentData).offset = _contentOffset(_layoutInsets);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final insets = _insets;
    // The owner can refine clearance after placement. Paint with the latest
    // snapshot, then reconcile layout without a visible top jump.
    if (insets != _layoutInsets && !_layoutScheduled) {
      _layoutScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _layoutScheduled = false;
        if (!attached) return;
        markNeedsLayout();
        markNeedsSemanticsUpdate();
      });
    }
    _paintedInsets = insets;
    context.paintChild(child!, offset + _contentOffset(insets));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) => result.addWithPaintOffset(
    offset: _contentOffset(_insets),
    position: position,
    hitTest: (result, position) => child!.hitTest(result, position: position),
  );

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final offset = _contentOffset(_insets);
    transform.translateByDouble(offset.dx, offset.dy, 0, 1);
  }
}
