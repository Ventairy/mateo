part of 'show_mateo_sheet.dart';

/// A synchronous or asynchronous decision allowing a sheet to dismiss.
///
/// Return `true` to allow the dismissal requested by [source], or `false` to
/// keep the sheet open. A denied drag returns to its resting position.
/// Further requests are ignored while the decision is pending. Only the
/// current sheet is asked; sheets below it remain open.
///
/// Explicit [Navigator.pop] calls bypass this callback.
typedef MateoSheetShouldDismiss = FutureOr<bool> Function(MateoSheetDismissSource source);
