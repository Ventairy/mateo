part of '../mateo_text.dart';

const _textMotionDuration = Duration(milliseconds: 400);
const _textMotionCurve = Cubic(0.19, 1, 0.22, 1);
const double _minVisibleTextOpacity = 0.5 / 255;

typedef _TextMotionPose = ({Offset offset, double scale, double opacity, double roll});

class _TextMotionSprite {
  const new(this.layout, this.glyph, this.pose, {this.current = true, this.remainingExitFade});

  final _TextMotionLayout layout;
  final _TextMotionGlyph glyph;
  final _TextMotionPose pose;
  final bool current;
  final double? remainingExitFade;

  bool get isVisible => !(pose.opacity < _minVisibleTextOpacity);

  void paint(Canvas canvas, Rect clip, _TextMotionPose pose) {
    final bounds = glyph.bounds;
    final origin = pose.offset;
    final rolling = glyph.kind != .text && pose.roll != 0;
    canvas.save();
    final rollBounds = glyph.rollBounds.shift(origin - bounds.topLeft);
    if (rolling) {
      canvas
        ..clipRect(rollBounds)
        ..saveLayer(rollBounds, Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: pose.opacity))
        ..save();
    }
    canvas
      ..translate(origin.dx, origin.dy + pose.roll)
      ..scale(pose.scale)
      ..translate(-bounds.left, -bounds.top)
      ..clipRect(clip);
    if (!rolling && pose.opacity < 1) {
      canvas.saveLayer(clip, Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: pose.opacity));
    }
    canvas.drawPicture(layout.picture);
    if (rolling) {
      canvas.restore();
      final fade = (layout.numberFade / rollBounds.height).clamp(0.0, 0.5);
      canvas
        ..drawRect(
          rollBounds,
          Paint()
            ..blendMode = BlendMode.dstIn
            ..shader = ui.Gradient.linear(
              rollBounds.topLeft,
              rollBounds.bottomLeft,
              const [Color(0x00000000), Color(0xFF000000), Color(0xFF000000), Color(0x00000000)],
              [0, fade, 1 - fade, 1],
            ),
        )
        ..restore();
    } else if (pose.opacity < 1) {
      canvas.restore();
    }
    canvas.restore();
  }
}

class _TextMotionFrame {
  new(this.layout, this.size, this.sprites) : isAtRest = false;

  new atRest(this.layout)
    : isAtRest = true,
      size = layout.size,
      sprites = [
        for (final glyph in layout.glyphs)
          _TextMotionSprite(layout, glyph, (offset: glyph.bounds.topLeft, scale: 1, opacity: 1, roll: 0)),
      ];

  final _TextMotionLayout layout;
  final Size size;
  final List<_TextMotionSprite> sprites;
  final bool isAtRest;

  // Share transitions sampled from this frame without retaining its sprites.
  late final Object identity = Object();
}

class _TextMotionTrack extends _TextMotionSprite {
  const new(
    super.layout,
    super.glyph,
    super.pose,
    this.destination, {
    super.current,
    required this.fadeDuration,
    this.fadeDelay = 0,
  });

  final _TextMotionPose destination;
  final double fadeDuration;
  final double fadeDelay;

  _TextMotionPose? visiblePoseAt(double time, double travel) => _poseAt(time, travel, retainHidden: false);

  _TextMotionPose? _poseAt(double time, double travel, {required bool retainHidden}) {
    final from = pose;
    // Most tracks hold their opacity. Only entering or exiting glyphs fade.
    final opacity = from.opacity == destination.opacity
        ? from.opacity
        : ui.lerpDouble(from.opacity, destination.opacity, ((time - fadeDelay) / fadeDuration).clamp(0.0, 1.0))!;
    if (!retainHidden && opacity < _minVisibleTextOpacity) return null;
    return (
      offset: Offset.lerp(from.offset, destination.offset, travel)!,
      scale: ui.lerpDouble(from.scale, destination.scale, travel)!,
      opacity: opacity,
      roll: ui.lerpDouble(from.roll, destination.roll, travel)!,
    );
  }

  _TextMotionSprite? at(double time, double travel) {
    // Current glyphs may be waiting for their entrance fade. Keep them as
    // match candidates so the next update can resume from their zero opacity.
    final pose = _poseAt(time, travel, retainHidden: current);
    if (pose == null) return null;
    return _TextMotionSprite(
      layout,
      glyph,
      pose,
      current: current,
      remainingExitFade: current ? null : fadeDelay + fadeDuration - time,
    );
  }
}

class _TextMotionTransition {
  new(_TextMotionFrame before, this.layout, String decimalSeparator)
    : initialSize = before.size,
      _departingLayout = before.isAtRest ? before.layout : null {
    final matching = _TextMotionMatching(
      before.layout.words,
      layout.words,
      decimalSeparator,
    );
    final sourceSprites = before.sprites;
    final targetGlyphs = layout.glyphs;
    final span = before.layout._key.text;
    final sourceLength = span is TextSpan ? span.text?.length : null;
    final denseIndices = sourceLength != null && sourceLength <= _sourceIndices.length
        ? (_sourceIndices..fillRange(0, sourceLength, 0))
        : null;
    final sparseIndices = denseIndices == null ? <int, int>{} : null;

    int? indexAt(int? start) {
      if (denseIndices == null) return sparseIndices![start];
      if (start == null || start < 0 || start >= sourceLength!) return null;
      final stored = denseIndices[start];
      return stored == 0 ? null : stored - 1;
    }

    for (var index = 0; index < sourceSprites.length; index++) {
      final sprite = sourceSprites[index];
      if (!sprite.current) continue;
      final start = sprite.glyph.unit.start;
      if (!sprite.isVisible) {
        final previous = indexAt(start);
        if (previous != null && sourceSprites[previous].isVisible) continue;
      }
      if (denseIndices != null) {
        denseIndices[start] = index + 1;
      } else {
        sparseIndices![start] = index;
      }
    }
    // Zero marks an unmatched glyph. Other entries store the opposite index plus one.
    final sourceByTarget = Uint32List(targetGlyphs.length);
    final targetBySource = Uint32List(sourceSprites.length);
    for (var targetIndex = 0; targetIndex < targetGlyphs.length; targetIndex++) {
      final glyph = targetGlyphs[targetIndex];
      final sourceIndex = indexAt(matching.sourceStartFor(glyph.wordIndex, glyph.unit.start));
      if (sourceIndex != null &&
          targetBySource[sourceIndex] == 0 &&
          sourceSprites[sourceIndex].glyph.unit.text == glyph.unit.text) {
        sourceByTarget[targetIndex] = sourceIndex + 1;
        targetBySource[sourceIndex] = targetIndex + 1;
      }
    }

    late final departedNeighbors = _directionalMatches(
      targetBySource,
      (index) => sourceSprites[index].glyph.unit.start,
    );
    late final arrivingNeighbors = _directionalMatches(
      sourceByTarget,
      (index) => targetGlyphs[index].unit.start,
    );
    late final enteringGroups = _groupCenters(
      targetGlyphs,
      {
        for (var index = 0; index < targetGlyphs.length; index++)
          if (sourceByTarget[index] != 0) targetGlyphs[index],
      },
      layout.byWord,
      matching.splitTargets,
    );
    late final outgoingGlyphs = [
      for (final source in sourceSprites)
        if (source.current && source.isVisible) source.glyph,
    ];
    late final leavingGroups = _groupCenters(
      outgoingGlyphs,
      {
        for (var index = 0; index < sourceSprites.length; index++)
          if (targetBySource[index] != 0) sourceSprites[index].glyph,
      },
      before.layout.byWord,
      matching.splitSources,
    );
    late final enteringWordCenters = _wordCenters(
      targetGlyphs,
      layout.byWord,
      matching.splitTargets,
    );
    late final leavingWordCenters = _wordCenters(
      outgoingGlyphs,
      before.layout.byWord,
      matching.splitSources,
    );

    for (var sourceIndex = 0; sourceIndex < sourceSprites.length; sourceIndex++) {
      if (targetBySource[sourceIndex] != 0) continue;
      final source = sourceSprites[sourceIndex];
      // An entrance that never became visible has nothing to fade out.
      if (!source.isVisible) continue;
      final glyph = source.glyph;
      final kind = glyph.kind;
      final group = kind == .text ? leavingGroups[glyph] : null;
      var anchor = Offset.zero;
      if (source.current && group == null) {
        final neighbor = sourceSprites.length > _directNeighborSearchLimit
            ? _preferredNeighbor(
                departedNeighbors,
                sourceIndex,
                forwardFirst: true,
              )
            : _adjacentMatch(
                sourceIndex,
                targetBySource,
                (index) => sourceSprites[index].glyph.unit.start,
                forwardFirst: true,
              );
        if (neighbor >= 0) {
          anchor = targetGlyphs[targetBySource[neighbor] - 1].bounds.topLeft - sourceSprites[neighbor].pose.offset;
        }
      }
      final pose = source.pose;
      final scale = switch ((kind, group)) {
        (.text, null) => 0.95,
        (.text, _) => 0.8,
        _ => 1.0,
      };
      final center = group ?? (kind == .text ? leavingWordCenters[glyph] : null) ?? glyph.bounds.center;
      final offset = pose.offset + anchor + (center - glyph.bounds.topLeft) * (1 - scale);
      tracks.add(
        _TextMotionTrack(
          source.layout,
          glyph,
          pose,
          (
            offset: offset,
            scale: scale,
            opacity: 0,
            roll: kind == .text ? pose.roll : glyph.rollBounds.height,
          ),
          current: false,
          // Carry the end of an existing fade forward when another update arrives.
          // Restarting it retains invisible departed glyphs during sustained changes.
          fadeDuration: source.remainingExitFade ?? (kind == .text && group == null ? 0.25 : 0.45),
        ),
      );
    }

    for (var targetIndex = 0; targetIndex < targetGlyphs.length; targetIndex++) {
      final glyph = targetGlyphs[targetIndex];
      final target = glyph.bounds.topLeft;
      final destination = (offset: target, scale: 1.0, opacity: 1.0, roll: 0.0);
      final sourceIndex = sourceByTarget[targetIndex] - 1;
      if (sourceIndex >= 0) {
        tracks.add(
          _TextMotionTrack(
            layout,
            glyph,
            sourceSprites[sourceIndex].pose,
            destination,
            fadeDuration: 0.25,
          ),
        );
        continue;
      }
      final kind = glyph.kind;
      final group = kind == .text ? enteringGroups[glyph] : null;
      final scale = group != null
          ? 0.8
          : kind == .text
          ? 0.95
          : 1.0;
      final center = group ?? (kind == .text ? enteringWordCenters[glyph] : null) ?? glyph.bounds.center;
      var anchor = Offset.zero;
      if (group == null) {
        final neighbor = targetGlyphs.length > _directNeighborSearchLimit
            ? _preferredNeighbor(
                arrivingNeighbors,
                targetIndex,
                forwardFirst: false,
              )
            : _adjacentMatch(
                targetIndex,
                sourceByTarget,
                (index) => targetGlyphs[index].unit.start,
                forwardFirst: false,
              );
        if (neighbor >= 0) {
          anchor = -(targetGlyphs[neighbor].bounds.topLeft - sourceSprites[sourceByTarget[neighbor] - 1].pose.offset);
        }
      }
      final start = (
        offset: target + anchor + (center - target) * (1 - scale),
        scale: scale,
        opacity: 0.0,
        roll: switch (kind) {
          .text => 0.0,
          .digit => -glyph.rollBounds.height,
          .symbol => glyph.rollBounds.height,
        },
      );
      final ordinaryEntry = kind == .text && group == null;
      tracks.add(
        _TextMotionTrack(
          layout,
          glyph,
          start,
          destination,
          fadeDuration: ordinaryEntry
              ? 0.5
              : group == null
              ? 0.25
              : 0.35,
          fadeDelay: ordinaryEntry ? 0.25 : 0,
        ),
      );
    }
  }

  // Matching is synchronous. Short labels can address this table by UTF-16
  // offset without allocating a map for each transition.
  static final _sourceIndices = Uint32List(128);
  static const _directNeighborSearchLimit = 64;

  static int _adjacentMatch(
    int index,
    Uint32List matches,
    int Function(int) startAt, {
    required bool forwardFirst,
  }) {
    final offset = startAt(index);
    int searchForward() {
      for (var next = index + 1; next < matches.length; next++) {
        if (matches[next] != 0 && startAt(next) > offset) return next;
      }
      return -1;
    }

    int searchBackward() {
      for (var previous = index - 1; previous >= 0; previous--) {
        if (matches[previous] != 0 && startAt(previous) < offset) return previous;
      }
      return -1;
    }

    final preferred = forwardFirst ? searchForward() : searchBackward();
    return preferred >= 0
        ? preferred
        : forwardFirst
        ? searchBackward()
        : searchForward();
  }

  static (Uint32List, Uint32List) _directionalMatches(
    Uint32List matches,
    int Function(int) startAt,
  ) {
    // The current glyphs are in logical order. Keep the previous anchor until
    // this glyph has a different start, since a shaped unit can span two boxes.
    final backward = Uint32List(matches.length);
    var anchor = -1;
    var candidate = -1;
    for (var index = 0; index < matches.length; index++) {
      if (candidate >= 0 && startAt(candidate) < startAt(index)) anchor = candidate;
      backward[index] = anchor + 1;
      if (matches[index] != 0) candidate = index;
    }

    final forward = Uint32List(matches.length);
    anchor = -1;
    candidate = -1;
    for (var index = matches.length - 1; index >= 0; index--) {
      if (candidate >= 0 && startAt(candidate) > startAt(index)) anchor = candidate;
      forward[index] = anchor + 1;
      if (matches[index] != 0) candidate = index;
    }
    return (forward, backward);
  }

  static int _preferredNeighbor(
    (Uint32List, Uint32List) neighbors,
    int index, {
    required bool forwardFirst,
  }) {
    final (forward, backward) = neighbors;
    final next = forward[index];
    final previous = backward[index];
    return (forwardFirst ? (next == 0 ? previous : next) : (previous == 0 ? next : previous)) - 1;
  }

  final _TextMotionLayout layout;
  final Size initialSize;
  final tracks = <_TextMotionTrack>[];

  _TextMotionFrame frameAt(double time, double travel) {
    return _TextMotionFrame(layout, Size.lerp(initialSize, layout.size, travel)!, [
      for (final track in tracks) ?track.at(time, travel),
    ]);
  }

  // Painting is synchronous and every canvas records its own copy of the mesh.
  static final _paintBatch = _TextMotionPaintBatch();

  final _TextMotionLayout? _departingLayout;
  late final List<({_TextMotionLayout layout, double end})> departureExpirations = _computeDepartureExpirations();

  List<({_TextMotionLayout layout, double end})> _computeDepartureExpirations() {
    final byLayout = <_TextMotionLayout, double>{};
    for (final track in tracks) {
      // The destination tracks follow all outgoing tracks.
      if (track.current) break;
      final previous = track.layout;
      if (identical(previous, layout)) continue;
      final end = track.fadeDelay + track.fadeDuration;
      if (end > (byLayout[previous] ?? -1)) byLayout[previous] = end;
    }
    return [
      for (final MapEntry(key: layout, value: end) in byLayout.entries) (layout: layout, end: end),
    ]..sort((a, b) => a.end.compareTo(b.end));
  }

  late final List<_TextMotionPaintRun> _paintRuns = _compilePaintRuns();
  late final ({double travelDistance, double fadeEnd}) _settlingBounds = _computeSettlingBounds();

  double remainingDistance(double time, double travel) {
    final bounds = _settlingBounds;
    return time < bounds.fadeEnd ? double.infinity : bounds.travelDistance * (1 - travel);
  }

  ({double travelDistance, double fadeEnd}) _computeSettlingBounds() {
    var travelDistance = math.max(
      (initialSize.width - layout.size.width).abs(),
      (initialSize.height - layout.size.height).abs(),
    );
    var fadeEnd = 0.0;
    for (final run in _paintRuns) {
      final track = run.track;
      final start = track.pose;
      final end = track.destination;
      if (start.opacity != end.opacity) fadeEnd = math.max(fadeEnd, track.fadeDelay + track.fadeDuration);
      if (!track.current) continue;

      // Bound the movement of the entire slice, including its overhang.
      final clip = run.clip;
      final origin = track.glyph.bounds.topLeft;
      final scaleDelta = (start.scale - end.scale).abs();
      final dx =
          (start.offset.dx - end.offset.dx).abs() +
          math.max((clip.left - origin.dx).abs(), (clip.right - origin.dx).abs()) * scaleDelta;
      final dy =
          (start.offset.dy + start.roll - end.offset.dy - end.roll).abs() +
          math.max((clip.top - origin.dy).abs(), (clip.bottom - origin.dy).abs()) * scaleDelta;
      travelDistance = math.max(travelDistance, math.max(dx, dy));
    }
    return (travelDistance: travelDistance, fadeEnd: fadeEnd);
  }

  List<_TextMotionPaintRun> _compilePaintRuns() {
    final runs = <_TextMotionPaintRun>[];
    if (!_TextMotionAtlasBatch.usesRawAtlas || layout._preparedGlyphs == null) {
      for (final track in tracks) {
        if (runs.isNotEmpty && runs.last.append(track)) continue;
        runs.add(_TextMotionPaintRun(track));
      }
      return runs;
    }
    var previousEnd = 0;
    for (final track in tracks) {
      if (runs.isEmpty || !runs.last.append(track, previousEnd)) {
        runs.add(_TextMotionPaintRun(track));
      }
      previousEnd = track.glyph.unit.end;
    }
    return runs;
  }

  late final Map<_TextMotionPaintRun, _TextMotionVectorRun> _vectorRuns = _compileVectorRuns();

  Map<_TextMotionPaintRun, _TextMotionVectorRun> _compileVectorRuns() {
    // Widening a clip across a space can pick up ink from an overlapping line
    // and paint it using the wrong track's motion and opacity.
    if (layout._hasMultipleLines) return const {};
    final runs = _paintRuns;
    if (runs.length < 2) return const {};
    // All current tracks use the destination paragraph.
    final text = _asciiLtrText(layout);
    if (text == null) return const {};
    final groups = <_TextMotionPaintRun, _TextMotionVectorRun>{};
    var firstRun = 0;
    var nextRun = 0;
    var previousEnd = 0;
    Rect? groupClip;

    void finishGroup() {
      final clip = groupClip;
      if (clip == null) return;
      final group = _TextMotionVectorRun(runs[firstRun], clip);
      for (var index = firstRun; index < nextRun; index++) {
        groups[runs[index]] = group;
      }
    }

    for (final track in tracks) {
      if (nextRun < runs.length && identical(track, runs[nextRun].track)) {
        if (nextRun > 0) {
          final first = runs[firstRun];
          final previous = runs[nextRun - 1];
          final next = runs[nextRun];
          final start = track.glyph.unit.start;
          final canJoin =
              previousEnd < start &&
              previous.clip.right < next.clip.left &&
              previous.clip.top == next.clip.top &&
              previous.clip.bottom == next.clip.bottom &&
              identical(first.track.layout, track.layout) &&
              _hasEqualOpaqueMotion(first.track, track) &&
              _hasOnlySpaces(text, previousEnd, start);
          if (canJoin) {
            // A single clip preserves the shaped word overhangs in the gap.
            groupClip = (groupClip ?? first.clip).expandToInclude(next.clip);
          } else {
            finishGroup();
            firstRun = nextRun;
            groupClip = null;
          }
        }
        nextRun++;
      }
      previousEnd = track.glyph.unit.end;
    }
    finishGroup();
    return groups;
  }

  static String? _asciiLtrText(_TextMotionLayout layout) {
    final key = layout._key;
    final span = key.text;
    final decoration = span.style?.decoration;
    if (key.textDirection != .ltr ||
        span is! TextSpan ||
        span.children?.isNotEmpty == true ||
        (decoration != null && decoration != TextDecoration.none)) {
      return null;
    }
    final text = span.text;
    if (text == null) return null;
    for (var index = 0; index < text.length; index++) {
      final code = text.codeUnitAt(index);
      if (code != 0x0A && (code < 0x20 || code > 0x7E)) return null;
    }
    return text;
  }

  static bool _hasOnlySpaces(String text, int start, int end) {
    for (var index = start; index < end; index++) {
      if (text.codeUnitAt(index) != 0x20) return false;
    }
    return true;
  }

  static bool _hasEqualOpaqueMotion(_TextMotionTrack first, _TextMotionTrack next) {
    if (!_isOpaqueMatch(first) || !_isOpaqueMatch(next)) return false;
    final origin = first.glyph.bounds.topLeft;
    final nextOrigin = next.glyph.bounds.topLeft;
    return _TextMotionPaintRun._sameTranslation(first.pose, origin, next.pose, nextOrigin) &&
        _TextMotionPaintRun._sameTranslation(first.destination, origin, next.destination, nextOrigin);
  }

  static bool _isOpaqueMatch(_TextMotionTrack track) =>
      track.current &&
      track.pose.opacity == 1 &&
      track.destination.opacity == 1 &&
      track.pose.scale == 1 &&
      track.destination.scale == 1 &&
      track.pose.roll == 0 &&
      track.destination.roll == 0;

  void prepareTextures(double pixelRatio, {Set<_TextMotionLayout>? retained}) {
    final departingLayout = _departingLayout;
    if (departingLayout != null && !identical(departingLayout, layout)) {
      Rect? coverage;
      for (final run in _paintRuns) {
        if (!identical(run.track.layout, departingLayout)) break;
        coverage = coverage?.expandToInclude(run.clip) ?? run.clip;
      }
      if (coverage != null && (retained == null || retained.contains(departingLayout))) {
        departingLayout.prepareDepartureAtlas(pixelRatio, coverage);
      }
      layout.prepareTextureAt(pixelRatio);
      return;
    }
    _TextMotionLayout? previousLayout;
    for (final run in _paintRuns) {
      final layout = run.track.layout;
      if (identical(layout, previousLayout) || (retained != null && !retained.contains(layout))) continue;
      if (!identical(layout, this.layout) && layout.hasPreparedDepartureTexture(pixelRatio, run.clip)) continue;
      layout.prepareTextureAt(pixelRatio);
      previousLayout = layout;
    }
  }

  bool hasPendingTextures(double pixelRatio) {
    _TextMotionLayout? previousLayout;
    for (final run in _paintRuns) {
      final layout = run.track.layout;
      if (identical(layout, previousLayout)) continue;
      final pending = identical(layout, _departingLayout)
          ? layout.hasPendingTextureForDeparture(pixelRatio)
          : layout.hasPendingTexture(pixelRatio);
      if (pending) return true;
      previousLayout = layout;
    }
    return false;
  }

  void paint(Canvas canvas, double time, double travel, double pixelRatio) {
    _TextMotionLayout? previousLayout;
    _TextMotionTexture? texture;
    _TextMotionVectorRun? paintedVectorRun;
    _paintBatch.beginFrame(time, travel);
    try {
      for (final run in _paintRuns) {
        final track = run.track;
        final pose = track.visiblePoseAt(time, travel);
        if (pose == null) continue;
        final sprite = track;
        if (!identical(sprite.layout, previousLayout)) {
          previousLayout = sprite.layout;
          texture = sprite.layout.textureAt(pixelRatio);
        }
        final prepared = sprite.layout._preparedGlyphs;
        final raster = prepared != null && prepared.pixelRatio == pixelRatio
            ? prepared.forOffset(sprite.glyph.unit.start)
            : texture ?? sprite.layout.departureTextureAt(pixelRatio, run.clip);
        if (raster == null || raster.page.rasterizationFailed) {
          final group = sprite.current && sprite.layout._departureAtlas == null ? _vectorRuns[run] : null;
          // A page can fail midway through the group. Only skip after painting it.
          if (group != null && identical(group, paintedVectorRun)) continue;
          _paintBatch.flush(canvas);
          if (group != null && identical(run, group.first)) {
            sprite.paint(canvas, group.clip, pose);
            paintedVectorRun = group;
          } else {
            sprite.paint(canvas, run.clip, pose);
          }
          continue;
        }
        _paintBatch.add(canvas, raster, run, pose, pixelRatio);
      }
      _paintBatch.flush(canvas);
    } finally {
      _paintBatch.clear();
    }
  }

  static Map<_TextMotionGlyph, Offset> _groupCenters(
    List<_TextMotionGlyph> glyphs,
    Set<_TextMotionGlyph> matched,
    bool byWord,
    Set<int> splitWords,
  ) {
    final centers = <_TextMotionGlyph, Offset>{};
    final run = <_TextMotionGlyph>[];

    void finishRun() {
      final segments = {
        for (final glyph in run)
          if (!byWord || splitWords.contains(glyph.wordIndex))
            (glyph.wordIndex, glyph.unit.start)
          else
            (glyph.wordIndex, -1),
      };
      if (segments.length >= 6) {
        final bounds = run.map((glyph) => glyph.bounds).reduce((a, b) => a.expandToInclude(b));
        for (final glyph in run) {
          centers[glyph] = bounds.center;
        }
      }
      run.clear();
    }

    for (final glyph in glyphs) {
      if (matched.contains(glyph) || glyph.kind != .text) {
        finishRun();
        continue;
      }
      if (run.isNotEmpty && run.last.bounds.top != glyph.bounds.top) finishRun();
      run.add(glyph);
    }
    finishRun();
    return centers;
  }

  static Map<_TextMotionGlyph, Offset> _wordCenters(
    List<_TextMotionGlyph> glyphs,
    bool byWord,
    Set<int> splitWords,
  ) {
    if (!byWord) return {};
    final boundsByWord = <(int, double), Rect>{};
    for (final glyph in glyphs) {
      if (splitWords.contains(glyph.wordIndex)) continue;
      final segment = (glyph.wordIndex, glyph.bounds.top);
      boundsByWord.update(segment, (bounds) => bounds.expandToInclude(glyph.bounds), ifAbsent: () => glyph.bounds);
    }
    return {
      for (final glyph in glyphs)
        if (boundsByWord[(glyph.wordIndex, glyph.bounds.top)] case final bounds?) glyph: bounds.center,
    };
  }
}
