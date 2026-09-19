import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/mateo_page/mateo_page.dart' show MateoPage;

@internal
abstract class BaseMateoPageRoute<T> extends PageRoute<T> {
  BaseMateoPageRoute({required MateoPage<T> page, required this.reducedMotion}) : super(settings: page);

  bool _isPrimaryVisualMotionDisabled = false;
  bool get isPrimaryVisualMotionDisabled => _isPrimaryVisualMotionDisabled;
  bool get shouldAnimatePrimary => !reducedMotion && !isPrimaryVisualMotionDisabled;
  bool get shouldAnimateSecondary => !reducedMotion;

  void disablePrimaryVisualMotion() {
    _isPrimaryVisualMotionDisabled = true;
    changedInternalState();
  }

  ({Duration forward, Duration reverse})? _transitionDurations;
  ({Duration forward, Duration reverse})? get transitionDurations => _transitionDurations;

  void setTransitionDurations({required Duration forward, required Duration reverse}) {
    assert(!forward.isNegative && !reverse.isNegative, 'Transition durations must be nonnegative.');
    _transitionDurations = (forward: forward, reverse: reverse);
    changedInternalState();

    final animationController = controller;

    if (animationController == null || !animationController.isAnimating) return;
    if (animationController.status == .reverse) {
      animationController.reverse();
      return;
    }

    animationController.forward();
  }

  bool reducedMotion;
  bool _disposed = false;
  bool _settlementScheduled = false;
  MateoPage<T> get page => settings as MateoPage<T>;
  Widget buildContent(BuildContext context) => page.child;
  String? get title => page.title;
  @override
  bool get maintainState => page.maintainState;
  @override
  bool get fullscreenDialog => page.fullscreenDialog;
  @override
  bool get allowSnapshotting => page.allowSnapshotting;
  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;

  @override
  void changedExternalState() {
    super.changedExternalState();
    _updateTiming();
  }

  @override
  void changedInternalState() {
    super.changedInternalState();
    _updateTiming();
  }

  void updateMotion(BuildContext context) {
    final disabled = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disabled == reducedMotion) return;
    reducedMotion = disabled;
    _updateTiming();
    if (!disabled || _settlementScheduled) return;
    _settlementScheduled = true;
    // Route completion can rebuild Navigator; defer it beyond the current build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _settlementScheduled = false;
      if (_disposed || !reducedMotion || !isActive || popGestureInProgress) return;
      final animationController = controller;
      if (animationController == null || !animationController.isAnimating) return;
      animationController.value = animationController.status == .reverse ? 0 : 1;
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _stopGesture();
    super.dispose();
  }

  void _updateTiming() {
    controller
      ?..duration = transitionDuration
      ..reverseDuration = reverseTransitionDuration;
  }

  NavigatorState? _gestureNavigator;
  AnimationStatusListener? _gestureStatusListener;

  @override
  void handleStartBackGesture({double progress = 0}) {
    _gestureNavigator = navigator;
    super.handleStartBackGesture(progress: progress);
  }

  @override
  void handleCancelBackGesture() {
    if (isCurrent) controller?.forward();
    _settleGesture();
  }

  @override
  void handleCommitBackGesture() {
    // Navigator.pop reverses from the current controller value. The framework's
    // default predictive handler subsequently resets it to one, which would jump.
    if (isCurrent) navigator?.pop();
    _settleGesture();
  }

  void _settleGesture() {
    if (!(controller?.isAnimating ?? false)) {
      _stopGesture();
      return;
    }
    final previousListener = _gestureStatusListener;
    if (previousListener != null) controller?.removeStatusListener(previousListener);
    _gestureStatusListener = (status) {
      if (!status.isAnimating) _stopGesture();
    };
    controller?.addStatusListener(_gestureStatusListener!);
  }

  void _stopGesture() {
    final listener = _gestureStatusListener;
    if (listener != null) controller?.removeStatusListener(listener);
    _gestureStatusListener = null;
    final owner = _gestureNavigator;
    _gestureNavigator = null;
    if (owner != null && owner.mounted && owner.userGestureInProgress) owner.didStopUserGesture();
  }
}
