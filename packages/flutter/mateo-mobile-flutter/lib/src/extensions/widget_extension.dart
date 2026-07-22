import 'package:flutter/material.dart';
import 'package:mateo_mobile/src/widgets/mateo_skeleton/mateo_skeleton.dart';

extension WidgetExtension on Widget {
  /// Wraps this widget with [MateoSkeleton] for loading-placeholder display.
  ///
  /// [enabled] controls whether the skeleton effect is active (default
  /// `true`). Pass a [MateoSkeletonStyle] to customize any subset; `null` uses theme
  /// defaults
  ///
  /// ```dart
  /// Text('Hello').skeleton();
  /// Text('Hello').skeleton(style: MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect()));
  /// CircularProgressIndicator().skeleton(enabled: isLoading);
  /// ```
  Widget skeleton({bool enabled = true, MateoSkeletonStyle? style}) {
    return MateoSkeleton(enabled: enabled, style: style, child: this);
  }
}
