part of '../../mateo_menu.dart';

class _RenderMateoMenuOptionsRow extends RenderFlex {
  _RenderMateoMenuOptionsRow({
    required this._hasSupporting,
    required this._singleLineHeight,
    required super.textDirection,
  }) : super(direction: .horizontal, mainAxisSize: .min);

  bool _hasSupporting;
  double _singleLineHeight;

  bool get hasSupporting => _hasSupporting;

  set hasSupporting(bool value) {
    if (_hasSupporting == value) return;
    _hasSupporting = value;
    markNeedsLayout();
  }

  double get singleLineHeight => _singleLineHeight;

  set singleLineHeight(double value) {
    if (_singleLineHeight == value) return;
    _singleLineHeight = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    super.performLayout();
    final leading = firstChild;
    final content = lastChild;
    if (leading == null || content == null || leading == content) return;
    if (!_hasSupporting && !_hasMultipleLines(content)) return;

    final leadingParentData = leading.parentData! as FlexParentData;
    final contentParentData = content.parentData! as FlexParentData;
    leadingParentData.offset = Offset(leadingParentData.offset.dx, contentParentData.offset.dy);
  }

  bool _hasMultipleLines(RenderBox content) {
    RenderParagraph? principal;
    void findPrincipal(RenderObject child) {
      if (principal != null) return;
      if (child case final RenderParagraph paragraph) {
        principal = paragraph;
        return;
      }
      child.visitChildren(findPrincipal);
    }

    content.visitChildren(findPrincipal);
    final paragraph = principal;
    if (paragraph == null) return content.size.height > _singleLineHeight;
    final textLength = paragraph.text.toPlainText().length;
    if (textLength == 0) return false;
    final boxes = paragraph.getBoxesForSelection(TextSelection(baseOffset: 0, extentOffset: textLength));
    if (boxes.isEmpty) return false;
    final firstLineTop = boxes.first.top;
    return boxes.skip(1).any((box) => box.top != firstLineTop);
  }
}
