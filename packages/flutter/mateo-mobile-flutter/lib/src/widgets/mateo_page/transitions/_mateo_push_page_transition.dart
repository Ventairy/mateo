part of '../mateo_page.dart';

final class _MateoPushPageTransitionView extends SingleChildRenderObjectWidget {
  _MateoPushPageTransitionView({
    required this.animation,
    required this.direction,
    required this.outgoing,
    required this.fadeIntoDestination,
    required this.allowSnapshotting,
    required this.useLinearProgress,
    required Widget child,
  }) : super(
         child: fadeIntoDestination && !kIsWeb && allowSnapshotting && child is! RepaintBoundary
             ? RepaintBoundary(child: child)
             : child,
       );

  final Animation<double> animation;
  final MateoPageTransitionDirection direction;
  final bool outgoing;
  final bool fadeIntoDestination;
  final bool allowSnapshotting;
  final bool useLinearProgress;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final allowEdgeSnapshot = fadeIntoDestination && !kIsWeb && allowSnapshotting;
    return _RenderMateoPushPageTransition(
      animation: animation,
      direction: direction,
      outgoing: outgoing,
      allowEdgeSnapshot: allowEdgeSnapshot,
      useLinearProgress: useLinearProgress,
      devicePixelRatio: allowEdgeSnapshot ? MediaQuery.devicePixelRatioOf(context) : 1,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMateoPushPageTransition renderObject,
  ) {
    final allowEdgeSnapshot = fadeIntoDestination && !kIsWeb && allowSnapshotting;
    renderObject
      ..animation = animation
      ..direction = direction
      ..outgoing = outgoing
      ..allowEdgeSnapshot = allowEdgeSnapshot
      ..useLinearProgress = useLinearProgress
      ..devicePixelRatio = allowEdgeSnapshot ? MediaQuery.devicePixelRatioOf(context) : 1;
  }
}

final class _RenderMateoPushPageTransition extends RenderProxyBox {
  _RenderMateoPushPageTransition({
    required this._animation,
    required this._direction,
    required this._outgoing,
    required this._allowEdgeSnapshot,
    required this._useLinearProgress,
    required this._devicePixelRatio,
  });

  static const _seamOverlap = 1.0;

  Paint? _destinationPaint;
  ui.Image? _edgeImage;
  Rect _edgeImageBounds = Rect.zero;
  double _progress = 0;

  Animation<double> get animation => _animation;
  Animation<double> _animation;
  set animation(Animation<double> value) {
    if (value == _animation) return;
    if (attached) {
      _animation
        ..removeListener(_handleAnimationTick)
        ..removeStatusListener(_handleAnimationStatus);
    }
    _animation = value;
    if (attached) {
      _animation
        ..addListener(_handleAnimationTick)
        ..addStatusListener(_handleAnimationStatus);
    }
    _updateProgress();
    _disposeEdgeImage();
    _markMotionChanged();
  }

  MateoPageTransitionDirection get direction => _direction;
  MateoPageTransitionDirection _direction;
  set direction(MateoPageTransitionDirection value) {
    if (value == _direction) return;
    _direction = value;
    _disposeEdgeImage();
    _markMotionChanged();
    markNeedsSemanticsUpdate();
  }

  bool get outgoing => _outgoing;
  bool _outgoing;
  set outgoing(bool value) {
    if (value == _outgoing) return;
    _outgoing = value;
    _markMotionChanged();
    markNeedsSemanticsUpdate();
  }

  bool get allowEdgeSnapshot => _allowEdgeSnapshot;
  bool _allowEdgeSnapshot;
  set allowEdgeSnapshot(bool value) {
    if (value == _allowEdgeSnapshot) return;
    _allowEdgeSnapshot = value;
    if (!value) _disposeEdgeImage();
    markNeedsPaint();
  }

  bool get useLinearProgress => _useLinearProgress;
  bool _useLinearProgress;
  set useLinearProgress(bool value) {
    if (value == _useLinearProgress) return;
    _useLinearProgress = value;
    _updateProgress();
    _markMotionChanged();
    markNeedsSemanticsUpdate();
  }

  double get devicePixelRatio => _devicePixelRatio;
  double _devicePixelRatio;
  set devicePixelRatio(double value) {
    if (value == _devicePixelRatio) return;
    _devicePixelRatio = value;
    _disposeEdgeImage();
    if (_allowEdgeSnapshot) markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _updateProgress();
    _animation
      ..addListener(_handleAnimationTick)
      ..addStatusListener(_handleAnimationStatus);
  }

  @override
  void detach() {
    _animation
      ..removeListener(_handleAnimationTick)
      ..removeStatusListener(_handleAnimationStatus);
    _disposeEdgeImage();
    super.detach();
  }

  @override
  void performLayout() {
    final previousSize = hasSize ? size : null;
    super.performLayout();
    if (previousSize != size) _disposeEdgeImage();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintOffset(
      offset: _translationOffset,
      position: position,
      hitTest: (result, position) {
        return super.hitTestChildren(result, position: position);
      },
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child == null) return;

    final progress = _progress;
    final childOffset = _translatedOffset(offset, progress);
    final edgeImage = _edgeImage;
    if (edgeImage != null) {
      _paintEdgeWash(
        context: context,
        viewportOffset: offset,
        childOffset: childOffset,
        progress: progress,
        image: edgeImage,
      );
    }

    context.paintChild(child, childOffset);
    if (_allowEdgeSnapshot && _animation.isAnimating && _edgeImage == null) {
      _captureEdge(child);
    }
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final offset = _translationOffset;
    transform.translateByDouble(offset.dx, offset.dy, 0, 1);
  }

  Offset get _translationOffset => _translatedOffset(Offset.zero, _progress);

  Offset _translatedOffset(Offset offset, double progress) {
    final travelProgress = _outgoing ? progress : progress - 1;
    return switch (_direction) {
      MateoPageTransitionDirection.up => Offset(
        offset.dx,
        offset.dy - travelProgress * size.height,
      ),
      MateoPageTransitionDirection.down => Offset(
        offset.dx,
        offset.dy + travelProgress * size.height,
      ),
      MateoPageTransitionDirection.left => Offset(
        offset.dx - travelProgress * size.width,
        offset.dy,
      ),
      MateoPageTransitionDirection.right => Offset(
        offset.dx + travelProgress * size.width,
        offset.dy,
      ),
    };
  }

  void _paintEdgeWash({
    required PaintingContext context,
    required Offset viewportOffset,
    required Offset childOffset,
    required double progress,
    required ui.Image image,
  }) {
    final alpha = (progress * 255).round();
    if (alpha == 0 || alpha == 255) return;

    final destinationPaint = (_destinationPaint ??= Paint())..color = _mateoWhiteWithAlpha(alpha);
    context.canvas.drawImageRect(
      image,
      _edgeImageBounds,
      _visibleSourceRect(
        viewportOffset: viewportOffset,
        childOffset: childOffset,
      ),
      destinationPaint,
    );
  }

  void _captureEdge(RenderBox child) {
    final layer = child.layer;
    if (layer is! OffsetLayer || size.isEmpty) return;

    final image = layer.toImageSync(
      _edgeBounds,
      pixelRatio: _devicePixelRatio,
    );
    _edgeImage = image;
    _edgeImageBounds = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
  }

  Rect get _edgeBounds {
    final logicalPixel = 1 / _devicePixelRatio;
    return switch (_direction) {
      MateoPageTransitionDirection.up => Rect.fromLTWH(
        0,
        0,
        size.width,
        logicalPixel,
      ),
      MateoPageTransitionDirection.down => Rect.fromLTWH(
        0,
        size.height - logicalPixel,
        size.width,
        logicalPixel,
      ),
      MateoPageTransitionDirection.left => Rect.fromLTWH(
        0,
        0,
        logicalPixel,
        size.height,
      ),
      MateoPageTransitionDirection.right => Rect.fromLTWH(
        size.width - logicalPixel,
        0,
        logicalPixel,
        size.height,
      ),
    };
  }

  Rect _visibleSourceRect({
    required Offset viewportOffset,
    required Offset childOffset,
  }) {
    final left = viewportOffset.dx;
    final top = viewportOffset.dy;
    final width = size.width;
    final height = size.height;
    final right = left + width;
    final bottom = top + height;
    return switch (_direction) {
      MateoPageTransitionDirection.up => Rect.fromLTRB(
        left,
        top,
        right,
        math.min(bottom, childOffset.dy + _seamOverlap),
      ),
      MateoPageTransitionDirection.down => Rect.fromLTRB(
        left,
        math.max(top, childOffset.dy + height - _seamOverlap),
        right,
        bottom,
      ),
      MateoPageTransitionDirection.left => Rect.fromLTRB(
        left,
        top,
        math.min(right, childOffset.dx + _seamOverlap),
        bottom,
      ),
      MateoPageTransitionDirection.right => Rect.fromLTRB(
        math.max(left, childOffset.dx + width - _seamOverlap),
        top,
        right,
        bottom,
      ),
    };
  }

  void _handleAnimationTick() {
    _updateProgress();
    _markMotionChanged();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (!status.isAnimating) _disposeEdgeImage();
    markNeedsSemanticsUpdate();
  }

  void _updateProgress() {
    final animationValue = _animation.value;
    _progress = _useLinearProgress ? animationValue : _mateoPageEaseInOutCubic.transform(animationValue);
  }

  void _markMotionChanged() {
    markNeedsPaint();
  }

  void _disposeEdgeImage() {
    final edgeImage = _edgeImage;
    if (edgeImage == null) return;

    edgeImage.dispose();
    _edgeImage = null;
    _edgeImageBounds = Rect.zero;
  }

  @override
  void dispose() {
    _disposeEdgeImage();
    super.dispose();
  }
}
