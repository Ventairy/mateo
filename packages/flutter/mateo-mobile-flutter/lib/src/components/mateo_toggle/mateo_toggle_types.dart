part of 'mateo_toggle.dart';

/// Callback that receives a requested toggle value and its visual transition.
typedef MateoToggleChanged = FutureOr<void> Function(
  // Matches Flutter's positional boolean control callbacks.
  // ignore: avoid_positional_boolean_parameters
  bool value,
  Future<void> animation,
);
