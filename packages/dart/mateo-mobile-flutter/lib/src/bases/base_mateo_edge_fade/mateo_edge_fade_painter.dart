import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'mateo_edge_fade_band.dart';
import 'mateo_edge_fade_band_paint.dart';

@internal
class MateoEdgeFadePainter extends CustomPainter {
  MateoEdgeFadePainter({required this.color, required this.resolveBands, required this.bands, this.signal})
    : super(repaint: signal);

  final Listenable? signal;
  final Color? color;
  final List<MateoEdgeFadeBand> Function(Size) resolveBands;
  final List<MateoEdgeFadeBandPaint> bands;

  @override
  void paint(Canvas canvas, Size size) {
    final resolved = resolveBands(size);
    var count = 0;
    if (!size.isEmpty) {
      for (final band in resolved) {
        if (band.extent == 0) continue;
        if (count == bands.length) bands.add(MateoEdgeFadeBandPaint());
        bands[count++].paint(canvas, bandSize(size, band), band, color);
      }
    }
    // Retain only resources used by the current frame, never a size history.
    bands.length = count;
  }

  Size bandSize(Size size, MateoEdgeFadeBand band) => size;

  @override
  bool shouldRepaint(MateoEdgeFadePainter oldDelegate) =>
      color != oldDelegate.color || resolveBands != oldDelegate.resolveBands || signal != oldDelegate.signal;

  @override
  bool? hitTest(Offset position) => false;
}
