part of 'mateo_toggle.dart';

/// A listenable controller for reading and changing a [MateoToggle].
///
/// The controller stores the toggle's logical [value]. Calls to [setValue]
/// and [toggle] notify listeners synchronously, then return a future that
/// completes when an attached toggle finishes its visual transition. Commands
/// issued while detached update [value] and complete immediately.
///
/// A controller can be attached to only one [MateoToggle] at a time. Call
/// [dispose] after the attached toggle has been removed.
///
/// See also:
///  * [MateoToggle], which owns an internal controller when none is supplied.
class MateoToggleController extends ChangeNotifier implements ValueListenable<bool> {
  /// Creates a toggle controller with an optional initial [value].
  // The public parameter name intentionally differs from the private field.
  // ignore: prefer_initializing_formals
  MateoToggleController({bool value = false}) : _value = value;

  _MateoToggleControllerClient? _client;
  Future<void> _animation = Future<void>.value();
  bool _value;

  /// Whether this controller is attached to a [MateoToggle].
  bool get hasClients => _client != null;

  /// Whether the controlled toggle is on.
  @override
  bool get value => _value;

  /// Sets the logical [value] and waits for its visual transition.
  ///
  /// Listeners are notified synchronously when [value] changes. If another
  /// command supersedes this one, the returned future completes when the
  /// interrupted transition stops. Calling this with the current value returns
  /// the active transition future, or an already-completed future at rest.
  Future<void> setValue(
    // Matches Flutter's positional boolean control APIs.
    // ignore: avoid_positional_boolean_parameters
    bool value,
  ) {
    if (_value == value) return _animation;

    _value = value;
    _animation = _client?.setToggleValue(value) ?? Future<void>.value();
    notifyListeners();
    return _animation;
  }

  /// Reverses [value] and waits for its visual transition.
  Future<void> toggle() => setValue(!_value);

  /// Releases listeners and detaches this controller from its toggle.
  ///
  /// Call this only after the attached [MateoToggle] has been removed.
  @override
  void dispose() {
    _client = null;
    super.dispose();
  }

  FlutterError? _attach(_MateoToggleControllerClient client) {
    if (_client != null && !identical(_client, client)) {
      return FlutterError(
        'A MateoToggleController can only be attached to one MateoToggle at a time.',
      );
    }

    _client = client;
    return null;
  }

  void _detach(_MateoToggleControllerClient client) {
    if (identical(_client, client)) _client = null;
  }
}

// The interface gives the controller an attachable client identity.
// ignore: one_member_abstracts
abstract interface class _MateoToggleControllerClient {
  Future<void> setToggleValue(
    // Mirrors the controller's positional boolean API internally.
    // ignore: avoid_positional_boolean_parameters
    bool value,
  );
}
