import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';
import 'package:mateo_mobile_old/src/foundation/mateo_elevation.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

part '_mateo_toast_entry.dart';
part '_mateo_toast_overlay.dart';
part '_mateo_toast_presentation_scope.dart';
part 'mateo_toast_messenger.dart';
part 'mateo_toast_presentation.dart';
part 'mateo_toast_slide/_mateo_toast_slide_render_object.dart';
part 'mateo_toast_slide/_mateo_toast_slide_widget.dart';
part 'mateo_toast_types.dart';
part 'presentations/_mateo_error_toast_presentation.dart';
part 'presentations/_mateo_info_toast_presentation.dart';
part 'presentations/_mateo_neutral_toast_presentation.dart';
part 'presentations/_mateo_success_toast_presentation.dart';
part 'presentations/_mateo_warning_toast_presentation.dart';

/// A toast surface for transient messages.
///
/// `MateoToast` renders a compact floating toast. Use [show]
/// for normal app feedback so the toast is inserted above the provided
/// [BuildContext].
///
/// When a [MateoToastMessenger] is installed, calling [show] while a toast is
/// already visible replaces the previous toast instead of stacking messages.
/// [MateoApp] and [MateoApp.router] install the messenger automatically.
/// Applications that use [MaterialApp] directly should follow the manual setup
/// documented on [MateoToastMessenger].
///
/// ```dart
/// MateoToast.show(
///   context,
///   message: 'Something went wrong',
///   presentation: .error(),
/// );
/// ```
///
/// See also:
///  * [MateoToastPresentation], the semantic appearance of the toast.
///  * [MateoToastMessenger], the messenger that keeps toast entries above the
///    navigator.
class MateoToast extends StatelessWidget {
  /// Creates a Mateo Mobile toast widget.
  ///
  /// Use the constructor for direct rendering in previews, tests, or composed
  /// surfaces. Use [show] for the common overlay behavior. The [presentation]
  /// owns the toast's semantic colors, icon, layout, and accessibility.
  const MateoToast({
    required this.message,
    required this.presentation,
    super.key,
  });

  /// The visible message presented in the toast.
  final String message;

  /// The semantic visual presentation of this toast.
  final MateoToastPresentation presentation;

  /// Shows a Mateo Mobile toast above [context].
  ///
  /// The [message] is displayed after the safe area using [presentation]. The
  /// optional [duration] controls how long the toast remains visible before
  /// dismissing; when omitted, it estimates a reading duration from [message].
  /// When [dismissible] is false, taps and upward swipes cannot dismiss the
  /// toast; dragging in any direction uses resistance instead. The [padding]
  /// is applied after the safe area and controls the toast inset from the
  /// overlay edges.
  ///
  /// When a [MateoToastMessenger] ancestor is found via [context], the toast is
  /// inserted into that messenger's overlay so it remains above route and hero
  /// overlays. Otherwise, the furthest overlay above [context] is used as a
  /// fallback. The fallback does not provide messenger-owned replacement
  /// behavior; install [MateoToastMessenger] manually when not using [MateoApp].
  ///
  /// With a messenger installed, an active toast is removed before the new one
  /// is shown. If [context] has no overlay, this method safely does nothing.
  static void show(
    BuildContext context, {
    required String message,
    required MateoToastPresentation presentation,
    Duration? duration,
    bool dismissible = true,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 16,
    ),
  }) {
    final messenger = MateoToastMessenger.maybeOf(context);
    final overlay = messenger?.overlay ?? Overlay.maybeOf(context, rootOverlay: true);

    if (overlay == null) return;

    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final capturedThemes = InheritedTheme.capture(
      from: context,
      to: overlay.context,
    );

    messenger?.dismissActive();

    late final _MateoToastEntry toastEntry;

    final entry = OverlayEntry(
      builder: (context) => capturedThemes.wrap(
        _MateoToastOverlay(
          message: message,
          presentation: presentation,
          duration: duration ?? _estimateDuration(message),
          dismissible: dismissible,
          disableAnimations: disableAnimations,
          padding: padding,
          onDismissed: () {
            toastEntry.remove();

            if (identical(messenger?._activeEntry, toastEntry)) {
              messenger?._activeEntry = null;
            }
          },
        ),
      ),
    );

    toastEntry = _MateoToastEntry(entry: entry);
    messenger?._activeEntry = toastEntry;

    overlay.insert(entry);
  }

  static const Duration _minAutoDuration = Duration(milliseconds: 2500);
  static const Duration _maxAutoDuration = Duration(milliseconds: 8000);
  static const Duration _appearDuration = Duration(milliseconds: 280);
  static const Duration _dismissDuration = Duration(milliseconds: 220);
  static const double _readableCharactersPerSecond = 14;

  static Duration _estimateDuration(String message) {
    final readableCharacters = message.trim().isEmpty ? 1 : message.trim().length;
    final milliseconds = (readableCharacters / _readableCharactersPerSecond * 1000).round();
    final duration = Duration(milliseconds: milliseconds);

    if (duration < _minAutoDuration) return _minAutoDuration;
    if (duration > _maxAutoDuration) return _maxAutoDuration;

    return duration;
  }

  @override
  Widget build(BuildContext context) => _MateoToastPresentationScope(
    message: message,
    child: presentation,
  );
}
