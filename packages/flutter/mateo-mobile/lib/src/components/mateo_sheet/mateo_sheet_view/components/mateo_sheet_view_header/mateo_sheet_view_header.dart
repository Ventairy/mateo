part of '../../../show_mateo_sheet.dart';

/// A fixed header with sheet-owned spacing.
///
/// Supply this to [MateoSheetView.header].
class MateoSheetViewHeader extends StatelessWidget {
  /// Creates a header arranging [leading], [principal], and [trailing].
  const MateoSheetViewHeader({this.leading, this.principal, this.trailing, super.key});

  /// The content at the directional start.
  final Widget? leading;

  /// The optional content that fills the available space between side slots.
  ///
  /// With no sides it fills the header; with one side it fills the remaining
  /// space. With both sides it fills a region centered across the header, and
  /// text defaults to centered alignment.
  /// The child owns its text alignment, wrapping, and overflow behavior.
  final Widget? principal;

  /// The content at the directional end.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return BaseMateoViewHeader(
      leading: leading,
      principal: principal,
      trailing: trailing,
    );
  }
}
