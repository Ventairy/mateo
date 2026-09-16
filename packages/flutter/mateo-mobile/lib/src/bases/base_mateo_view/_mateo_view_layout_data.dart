part of 'base_mateo_view.dart';

class _MateoViewLayoutData extends ChangeNotifier {
  static const double _defaultContentGap = 20;

  bool reserveHeaderSpace = true;

  EdgeInsets _obstructionInsets = EdgeInsets.zero;
  EdgeInsets _notifiedObstructionInsets = EdgeInsets.zero;
  bool _notificationScheduled = false;
  bool _disposed = false;
  double _headerSafeAreaAdjustment = 0;
  double _footerSafeAreaAdjustment = 0;

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
    _footer?.safeAreaHandle.addListener(resolveObstructionInsets);
  }

  EdgeInsets get obstructionInsets => _obstructionInsets;
  Listenable get obstructionInsetsChanges => this;

  double get headerObstructionExtent {
    final header = this.header;
    if (header == null) return 0;
    return header.height + _headerSafeAreaAdjustment;
  }

  void updateObstructionInsets() {
    _obstructionInsets = EdgeInsets.only(
      top: header == null || !reserveHeaderSpace ? 0 : headerObstructionExtent,
      bottom: footer == null ? 0 : footer!.height + _footerSafeAreaAdjustment,
    );
    if (_obstructionInsets == _notifiedObstructionInsets) return;
    // Safe-area handles already notify after the frame. Deliver their changes
    // now so retained views repaint on the next frame, without another delay.
    if (WidgetsBinding.instance.schedulerPhase == .postFrameCallbacks) {
      _notifyObstructionInsets();
      return;
    }
    if (_notificationScheduled) return;
    _notificationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationScheduled = false;
      _notifyObstructionInsets();
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
    _footerSafeAreaAdjustment = footer == null ? 0 : -footer!.topOffset;
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
