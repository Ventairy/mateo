part of '../../mateo_text_field.dart';

class _MateoSearchTextSelectionPainter extends CustomPainter {
  _MateoSearchTextSelectionPainter({
    required this.textController,
    required this.paintRootKey,
    required this.color,
  }) : super(repaint: textController);

  final MateoTextController textController;
  final GlobalKey paintRootKey;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final selection = textController.value.selection;
    if (!textController.hasFocus || !selection.isValid || selection.isCollapsed) return;

    final paintRoot = paintRootKey.currentContext?.findRenderObject();
    if (paintRoot is! RenderBox) return;

    final editable = _findEditable(paintRoot);
    if (editable == null) return;

    final transform = editable.getTransformTo(paintRoot);
    final editableBounds = MatrixUtils.transformRect(
      transform,
      Offset.zero & editable.size,
    );
    final paintBounds = Offset.zero & size;
    final beforeEditable = Rect.fromLTRB(
      paintBounds.left,
      paintBounds.top,
      editableBounds.left,
      paintBounds.bottom,
    );
    final afterEditable = Rect.fromLTRB(
      editableBounds.right,
      paintBounds.top,
      paintBounds.right,
      paintBounds.bottom,
    );
    // Flutter clips its selection highlight to the editable bounds. Paint only
    // the missing overflow here; the search mask fades both parts together.
    final selectionPaint = Paint()..color = color;
    for (final box in editable.getBoxesForSelection(selection)) {
      final selectionRect = MatrixUtils.transformRect(transform, box.toRect());
      final leadingOverflow = selectionRect.intersect(beforeEditable);
      final trailingOverflow = selectionRect.intersect(afterEditable);
      if (!leadingOverflow.isEmpty) canvas.drawRect(leadingOverflow, selectionPaint);
      if (!trailingOverflow.isEmpty) canvas.drawRect(trailingOverflow, selectionPaint);
    }
  }

  RenderEditable? _findEditable(RenderObject root) {
    RenderEditable? result;
    void visitor(RenderObject child) {
      if (result != null) return;
      if (child case final RenderEditable editable) {
        result = editable;
        return;
      }
      child.visitChildren(visitor);
    }

    root.visitChildren(visitor);
    return result;
  }

  @override
  bool shouldRepaint(covariant _MateoSearchTextSelectionPainter oldDelegate) =>
      !identical(oldDelegate.textController, textController) || oldDelegate.color != color;
}
