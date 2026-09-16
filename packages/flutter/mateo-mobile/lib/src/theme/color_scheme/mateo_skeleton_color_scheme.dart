part of 'mateo_color_scheme.dart';

/// The semantic colors for skeleton loading placeholders.
@immutable
final class MateoSkeletonColorScheme {
  /// Creates the color roles of a skeleton.
  const MateoSkeletonColorScheme({required this.bone});

  /// The fill color for skeleton bones.
  final Color bone;

  /// Whether every color role equals the other scheme.
  @override
  bool operator ==(Object other) => identical(this, other) || other is MateoSkeletonColorScheme && bone == other.bone;

  /// The hash of this scheme's color roles.
  @override
  int get hashCode => bone.hashCode;
}
