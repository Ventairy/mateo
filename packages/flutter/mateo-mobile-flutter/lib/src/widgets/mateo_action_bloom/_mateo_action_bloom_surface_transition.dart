part of 'mateo_action_bloom.dart';

class _MateoActionBloomSurfaceTransition extends SingleChildRenderObjectWidget {
  const _MateoActionBloomSurfaceTransition({
    required this.sourceSize,
    required this.animation,
    required this.sourceBackgroundColor,
    required this.sourceBorderRadius,
    required this.sourceBorderSide,
    required this.sourceAlignment,
    required this.sourceOffsetFromPanelAnchor,
    required super.child,
    super.key,
  });

  static const _panelBorderRadius = BorderRadius.all(Radius.circular(32));

  final Size sourceSize;
  final Animation<double> animation;
  final Color sourceBackgroundColor;
  final BorderRadius sourceBorderRadius;
  final BorderSide? sourceBorderSide;
  final Alignment sourceAlignment;
  final Offset sourceOffsetFromPanelAnchor;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMateoActionBloomSurfaceTransition(
      sourceSize: sourceSize,
      animation: animation,
      sourceBackgroundColor: sourceBackgroundColor,
      panelBackgroundColor: context.mateo.colorScheme.background,
      sourceBorderRadius: sourceBorderRadius,
      sourceBorderSide: sourceBorderSide,
      sourceAlignment: sourceAlignment,
      sourceOffsetFromPanelAnchor: sourceOffsetFromPanelAnchor,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMateoActionBloomSurfaceTransition renderObject,
  ) {
    renderObject
      ..sourceSize = sourceSize
      ..animation = animation
      ..sourceBackgroundColor = sourceBackgroundColor
      ..panelBackgroundColor = context.mateo.colorScheme.background
      ..sourceBorderRadius = sourceBorderRadius
      ..sourceBorderSide = sourceBorderSide
      ..sourceAlignment = sourceAlignment
      ..sourceOffsetFromPanelAnchor = sourceOffsetFromPanelAnchor;
  }
}

class _RenderMateoActionBloomSurfaceTransition extends RenderProxyBox {
  _RenderMateoActionBloomSurfaceTransition({
    required this._sourceSize,
    required this._animation,
    required this._sourceBackgroundColor,
    required this._panelBackgroundColor,
    required this._sourceBorderRadius,
    required this._sourceBorderSide,
    required this._sourceAlignment,
    required this._sourceOffsetFromPanelAnchor,
  }) {
    _resolveSourceBorderRadius();
  }

  final LayerHandle<ClipRSuperellipseLayer> _clipLayer =
      LayerHandle<ClipRSuperellipseLayer>();
  final LayerHandle<TransformLayer> _contentTransformLayer =
      LayerHandle<TransformLayer>();
  final Matrix4 _contentTransform = Matrix4.identity();
  final Path _surfacePath = Path();
  final Path _borderPath = Path();
  final Paint _surfacePaint = Paint();
  final Paint _borderPaint = Paint()..style = PaintingStyle.stroke;
  Size _sourceSize;
  Animation<double> _animation;
  Color _sourceBackgroundColor;
  Color _panelBackgroundColor;
  BorderRadius _sourceBorderRadius;
  late BorderRadius _resolvedSourceBorderRadius;
  BorderSide? _sourceBorderSide;
  Alignment _sourceAlignment;
  Offset _sourceOffsetFromPanelAnchor;

  Size get sourceSize => _sourceSize;

  set sourceSize(Size value) {
    if (value == _sourceSize) return;
    _sourceSize = value;
    _resolveSourceBorderRadius();
    markNeedsPaint();
  }

  Animation<double> get animation => _animation;

  set animation(Animation<double> value) {
    if (identical(value, _animation)) return;
    if (attached) _animation.removeListener(markNeedsPaint);
    _animation = value;
    if (attached) _animation.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  Color get sourceBackgroundColor => _sourceBackgroundColor;

  set sourceBackgroundColor(Color value) {
    if (value == _sourceBackgroundColor) return;
    _sourceBackgroundColor = value;
    markNeedsPaint();
  }

  Color get panelBackgroundColor => _panelBackgroundColor;

  set panelBackgroundColor(Color value) {
    if (value == _panelBackgroundColor) return;
    _panelBackgroundColor = value;
    markNeedsPaint();
  }

  BorderRadius get sourceBorderRadius => _sourceBorderRadius;

  set sourceBorderRadius(BorderRadius value) {
    if (value == _sourceBorderRadius) return;
    _sourceBorderRadius = value;
    _resolveSourceBorderRadius();
    markNeedsPaint();
  }

  BorderSide? get sourceBorderSide => _sourceBorderSide;

  set sourceBorderSide(BorderSide? value) {
    if (value == _sourceBorderSide) return;
    _sourceBorderSide = value;
    markNeedsPaint();
  }

  Alignment get sourceAlignment => _sourceAlignment;

  set sourceAlignment(Alignment value) {
    if (value == _sourceAlignment) return;
    _sourceAlignment = value;
    markNeedsPaint();
  }

  Offset get sourceOffsetFromPanelAnchor => _sourceOffsetFromPanelAnchor;

  set sourceOffsetFromPanelAnchor(Offset value) {
    if (value == _sourceOffsetFromPanelAnchor) return;
    _sourceOffsetFromPanelAnchor = value;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _animation.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _animation.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  void _resolveSourceBorderRadius() {
    final scaledRRect = _sourceBorderRadius
        .toRRect(Offset.zero & _sourceSize)
        .scaleRadii();
    _resolvedSourceBorderRadius = BorderRadius.only(
      topLeft: scaledRRect.tlRadius,
      topRight: scaledRRect.trRadius,
      bottomLeft: scaledRRect.blRadius,
      bottomRight: scaledRRect.brRadius,
    );
  }

  RSuperellipse _surfaceRSuperellipseAt(double progress) {
    return BorderRadius.lerp(
      _resolvedSourceBorderRadius,
      _MateoActionBloomSurfaceTransition._panelBorderRadius,
      progress,
    )!.toRSuperellipse(
      Rect.lerp(_sourceRect, Offset.zero & size, progress)!,
    );
  }

  Matrix4 _updateContentTransform(Rect surfaceRect) {
    return _contentTransform
      ..setIdentity()
      ..translateByDouble(surfaceRect.left, surfaceRect.top, 0, 1)
      ..scaleByDouble(
        size.width == 0 ? 1 : surfaceRect.width / size.width,
        size.height == 0 ? 1 : surfaceRect.height / size.height,
        1,
        1,
      );
  }

  Rect get _sourceRect =>
      (_sourceAlignment.alongSize(
            Size(
              size.width - _sourceSize.width,
              size.height - _sourceSize.height,
            ),
          ) +
          _sourceOffsetFromPanelAnchor) &
      _sourceSize;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (_animation.value < 1) return false;
    return super.hitTest(result, position: position);
  }

  @override
  Rect get paintBounds => (Offset.zero & size).expandToInclude(_sourceRect);

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child == null) return;

    final canvas = context.canvas;
    final progress = _animation.value;
    final localSurface = _surfaceRSuperellipseAt(progress);
    final surface = localSurface.shift(offset);
    _surfacePath
      ..reset()
      ..addRSuperellipse(surface);

    _surfacePaint.color = Color.lerp(
      _sourceBackgroundColor,
      _panelBackgroundColor,
      const Interval(
        0,
        0.3,
        curve: Curves.easeOutCubic,
      ).transform(progress),
    )!;
    canvas.drawPath(_surfacePath, _surfacePaint);

    final sourceBorderSide = _sourceBorderSide;
    if (sourceBorderSide != null &&
        sourceBorderSide.style != BorderStyle.none &&
        sourceBorderSide.width > 0 &&
        progress < 1 &&
        surface.width > sourceBorderSide.width &&
        surface.height > sourceBorderSide.width) {
      _borderPath
        ..reset()
        ..addRSuperellipse(surface.deflate(sourceBorderSide.width / 2));
      _borderPaint
        ..color = sourceBorderSide.color.withValues(
          alpha: sourceBorderSide.color.a * (1 - progress),
        )
        ..strokeWidth = sourceBorderSide.width;
      canvas.drawPath(_borderPath, _borderPaint);
    }

    _clipLayer.layer = context.pushClipRSuperellipse(
      needsCompositing,
      offset,
      localSurface.outerRect,
      localSurface,
      (context, offset) {
        _contentTransformLayer.layer = context.pushTransform(
          needsCompositing,
          offset,
          _updateContentTransform(localSurface.outerRect),
          (context, offset) => context.paintChild(child, offset),
          oldLayer: _contentTransformLayer.layer,
        );
      },
      clipBehavior: Clip.antiAlias,
      oldLayer: _clipLayer.layer,
    );
  }

  @override
  void dispose() {
    _clipLayer.layer = null;
    _contentTransformLayer.layer = null;
    super.dispose();
  }
}
