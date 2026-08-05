part of '../mateo_page.dart';

final class _MateoPredictiveBackGestureDetector extends StatefulWidget {
  const _MateoPredictiveBackGestureDetector({
    required this.route,
    required this.child,
  });

  final PageRoute<dynamic> route;
  final Widget child;

  @override
  State<_MateoPredictiveBackGestureDetector> createState() =>
      _MateoPredictiveBackGestureDetectorState();
}

final class _MateoPredictiveBackGestureDetectorState
    extends State<_MateoPredictiveBackGestureDetector>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    final route = widget.route;
    if (backEvent.isButtonEvent ||
        !route.isCurrent ||
        !route.popGestureEnabled) {
      return false;
    }

    route.handleStartBackGesture(progress: 1 - backEvent.progress);
    return true;
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
    widget.route.handleUpdateBackGestureProgress(
      progress: 1 - backEvent.progress,
    );
  }

  @override
  void handleCancelBackGesture() {
    widget.route.handleCancelBackGesture();
  }

  @override
  void handleCommitBackGesture() {
    widget.route.handleCommitBackGesture();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
