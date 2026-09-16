part of '../show_mateo_sheet.dart';

class _RenderMateoSheetFrame extends RenderProxyBox {
  _RenderMateoSheetFrame({required this._stackEntry, required this._color, required this._dimColor});

  _MateoSheetStackEntry _stackEntry;
  _MateoSheetStackEntry get stackEntry => _stackEntry;
  set stackEntry(_MateoSheetStackEntry value) {
    if (identical(value, _stackEntry)) return;
    if (attached) _stackEntry.removeListener(markNeedsPaint);
    _stackEntry = value;
    if (attached) _stackEntry.addListener(markNeedsPaint);
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
    _stackEntry.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _stackEntry.removeListener(markNeedsPaint);
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
    if (child == null || size.isEmpty || _stackEntry.opacity == 0) return;
    if (_stackEntry.depth == 0) {
      super.paint(context, offset);
      return;
    }
    final frame = _frame;
    final scale = _contentScale(frame);
    final shape = MateoSheetView._shape.scale(scale);
    final path = shape.getOuterPath(frame);
    context.pushClipPath(needsCompositing, offset, paintBounds, path, (context, offset) {
      context.canvas.drawPath(path.shift(offset), Paint()..color = _color);
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
        path.shift(offset),
        Paint()..color = _dimColor.withValues(alpha: 0.08 * _stackEntry.depth.clamp(0, 2)),
      );
    }, clipBehavior: Clip.antiAlias);
  }
}
