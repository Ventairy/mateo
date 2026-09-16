part of '../mateo_text_input.dart';

/// Extends Flutter's selection highlight past the paragraph's left paint bound.
class _MateoTextInputSelectionOverflow extends SingleChildRenderObjectWidget {
  const _MateoTextInputSelectionOverflow({required this.repaint, required super.child});

  final Listenable repaint;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderMateoTextInputSelectionOverflow(repaint);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoTextInputSelectionOverflow renderObject) {
    renderObject.repaint = repaint;
  }
}

class _RenderMateoTextInputSelectionOverflow extends RenderProxyBox {
  _RenderMateoTextInputSelectionOverflow(this._repaint);

  Listenable _repaint;

  Listenable get repaint => _repaint;

  set repaint(Listenable value) {
    if (identical(value, _repaint)) return;
    if (attached) _repaint.removeListener(markNeedsPaint);
    _repaint = value;
    if (attached) _repaint.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _repaint.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _repaint.removeListener(markNeedsPaint);
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
