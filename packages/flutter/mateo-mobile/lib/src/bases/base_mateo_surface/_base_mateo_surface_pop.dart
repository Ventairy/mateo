part of 'base_mateo_surface.dart';

class _BaseMateoSurfacePop extends StatefulWidget {
  const _BaseMateoSurfacePop({required this.animation, required this.child});

  final MateoSurfaceAnimationPop animation;
  final Widget child;

  @override
  State<_BaseMateoSurfacePop> createState() => _BaseMateoSurfacePopState();
}

class _BaseMateoSurfacePopState extends State<_BaseMateoSurfacePop> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            duration: widget.animation.duration,
            animationBehavior: .preserve,
            vsync: this,
          )
          ..addListener(_handleProgress)
          ..addStatusListener(_handleStatus);
    _updateAnimations();
  }

  void _updateAnimations() {
    assert(widget.animation.duration > Duration.zero, 'duration must be positive.');
    _scale = _controller.drive(_BaseMateoSurfacePopScale(widget.animation));
    _opacity = _controller.drive(_BaseMateoSurfacePopOpacity(widget.animation.curve));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _hasStarted = true;
      if (!_controller.isCompleted) _controller.value = 1;
      return;
    }
    if (_hasStarted) return;
    _hasStarted = true;
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _BaseMateoSurfacePop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation == widget.animation) return;
    _updateAnimations();
    if (oldWidget.animation.duration == widget.animation.duration) return;
    _controller.duration = widget.animation.duration;
    if (_controller.isAnimating) {
      // Motion retimes the remaining distance over the full new duration.
      _controller.animateTo(1, duration: widget.animation.duration);
    }
  }

  void _handleProgress() {
    // Flutter's interpolation otherwise stays active at exactly the duration.
    if (_controller.value == 1 && !_controller.isCompleted) _controller.value = 1;
  }

  void _handleStatus(AnimationStatus status) {
    if (status == .completed) setState(() {});
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleProgress)
      ..removeStatusListener(_handleStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      alwaysIncludeSemantics: true,
      child: ScaleTransition(
        scale: _scale,
        filterQuality: .low,
        // The surface's existing GlobalKey preserves its subtree when this
        // temporary boundary is removed after playback or reduced motion.
        child: _controller.isCompleted ? widget.child : RepaintBoundary(child: widget.child),
      ),
    );
  }
}
