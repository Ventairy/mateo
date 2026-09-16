part of 'mateo_button.dart';

/// Builds an icon-only button from its resolved state and recommended size.
typedef MateoIconButtonIconBuilder = Widget Function(MateoIconButtonIconState state);

/// Builds a Mateo button icon from its current state.
typedef MateoButtonIconBuilder = Widget Function(MateoButtonState state);
