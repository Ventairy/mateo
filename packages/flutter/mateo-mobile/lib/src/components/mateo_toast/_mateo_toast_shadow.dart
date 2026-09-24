part of 'mateo_toast.dart';

class _MateoToastShadow extends CustomPainter {
  const _MateoToastShadow({required this.color, required this.transparentOccluder});

  // One path shadow keeps the toast lifted without rasterizing two wide blurs.
  static const _opacity = 0.35;
  static const _physicalElevation = 8.0;

  final Color color;
  final bool transparentOccluder;

  @override
  void paint(Canvas canvas, Size size) {
    if (debugDisableShadows) return;
    final path = const MateoRoundedShapeBorder.capsule().getOuterPath(Offset.zero & size);
    canvas.drawShadow(path, color.withValues(alpha: _opacity), _physicalElevation, transparentOccluder);
  }

  @override
  bool shouldRepaint(_MateoToastShadow oldDelegate) =>
      color != oldDelegate.color || transparentOccluder != oldDelegate.transparentOccluder;
}
