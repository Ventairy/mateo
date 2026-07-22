part of 'mateo_toast.dart';

/// Manages [MateoToast] entries and keeps them above navigator-owned overlays.
///
/// [MateoApp.new] and [MateoApp.router] auto-inject a [MateoToastMessenger] above the
/// navigation surface so toasts always paint above the needed content.
/// [MateoToast.show] finds the nearest [MateoToastMessenger] via the provided
/// [BuildContext].
///
/// ## Without MateoApp
///
/// When an application must keep its own [MaterialApp], install the messenger
/// through [MaterialApp.builder]. Wrapping the builder's [child] places the
/// messenger above the [Navigator] and its route overlays.
///
/// ```dart
/// MaterialApp(
///   theme: MateoTheme.light(
///     primaryColor: const Color(0xFF8E51FF),
///     onPrimary: const Color(0xFFFFFFFF),
///   ),
///   home: const Scaffold(
///     body: Center(child: Text('Home')),
///   ),
///   builder: (context, child) {
///     return MateoToastMessenger(
///       child: child ?? const SizedBox.shrink(),
///     );
///   },
/// )
/// ```
///
/// After installing the messenger, call [MateoToast.show] from any descendant
/// [BuildContext] as usual.
///
/// See also:
///  * [MateoToast.show], the API that inserts toast messages into this messenger.
///  * [MateoApp], which auto-injects this messenger for both navigation modes.
class MateoToastMessenger extends StatefulWidget {
  /// Creates a toast messenger around [child].
  ///
  /// The [child] subtree renders below toast overlay entries.
  const MateoToastMessenger({required this.child, super.key});

  /// The subtree that renders below toast overlay entries.
  final Widget child;

  @override
  State<MateoToastMessenger> createState() => MateoToastMessengerState();

  /// Finds the nearest [MateoToastMessengerState] ancestor of [context].
  ///
  /// Returns null if no messenger is mounted above [context].
  static MateoToastMessengerState? maybeOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_MateoToastMessengerScope>();
    return scope?._state;
  }
}

class MateoToastMessengerState extends State<MateoToastMessenger> {
  final GlobalKey<OverlayState> _overlayKey = GlobalKey<OverlayState>();
  late final OverlayEntry _childEntry = OverlayEntry(
    builder: (_) => widget.child,
  );

  _MateoToastPresentation? _activePresentation;

  /// The overlay this messenger renders toast entries into.
  OverlayState? get overlay => _overlayKey.currentState;

  /// Removes the currently active toast, if any.
  void dismissActive() {
    _activePresentation?.remove();
    _activePresentation = null;
  }

  @override
  void didUpdateWidget(MateoToastMessenger oldWidget) {
    super.didUpdateWidget(oldWidget);
    _childEntry.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return _MateoToastMessengerScope(
      state: this,
      child: Overlay(key: _overlayKey, initialEntries: [_childEntry]),
    );
  }
}

class _MateoToastMessengerScope extends InheritedWidget {
  const _MateoToastMessengerScope({required this._state, required super.child});

  final MateoToastMessengerState _state;

  @override
  bool updateShouldNotify(_MateoToastMessengerScope old) =>
      _state != old._state;
}
