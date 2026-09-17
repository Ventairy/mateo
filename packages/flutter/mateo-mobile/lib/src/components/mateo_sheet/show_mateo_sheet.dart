import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
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
import '../mateo_drag_resistance/mateo_drag_resistance.dart';

part '_mateo_sheet_drag.dart';
part '_mateo_sheet_landing_curve.dart';
part '_mateo_sheet_route.dart';
part '_mateo_sheet_stack_scope.dart';
part '_mateo_sheet_stack_entry.dart';
part 'mateo_sheet_source.dart';
part 'mateo_sheet_dismiss_source.dart';
part 'mateo_sheet_should_dismiss.dart';
part 'mateo_sheet_view/_mateo_sheet_frame.dart';
part 'mateo_sheet_view/_render_mateo_sheet_frame.dart';
part 'mateo_sheet_view/components/mateo_sheet_view_footer/mateo_sheet_view_footer.dart';
part 'mateo_sheet_view/components/mateo_sheet_view_header/mateo_sheet_view_header.dart';
part 'mateo_sheet_view/components/mateo_sheet_view_surface/mateo_sheet_view_surface.dart';
part 'mateo_sheet_view/mateo_sheet_view.dart';

/// Shows a sheet view above the nearest navigator.
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
}) {
  final navigator = Navigator.of(context);

  return navigator.push<T>(
    _MateoSheetRoute<T>(
      view: view,
      shouldDismiss: shouldDismiss,
      from: .bottom,
      theme: MateoTheme.of(context),
      textStyle: DefaultTextStyle.of(context).style,
      direction: Directionality.of(context),
      reducedMotion: MediaQuery.maybeDisableAnimationsOf(context) ?? false,
    ),
  );
}
