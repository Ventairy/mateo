part of 'base_mateo_surface.dart';

// Retain the first surface in each scroll-content branch. Ordinary surfaces
// stop the scope so nested controls do not each acquire another boundary.
class _BaseMateoSurfaceRepaintScope extends InheritedWidget {
  const _BaseMateoSurfaceRepaintScope({required this.controller, required super.child});

  final _BaseMateoSurfaceScrollController? controller;

  static _BaseMateoSurfaceScrollController? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BaseMateoSurfaceRepaintScope>()?.controller;

  @override
  bool updateShouldNotify(_BaseMateoSurfaceRepaintScope oldWidget) => controller != oldWidget.controller;
}
