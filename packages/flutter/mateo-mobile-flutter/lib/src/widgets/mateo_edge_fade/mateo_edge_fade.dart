import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

part 'mateo_edge_fade_enums.dart';
part 'mateo_edge_fade_style.dart';

/// A Mateo Mobile edge-fade gradient that fades content at a screen edge.
///
/// Renders a vertical [LinearGradient] that fades from an opaque
/// `style.color` at the chosen [position] to fully transparent, wrapped in
/// an [IgnorePointer] and [RepaintBoundary] so it never intercepts hit-testing
/// and never triggers repaints of the content beneath it.
///
/// ## Usage
///
/// The widget is **not** self-positioning. Place it inside a [Stack] using a
/// [Positioned] at the matching screen edge. The [position] prop only
/// controls which end of the gradient is opaque.
///
/// ```dart
/// Stack(
///   children: [
///     const Positioned.fill(child: MyFeed()),
///     Positioned(
///       top: 0, left: 0, right: 0,
///       child: MateoEdgeFade(position: MateoEdgeFadePosition.top),
///     ),
///     Positioned(
///       bottom: 0, left: 0, right: 0,
///       child: MateoEdgeFade(position: MateoEdgeFadePosition.bottom),
///     ),
///   ],
/// )
/// ```
///
/// See also:
///  * [MateoEdgeFadePosition], the screen edges supported by this widget.
///  * [MateoEdgeFadeStyle], the visual configuration consumed by this widget.
class MateoEdgeFade extends StatefulWidget {
  /// Creates a Mateo Mobile edge-fade gradient.
  const MateoEdgeFade({
    required this.position,
    super.key,
    this.style = const MateoEdgeFadeStyle(),
  });

  /// Which screen edge the gradient fades from.
  ///
  /// Drives the gradient's opaque-to-transparent direction. The consumer must
  /// place the widget at the matching edge via [Positioned].
  final MateoEdgeFadePosition position;

  /// Visual configuration of the fade
  ///
  /// When `null`, defaults to a [MateoEdgeFadeStyle] whose `null` fields resolve
  /// at build time (color → theme background, height → viewport factor).
  final MateoEdgeFadeStyle style;

  @override
  State<MateoEdgeFade> createState() => _MateoEdgeFadeState();
}

class _MateoEdgeFadeState extends State<MateoEdgeFade> {
  static const int _curveSegmentCount = 32;

  static final List<double> _gradientStops = List<double>.unmodifiable([
    for (var index = 0; index <= _curveSegmentCount; index++)
      index / _curveSegmentCount,
  ]);

  static double _smoothFadeOpacity(double progress) {
    final progressSquared = progress * progress;
    final progressCubed = progressSquared * progress;
    final smootherStep = progressCubed * (progress * (progress * 6 - 15) + 10);

    return 1 - smootherStep;
  }

  static List<Color> _resolveGradientColors(Color color) {
    return <Color>[
      color,
      for (var index = 1; index <= _curveSegmentCount; index++)
        color.withValues(
          alpha: color.a * _smoothFadeOpacity(index / _curveSegmentCount),
        ),
    ];
  }

  Color? _cachedColor;
  MateoEdgeFadePosition? _cachedPosition;
  late LinearGradient _cachedGradient;

  static (Alignment, Alignment) _resolveGradientAlignment(
    MateoEdgeFadePosition position,
  ) {
    return switch (position) {
      MateoEdgeFadePosition.top => (
        Alignment.topCenter,
        Alignment.bottomCenter,
      ),
      MateoEdgeFadePosition.bottom => (
        Alignment.bottomCenter,
        Alignment.topCenter,
      ),
    };
  }

  LinearGradient _resolveGradient(Color color) {
    if (_cachedColor == color && _cachedPosition == widget.position) {
      return _cachedGradient;
    }

    _cachedColor = color;
    _cachedPosition = widget.position;
    final (begin, end) = _resolveGradientAlignment(widget.position);

    return _cachedGradient = LinearGradient(
      begin: begin,
      end: end,
      stops: _gradientStops,
      colors: _resolveGradientColors(color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolved = widget.style.resolve(context);
    final resolvedColor = resolved.color!;

    return SizedBox(
      height: resolved.height,
      child: IgnorePointer(
        child: RepaintBoundary(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: _resolveGradient(resolvedColor),
            ),
          ),
        ),
      ),
    );
  }
}
