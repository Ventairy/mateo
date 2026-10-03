part of '../show_mateo_sheet.dart';

class _RenderMateoSheetFrame extends RenderProxyBox {
  _RenderMateoSheetFrame({required this._stackEntry, required this._color, required this._dimColor});

  _MateoSheetStackEntry _stackEntry;
  Rect? _paintedFrame;
  double? _paintedDepth;

  void _handleStackChange() {
    // Entry progress also drives sheets below this one without changing this frame.
    if (_paintedDepth == _stackEntry.depth && _paintedFrame == _frame) return;
    markNeedsPaint();
  }

  _MateoSheetStackEntry get stackEntry => _stackEntry;
  set stackEntry(_MateoSheetStackEntry value) {
    if (identical(value, _stackEntry)) return;
    if (attached) _stackEntry.removeListener(_handleStackChange);
    _stackEntry = value;
    _paintedFrame = null;
    _paintedDepth = null;
    if (attached) _stackEntry.addListener(_handleStackChange);
    markNeedsLayout();
  }

  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  Color _dimColor;
  Color get dimColor => _dimColor;
  set dimColor(Color value) {
    if (_dimColor == value) return;
    _dimColor = value;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _stackEntry.addListener(_handleStackChange);
  }

  @override
  void detach() {
    _stackEntry.removeListener(_handleStackChange);
    super.detach();
  }

  @override
  void performLayout() {
    super.performLayout();
    _stackEntry.size = size;
  }

  Rect get _frame => switch (_stackEntry.source) {
    .bottom => _stackEntry.frame.shift(Offset(0, size.height)),
  };

  double _contentScale(Rect frame) => switch (_stackEntry.source) {
    .bottom => frame.width / size.width,
  };

  @override
  Rect? describeApproximatePaintClip(RenderObject child) => _stackEntry.depth == 0 ? null : _frame;

  @override
  Rect get paintBounds => (Offset.zero & size).expandToInclude(_frame);

  @override
  void paint(PaintingContext context, Offset offset) {
    final depth = _stackEntry.depth;
    final frame = _frame;
    _paintedFrame = frame;
    _paintedDepth = depth;
    if (child == null || size.isEmpty || depth >= 3) return;
    if (depth == 0) {
      super.paint(context, offset);
      return;
    }
    final scale = _contentScale(frame);
    final shape = MateoSheetView._shape.scale(scale);
    final path = shape.getOuterPath(frame);
    final shiftedPath = path.shift(offset);
    context.pushClipPath(needsCompositing, offset, (Offset.zero & size).expandToInclude(frame), path, (
      context,
      offset,
    ) {
      // The clip supplies the sheet outline; filling it avoids another path draw.
      context.canvas.drawRect(frame.shift(offset), Paint()..color = _color);
      final transform = Matrix4.identity()
        ..translateByDouble(frame.left, frame.top, 0, 1)
        ..scaleByDouble(scale, scale, 1, 1);
      context.pushTransform(
        needsCompositing,
        offset,
        transform,
        (context, offset) => context.paintChild(child!, offset),
      );
      context.canvas.drawPath(
        shiftedPath,
        Paint()..color = _dimColor.withValues(alpha: 0.08 * depth.clamp(0, 2)),
      );
    }, clipBehavior: Clip.antiAlias);
  }
}
