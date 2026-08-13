import 'dart:async';

import 'package:mateo_mobile/src/widgets/mateo_bottom_sheet/mateo_bottom_sheet_dismiss_source.dart';

/// A synchronous or asynchronous decision about a requested sheet dismissal.
///
/// The [source] identifies the user interaction that requested dismissal.
/// Returning `true` allows the sheet to close. Returning `false` keeps it open.
typedef MateoBottomSheetShouldDismiss =
    FutureOr<bool> Function(MateoBottomSheetDismissSource source);
