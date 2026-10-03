import 'package:flutter/widgets.dart';

import '../../../../bases/base_mateo_view_header/base_mateo_view_header.dart';
import '../../mateo_view.dart';

/// A transparent three-slot header for a Mateo view.
///
/// Supply this through [MateoView.header].
///
/// ```dart
/// const MateoView(
///   header: MateoViewHeader(principal: Text('Messages')),
///   surface: MateoViewSurface(child: Text('Content')),
/// )
/// ```
class MateoViewHeader extends StatelessWidget {
  /// Creates a header arranging [leading], [principal], and [trailing].
  const MateoViewHeader({this.principal, this.leading, this.trailing, this.padding, super.key});

  /// The local padding, or null to inherit spacing from the owning view.
  ///
  /// Explicit padding replaces the inherited padding.
  final EdgeInsetsGeometry? padding;

  /// The optional content that fills the available space between side slots.
  ///
  /// With no sides it fills the header; with one side it fills the remaining
  /// space. With both sides it fills a region centered across the header, and
  /// text defaults to centered alignment.
  ///
  /// The child owns its text alignment, wrapping, overflow behavior, and any
  /// explicit text-style overrides.
  final Widget? principal;

  /// The optional content at the directional start of the header.
  final Widget? leading;

  /// The optional content at the directional end of the header.
  final Widget? trailing;

  /// Builds the padded three-slot layout in the current text direction.
  @override
  Widget build(BuildContext context) {
    return BaseMateoViewHeader(
      padding: padding,
      principal: principal,
      leading: leading,
      trailing: trailing,
    );
  }
}
