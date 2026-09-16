part of 'mateo_orb.dart';

class _MateoOrbPainter extends CustomPainter {
  _MateoOrbPainter({
    required this.background,
    required this.smoke,
    required this.shader,
    required this.time,
    required this.timeInSeconds,
  }) : super(repaint: time);

  final Color background;
  final Color smoke;
  final ui.FragmentShader? shader;
  final Animation<double> time;
  final double Function() timeInSeconds;

  double get elapsedSeconds => timeInSeconds();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final shader = this.shader;
    if (shader == null) {
      _paintFallback(canvas, size);
      return;
    }

    _setShaderUniforms(shader, size);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..isAntiAlias = true
        ..shader = shader,
    );
  }

  void _setShaderUniforms(ui.FragmentShader shader, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, elapsedSeconds)
      ..setFloat(3, background.r)
      ..setFloat(4, background.g)
      ..setFloat(5, background.b)
      ..setFloat(6, background.a)
      ..setFloat(7, smoke.r)
      ..setFloat(8, smoke.g)
      ..setFloat(9, smoke.b)
      ..setFloat(10, smoke.a);
  }

  void _paintFallback(Canvas canvas, Size size) {
    final diameter = size.shortestSide;
    final bounds = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: diameter,
      height: diameter,
    );
    final baseHighlight = Color.lerp(background, smoke, 0.26)!;
    final baseShadow = Color.lerp(background, Colors.black, 0.30)!;
    final surfacePaint = Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.radial(
        bounds.center - Offset(diameter * 0.22, diameter * 0.24),
        diameter * 0.78,
        [baseHighlight, background, baseShadow],
        const [0, 0.56, 1],
      );
    canvas
      ..drawCircle(bounds.center, diameter / 2, surfacePaint)
      ..save()
      ..clipPath(Path()..addOval(bounds), doAntiAlias: true);
    final vaporPaint = Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.linear(
        bounds.topLeft + Offset(0, diameter * 0.28),
        bounds.bottomRight - Offset(0, diameter * 0.08),
        [
          smoke.withValues(alpha: 0),
          Color.lerp(background, smoke, 0.58)!.withValues(
            alpha: smoke.a * 0.62,
          ),
          smoke.withValues(alpha: smoke.a * 0.84),
        ],
        const [0.16, 0.57, 1],
      );
    canvas
      ..drawRect(bounds, vaporPaint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _MateoOrbPainter oldDelegate) {
    return oldDelegate.background != background ||
        oldDelegate.smoke != smoke ||
        oldDelegate.shader != shader ||
        oldDelegate.time != time;
  }
}
