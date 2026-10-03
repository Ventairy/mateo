part of '../mateo_button.dart';

final class _RenderMateoFittedLabelButtonContent extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, ContainerBoxParentData<RenderBox>> {
  _RenderMateoFittedLabelButtonContent({required this._progress, required this._alignment});

  Animation<double> _progress;
  Alignment _alignment;
  final _contentTransform = Matrix4.identity();
  final _loadingIndicatorTransform = Matrix4.identity();
  final _contentLayer = LayerHandle<TransformLayer>();
  final _loadingIndicatorLayer = LayerHandle<TransformLayer>();

  Animation<double> get progress => _progress;
  set progress(Animation<double> value) {
    if (identical(_progress, value)) return;
    if (attached) _progress.removeListener(markNeedsLayout);
    _progress = value;
    if (attached) _progress.addListener(markNeedsLayout);
    markNeedsLayout();
  }

  Alignment get alignment => _alignment;
  set alignment(Alignment value) {
    if (_alignment == value) return;
    _alignment = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ContainerBoxParentData<RenderBox>) {
      child.parentData = _MateoFittedLabelButtonContentParentData();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _progress.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _progress.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void dispose() {
    _contentLayer.layer = null;
    _loadingIndicatorLayer.layer = null;
    super.dispose();
  }

  double _width(double contentWidth, double loadingIndicatorWidth) =>
      contentWidth + (loadingIndicatorWidth - contentWidth) * _progress.value;

  Size _layout(BoxConstraints constraints, ChildLayouter layoutChild) {
    // Both destinations use the parent's available space, never the animated
    // width. Unchanged child layouts are reused on subsequent spring ticks.
    final looseConstraints = constraints.loosen();
    final contentSize = layoutChild(firstChild!, looseConstraints);
    final loadingIndicatorSize = layoutChild(lastChild!, looseConstraints);
    return constraints.constrain(Size(_width(contentSize.width, loadingIndicatorSize.width), contentSize.height));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => _layout(constraints, ChildLayoutHelper.dryLayoutChild);

  @override
  double computeMinIntrinsicWidth(double height) =>
      _width(firstChild!.getMinIntrinsicWidth(height), lastChild!.getMinIntrinsicWidth(height));

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _width(firstChild!.getMaxIntrinsicWidth(height), lastChild!.getMaxIntrinsicWidth(height));

  @override
  double computeMinIntrinsicHeight(double width) => firstChild!.getMinIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) => firstChild!.getMaxIntrinsicHeight(width);

  @override
  void performLayout() {
    size = _layout(constraints, ChildLayoutHelper.layoutChild);
    _updateTransform(firstChild!, _contentTransform);
    _updateTransform(lastChild!, _loadingIndicatorTransform);
  }

  void _updateTransform(RenderBox child, Matrix4 transform) {
    final scale = math.min<double>(
      1,
      child.size.isEmpty ? 1 : math.min(size.width / child.size.width, size.height / child.size.height),
    );
    final offset = _alignment.alongOffset(
      Offset(size.width - child.size.width * scale, size.height - child.size.height * scale),
    );
    transform.setIdentity();
    transform.storage[0] = scale;
    transform.storage[5] = scale;
    transform.storage[12] = offset.dx;
    transform.storage[13] = offset.dy;
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(child == firstChild ? _contentTransform : _loadingIndicatorTransform);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) => result.addWithPaintTransform(
    transform: _contentTransform,
    position: position,
    hitTest: (result, position) => firstChild!.hitTest(result, position: position),
  );

  @override
  void paint(PaintingContext context, Offset offset) {
    _contentLayer.layer = context.pushTransform(
      needsCompositing,
      offset,
      _contentTransform,
      (context, offset) => context.paintChild(firstChild!, offset),
      oldLayer: _contentLayer.layer,
    );
    _loadingIndicatorLayer.layer = context.pushTransform(
      needsCompositing,
      offset,
      _loadingIndicatorTransform,
      (context, offset) => context.paintChild(lastChild!, offset),
      oldLayer: _loadingIndicatorLayer.layer,
    );
  }
}
