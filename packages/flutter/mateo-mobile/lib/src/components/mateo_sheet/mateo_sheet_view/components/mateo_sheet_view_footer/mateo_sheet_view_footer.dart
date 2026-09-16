part of '../../../show_mateo_sheet.dart';

/// A fixed footer with sheet-owned spacing.
///
/// Supply this to [MateoSheetView.footer].
class MateoSheetViewFooter extends StatelessWidget {
  /// Creates a footer arranging [leading], [principal], and [trailing].
  const MateoSheetViewFooter({this.leading, this.principal, this.trailing, super.key});

  /// The content at the directional start.
  final Widget? leading;

  /// The principal content between the side slots.
  final Widget? principal;

  /// The content at the directional end.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return BaseMateoViewFooter(
      leading: leading,
      principal: principal,
      trailing: trailing,
    );
  }
}
