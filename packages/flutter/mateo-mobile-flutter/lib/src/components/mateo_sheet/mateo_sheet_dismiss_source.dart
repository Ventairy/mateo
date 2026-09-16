/// The user interaction that requested dismissal of a Mateo sheet.
enum MateoSheetDismissSource {
  /// A press of the sheet's visible close button.
  closeButton,

  /// A committed downward drag on the sheet or its scrim.
  drag,

  /// A tap on the scrim outside the sheet.
  tapOutside,

  /// The platform's system back action.
  systemBack,

  /// A dismissal action exposed to assistive technology.
  accessibilityAction;

  /// Whether dismissal was requested by the close button.
  bool get isCloseButton => this == closeButton;

  /// Whether dismissal was requested by a committed drag.
  bool get isDrag => this == drag;

  /// Whether dismissal was requested by a tap outside the sheet.
  bool get isTapOutside => this == tapOutside;

  /// Whether dismissal was requested by the system back action.
  bool get isSystemBack => this == systemBack;

  /// Whether dismissal was requested by assistive technology.
  bool get isAccessibilityAction => this == accessibilityAction;
}
