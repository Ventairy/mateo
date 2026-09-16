part of 'mateo_message_bubble.dart';

enum _MateoMessageBubbleContentKind { message, typing }

class _MateoMessageBubbleTransitionValues {
  _MateoMessageBubbleTransitionValues({required this.targetIsTyping})
    : _beginMessageOpacity = targetIsTyping ? 0 : 1,
      _beginTypingOpacity = targetIsTyping ? 1 : 0;

  static const double messageGeometryIntervalEnd = 2 / 3;
  static const double _messageFadeIntervalStart = 0.15;

  bool targetIsTyping;
  double _beginMessageOpacity;
  double _beginTypingOpacity;

  double opacityFor(
    _MateoMessageBubbleContentKind kind,
    double rawProgress, {
    required bool transitioning,
  }) {
    if (!transitioning) {
      return switch (kind) {
        _MateoMessageBubbleContentKind.message => targetIsTyping ? 0 : 1,
        _MateoMessageBubbleContentKind.typing => targetIsTyping ? 1 : 0,
      };
    }

    final begin = switch (kind) {
      _MateoMessageBubbleContentKind.message => _beginMessageOpacity,
      _MateoMessageBubbleContentKind.typing => _beginTypingOpacity,
    };
    final target = switch (kind) {
      _MateoMessageBubbleContentKind.message => targetIsTyping ? 0.0 : 1.0,
      _MateoMessageBubbleContentKind.typing => targetIsTyping ? 1.0 : 0.0,
    };
    final progress = switch ((kind, targetIsTyping)) {
      (_MateoMessageBubbleContentKind.message, true) => 1 - Curves.easeInCubic.transform(1 - rawProgress),
      (_MateoMessageBubbleContentKind.message, false) => Curves.easeOutCubic.transform(
        ((rawProgress - _messageFadeIntervalStart) / (1 - _messageFadeIntervalStart)).clamp(0.0, 1.0),
      ),
      (_MateoMessageBubbleContentKind.typing, true) => Curves.easeOutCubic.transform(rawProgress),
      (_MateoMessageBubbleContentKind.typing, false) => 1 - Curves.easeInCubic.transform(1 - rawProgress),
    };
    return (begin + (target - begin) * progress).clamp(0.0, 1.0);
  }

  void capture(double rawProgress, {required bool transitioning}) {
    _beginMessageOpacity = opacityFor(
      _MateoMessageBubbleContentKind.message,
      rawProgress,
      transitioning: transitioning,
    );
    _beginTypingOpacity = opacityFor(
      _MateoMessageBubbleContentKind.typing,
      rawProgress,
      transitioning: transitioning,
    );
  }

  void finish({required bool isTyping}) {
    targetIsTyping = isTyping;
    _beginMessageOpacity = isTyping ? 0 : 1;
    _beginTypingOpacity = isTyping ? 1 : 0;
  }
}

class _MateoMessageBubbleContentParentData extends ContainerBoxParentData<RenderBox> {
  _MateoMessageBubbleContentKind? kind;
}

class _MateoMessageBubbleFadedContent extends SingleChildRenderObjectWidget {
  const _MateoMessageBubbleFadedContent({
    required this.controller,
    required this.transitionValues,
    required this.kind,
    required this.enabled,
    required super.child,
  });

  final AnimationController? controller;
  final _MateoMessageBubbleTransitionValues transitionValues;
  final _MateoMessageBubbleContentKind kind;
  final bool enabled;

  double get _opacity {
    final activeController = enabled ? controller : null;
    return activeController == null
        ? 1
        : transitionValues.opacityFor(
            kind,
            activeController.value,
            transitioning: true,
          );
  }

  @override
  _RenderMateoMessageBubbleFadedContent createRenderObject(
    BuildContext context,
  ) {
    return _RenderMateoMessageBubbleFadedContent(
      enabled: enabled,
      opacity: _opacity,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMateoMessageBubbleFadedContent renderObject,
  ) {
    renderObject.update(enabled: enabled, opacity: _opacity);
  }
}

class _RenderMateoMessageBubbleFadedContent extends RenderProxyBox {
  _RenderMateoMessageBubbleFadedContent({
    required bool enabled,
    required double opacity,
  }) : _enabled = enabled,
       _alpha = _alphaFor(enabled, opacity);

  bool _enabled;
  int _alpha;

  bool get hasLayer => layer != null;

  static int _alphaFor(bool enabled, double opacity) {
    return enabled ? (opacity.clamp(0.0, 1.0) * 255).round() : 255;
  }

  void update({required bool enabled, required double opacity}) {
    if (enabled == _enabled) {
      updateOpacity(opacity);
      return;
    }
    final wasRepaintBoundary = isRepaintBoundary;
    _enabled = enabled;
    _alpha = _alphaFor(enabled, opacity);
    if (wasRepaintBoundary != isRepaintBoundary) {
      markNeedsCompositingBitsUpdate();
    }
    markNeedsCompositedLayerUpdate();
    markNeedsPaint();
  }

  void updateOpacity(double opacity) {
    if (!_enabled) return;
    final alpha = _alphaFor(true, opacity);
    if (alpha == _alpha) return;
    final wasRepaintBoundary = isRepaintBoundary;
    final wasVisible = _alpha != 0;
    _alpha = alpha;
    if (wasRepaintBoundary != isRepaintBoundary) {
      markNeedsCompositingBitsUpdate();
    }
    markNeedsCompositedLayerUpdate();
    if (wasVisible != (alpha != 0)) markNeedsPaint();
  }

  @override
  bool get isRepaintBoundary => _enabled && _alpha != 0;

  @override
  OffsetLayer updateCompositedLayer({
    required covariant OpacityLayer? oldLayer,
  }) {
    return (oldLayer ?? OpacityLayer())..alpha = _alpha;
  }

  @override
  bool paintsChild(RenderBox child) => _alpha != 0;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_alpha != 0) super.paint(context, offset);
  }
}

class _MateoMessageBubbleCachedContent extends SingleChildRenderObjectWidget {
  const _MateoMessageBubbleCachedContent({
    required this.enabled,
    required super.child,
  });

  final bool enabled;

  @override
  _RenderMateoMessageBubbleCachedContent createRenderObject(
    BuildContext context,
  ) {
    return _RenderMateoMessageBubbleCachedContent(enabled: enabled);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMateoMessageBubbleCachedContent renderObject,
  ) {
    renderObject.enabled = enabled;
  }
}

class _RenderMateoMessageBubbleCachedContent extends RenderProxyBox {
  _RenderMateoMessageBubbleCachedContent({required this._enabled});

  bool _enabled;

  bool get hasLayer => layer != null;

  bool get enabled => _enabled;

  set enabled(bool value) {
    if (value == _enabled) return;
    _enabled = value;
    markNeedsCompositingBitsUpdate();
    markNeedsPaint();
  }

  @override
  bool get isRepaintBoundary => _enabled;
}

class _MateoMessageBubbleContent extends ParentDataWidget<_MateoMessageBubbleContentParentData> {
  const _MateoMessageBubbleContent({
    required this.kind,
    required super.child,
    super.key,
  });

  final _MateoMessageBubbleContentKind kind;

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData! as _MateoMessageBubbleContentParentData;
    if (parentData.kind == kind) return;
    parentData.kind = kind;
    final parent = renderObject.parent;
    if (parent is RenderObject) parent.markNeedsLayout();
  }

  @override
  Type get debugTypicalAncestorWidgetClass => _MateoMessageBubbleSurface;
}

class _MateoMessageBubbleSurface extends MultiChildRenderObjectWidget {
  const _MateoMessageBubbleSurface({
    required this.controller,
    required this.transitionValues,
    required this.transitionGeneration,
    required this.targetIsTyping,
    required this.direction,
    required this.backgroundColor,
    required this.constraints,
    required this.useSurfaceMessageFade,
    required super.children,
    super.key,
  });

  final AnimationController? controller;
  final _MateoMessageBubbleTransitionValues transitionValues;
  final int transitionGeneration;
  final bool targetIsTyping;
  final MateoMessageDirection direction;
  final Color backgroundColor;
  final BoxConstraints? constraints;
  final bool useSurfaceMessageFade;

  @override
  _RenderMateoMessageBubbleSurface createRenderObject(BuildContext context) {
    return _RenderMateoMessageBubbleSurface(
      controller: controller,
      transitionValues: transitionValues,
      transitionGeneration: transitionGeneration,
      targetIsTyping: targetIsTyping,
      direction: direction,
      backgroundColor: backgroundColor,
      additionalConstraints: constraints,
      useSurfaceMessageFade: useSurfaceMessageFade,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMateoMessageBubbleSurface renderObject,
  ) {
    renderObject
      ..controller = controller
      ..direction = direction
      ..backgroundColor = backgroundColor
      ..additionalConstraints = constraints
      ..useSurfaceMessageFade = useSurfaceMessageFade
      ..updateTransition(
        generation: transitionGeneration,
        targetIsTyping: targetIsTyping,
      );
  }
}

class _RenderMateoMessageBubbleSurface extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _MateoMessageBubbleContentParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _MateoMessageBubbleContentParentData> {
  _RenderMateoMessageBubbleSurface({
    required this._controller,
    required this._transitionValues,
    required this._transitionGeneration,
    required this._targetIsTyping,
    required this._direction,
    required Color backgroundColor,
    required BoxConstraints? additionalConstraints,
    required bool useSurfaceMessageFade,
  }) : assert(
         additionalConstraints == null || additionalConstraints.debugAssertIsValid(),
         'constraints must be valid',
       ),
       _backgroundColor = backgroundColor {
    _additionalConstraints = additionalConstraints;
    _useSurfaceMessageFade = useSurfaceMessageFade;
    _backgroundPaint.color = backgroundColor;
  }

  static const _incomingContentInsets = EdgeInsets.fromLTRB(
    _MateoMessageBubbleShape.tailWidth + 24,
    18,
    24,
    _MateoMessageBubbleShape.tailHeight + 18,
  );
  static const _outgoingContentInsets = EdgeInsets.fromLTRB(
    24,
    18,
    _MateoMessageBubbleShape.tailWidth + 24,
    _MateoMessageBubbleShape.tailHeight + 18,
  );
  static const _morphDuration = Duration(milliseconds: 300);
  static const _messageContentDuration = Duration(milliseconds: 450);
  static const Curve _messageMorphCurve = Curves.easeOutBack;
  static const Curve _typingMorphCurve = Curves.easeInOutCubic;

  final Paint _backgroundPaint = Paint();
  final Paint _fadePaint = Paint();
  final LayerHandle<ClipRRectLayer> _clipLayer = LayerHandle<ClipRRectLayer>();

  late final PaintingContextCallback _paintClippedContents = _paintContents;

  AnimationController? _controller;
  final _MateoMessageBubbleTransitionValues _transitionValues;
  int _transitionGeneration;
  bool _targetIsTyping;
  MateoMessageDirection _direction;
  Color _backgroundColor;
  late BoxConstraints? _additionalConstraints;
  late bool _useSurfaceMessageFade;
  bool _hasContentTransition = false;
  bool _transitionNeedsTargetSize = false;
  bool _geometryNeedsFinalLayout = false;
  bool _hasVisualOverflow = false;
  bool _layingOut = false;
  Size? _beginContentSize;
  Size? _targetContentSize;
  Path? _bodyPath;
  Size? _shapeSize;
  MateoMessageDirection? _shapeDirection;
  RenderBox? _messageChild;
  RenderBox? _typingChild;
  Size? _typingNaturalSize;

  AnimationController? get controller => _controller;

  set controller(AnimationController? value) {
    if (identical(value, _controller)) return;
    if (attached) {
      _controller
        ?..removeListener(_handleTick)
        ..removeStatusListener(_handleStatus);
    }
    _controller = value;
    if (attached) {
      _controller
        ?..addListener(_handleTick)
        ..addStatusListener(_handleStatus);
    }
    if (value == null) {
      _finishImmediately();
    }
    markNeedsLayout();
  }

  MateoMessageDirection get direction => _direction;

  set direction(MateoMessageDirection value) {
    if (value == _direction) return;
    _direction = value;
    _invalidateShape();
    markNeedsLayout();
  }

  Color get backgroundColor => _backgroundColor;

  set backgroundColor(Color value) {
    if (value == _backgroundColor) return;
    _backgroundColor = value;
    _backgroundPaint.color = value;
    markNeedsPaint();
  }

  BoxConstraints? get additionalConstraints => _additionalConstraints;

  set additionalConstraints(BoxConstraints? value) {
    assert(
      value == null || value.debugAssertIsValid(),
      'constraints must be valid',
    );
    if (value == _additionalConstraints) return;
    _additionalConstraints = value;
    markNeedsLayout();
  }

  bool get useSurfaceMessageFade => _useSurfaceMessageFade;

  set useSurfaceMessageFade(bool value) {
    if (value == useSurfaceMessageFade) return;
    _useSurfaceMessageFade = value;
    markNeedsCompositingBitsUpdate();
    markNeedsPaint();
  }

  EdgeInsets get _contentInsets => switch (_direction) {
    MateoMessageDirection.incoming => _incomingContentInsets,
    MateoMessageDirection.outgoing => _outgoingContentInsets,
  };

  BoxConstraints _targetConstraintsFor(BoxConstraints parentConstraints) {
    final additional = _additionalConstraints;
    return additional == null ? parentConstraints : additional.enforce(parentConstraints);
  }

  double _constrainIntrinsicWidth(double width) => _additionalConstraints?.constrainWidth(width) ?? width;

  double _constrainIntrinsicHeight(double height) => _additionalConstraints?.constrainHeight(height) ?? height;

  RenderBox? get _targetChild => _targetIsTyping ? _typingChild : _messageChild;

  RenderBox? get _previousChild => _targetIsTyping ? _messageChild : _typingChild;

  Curve get geometryCurve => _hasContentTransition && !_targetIsTyping ? _messageMorphCurve : _typingMorphCurve;

  bool get geometryIsAnimating => _geometryIsAnimating;

  bool get hasContentTransition => _hasContentTransition;

  double get messageOpacity => _messageOpacity;

  double get typingOpacity => _typingOpacity;

  bool get hasClipLayer => _clipLayer.layer != null;

  bool get messageFadeHasLayer {
    final message = _messageChild;
    return message is _RenderMateoMessageBubbleFadedContent && message.hasLayer;
  }

  bool get messageCacheHasLayer {
    final message = _messageChild;
    final cachedMessage = message is RenderProxyBox && message.child is _RenderMateoMessageBubbleCachedContent
        ? message.child! as _RenderMateoMessageBubbleCachedContent
        : null;
    return cachedMessage?.hasLayer ?? false;
  }

  bool get typingFadeHasLayer {
    final typing = _typingChild;
    return typing is _RenderMateoMessageBubbleFadedContent && typing.hasLayer;
  }

  bool get hasTransitionLayers => hasClipLayer || messageFadeHasLayer || messageCacheHasLayer || typingFadeHasLayer;

  bool get usesSurfaceMessageFade => _useSurfaceMessageFade;

  bool get messageUsesOpacityLayer {
    final message = _messageChild;
    return message is _RenderMateoMessageBubbleFadedContent && message.hasLayer;
  }

  Path get shapePath => _resolvedBodyPath;

  double get dotRadius => _MateoMessageBubbleShape.dotRadiusFor(size);

  Offset get dotCenter => _MateoMessageBubbleShape.dotCenterFor(
    size,
    _direction,
    dotRadius,
  );

  double get _rawProgress => _controller?.value ?? 1;

  double get _geometryProgress {
    var progress = _rawProgress;
    if (_hasContentTransition && !_targetIsTyping) {
      progress = math.min(
        1,
        progress / _MateoMessageBubbleTransitionValues.messageGeometryIntervalEnd,
      );
    }
    return geometryCurve.transform(progress);
  }

  Size get _currentContentSize {
    final target = _targetContentSize;
    if (target == null) return Size.zero;
    final begin = _beginContentSize ?? target;
    return Size.lerp(begin, target, _geometryProgress)!;
  }

  double get _messageOpacity {
    return _transitionValues.opacityFor(
      _MateoMessageBubbleContentKind.message,
      _rawProgress,
      transitioning: _hasContentTransition,
    );
  }

  double get _typingOpacity {
    return _transitionValues.opacityFor(
      _MateoMessageBubbleContentKind.typing,
      _rawProgress,
      transitioning: _hasContentTransition,
    );
  }

  bool get _geometryIsAnimating {
    final controller = _controller;
    if (controller == null || !controller.isAnimating) return false;
    return !_hasContentTransition ||
        _targetIsTyping ||
        controller.value < _MateoMessageBubbleTransitionValues.messageGeometryIntervalEnd;
  }

  void updateTransition({
    required int generation,
    required bool targetIsTyping,
  }) {
    if (generation == _transitionGeneration && targetIsTyping == _targetIsTyping) {
      return;
    }
    _captureVisualState();
    _transitionGeneration = generation;
    _targetIsTyping = targetIsTyping;
    _transitionValues.targetIsTyping = targetIsTyping;
    if (_controller == null) {
      _finishImmediately();
    } else {
      _hasContentTransition = true;
      _transitionNeedsTargetSize = true;
      _startAnimation();
    }
    markNeedsLayout();
  }

  void _captureVisualState() {
    _beginContentSize = _currentContentSize;
    _transitionValues.capture(
      _rawProgress,
      transitioning: _hasContentTransition,
    );
  }

  void _startAnimation() {
    final controller = _controller;
    if (controller == null) return;
    controller
      ..duration = _hasContentTransition && !_targetIsTyping ? _messageContentDuration : _morphDuration
      ..forward(from: 0);
    _geometryNeedsFinalLayout = true;
  }

  void _finishImmediately() {
    _hasContentTransition = false;
    _transitionNeedsTargetSize = false;
    _geometryNeedsFinalLayout = false;
    _beginContentSize = _targetContentSize;
    _transitionValues.finish(isTyping: _targetIsTyping);
    _syncContentFades();
    _clearTransitionLayers();
    markNeedsPaint();
  }

  void _handleTick() {
    if (_layingOut) return;
    _syncContentFades();
    if (_geometryIsAnimating) {
      markNeedsLayout();
      return;
    }
    if (_geometryNeedsFinalLayout) {
      _geometryNeedsFinalLayout = false;
      markNeedsLayout();
      return;
    }
    if (usesSurfaceMessageFade) {
      markNeedsPaint();
    }
  }

  void _handleStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    _beginContentSize = _targetContentSize;
    _transitionValues.finish(isTyping: _targetIsTyping);
    _hasContentTransition = false;
    _transitionNeedsTargetSize = false;
    _geometryNeedsFinalLayout = false;
    _syncContentFades();
    _clearTransitionLayers();
    markNeedsLayout();
  }

  void _retargetSize(Size target) {
    if (_transitionNeedsTargetSize) {
      _transitionNeedsTargetSize = false;
      _beginContentSize ??= target;
      _targetContentSize = target;
      return;
    }
    if (_targetContentSize == null) {
      _beginContentSize = _targetContentSize = target;
      return;
    }
    if (_targetContentSize == target) return;
    _captureVisualState();
    _targetContentSize = target;
    if (_controller == null) {
      _beginContentSize = target;
    } else {
      _startAnimation();
    }
  }

  void _refreshChildren() {
    final previousTypingChild = _typingChild;
    _messageChild = null;
    _typingChild = null;
    var child = firstChild;
    while (child != null) {
      final parentData = child.parentData! as _MateoMessageBubbleContentParentData;
      switch (parentData.kind) {
        case _MateoMessageBubbleContentKind.message:
          _messageChild = child;
        case _MateoMessageBubbleContentKind.typing:
          _typingChild = child;
        case null:
          break;
      }
      child = parentData.nextSibling;
    }
    if (!identical(previousTypingChild, _typingChild)) {
      _typingNaturalSize = null;
    }
  }

  void _syncContentFades() {
    final message = _messageChild;
    if (message is _RenderMateoMessageBubbleFadedContent) {
      message.updateOpacity(_messageOpacity);
    }
    final typing = _typingChild;
    if (typing is _RenderMateoMessageBubbleFadedContent) {
      typing.updateOpacity(_typingOpacity);
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _MateoMessageBubbleContentParentData) {
      child.parentData = _MateoMessageBubbleContentParentData();
    }
  }

  @override
  void performLayout() {
    _layingOut = true;
    try {
      _refreshChildren();
      final targetChild = _targetChild;
      if (targetChild == null) {
        size = constraints.smallest;
        return;
      }

      final targetConstraints = _targetConstraintsFor(constraints);
      final contentConstraints = targetConstraints.deflate(_contentInsets);
      targetChild.layout(contentConstraints, parentUsesSize: true);
      final previousChild = _previousChild;
      if (previousChild != null) {
        previousChild.layout(
          previousChild.hasSize ? previousChild.constraints : contentConstraints,
          parentUsesSize: true,
        );
      }
      final targetBubbleSize = targetConstraints.constrain(
        Size(
          targetChild.size.width + _contentInsets.horizontal,
          targetChild.size.height + _contentInsets.vertical,
        ),
      );
      _retargetSize(
        Size(
          targetBubbleSize.width - _contentInsets.horizontal,
          targetBubbleSize.height - _contentInsets.vertical,
        ),
      );

      final contentSize = _currentContentSize;
      final desiredSize = Size(
        contentSize.width + _contentInsets.horizontal,
        contentSize.height + _contentInsets.vertical,
      );
      size = constraints.constrain(desiredSize);
      final typingNaturalSize = _targetIsTyping
          ? (_typingNaturalSize ??= targetChild.getDryLayout(const BoxConstraints()))
          : targetChild.size;
      final visibleContentSize = Size(
        math.max(0, size.width - _contentInsets.horizontal),
        math.max(0, size.height - _contentInsets.vertical),
      );
      final messageChild = _messageChild;
      final typingChild = _typingChild;
      final retainedContentOverflows =
          (messageChild != null &&
              (messageChild.size.width > visibleContentSize.width + precisionErrorTolerance ||
                  messageChild.size.height > visibleContentSize.height + precisionErrorTolerance)) ||
          (typingChild != null &&
              (typingChild.size.width > visibleContentSize.width + precisionErrorTolerance ||
                  typingChild.size.height > visibleContentSize.height + precisionErrorTolerance));
      _hasVisualOverflow =
          desiredSize.width > size.width + precisionErrorTolerance ||
          desiredSize.height > size.height + precisionErrorTolerance ||
          typingNaturalSize.width > targetChild.size.width + precisionErrorTolerance ||
          typingNaturalSize.height > targetChild.size.height + precisionErrorTolerance ||
          retainedContentOverflows;
      var child = firstChild;
      while (child != null) {
        final parentData = child.parentData! as _MateoMessageBubbleContentParentData;
        child =
            (parentData
                  ..offset = Offset(
                    _contentInsets.left,
                    _contentInsets.top + visibleContentSize.height - child.size.height,
                  ))
                .nextSibling;
      }
      _invalidateShapeIfSizeChanged();
    } finally {
      _layingOut = false;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    _refreshChildren();
    final targetChild = _targetChild;
    if (targetChild == null) return constraints.smallest;
    final targetConstraints = _targetConstraintsFor(constraints);
    final contentConstraints = targetConstraints.deflate(_contentInsets);
    final dryChildSize = targetChild.getDryLayout(contentConstraints);
    final dryTargetBubbleSize = targetConstraints.constrain(
      Size(
        dryChildSize.width + _contentInsets.horizontal,
        dryChildSize.height + _contentInsets.vertical,
      ),
    );
    final dryTargetContentSize = Size(
      dryTargetBubbleSize.width - _contentInsets.horizontal,
      dryTargetBubbleSize.height - _contentInsets.vertical,
    );
    final contentSize = _targetContentSize == dryTargetContentSize ? _currentContentSize : dryTargetContentSize;
    return constraints.constrain(
      Size(
        contentSize.width + _contentInsets.horizontal,
        contentSize.height + _contentInsets.vertical,
      ),
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    _refreshChildren();
    final childHeight = height <= _contentInsets.vertical ? 0.0 : height - _contentInsets.vertical;
    return _constrainIntrinsicWidth(
      (_targetChild?.getMinIntrinsicWidth(childHeight) ?? 0) + _contentInsets.horizontal,
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    _refreshChildren();
    final childHeight = height <= _contentInsets.vertical ? 0.0 : height - _contentInsets.vertical;
    return _constrainIntrinsicWidth(
      (_targetChild?.getMaxIntrinsicWidth(childHeight) ?? 0) + _contentInsets.horizontal,
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    _refreshChildren();
    final constrainedWidth = _constrainIntrinsicWidth(width);
    final childWidth = constrainedWidth <= _contentInsets.horizontal
        ? 0.0
        : constrainedWidth - _contentInsets.horizontal;
    return _constrainIntrinsicHeight(
      (_targetChild?.getMinIntrinsicHeight(childWidth) ?? 0) + _contentInsets.vertical,
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    _refreshChildren();
    final constrainedWidth = _constrainIntrinsicWidth(width);
    final childWidth = constrainedWidth <= _contentInsets.horizontal
        ? 0.0
        : constrainedWidth - _contentInsets.horizontal;
    return _constrainIntrinsicHeight(
      (_targetChild?.getMaxIntrinsicHeight(childWidth) ?? 0) + _contentInsets.vertical,
    );
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    final child = _targetChild;
    if (child == null) return null;
    final childBaseline = child.getDistanceToActualBaseline(baseline);
    if (childBaseline == null) return null;
    final parentData = child.parentData! as _MateoMessageBubbleContentParentData;
    return childBaseline + parentData.offset.dy;
  }

  @override
  double? computeDryBaseline(
    covariant BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    _refreshChildren();
    final child = _targetChild;
    if (child == null) return null;
    final targetConstraints = _targetConstraintsFor(constraints);
    final contentConstraints = targetConstraints.deflate(_contentInsets);
    final childBaseline = child.getDryBaseline(contentConstraints, baseline);
    if (childBaseline == null) return null;
    final childSize = child.getDryLayout(contentConstraints);
    final drySize = computeDryLayout(constraints);
    final visibleContentHeight = math.max(
      0,
      drySize.height - _contentInsets.vertical,
    );
    return childBaseline + _contentInsets.top + visibleContentHeight - childSize.height;
  }

  void _invalidateShapeIfSizeChanged() {
    if (_shapeSize != size || _shapeDirection != _direction) _invalidateShape();
  }

  void _invalidateShape() {
    _shapeSize = null;
    _shapeDirection = null;
    markNeedsPaint();
  }

  Path get _resolvedBodyPath {
    if (_bodyPath == null || _shapeSize != size || _shapeDirection != _direction) {
      _shapeSize = size;
      _shapeDirection = _direction;
      _bodyPath = _MateoMessageBubbleShape.bodyAndLobePathFor(
        size,
        _direction,
        _bodyPath,
      );
    }
    return _bodyPath!;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final bodyPath = _resolvedBodyPath;
    final dotRadius = _MateoMessageBubbleShape.dotRadiusFor(size);
    final dotCenter = _MateoMessageBubbleShape.dotCenterFor(
      size,
      _direction,
      dotRadius,
    );

    if (_geometryIsAnimating || _hasVisualOverflow) {
      context.canvas
        ..save()
        ..translate(offset.dx, offset.dy)
        ..drawPath(bodyPath, _backgroundPaint)
        ..drawCircle(dotCenter, dotRadius, _backgroundPaint)
        ..restore();
      _clipLayer.layer = context.pushClipRRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        _MateoMessageBubbleShape.contentClipFor(size, _direction),
        _paintClippedContents,
        oldLayer: _clipLayer.layer,
      );
    } else {
      _clipLayer.layer = null;
      context.canvas
        ..save()
        ..translate(offset.dx, offset.dy)
        ..drawPath(bodyPath, _backgroundPaint)
        ..drawCircle(dotCenter, dotRadius, _backgroundPaint)
        ..restore();
      _paintContents(context, offset);
    }
  }

  void _paintContents(PaintingContext context, Offset offset) {
    // The surface is solid, so painting its color over a child is visually
    // equivalent to lowering that child's opacity. This keeps the crossfade in
    // one display list instead of allocating an off-screen opacity layer or
    // rebuilding the text paragraph on every animation tick.
    _paintContent(
      context,
      offset,
      _messageChild,
      opacity: _messageOpacity,
      useSurfaceFade: _useSurfaceMessageFade,
    );
    _paintContent(
      context,
      offset,
      _typingChild,
      opacity: _typingOpacity,
      useSurfaceFade: false,
    );
  }

  void _paintContent(
    PaintingContext context,
    Offset offset,
    RenderBox? child, {
    required double opacity,
    required bool useSurfaceFade,
  }) {
    if (child == null || (useSurfaceFade && opacity <= 0)) return;
    final parentData = child.parentData! as _MateoMessageBubbleContentParentData;
    final childOffset = offset + parentData.offset;
    context.paintChild(child, childOffset);
    if (!useSurfaceFade || opacity >= 1) return;
    _fadePaint.color = _backgroundColor.withValues(
      alpha: _backgroundColor.a * (1 - opacity),
    );
    context.canvas.drawRect(childOffset & child.size, _fadePaint);
  }

  @override
  bool paintsChild(RenderBox child) {
    return !identical(child, _messageChild) || !_useSurfaceMessageFade || _messageOpacity > 0;
  }

  void _clearTransitionLayers() {
    _clipLayer.layer = null;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final child = _targetChild;
    if (child == null || !_MateoMessageBubbleShape.contentClipFor(size, _direction).contains(position)) {
      return false;
    }
    final parentData = child.parentData! as _MateoMessageBubbleContentParentData;
    return result.addWithPaintOffset(
      offset: parentData.offset,
      position: position,
      hitTest: (result, transformed) => child.hitTest(result, position: transformed),
    );
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    final child = _targetChild;
    if (child != null) visitor(child);
  }

  @override
  bool hitTestSelf(Offset position) {
    if (_resolvedBodyPath.contains(position)) return true;
    final radius = _MateoMessageBubbleShape.dotRadiusFor(size);
    final center = _MateoMessageBubbleShape.dotCenterFor(
      size,
      _direction,
      radius,
    );
    final delta = position - center;
    return delta.distanceSquared <= radius * radius;
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final parentData = child.parentData! as _MateoMessageBubbleContentParentData;
    transform.translateByDouble(parentData.offset.dx, parentData.offset.dy, 0, 1);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _controller
      ?..addListener(_handleTick)
      ..addStatusListener(_handleStatus);
    _refreshChildren();
    _syncContentFades();
    if (_hasContentTransition && _controller?.status == AnimationStatus.completed) {
      _handleStatus(AnimationStatus.completed);
    }
  }

  @override
  void detach() {
    _controller
      ?..removeListener(_handleTick)
      ..removeStatusListener(_handleStatus);
    super.detach();
  }

  @override
  void dispose() {
    _clearTransitionLayers();
    super.dispose();
  }
}
