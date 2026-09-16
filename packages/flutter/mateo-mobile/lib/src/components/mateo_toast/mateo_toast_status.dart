import 'package:flutter/foundation.dart';

import '../../theme/color_scheme/mateo_color_scheme.dart';
import '../mateo_icon/mateo_icon.dart';

/// The meaning communicated by a toast.
enum MateoToastStatus {
  /// An operation failed or could not be completed.
  error(defaultIcon: .exclamationCircle),

  /// A condition needs attention.
  warning(defaultIcon: .exclamationTriangle),

  /// Useful information about the current situation.
  info(defaultIcon: .circleInfo),

  /// An operation completed successfully.
  success(defaultIcon: .circleCheck);

  const MateoToastStatus({required this.defaultIcon});

  /// The authored icon for this status.
  @internal
  final MateoIconData defaultIcon;

  /// The toast color roles associated with this status.
  @internal
  MateoToastStatusColorScheme colors(MateoToastColorScheme scheme) => switch (this) {
    error => scheme.error,
    warning => scheme.warning,
    info => scheme.info,
    success => scheme.success,
  };
}
