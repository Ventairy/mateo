import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../../bases/base_mateo_surface/mateo_surface_scope.dart';
import '../../bases/base_mateo_view/base_mateo_view.dart';
import '../../bases/base_mateo_view/mateo_view_scope.dart';
import '../../bases/base_mateo_view_footer/base_mateo_view_footer.dart';
import '../../bases/base_mateo_view_header/base_mateo_view_header.dart';
import '../../bases/base_mateo_view_surface/base_mateo_view_surface.dart';
import '../../foundation/mateo_edge_effect/mateo_edge_effect.dart';
import '../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';
import '../../theme/mateo_theme.dart';
import '../../theme/mateo_theme_data.dart';
import '../mateo_button/mateo_button.dart';
import '../mateo_drag_resistance/mateo_drag_resistance.dart';
import '../mateo_icon/mateo_icon.dart';

part '_mateo_sheet_drag.dart';
part '_mateo_sheet_landing_curve.dart';
part 'mateo_sheet_route.dart';
part '_mateo_sheet_stack_entry.dart';
part '_mateo_sheet_stack_scope.dart';
part 'mateo_sheet_dismiss_source.dart';
part 'mateo_sheet_should_dismiss.dart';
part 'mateo_sheet_source.dart';
part 'mateo_sheet_view/_mateo_sheet_frame.dart';
part 'mateo_sheet_view/_render_mateo_sheet_frame.dart';
part 'mateo_sheet_view/components/mateo_sheet_view_footer/mateo_sheet_view_footer.dart';
part 'mateo_sheet_view/components/mateo_sheet_view_header/mateo_sheet_view_header.dart';
part 'mateo_sheet_view/components/mateo_sheet_view_header/presentations/_mateo_close_button_sheet_view_header_presentation.dart';
part 'mateo_sheet_view/components/mateo_sheet_view_header/presentations/_mateo_custom_sheet_view_header_presentation.dart';
part 'mateo_sheet_view/components/mateo_sheet_view_header/presentations/_mateo_handle_sheet_view_header_presentation.dart';
part 'mateo_sheet_view/components/mateo_sheet_view_header/presentations/mateo_sheet_view_header_presentation.dart';
part 'mateo_sheet_view/components/mateo_sheet_view_surface/mateo_sheet_view_surface.dart';
part 'mateo_sheet_view/mateo_sheet_view.dart';

/// Shows a sheet view above the nearest navigator.
///
/// [maxExtent] limits the whole sheet along its presentation axis, in logical
/// pixels. For a bottom sheet, this is its height, including fixed slots and
/// internal spacing but excluding external margins. It must be finite and greater
/// than zero. When omitted, the existing presentation limit applies; a supplied
/// value can only reduce that limit.
///
/// [avoidBottomInset] moves the whole sheet above bottom system obstructions,
/// such as the keyboard. Defaults to false, keeping bottom device safe-area
/// spacing stable while a keyboard opens or closes. Enable it for sheets that
/// need to remain above the keyboard. Long content still needs a
/// [MateoSheetViewSurface.scrollable] surface to stay reachable.
///
/// [shouldDismiss] decides whether a requested dismissal may proceed. When
/// omitted, dismissal is allowed. Explicit [Navigator.pop] calls bypass this
/// decision and can return a result.
///
/// ```dart
/// await showMateoSheet<void>(
///   context: context,
///   shouldDismiss: (source) => source != .tapOutside,
///   view: const MateoSheetView(
///     surface: MateoSheetViewSurface(child: Text('Details')),
///   ),
/// );
/// ```
Future<T?> showMateoSheet<T>({
  required BuildContext context,
  required MateoSheetView view,
  MateoSheetShouldDismiss? shouldDismiss,
  double? maxExtent,
  bool avoidBottomInset = false,
}) {
  assert(maxExtent == null || (maxExtent.isFinite && maxExtent > 0), 'maxExtent must be finite and greater than zero.');
  final navigator = Navigator.of(context);

  return navigator.push<T>(
    MateoSheetRoute<T>(
      view: view,
      maxExtent: maxExtent,
      avoidBottomInset: avoidBottomInset,
      shouldDismiss: shouldDismiss,
      from: .bottom,
      theme: MateoTheme.of(context),
      textStyle: DefaultTextStyle.of(context).style,
      direction: Directionality.of(context),
      reducedMotion: MediaQuery.maybeDisableAnimationsOf(context) ?? false,
    ),
  );
}
