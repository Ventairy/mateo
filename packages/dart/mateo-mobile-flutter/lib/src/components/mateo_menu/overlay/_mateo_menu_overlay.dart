part of 'show_mateo_menu.dart';

class _MateoMenuOverlay extends StatelessWidget {
  const _MateoMenuOverlay({required this.route, required this.child});
  final _MateoMenuRoute route;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final inset = route.menu.presentation.density.screenEdgeInset;
    final padding = EdgeInsets.fromLTRB(
      math.max(safePadding.left, viewInsets.left) + inset,
      math.max(safePadding.top, viewInsets.top) + inset,
      math.max(safePadding.right, viewInsets.right) + inset,
      math.max(safePadding.bottom, viewInsets.bottom) + inset,
    );

    return CustomSingleChildLayout(
      delegate: _MateoMenuLayout(
        anchorBounds: route.anchorBounds,
        padding: padding,
        placement: route.placement,
      ),
      child: child,
    );
  }
}
