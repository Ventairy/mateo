part of 'mateo_text_input.dart';

/// Extends Flutter's selection highlight past the paragraph's left paint bound.
class _MateoTextInputSelectionOverflow extends SingleChildRenderObjectWidget {
  const _MateoTextInputSelectionOverflow({required this.repaint, required super.child});

  final Listenable repaint;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderMateoTextInputSelectionOverflow(
    repaint,
    _MateoTextInputPresentationScope.of(context).controller,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderMateoTextInputSelectionOverflow renderObject) {
    renderObject
      ..updateController(_MateoTextInputPresentationScope.of(context).controller)
      ..repaint = repaint;
  }
}

class _RenderMateoTextInputSelectionOverflow extends RenderProxyBox {
  _RenderMateoTextInputSelectionOverflow(this._repaint, TextEditingController controller)
    : _controller = controller,
      _selectionCanPaint = _hasSelection(controller);

  Listenable _repaint;
  TextEditingController _controller;
  bool _selectionCanPaint;

  static bool _hasSelection(TextEditingController controller) {
    final selection = controller.selection;
    return selection.isValid && !selection.isCollapsed;
  }

  void _handleRepaint() {
    final selectionCanPaint = _hasSelection(_controller);
    if (_selectionCanPaint || selectionCanPaint) markNeedsPaint();
    _selectionCanPaint = selectionCanPaint;
  }

  void updateController(TextEditingController value) {
    if (identical(value, _controller)) return;
    final selectionCouldPaint = _selectionCanPaint;
    _controller = value;
    _selectionCanPaint = _hasSelection(value);
    if (selectionCouldPaint || _selectionCanPaint) markNeedsPaint();
  }

  Listenable get repaint => _repaint;

  set repaint(Listenable value) {
    if (identical(value, _repaint)) return;
    if (attached) _repaint.removeListener(_handleRepaint);
    _repaint = value;
    if (attached) _repaint.addListener(_handleRepaint);
    if (_selectionCanPaint) markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _repaint.addListener(_handleRepaint);
  }

  @override
  void detach() {
    _repaint.removeListener(_handleRepaint);
    super.detach();
  }

  RenderEditable? _findEditable(RenderObject object) {
    if (object is RenderEditable) return object;
    RenderEditable? result;
    object.visitChildren((child) => result ??= _findEditable(child));
    return result;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_hasSelection(_controller)) {
      super.paint(context, offset);
      return;
    }
    final editable = _findEditable(this);
    final selection = editable?.selection;
    final color = editable?.selectionColor;
    if (editable != null && color != null && selection != null && selection.isValid && !selection.isCollapsed) {
      final origin = editable.localToGlobal(Offset.zero, ancestor: this) + offset;
      final paint = Paint()..color = color;
      // Flutter intersects selection boxes with the unscrolled paragraph
      // bounds, even with Clip.none. Single-line scrolling shifts boxes left
      // in both text directions. Restore only that clipped portion; the native
      // painter already paints the right overflow. The enclosing fade applies
      // to both parts without painting translucent selection twice.
      for (final box in editable.getBoxesForSelection(selection)) {
        final rect = box.toRect().shift(origin);
        if (rect.left < origin.dx) {
          context.canvas.drawRect(
            Rect.fromLTRB(rect.left, rect.top, rect.right.clamp(rect.left, origin.dx), rect.bottom),
            paint,
          );
        }
      }
    }
    super.paint(context, offset);
  }
}
