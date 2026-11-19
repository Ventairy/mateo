part of '../mateo_text.dart';

// Keep contextually shaped words together. Flutter still lays out both full paragraphs.
final _joinedScript = RegExp(
  r'[\p{Script=Arabic}\p{Script=Syriac}\p{Script=Devanagari}\p{Script=Bengali}\p{Script=Gurmukhi}'
  r'\p{Script=Gujarati}\p{Script=Oriya}\p{Script=Tamil}\p{Script=Telugu}\p{Script=Kannada}'
  r'\p{Script=Malayalam}\p{Script=Sinhala}\p{Script=Myanmar}\p{Script=Khmer}]',
  unicode: true,
);

class _TextMotionGlyph {
  new(this.unit, this.wordIndex, this.bounds, this.paintBounds, this.kind, this.rollBounds);

  final _TextMotionUnit unit;
  final int wordIndex;
  final Rect bounds;
  final Rect paintBounds;
  final _TextMotionKind kind;
  final Rect rollBounds;
}

/// Each affix borrows one texture. The numeric token has one per UTF-16 unit.
class _PreparedGlyphTextures {
  const new(this.page, this.pixelRatio, this.numberStart, this.before, this.number, this.after);

  final _TextMotionAtlasImage page;
  final double pixelRatio;
  final int numberStart;
  final _TextMotionTexture? before;
  final List<_TextMotionTexture> number;
  final _TextMotionTexture? after;

  _TextMotionTexture? forOffset(int start) {
    final index = start - numberStart;
    if (index < 0) return before;
    return index < number.length ? number[index] : after;
  }

  void dispose() {
    before?.dispose();
    for (final texture in number) {
      texture.dispose();
    }
    after?.dispose();
  }
}

class _TextMotionLayout {
  new _(this._key, String data, RenderParagraph paragraph, _TextMotionLineMetrics? knownNumericMetrics)
    : _preparedGlyphs = null,
      glyphs = <_TextMotionGlyph>[],
      _dataHash = data.hashCode,
      byWord = data.contains(' ') || data.contains('\n'),
      fontSize = _key.textScaler.scale(_key.text.style?.fontSize ?? 14) {
    _TextMotionNativeParagraph? nativeParagraph;
    if (_canBorrowNativeParagraph(paragraph)) {
      final isDirectChild = paragraph.parent is _RenderMateoTextMotion;
      // Both paths refresh native layout after paint-only changes. Checking
      // overflow before painting an annotated descendant avoids reading its
      // RenderBox.size during an ancestor's layout.
      if (isDirectChild) {
        nativeParagraph = _TextMotionParagraphCanvas.borrow(paragraph);
      } else {
        paragraph.getBoxesForSelection(const TextSelection.collapsed(offset: 0));
      }
      final textSize = paragraph.textSize;
      final nativeSize = _key.constraints.constrain(textSize);
      if (!_canAnimate(textSize, nativeSize, truncated: paragraph.didExceedMaxLines)) {
        size = nativeSize;
        canAnimate = false;
        words = const [];
        return;
      }

      if (!isDirectChild && !debugRepaintTextRainbowEnabled) {
        nativeParagraph = _TextMotionParagraphCanvas.borrow(paragraph);
      }
      if (nativeParagraph != null) {
        size = nativeSize;
        canAnimate = true;
        // The picture survives updates to the native paragraph.
        final recorder = ui.PictureRecorder();
        Canvas(recorder).drawParagraph(nativeParagraph.paragraph, nativeParagraph.offset);
        _picture = recorder.endRecording();
      }
    }

    if (nativeParagraph == null) {
      final painter = _newPainter(_key.text)
        ..layout(
          minWidth: _key.constraints.minWidth,
          maxWidth: _key.softWrap || _key.overflow == TextOverflow.ellipsis
              ? _key.constraints.maxWidth
              : double.infinity,
        );
      _painter = painter;
      size = _key.constraints.constrain(painter.size);
      canAnimate = _canAnimate(painter.size, size, truncated: painter.didExceedMaxLines);
    }

    words = canAnimate ? _textMotionWords(data) : const [];
    if (canAnimate) _collectGlyphs(data, nativeParagraph, knownNumericMetrics);
  }

  new _replay(this._key, String data, _TextMotionLineMetrics? knownNumericMetrics)
    : _preparedGlyphs = null,
      glyphs = <_TextMotionGlyph>[],
      _dataHash = data.hashCode,
      byWord = data.contains(' ') || data.contains('\n'),
      fontSize = _key.textScaler.scale(_key.text.style?.fontSize ?? 14) {
    final painter = _newPainter(_key.text)
      ..layout(
        minWidth: _key.constraints.minWidth,
        maxWidth: _key.softWrap || _key.overflow == TextOverflow.ellipsis ? _key.constraints.maxWidth : double.infinity,
      );
    _painter = painter;
    size = _key.constraints.constrain(painter.size);
    canAnimate = _canAnimate(painter.size, size, truncated: painter.didExceedMaxLines);
    words = canAnimate ? _textMotionWords(data) : const [];
    if (!canAnimate) return;

    final capture = _TextMotionParagraphCanvas();
    painter.paint(capture, Offset.zero);
    final native = capture._drawnParagraph;
    if (native != null) {
      final recorder = ui.PictureRecorder();
      Canvas(recorder).drawParagraph(native.paragraph, native.offset);
      _picture = recorder.endRecording();
    }
    _collectGlyphs(data, native, knownNumericMetrics);
    if (_picture != null) {
      _painter = null;
      painter.dispose();
    }
  }

  new _prepared(
    _TextMotionLayout reference,
    String data,
    double width,
    double height,
    List<_TextMotionWord> preparedWords,
    this.glyphs,
    _PreparedGlyphTextures preparedTextures,
  ) : _key = (
        fontGeneration: reference._key.fontGeneration,
        text: TextSpan(text: data, style: reference._key.text.style),
        textAlign: reference._key.textAlign,
        textDirection: reference._key.textDirection,
        textScaler: reference._key.textScaler,
        maxLines: reference._key.maxLines,
        locale: reference._key.locale,
        strutStyle: reference._key.strutStyle,
        textWidthBasis: reference._key.textWidthBasis,
        textHeightBehavior: reference._key.textHeightBehavior,
        hyphens: reference._key.hyphens,
        overflow: reference._key.overflow,
        softWrap: reference._key.softWrap,
        constraints: reference._key.constraints,
      ),
      _dataHash = data.hashCode,
      byWord = data.contains(' ') || data.contains('\n'),
      fontSize = reference.fontSize,
      _preparedGlyphs = preparedTextures {
    size = _key.constraints.constrain(Size(width, height));
    canAnimate = true;
    words = preparedWords;
    _owners = 1;
  }

  factory acquireForReplay(
    RenderParagraph paragraph,
    String data,
    BoxConstraints constraints, {
    _TextMotionLineMetrics? knownNumericMetrics,
  }) {
    final native = paragraph.text as TextSpan;
    if (native.text == data) {
      return _TextMotionLayout.acquire(paragraph, data, constraints, knownNumericMetrics: knownNumericMetrics);
    }
    final span = TextSpan(text: data, style: native.style, locale: native.locale);
    final key = _keyFor(paragraph, span, constraints);
    final layout = _active.putIfAbsent(
      key,
      () => _takeRecentLayout(key) ?? _TextMotionLayout._replay(key, data, knownNumericMetrics),
    );
    layout._owners++;
    return layout;
  }

  factory acquire(
    RenderParagraph paragraph,
    String data,
    BoxConstraints constraints, {
    _TextMotionLineMetrics? knownNumericMetrics,
  }) {
    _listenForFontChanges();
    final key = _keyFor(paragraph, paragraph.text, constraints);
    final layout = _active.putIfAbsent(
      key,
      () => _takeRecentLayout(key) ?? _TextMotionLayout._(key, data, paragraph, knownNumericMetrics),
    );
    layout._owners++;
    return layout;
  }

  static _TextMotionLayoutKey _keyFor(RenderParagraph paragraph, InlineSpan text, BoxConstraints constraints) => (
    fontGeneration: _fontGeneration,
    text: text,
    textAlign: paragraph.textAlign,
    textDirection: paragraph.textDirection,
    textScaler: paragraph.textScaler,
    maxLines: paragraph.maxLines,
    locale: paragraph.locale,
    strutStyle: paragraph.strutStyle,
    textWidthBasis: paragraph.textWidthBasis,
    textHeightBehavior: paragraph.textHeightBehavior,
    hyphens: paragraph.hyphens,
    overflow: paragraph.overflow,
    softWrap: paragraph.softWrap,
    constraints: constraints,
  );

  void _collectGlyphs(
    String data,
    _TextMotionNativeParagraph? nativeParagraph,
    _TextMotionLineMetrics? knownNumericMetrics,
  ) {
    final nativeBand = nativeParagraph == null ? null : _nativeLineBand(nativeParagraph, data, knownNumericMetrics);
    final nativeEdges = nativeBand == null
        ? null
        : _numberRollEdges(nativeBand.$1.top, nativeBand.$1.bottom, nativeBand.$2);
    final lines = nativeBand == null
        ? nativeParagraph?.paragraph.computeLineMetrics() ?? _painter!.computeLineMetrics()
        : null;
    _hasMultipleLines = lines != null && lines.length > 1;
    for (var index = 0; index < words.length; index++) {
      _addWordGlyphs(
        words[index],
        index,
        lines: lines,
        nativeParagraph: nativeParagraph,
        nativeBand: nativeBand,
        nativeEdges: nativeEdges,
      );
    }
  }

  static _TextMotionLayout? _takeRecentLayout(_TextMotionLayoutKey key) {
    final layout = _recent.remove(key);
    if (layout != null) _recentBytes -= layout._retainedBytes;
    return layout;
  }

  // Share active endpoints. Retired destinations can keep their recorded
  // paragraph and glyph geometry after their atlas is released.
  static final _active = <_TextMotionLayoutKey, _TextMotionLayout>{};
  static final _recent = <_TextMotionLayoutKey, _TextMotionLayout>{};
  static const int _maxRecentBytes = 512 * 1024;
  static const _maxRecentLayouts = 64;
  static const int _maxActiveRecentBytes = 2 * 1024 * 1024;
  static const _maxActiveRecentLayouts = 256;
  static final _retiredTextHashes = <int>{};
  static int _recentBytes = 0;
  static int _fontGeneration = 0;
  static bool _listensToFonts = false;

  static void _listenForFontChanges() {
    if (_listensToFonts) return;
    PaintingBinding.instance.systemFonts.addListener(_invalidateFonts);
    _listensToFonts = true;
  }

  static void _invalidateFonts() {
    _fontGeneration++;
    _PreparedNumeralBank.invalidateBanks();
    _clearNumericMetrics();
    _retiredTextHashes.clear();
    for (final layout in _recent.values) {
      layout._disposePicture();
    }
    _recent.clear();
    _recentBytes = 0;
  }

  final _TextMotionLayoutKey _key;
  final int _dataHash;
  final bool byWord;
  late final List<_TextMotionWord> words;
  late final _TextMotionFrame restFrame = _TextMotionFrame.atRest(this);
  TextPainter? _painter;
  final List<_TextMotionGlyph> glyphs;
  final double fontSize;
  _TextMotionLineMetrics? _measuredNumericMetrics;
  bool _hasMultipleLines = false;
  late final Size size;
  late final bool canAnimate;
  int _owners = 0;
  bool _wasDestination = false;
  ui.Picture? _picture;
  final _PreparedGlyphTextures? _preparedGlyphs;
  Map<double, _TextMotionTextureEntry?>? _textures;
  ({Rect coverage, double pixelRatio, Map<double, _TextMotionTextureEntry?> textures})? _departureAtlas;

  // The engine reports its display list size. Also budget Dart glyph records,
  // their rectangles and text ranges, and word and grapheme strings.
  late final int _retainedBytes =
      512 +
      _recordedPictureBytes +
      glyphs.length * 384 +
      words.fold(0, (bytes, word) => bytes + 128 + word.units.length * 80 + word.text.length * 4);

  int get _recordedPictureBytes {
    final bytes = _picture!.approximateBytesUsed;
    // Flutter 3.50 binds the native size_t result as Uint64. On 32-bit
    // devices the upper register does not belong to the result.
    return ffi.sizeOf<ffi.Size>() == 4 ? bytes.toUnsigned(32) : bytes;
  }

  static void _clearNumericMetrics() => _lastNumericMetrics = _previousNumericMetrics = _oldestNumericMetrics = null;

  static void _clearIdleNumericMetrics() {
    if (_active.isEmpty && _textMotionClock._started.isEmpty) _clearNumericMetrics();
  }

  static (_TextMotionLineStyle, _TextMotionLineMetrics)? _lastNumericMetrics;
  static (_TextMotionLineStyle, _TextMotionLineMetrics)? _previousNumericMetrics;
  static (_TextMotionLineStyle, _TextMotionLineMetrics)? _oldestNumericMetrics;

  TextPainter _newPainter(InlineSpan span) => _painterFor(_key, span);

  static TextPainter _painterFor(_TextMotionLayoutKey key, InlineSpan span) => TextPainter(
    text: span,
    textAlign: key.textAlign,
    textDirection: key.textDirection,
    textScaler: key.textScaler,
    maxLines: key.maxLines,
    ellipsis: key.overflow == TextOverflow.ellipsis ? '…' : null,
    locale: key.locale,
    strutStyle: key.strutStyle,
    textWidthBasis: key.textWidthBasis,
    textHeightBehavior: key.textHeightBehavior,
    hyphens: key.hyphens,
  );

  bool _canAnimate(Size textSize, Size boxSize, {required bool truncated}) =>
      !truncated &&
      (_key.overflow == TextOverflow.visible || (textSize.width <= boxSize.width && textSize.height <= boxSize.height));

  bool _canBorrowNativeParagraph(RenderParagraph paragraph) {
    final text = _key.text;
    return !paragraph.debugNeedsLayout &&
        paragraph.constraints == _key.constraints &&
        text is TextSpan &&
        text.children?.isNotEmpty != true;
  }

  (Rect, double)? _nativeLineBand(
    _TextMotionNativeParagraph nativeParagraph,
    String data,
    _TextMotionLineMetrics? knownNumericMetrics,
  ) {
    if (_key.textDirection != .ltr || !_isSimpleLatinLine(data)) return null;
    final boxes = nativeParagraph.paragraph.getBoxesForRange(0, data.length, boxHeightStyle: ui.BoxHeightStyle.max);
    if (boxes.length != 1) return null;
    final band = boxes.single.toRect().shift(nativeParagraph.offset);
    final metrics = knownNumericMetrics ?? _numericMetrics(_key.text.style);
    _measuredNumericMetrics = metrics;
    if ((metrics.top - band.top).abs() > 0.01 || (metrics.bottom - band.bottom).abs() > 0.01) return null;
    return (band, metrics.baseline);
  }

  static bool _isSimpleLatinLine(String data) {
    if (data.isEmpty ||
        data.startsWith(' ') ||
        data.endsWith(' ') ||
        data.startsWith('\u00a0') ||
        data.endsWith('\u00a0')) {
      return false;
    }
    for (var index = 0; index < data.length; index++) {
      final code = data.codeUnitAt(index);
      if ((code < 0x20 || code > 0x7e) && code != 0xa0) return false;
    }
    return true;
  }

  _TextMotionLineMetrics _numericMetrics(TextStyle? style) {
    final key = (
      style: style,
      textScaler: _key.textScaler,
      locale: _key.locale,
      strutStyle: _key.strutStyle,
      heightBehavior: _key.textHeightBehavior,
    );
    final cached = _lastNumericMetrics;
    if (cached != null && cached.$1 == key) return cached.$2;

    // Alternating styles can otherwise shape a temporary paragraph for each
    // source label in the same update. Keep the last three measured styles.
    final previous = _previousNumericMetrics;
    if (previous != null && previous.$1 == key) {
      _previousNumericMetrics = cached;
      _lastNumericMetrics = previous;
      return previous.$2;
    }
    final oldest = _oldestNumericMetrics;
    if (oldest != null && oldest.$1 == key) {
      _oldestNumericMetrics = previous;
      _previousNumericMetrics = cached;
      _lastNumericMetrics = oldest;
      return oldest.$2;
    }

    final painter = _newPainter(TextSpan(text: '0', style: style))..layout();
    try {
      final line = painter.computeLineMetrics().single;
      final metrics = (top: line.baseline - line.ascent, bottom: line.baseline + line.descent, baseline: line.baseline);
      _oldestNumericMetrics = previous;
      _previousNumericMetrics = cached;
      _lastNumericMetrics = (key, metrics);
      return metrics;
    } finally {
      painter.dispose();
    }
  }

  double get numberFade => fontSize * 0.15;

  void prepareTextureAt(double pixelRatio) {
    if (_preparedGlyphs != null) return;
    final textures = _textures ??= {};
    if (textures.containsKey(pixelRatio)) return;
    _prepareTextureRegion(textures, pixelRatio, _TextMotionTexture.measure(this, pixelRatio));
  }

  void prepareDepartureAtlas(double pixelRatio, Rect coverage) {
    if (_preparedGlyphs != null) return;
    if (_owners != 1 || (_textures?.containsKey(pixelRatio) ?? false) || _departureAtlas != null) {
      prepareTextureAt(pixelRatio);
      return;
    }
    final full = _TextMotionTexture.measure(this, pixelRatio);
    final region = _TextMotionTexture.measureBounds(coverage, pixelRatio);
    if (full == null || region == null || region.width * region.height >= full.width * full.height * 0.7) {
      _prepareTextureRegion(_textures ??= {}, pixelRatio, full);
      return;
    }
    final textures = <double, _TextMotionTextureEntry?>{};
    _departureAtlas = (coverage: coverage, pixelRatio: pixelRatio, textures: textures);
    _prepareTextureRegion(textures, pixelRatio, region);
  }

  void _prepareTextureRegion(
    Map<double, _TextMotionTextureEntry?> textures,
    double pixelRatio,
    _TextMotionAtlasRegion? region,
  ) {
    textures[pixelRatio] = null;
    if (region == null) return;
    if (_TextMotionAtlasBatch.fitsPage(region)) {
      _TextMotionAtlasBatch.enqueue(this, textures, pixelRatio, region);
    } else {
      _prepareIndividualTexture(textures, pixelRatio, region);
    }
  }

  _TextMotionTexture? textureAt(double pixelRatio) {
    final entry = _textures?[pixelRatio];
    return entry is _TextMotionTexture ? entry : null;
  }

  Map<double, _TextMotionTextureEntry?>? _departureTexturesFor(double pixelRatio, Rect clip) {
    final atlas = _departureAtlas;
    if (atlas == null || atlas.pixelRatio != pixelRatio) return null;
    final coverage = atlas.coverage;
    if (clip.left < coverage.left ||
        clip.right > coverage.right ||
        clip.top < coverage.top ||
        clip.bottom > coverage.bottom) {
      return null;
    }
    return atlas.textures;
  }

  _TextMotionTexture? departureTextureAt(double pixelRatio, Rect clip) {
    final entry = _departureTexturesFor(pixelRatio, clip)?[pixelRatio];
    return entry is _TextMotionTexture ? entry : null;
  }

  bool hasPreparedDepartureTexture(double pixelRatio, Rect clip) {
    final textures = _departureTexturesFor(pixelRatio, clip);
    if (textures == null) return false;
    return textures[pixelRatio] != null || _TextMotionAtlasBatch.hasQueuedTexture(textures, pixelRatio);
  }

  bool hasPendingTextureForDeparture(double pixelRatio) {
    final entry = _departureAtlas?.textures[pixelRatio];
    if (entry is _TextMotionTexture || textureAt(pixelRatio) != null) return false;
    return entry == _PendingTextMotionTexture.rasterizing || hasPendingTexture(pixelRatio);
  }

  bool ownsTextureMap(Map<double, _TextMotionTextureEntry?> textures) =>
      identical(_textures, textures) || identical(_departureAtlas?.textures, textures);

  bool hasPendingTexture(double pixelRatio) => _textures?[pixelRatio] == _PendingTextMotionTexture.rasterizing;

  void _prepareIndividualTexture(
    Map<double, _TextMotionTextureEntry?> textures,
    double pixelRatio,
    _TextMotionAtlasRegion region,
  ) {
    final request = _TextMotionTexture.prepare(this, pixelRatio, region);
    if (request == null) return;
    if (_TextMotionAtlasBatch.usesDeferredImages) {
      _publishTexture(textures, pixelRatio, _TextMotionTexture.rasterizeSync(request));
    } else {
      textures[pixelRatio] = _PendingTextMotionTexture.rasterizing;
      unawaited(_loadTexture(textures, pixelRatio, request));
    }
  }

  Future<void> _loadTexture(
    Map<double, _TextMotionTextureEntry?> textures,
    double pixelRatio,
    _TextMotionAtlasRequest request,
  ) async {
    final texture = await _TextMotionTexture.rasterize(request);
    if (!ownsTextureMap(textures)) {
      texture?.dispose();
      return;
    }
    _publishTexture(textures, pixelRatio, texture);
  }

  void _publishTexture(Map<double, _TextMotionTextureEntry?> textures, double pixelRatio, _TextMotionTexture? texture) {
    textures[pixelRatio] = texture;
    if (texture != null && identical(_textures, textures) && _departureAtlas?.pixelRatio == pixelRatio) {
      _releaseDepartureAtlas();
    }
  }

  void _releaseDepartureAtlas() {
    final atlas = _departureAtlas;
    if (atlas == null) return;
    _departureAtlas = null;
    _disposeTextures(atlas.textures);
  }

  ui.Picture get picture {
    final cached = _picture;
    if (cached != null) return cached;
    final recorder = ui.PictureRecorder();
    (_painter ??= _newPainter(_key.text)
          ..layout(minWidth: _key.constraints.minWidth, maxWidth: _key.constraints.maxWidth))
        .paint(Canvas(recorder), Offset.zero);
    return _picture = recorder.endRecording();
  }

  bool matchesParagraph(RenderParagraph paragraph) =>
      _key.fontGeneration == _fontGeneration &&
      _key.text.style == paragraph.text.style &&
      _key.textScaler == paragraph.textScaler &&
      _key.textDirection == paragraph.textDirection &&
      _key.locale == paragraph.locale &&
      _key.textAlign == paragraph.textAlign &&
      _key.maxLines == paragraph.maxLines &&
      _key.strutStyle == paragraph.strutStyle &&
      _key.textWidthBasis == paragraph.textWidthBasis &&
      _key.textHeightBehavior == paragraph.textHeightBehavior &&
      _key.hyphens == paragraph.hyphens &&
      _key.softWrap == paragraph.softWrap &&
      _key.overflow == paragraph.overflow;

  void _addWordGlyphs(
    _TextMotionWord word,
    int wordIndex, {
    List<ui.LineMetrics>? lines,
    _TextMotionNativeParagraph? nativeParagraph,
    (Rect, double)? nativeBand,
    (double, double)? nativeEdges,
  }) {
    final units = word.units;
    final numeric = word.numeric;
    final offset = nativeParagraph?.offset ?? Offset.zero;
    final joined = nativeBand == null && !numeric && _joinedScript.hasMatch(word.text);
    for (var first = 0; first < units.length;) {
      var last = first;
      final start = units[first].start;
      if (joined) {
        final position = TextPosition(offset: start);
        final line = nativeParagraph?.paragraph.getLineBoundary(position) ?? _painter!.getLineBoundary(position);
        while (last + 1 < units.length && units[last + 1].end <= line.end) {
          last++;
        }
      }
      var boxes = _selectionBoxes(start, units[last].end, nativeParagraph);
      if (!joined) {
        // A partial glyph selection can be empty when several characters form one glyph.
        while (last + 1 < units.length && boxes.isEmpty) {
          boxes = _selectionBoxes(start, units[++last].end, nativeParagraph);
        }
      }

      if (boxes.isNotEmpty) {
        final unit = _mergeUnits(units, first, last);
        final kind = numeric
            ? _isDigit(unit.text)
                  ? _TextMotionKind.digit
                  : _TextMotionKind.symbol
            : _TextMotionKind.text;
        for (final box in boxes) {
          final left = box.left + offset.dx;
          final right = box.right + offset.dx;
          final inkTop = box.top + offset.dy;
          final inkBottom = box.bottom + offset.dy;
          if (left >= right || inkTop >= inkBottom) continue;

          final double lineLeft;
          final double lineRight;
          final double top;
          final double bottom;
          final double baseline;
          if (nativeBand case (final line, final nativeBaseline)) {
            lineLeft = line.left;
            lineRight = line.right;
            top = line.top;
            bottom = line.bottom;
            baseline = nativeBaseline;
          } else {
            final line = _lineAt(inkTop + (inkBottom - inkTop) / 2, offset.dy, lines!);
            baseline = line.baseline + offset.dy;
            lineLeft = line.left + offset.dx;
            lineRight = lineLeft + line.width;
            top = math.min(inkTop, baseline - line.ascent);
            bottom = math.max(inkBottom, baseline + line.descent);
          }

          final bounds = Rect.fromLTRB(left, top, right, bottom);
          // Preserve ink overhang at the edges of the line. Interior slices
          // use the same rectangle for geometry and painting.
          final extendLeft = (left - lineLeft).abs() < 1;
          final extendRight = (right - lineRight).abs() < 1;
          final paintBounds = extendLeft || extendRight
              ? Rect.fromLTRB(
                  extendLeft ? left - bounds.height * 0.25 : left,
                  top,
                  extendRight ? right + bounds.height * 0.25 : right,
                  bottom,
                )
              : bounds;
          var rollBounds = Rect.zero;
          if (numeric) {
            final (rollTop, rollBottom) = nativeEdges ?? _numberRollEdges(top, bottom, baseline);
            rollBounds = Rect.fromLTRB(left - 1, rollTop, right + 1, rollBottom);
          }
          glyphs.add(_TextMotionGlyph(unit, wordIndex, bounds, paintBounds, kind, rollBounds));
        }
      }
      first = last + 1;
    }
  }

  (double, double) _numberRollEdges(double top, double bottom, double baseline) {
    // The mask clears the height of Inter's numeric glyphs and common currency signs.
    final topPadding = math.max(0, (numberFade + fontSize * 0.81 - (baseline - top)).ceil());
    final bottomPadding = math.max(0, (numberFade + fontSize * 0.20 - (bottom - baseline)).ceil());
    return (top - topPadding, bottom + bottomPadding);
  }

  static ui.LineMetrics _lineAt(double center, double offset, List<ui.LineMetrics> lines) {
    var first = 0;
    var last = lines.length - 1;
    while (first < last) {
      final middle = (first + last) >> 1;
      final line = lines[middle];
      if (center <= line.baseline + offset + line.descent) {
        last = middle;
      } else {
        first = middle + 1;
      }
    }
    return lines[first];
  }

  static _TextMotionUnit _mergeUnits(List<_TextMotionUnit> units, int first, int last) => first == last
      ? units[first]
      : (
          text: units.getRange(first, last + 1).map((unit) => unit.text).join(),
          start: units[first].start,
          end: units[last].end,
        );

  List<ui.TextBox> _selectionBoxes(int start, int end, _TextMotionNativeParagraph? nativeParagraph) =>
      nativeParagraph?.paragraph.getBoxesForRange(start, end) ??
      _painter!.getBoxesForSelection(TextSelection(baseOffset: start, extentOffset: end));

  void retire({required bool afterInterruption}) {
    if (_preparedGlyphs != null ||
        !afterInterruption ||
        !_wasDestination ||
        _owners != 1 ||
        _key.fontGeneration != _fontGeneration) {
      dispose();
      return;
    }
    // A hash only decides what enters the cache. Geometry lookups still
    // compare the complete layout key.
    final repeated = _retiredTextHashes.remove(_dataHash);
    _retiredTextHashes.add(_dataHash);
    if (_retiredTextHashes.length > _maxActiveRecentLayouts) {
      _retiredTextHashes.remove(_retiredTextHashes.first);
    }
    dispose(keepGeometry: repeated);
  }

  void dispose({bool keepGeometry = false}) {
    if (--_owners != 0) return;
    final prepared = _preparedGlyphs;
    if (prepared != null) {
      prepared.dispose();
      _painter?.dispose();
      _disposePicture();
      return;
    }
    _active.remove(_key);
    final animating = _active.isNotEmpty;
    if (!animating) {
      _clearIdleNumericMetrics();
      _retiredTextHashes.clear();
    }

    final textures = _textures;
    _textures = null;
    _disposeTextures(textures);
    _releaseDepartureAtlas();
    _painter?.dispose();
    _painter = null;

    final byteLimit = animating ? _maxActiveRecentBytes : _maxRecentBytes;
    final layoutLimit = animating ? _maxActiveRecentLayouts : _maxRecentLayouts;
    if (!keepGeometry || _key.fontGeneration != _fontGeneration || _picture == null || _retainedBytes > byteLimit) {
      _disposePicture();
      if (!animating) _trimRecent(layoutLimit, byteLimit);
      return;
    }
    _trimRecent(layoutLimit - 1, byteLimit - _retainedBytes);
    _recent[_key] = this;
    _recentBytes += _retainedBytes;
  }

  static void _trimRecent(int layoutLimit, int byteLimit) {
    while (_recent.length > layoutLimit || _recentBytes > byteLimit) {
      final oldest = _recent.remove(_recent.keys.first)!;
      _recentBytes -= oldest._retainedBytes;
      oldest._disposePicture();
    }
  }

  void _disposeTextures(Map<double, _TextMotionTextureEntry?>? textures) {
    if (textures == null) return;
    _TextMotionAtlasBatch.cancel(textures);
    for (final entry in textures.values) {
      if (entry is _TextMotionTexture) entry.dispose();
    }
    textures.clear();
  }

  void _disposePicture() {
    _picture?.dispose();
    _picture = null;
  }
}

typedef _TextMotionNativeParagraph = ({ui.Paragraph paragraph, Offset offset});

// Borrow the shaped paragraph only during synchronous geometry capture. If
// Flutter paints clipping, selection, or debug decorations, use TextPainter.
class _TextMotionParagraphCanvas implements Canvas {
  _TextMotionNativeParagraph? _drawnParagraph;

  static _TextMotionNativeParagraph? borrow(RenderParagraph paragraph) {
    final canvas = _TextMotionParagraphCanvas();
    try {
      paragraph.paint(_TextMotionRecordingContext(canvas), Offset.zero);
    } on _UnsupportedTextMotionParagraphPaint {
      return null;
    }
    return canvas._drawnParagraph;
  }

  @override
  void drawParagraph(ui.Paragraph paragraph, Offset offset) {
    if (_drawnParagraph != null) throw const _UnsupportedTextMotionParagraphPaint();
    _drawnParagraph = (paragraph: paragraph, offset: offset);
  }

  @override
  Object? noSuchMethod(Invocation invocation) => throw const _UnsupportedTextMotionParagraphPaint();
}

class _UnsupportedTextMotionParagraphPaint implements Exception {
  const new();
}

class _TextMotionRecordingContext extends PaintingContext {
  new(this.canvas) : super(ContainerLayer(), Rect.zero);

  @override
  final Canvas canvas;
}

typedef _TextMotionLineStyle = ({
  TextStyle? style,
  TextScaler textScaler,
  Locale? locale,
  StrutStyle? strutStyle,
  TextHeightBehavior? heightBehavior,
});

typedef _TextMotionLineMetrics = ({double top, double bottom, double baseline});

typedef _TextMotionLayoutKey = ({
  int fontGeneration,
  InlineSpan text,
  TextAlign textAlign,
  ui.TextDirection textDirection,
  TextScaler textScaler,
  int? maxLines,
  Locale? locale,
  StrutStyle? strutStyle,
  TextWidthBasis textWidthBasis,
  TextHeightBehavior? textHeightBehavior,
  ui.Hyphens hyphens,
  TextOverflow overflow,
  bool softWrap,
  BoxConstraints constraints,
});
