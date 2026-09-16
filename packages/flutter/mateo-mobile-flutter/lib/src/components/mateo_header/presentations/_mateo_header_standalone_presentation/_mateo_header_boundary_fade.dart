part of '../../mateo_header.dart';

final class _MateoHeaderBoundaryFade extends StatefulWidget {
  const _MateoHeaderBoundaryFade({
    required this.color,
    super.key,
  });

  static const double _extentFactor = 1 / 9;
  static const double _minimumExtent = 64;
  static const double _maximumExtent = 96;
  static const int _segmentCount = 32;

  static final List<double> _gradientStops = List<double>.unmodifiable([
    for (var index = 0; index <= _segmentCount; index++) index / _segmentCount,
  ]);

  static double resolveMaximumExtent(BuildContext context) {
    return (MediaQuery.sizeOf(context).height * _extentFactor).clamp(
      _minimumExtent,
      _maximumExtent,
    );
  }

  static double _passingContentVisibility(double progress) {
    final progressSquared = progress * progress;
    final progressCubed = progressSquared * progress;
    final smootherStep = progressCubed * (progress * (progress * 6 - 15) + 10);
    final midpointDistance = smootherStep - 0.5;
    final interiorStrengthBias = 0.4 * smootherStep * (1 - smootherStep) * midpointDistance * midpointDistance;
    return smootherStep * (0.12 + 0.88 * smootherStep) - interiorStrengthBias;
  }

  final Color color;

  @override
  State<_MateoHeaderBoundaryFade> createState() => _MateoHeaderBoundaryFadeState();
}

final class _MateoHeaderBoundaryFadeState extends State<_MateoHeaderBoundaryFade> {
  Color? _cachedColor;
  late LinearGradient _cachedGradient;

  LinearGradient _resolveGradient() {
    if (_cachedColor == widget.color) return _cachedGradient;
    _cachedColor = widget.color;
    return _cachedGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: _MateoHeaderBoundaryFade._gradientStops,
      colors: <Color>[
        widget.color,
        for (var index = 1; index <= _MateoHeaderBoundaryFade._segmentCount; index++)
          widget.color.withValues(
            alpha:
                widget.color.a *
                (1 -
                    _MateoHeaderBoundaryFade._passingContentVisibility(
                      index / _MateoHeaderBoundaryFade._segmentCount,
                    )),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: _resolveGradient()),
          ),
        ),
      ),
    );
  }
}
