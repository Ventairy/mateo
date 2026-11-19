part of '../mateo_text.dart';

/// Batches moving text fragments in their original paint order. The mesh uses
/// up to three quads per rolling glyph to cover the center and the two fades.
class _TextMotionPaintBatch {
  static const _capacity = 512;
  final _positions = Float32List(_capacity * 2);
  final _coordinates = Float32List(_capacity * 2);
  final _colors = Int32List(_capacity);
  final _indices = Uint16List(_capacity * 3);
  _TextMotionTexture? _raster;
  late final _rawAtlas = _TextMotionRawAtlasBatch();
  int _vertexCount = 0;
  int _indexCount = 0;

  void beginFrame(double time, double travel) {
    if (_TextMotionAtlasBatch.usesRawAtlas) _rawAtlas.beginFrame(time, travel);
  }

  void add(
    Canvas canvas,
    _TextMotionTexture raster,
    _TextMotionPaintRun run,
    _TextMotionPose pose,
    double pixelRatio,
  ) {
    final sprite = run.track;
    final glyph = sprite.glyph;
    final clip = run.clip;
    final bounds = glyph.bounds;
    final scale = pose.scale;
    final origin = pose.offset;
    final imageLeft = origin.dx - bounds.left * scale;
    final imageTop = origin.dy + pose.roll - bounds.top * scale;
    var left = clip.left * scale + imageLeft;
    var right = clip.right * scale + imageLeft;
    var top = clip.top * scale + imageTop;
    var bottom = clip.bottom * scale + imageTop;

    final rolling = glyph.kind != .text && pose.roll != 0;
    var fade = 0.0;
    var rollTop = 0.0;
    var rollBottom = 0.0;
    if (rolling) {
      final slot = glyph.rollBounds;
      rollTop = slot.top + origin.dy - bounds.top;
      rollBottom = slot.bottom + origin.dy - bounds.top;
      fade = math.min(sprite.layout.numberFade, slot.height / 2);
      top = math.max(top, rollTop);
      bottom = math.min(bottom, rollBottom);
      left = math.max(left, slot.left + origin.dx - bounds.left);
      right = math.min(right, slot.right + origin.dx - bounds.left);
    }
    if (left >= right || top >= bottom) return;
    if (_TextMotionAtlasBatch.usesRawAtlas) {
      _rawAtlas.add(
        canvas,
        raster,
        run,
        pose,
        Rect.fromLTRB(left, top, right, bottom),
        Offset(imageLeft, imageTop),
        pixelRatio,
        (top: rollTop, bottom: rollBottom, fade: fade),
      );
      return;
    }

    if (!identical(_raster?.page, raster.page) || _vertexCount + 8 > _capacity) {
      flush(canvas);
      _raster = raster;
    }
    final textureScale = pixelRatio / scale;
    final sourceLeft = (left - imageLeft) * textureScale - raster.origin.dx * pixelRatio;
    final sourceRight = (right - imageLeft) * textureScale - raster.origin.dx * pixelRatio;
    final first = _vertexCount;
    void row(double y) {
      final alpha = fade == 0
          ? pose.opacity
          : pose.opacity * (math.min(y - rollTop, rollBottom - y) / fade).clamp(0.0, 1.0);
      final color = (alpha * 255).round() << 24;
      final sourceY = (y - imageTop) * textureScale - raster.origin.dy * pixelRatio;
      final index = _vertexCount * 2;
      _positions[index] = left;
      _positions[index + 1] = y;
      _positions[index + 2] = right;
      _positions[index + 3] = y;
      _coordinates[index] = sourceLeft;
      _coordinates[index + 1] = sourceY;
      _coordinates[index + 2] = sourceRight;
      _coordinates[index + 3] = sourceY;
      _colors[_vertexCount] = color;
      _colors[_vertexCount + 1] = color;
      _vertexCount += 2;
    }

    row(top);
    if (rolling) {
      final fadeIn = rollTop + fade;
      final fadeOut = rollBottom - fade;
      if (fadeIn > top && fadeIn < bottom) row(fadeIn);
      if (fadeOut > math.max(top, fadeIn) && fadeOut < bottom) row(fadeOut);
    }
    row(bottom);
    for (var i = first; i < _vertexCount - 2; i += 2) {
      _indices[_indexCount++] = i;
      _indices[_indexCount++] = i + 1;
      _indices[_indexCount++] = i + 2;
      _indices[_indexCount++] = i + 1;
      _indices[_indexCount++] = i + 2;
      _indices[_indexCount++] = i + 3;
    }
  }

  void flush(Canvas canvas) {
    if (_TextMotionAtlasBatch.usesRawAtlas) {
      _rawAtlas.flush(canvas);
      return;
    }
    final raster = _raster;
    if (raster == null || _vertexCount == 0) return;
    final vertices = ui.Vertices.raw(
      VertexMode.triangles,
      Float32List.sublistView(_positions, 0, _vertexCount * 2),
      textureCoordinates: Float32List.sublistView(_coordinates, 0, _vertexCount * 2),
      colors: Int32List.sublistView(_colors, 0, _vertexCount),
      indices: Uint16List.sublistView(_indices, 0, _indexCount),
    );
    try {
      canvas.drawVertices(vertices, BlendMode.srcIn, raster.paint);
    } finally {
      vertices.dispose();
      clear();
    }
  }

  void clear() {
    if (_TextMotionAtlasBatch.usesRawAtlas) _rawAtlas.clear();
    _raster = null;
    _vertexCount = 0;
    _indexCount = 0;
  }
}

class _TextMotionVectorRun {
  const new(this.first, this.clip);

  final _TextMotionPaintRun first;
  final Rect clip;
}

/// Adjacent glyphs on the same paragraph and motion path can use one slice.
class _TextMotionPaintRun {
  new(this.track) : clip = track.glyph.paintBounds;

  final _TextMotionTrack track;
  Rect clip;

  bool append(_TextMotionTrack other, [int? previousEnd]) {
    final source = track;
    final next = other;
    final textures = source.layout._preparedGlyphs;
    if (!identical(source.layout, next.layout) ||
        (textures != null &&
            !identical(textures.forOffset(source.glyph.unit.start), textures.forOffset(next.glyph.unit.start))) ||
        source.pose.roll != 0 ||
        next.pose.roll != 0 ||
        track.destination.roll != 0 ||
        other.destination.roll != 0 ||
        source.pose.scale != next.pose.scale ||
        track.destination.scale != other.destination.scale ||
        source.pose.opacity != next.pose.opacity ||
        track.destination.opacity != other.destination.opacity) {
      return false;
    }
    final hasFade = source.pose.opacity != track.destination.opacity;
    if (hasFade && (track.fadeDelay != other.fadeDelay || track.fadeDuration != other.fadeDuration)) return false;
    final nextClip = next.glyph.paintBounds;
    if (clip.top != nextClip.top || clip.bottom != nextClip.bottom) return false;
    final separated = clip.left > nextClip.right + 0.001 || nextClip.left > clip.right + 0.001;
    if (separated) {
      // A prepared affix is one ink tile. An opaque slice can cover its
      // neighboring space if the next glyph follows the same path.
      if (previousEnd == null ||
          textures == null ||
          nextClip.left <= clip.right ||
          !source.current ||
          !next.current ||
          source.pose.opacity != 1 ||
          track.destination.opacity != 1 ||
          source.pose.scale != 1 ||
          track.destination.scale != 1) {
        return false;
      }
      final span = source.layout._key.text;
      final start = next.glyph.unit.start;
      if (span is! TextSpan ||
          span.text == null ||
          previousEnd >= start ||
          !_TextMotionTransition._hasOnlySpaces(span.text!, previousEnd, start)) {
        return false;
      }
    }

    final sourcePosition = source.glyph.bounds.topLeft;
    final nextPosition = next.glyph.bounds.topLeft;
    final tolerance = separated ? 1e-9 : 0.001;
    if (!_sameTranslation(source.pose, sourcePosition, next.pose, nextPosition, tolerance: tolerance) ||
        !_sameTranslation(track.destination, sourcePosition, other.destination, nextPosition, tolerance: tolerance)) {
      return false;
    }
    clip = clip.expandToInclude(nextClip);
    return true;
  }

  static bool _sameTranslation(
    _TextMotionPose a,
    Offset aOrigin,
    _TextMotionPose b,
    Offset bOrigin, {
    double tolerance = .001,
  }) {
    final deltaX = a.offset.dx - b.offset.dx - (aOrigin.dx - bOrigin.dx) * a.scale;
    final deltaY = a.offset.dy - b.offset.dy - (aOrigin.dy - bOrigin.dy) * a.scale;
    return deltaX.abs() < tolerance && deltaY.abs() < tolerance;
  }
}

// Skia's native atlas operation samples an image without installing it as a
// paint shader. Subdivide only the feathered edges; the center is one quad.
class _TextMotionRawAtlasBatch {
  static const _capacity = 512;
  static const _fadeSlices = 8;
  static final _paint = Paint()..filterQuality = FilterQuality.low;

  final _transforms = Float32List(_capacity * 4);
  final _bounds = Float32List(_capacity * 4);
  final _colors = Int32List(_capacity);
  // The native draw copies the values synchronously, so the length-specific
  // views can share the scratch buffers across draws and frames.
  late final _cachedViews = List<_TextMotionAtlasViews?>.filled(64, null);
  final _runs = <_TextMotionPaintRun>[];
  _TextMotionAtlasImage? _page;
  int _count = 0;
  double _time = 0;
  double _travel = 0;

  void beginFrame(double time, double travel) {
    _time = time;
    _travel = travel;
  }

  void add(
    Canvas canvas,
    _TextMotionTexture texture,
    _TextMotionPaintRun run,
    _TextMotionPose pose,
    Rect clip,
    Offset imageOffset,
    double pixelRatio,
    ({double top, double bottom, double fade}) roll,
  ) {
    if (!identical(_page, texture.page) || _count + 2 * _fadeSlices + 1 > _capacity) {
      flush(canvas);
      _page = texture.page;
    }
    if (texture.page.rasterizationFailed) {
      run.track.paint(canvas, run.clip, pose);
      return;
    }
    final initialCount = _count;
    final spriteScale = pose.scale / pixelRatio;
    final textureScale = pixelRatio / pose.scale;
    final sourceLeft = (clip.left - imageOffset.dx) * textureScale - texture.origin.dx * pixelRatio;
    final sourceRight = (clip.right - imageOffset.dx) * textureScale - texture.origin.dx * pixelRatio;
    final sourceTop = texture.origin.dy * pixelRatio;
    void addBand(double upper, double lower) {
      if (upper >= lower) return;
      final middle = (upper + lower) * 0.5;
      final opacity = roll.fade == 0
          ? pose.opacity
          : pose.opacity * (math.min(middle - roll.top, roll.bottom - middle) / roll.fade).clamp(0.0, 1.0);
      final alpha = (opacity * 255).round();
      if (alpha == 0) return;

      final offset = _count * 4;
      _transforms[offset] = spriteScale;
      _transforms[offset + 1] = 0;
      _transforms[offset + 2] = clip.left;
      _transforms[offset + 3] = upper;
      _bounds[offset] = sourceLeft;
      _bounds[offset + 1] = (upper - imageOffset.dy) * textureScale - sourceTop;
      _bounds[offset + 2] = sourceRight;
      _bounds[offset + 3] = (lower - imageOffset.dy) * textureScale - sourceTop;
      _colors[_count++] = (alpha << 24) | 0xFFFFFF;
    }

    if (roll.fade == 0) {
      addBand(clip.top, clip.bottom);
    } else {
      // Fainter glyphs need fewer strips for the same opacity error bound.
      // Use four strips for short fades, covering about 1.6 device pixels
      // each at full opacity. Wider fades use the finer sample limit.
      final sampleLimit = roll.fade * pixelRatio <= 6.4 ? 4 : _fadeSlices;
      final fadeSlices = math.min(sampleLimit, math.max(1, (pose.opacity * _fadeSlices).ceil()));
      // Keep internal strip edges just off the pixel centers where independent
      // float32 atlas transforms can otherwise leave a one-pixel seam.
      final edgeBias = math.min(0.005 / pixelRatio, roll.fade / (2 * fadeSlices));
      void addFade(double begin, double end) {
        if (clip.top >= end || clip.bottom <= begin) return;
        final span = end - begin;
        var upper = math.max(clip.top, begin);
        for (var index = 1; index <= fadeSlices; index++) {
          final edge = index == fadeSlices ? end : begin + span * (index / fadeSlices) + edgeBias;
          if (edge <= clip.top) continue;
          addBand(upper, math.min(clip.bottom, edge));
          if (edge >= clip.bottom) break;
          upper = edge;
        }
      }

      final fadeIn = roll.top + roll.fade + edgeBias;
      final fadeOut = roll.bottom - roll.fade + edgeBias;
      addFade(roll.top, fadeIn);
      addBand(math.max(clip.top, fadeIn), math.min(clip.bottom, fadeOut));
      addFade(fadeOut, roll.bottom);
    }
    if (_count != initialCount) _runs.add(run);
  }

  void flush(Canvas canvas) {
    final page = _page;
    if (page == null || _count == 0) return;
    try {
      final views = _count <= _cachedViews.length
          ? (_cachedViews[_count - 1] ??= (
              transforms: Float32List.sublistView(_transforms, 0, _count * 4),
              bounds: Float32List.sublistView(_bounds, 0, _count * 4),
              colors: Int32List.sublistView(_colors, 0, _count),
            ))
          : null;
      canvas.drawRawAtlas(
        page.image,
        views?.transforms ?? Float32List.sublistView(_transforms, 0, _count * 4),
        views?.bounds ?? Float32List.sublistView(_bounds, 0, _count * 4),
        views?.colors ?? Int32List.sublistView(_colors, 0, _count),
        BlendMode.modulate,
        null,
        _paint,
      );
    } on ui.PictureRasterizationException {
      page.rasterizationFailed = true;
      for (final run in _runs) {
        // Only tracks that contributed pixels at this time enter the batch.
        run.track.paint(canvas, run.clip, run.track.visiblePoseAt(_time, _travel)!);
      }
    } finally {
      clear();
    }
  }

  void clear() {
    _page = null;
    _count = 0;
    _runs.clear();
  }
}

typedef _TextMotionAtlasViews = ({Float32List transforms, Float32List bounds, Int32List colors});
