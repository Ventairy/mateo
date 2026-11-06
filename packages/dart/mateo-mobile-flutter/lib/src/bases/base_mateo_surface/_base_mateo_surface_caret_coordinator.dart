part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceCaretCoordinator extends ChangeNotifier with WidgetsBindingObserver {
  new({
    required this.viewportKey,
    required this.scrollController,
    required this.onClearanceChanged,
  }) {
    WidgetsBinding.instance.addObserver(this);
    scrollController.dimensionsChanges.addListener(_geometryChanged);
  }

  final GlobalKey viewportKey;
  final _BaseMateoSurfaceScrollController scrollController;
  final VoidCallback onClearanceChanged;

  static const _revealDuration = Duration(milliseconds: 100);
  static const Curve _revealCurve = Curves.fastOutSlowIn;

  MateoSurfaceCaretClient? _client;
  MateoSurfaceObstruction? _obstruction;
  MateoSurfaceCaretScope? _parentScope;
  ui.FlutterView? _view;
  bool _isCurrent = true;
  bool _reduceMotion = false;
  bool _scheduled = false;
  bool _geometryPending = false;
  bool _disposed = false;
  double _clearance = 0;

  double get bottomClearance => _clearance;

  void update({
    required MateoSurfaceObstruction? obstruction,
    required MateoSurfaceCaretScope? parentScope,
    required ui.FlutterView view,
    required bool isCurrent,
    required bool reduceMotion,
  }) {
    final changed =
        !identical(obstruction, _obstruction) ||
        !identical(view, _view) ||
        !identical(parentScope?.geometryChanges, _parentScope?.geometryChanges) ||
        _isCurrent != isCurrent;
    if (!identical(obstruction, _obstruction)) {
      _obstruction?.removeListener(_geometryChanged);
      _obstruction = obstruction;
      _obstruction?.addListener(_geometryChanged);
    }
    _view = view;
    if (!identical(_parentScope?.geometryChanges, parentScope?.geometryChanges)) {
      _parentScope?.geometryChanges.removeListener(_geometryChanged);
      parentScope?.geometryChanges.addListener(_geometryChanged);
    }
    _parentScope = parentScope;
    _isCurrent = isCurrent;
    _reduceMotion = reduceMotion;
    if (changed) _geometryChanged();
  }

  void caretChanged(MateoSurfaceCaretClient client) {
    if (!client.isCaretActive) {
      caretRemoved(client);
      return;
    }
    _client = client;
    _scheduleReveal();
  }

  void caretRemoved(MateoSurfaceCaretClient client) {
    if (!identical(client, _client)) return;
    _client = null;
    _geometryChanged();
  }

  bool handleReveal(RenderObject? descendant) {
    final client = _client;
    if (client == null || !identical(descendant, client.caretEditor?.renderEditable)) return false;
    // Native editor requests must use the same obstruction-aware path rather
    // than treating the full-height viewport as unobstructed.
    _scheduleReveal();
    return true;
  }

  Rect? visibleRectIn(RenderBox target) {
    final viewport = viewportKey.currentContext?.findRenderObject();
    if (viewport is! RenderBox || !viewport.attached || !viewport.hasSize || _view == null) return null;
    final visible = _visibleBounds(viewport);
    return MatrixUtils.transformRect(viewport.getTransformTo(target), visible);
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dimensionsChanges.removeListener(_geometryChanged);
    _obstruction?.removeListener(_geometryChanged);
    _parentScope?.geometryChanges.removeListener(_geometryChanged);
    _client = null;
    super.dispose();
  }

  void _geometryChanged() {
    if (_disposed) return;
    _geometryPending = true;
    _scheduleReveal();
    notifyListeners();
  }

  void _scheduleReveal() {
    if (_disposed || _scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (_disposed) return;
      final geometryChanged = _geometryPending;
      _geometryPending = false;
      _reveal(geometryChanged: geometryChanged);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _setClearance(double clearance) {
    if ((_clearance - clearance).abs() < precisionErrorTolerance) return;
    _clearance = clearance;
    onClearanceChanged();
    _geometryChanged();
  }

  Rect _visibleBounds(RenderBox viewport) {
    final view = _view!;
    final insets = _obstruction?.resolvePaintInsets() ?? EdgeInsets.zero;
    final screenBounds = Rect.fromLTWH(
      0,
      0,
      view.physicalSize.width / view.devicePixelRatio,
      (view.physicalSize.height - view.viewInsets.bottom) / view.devicePixelRatio,
    );
    final screenToViewport = Matrix4.tryInvert(viewport.getTransformTo(null));
    if (screenToViewport == null) return Rect.zero;
    final screenInViewport = MatrixUtils.transformRect(screenToViewport, screenBounds);
    final visible = insets.deflateRect(Offset.zero & viewport.size).intersect(screenInViewport);
    final parentBounds = _parentScope?.visibleRectIn(viewport);
    return parentBounds == null ? visible : visible.intersect(parentBounds);
  }

  void _reveal({required bool geometryChanged}) {
    final client = _client;
    if (!_isCurrent || client == null || !client.isCaretActive) {
      if (_isCurrent) _setClearance(0);
      return;
    }
    final editor = client.caretEditor;
    final viewport = viewportKey.currentContext?.findRenderObject();
    final view = _view;
    if (editor == null ||
        !editor.mounted ||
        viewport is! RenderBox ||
        !viewport.attached ||
        !viewport.hasSize ||
        view == null ||
        !scrollController.hasClients) {
      return;
    }
    final editable = editor.renderEditable;
    final selection = editor.widget.controller.selection;
    if (!editable.attached || !editable.hasSize || !selection.isValid) return;

    final viewportBounds = Offset.zero & viewport.size;
    final visible = _visibleBounds(viewport);
    if (visible.isEmpty || !visible.isFinite) return;

    final reservedBottom = _obstruction?.layoutInsets.bottom ?? 0;
    final clearance = math.max(0, viewportBounds.bottom - visible.bottom - reservedBottom).toDouble();
    if ((_clearance - clearance).abs() >= precisionErrorTolerance) {
      // Wait for the additional scroll extent to be laid out before scrolling.
      _setClearance(clearance);
      return;
    }
    final caret = MatrixUtils.transformRect(
      editable.getTransformTo(viewport),
      editable.getLocalRectForCaret(selection.extent),
    );
    final target = editor.widget.scrollPadding.inflateRect(caret);
    final delta = switch (target) {
      Rect(:final bottom) when bottom > visible.bottom => bottom - visible.bottom,
      Rect(:final top) when top < visible.top => top - visible.top,
      _ => 0.0,
    };
    if (delta.abs() < precisionErrorTolerance) return;
    final position = scrollController.position;
    final offset = (position.pixels + delta).clamp(position.minScrollExtent, position.maxScrollExtent);
    if ((offset - position.pixels).abs() < precisionErrorTolerance) return;
    if (geometryChanged || _reduceMotion) {
      scrollController.jumpTo(offset);
      return;
    }
    scrollController.animateTo(offset, duration: _revealDuration, curve: _revealCurve);
  }

  @override
  void didChangeMetrics() => _geometryChanged();
}
