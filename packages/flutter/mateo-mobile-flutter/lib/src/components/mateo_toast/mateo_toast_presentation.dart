part of 'mateo_toast.dart';

/// The mounted semantic presentation of a [MateoToast].
///
/// Each presentation owns the toast surface, semantic color roles, icon,
/// typography, layout, elevation, and accessibility behavior. Supply it to
/// [MateoToast.new] for direct rendering or [MateoToast.show] for overlay
/// feedback.
@immutable
sealed class MateoToastPresentation extends StatelessWidget {
  const MateoToastPresentation._();

  /// Creates an error presentation for failed actions or invalid states.
  ///
  /// The optional [iconBuilder] replaces the presentation's default error
  /// icon while retaining its recommended size and semantic icon color.
  const factory MateoToastPresentation.error({
    MateoToastIconBuilder? iconBuilder,
  }) = _MateoErrorToastPresentation;

  /// Creates a warning presentation for risks or degraded conditions.
  ///
  /// The optional [iconBuilder] replaces the presentation's default warning
  /// icon while retaining its recommended size and semantic icon color.
  const factory MateoToastPresentation.warning({
    MateoToastIconBuilder? iconBuilder,
  }) = _MateoWarningToastPresentation;

  /// Creates an informational presentation for timely task-relevant facts.
  ///
  /// The optional [iconBuilder] replaces the presentation's default
  /// information icon while retaining its recommended size and semantic icon
  /// color.
  const factory MateoToastPresentation.info({
    MateoToastIconBuilder? iconBuilder,
  }) = _MateoInfoToastPresentation;

  /// Creates a success presentation for meaningful completed actions.
  ///
  /// The optional [iconBuilder] replaces the presentation's default success
  /// icon while retaining its recommended size and semantic icon color.
  const factory MateoToastPresentation.success({
    MateoToastIconBuilder? iconBuilder,
  }) = _MateoSuccessToastPresentation;

  /// Creates a neutral presentation for status without severity.
  ///
  /// The required [iconBuilder] identifies the status while receiving the
  /// presentation's recommended size and semantic icon color.
  const factory MateoToastPresentation.neutral({
    required MateoToastIconBuilder iconBuilder,
  }) = _MateoNeutralToastPresentation;
}
