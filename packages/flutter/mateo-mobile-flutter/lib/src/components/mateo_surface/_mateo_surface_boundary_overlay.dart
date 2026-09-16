part of '../mateo_surface.dart';

final class _MateoSurfaceBoundaryOverlay extends StatelessWidget {
  const _MateoSurfaceBoundaryOverlay({
    required this.color,
    required this.effect,
    required this.resolveExtent,
  });

  final Color color;
  final MateoBoundaryEffect effect;
  final double Function(double height, MateoBoundaryEffect effect) resolveExtent;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final extent = resolveExtent(constraints.maxHeight, effect);
            return Stack(
              fit: StackFit.expand,
              children: [
                if (effect.top && extent > 0)
                  Align(
                    alignment: Alignment.topCenter,
                    child: _MateoSurfaceBoundaryFade(
                      key: const ValueKey('mateo_surface_boundary_fade_top'),
                      position: _MateoSurfaceBoundaryPosition.top,
                      color: color,
                      extent: extent,
                    ),
                  ),
                if (effect.bottom && extent > 0)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _MateoSurfaceBoundaryFade(
                      key: const ValueKey('mateo_surface_boundary_fade_bottom'),
                      position: _MateoSurfaceBoundaryPosition.bottom,
                      color: color,
                      extent: extent,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
