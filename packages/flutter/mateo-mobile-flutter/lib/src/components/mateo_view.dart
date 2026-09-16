import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show BoxHitTestResult, MatrixUtils, PaintingContext, RenderProxyBox;
import 'package:mateo_mobile_old/src/components/mateo_header/mateo_header.dart';
import 'package:mateo_mobile_old/src/components/mateo_surface.dart';

part 'mateo_view/_mateo_view_frame.dart';
part 'mateo_view/_mateo_view_layout_delegate.dart';
part 'mateo_view/_mateo_view_layout_id.dart';
part 'mateo_view/_mateo_view_safe_area_geometry.dart';
part 'mateo_view/_mateo_view_safe_area_observer.dart';
part 'mateo_view/_mateo_view_safe_area_paint_compensator.dart';
part 'mateo_view/_mateo_view_slot_spacing.dart';

/// A route-level Mateo shell for one surface and fixed edge controls.
///
/// [MateoView] owns safe-area interpretation, intrinsic [header] and [footer]
/// measurement, keyboard obstruction geometry, and the final app-owned
/// [overlay]. Its required [surface] owns every visible body treatment and any
/// scrolling behavior.
///
/// Ordinary surface content clears fixed slots by default. A scrollable
/// surface starts clear of them and can then travel underneath them. Set
/// [extendContentBehindHeader] or [extendContentBehindFooter] only when
/// ordinary content deliberately owns that obstruction.
///
/// Do not nest this route-level shell inside [Scaffold].
///
/// ```dart
/// MateoView(
///   surface: .scrollable(
///     child: const MyFeedContent(),
///   ),
/// )
/// ```
///
/// See also:
///  * [MateoSurface], the visible and behavioral owner of view content.
///  * [MateoHeader], the header optimized for the fixed header slot.
class MateoView extends StatelessWidget {
  /// Creates a route-level shell around [surface].
  ///
  /// [header] and [footer] remain fixed inside their safe areas. [overlay]
  /// fills the route above the surface and fixed controls. [padding] replaces
  /// automatic edge insets for content and slots without changing the surface
  /// bounds.
  const MateoView({
    required this.surface,
    super.key,
    this.header,
    this.footer,
    this.overlay,
    this.padding,
    this.extendContentBehindHeader = false,
    this.extendContentBehindFooter = false,
  });

  /// Surface filling the route beneath fixed controls.
  final MateoSurface surface;

  /// Optional spacing from every physical edge of the view.
  ///
  /// When `null`, Mateo preserves automatic safe-area and fixed-slot spacing.
  /// A supplied value replaces those content and slot insets while the surface
  /// itself remains full-size.
  final EdgeInsetsGeometry? padding;

  /// Whether ordinary surface content fills the view behind [header].
  ///
  /// Scrollable surfaces always manage the header obstruction inside their
  /// scroll extent, so this setting does not change their behavior.
  final bool extendContentBehindHeader;

  /// Whether ordinary surface content fills the view behind [footer].
  ///
  /// Scrollable surfaces always manage the footer obstruction inside their
  /// scroll extent, so this setting does not change their behavior.
  final bool extendContentBehindFooter;

  /// {@template mateo_header_slot}
  /// Optional fixed content placed across the safe top of a Mateo view.
  ///
  /// The slot expands to the view width and takes its child's intrinsic height.
  /// Mateo adds 20 logical pixels horizontally and 12 inward from the safe top
  /// boundary. Consumers may add more spacing inside [header].
  /// {@endtemplate}
  final Widget? header;

  /// {@template mateo_view_footer_slot}
  /// Optional fixed content placed across the safe bottom of a Mateo view.
  ///
  /// The slot expands to the view width and takes its child's intrinsic height.
  /// Mateo adds 20 logical pixels horizontally and 12 inward from the safe
  /// bottom boundary. Consumers may add more spacing inside [footer].
  /// {@endtemplate}
  final Widget? footer;

  /// {@template mateo_view_overlay}
  /// Optional full-view content painted above the surface and fixed slots.
  ///
  /// This widget owns its hit-testing, focus, and semantics behavior. Wrap a
  /// modal treatment in [BlockSemantics] and manage focus explicitly.
  /// {@endtemplate}
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return MateoSurfaceHost(
      surface: surface,
      builder: (context, surface, managedScrollController) => _MateoViewFrame(
        surface: surface,
        managedScrollController: managedScrollController,
        header: header,
        footer: footer,
        overlay: overlay,
        padding: padding,
        keyboardViewportBehavior: surface.keyboardViewportBehavior,
        reserveLeadingExtent: !extendContentBehindHeader && header != null,
        reserveTrailingExtent: !extendContentBehindFooter && footer != null,
      ),
    );
  }
}
