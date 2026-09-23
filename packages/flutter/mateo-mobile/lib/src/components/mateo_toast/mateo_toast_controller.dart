part of 'mateo_toast.dart';

/// A handle for dismissing one toast shown by [showMateoToast].
///
/// Keep the returned controller when a toast may need to be cancelled before
/// its delay ends or dismissed after it appears.
final class MateoToastController {
  MateoToastController._(this._host);

  _MateoToastHostState? _host;

  /// Dismisses this toast or cancels it before it appears.
  ///
  /// Repeated calls and calls after the toast has ended do nothing. A later
  /// toast is never affected.
  void dismiss() => _host?._dismissRequest(this);

  void _finish() => _host = null;
}
