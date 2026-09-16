part of '../mateo_surface.dart';

/// Builds a host around [surface] with its optional managed scroll controller.
@internal
typedef MateoSurfaceHostBuilder = Widget Function(
  BuildContext context,
  MateoSurface surface,
  ScrollController? managedScrollController,
);

/// A package-internal owner used when another component hosts a surface.
///
/// The host keeps scroll-controller ownership in the surface domain while
/// allowing an interoperable component to place layers around [surface].
@internal
final class MateoSurfaceHost extends StatefulWidget {
  /// Creates a host for [surface] using [builder].
  const MateoSurfaceHost({
    required this.surface,
    required this.builder,
    super.key,
  });

  /// Surface mounted by [builder].
  final MateoSurface surface;

  /// Builder that composes the surface with its surrounding component.
  final MateoSurfaceHostBuilder builder;

  @override
  State<MateoSurfaceHost> createState() => _MateoSurfaceHostState();
}

class _MateoSurfaceHostState extends State<MateoSurfaceHost> {
  ScrollController? _controller;

  void _synchronizeController() {
    if (widget.surface._scrollable) {
      _controller ??= _MateoSurfaceScrollController();
      return;
    }
    _controller?.dispose();
    _controller = null;
  }

  @override
  void initState() {
    super.initState();
    _synchronizeController();
  }

  @override
  void didUpdateWidget(MateoSurfaceHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _synchronizeController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final content = _MateoSurfaceHostScope(
      surface: widget.surface,
      controller: controller,
      child: Builder(
        builder: (context) => widget.builder(
          context,
          widget.surface,
          controller,
        ),
      ),
    );
    if (controller == null) return content;
    return PrimaryScrollController(
      controller: controller,
      child: content,
    );
  }
}

final class _MateoSurfaceHostScope extends InheritedWidget {
  const _MateoSurfaceHostScope({
    required this.surface,
    required this.controller,
    required super.child,
  });

  final MateoSurface surface;
  final ScrollController? controller;

  static _MateoSurfaceHostScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MateoSurfaceHostScope>();

  @override
  bool updateShouldNotify(_MateoSurfaceHostScope oldWidget) =>
      !identical(surface, oldWidget.surface) || !identical(controller, oldWidget.controller);
}
