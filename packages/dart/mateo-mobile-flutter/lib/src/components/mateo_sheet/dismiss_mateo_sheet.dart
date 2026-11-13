part of 'show_mateo_sheet.dart';

/// Dismisses the current Mateo sheet on the nearest navigator.
///
/// [context] may belong to the launching page or sheet content. [result] is
/// returned to the sheet's [showMateoSheet] future. This explicit command
/// bypasses [MateoSheetShouldDismiss]. Completes after the sheet exits, or
/// immediately when a page or dialog is current instead of a Mateo sheet.
Future<void> dismissMateoSheet<T>(BuildContext context, {T? result}) {
  final navigator = Navigator.of(context);
  final pending = MateoSheetRoute._pendingDismissals[navigator];
  if (pending != null) return pending;
  final route = MateoSheetRoute._currentSheet(navigator);
  if (route == null) return Future<void>.value();
  final stackDismissal = route._stackDismissal;
  if (stackDismissal != null) return stackDismissal.completed;
  final completed = route.completed.then<void>((_) {});
  MateoSheetRoute._pendingDismissals[navigator] = completed;
  unawaited(completed.whenComplete(() => MateoSheetRoute._pendingDismissals[navigator] = null));
  navigator.pop<T>(result);
  return completed;
}
