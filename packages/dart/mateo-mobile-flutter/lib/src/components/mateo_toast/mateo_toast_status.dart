import 'package:flutter/foundation.dart';

import '../../theme/color_scheme/mateo_color_scheme.dart';

/// The meaning communicated by a toast.
enum MateoToastStatus {
  /// Brief feedback without a success, warning, error, or loading meaning.
  neutral,

  /// An operation failed or could not be completed.
  error,

  /// A condition needs attention.
  warning,

  /// Useful information about the current situation.
  info,

  /// An operation is still in progress.
  loading,

  /// An operation completed successfully.
  success;

  /// The toast color roles associated with this status.
  @internal
  MateoToastStatusColorScheme colors(MateoToastColorScheme scheme) => switch (this) {
    neutral => scheme.neutral,
    error => scheme.error,
    warning => scheme.warning,
    info => scheme.info,
    loading => scheme.loading,
    success => scheme.success,
  };
}
