part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceScroll extends StatelessWidget {
  const _BaseMateoSurfaceScroll({required this.controller, required this.child});

  final ScrollController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    controller: controller,
    primary: false,
    clipBehavior: Clip.none,
    slivers: [SliverFillRemaining(hasScrollBody: false, child: child)],
  );
}
