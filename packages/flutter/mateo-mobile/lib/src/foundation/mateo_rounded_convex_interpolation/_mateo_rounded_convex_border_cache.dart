part of 'mateo_rounded_convex_interpolation.dart';

// Bounded memoization does not change a returned border's geometry.
final class _MateoRoundedConvexBorderCache {
  Float64List? points;
  Float64List Function()? capture;
  Path Function(Rect)? transform;
  ({Size size, MateoRoundedConvexDescription description})? prepared;
  ({Rect bounds, Path path})? transformed;
}
