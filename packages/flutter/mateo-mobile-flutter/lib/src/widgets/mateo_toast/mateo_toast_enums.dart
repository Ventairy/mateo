part of 'mateo_toast.dart';

/// The status category used to style a [MateoToast].
///
/// The type controls the toast background, foreground, and default icon. Use
/// [neutral] for status that has no success, warning, or error meaning, and
/// provide the required custom icon through [MateoToast.iconBuilder].
enum MateoToastType {
  /// Error feedback for failed actions or invalid states.
  error,

  /// Warning feedback for non-blocking risks or degraded conditions.
  warning,

  /// Informational feedback relevant to the person's current task.
  info,

  /// Success feedback for meaningful actions or awaited processes.
  success,

  /// Neutral feedback for object or system status without severity.
  neutral;

  /// Resolves the color triplet for this toast type using [context].
  ///
  /// Returns a record with `background`, `foreground`, and `icon` colors.
  ({Color background, Color foreground, Color icon}) colors(
    BuildContext context,
  ) {
    final colorScheme = context.mateo.colorScheme;

    return switch (this) {
      MateoToastType.error => (
        background: colorScheme.toast.error.background,
        foreground: colorScheme.toast.error.foreground,
        icon: colorScheme.toast.error.icon,
      ),
      MateoToastType.warning => (
        background: colorScheme.toast.warning.background,
        foreground: colorScheme.toast.warning.foreground,
        icon: colorScheme.toast.warning.icon,
      ),
      MateoToastType.info => (
        background: colorScheme.toast.info.background,
        foreground: colorScheme.toast.info.foreground,
        icon: colorScheme.toast.info.icon,
      ),
      MateoToastType.success => (
        background: colorScheme.toast.success.background,
        foreground: colorScheme.toast.success.foreground,
        icon: colorScheme.toast.success.icon,
      ),
      MateoToastType.neutral => (
        background: colorScheme.toast.neutral.background,
        foreground: colorScheme.toast.neutral.foreground,
        icon: colorScheme.toast.neutral.icon,
      ),
    };
  }
}
