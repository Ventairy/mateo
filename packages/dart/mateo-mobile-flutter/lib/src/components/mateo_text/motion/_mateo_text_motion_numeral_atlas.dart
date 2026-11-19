part of '../mateo_text.dart';

typedef _NumeralInkPiece = (String, int);
typedef _NumeralInkPlacement = ({List<Offset> offsets, Rect sampleBounds});

/// Immutable page. All textures for an admitted label use this image.
class _NumeralInkPage {
  new(this.page, this._pieces, this.pixelRatio, this.suffixPhases) {
    page.owners++;
  }

  static const phases = 4;
  static const List<_NumeralInkPiece> digits = [
    ('0', phases),
    ('1', phases),
    ('2', phases),
    ('3', phases),
    ('4', phases),
    ('5', phases),
    ('6', phases),
    ('7', phases),
    ('8', phases),
    ('9', phases),
  ];

  final _TextMotionAtlasImage page;
  final Map<_NumeralInkPiece, _NumeralInkPlacement> _pieces;
  final double pixelRatio;
  final int suffixPhases;

  bool covers(_NumeralInkPiece piece, Rect clip) {
    final safe = _pieces[piece]?.sampleBounds;
    return safe != null &&
        clip.left >= safe.left &&
        clip.top >= safe.top &&
        clip.right <= safe.right &&
        clip.bottom <= safe.bottom;
  }

  _TextMotionTexture forPiece(_NumeralInkPiece piece, double logicalAnchor) {
    final pixelAnchor = logicalAnchor * pixelRatio;
    final samples = piece.$2;
    final phase = samples == 1 ? 0 : ((pixelAnchor - pixelAnchor.floor()) * samples).round() % samples;
    final content = _pieces[piece]!.offsets[phase];
    return _TextMotionTexture(page, Offset(logicalAnchor - content.dx / pixelRatio, -content.dy / pixelRatio));
  }

  void dispose() {
    if (--page.owners == 0) page.dispose();
  }
}

typedef _NumeralAffixFragment = ({Rect clip, double anchor});

class _NumeralAffixInk {
  new(this.picture, this.prefix, this.suffix);

  final ui.Picture picture;
  final _NumeralAffixFragment? prefix;
  final _NumeralAffixFragment? suffix;

  static _NumeralAffixInk? borrow(_TextMotionLayout layout, _PreparedNumeralTemplate template, double pixelRatio) {
    final picture = layout._picture;
    if (picture == null || layout._preparedGlyphs != null) return null;
    Rect? prefix;
    Rect? suffix;
    _TextMotionGlyph? firstDigit;
    _TextMotionGlyph? lastDigit;
    for (final glyph in layout.glyphs) {
      final unit = glyph.unit;
      if (unit.end <= template.numberStart) {
        prefix = prefix?.expandToInclude(glyph.paintBounds) ?? glyph.paintBounds;
      } else if (unit.start >= template.numberEnd) {
        suffix = suffix?.expandToInclude(glyph.paintBounds) ?? glyph.paintBounds;
      } else {
        if (unit.start < template.numberStart || unit.end > template.numberEnd) return null;
        firstDigit ??= glyph;
        lastDigit = glyph;
      }
    }
    if (firstDigit == null ||
        lastDigit == null ||
        (prefix == null && template.prefix.isNotEmpty) ||
        (suffix == null && template.suffix.isNotEmpty)) {
      return null;
    }
    final numberRight = lastDigit.bounds.right;
    // The admitted bundled Inter motion uses a space on either affix edge.
    // Leave room for an integer-aligned one-texel apron, including rounding,
    // without exposing a neighboring numeral to bilinear sampling.
    const minimumPixelGap = 3;
    if ((prefix != null && (firstDigit.paintBounds.left - prefix.right) * pixelRatio < minimumPixelGap) ||
        (suffix != null && (suffix.left - lastDigit.paintBounds.right) * pixelRatio < minimumPixelGap)) {
      return null;
    }
    // Retain the immutable display list independently of the Dart Picture
    // handle and its originating layout's geometry and raster resources.
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawPicture(picture);
    return _NumeralAffixInk(
      recorder.endRecording(),
      prefix == null ? null : (clip: prefix, anchor: 0),
      suffix == null ? null : (clip: suffix, anchor: numberRight),
    );
  }

  void dispose() => picture.dispose();
}

typedef _NumeralInkBatch = ({List<_NumeralAffixes> packed, List<_NumeralAffixes> rejected});
typedef _NumeralInkPlan = ({_NumeralInkBatch batch, int pixels});
typedef _NumeralInkPosition = (int left, int top, int rowHeight, int width);

class _NumeralInkShelf {
  static const _maximumWidth = 1024;
  static const _maximumHeight = 768;

  int left = 0;
  int top = 0;
  int rowHeight = 0;
  int width = 0;

  int get pixels => width * (top + rowHeight);

  _NumeralInkPosition get position => (left, top, rowHeight, width);

  void restore(_NumeralInkPosition position) {
    left = position.$1;
    top = position.$2;
    rowHeight = position.$3;
    width = position.$4;
  }

  bool place(int tileWidth, int tileHeight, int count, [void Function(int left, int top, int phase)? record]) {
    if (tileWidth > _maximumWidth || tileHeight > _maximumHeight) return false;
    for (var phase = 0; phase < count; phase++) {
      if (left + tileWidth > _maximumWidth) {
        left = 0;
        top += rowHeight;
        rowHeight = 0;
      }
      if (top + tileHeight > _maximumHeight) return false;
      record?.call(left, top, phase);
      left += tileWidth;
      width = math.max(width, left);
      rowHeight = math.max(rowHeight, tileHeight);
    }
    return true;
  }
}

double _sampleSpan(int phases) => (phases - 1) / phases;

(int, int, int, int)? _borrowedInkExtent(_NumeralInkPiece piece, double pixelRatio, _NumeralAffixInk? ink) {
  final phases = piece.$2;
  final fragment = phases == 1 ? ink?.prefix : ink?.suffix;
  if (fragment == null) return null;
  // Borrowed text already has shaped paint bounds. Pack just that ink,
  // with room for subpixel samples and an empty filter texel.
  final bounds = fragment.clip.shift(Offset(-fragment.anchor, 0));
  if (!bounds.isFinite) return null;
  return (
    (bounds.left * pixelRatio).floor() - 2,
    (bounds.top * pixelRatio).floor() - 2,
    (bounds.right * pixelRatio + _sampleSpan(phases)).ceil() + 2,
    (bounds.bottom * pixelRatio).ceil() + 2,
  );
}

typedef _NumeralInkTile = ({
  TextPainter? painter,
  _NumeralAffixInk? ink,
  _NumeralAffixFragment? fragment,
  _NumeralInkPlacement placement,
  List<Rect> tileBounds,
});

typedef _NumeralInkCrop = ({int left, int top, int right, int bottom});

/// Places all pieces of a template together or leaves the sheet unmodified.
class _NumeralInkSheet {
  new(this.config, this.pixelRatio);

  static const _pad = 6;
  final _PreparedNumeralConfig config;
  final double pixelRatio;
  final _tiles = <_NumeralInkPiece, _NumeralInkTile>{};
  final _shelf = _NumeralInkShelf();

  void _restoreBase(_NumeralInkPosition base, int pieceCount) {
    _shelf.restore(base);
    for (final piece in _tiles.keys.skip(pieceCount).toList()) {
      _tiles.remove(piece)!.painter?.dispose();
    }
  }

  bool place(Iterable<_NumeralInkPiece> pieces, {_NumeralAffixInk? ink}) {
    final placed = <_NumeralInkPiece>[];
    final origin = _shelf.position;
    for (final piece in pieces) {
      if (_tiles.containsKey(piece)) continue;
      if (_placePiece(piece, ink)) {
        placed.add(piece);
        continue;
      }
      for (final tile in placed) {
        _tiles.remove(tile)!.painter?.dispose();
      }
      _shelf.restore(origin);
      return false;
    }
    return true;
  }

  bool _placePiece(_NumeralInkPiece piece, _NumeralAffixInk? ink) {
    final (text, phases) = piece;
    final fragment = phases == 1 ? ink?.prefix : ink?.suffix;
    final painter = fragment != null
        ? null
        : (TextPainter(
            text: TextSpan(style: config.style, text: text),
            textDirection: TextDirection.ltr,
            locale: config.locale,
          )..layout());
    final int tileLeft;
    final int tileTop;
    final int tileRight;
    final int tileBottom;
    final phaseSpan = _sampleSpan(phases);
    if (fragment != null) {
      final extent = _borrowedInkExtent(piece, pixelRatio, ink);
      if (extent == null) return false;
      (tileLeft, tileTop, tileRight, tileBottom) = extent;
    } else {
      final logicalWidth = painter!.width * pixelRatio;
      final logicalHeight = painter.height * pixelRatio;
      if (!logicalWidth.isFinite || !logicalHeight.isFinite) {
        painter.dispose();
        return false;
      }
      // A line-edge numeral clip can extend past its advance.
      final horizontalPad = math.max(_pad, (logicalHeight * .25).ceil() + 2);
      tileLeft = -horizontalPad;
      tileTop = -_pad;
      tileRight = logicalWidth.ceil() + horizontalPad + 1;
      tileBottom = logicalHeight.ceil() + _pad;
    }
    final width = tileRight - tileLeft;
    final height = tileBottom - tileTop;
    final offsets = <Offset>[];
    final tileBounds = <Rect>[];
    if (!_shelf.place(width, height, phases, (left, top, phase) {
      tileBounds.add(Rect.fromLTWH(left.toDouble(), top.toDouble(), width.toDouble(), height.toDouble()));
      offsets.add(Offset(left - tileLeft + phase / phases, (top - tileTop).toDouble()));
    })) {
      painter?.dispose();
      return false;
    }
    // Reserve a transparent filter texel past the largest clip on each side.
    // The last subpixel phase has the least space on its right side.
    final sampleBounds = Rect.fromLTRB(
      (tileLeft + 1) / pixelRatio,
      (tileTop + 1) / pixelRatio,
      (tileRight - phaseSpan - 1) / pixelRatio,
      (tileBottom - 1) / pixelRatio,
    );
    _tiles[piece] = (
      painter: painter,
      ink: ink,
      fragment: fragment,
      placement: (offsets: offsets, sampleBounds: sampleBounds),
      tileBounds: tileBounds,
    );
    return true;
  }

  void _compactNumeralTiles(List<_NumeralAffixes> affixes) {
    final leadingOverhang = affixes.any((affix) => affix.$1.isEmpty);
    final trailingOverhang = affixes.any((affix) => affix.$2.isEmpty);
    final trial = _NumeralInkShelf();
    final crops = <_NumeralInkPiece, _NumeralInkCrop>{};
    for (final MapEntry(key: piece, value: tile) in _tiles.entries) {
      final source = tile.tileBounds.first;
      var width = source.width.toInt();
      var height = source.height.toInt();
      if (tile.painter != null) {
        final text = piece.$1;
        final digit = text.length == 1 && _isDigit(text);
        if (digit || text == ',' || text == '.') {
          // Phase zero's text origin and the stock tile edges are integers.
          final horizontalPad = (tile.placement.offsets.first.dx - source.left).toInt();
          final crop = (
            left: digit && leadingOverhang ? 0 : horizontalPad - 2,
            top: _pad - 2,
            right: digit && trailingOverhang ? 0 : horizontalPad - 3,
            bottom: _pad - 2,
          );
          crops[piece] = crop;
          width -= crop.left + crop.right;
          height -= crop.top + crop.bottom;
        }
      }
      if (!trial.place(width, height, tile.tileBounds.length)) return;
    }
    if (trial.pixels >= _shelf.pixels) return;

    // Keep the original admissions and sample counts even when a tighter seed
    // could fit different affixes. Only smaller, complete repacks are committed.
    _shelf.restore((0, 0, 0, 0));
    for (final MapEntry(key: piece, value: tile) in _tiles.entries) {
      final crop = crops[piece];
      final leftTrim = crop?.left ?? 0;
      final topTrim = crop?.top ?? 0;
      final source = tile.tileBounds.first;
      final offsets = tile.placement.offsets;
      final originalOrigin = offsets.first;
      final width = source.width.toInt() - leftTrim - (crop?.right ?? 0);
      final height = source.height.toInt() - topTrim - (crop?.bottom ?? 0);
      final placed = _shelf.place(width, height, tile.tileBounds.length, (left, top, phase) {
        final bounds = tile.tileBounds[phase];
        final dx = left - bounds.left - leftTrim;
        final dy = top - bounds.top - topTrim;
        offsets[phase] = offsets[phase].translate(dx, dy);
        tile.tileBounds[phase] = Rect.fromLTWH(left.toDouble(), top.toDouble(), width.toDouble(), height.toDouble());
      });
      assert(placed, 'The compact page must fit the placements accepted in the trial.');
      if (crop == null) continue;

      final localLeft = source.left - originalOrigin.dx + leftTrim;
      final localTop = source.top - originalOrigin.dy + topTrim;
      final phaseSpan = _sampleSpan(offsets.length);
      _tiles[piece] = (
        painter: tile.painter,
        ink: tile.ink,
        fragment: tile.fragment,
        placement: (
          offsets: offsets,
          sampleBounds: Rect.fromLTRB(
            (localLeft + 1) / pixelRatio,
            (localTop + 1) / pixelRatio,
            (localLeft + width - phaseSpan - 1) / pixelRatio,
            (localTop + height - 1) / pixelRatio,
          ),
        ),
        tileBounds: tile.tileBounds,
      );
    }
  }

  ({_NumeralInkPage? page, int blockedPixels}) finish(int suffixPhases, List<_NumeralAffixes> affixes) {
    _compactNumeralTiles(affixes);
    final height = _shelf.top + _shelf.rowHeight;
    final width = _shelf.width;
    if (!_TextMotionTexture.reserve(width, height)) return (page: null, blockedPixels: width * height);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    for (final tile in _tiles.values) {
      final offsets = tile.placement.offsets;
      for (var index = 0; index < offsets.length; index++) {
        final offset = offsets[index];
        final fragment = tile.fragment;
        var clip = tile.tileBounds[index];
        var horizontal = offset.dx;
        if (fragment != null) {
          horizontal -= fragment.anchor * pixelRatio;
          final source = fragment.clip;
          final crop = Rect.fromLTRB(
            (horizontal + source.left * pixelRatio).floorToDouble() - 1,
            (offset.dy + source.top * pixelRatio).floorToDouble() - 1,
            (horizontal + source.right * pixelRatio).ceilToDouble() + 1,
            (offset.dy + source.bottom * pixelRatio).ceilToDouble() + 1,
          );
          clip = crop.intersect(clip);
        }
        canvas
          ..save()
          ..clipRect(clip, doAntiAlias: false)
          ..translate(horizontal, offset.dy)
          ..scale(pixelRatio);
        if (fragment == null) {
          tile.painter!.paint(canvas, Offset.zero);
        } else {
          canvas.drawPicture(tile.ink!.picture);
        }
        canvas.restore();
      }
    }
    final page = _TextMotionTexture.rasterizePageSync(recorder.endRecording(), width, height);
    return (
      page: page == null
          ? null
          : _NumeralInkPage(page, _tiles.map((key, tile) => MapEntry(key, tile.placement)), pixelRatio, suffixPhases),
      blockedPixels: 0,
    );
  }

  void dispose() {
    for (final tile in _tiles.values) {
      tile.painter?.dispose();
    }
  }
}
