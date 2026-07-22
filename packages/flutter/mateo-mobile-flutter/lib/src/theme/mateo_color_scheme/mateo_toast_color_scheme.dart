part of 'mateo_color_scheme.dart';

/// Toast-specific roles for transient messaging surfaces.
///
/// Toasts combine a shared container treatment with status accents. This group
/// keeps those roles together so transient messaging can stay consistent
/// without borrowing unrelated status or button tokens directly.
@immutable
class MateoToastColorScheme {
  /// Creates toast-specific roles for transient messaging surfaces.
  const MateoToastColorScheme({
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
    required this.neutral,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoToastColorScheme.lerp(
    MateoToastColorScheme a,
    MateoToastColorScheme b,
    double t,
  ) {
    return MateoToastColorScheme(
      success: MateoToastVariantColorScheme.lerp(a.success, b.success, t),
      error: MateoToastVariantColorScheme.lerp(a.error, b.error, t),
      warning: MateoToastVariantColorScheme.lerp(a.warning, b.warning, t),
      info: MateoToastVariantColorScheme.lerp(a.info, b.info, t),
      neutral: MateoToastVariantColorScheme.lerp(a.neutral, b.neutral, t),
    );
  }

  /// Color roles for success toasts (positive confirmation, task complete).
  final MateoToastVariantColorScheme success;

  /// Color roles for error toasts (failure, destructive action).
  final MateoToastVariantColorScheme error;

  /// Color roles for warning toasts (caution, attention needed).
  final MateoToastVariantColorScheme warning;

  /// Color roles for informational toasts (neutral status, tips).
  final MateoToastVariantColorScheme info;

  /// Color roles for neutral toasts (non-status, general messaging).
  final MateoToastVariantColorScheme neutral;

  /// {@macro mateo_color_scheme_copy_with}
  MateoToastColorScheme copyWith({
    MateoToastVariantColorScheme? success,
    MateoToastVariantColorScheme? error,
    MateoToastVariantColorScheme? warning,
    MateoToastVariantColorScheme? info,
    MateoToastVariantColorScheme? neutral,
  }) {
    return MateoToastColorScheme(
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      neutral: neutral ?? this.neutral,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoToastColorScheme &&
          success == other.success &&
          error == other.error &&
          warning == other.warning &&
          info == other.info &&
          neutral == other.neutral;

  @override
  int get hashCode => Object.hashAll([success, error, warning, info, neutral]);
}

/// A set of colors for a single toast variant role.
@immutable
class MateoToastVariantColorScheme {
  /// Creates a toast variant with all color roles.
  const MateoToastVariantColorScheme({
    required this.background,
    required this.foreground,
    required this.icon,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoToastVariantColorScheme.lerp(
    MateoToastVariantColorScheme a,
    MateoToastVariantColorScheme b,
    double t,
  ) {
    return MateoToastVariantColorScheme(
      background: Color.lerp(a.background, b.background, t)!,
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      icon: Color.lerp(a.icon, b.icon, t)!,
    );
  }

  /// Surface color for this toast variant's background.
  final Color background;

  /// Text color for this toast variant's message text.
  final Color foreground;

  /// Icon tint color for this toast variant's icon.
  final Color icon;

  /// {@macro mateo_color_scheme_copy_with}
  MateoToastVariantColorScheme copyWith({
    Color? background,
    Color? foreground,
    Color? icon,
  }) {
    return MateoToastVariantColorScheme(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoToastVariantColorScheme &&
          background == other.background &&
          foreground == other.foreground &&
          icon == other.icon;

  @override
  int get hashCode => Object.hashAll([background, foreground, icon]);
}
