import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// A shared connection between Mateo elements that transform into one another.
///
/// Create once in an owner shared by both elements and pass the same instance
/// to their transform animations. Separate instances do not match.
@immutable
final class MateoTransformTarget {
  /// Creates a connection with shared timing in both directions.
  MateoTransformTarget({
    this.duration = defaultDuration,
    this.curve = Curves.easeOutCubic,
  }) : assert(
         duration == null || !duration.isNegative,
         'duration must not be negative.',
       );

  // Shared with routes that need a fallback for route-driven transforms.
  @internal
  // Internal configuration is intentionally excluded from consumer Dartdoc.
  // ignore: public_member_api_docs
  static const defaultDuration = Duration(milliseconds: 230);

  /// The duration used by transforms through this connection.
  ///
  /// Pass null to follow route timing during navigation. Local transitions
  /// then use the underlying motion system's default timing.
  final Duration? duration;

  /// The easing used by transforms through this connection.
  final Curve curve;
}
