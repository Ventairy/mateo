import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:mateo_mobile_old/src/components/mateo_button/mateo_button.dart';
import 'package:mateo_mobile_old/src/components/mateo_drag_resistance/mateo_drag_resistance.dart';
import 'package:mateo_mobile_old/src/components/mateo_sheet/mateo_sheet_dismiss_source.dart';
import 'package:mateo_mobile_old/src/components/mateo_sheet/mateo_sheet_should_dismiss.dart';
import 'package:mateo_mobile_old/src/icons/mateo_icons.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

part '_mateo_sheet_route.dart';
part '_mateo_sheet_stack.dart';
part 'mateo_sheet_presentation.dart';
part 'presentations/_mateo_bottom_sheet_presentation/_mateo_bottom_sheet_presentation.dart';
part 'presentations/_mateo_bottom_sheet_presentation/_mateo_bottom_sheet_drag_surface.dart';
part 'presentations/_mateo_bottom_sheet_presentation/_mateo_bottom_sheet_scroll.dart';
part 'presentations/_mateo_bottom_sheet_presentation/_mateo_bottom_sheet_transition.dart';
part 'presentations/_mateo_bottom_sheet_presentation/_render_mateo_bottom_sheet_transition.dart';

/// A modal Mateo Mobile surface for compact information and focused actions.
///
/// Use [show] to present [Widget] content near the physical bottom edge of the
/// current navigator.
///
/// Opening another sheet above the current sheet morphs the same surface to
/// its new size. Its close button moves with the surface, and the content
/// switches at the midpoint. Each sheet keeps its own state and result.
///
/// Use [MateoSheetPresentation.bottom] to anchor the sheet at the bottom.
/// Supply a scroll view as the content when information extends beyond the
/// available height.
///
/// The sheet can be dismissed with a downward drag when its content is not
/// scrollable or is already at the top. Back navigation, accessibility dismiss
/// actions, the overlaid close button, taps on the modal backdrop, and downward
/// backdrop swipes also dismiss it.
///
/// ```dart
/// MateoSheet.show(
///   context,
///   presentation: const MateoSheetPresentation.bottom(),
///   child: const Text('Details'),
/// );
/// ```
///
/// Protect work from accidental dismissal by accepting only the close button:
///
/// ```dart
/// MateoSheet.show(
///   context,
///   presentation: const MateoSheetPresentation.bottom(),
///   shouldDismiss: (source) =>
///       source.isCloseButton,
///   child: const Text('Draft details'),
/// );
/// ```
///
abstract final class MateoSheet {
  /// Shows a Mateo Mobile bottom sheet above the nearest navigator.
  ///
  /// The [child] is placed inside fixed Mateo content padding and an internal
  /// safe area. A close button is overlaid at the top right without reserving
  /// layout space, so [child] content may extend behind it. Small children keep
  /// their intrinsic height while tall children receive a maximum height equal
  /// to 85 percent of the keyboard-adjusted viewport. Supply a scroll view when
  /// the content needs to scroll; Mateo does not wrap it in one automatically.
  /// The required [presentation] selects the sheet's layout and drag behavior.
  ///
  /// The optional [shouldDismiss] callback runs before a user-initiated
  /// dismissal and receives its [MateoSheetDismissSource]. It may return
  /// a [bool] immediately or wait for an asynchronous decision. Returning
  /// `false` keeps the sheet open. While an asynchronous decision is pending,
  /// Mateo ignores additional dismissal attempts.
  ///
  /// Calls to `Navigator.pop` are explicit programmatic completions and do not
  /// invoke [shouldDismiss].
  ///
  /// When the current route in the same navigator is another Mateo sheet,
  /// the surface and close button morph to their new bounds instead of
  /// repeating the entrance. The morph takes 350 milliseconds in either
  /// direction and slows gradually into rest. Content switches at the midpoint
  /// of the morph’s visual progress.
  /// Reduced motion shows the destination immediately.
  ///
  /// The close button, system back, accessibility dismissal, and
  /// `Navigator.pop` return one sheet. A scrim tap or committed downward drag
  /// attempts to close the whole stack, checking each sheet's [shouldDismiss]
  /// from top to bottom with the original dismissal source. Checking stops at
  /// the first refusal: accepted sheets above it close with a `null` result,
  /// and that sheet and all sheets below it remain. A scrim tap morphs to the
  /// protected sheet; a drag brings it back into view. Pending decisions ignore
  /// further user dismissal attempts.
  ///
  /// Returns the value supplied to `Navigator.pop` when the sheet closes, or
  /// `null` when it is dismissed without a result.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    required MateoSheetPresentation presentation,
    MateoSheetShouldDismiss? shouldDismiss,
  }) {
    final navigator = Navigator.of(context);
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return navigator.push<T>(
      _MateoSheetRoute<T>(
        child: child,
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
        barrierColor: presentation._scrim(context),
        barrierLabel: MaterialLocalizations.of(
          context,
        ).modalBarrierDismissLabel,
        disableAnimations: disableAnimations,
        presentation: presentation,
        shouldDismiss: shouldDismiss,
      ),
    );
  }
}
