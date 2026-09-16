import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show immutable, internal;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show MatrixUtils, PipelineOwner, RenderAbstractViewport, RenderProxyBox, TransformLayer;
import 'package:mateo_mobile_old/src/foundation/mateo_boundary_effect.dart';
import 'package:mateo_mobile_old/src/foundation/mateo_elevation.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';
// Mateo's public API keeps Morph delegates private, but the surface flight
// composes Morph's built-in container/child interpolation internally.
// ignore: implementation_imports
import 'package:oh_my_flutter/src/widgets/morph/morph.dart'
    show MorphChildFlightDelegate, MorphContainerFlightDelegate, MorphContainerProperties;

part 'mateo_surface/_mateo_surface_host.dart';
part 'mateo_surface/_mateo_surface_boundary_fade.dart';
part 'mateo_surface/_mateo_surface_boundary_overlay.dart';
part 'mateo_surface/_mateo_surface_boundary_position.dart';
part 'mateo_surface/_mateo_surface_boundary_reveal.dart';
part 'mateo_surface/_mateo_surface_boundary_scroll_metrics.dart';
part 'mateo_surface/_render_mateo_surface_boundary_reveal.dart';
part 'mateo_surface/_mateo_surface_flight.dart';
part 'mateo_surface/_mateo_surface_layout_constraints.dart';
part 'mateo_surface/_mateo_surface_scroll.dart';
part 'mateo_surface/mateo_surface.dart';
part 'mateo_surface/mateo_surface_animation.dart';
part 'mateo_surface/mateo_surface_keyboard_viewport_behavior.dart';
