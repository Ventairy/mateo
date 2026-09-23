part of 'mateo_toast.dart';

/// Shows [toast] above the navigation of the enclosing Mateo app.
///
/// Lets the current toast leave before bringing in the new toast. During a
/// handoff, only the latest waiting toast is retained. Reduced motion switches
/// immediately. [duration] overrides the estimated
/// reading time. [dismissible] controls swipe and tap dismissal. A toast's
/// [MateoToast.onPressed] action still runs when [dismissible] is false.
/// Automatic dismissal and [dismissMateoToast] remain enabled. [padding] is
/// applied inside the top and side safe areas.
/// Throws [FlutterError] when [context] is not below a Mateo app's toast host.
///
/// ```dart
/// showMateoToast(
///   context: context,
///   toast: const MateoToast(message: 'Changes saved', status: .success),
/// );
/// ```
void showMateoToast({
  required BuildContext context,
  required MateoToast toast,
  Duration? duration,
  bool dismissible = true,
  EdgeInsetsGeometry padding = const .symmetric(horizontal: 20, vertical: 12),
}) {
  final host = context.findAncestorStateOfType<_MateoToastHostState>();
  if (host == null) {
    throw FlutterError('showMateoToast requires a context below MateoApp or MateoApp.router.');
  }
  final theme = MateoTheme.of(context);
  final direction = Directionality.of(context);
  final textScaler = MediaQuery.textScalerOf(context);
  final reducedMotion = MediaQuery.disableAnimationsOf(context);
  final locale = Localizations.maybeLocaleOf(context);
  host.show(
    (overlayKey, onDismissed) => MateoTheme(
      data: theme,
      child: Builder(
        builder: (context) {
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
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler, disableAnimations: reducedMotion),
            child: locale == null ? overlay : Localizations.override(context: context, locale: locale, child: overlay),
          );
        },
      ),
    ),
  );
}

/// Dismisses the current toast in the enclosing Mateo app.
///
/// Cancels any waiting replacement and lets the current toast animate out.
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
  _MateoToastBuilder? _pendingToast;

  void show(_MateoToastBuilder builder) {
    final overlay = _overlayKey?.currentState;
    if (overlay == null) {
      // Requests before the first frame can replace content that has not appeared.
      setState(() => _install(builder));
      return;
    }
    _pendingToast = builder;
    overlay.dismiss();
  }

  void dismiss() {
    _pendingToast = null;
    if (_toast == null) return;
    final overlay = _overlayKey?.currentState;
    if (overlay != null) {
      overlay.dismiss();
      return;
    }
    setState(() {
      _overlayKey = null;
      _toast = null;
    });
  }

  void _install(_MateoToastBuilder builder) {
    final overlayKey = GlobalKey<_MateoToastOverlayState>();
    _overlayKey = overlayKey;
    _pendingToast = null;
    _toast = builder(overlayKey, () {
      if (!mounted || !identical(_overlayKey, overlayKey)) return;
      setState(() {
        if (_pendingToast case final pendingToast?) {
          _install(pendingToast);
          return;
        }
        _overlayKey = null;
        _toast = null;
      });
    });
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
