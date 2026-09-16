part of '../../mateo_menu_button.dart';

final class _RenderMateoContextMenuRevealTransition extends RenderTransform {
  _RenderMateoContextMenuRevealTransition(this._progress, this._backgroundColor, this._contentFadeStart, this._radius)
    : super(transform: Matrix4.identity(), alignment: Alignment.center);

  Animation<double> _progress;
  Color _backgroundColor;
  double _contentFadeStart;
  final double _radius;
  double _sourceDiameter = 0;
  final LayerHandle<ClipRRectLayer> _clipLayer = LayerHandle<ClipRRectLayer>();
  final LayerHandle<OpacityLayer> _opacityLayer = LayerHandle<OpacityLayer>();

  Animation<double> get progress => _progress;
  set progress(Animation<double> value) {
    if (_progress == value) return;
    if (attached) _progress.removeListener(_update);
    _progress = value;
    if (attached) _progress.addListener(_update);
    _update();
  }

  double get contentFadeStart => _contentFadeStart;
  set contentFadeStart(double value) {
    _contentFadeStart = value;
    markNeedsPaint();
  }

  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color value) {
    _backgroundColor = value;
    markNeedsPaint();
  }

  double get sourceDiameter => _sourceDiameter;
  set sourceDiameter(double value) {
    _sourceDiameter = value;
    _update();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _progress.addListener(_update);
    _update();
  }

  @override
  void detach() {
    _progress.removeListener(_update);
    super.detach();
  }

  RRect get _shape {
    final diameter = math.min(_sourceDiameter, size.shortestSide);
    final pivot = (alignment! as Alignment).alongSize(size);
    final start = Rect.fromLTWH(
      (pivot.dx - diameter / 2).clamp(0.0, size.width - diameter),
      (pivot.dy - diameter / 2).clamp(0.0, size.height - diameter),
      diameter,
      diameter,
    );
    final rect = Rect.lerp(start, Offset.zero & size, _progress.value)!;
    return RRect.fromRectAndRadius(
      rect,
      Radius.circular(diameter / 2 + (_radius - diameter / 2) * _progress.value),
    );
  }

  @override
  Rect get paintBounds => _shape.outerRect;

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  set alignment(AlignmentGeometry? value) {
    super.alignment = value;
    _update();
  }

  @override
  void performLayout() {
    super.performLayout();
    _update();
  }

  void _update() {
    if (!hasSize || size.isEmpty) return;
    final shape = _shape.outerRect;
    final scale = math.min(shape.width / size.width, shape.height / size.height);
    final pivot = (alignment! as Alignment).alongSize(size);
    final content = (alignment! as Alignment).inscribe(size * scale, shape);
    transform = Matrix4.diagonal3Values(scale, scale, 1)
      ..setTranslationRaw(content.left - pivot.dx * (1 - scale), content.top - pivot.dy * (1 - scale), 0);
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final shape = _shape;
    context.canvas.drawRRect(shape.shift(offset), Paint()..color = _backgroundColor);
    final opacity = ((_progress.value - _contentFadeStart) / (1 - _contentFadeStart)).clamp(0.0, 1.0);
    if (opacity == 0 || child == null) return;
    _clipLayer.layer = context.pushClipRRect(
      needsCompositing,
      offset,
      shape.outerRect,
      shape,
      (context, offset) {
        _opacityLayer.layer = context.pushOpacity(
          offset,
          (opacity * 255).round(),
          super.paint,
          oldLayer: _opacityLayer.layer,
        );
      },
      clipBehavior: Clip.antiAlias,
      oldLayer: _clipLayer.layer,
    );
  }

  @override
  void dispose() {
    _clipLayer.layer = null;
    _opacityLayer.layer = null;
    super.dispose();
  }
}
