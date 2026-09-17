part of 'mateo_toggle.dart';

class _MateoTogglePainter extends CustomPainter {
  _MateoTogglePainter({required this.position, required this.colors, required this.enabled, required this.direction})
    : super(repaint: position);

  static const _trackSize = Size(74, 32);
  static const _thumbSize = Size(35, 24);
  static const _inset = 4.0;
  static final double travel = _trackSize.width - _thumbSize.width - 2 * _inset;
  static const _shape = MateoRoundedShapeBorder.capsule();
  final Animation<double> position;
  final MateoToggleColorScheme colors;
  final bool enabled;
  final double direction;
  final _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final progress = position.value.clamp(0.0, 1.0);
    final track = Rect.fromCenter(center: size.center(Offset.zero), width: _trackSize.width, height: _trackSize.height);
    // Retain spring overshoot while keeping extreme interrupted velocities
    // inside the track. Color progress remains bounded independently.
    final visualPosition = direction > 0 ? position.value : 1 - position.value;
    final thumbLeft = (track.left + _inset + travel * visualPosition).clamp(track.left, track.right - _thumbSize.width);
    final thumb = Rect.fromLTWH(
      thumbLeft,
      track.center.dy - _thumbSize.height / 2,
      _thumbSize.width,
      _thumbSize.height,
    );
    canvas
      ..drawPath(
        _shape.getOuterPath(track),
        _paint..color = enabled ? Color.lerp(colors.trackOff, colors.trackOn, progress)! : colors.trackDisabled,
      )
      ..drawPath(
        _shape.getOuterPath(thumb),
        _paint..color = enabled ? Color.lerp(colors.thumbOff, colors.thumbOn, progress)! : colors.thumbDisabled,
      );
  }

  @override
  bool shouldRepaint(_MateoTogglePainter oldDelegate) =>
      oldDelegate.position != position ||
      oldDelegate.colors != colors ||
      oldDelegate.enabled != enabled ||
      oldDelegate.direction != direction;
}
