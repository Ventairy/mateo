part of 'mateo_y_snap_list.dart';

class _MateoYSnapListViewport extends MultiChildRenderObjectWidget {
  _MateoYSnapListViewport({
    required this.offsetListenable,
    required this.loadingLiftListenable,
    required this.spacing,
    required this.hasPreviousCard,
    required this.hasNextCard,
    required this.isAwaitMode,
    required this.loadingMoreOffset,
    required Widget currentCard,
    required Widget nextCard,
    required Widget previousCard,
    required Widget loadingIndicator,
    super.key,
  }) : super(
         children: <Widget>[
           currentCard,
           nextCard,
           previousCard,
           loadingIndicator,
         ],
       );

  final ValueListenable<double> offsetListenable;
  final ValueListenable<double> loadingLiftListenable;
  final double spacing;
  final bool hasPreviousCard;
  final bool hasNextCard;
  final bool isAwaitMode;
  final double loadingMoreOffset;

  @override
  _RenderMateoYSnapListViewport createRenderObject(BuildContext context) {
    return _RenderMateoYSnapListViewport(
      offsetListenable: offsetListenable,
      loadingLiftListenable: loadingLiftListenable,
      spacing: spacing,
      hasPreviousCard: hasPreviousCard,
      hasNextCard: hasNextCard,
      isAwaitMode: isAwaitMode,
      loadingMoreOffset: loadingMoreOffset,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMateoYSnapListViewport renderObject,
  ) {
    renderObject
      ..offsetListenable = offsetListenable
      ..loadingLiftListenable = loadingLiftListenable
      ..spacing = spacing
      ..hasPreviousCard = hasPreviousCard
      ..hasNextCard = hasNextCard
      ..isAwaitMode = isAwaitMode
      ..loadingMoreOffset = loadingMoreOffset;
  }
}

class _MateoYSnapListViewportParentData extends ContainerBoxParentData<RenderBox> {
  bool wasPainted = false;
}

class _RenderMateoYSnapListViewport extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _MateoYSnapListViewportParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _MateoYSnapListViewportParentData> {
  _RenderMateoYSnapListViewport({
    required this._offsetListenable,
    required this._loadingLiftListenable,
    required this._spacing,
    required this._hasPreviousCard,
    required this._hasNextCard,
    required this._isAwaitMode,
    required this._loadingMoreOffset,
  }) {
    _paintLoadingIndicatorChild = _paintLoadingIndicatorLayerChild;
  }

  static const double _spinnerSize = _MateoYSnapListLoadingIndicator.indicatorBoxSize;
  static final BoxConstraints _spinnerConstraints = BoxConstraints.tight(
    const Size(_spinnerSize, _spinnerSize),
  );

  final List<RenderBox?> _lastPaintOrder = List<RenderBox?>.filled(
    4,
    null,
    growable: false,
  );
  final LayerHandle<OpacityLayer> _spinnerOpacityLayer = LayerHandle<OpacityLayer>();

  ValueListenable<double> _offsetListenable;
  ValueListenable<double> _loadingLiftListenable;
  double _spacing;
  bool _hasPreviousCard;
  bool _hasNextCard;
  bool _isAwaitMode;
  double _loadingMoreOffset;

  RenderBox? _currentCard;
  RenderBox? _nextCard;
  RenderBox? _previousCard;
  RenderBox? _loadingIndicator;
  int _paintedChildCount = 0;
  bool _usedSpinnerOpacityLayer = false;
  late final PaintingContextCallback _paintLoadingIndicatorChild;

  ValueListenable<double> get offsetListenable => _offsetListenable;

  set offsetListenable(ValueListenable<double> value) {
    if (identical(value, _offsetListenable)) return;

    if (attached) {
      _offsetListenable.removeListener(_handlePositionChanged);
    }
    _offsetListenable = value;
    if (attached) {
      _offsetListenable.addListener(_handlePositionChanged);
    }
    _handlePositionChanged();
  }

  ValueListenable<double> get loadingLiftListenable => _loadingLiftListenable;

  set loadingLiftListenable(ValueListenable<double> value) {
    if (identical(value, _loadingLiftListenable)) return;

    if (attached) {
      _loadingLiftListenable.removeListener(_handlePositionChanged);
    }
    _loadingLiftListenable = value;
    if (attached) {
      _loadingLiftListenable.addListener(_handlePositionChanged);
    }
    _handlePositionChanged();
  }

  double get spacing => _spacing;

  set spacing(double value) {
    if (value == _spacing) return;

    _spacing = value;
    markNeedsPaint();
  }

  bool get hasPreviousCard => _hasPreviousCard;

  set hasPreviousCard(bool value) {
    if (value == _hasPreviousCard) return;

    _hasPreviousCard = value;
    markNeedsPaint();
  }

  bool get hasNextCard => _hasNextCard;

  set hasNextCard(bool value) {
    if (value == _hasNextCard) return;

    _hasNextCard = value;
    markNeedsPaint();
  }

  bool get isAwaitMode => _isAwaitMode;

  set isAwaitMode(bool value) {
    if (value == _isAwaitMode) return;

    _isAwaitMode = value;
    markNeedsPaint();
    if (owner?.semanticsOwner != null) markNeedsSemanticsUpdate();
  }

  double get loadingMoreOffset => _loadingMoreOffset;

  set loadingMoreOffset(double value) {
    if (value == _loadingMoreOffset) return;

    _loadingMoreOffset = value;
    markNeedsPaint();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get sizedByParent => true;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _MateoYSnapListViewportParentData) {
      child.parentData = _MateoYSnapListViewportParentData();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _offsetListenable.addListener(_handlePositionChanged);
    _loadingLiftListenable.addListener(_handlePositionChanged);
  }

  @override
  void detach() {
    _offsetListenable.removeListener(_handlePositionChanged);
    _loadingLiftListenable.removeListener(_handlePositionChanged);
    super.detach();
  }

  void _handlePositionChanged() {
    markNeedsPaint();
  }

  Size _sizeFor(BoxConstraints constraints) {
    return constraints.constrain(constraints.biggest);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final width = _sizeFor(
      BoxConstraints.tightForFinite(height: height),
    ).width;
    return width.isFinite ? width : 0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final width = _sizeFor(
      BoxConstraints.tightForFinite(height: height),
    ).width;
    return width.isFinite ? width : 0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final height = _sizeFor(
      BoxConstraints.tightForFinite(width: width),
    ).height;
    return height.isFinite ? height : 0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final height = _sizeFor(
      BoxConstraints.tightForFinite(width: width),
    ).height;
    return height.isFinite ? height : 0;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => _sizeFor(constraints);

  @override
  void performResize() {
    size = computeDryLayout(constraints);
  }

  @override
  void performLayout() {
    _resetPaintOrder();
    _currentCard = null;
    _nextCard = null;
    _previousCard = null;
    _loadingIndicator = null;

    final cardConstraints = BoxConstraints.tight(size);
    var index = 0;
    var child = firstChild;
    while (child != null) {
      child.layout(
        index == 3 ? _spinnerConstraints : cardConstraints,
        parentUsesSize: false,
      );

      final parentData = (child.parentData! as _MateoYSnapListViewportParentData)
        ..offset = Offset.zero
        ..wasPainted = false;

      switch (index) {
        case 0:
          _currentCard = child;
        case 1:
          _nextCard = child;
        case 2:
          _previousCard = child;
        case 3:
          _loadingIndicator = child;
      }

      child = parentData.nextSibling;
      index += 1;
    }

    assert(index == 4, 'MateoYSnapList viewport requires exactly four slots.');
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _prepareForPaint();

    final offsetY = _offsetListenable.value;
    if (_hasPreviousCard && offsetY > 0) {
      _paintChild(
        context,
        offset,
        _previousCard!,
        Offset(0, offsetY - size.height - _spacing),
      );
    }

    if (_isAwaitMode) {
      _paintAwaitModeChildren(context, offset, offsetY);
    } else {
      if (_hasNextCard && offsetY <= 0) {
        _paintChild(
          context,
          offset,
          _nextCard!,
          Offset(0, offsetY + size.height + _spacing),
        );
      }

      _paintChild(
        context,
        offset,
        _currentCard!,
        Offset(0, offsetY),
      );
    }

    if (!_usedSpinnerOpacityLayer) {
      _spinnerOpacityLayer.layer = null;
    }
  }

  void _prepareForPaint() {
    _resetPaintOrder();
    _usedSpinnerOpacityLayer = false;
  }

  void _resetPaintOrder() {
    for (var index = 0; index < _paintedChildCount; index += 1) {
      final child = _lastPaintOrder[index]!;
      final parentData = child.parentData;
      if (child.parent == this && parentData is _MateoYSnapListViewportParentData) {
        parentData
          ..offset = Offset.zero
          ..wasPainted = false;
      }
      _lastPaintOrder[index] = null;
    }
    _paintedChildCount = 0;
  }

  void _paintAwaitModeChildren(
    PaintingContext context,
    Offset offset,
    double offsetY,
  ) {
    final loadingLift = _loadingLiftListenable.value;
    if (offsetY >= 0) {
      _paintChild(
        context,
        offset,
        _currentCard!,
        Offset(0, loadingLift),
      );

      if (loadingLift < 0) {
        final spinnerOffset = Offset(
          (size.width - _spinnerSize) * 0.5,
          size.height + loadingLift,
        );
        _paintLoadingIndicator(
          context,
          offset,
          spinnerOffset,
          _loadingOpacityFor(loadingLift),
        );
      }
      return;
    }

    _paintChild(
      context,
      offset,
      _currentCard!,
      Offset(0, loadingLift + offsetY),
    );

    if (_hasNextCard) {
      _paintChild(
        context,
        offset,
        _nextCard!,
        Offset(0, offsetY + size.height + _spacing),
      );
    }
  }

  void _paintChild(
    PaintingContext context,
    Offset viewportOffset,
    RenderBox child,
    Offset childOffset,
  ) {
    _registerPaintedChild(child, childOffset);
    context.paintChild(
      child,
      viewportOffset == Offset.zero ? childOffset : viewportOffset + childOffset,
    );
  }

  void _paintLoadingIndicator(
    PaintingContext context,
    Offset viewportOffset,
    Offset childOffset,
    double opacity,
  ) {
    final child = _loadingIndicator!;
    final alpha = ui.Color.getAlphaFromOpacity(opacity);
    if (alpha == 0) return;

    _registerPaintedChild(child, childOffset);
    if (alpha == 255) {
      context.paintChild(
        child,
        viewportOffset == Offset.zero ? childOffset : viewportOffset + childOffset,
      );
      return;
    }

    _usedSpinnerOpacityLayer = true;
    _spinnerOpacityLayer.layer = context.pushOpacity(
      viewportOffset == Offset.zero ? childOffset : viewportOffset + childOffset,
      alpha,
      _paintLoadingIndicatorChild,
      oldLayer: _spinnerOpacityLayer.layer,
    );
  }

  void _paintLoadingIndicatorLayerChild(
    PaintingContext context,
    Offset offset,
  ) {
    context.paintChild(_loadingIndicator!, offset);
  }

  void _registerPaintedChild(RenderBox child, Offset offset) {
    final parentData = child.parentData! as _MateoYSnapListViewportParentData;
    assert(!parentData.wasPainted, 'A viewport child cannot be painted twice.');
    parentData
      ..offset = offset
      ..wasPainted = true;
    _lastPaintOrder[_paintedChildCount] = child;
    _paintedChildCount += 1;
  }

  double _loadingOpacityFor(double loadingLift) {
    if (_loadingMoreOffset == 0) return 0;

    return (-loadingLift / _loadingMoreOffset).clamp(0.0, 1.0);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (var index = _paintedChildCount - 1; index >= 0; index -= 1) {
      final child = _lastPaintOrder[index]!;
      final parentData = child.parentData! as _MateoYSnapListViewportParentData;
      final isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (result, transformed) {
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) return true;
    }

    return false;
  }

  @override
  bool paintsChild(covariant RenderBox child) {
    assert(
      child.parent == this,
      'Viewport children must belong to this render object.',
    );
    return (child.parentData! as _MateoYSnapListViewportParentData).wasPainted;
  }

  @override
  void applyPaintTransform(covariant RenderBox child, Matrix4 transform) {
    if (!paintsChild(child)) {
      transform.setZero();
      return;
    }

    super.applyPaintTransform(child, transform);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    final currentCard = _currentCard;
    if (currentCard != null && currentCard.parent == this && paintsChild(currentCard)) {
      visitor(currentCard);
    }
  }

  @override
  void dispose() {
    _spinnerOpacityLayer.layer = null;
    super.dispose();
  }
}
