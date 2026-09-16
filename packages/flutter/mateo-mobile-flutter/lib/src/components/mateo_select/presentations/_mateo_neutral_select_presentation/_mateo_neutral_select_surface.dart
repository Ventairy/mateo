part of '../../mateo_select.dart';

final class _MateoNeutralSelectSurface extends StatelessWidget {
  const _MateoNeutralSelectSurface({
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
              painter: _MateoNeutralSelectSurfacePainter(
                animation: animation,
                triggerRect: triggerRect,
                triggerColor: colorScheme.background,
                menuColor: menuColorScheme.background,
              ),
            ),
          ),
          ClipRRect(
            clipper: _MateoNeutralSelectSurfaceClipper(
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
