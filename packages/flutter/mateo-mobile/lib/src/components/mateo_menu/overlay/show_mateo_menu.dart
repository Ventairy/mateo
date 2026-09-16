import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../bases/base_mateo_surface/mateo_surface_scope.dart';
import '../../../foundation/mateo_surface_animation/mateo_surface_animation.dart';
import '../../../theme/mateo_theme.dart';
import '../../../theme/mateo_theme_data.dart';
import '../mateo_menu.dart';
import '../presentations/options_presentation/mateo_menu_options_presentation_item.dart';

part '_mateo_menu_anchor.dart';
part '_mateo_menu_layout.dart';
part '_mateo_menu_overlay.dart';
part '_mateo_menu_route.dart';

@internal
typedef MateoMenuPlacement =
    Offset Function(
      Rect anchorBounds,
      Size menuSize,
      Rect availableBounds,
    );

@internal
typedef MateoMenuExitTransition = ({
  Duration duration,
  Widget Function(BuildContext context, Animation<double> animation, Widget child) builder,
});

@internal
Future<MateoMenuOptionsPresentationItem?> showMateoMenu({
  required MateoMenu menu,
  required BuildContext anchorContext,
  required MateoSurfaceAnimation surfaceAnimation,
  required MateoMenuPlacement placement,
  MateoMenuExitTransition? exitTransition,
}) async {
  final navigator = Navigator.of(anchorContext);
  final overlay = navigator.overlay!.context.findRenderObject()! as RenderBox;
  final anchorBounds = _readMateoMenuAnchorBounds(anchorContext: anchorContext, overlay: overlay);
  if (anchorBounds == null) {
    throw ArgumentError('anchorContext must identify a laid-out render box.');
  }

  final route = _MateoMenuRoute(
    menu: menu,
    surfaceAnimation: surfaceAnimation,
    placement: placement,
    exitTransition: exitTransition,
    reducedMotion: MediaQuery.disableAnimationsOf(anchorContext),
    theme: MateoTheme.of(anchorContext),
    textStyle: DefaultTextStyle.of(anchorContext).style,
    direction: Directionality.of(anchorContext),
    anchorBounds: anchorBounds,
  );

  final result = await navigator.push(route);
  await route.completed;
  return result;
}
