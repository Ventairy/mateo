import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/mateo_elevation.dart';
import '../../theme/mateo_theme.dart';
import '../../theme/mateo_typography.dart';
import '../mateo_drag_resistance/mateo_drag_resistance.dart';
import '../mateo_icon/mateo_icon.dart';
import '../mateo_icon/mateo_icon_scope.dart';
import '../mateo_loading_indicator/mateo_loading_indicator.dart';
import '../mateo_surface/mateo_surface.dart';
import 'duration/mateo_toast_duration.dart';
import 'mateo_toast_status.dart';

part '_mateo_toast_curve.dart';
part '_mateo_toast_overlay.dart';
part '_mateo_toast_host_scope.dart';
part 'mateo_toast_host.dart';

/// A compact status message for transient feedback.
///
/// Use `showMateoToast` to display this surface above an app's navigation.
/// Supply a localized [message]; the full message is announced even when the
/// visible text is truncated. Toasts suit brief feedback, not essential
/// instructions or decisions that require a response.
class MateoToast extends StatelessWidget {
  /// Creates a toast with a [message], [status], and optional [icon] and [onPressed] action.
  const MateoToast({required this.message, required this.status, this.icon, this.onPressed, super.key});

  /// The localized message, displayed on at most two lines.
  final String message;

  /// The meaning that selects the surface colors and default icon or indicator.
  final MateoToastStatus status;

  /// The optional replacement for the status icon or indicator.
  ///
  /// Mateo icons inherit the toast's size and color through [MateoIconScope].
  /// Explicit icon properties take precedence over those defaults.
  final Widget? icon;

  /// Called when a person completes a tap on the toast.
  final VoidCallback? onPressed;

  static const _iconSize = 28.0;
  static const _iconTextGap = 6.0;
  static const _maxLines = 2;

  Widget _defaultStatusVisual(Color iconColor) => switch (status) {
    MateoToastStatus.neutral => const MateoIcon(.circle),
    MateoToastStatus.error => const MateoIcon(.exclamationCircle),
    MateoToastStatus.warning => const MateoIcon(.exclamationTriangle),
    MateoToastStatus.info => const MateoIcon(.circleInfo),
    MateoToastStatus.loading => Center(
      child: MateoLoadingIndicator(presentation: .circular(color: iconColor, size: 22)),
    ),
    MateoToastStatus.success => const MateoIcon(.circleCheck),
  };

  void _activate(BuildContext context, {required bool dismissOnPress}) {
    if (dismissOnPress) dismissMateoToast(context: context);
    onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MateoTheme.of(context);
    final colors = status.colors(theme.colorScheme.toast);
    final dismissOnPress = _MateoToastHostScope.maybeOf(context);
    final canPress = onPressed != null || dismissOnPress;
    final activate = canPress ? () => _activate(context, dismissOnPress: dismissOnPress) : null;
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
      button: canPress,
      label: message,
      excludeSemantics: true,
      onTap: activate,
      child: GestureDetector(
        behavior: .opaque,
        excludeFromSemantics: true,
        onTap: activate,
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
      ),
    );
  }
}
