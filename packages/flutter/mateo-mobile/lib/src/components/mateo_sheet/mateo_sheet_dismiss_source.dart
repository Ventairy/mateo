part of 'show_mateo_sheet.dart';

/// The interaction requesting dismissal of a Mateo sheet.
enum MateoSheetDismissSource {
  /// A drag toward the sheet's dismissal edge.
  drag,

  /// A press on the built-in sheet header close button.
  closeButton,

  /// A tap outside the sheet.
  tapOutside,

  /// A system back action or a call to [Navigator.maybePop].
  systemBack,

  /// A dismiss action from assistive technology.
  accessibilityAction,
}
