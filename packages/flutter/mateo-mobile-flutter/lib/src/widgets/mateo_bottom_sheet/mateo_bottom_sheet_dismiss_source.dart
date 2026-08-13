/// The user interaction that requested dismissal of a Mateo Bottom Sheet.
enum MateoBottomSheetDismissSource {
  /// A press of the sheet's visible close button.
  closeButton,

  /// A committed downward drag on the sheet or its scrim.
  drag,

  /// A tap on the scrim outside the sheet.
  tapOutside,

  /// The platform's system back action.
  systemBack,

  /// A dismissal action exposed to assistive technology.
  accessibilityAction,
}
