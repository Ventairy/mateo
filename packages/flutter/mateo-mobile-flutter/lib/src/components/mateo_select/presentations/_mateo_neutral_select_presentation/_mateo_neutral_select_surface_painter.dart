part of '../../mateo_select.dart';

final class _MateoNeutralSelectSurfacePainter extends CustomPainter {
  _MateoNeutralSelectSurfacePainter({
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
    final surface = _MateoNeutralSelectPresentation._borderRadius.toRRect(rect);
    canvas.drawRRect(surface, _paint);
  }

  @override
  bool shouldRepaint(_MateoNeutralSelectSurfacePainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.triggerRect != triggerRect ||
      oldDelegate.triggerColor != triggerColor ||
      oldDelegate.menuColor != menuColor;
}
