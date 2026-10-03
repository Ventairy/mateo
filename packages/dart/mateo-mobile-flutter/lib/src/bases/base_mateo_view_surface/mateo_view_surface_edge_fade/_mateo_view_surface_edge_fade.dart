part of '../base_mateo_view_surface.dart';

final class _MateoViewSurfaceEdgeFade extends StatelessWidget {
  _MateoViewSurfaceEdgeFade({
    required this.surfaceColor,
    required this.contentTopPadding,
    required Set<MateoEdgeEffectSide> sides,
    required this.child,
    this.leadingScrollDistance,
  }) : sides = Set.unmodifiable(sides);

  static const double _headerFractionOfFade = .55;

  static final _footerFadeProfile = _MateoViewSurfaceFooterFadeProfile();

  static final _headerFadeProfile = _MateoViewSurfaceHeaderFadeProfile();

  final ValueListenable<double>? leadingScrollDistance;
  final Color surfaceColor;
  final double contentTopPadding;
  final Set<MateoEdgeEffectSide> sides;
  final Widget child;

  List<MateoEdgeFadeBand> _resolveBands(Size size, MateoViewLayoutScope view) {
    final header = view.header;
    final footer = view.footer;
    final contextualTop = header != null && sides.contains(MateoEdgeEffectSide.top);
    final contextualBottom = footer != null && sides.contains(MateoEdgeEffectSide.bottom);

    final defaults = DefaultMateoSurfaceEdgeFade.resolveBands(
      size: size,
      sides: sides.difference({
        if (contextualTop) MateoEdgeEffectSide.top,
        if (contextualBottom) MateoEdgeEffectSide.bottom,
      }),
    );

    if (size.isEmpty) return defaults;

    final bands = [...defaults];

    if (contextualTop) {
      final obstructionDepth = view.headerObstructionExtent + contentTopPadding;
      if (obstructionDepth > 0) {
        final protectedDepth = header.bottomOffset / _headerFractionOfFade;
        final extension = (protectedDepth - obstructionDepth).clamp(0, double.infinity);
        final growthDistance = contentTopPadding > 0 ? contentTopPadding : view.defaultContentGap;
        final progress = ((leadingScrollDistance?.value ?? 0) / growthDistance).clamp(0, 1);
        final growth = progress * (2 - progress);
        bands.insert(
          0,
          .top(
            extent: obstructionDepth + extension * growth,
            profile: _headerFadeProfile,
          ),
        );
      }
    }

    if (contextualBottom) {
      bands.add(
        .bottom(
          extent: (footer.height - footer.topOffset).clamp(0, double.infinity),
          profile: _footerFadeProfile,
        ),
      );
    }
    return bands;
  }

  @override
  Widget build(BuildContext context) {
    final view = MateoViewLayoutScope.maybeOf(context);
    assert(view != null, '_MateoViewSurfaceEdgeFade requires a BaseMateoView ancestor.');
    if (sides.isEmpty) return child;
    final repaint = Listenable.merge([view!.headerChanges, view.footerChanges, leadingScrollDistance]);

    final painted = CustomPaint(
      foregroundPainter: _MateoViewSurfaceEdgeFadePainter(
        color: surfaceColor.a == 1 ? surfaceColor : null,
        resolveBands: (size) => _resolveBands(size, view),
        view: view,
        repaint: repaint,
      ),
      child: child,
    );
    if (surfaceColor.a == 1) return painted;
    return ColorFiltered(
      colorFilter: const .mode(Color(0xFFFFFFFF), .modulate),
      child: painted,
    );
  }
}
