part of '../../mateo_select.dart';

final class _MateoGhostSelectSurfacePainter extends CustomPainter {
  _MateoGhostSelectSurfacePainter({
    required this.animation,
    required this.triggerRect,
    required this.triggerColor,
    required this.menuColor,
  }) : _paint = Paint(),
       super(repaint: animation);

  final Animation<double> animation;
  final Rect triggerRect;
  final Color triggerColor;
  final Color menuColor;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.lerp(triggerRect, Offset.zero & size, animation.value)!;
    if (rect.isEmpty) return;

    _paint.color = Color.lerp(triggerColor, menuColor, animation.value)!;
    final surface = _MateoGhostSelectPresentation._borderRadius.toRRect(rect);
    canvas.drawRRect(surface, _paint);
  }

  @override
  bool shouldRepaint(_MateoGhostSelectSurfacePainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.triggerRect != triggerRect ||
      oldDelegate.triggerColor != triggerColor ||
      oldDelegate.menuColor != menuColor;
}
