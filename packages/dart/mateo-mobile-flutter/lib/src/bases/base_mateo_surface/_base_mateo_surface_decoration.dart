part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceDecoration extends ShapeDecoration {
  const _BaseMateoSurfaceDecoration({
    required Color super.color,
    required MateoRoundedShapeBorder super.shape,
    required List<BoxShadow> super.shadows,
  });

  @override
  bool get isComplex => shadows!.isNotEmpty;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _BaseMateoSurfaceDecorationPainter(this, onChanged);
}
