part of 'base_mateo_view.dart';

class _MateoViewLayoutData extends ChangeNotifier implements MateoSurfaceObstruction {
  static const double _defaultContentGap = 20;

  bool reserveHeaderSpace = true;

  EdgeInsets _obstructionInsets = EdgeInsets.zero;
  EdgeInsets _notifiedObstructionInsets = EdgeInsets.zero;
  bool _notificationScheduled = false;
  bool _disposed = false;
  double _headerSafeAreaAdjustment = 0;
  double _footerSafeAreaAdjustment = 0;
  double? _bottomSafeAreaPadding;
  double? _resolvedFooterClearance;
  bool _footerSafeAreaPending = false;

  _MateoViewHeaderLayoutData? _header;
  _MateoViewHeaderLayoutData? get header => _header;
  set header(_MateoViewHeaderLayoutData? value) {
    if (identical(value, _header)) return;
    _header?.safeAreaHandle.removeListener(resolveObstructionInsets);
    _header = value;
    _headerSafeAreaAdjustment = 0;
    _header?.safeAreaHandle.addListener(resolveObstructionInsets);
  }

  _MateoViewFooterLayoutData? _footer;
  _MateoViewFooterLayoutData? get footer => _footer;
  set footer(_MateoViewFooterLayoutData? value) {
    if (identical(value, _footer)) return;
    _footer?.safeAreaHandle.removeListener(resolveObstructionInsets);
    _footer = value;
    _footerSafeAreaAdjustment = 0;
    _resolvedFooterClearance = null;
    _footerSafeAreaPending = false;
    _footer?.safeAreaHandle.addListener(resolveObstructionInsets);
  }

  @override
  EdgeInsets get layoutInsets => _obstructionInsets;

  @override
  EdgeInsets resolvePaintInsets() {
    resolveObstructionInsets();
    return _obstructionInsets;
  }

  double get headerObstructionExtent {
    final header = this.header;
    if (header == null) return 0;
    return header.height + _headerSafeAreaAdjustment;
  }

  void updateBottomSafeAreaPadding(double padding) {
    final previous = _bottomSafeAreaPadding;
    _bottomSafeAreaPadding = padding;
    if (previous == null || previous == padding || footer == null) return;
    _footerSafeAreaPending = true;
    // The retained clearance may be unchanged; current placement still needs
    // to be resolved after layout, including when the view is offstage.
    _scheduleObstructionResolution();
  }

  void updateObstructionInsets() {
    _obstructionInsets = EdgeInsets.only(
      top: header == null || !reserveHeaderSpace ? 0 : headerObstructionExtent,
      bottom: footer == null
          ? 0
          : _footerSafeAreaPending && _resolvedFooterClearance != null
          ? _resolvedFooterClearance!
          : footer!.height + _footerSafeAreaAdjustment,
    );
    if (_obstructionInsets == _notifiedObstructionInsets) return;
    // Safe-area handles already notify after the frame. Deliver their changes
    // now so retained views repaint on the next frame, without another delay.
    if (WidgetsBinding.instance.schedulerPhase == .postFrameCallbacks) {
      _notifyObstructionInsets();
      return;
    }
    _scheduleObstructionResolution();
  }

  void _scheduleObstructionResolution() {
    if (_notificationScheduled) return;
    _notificationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationScheduled = false;
      if (_disposed) return;
      // An incoming route can be laid out offstage before its first paint.
      // Resolve placement now so snapshot capture receives safe-area clearance
      // without waiting for the live view to become visible.
      resolveObstructionInsets();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _notifyObstructionInsets() {
    if (_disposed || _obstructionInsets == _notifiedObstructionInsets) return;
    _notifiedObstructionInsets = _obstructionInsets;
    notifyListeners();
  }

  // Rendered bounds are only read after layout. Retain their adjustment when
  // slot heights change so layout does not alternate between two measurements.
  void resolveObstructionInsets() {
    _headerSafeAreaAdjustment = header == null ? 0 : header!.bottomOffset - header!.height;
    final footerBounds = footer?.safeAreaHandle.adjustedBounds;
    if (footer == null) {
      _footerSafeAreaAdjustment = 0;
      _resolvedFooterClearance = null;
      _footerSafeAreaPending = false;
    } else if (footerBounds != null) {
      _footerSafeAreaAdjustment = -footerBounds.top;
      _resolvedFooterClearance = footer!.height + _footerSafeAreaAdjustment;
      _footerSafeAreaPending = false;
    }
    updateObstructionInsets();
  }

  @override
  void dispose() {
    _disposed = true;
    _header?.safeAreaHandle.removeListener(resolveObstructionInsets);
    _footer?.safeAreaHandle.removeListener(resolveObstructionInsets);
    _header?.dispose();
    _footer?.dispose();
    super.dispose();
  }
}
