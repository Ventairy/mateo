part of '../../../../show_mateo_sheet.dart';

class _MateoCustomSheetViewHeaderPresentation extends MateoSheetViewHeaderPresentation {
  const new({this.leading, this.principal, this.trailing}) : super._();

  final Widget? leading;
  final Widget? principal;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => BaseMateoViewHeader(
    leading: leading,
    principal: principal,
    trailing: trailing,
  );
}
