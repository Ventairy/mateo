import 'package:flutter/widgets.dart';

import '../../bases/base_mateo_surface/mateo_surface_scope.dart';
import '../../bases/base_mateo_view/base_mateo_view.dart';
import '../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';
import '../../foundation/mateo_view_animation/mateo_view_animation.dart';
import 'components/mateo_view_footer/mateo_view_footer.dart';
import 'components/mateo_view_header/mateo_view_header.dart';
import 'components/mateo_view_surface/mateo_view_surface.dart';

/// A transparent host for a view.
///
/// ```dart
/// const MateoView(
///   surface: MateoViewSurface.scrollable(
///     child: Text('Welcome'),
///   ),
/// )
/// ```
class MateoView extends StatelessWidget {
  /// Creates a view hosting [surface] within its parent's bounded space.
  const MateoView({
    required this.surface,
    this.header,
    this.footer,
    this.overlay,
    this.animation,
    this.padding,
    this.avoidBottomInset = true,
    super.key,
  });

  /// Whether content and the footer avoid the bottom system obstruction.
  ///
  /// Defaults to true and follows live insets, including while another route
  /// covers the view. Set to false for views that should not accommodate input.
  /// When disabled, bottom device safe-area spacing stays in place as the
  /// keyboard opens or closes. Descendant media values remain unchanged.
  /// Remove manual keyboard or bottom safe-area compensation to avoid double
  /// spacing.
  final bool avoidBottomInset;

  /// The general view spacing that surface, header, footer will inherit.
  ///
  /// defaults to 20 horizontal and 12 vertical logical pixels.
  /// At edges without a header or footer, vertical padding reserves space
  /// between the surface content and the view boundary when surface padding
  /// is omitted. Explicit surface padding replaces that inherited spacing.
  final EdgeInsetsGeometry? padding;

  /// The surface filling the view and owning its visible appearance and content.
  final MateoViewSurface surface;

  /// The optional fixed header overlaid above the surface.
  final MateoViewHeader? header;

  /// The optional footer positioned at the bottom of the view.
  final MateoViewFooter? footer;

  /// Optional full-view content painted above the surface, header, and footer.
  ///
  /// Stays fixed while the surface scrolls, without automatic padding or safe-area
  /// insets. The child owns alignment, hit testing, focus, and semantics.
  final Widget? overlay;

  /// The transform animation connecting this view to another Mateo element.
  final MateoViewAnimation? animation;

  @override
  Widget build(BuildContext context) {
    final surfaceScope = MateoSurfaceScope.of(context);

    return BaseMateoView(
      padding: padding,
      fitHeight: false,
      avoidBottomInset: avoidBottomInset,
      maintainBottomViewPadding: !avoidBottomInset,
      animation: animation,
      surfacePresentation: (
        color: surface.color,
        elevation: surface.elevation,
        shape: surface.shape?.border ?? surfaceScope.shape ?? const MateoRoundedShapeBorder(radius: 0),
      ),
      surface: surface,
      header: header,
      footer: footer,
      overlay: overlay,
    );
  }
}
