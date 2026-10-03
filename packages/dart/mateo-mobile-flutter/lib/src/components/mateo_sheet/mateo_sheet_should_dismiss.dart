part of 'show_mateo_sheet.dart';

/// A synchronous decision allowing a sheet to dismiss.
///
/// Return `true` to allow the dismissal requested by [source], or `false` to
/// keep the sheet open. Only the current sheet is asked.
///
/// Keep this check quick and free of side effects. [MateoSheetDismissSource.drag]
/// is checked at pointer down, including touches that never become drags, and
/// again before a drag dismisses the sheet. Return `false` at pointer down to
/// prevent dragging and resistance. If permission changes during a drag, a
/// denied dismissal returns the sheet to its resting position.
///
///
/// Explicit [Navigator.pop] calls bypass this callback.
typedef MateoSheetShouldDismiss = bool Function(MateoSheetDismissSource source);
