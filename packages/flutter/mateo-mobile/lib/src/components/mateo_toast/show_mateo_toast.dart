import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../theme/mateo_theme.dart';
import '../mateo_drag_resistance/mateo_drag_resistance.dart';
import 'mateo_toast.dart';

part '_mateo_toast_curve.dart';
part '_mateo_toast_overlay.dart';
part 'mateo_toast_host.dart';

/// Shows [toast] above the navigation of the enclosing Mateo app.
///
/// Lets the current toast leave before bringing in the new toast. During a
/// handoff, only the latest waiting toast is retained. Reduced motion switches
/// immediately. [duration] overrides the estimated
/// reading time. [dismissible] controls touch dismissal; automatic dismissal
/// remains enabled. [padding] is applied inside the top and side safe areas.
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
