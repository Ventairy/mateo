import 'package:flutter/widgets.dart';

import '../../../../bases/base_mateo_view_footer/base_mateo_view_footer.dart';
import '../../mateo_view.dart';

/// A footer for actions or information at the bottom of a view.
///
/// Stays clear of system edges. An owning Mateo view leaves
/// room for it at the end of the surface content.
///
/// Supply this through [MateoView.footer].
///
/// ```dart
/// const MateoView(
///   footer: MateoViewFooter(principal: Text('Ready when you are')),
///   surface: MateoViewSurface(child: Text('Content')),
/// )
/// ```
class MateoViewFooter extends StatelessWidget {
  /// Creates a footer arranging [leading], [principal], and [trailing].
  const MateoViewFooter({
    this.principal,
    this.leading,
    this.trailing,
    this.padding,
    super.key,
  });

  /// The optional centered content between the side slots.
  final Widget? principal;

  /// The optional content at the directional start of the footer.
  final Widget? leading;

  /// The optional content at the directional end of the footer.
  final Widget? trailing;

  /// The local padding, or null to inherit spacing from the owning view.
  ///
  /// Explicit padding replaces inherited padding.
  final EdgeInsetsGeometry? padding;

  /// Builds the footer in the current text direction.
  @override
  Widget build(BuildContext context) {
    return BaseMateoViewFooter(
      padding: padding,
      principal: principal,
      leading: leading,
      trailing: trailing,
    );
  }
}
