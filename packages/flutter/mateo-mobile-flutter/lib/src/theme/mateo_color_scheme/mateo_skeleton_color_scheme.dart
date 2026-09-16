part of 'mateo_color_scheme.dart';

/// Placeholder and shimmer roles for loading skeletons.
///
/// Use this group when rendering loading placeholders that should feel tied to
/// the active theme instead of appearing as hardcoded greys. The roles separate
/// the base placeholder treatment from the glow used by animated effects.
@immutable
class MateoSkeletonColorScheme {
  /// Creates placeholder and shimmer roles for loading skeletons.
  const MateoSkeletonColorScheme({
    required this.bone,
    required this.skeletonText,
    required this.skeletonTextGlow,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoSkeletonColorScheme.lerp(
    MateoSkeletonColorScheme a,
    MateoSkeletonColorScheme b,
    double t,
  ) {
    return MateoSkeletonColorScheme(
      bone: Color.lerp(a.bone, b.bone, t)!,
      skeletonText: Color.lerp(a.skeletonText, b.skeletonText, t)!,
      skeletonTextGlow: Color.lerp(a.skeletonTextGlow, b.skeletonTextGlow, t)!,
    );
  }

  /// Base fill color for skeleton blocks and shapes.
  final Color bone;

  /// Base fill color for skeleton text placeholders.
  final Color skeletonText;

  /// Highlight glow color used by skeleton text shimmer effects.
  final Color skeletonTextGlow;

  /// {@macro mateo_color_scheme_copy_with}
  MateoSkeletonColorScheme copyWith({
    Color? bone,
    Color? skeletonText,
    Color? skeletonTextGlow,
  }) {
    return MateoSkeletonColorScheme(
      bone: bone ?? this.bone,
      skeletonText: skeletonText ?? this.skeletonText,
      skeletonTextGlow: skeletonTextGlow ?? this.skeletonTextGlow,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoSkeletonColorScheme &&
          bone == other.bone &&
          skeletonText == other.skeletonText &&
          skeletonTextGlow == other.skeletonTextGlow;

  @override
  int get hashCode => Object.hash(bone, skeletonText, skeletonTextGlow);
}
