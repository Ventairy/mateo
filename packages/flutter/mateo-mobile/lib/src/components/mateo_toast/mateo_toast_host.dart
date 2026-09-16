part of 'show_mateo_toast.dart';

typedef _MateoToastBuilder = Widget Function(GlobalKey<_MateoToastOverlayState> overlayKey, VoidCallback onDismissed);

/// The app-owned toast layer above [child].
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
    overlay.dismissForReplacement();
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
