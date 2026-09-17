part of 'show_mateo_sheet.dart';

/// The interaction requesting dismissal of a Mateo sheet.
enum MateoSheetDismissSource {
  /// A committed drag toward the sheet's dismissal edge.
  drag,

  /// A tap outside the sheet.
  tapOutside,

  /// A system back action or a call to [Navigator.maybePop].
  systemBack,

  /// A dismiss action from assistive technology.
  accessibilityAction,
}
