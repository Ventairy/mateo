part of 'base_mateo_surface.dart';

class _RenderBaseMateoSurfaceRepaintBoundary extends RenderRepaintBoundary {
  _RenderBaseMateoSurfaceRepaintBoundary(this._controller);

  final _originalCacheHints = <PictureLayer, bool>{};
  _BaseMateoSurfaceScrollController _controller;
  _BaseMateoSurfaceScrollController get controller => _controller;

  set controller(_BaseMateoSurfaceScrollController value) {
    if (identical(value, _controller)) return;
    if (attached) _removeViewportListeners();
    _controller = value;
    if (attached) _addViewportListeners();
    markNeedsCompositedLayerUpdate();
  }

  void _addViewportListeners() {
    _controller.addListener(markNeedsCompositedLayerUpdate);
    _controller.dimensionsChanges.addListener(markNeedsCompositedLayerUpdate);
  }

  void _removeViewportListeners() {
    _controller.removeListener(markNeedsCompositedLayerUpdate);
    _controller.dimensionsChanges.removeListener(markNeedsCompositedLayerUpdate);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _addViewportListeners();
  }

  @override
  void detach() {
    _removeViewportListeners();
    super.detach();
  }

  @override
  void dispose() {
    _originalCacheHints.clear();
    super.dispose();
  }

  bool get _nearViewport {
    final viewport = RenderAbstractViewport.maybeOf(this);
    if (viewport == null || !hasSize) return true;
    final viewportBounds = viewport.paintBounds;
    final bounds = MatrixUtils.transformRect(getTransformTo(viewport), paintBounds);
    if (!viewportBounds.isFinite || !bounds.isFinite) return true;
    // Keep one screen before and after the viewport available for caching.
    // This affects bitmap retention only; drawing and hit testing never cull.
    return bounds.overlaps(viewportBounds.inflate(viewportBounds.height));
  }

  void _updateCacheHints() {
    final avoidBitmap = !_nearViewport;
    for (final entry in _originalCacheHints.entries) {
      entry.key.willChangeHint = entry.value || avoidBitmap;
    }
  }

  @override
  OffsetLayer updateCompositedLayer({required OffsetLayer? oldLayer}) {
    final result = super.updateCompositedLayer(oldLayer: oldLayer);
    // A repaint removes the old recordings before this callback. They may
    // already be disposed; paint will collect the replacement recordings.
    if (result.hasChildren) {
      _updateCacheHints();
    } else {
      _originalCacheHints.clear();
    }
    return result;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    _originalCacheHints.clear();
    final independentLayers = <ContainerLayer>{};
    void findIndependentLayers(RenderObject descendant) {
      if (descendant.isRepaintBoundary) {
        if (descendant.layer case final layer?) independentLayers.add(layer);
        return;
      }
      descendant.visitChildren(findIndependentLayers);
    }

    visitChildren(findIndependentLayers);
    void collectCacheHints(ContainerLayer container) {
      var childLayer = container.firstChild;
      while (childLayer != null) {
        if (childLayer is PictureLayer) {
          // Preserve each drawing's own policy while allowing distant eager
          // cards to release bitmaps. Explicit child boundaries stay untouched.
          _originalCacheHints[childLayer] = childLayer.willChangeHint;
        } else if (childLayer is ContainerLayer && !independentLayers.contains(childLayer)) {
          collectCacheHints(childLayer);
        }
        childLayer = childLayer.nextSibling;
      }
    }

    collectCacheHints(layer!);
    _updateCacheHints();
  }
}
