part of 'mateo_dot_matrix.dart';

const double _kMinOpacity = 0.01;
const double _kOneMinusMinOpacity = 1.0 - _kMinOpacity;
const double _kBandSigma = 0.18;
const double _kInvTwoSigmaSq = 1.0 / (2.0 * _kBandSigma * _kBandSigma);

class _MateoDotMatrixPainter extends CustomPainter {
  const _MateoDotMatrixPainter({
    required this.particles,
    required this.color,
    required this.progress,
  });

  final List<_MateoDotMatrixDot> particles;
  final Color color;
  final double progress;

  double get bandCenter => progress % 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || particles.isEmpty) return;

    // ---- diagonal sweep band ----
    final invSumWH = 1.0 / (size.width + size.height);

    final paint = Paint();
    for (final pDot in particles) {
      final t = (pDot.position.dx + pDot.position.dy) * invSumWH;
      final rawDist = (t - bandCenter).abs();
      final dist = rawDist < 0.5 ? rawDist : 1.0 - rawDist;
      final activation = math.exp(-dist * dist * _kInvTwoSigmaSq);

      final opacity = _kMinOpacity + _kOneMinusMinOpacity * activation;

      paint.color = color.withValues(alpha: opacity);
      canvas.drawCircle(pDot.position, pDot.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MateoDotMatrixPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        !identical(oldDelegate.particles, particles);
  }
}
