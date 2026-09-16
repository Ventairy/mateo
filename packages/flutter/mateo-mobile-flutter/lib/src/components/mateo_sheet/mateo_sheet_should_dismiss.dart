import 'dart:async';

import 'package:mateo_mobile_old/src/components/mateo_sheet/mateo_sheet_dismiss_source.dart';

/// A synchronous or asynchronous decision about a requested sheet dismissal.
///
/// The [source] identifies the user interaction that requested dismissal.
/// Returning `true` allows the sheet to close. Returning `false` keeps it open.
///
/// When a scrim tap or downward drag dismisses a stack of sheets, each sheet
/// receives the original [source], starting with the visible sheet. The first
/// refusal stops dismissal and returns to that sheet, preserving those below it.
typedef MateoSheetShouldDismiss = FutureOr<bool> Function(MateoSheetDismissSource source);
