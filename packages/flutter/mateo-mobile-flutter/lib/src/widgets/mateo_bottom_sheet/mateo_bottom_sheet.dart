import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:mateo_mobile/src/icons/mateo_icons.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile/src/widgets/mateo_bottom_sheet/mateo_bottom_sheet_dismiss_source.dart';
import 'package:mateo_mobile/src/widgets/mateo_bottom_sheet/mateo_bottom_sheet_should_dismiss.dart';
import 'package:mateo_mobile/src/widgets/mateo_drag_resistance/mateo_drag_resistance.dart';
import 'package:mateo_mobile/src/widgets/mateo_floating_action_button/mateo_floating_action_button.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

part '_mateo_bottom_sheet_drag_surface.dart';
part '_mateo_bottom_sheet_route.dart';
part '_mateo_bottom_sheet_scrim_drag_surface.dart';
part '_mateo_bottom_sheet_surface.dart';
part '_mateo_bottom_sheet_transition.dart';
part '_mateo_bottom_sheet_transition_render_object.dart';

/// A modal Mateo Mobile surface for compact information and focused actions.
///
/// Use [show] to present [Widget] content near the physical bottom edge of the
/// current navigator.
///
/// Set `scrollable: true` when Mateo should own scrolling for content that is
/// taller than the sheet. An upward scroll first expands it to 85 percent of that
/// viewport; after it reaches that height, the same gesture scrolls the content.
///
/// The sheet can be dismissed with a downward drag when its content is not
/// scrollable or is already at the top. Back navigation, accessibility dismiss
/// actions, the overlaid close button, taps on the modal backdrop, and downward
/// backdrop swipes also dismiss it.
///
/// ```dart
/// MateoBottomSheet.show(
///   context,
///   child: const Text('Details'),
/// );
/// ```
///
/// ```dart
/// MateoBottomSheet.show(
///   context,
///   scrollable: true,
///   child: Column(
///     children: const [
///       Text('Details'),
///       SizedBox(height: 16),
///       Text('Requirements'),
///     ],
///   ),
/// );
/// ```
///
/// Protect work from accidental dismissal by accepting only the close button:
///
/// ```dart
/// MateoBottomSheet.show(
///   context,
///   shouldDismiss: (source) =>
///       source == MateoBottomSheetDismissSource.closeButton,
///   child: const Text('Draft details'),
/// );
/// ```
///
abstract final class MateoBottomSheet {
  /// Shows a Mateo Mobile bottom sheet above the nearest navigator.
  ///
  /// The [child] is placed inside fixed Mateo content padding and an internal
  /// safe area. A close button is overlaid at the top right without reserving
  /// layout space, so [child] content may extend behind it. When [scrollable]
  /// is `false`, small children keep their intrinsic height while tall children
  /// receive a maximum height equal to 85 percent of the keyboard-adjusted
  /// viewport.
  ///
  /// When [scrollable] is `true`, the sheet starts at one third of the
  /// keyboard-adjusted viewport and Mateo wraps [child] in a scroll view. Upward
  /// scrolling expands the sheet before scrolling its content. The [child]
  /// must not contain another vertical scrollable in this mode. Keep the child
  /// to a bounded amount of content because it is built as one scrollable box;
  /// do not use this mode for an unbounded or very large collection.
  ///
  /// The optional [shouldDismiss] callback runs before a user-initiated
  /// dismissal and receives its [MateoBottomSheetDismissSource]. It may return
  /// a [bool] immediately or wait for an asynchronous decision. Returning
  /// `false` keeps the sheet open. While an asynchronous decision is pending,
  /// Mateo ignores additional dismissal attempts.
  ///
  /// Calls to `Navigator.pop` are explicit programmatic completions and do not
  /// invoke [shouldDismiss].
  ///
  /// When [draggable] is `false`, Mateo disables every sheet drag, including
  /// expansion and scrolling in the scrollable variant. Direct drags on the
  /// sheet receive resistance when [resistance] is `true`. Drag attempts do
  /// not invoke [shouldDismiss].
  ///
  /// When [resistance] is `false`, Mateo does not apply its resistance effect
  /// in any direction. This does not change whether the sheet is [draggable].
  ///
  /// Returns the value supplied to `Navigator.pop` when the sheet closes, or
  /// `null` when it is dismissed without a result.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool scrollable = false,
    bool draggable = true,
    bool resistance = true,
    MateoBottomSheetShouldDismiss? shouldDismiss,
  }) {
    final navigator = Navigator.of(context);
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final colorScheme = context.mateo.colorScheme;

    return navigator.push<T>(
      _MateoBottomSheetRoute<T>(
        child: child,
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
        barrierColor: colorScheme.overlay.scrim,
        barrierLabel: MaterialLocalizations.of(
          context,
        ).modalBarrierDismissLabel,
        disableAnimations: disableAnimations,
        scrollable: scrollable,
        draggable: draggable,
        resistance: resistance,
        shouldDismiss: shouldDismiss,
      ),
    );
  }
}
