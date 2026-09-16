part of 'mateo_header.dart';

/// The package-internal link between a header and its view-owned top fade.
///
/// Listeners are notified when header presence changes and layout must update.
/// Scroll changes call [onFadeChanged] without requesting layout.
@internal
final class MateoHeaderConnection extends ChangeNotifier {
  /// Creates a connection that calls [onFadeChanged] when the fade needs updating.
  MateoHeaderConnection({required this.onFadeChanged});

  /// The callback that updates the view's fade without rebuilding its content.
  final VoidCallback onFadeChanged;
  _MateoHeaderScrollObserver? _scroll;

  /// Whether a coordinated header is currently attached.
  bool get hasHeader => _scroll != null;

  /// The top fade's current depth, or null when no header is connected.
  ///
  /// [maximumExtent] is the full fade depth measured by the containing view.
  double? resolveFadeExtent(double maximumExtent) => _scroll?.resolveFadeExtent(maximumExtent);

  void _connect(_MateoHeaderScrollObserver scroll) {
    if (identical(_scroll, scroll)) return;
    _scroll?.removeListener(onFadeChanged);
    _scroll = scroll;
    scroll.addListener(onFadeChanged);
    notifyListeners();
    onFadeChanged();
  }

  void _disconnect(_MateoHeaderScrollObserver scroll) {
    if (!identical(_scroll, scroll)) return;
    scroll.removeListener(onFadeChanged);
    _scroll = null;
    notifyListeners();
    onFadeChanged();
  }

  /// Releases the connection's listener without disposing the header's controller.
  @override
  void dispose() {
    _scroll?.removeListener(onFadeChanged);
    super.dispose();
  }
}
