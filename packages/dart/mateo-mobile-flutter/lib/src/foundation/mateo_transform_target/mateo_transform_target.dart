import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import '../mateo_transform_duration/mateo_transform_duration.dart';

/// A shared connection between Mateo elements that transform into one another.
///
/// Create once in an owner shared by both elements and pass the same instance
/// to their transform animations. Separate instances do not match.
@immutable
final class MateoTransformTarget {
  /// Creates a connection with directional timing.
  // Targets match by identity, so const canonicalization would connect
  // separately constructed targets.
  // ignore: prefer_const_constructors_in_immutables
  MateoTransformTarget({
    this.duration = const .auto(),
    MateoTransformDuration? reverseDuration,
    this.curve = Curves.easeOutCubic,
    Curve? reverseCurve,
  }) : reverseDuration = reverseDuration ?? duration,
       reverseCurve = reverseCurve ?? curve;

  // Shared with routes that need a fallback for route-driven transforms.
  @internal
  // Internal configuration is intentionally excluded from consumer Dartdoc.
  // ignore: public_member_api_docs
  static const defaultDuration = Duration(milliseconds: 230);

  /// The timing used when moving to a newer appearance.
  final MateoTransformDuration duration;

  /// The timing used when returning to an earlier appearance.
  ///
  /// When omitted from the constructor, uses [duration].
  final MateoTransformDuration reverseDuration;

  /// The easing used when moving to a newer appearance.
  final Curve curve;

  /// The easing used when returning to an earlier appearance.
  ///
  /// When omitted from the constructor, uses [curve].
  final Curve reverseCurve;
}
