part of 'show_mateo_sheet.dart';

class _MateoSheetStackDismissal {
  new({required this.navigator, required this.routes})
    : controller = AnimationController(
        vsync: navigator,
        duration: routes.first.reducedMotion ? Duration.zero : routes.first.from._reverseDuration,
      );

  final NavigatorState navigator;
  final List<MateoSheetRoute<dynamic>> routes;
  final AnimationController controller;
  final Completer<void> _completion = Completer<void>();
  Future<void> get completed => _completion.future;
  double distance = 0;
  bool _disposed = false;

  double get progress => 1 - routes.first.from._reverseCurve.transform(1 - controller.value);

  Future<void> start() {
    // Capture every frame before stopping any entrance or restoration clock.
    for (final route in routes) {
      route._stackEntry.freezeForDismissal();
      distance = math.max(
        distance,
        -route._stackEntry.frame.top + route._stackEntry.bottomOffset + route.from._margin.vertical,
      );
    }
    for (final route in routes) {
      route._prepareStackDismissal(this);
    }
    unawaited(_exit());
    return completed;
  }

  Future<void> _exit() async {
    try {
      await controller.forward().orCancel;
      // Remove only the captured routes, even if another route was pushed.
      for (final route in routes) {
        if (route.isActive) navigator.removeRoute(route);
      }
      await Future.wait(routes.map((route) => route.completed));
    } on TickerCanceled {
      // The navigator can be disposed while the stack is leaving.
    } finally {
      _dispose();
      _completion.complete();
    }
  }

  void routeDisposed() {
    if (routes.every((route) => route._disposed)) _dispose();
  }

  void _dispose() {
    if (_disposed) return;
    _disposed = true;
    controller.dispose();
  }
}
