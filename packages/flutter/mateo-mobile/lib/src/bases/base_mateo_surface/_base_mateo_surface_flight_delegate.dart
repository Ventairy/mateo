part of 'base_mateo_surface.dart';

typedef _BaseMateoSurfaceFlightProperties = ({Color color, ShapeBorder shape, Size size});

final class _BaseMateoSurfaceFlightDelegate extends MorphFlightDelegate<_BaseMateoSurfaceFlightProperties> {
  _BaseMateoSurfaceFlightDelegate({required this.color, required this.shape});

  final Color color;
  final ShapeBorder shape;
  MateoRoundedConvexInterpolation? _interpolation;

  @override
  _BaseMateoSurfaceFlightProperties properties(MorphEndpointContext endpoint) => (
    color: color,
    shape: endpoint.localSize == endpoint.overlayBounds.size
        ? shape
        : _BaseMateoSurfaceScaledBorder(shape: shape, size: endpoint.localSize),
    size: endpoint.overlayBounds.size,
  );

  @override
  _BaseMateoSurfaceFlightProperties lerpProperties(
    _BaseMateoSurfaceFlightProperties source,
    _BaseMateoSurfaceFlightProperties destination,
    double progress,
  ) {
    final begin = (shape: source.shape, size: source.size);
    final end = (shape: destination.shape, size: destination.size);
    var interpolation = _interpolation;
    if (interpolation == null || interpolation.begin != begin || interpolation.end != end) {
      _interpolation = interpolation = MateoRoundedConvexInterpolation(begin: begin, end: end);
    }
    final frame = interpolation.lerp(progress);
    return (color: Color.lerp(source.color, destination.color, progress)!, shape: frame.border, size: frame.size);
  }

  @override
  Widget buildFlight(BuildContext context, MorphFlight<_BaseMateoSurfaceFlightProperties> flight) => AnimatedBuilder(
    animation: flight.curvedAnimation,
    builder: (context, child) {
      final properties = flight.properties;
      return DecoratedBox(
        decoration: ShapeDecoration(color: properties.color, shape: properties.shape),
      );
    },
  );
}
