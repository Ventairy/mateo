part of 'show_mateo_menu.dart';

Rect? _readMateoMenuAnchorBounds({required BuildContext anchorContext, required RenderBox overlay}) {
  if (!anchorContext.mounted) return null;
  final anchor = anchorContext.findRenderObject();
  if (anchor is! RenderBox || !anchor.attached || !anchor.hasSize) return null;
  final anchorToOverlay = anchor.getTransformTo(overlay);
  if (anchorToOverlay.determinant() == 0) return null;
  return MatrixUtils.transformRect(anchorToOverlay, Offset.zero & anchor.size);
}
