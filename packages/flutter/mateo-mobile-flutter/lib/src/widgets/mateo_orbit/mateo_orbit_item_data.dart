part of 'mateo_orbit.dart';

/// Per-item data for computing animated orbit positions.
class _MateoOrbitItemData {
  const _MateoOrbitItemData({
    required this.size,
    required this.cosBase,
    required this.sinBase,
    required this.cachedChild,
  });

  final Size size;
  final double cosBase;
  final double sinBase;
  final Widget cachedChild;
}
