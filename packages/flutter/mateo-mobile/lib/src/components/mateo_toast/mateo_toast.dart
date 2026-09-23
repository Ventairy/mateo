import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

/// A compact status message for transient feedback.
///
/// Use `showMateoToast` to display this surface above an app's navigation.
/// Supply a localized [message]; the full message is announced even when the
/// visible text is truncated. Toasts suit brief feedback, not essential
/// instructions or decisions that require a response.
class MateoToast extends StatelessWidget {
  /// Creates a toast with a [message], [status], and optional custom [icon].
  const MateoToast({required this.message, required this.status, this.icon, super.key});

  /// The localized message, displayed on at most two lines.
  final String message;

  /// The meaning that selects the surface colors and default icon or indicator.
  final MateoToastStatus status;

  /// The optional replacement for the status icon or indicator.
  ///
  /// Mateo icons inherit the toast's size and color through [MateoIconScope].
  /// Explicit icon properties take precedence over those defaults.
  final Widget? icon;

  static const _iconSize = 28.0;
  static const _iconTextGap = 6.0;
  static const _maxLines = 2;

  Widget _defaultStatusVisual(Color iconColor) => switch (status) {
    MateoToastStatus.error => const MateoIcon(.exclamationCircle),
    MateoToastStatus.warning => const MateoIcon(.exclamationTriangle),
    MateoToastStatus.info => const MateoIcon(.circleInfo),
    MateoToastStatus.loading => Center(
      child: MateoLoadingIndicator(presentation: .circular(color: iconColor, size: 22)),
    ),
    MateoToastStatus.success => const MateoIcon(.circleCheck),
  };

  @override
  Widget build(BuildContext context) {
    final theme = MateoTheme.of(context);
    final colors = status.colors(theme.colorScheme.toast);
    final style = TextStyle(
      color: colors.foreground,
      decoration: TextDecoration.none,
      fontFamily: MateoTypography.fontFamily,
      fontWeight: .w600,
      letterSpacing: MateoTypography.letterSpacing,
      fontSize: 14,
    );
    return Semantics(
      liveRegion: true,
      label: message,
      excludeSemantics: true,
      child: MateoSurface(
        color: colors.background,
        shape: const .capsule(),
        elevation: MateoElevation(level: 2),
        animation: const .none(),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12).copyWith(left: 12, right: 20),
        child: Row(
          mainAxisSize: .min,
          children: [
            SizedBox.square(
              dimension: _iconSize,
              child: Align(
                alignment: .topLeft,
                child: MateoIconScope(
                  size: _iconSize,
                  sizeWithBackground: _iconSize,
                  color: colors.icon,
                  child: icon ?? _defaultStatusVisual(colors.icon),
                ),
              ),
            ),
            const SizedBox(width: _iconTextGap),
            Flexible(
              child: Text(message, maxLines: _maxLines, overflow: .ellipsis, style: style),
            ),
          ],
        ),
      ),
    );
  }
}
