part of 'mateo_toast.dart';

/// Shows [toast] above the navigation of the enclosing Mateo app.
///
/// Lets the current toast leave before bringing in the new toast. During a
/// handoff, only the latest waiting toast is retained. Reduced motion switches
/// immediately. [duration] selects estimated reading time, a custom timeout,
/// or no timeout. [dismissible] controls swipe and tap dismissal. A toast's
/// [MateoToast.onPressed] action still runs when [dismissible] is false.
/// [delay] waits before requesting the toast. A delayed toast can replace a
/// newer toast when its delay ends. The returned [MateoToastController] can
/// cancel that request or dismiss only its toast. [dismissMateoToast] remains
/// enabled for every duration. [padding] is applied inside the top and side
/// safe areas.
///
/// [delay] must be nonnegative. The visible [duration] begins when the toast
/// appears, including after a handoff from an earlier toast.
/// Throws [FlutterError] when [context] is not below a Mateo app's toast host.
///
/// ```dart
/// final toastController = showMateoToast(
///   context: context,
///   toast: const MateoToast(message: 'Changes saved', status: .success),
///   delay: const Duration(seconds: 1),
/// );
/// // If the message becomes irrelevant: toastController.dismiss();
/// ```
MateoToastController showMateoToast({
  required BuildContext context,
  required MateoToast toast,
  MateoToastDuration duration = const .auto(),
  Duration delay = Duration.zero,
  bool dismissible = true,
  EdgeInsetsGeometry padding = const .symmetric(horizontal: 20, vertical: 12),
}) {
  if (delay.isNegative) throw ArgumentError.value(delay, 'delay', 'must be nonnegative');
  final host = context.findAncestorStateOfType<_MateoToastHostState>();
  if (host == null) {
    throw FlutterError('showMateoToast requires a context below MateoApp or MateoApp.router.');
  }
  final theme = MateoTheme.of(context);
  final direction = Directionality.of(context);
  final textScaler = MediaQuery.textScalerOf(context);
  final reducedMotion = MediaQuery.disableAnimationsOf(context);
  final locale = Localizations.maybeLocaleOf(context);
  return host.show(
    (overlayKey, onDismissed) {
      final overlay = Directionality(
        textDirection: direction,
        child: _MateoToastOverlay(
          key: overlayKey,
          toast: toast,
          duration: duration,
          dismissible: dismissible,
          padding: padding,
          onDismissed: onDismissed,
        ),
      );
      return MateoTheme(
        data: theme,
        child: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler, disableAnimations: reducedMotion),
            child: locale == null ? overlay : Localizations.override(context: context, locale: locale, child: overlay),
          ),
        ),
      );
    },
    delay: delay,
  );
}

/// Dismisses the current toast in the enclosing Mateo app.
///
/// Cancels any waiting replacement and lets the current toast animate out.
/// Independently delayed toasts can still appear later.
/// Reduced motion removes the toast immediately. Does nothing when no toast
/// exists. Touch dismissal settings do not prevent programmatic dismissal.
/// Throws [FlutterError] when [context] is not below a Mateo app's toast host.
///
/// ```dart
/// dismissMateoToast(context: context);
/// ```
void dismissMateoToast({required BuildContext context}) {
  final host = context.findAncestorStateOfType<_MateoToastHostState>();
  if (host == null) {
    throw FlutterError('dismissMateoToast requires a context below MateoApp or MateoApp.router.');
  }
  host.dismiss();
}

typedef _MateoToastBuilder = Widget Function(GlobalKey<_MateoToastOverlayState> overlayKey, VoidCallback onDismissed);
typedef _MateoToastRequest = ({MateoToastController controller, _MateoToastBuilder builder});

@internal
class MateoToastHost extends StatefulWidget {
  const MateoToastHost({required this.child, super.key});
  final Widget child;

  @override
  State<MateoToastHost> createState() => _MateoToastHostState();
}

class _MateoToastHostState extends State<MateoToastHost> {
  Widget? _toast;
  GlobalKey<_MateoToastOverlayState>? _overlayKey;
  _MateoToastRequest? _currentRequest;
  _MateoToastRequest? _pendingRequest;
  final Set<MateoToastController> _controllers = {};
  final Map<MateoToastController, Timer> _delayTimers = {};

  MateoToastController show(_MateoToastBuilder builder, {required Duration delay}) {
    final controller = MateoToastController._(this);
    final request = (controller: controller, builder: builder);
    _controllers.add(controller);
    if (delay > Duration.zero) {
      _delayTimers[controller] = Timer(delay, () {
        _delayTimers.remove(controller);
        if (mounted && _controllers.contains(controller)) _showRequest(request);
      });
    } else {
      _showRequest(request);
    }
    return controller;
  }

  void _showRequest(_MateoToastRequest request) {
    final overlay = _overlayKey?.currentState;
    if (overlay == null) {
      // Requests before the first frame can replace content that has not appeared.
      setState(() => _install(request));
      return;
    }
    if (_pendingRequest case final pendingRequest?) _retire(pendingRequest.controller);
    _pendingRequest = request;
    overlay.dismiss();
  }

  void dismiss() {
    if (_pendingRequest case final pendingRequest?) _retire(pendingRequest.controller);
    _pendingRequest = null;
    if (_toast == null) return;
    final overlay = _overlayKey?.currentState;
    if (overlay != null) {
      overlay.dismiss();
      return;
    }
    setState(() {
      if (_currentRequest case final currentRequest?) _retire(currentRequest.controller);
      _currentRequest = null;
      _overlayKey = null;
      _toast = null;
    });
  }

  void _dismissRequest(MateoToastController controller) {
    if (!_controllers.contains(controller)) return;
    _retire(controller);
    if (_pendingRequest?.controller == controller) {
      _pendingRequest = null;
      return;
    }
    if (_currentRequest?.controller != controller) return;
    final overlay = _overlayKey?.currentState;
    if (overlay != null) {
      overlay.dismiss();
      return;
    }
    setState(() {
      _currentRequest = null;
      _overlayKey = null;
      _toast = null;
    });
  }

  void _retire(MateoToastController controller) {
    _controllers.remove(controller);
    _delayTimers.remove(controller)?.cancel();
    controller._finish();
  }

  void _install(_MateoToastRequest request) {
    if (_currentRequest case final currentRequest?) _retire(currentRequest.controller);
    final overlayKey = GlobalKey<_MateoToastOverlayState>();
    _currentRequest = request;
    _overlayKey = overlayKey;
    _pendingRequest = null;
    _toast = request.builder(overlayKey, () {
      if (!mounted || !identical(_overlayKey, overlayKey)) return;
      setState(() {
        if (_pendingRequest case final pendingRequest?) {
          _install(pendingRequest);
          return;
        }
        _retire(request.controller);
        _currentRequest = null;
        _overlayKey = null;
        _toast = null;
      });
    });
  }

  @override
  void dispose() {
    _controllers.toList().forEach(_retire);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: .expand,
    children: [
      widget.child,
      if (_toast case final toast?) Positioned(top: 0, left: 0, right: 0, child: toast),
    ],
  );
}
