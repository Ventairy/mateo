part of '../../mateo_page_transition.dart';

final class _MateoFadePageTransitionView extends StatefulWidget {
  const new({
    required this.animation,
    required this.transition,
    required this.useLinearProgress,
    required this.child,
  });

  final Animation<double> animation;
  final MateoPageTransitionFade transition;
  final bool useLinearProgress;
  final Widget child;

  @override
  State<_MateoFadePageTransitionView> createState() => _MateoFadePageTransitionViewState();
}

final class _MateoFadePageTransitionViewState extends State<_MateoFadePageTransitionView> {
  late CurvedAnimation _curvedAnimation;
  late bool _useLinearProgress;

  @override
  void initState() {
    super.initState();
    _useLinearProgress = widget.useLinearProgress;
    _createCurvedAnimation();
    widget.animation.addStatusListener(_handleAnimationStatus);
  }

  @override
  void didUpdateWidget(_MateoFadePageTransitionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation ||
        widget.transition.openingCurve != oldWidget.transition.openingCurve ||
        widget.transition.closingCurve != oldWidget.transition.closingCurve) {
      oldWidget.animation.removeStatusListener(_handleAnimationStatus);
      _curvedAnimation.dispose();
      _createCurvedAnimation();
      widget.animation.addStatusListener(_handleAnimationStatus);
    }

    if (widget.useLinearProgress || !widget.animation.isAnimating) {
      _useLinearProgress = widget.useLinearProgress;
    }
  }

  void _createCurvedAnimation() {
    _curvedAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: widget.transition.openingCurve,
      reverseCurve: FlippedCurve(widget.transition.closingCurve),
    );
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status.isAnimating || !_useLinearProgress) return;
    setState(() {
      _useLinearProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _useLinearProgress ? widget.animation : _curvedAnimation,
    child: widget.child,
  );

  @override
  void dispose() {
    widget.animation.removeStatusListener(_handleAnimationStatus);
    _curvedAnimation.dispose();
    super.dispose();
  }
}
