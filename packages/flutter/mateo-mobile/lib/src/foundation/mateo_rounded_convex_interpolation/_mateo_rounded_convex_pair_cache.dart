part of 'mateo_rounded_convex_evaluator.dart';

// Bounded reuse. Entries retain native kernels and copied numeric
// pair data, with weak source keys. Identity hits precede exact numeric hits.
// Application objects and endpoint arrays
// are never cache roots. The byte limit covers native kernels; Dart pair/entry
// overhead is additional and bounded by the number of retained entries.
final _preparedPairs = _MateoRoundedConvexPairCache();

final class _MateoRoundedConvexPairCache {
  static const int byteBudget = 2 * 1024 * 1024;
  final entries = <_MateoRoundedConvexPairCacheEntry>[];
  int retainedBytes = 0;

  void trim() {
    entries.removeWhere((entry) => !entry.alive);
    retainedBytes = entries.fold(
      0,
      (sum, entry) => sum + entry.kernel.retainedBytes,
    );
    while (retainedBytes > byteBudget && entries.isNotEmpty) {
      retainedBytes -= entries.removeAt(0).kernel.retainedBytes;
    }
  }

  _MateoRoundedConvexPairCacheEntry? find(
    MateoRoundedConvexDescription a,
    MateoRoundedConvexDescription b,
  ) {
    trim();
    for (var i = entries.length - 1; i >= 0; i--) {
      final entry = entries[i];
      if (entry.matches(a, b)) {
        entries
          ..removeAt(i)
          ..add(entry);
        return entry;
      }
    }
    for (var i = entries.length - 1; i >= 0; i--) {
      final entry = entries[i];
      if (entry.matchesContent(a, b)) {
        entries
          ..removeAt(i)
          ..add(entry);
        return entry;
      }
    }
    return null;
  }

  void add(
    MateoRoundedConvexDescription a,
    MateoRoundedConvexDescription b,
    MateoRoundedConvexPair pair,
    _MateoNativeKernel kernel,
  ) {
    if (kernel.retainedBytes > byteBudget) return;
    entries.add(_MateoRoundedConvexPairCacheEntry(a, b, pair, kernel));
    trim();
  }

  void clear() {
    entries.clear();
    retainedBytes = 0;
  }
}

final class _MateoRoundedConvexPairCacheEntry {
  _MateoRoundedConvexPairCacheEntry(
    MateoRoundedConvexDescription a,
    MateoRoundedConvexDescription b,
    this.pair,
    this.kernel,
  ) : aKey = WeakReference(a.outline ?? a.turns),
      bKey = WeakReference(b.outline ?? b.turns),
      aTurns = WeakReference(a.turns),
      bTurns = WeakReference(b.turns),
      aHasOutline = a.outline != null,
      bHasOutline = b.outline != null,
      aSpeeds = WeakReference(a.speeds),
      bSpeeds = WeakReference(b.speeds),
      aSpacings = WeakReference(a.spacings),
      bSpacings = WeakReference(b.spacings),
      dimensions = (a.width, a.height, a.angle, b.width, b.height, b.angle);

  final WeakReference<Object> aKey;
  final WeakReference<Object> bKey;
  final WeakReference<Float64List> aTurns;
  final WeakReference<Float64List> bTurns;
  final bool aHasOutline;
  final bool bHasOutline;
  final WeakReference<Float64List> aSpeeds;
  final WeakReference<Float64List> bSpeeds;
  final WeakReference<Float64List> aSpacings;
  final WeakReference<Float64List> bSpacings;
  final (double, double, double, double, double, double) dimensions;
  final MateoRoundedConvexPair pair;
  final _MateoNativeKernel kernel;

  bool get alive =>
      aKey.target != null &&
      bKey.target != null &&
      aTurns.target != null &&
      bTurns.target != null &&
      aSpeeds.target != null &&
      bSpeeds.target != null &&
      aSpacings.target != null &&
      bSpacings.target != null;

  bool matches(
    MateoRoundedConvexDescription a,
    MateoRoundedConvexDescription b,
  ) =>
      identical(aKey.target, a.outline ?? a.turns) &&
      identical(bKey.target, b.outline ?? b.turns) &&
      identical(aTurns.target, a.turns) &&
      identical(bTurns.target, b.turns) &&
      identical(aSpeeds.target, a.speeds) &&
      identical(bSpeeds.target, b.speeds) &&
      identical(aSpacings.target, a.spacings) &&
      identical(bSpacings.target, b.spacings) &&
      _dimensionsMatch(a, b);

  bool _dimensionsMatch(
    MateoRoundedConvexDescription a,
    MateoRoundedConvexDescription b,
  ) =>
      _sameDouble(dimensions.$1, a.width) &&
      _sameDouble(dimensions.$2, a.height) &&
      _sameDouble(dimensions.$3, a.angle) &&
      _sameDouble(dimensions.$4, b.width) &&
      _sameDouble(dimensions.$5, b.height) &&
      _sameDouble(dimensions.$6, b.angle);

  bool matchesContent(
    MateoRoundedConvexDescription a,
    MateoRoundedConvexDescription b,
  ) =>
      _dimensionsMatch(a, b) &&
      aHasOutline == (a.outline != null) &&
      bHasOutline == (b.outline != null) &&
      _sameValues(aTurns.target, a.turns) &&
      _sameValues(bTurns.target, b.turns) &&
      _sameValues(aSpeeds.target, a.speeds) &&
      _sameValues(bSpeeds.target, b.speeds) &&
      _sameValues(aSpacings.target, a.spacings) &&
      _sameValues(bSpacings.target, b.spacings) &&
      (!aHasOutline || _sameOutline(aKey.target, a.outline!)) &&
      (!bHasOutline || _sameOutline(bKey.target, b.outline!));

  static bool _sameDouble(double a, double b) => a == b && (a != 0 || a.isNegative == b.isNegative);

  static bool _sameValues(Float64List? a, Float64List b) {
    if (a == null || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!_sameDouble(a[i], b[i])) return false;
    }
    return true;
  }

  static bool _sameOutline(Object? a, MateoRoundedConvexEndpoint b) {
    if (a is! MateoRoundedConvexEndpoint || a.points.length != b.points.length) {
      return false;
    }
    for (var i = 0; i < a.points.length; i++) {
      if (!_sameDouble(a.points[i].dx, b.points[i].dx) || !_sameDouble(a.points[i].dy, b.points[i].dy)) {
        return false;
      }
    }
    return true;
  }
}
