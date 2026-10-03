part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceScrollPosition extends ScrollPositionWithSingleContext {
  _BaseMateoSurfaceScrollPosition({
    required super.physics,
    required super.context,
    required super.oldPosition,
    required this.onDistanceChanged,
  });

  final ValueChanged<double> onDistanceChanged;

  void _reportDistance() => onDistanceChanged(
    hasPixels && hasContentDimensions && maxScrollExtent > minScrollExtent
        ? (pixels - minScrollExtent).clamp(0, double.infinity)
        : 0,
  );

  @override
  void notifyListeners() {
    _reportDistance();
    super.notifyListeners();
  }

  // Layout corrections deliberately bypass normal scroll listeners. Only the
  // paint signal is updated here; do not dispatch widget or scroll notifications.
  @override
  void correctPixels(double value) {
    super.correctPixels(value);
    _reportDistance();
  }

  @override
  void correctBy(double correction) {
    super.correctBy(correction);
    _reportDistance();
  }

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    final accepted = super.applyContentDimensions(minScrollExtent, maxScrollExtent);
    _reportDistance();
    return accepted;
  }
}
