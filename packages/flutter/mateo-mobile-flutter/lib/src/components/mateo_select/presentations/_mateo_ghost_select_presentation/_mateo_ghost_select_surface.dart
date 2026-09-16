part of '../../mateo_select.dart';

final class _MateoGhostSelectSurface extends StatelessWidget {
  const _MateoGhostSelectSurface({
    required this.animation,
    required this.triggerRect,
    required this.colorScheme,
    required this.menuColorScheme,
    required this.child,
  });

  final Animation<double> animation;
  final Rect triggerRect;
  final MateoSelectVariantColorScheme colorScheme;
  final MateoMenuColorScheme menuColorScheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _MateoGhostSelectSurfacePainter(
                animation: animation,
                triggerRect: triggerRect,
                triggerColor: colorScheme.background,
                menuColor: menuColorScheme.background,
              ),
            ),
          ),
          ClipRRect(
            clipper: _MateoGhostSelectSurfaceClipper(
              animation: animation,
              triggerRect: triggerRect,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
