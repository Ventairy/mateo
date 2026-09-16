part of 'base_mateo_edge_fade.dart';

class _BaseMateoEdgeFadePainter extends CustomPainter {
  _BaseMateoEdgeFadePainter({required this.color, required this.resolveBands, required this.bands, this.signal})
    : super(repaint: signal);

  final Listenable? signal;
  final Color? color;
  final List<MateoEdgeFadeBand> Function(Size) resolveBands;
  final List<_BaseMateoEdgeFadeBandPaint> bands;

  @override
  void paint(Canvas canvas, Size size) {
    final resolved = resolveBands(size);
    var count = 0;
    if (!size.isEmpty) {
      for (final band in resolved) {
        if (band.extent == 0) continue;
        if (count == bands.length) bands.add(_BaseMateoEdgeFadeBandPaint());
        bands[count++].paint(canvas, size, band, color);
      }
    }
    // Retain only resources used by the current frame, never a size history.
    bands.length = count;
  }

  @override
  bool shouldRepaint(_BaseMateoEdgeFadePainter oldDelegate) =>
      color != oldDelegate.color || resolveBands != oldDelegate.resolveBands || signal != oldDelegate.signal;

  @override
  bool? hitTest(Offset position) => false;
}
