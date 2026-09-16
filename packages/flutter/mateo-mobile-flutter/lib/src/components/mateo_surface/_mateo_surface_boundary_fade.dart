part of '../mateo_surface.dart';

final class _MateoSurfaceBoundaryFade extends StatefulWidget {
  const _MateoSurfaceBoundaryFade({
    required this.position,
    required this.color,
    required this.extent,
    super.key,
  });

  final _MateoSurfaceBoundaryPosition position;
  final Color color;
  final double extent;

  @override
  State<_MateoSurfaceBoundaryFade> createState() => _MateoSurfaceBoundaryFadeState();
}

final class _MateoSurfaceBoundaryFadeState extends State<_MateoSurfaceBoundaryFade> {
  static final List<double> _gradientStops = List<double>.unmodifiable([
    for (var index = 0; index <= MateoSurface._boundaryFadeSegmentCount; index++)
      index / MateoSurface._boundaryFadeSegmentCount,
  ]);

  Color? _cachedColor;
  _MateoSurfaceBoundaryPosition? _cachedPosition;
  late LinearGradient _cachedGradient;

  LinearGradient _resolveGradient() {
    if (_cachedColor == widget.color && _cachedPosition == widget.position) {
      return _cachedGradient;
    }
    _cachedColor = widget.color;
    _cachedPosition = widget.position;
    final isTop = widget.position == _MateoSurfaceBoundaryPosition.top;
    return _cachedGradient = LinearGradient(
      begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
      stops: _gradientStops,
      colors: <Color>[
        widget.color,
        for (var index = 1; index <= MateoSurface._boundaryFadeSegmentCount; index++)
          widget.color.withValues(
            alpha:
                widget.color.a *
                (1 -
                    MateoSurface._passingContentVisibility(
                      index / MateoSurface._boundaryFadeSegmentCount,
                    )),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.extent,
      child: IgnorePointer(
        child: RepaintBoundary(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: _resolveGradient()),
          ),
        ),
      ),
    );
  }
}
