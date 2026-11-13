part of 'show_mateo_sheet.dart';

/// Dismisses the current Mateo sheet and its stack together.
///
/// [context] may belong to the launching page or sheet content. The nearest
/// navigator's contiguous sheet stack exits as one object. Every dismissed
/// sheet's [showMateoSheet] future completes with null, bypassing
/// [MateoSheetShouldDismiss]. Completes after the stack exits and is removed.
/// Does nothing when a page or dialog is current instead of a Mateo sheet.
Future<void> dismissMateoSheetStack(BuildContext context) {
  final navigator = Navigator.of(context);
  final pending = MateoSheetRoute._pendingDismissals[navigator];
  if (pending != null) return pending;
  final route = MateoSheetRoute._currentSheet(navigator);
  if (route == null) return Future<void>.value();
  final stackDismissal = route._stackDismissal;
  if (stackDismissal != null) return stackDismissal.completed;
  final routes = <MateoSheetRoute<dynamic>>[];
  MateoSheetRoute<dynamic>? sheet = route;
  while (sheet != null && sheet.isActive) {
    routes.add(sheet);
    sheet = sheet._previousSheet;
  }
  return _MateoSheetStackDismissal(navigator: navigator, routes: routes).start();
}
