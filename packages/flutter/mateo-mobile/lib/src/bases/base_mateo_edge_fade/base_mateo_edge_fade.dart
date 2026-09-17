import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'mateo_edge_fade_band.dart';
import 'mateo_edge_fade_band_paint.dart';

import 'mateo_edge_fade_painter.dart';

@internal
class BaseMateoEdgeFade extends StatefulWidget {
  // The nullable storage distinguishes the mask without a second mode flag.
  const BaseMateoEdgeFade.overlay({
    required Color this.color,
    required this.resolveBands,
    required this.child,
    this.repaint,
    super.key,
  });

  const BaseMateoEdgeFade.mask({required this.resolveBands, required this.child, this.repaint, super.key})
    : color = null;

  final Color? color;
  final List<MateoEdgeFadeBand> Function(Size size) resolveBands;
  final Listenable? repaint;
  final Widget child;

  @override
  State<BaseMateoEdgeFade> createState() => _BaseMateoEdgeFadeState();
}

class _BaseMateoEdgeFadeState extends State<BaseMateoEdgeFade> {
  final List<MateoEdgeFadeBandPaint> _bands = [];

  @override
  Widget build(BuildContext context) {
    if (widget.color case final color? when color.a != 1) {
      throw ArgumentError.value(color, 'color', 'An overlay requires an opaque color.');
    }
    final painted = CustomPaint(
      foregroundPainter: MateoEdgeFadePainter(
        color: widget.color,
        resolveBands: widget.resolveBands,
        signal: widget.repaint,
        bands: _bands,
      ),
      child: widget.child,
    );
    if (widget.color != null) return painted;
    // Isolate the entire layer subtree, including composited children, before
    // removing alpha. A canvas saveLayer around paintChild cannot do this.
    return ColorFiltered(
      colorFilter: const .mode(Color(0xFFFFFFFF), .modulate),
      child: painted,
    );
  }
}
