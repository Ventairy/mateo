part of 'mateo_button.dart';

abstract interface class _MateoButtonOwner {
  bool get isEnabled;
  bool get isInteractive;
  bool get isPressed;
  bool get isLoading;
  bool get showLoadingIndicator;
  bool get showTransitionOverlay;
  Animation<double> get contentOpacity;
  Key get loadingIndicatorKey;

  Future<void> handlePressed();
  void updatePressed({required bool pressed});
}
