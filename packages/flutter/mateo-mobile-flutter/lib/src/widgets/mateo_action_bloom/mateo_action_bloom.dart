import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile/src/theme/mateo_typography.dart';
import 'package:mateo_mobile/src/widgets/mateo_tap/mateo_tap.dart';

part '_mateo_action_bloom_overlay_geometry.dart';
part '_mateo_action_bloom_panel.dart';
part '_mateo_action_bloom_surface.dart';
part '_mateo_action_bloom_surface_transition.dart';
part 'mateo_action_bloom_action.dart';
part 'mateo_action_bloom_types.dart';

/// The internal entry point for opening an action bloom from its source
/// surface.
@internal
abstract final class MateoActionBloom {
  /// Opens the action bloom anchored by the nearest surface above [context].
  ///
  /// The [context] must be created beneath a [MateoActionBloomSurface]. The
  /// [actions] list must contain at least two actions. The returned future
  /// completes after the panel closes and the source surface is restored.
  static Future<void> open({
    required BuildContext context,
    required List<MateoActionBloomAction> actions,
    required Color actionIconForegroundColor,
  }) {
    if (actions.length < 2) {
      throw ArgumentError.value(
        actions,
        'actions',
        'MateoActionBloom.open requires at least two actions.',
      );
    }

    final surface = context
        .findAncestorStateOfType<_MateoActionBloomSurfaceState>();
    if (surface == null) {
      throw FlutterError(
        'MateoActionBloom.open requires a context beneath '
        'MateoActionBloomSurface.',
      );
    }

    return surface._open(
      actions: actions,
      actionIconForegroundColor: actionIconForegroundColor,
    );
  }
}
