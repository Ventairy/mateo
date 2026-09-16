part of '../mateo_surface.dart';

abstract final class _MateoSurfaceBoundaryScrollMetrics {
  static const _minimumScrollableRange = 0.5;

  static double resolve({
    required ScrollMetrics? metrics,
    required _MateoSurfaceBoundaryPosition position,
    required double maximumExtent,
    required double fallbackExtent,
  }) {
    assert(
      maximumExtent.isFinite && maximumExtent >= 0,
      'Mateo surface boundary extents must be finite and non-negative.',
    );
    if (!maximumExtent.isFinite || maximumExtent <= 0) return 0;
    if (metrics == null) {
      return fallbackExtent.clamp(0.0, maximumExtent);
    }
    if (metrics.axis != Axis.vertical) return 0;

    final scrollableRange = metrics.maxScrollExtent - metrics.minScrollExtent;
    if (scrollableRange.isNaN || scrollableRange <= _minimumScrollableRange) {
      return 0;
    }

    final reversed = axisDirectionIsReversed(metrics.axisDirection);
    final distance = switch (position) {
      _MateoSurfaceBoundaryPosition.top => reversed ? metrics.extentAfter : metrics.extentBefore,
      _MateoSurfaceBoundaryPosition.bottom => reversed ? metrics.extentBefore : metrics.extentAfter,
    };
    if (distance.isNaN || distance <= 0) return 0;
    if (distance.isInfinite) return maximumExtent;

    final progress = (distance / maximumExtent).clamp(0.0, 1.0);
    final remaining = 1 - progress;
    final remainingSquared = remaining * remaining;
    final remainingFourth = remainingSquared * remainingSquared;
    return maximumExtent * (1 - remainingFourth * remainingFourth);
  }
}
