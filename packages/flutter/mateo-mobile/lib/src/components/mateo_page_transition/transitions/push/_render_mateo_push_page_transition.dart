part of '../../mateo_page_transition.dart';

final class _RenderMateoPushPageTransition extends RenderProxyBox implements MaybeSafeAreaTransform {
  _RenderMateoPushPageTransition({
    required this._animation,
    required this._transition,
    required this._outgoing,
    required this._allowPageSnapshot,
    required this._allowEdgeSnapshot,
    required this._useLinearProgress,
    required this._devicePixelRatio,
    required this._snapshot,
  });

  static const _seamOverlap = 1.0;

  Paint? _destinationPaint;
  ui.Image? _edgeImage;
  bool _edgeSnapshotUnavailable = false;
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
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  MateoPageTransitionPush get transition => _transition;
  MateoPageTransitionPush _transition;
  set transition(MateoPageTransitionPush value) {
    if (value == _transition) return;
    _transition = value;
    _disposeEdgeImage();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  bool get outgoing => _outgoing;
  bool _outgoing;
  set outgoing(bool value) {
    if (value == _outgoing) return;
    _outgoing = value;
    markNeedsPaint();
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

  bool _allowPageSnapshot;
  bool get allowPageSnapshot => _allowPageSnapshot;
  set allowPageSnapshot(bool value) {
    if (value == _allowPageSnapshot) return;
    _allowPageSnapshot = value;
    markNeedsLayout();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  bool get usesRestingSafeAreaGeometry => _allowPageSnapshot;

  @override
  void applyRestingPaintTransform(RenderObject child, Matrix4 transform) {
    // Push moves the complete page. Its safe-area geometry stays at rest;
    // applyPaintTransform still supplies the moving position to interactions.
  }

  bool get useLinearProgress => _useLinearProgress;
  bool _useLinearProgress;
  set useLinearProgress(bool value) {
    if (value == _useLinearProgress || (!value && _animation.isAnimating)) return;
    _useLinearProgress = value;
    _updateProgress();
    markNeedsPaint();
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

  _MateoPushPageSnapshot? Function() get snapshot => _snapshot;
  _MateoPushPageSnapshot? Function() _snapshot;
  set snapshot(_MateoPushPageSnapshot? Function() value) {
    if (value == _snapshot) return;
    _snapshot = value;
    if (_allowEdgeSnapshot) markNeedsPaint();
  }

  _MateoPushPageSnapshot? get _edgeSourceSnapshot {
    if (!_allowEdgeSnapshot) return null;
    final snapshot = _snapshot();
    if (snapshot == null ||
        snapshot.pixelRatio != _devicePixelRatio ||
        snapshot.sourceSize != size * _devicePixelRatio) {
      return null;
    }
    return snapshot;
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
    final edgeSnapshot = _edgeSourceSnapshot;
    final edgeImage = edgeSnapshot?.image ?? _edgeImage;
    if (edgeImage != null) {
      _paintEdgeWash(
        context: context,
        viewportOffset: offset,
        childOffset: childOffset,
        progress: progress,
        image: edgeImage,
        sourceBounds: edgeSnapshot == null ? _edgeImageBounds : _edgeSnapshotBounds(edgeSnapshot),
      );
    }

    context.paintChild(child, childOffset);
    if (_allowEdgeSnapshot &&
        _animation.isAnimating &&
        _edgeImage == null &&
        !_edgeSnapshotUnavailable &&
        _edgeSourceSnapshot == null) {
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
    if (travelProgress == 0) return offset;
    return switch (_transition.direction) {
      .up => Offset(
        offset.dx,
        offset.dy - travelProgress * size.height,
      ),
      .down => Offset(
        offset.dx,
        offset.dy + travelProgress * size.height,
      ),
      .left => Offset(
        offset.dx - travelProgress * size.width,
        offset.dy,
      ),
      .right => Offset(
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
    required Rect sourceBounds,
  }) {
    final alpha = (progress * 255).round();
    if (alpha == 0 || alpha == 255) return;

    final destinationPaint = (_destinationPaint ??= Paint())..color = Color.fromARGB(alpha, 255, 255, 255);
    context.canvas.drawImageRect(
      image,
      sourceBounds,
      _visibleSourceRect(
        viewportOffset: viewportOffset,
        childOffset: childOffset,
      ),
      destinationPaint,
    );
  }

  Rect _edgeSnapshotBounds(_MateoPushPageSnapshot snapshot) => switch (_transition.direction) {
    .up => .fromLTWH(0, 0, snapshot.sourceSize.width, 1),
    .down => .fromLTWH(0, snapshot.sourceSize.height - 1, snapshot.sourceSize.width, 1),
    .left => .fromLTWH(0, 0, 1, snapshot.sourceSize.height),
    .right => .fromLTWH(snapshot.sourceSize.width - 1, 0, 1, snapshot.sourceSize.height),
  };

  void _captureEdge(RenderBox child) {
    final layer = child.layer;
    if (layer is! OffsetLayer || size.isEmpty) return;
    if (!layer.supportsRasterization()) {
      _edgeSnapshotUnavailable = true;
      return;
    }

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
    return switch (_transition.direction) {
      .up => Rect.fromLTWH(
        0,
        0,
        size.width,
        logicalPixel,
      ),
      .down => Rect.fromLTWH(
        0,
        size.height - logicalPixel,
        size.width,
        logicalPixel,
      ),
      .left => Rect.fromLTWH(
        0,
        0,
        logicalPixel,
        size.height,
      ),
      .right => Rect.fromLTWH(
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
    return switch (_transition.direction) {
      .up => Rect.fromLTRB(
        left,
        top,
        right,
        math.min(bottom, childOffset.dy + _seamOverlap),
      ),
      .down => Rect.fromLTRB(
        left,
        math.max(top, childOffset.dy + height - _seamOverlap),
        right,
        bottom,
      ),
      .left => Rect.fromLTRB(
        left,
        top,
        math.min(right, childOffset.dx + _seamOverlap),
        bottom,
      ),
      .right => Rect.fromLTRB(
        math.max(left, childOffset.dx + width - _seamOverlap),
        top,
        right,
        bottom,
      ),
    };
  }

  void _handleAnimationTick() {
    final previousProgress = _progress;
    _updateProgress();
    if (_progress == previousProgress) return;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (!status.isAnimating) {
      _useLinearProgress = false;
      _disposeEdgeImage();
    }
    markNeedsSemanticsUpdate();
  }

  void _updateProgress() {
    final animationValue = _animation.value;
    _progress = _useLinearProgress ? animationValue : _transition.curve.transform(animationValue);
  }

  void _disposeEdgeImage() {
    _edgeSnapshotUnavailable = false;
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
