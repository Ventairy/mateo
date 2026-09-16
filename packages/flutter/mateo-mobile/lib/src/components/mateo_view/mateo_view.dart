import 'package:flutter/widgets.dart';

import '../../bases/base_mateo_view/base_mateo_view.dart';
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
    this.padding,
    super.key,
  });

  /// The general view spacing that surface, header, footer etc. will inherit.
  ///
  /// defaults to 20 horizontal and 12 vertical logical pixels.
  /// At edges without a header or footer, vertical padding reserves space
  /// between the surface content and the view boundary.
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

  @override
  Widget build(BuildContext context) {
    return BaseMateoView(
      padding: padding,
      fitHeight: false,
      surface: surface,
      header: header,
      footer: footer,
      overlay: overlay,
    );
  }
}
