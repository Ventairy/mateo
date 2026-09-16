part of '../../mateo_page_transition.dart';

final class _MateoWashPageTransitionView extends StatefulWidget {
  const _MateoWashPageTransitionView({
    required this.animation,
    required this.transition,
    required this.allowSnapshotting,
    required this.useLinearProgress,
    required this.child,
  });

  final Animation<double> animation;
  final MateoPageTransitionWash transition;
  final bool allowSnapshotting;
  final bool useLinearProgress;
  final Widget child;

  @override
  State<_MateoWashPageTransitionView> createState() => _MateoWashPageTransitionViewState();
}

final class _MateoWashPageTransitionViewState extends State<_MateoWashPageTransitionView> {
  final _snapshotController = SnapshotController();
  late _MateoWashPageTransitionPainter _painter;

  bool get _canSnapshot => !kIsWeb && widget.allowSnapshotting;

  @override
  void initState() {
    super.initState();
    _painter = _createPainter();
    widget.animation.addStatusListener(_handleAnimationStatus);
    _updateSnapshotting();
  }

  @override
  void didUpdateWidget(covariant _MateoWashPageTransitionView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animation != widget.animation) {
      oldWidget.animation.removeStatusListener(_handleAnimationStatus);
      widget.animation.addStatusListener(_handleAnimationStatus);
      _replacePainter();
    } else {
      _painter.updateConfiguration(
        transition: widget.transition,
        useLinearProgress: widget.useLinearProgress,
      );
    }

    if (oldWidget.child != widget.child || oldWidget.transition != widget.transition) {
      _snapshotController.clear();
    }
    _updateSnapshotting();
  }

  void _handleAnimationStatus(AnimationStatus _) {
    _updateSnapshotting();
  }

  void _updateSnapshotting() {
    _snapshotController.allowSnapshotting = _canSnapshot && widget.animation.isAnimating;
  }

  _MateoWashPageTransitionPainter _createPainter() {
    return _MateoWashPageTransitionPainter(
      animation: widget.animation,
      transition: widget.transition,
      useLinearProgress: widget.useLinearProgress,
    );
  }

  void _replacePainter() {
    _painter.dispose();
    _painter = _createPainter();
  }

  @override
  Widget build(BuildContext context) {
    return SnapshotWidget(
      controller: _snapshotController,
      painter: _painter,
      // Live platform views can escape above the shader-based reveal.
      mode: SnapshotMode.forced,
      autoresize: true,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_handleAnimationStatus);
    _painter.dispose();
    _snapshotController.dispose();
    super.dispose();
  }
}
