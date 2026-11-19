part of '../mateo_text.dart';

typedef _NumeralAffixes = (String, String);
typedef _NumeralGeometryKey = (String, String, int, int, int);

extension on _PreparedNumeralTemplate {
  _NumeralAffixes get affixes => (prefix, suffix);
  _NumeralGeometryKey get geometryKey => (prefix, suffix, numberEnd, _separatorOffset, _decimalUnit);
}

class _PreparedNumeralBank {
  new(this.config, this.pixelRatio, this.fontGeneration);

  static _PreparedNumeralBank? _current;
  static List<_PreparedNumeralBank>? _additional;
  static Duration? _lastPublicationFrame;
  static bool _observingSemantics = false;
  static const _maximumBanks = 3;

  static void invalidateBanks() {
    _current?._invalidate();
    final other = _additional;
    if (other != null) {
      for (final bank in other) {
        bank._invalidate();
      }
    }
    _current = null;
    _additional = null;
  }

  static void _clearForSemantics() {
    if (SemanticsBinding.instance.semanticsEnabled) invalidateBanks();
  }

  static void _retireIdleBank(_PreparedNumeralBank bank) {
    final other = _additional;
    if (other == null) return;
    if (identical(_current, bank) && other.isNotEmpty) {
      _current = other.removeAt(0);
    } else {
      other.remove(bank);
    }
    if (other.isEmpty) _additional = null;
  }

  bool _matchesConfiguration(_PreparedNumeralConfig candidate, double ratio, int generation) =>
      pixelRatio == ratio && fontGeneration == generation && config == candidate;

  // A package-family name can be replaced by a dynamic font loader.
  static int? _fontProbeGeneration;
  static bool? _regularFontMatches;
  static bool? _mediumFontMatches;

  static bool _usesBundledFont(int generation, FontWeight weight) {
    if (_fontProbeGeneration != generation) {
      _fontProbeGeneration = generation;
      _regularFontMatches = null;
      _mediumFontMatches = null;
    }
    return switch (weight) {
      FontWeight.w400 => _regularFontMatches ??= _probeBundledFont(weight),
      FontWeight.w500 => _mediumFontMatches ??= _probeBundledFont(weight),
      _ => false,
    };
  }

  static bool _probeBundledFont(FontWeight weight) {
    const probe =
        '0123456789\n9876543210\n102 103 104 610 939 109 494 400\n'
        '3,1254 22,13560 1,483621\nRa 061 A Wa TI ft ffi\n'
        '034001405 017103581 596001073\nExtra R\$ 1 item 011';
    final widths = weight == FontWeight.w500
        ? const [84.12338, 84.10287, 225.41867, 172.26172, 130.32697, 229.76636, 122.86316]
        : const [82.81055, 82.79004, 223.27539, 169.66797, 129.52734, 226.14648, 121.95996];
    final painter = TextPainter(
      text: TextSpan(
        text: probe,
        style: TextStyle(fontFamily: MateoTypography.interfaceFontFamily, fontSize: 14, fontWeight: weight),
      ),
      textDirection: .ltr,
    )..layout();
    try {
      final metrics = painter.computeLineMetrics();
      bool matches(List<double> expected) {
        if (metrics.length != expected.length) return false;
        for (var line = 0; line < expected.length; line++) {
          if (!((metrics[line].width - expected[line]).abs() < .015)) return false;
        }
        return true;
      }

      // Android's font engine resolves slightly different advances for the
      // same medium variation. Accept the full measured fingerprint there too.
      return matches(widths) ||
          (weight == FontWeight.w500 &&
              matches(const [84.12988, 84.10938, 225.46289, 172.26343, 130.34552, 229.82422, 122.88312]));
    } finally {
      painter.dispose();
    }
  }

  final _PreparedNumeralConfig config;
  final double pixelRatio;
  final int fontGeneration;
  final _pairs = <(int, int), _NumeralAdvance>{};
  final _last = <int, double>{};
  static const _maximumAffixes = 48;
  static const _maximumAffixLength = 48;
  static const _maximumCalibratedUnits = 1024;
  static const _maximumPages = 2;
  final _templates = <_NumeralGeometryKey, _NumeralTemplate>{};
  final _anchors = <(String, int), double>{};
  final _inkByAffixes = <_NumeralAffixes, _NumeralInkPage>{};
  final _queuedInk = <_NumeralAffixes>{};
  final _inkSources = <_NumeralAffixes, _NumeralAffixInk>{};
  final _attemptedInk = <_NumeralAffixes>{};
  int _calibratedUnits = 0;
  int _inkPageCount = 0;
  int _waitingForInkPixels = 0;
  bool _retriedFirstPage = false;
  int _motionUsers = 0;
  Duration? _inkQueuedAt;

  bool _valid = true;
  bool _collectingCachedInk = false;

  static bool _eligible(_TextMotionLayout layout, _PreparedNumeralConfig config, double pixelRatio) {
    final key = layout._key;
    return layout.canAnimate &&
        key.fontGeneration == _TextMotionLayout._fontGeneration &&
        key.text.style == config.style &&
        key.textDirection == TextDirection.ltr &&
        key.textAlign == TextAlign.start &&
        key.textScaler == TextScaler.noScaling &&
        key.locale == config.locale &&
        key.textHeightBehavior == null &&
        key.hyphens == ui.Hyphens.manual &&
        key.textWidthBasis == TextWidthBasis.parent &&
        key.constraints.minWidth == 0 &&
        key.constraints.minHeight == 0 &&
        key.constraints.maxHeight >= layout.size.height + .25 &&
        key.overflow == TextOverflow.clip &&
        key.maxLines == null &&
        key.softWrap &&
        key.strutStyle == null &&
        layout.glyphs.isNotEmpty &&
        pixelRatio >= 1 &&
        pixelRatio <= 4;
  }

  static _PreparedNumeralBank? findTrainingBank(
    _PreparedNumeralConfig config,
    double ratio,
    int generation, {
    bool requireEmpty = true,
  }) {
    final bank = _current;
    if (bank != null && bank._acceptsColdTraining(config, ratio, generation, requireEmpty)) return bank;
    final additional = _additional;
    if (additional == null) return null;
    for (final bank in additional) {
      if (bank._acceptsColdTraining(config, ratio, generation, requireEmpty)) return bank;
    }
    return null;
  }

  bool _acceptsColdTraining(_PreparedNumeralConfig config, double ratio, int generation, bool requireEmpty) =>
      _valid &&
      _motionUsers > 0 &&
      (_inkPageCount == 0 || !requireEmpty) &&
      _matchesConfiguration(config, ratio, generation);

  static _PreparedNumeralBank? forLayout(_TextMotionLayout layout, _PreparedNumeralConfig config, double pixelRatio) {
    if (!_eligible(layout, config, pixelRatio) ||
        !_usesBundledFont(layout._key.fontGeneration, config.style.fontWeight ?? FontWeight.w400)) {
      return null;
    }
    final generation = layout._key.fontGeneration;
    final current = _current;
    if (current == null) return _current = _PreparedNumeralBank(config, pixelRatio, generation);
    if (current._matchesConfiguration(config, pixelRatio, generation)) return current._valid ? current : null;
    final additional = _additional;
    if (additional != null) {
      for (final bank in additional) {
        if (bank._matchesConfiguration(config, pixelRatio, generation)) return bank._valid ? bank : null;
      }
    }
    if (current._motionUsers == 0) return _current = _PreparedNumeralBank(config, pixelRatio, generation);
    if (additional != null) {
      for (var slot = 0; slot < additional.length; slot++) {
        if (additional[slot]._motionUsers == 0) {
          return additional[slot] = _PreparedNumeralBank(config, pixelRatio, generation);
        }
      }
      if (additional.length >= _maximumBanks - 1) return null;
    }
    final created = _PreparedNumeralBank(config, pixelRatio, generation);
    (_additional ??= []).add(created);
    if (!_observingSemantics) {
      SemanticsBinding.instance.addSemanticsEnabledListener(_clearForSemantics);
      _observingSemantics = true;
    }
    return created;
  }

  bool observe(_TextMotionLayout layout, _PreparedNumeralTemplate template) {
    if (!_valid || layout._preparedGlyphs != null || !_eligible(layout, config, pixelRatio)) return false;
    final text = (layout._key.text as TextSpan).text!;
    if (!template._matches(text)) return false;
    return _observeNative(layout, text, template);
  }

  _TextMotionLayout? prepare(String text, _PreparedNumeralTemplate template, _TextMotionLayout reference) =>
      _valid ? _prepare(text, template, reference) : null;

  void _invalidate() {
    _valid = false;
    _releaseInk();
  }

  bool get _hasInkWork =>
      _valid &&
      _motionUsers > 0 &&
      _queuedInk.isNotEmpty &&
      _inkPageCount < _maximumPages &&
      (_waitingForInkPixels == 0 || _TextMotionTexture._canReservePixels(_waitingForInkPixels));

  bool _canPublishAt(Duration frame) {
    final viewRatio = config.view?.devicePixelRatio;
    if (!_hasInkWork ||
        _inkQueuedAt == frame ||
        fontGeneration != _TextMotionLayout._fontGeneration ||
        (viewRatio != null && viewRatio != pixelRatio)) {
      return false;
    }
    if (_collectingCachedInk && _inkPageCount == 0 && _textMotionClock.hasPendingNativeTraining(this)) {
      final queuedAt = _inkQueuedAt ??= frame;
      if (frame - queuedAt < const Duration(milliseconds: 150)) return false;
    }
    return true;
  }

  static void flushInk() {
    final primary = _current;
    if (primary == null || !_TextMotionAtlasBatch.usesDeferredImages || SemanticsBinding.instance.semanticsEnabled) {
      return;
    }
    final additional = _additional;
    if (!primary._hasInkWork && (additional == null || !additional.any((b) => b._hasInkWork))) return;
    final frame = SchedulerBinding.instance.currentFrameTimeStamp;
    if (_lastPublicationFrame == frame) return;
    var next = primary._canPublishAt(frame) ? primary : null;
    if (additional != null) {
      for (final bank in additional) {
        if (!bank._canPublishAt(frame)) continue;
        final old = next;
        if (old == null ||
            (bank._inkPageCount == 0 && old._inkPageCount > 0) ||
            (bank._inkPageCount == old._inkPageCount &&
                (bank._inkQueuedAt ?? Duration.zero) < (old._inkQueuedAt ?? Duration.zero))) {
          next = bank;
        }
      }
    }
    if (next == null) return;
    _lastPublicationFrame = frame;
    next
      .._waitingForInkPixels = 0
      .._publishInk();
  }

  void _publishInk() {
    final sheet = _NumeralInkSheet(config, pixelRatio);
    try {
      final decimalSeparator = _RenderMateoTextMotion._decimalSeparator(config.locale);
      if (!sheet.place([
        ..._NumeralInkPage.digits,
        if (decimalSeparator == ',' || decimalSeparator == '.') (decimalSeparator, _NumeralInkPage.phases),
      ])) {
        _attemptedInk.addAll(_queuedInk);
        _clearInkSources();
        return;
      }
      final base = sheet._shelf.position;
      final basePieceCount = sheet._tiles.length;
      var suffixPhases = _NumeralInkPage.phases;
      var placement = _placeAffixes(sheet, suffixPhases);
      if (_inkPageCount == 0 && placement.packed.isNotEmpty && placement.packed.length < _queuedInk.length) {
        const fewerPhases = 2;
        final basePieces = sheet._tiles.keys.take(basePieceCount).toSet();
        final alternative = _planAffixes(base, basePieces, _queuedInk, fewerPhases);
        if (alternative.batch.packed.length > placement.packed.length &&
            alternative.pixels <= sheet._shelf.pixels &&
            (alternative.batch.packed.length == _queuedInk.length ||
                _improvesAffixPacking(base, basePieces, sheet._shelf.pixels, placement, alternative))) {
          suffixPhases = fewerPhases;
          sheet._restoreBase(base, basePieceCount);
          placement = _placeAffixes(sheet, suffixPhases);
        }
      }
      final packed = placement.packed;
      _attemptedInk.addAll(placement.rejected);
      final result = packed.isEmpty ? null : sheet.finish(suffixPhases, packed);
      final blockedPixels = result?.blockedPixels ?? 0;
      if (blockedPixels > 0 && _inkPageCount == 0 && !_retriedFirstPage) {
        // Ordinary transitions can briefly occupy the global texture pool.
        // Retry one first page only when its known footprint is free.
        _retriedFirstPage = true;
        _waitingForInkPixels = blockedPixels;
        return;
      }
      _attemptedInk.addAll(packed);
      final page = result?.page;
      for (final affixes in _attemptedInk) {
        if (_queuedInk.remove(affixes)) _inkSources.remove(affixes)?.dispose();
      }
      if (packed.isEmpty) return;
      if (page == null) {
        // The ordinary atlas already owns the available memory this frame.
        // Retry only when the next active cohort begins.
        _attemptedInk.addAll(_queuedInk);
        _clearInkSources();
        return;
      }
      _inkPageCount++;
      for (final affixes in packed) {
        _inkByAffixes[affixes] = page;
      }
      if (_inkPageCount == _maximumPages) _clearInkSources();
    } finally {
      sheet.dispose();
    }
  }

  _NumeralInkBatch _placeAffixes(_NumeralInkSheet sheet, int suffixPhases) =>
      _packAffixes(_queuedInk, (affixes) => sheet.place(_pieces(affixes, suffixPhases), ink: _inkSources[affixes]));

  _NumeralInkPlan _planAffixes(
    _NumeralInkPosition base,
    Set<_NumeralInkPiece> basePieces,
    Iterable<_NumeralAffixes> affixes,
    int suffixPhases,
  ) {
    final shelf = _NumeralInkShelf()..restore(base);
    final placed = Set<_NumeralInkPiece>.of(basePieces);
    final batch = _packAffixes(affixes, (affixes) {
      final origin = shelf.position;
      final added = <_NumeralInkPiece>[];
      final ink = _inkSources[affixes];
      for (final piece in _pieces(affixes, suffixPhases)) {
        if (placed.contains(piece)) continue;
        final extent = _borrowedInkExtent(piece, pixelRatio, ink);
        if (extent == null || !shelf.place(extent.$3 - extent.$1, extent.$4 - extent.$2, piece.$2)) {
          shelf.restore(origin);
          placed.removeAll(added);
          return false;
        }
        placed.add(piece);
        added.add(piece);
      }
      return true;
    });
    return (batch: batch, pixels: batch.packed.isEmpty ? 0 : shelf.pixels);
  }

  bool _improvesAffixPacking(
    _NumeralInkPosition base,
    Set<_NumeralInkPiece> basePieces,
    int originalPixels,
    _NumeralInkBatch original,
    _NumeralInkPlan alternative,
  ) {
    // Compare admissions over the entire page budget. A narrower first page
    // can change shelf breaks, so require it to preserve each original label.
    _NumeralInkPlan nextPage(_NumeralInkBatch first) {
      final attempted = {...first.packed, ...first.rejected};
      return _planAffixes(
        base,
        basePieces,
        _queuedInk.where((affixes) => !attempted.contains(affixes)),
        _NumeralInkPage.phases,
      );
    }

    final originalNext = nextPage(original);
    final alternativeNext = nextPage(alternative.batch);
    final originalLabels = {...original.packed, ...originalNext.batch.packed};
    final alternativeLabels = {...alternative.batch.packed, ...alternativeNext.batch.packed};
    return alternative.pixels + alternativeNext.pixels <= originalPixels + originalNext.pixels &&
        alternativeLabels.containsAll(originalLabels) &&
        (alternativeLabels.length > originalLabels.length ||
            (originalNext.batch.packed.isNotEmpty && alternativeNext.batch.packed.isEmpty));
  }

  static List<_NumeralInkPiece> _pieces(_NumeralAffixes affixes, int suffixPhases) {
    final (prefix, suffix) = affixes;
    return [if (prefix.isNotEmpty) (prefix, 1), if (suffix.isNotEmpty) (suffix, suffixPhases)];
  }

  static _NumeralInkBatch _packAffixes(Iterable<_NumeralAffixes> affixes, bool Function(_NumeralAffixes) place) {
    final packed = <_NumeralAffixes>[];
    final rejected = <_NumeralAffixes>[];
    for (final label in affixes) {
      if (place(label)) {
        packed.add(label);
      } else if (packed.isEmpty) {
        // This label also cannot fit in a later empty page at these settings.
        rejected.add(label);
      }
    }
    return (packed: packed, rejected: rejected);
  }

  void _clearInkSources() {
    for (final ink in _inkSources.values) {
      ink.dispose();
    }
    _inkSources.clear();
    _queuedInk.clear();
  }

  void _releaseInk() {
    _collectingCachedInk = false;
    for (final ink in _inkByAffixes.values.toSet()) {
      ink.dispose();
    }
    _inkByAffixes.clear();
    _clearInkSources();
    _attemptedInk.clear();
    _inkPageCount = 0;
    _waitingForInkPixels = 0;
    _retriedFirstPage = false;
    _inkQueuedAt = null;
  }

  bool _observeNative(_TextMotionLayout layout, String text, _PreparedNumeralTemplate parts) {
    const tolerance = .001;
    final templateKey = parts.geometryKey;
    final cached = _templates[templateKey];
    final affixUnits = parts.prefix.length + parts.suffix.length;
    if (parts.prefix.length > _maximumAffixLength ||
        parts.suffix.length > _maximumAffixLength ||
        (cached == null &&
            (_templates.length >= _maximumAffixes || _calibratedUnits + affixUnits > _maximumCalibratedUnits))) {
      return false;
    }
    final start = parts.numberStart;
    final end = parts.numberEnd;
    final bounds = layout.glyphs.first.bounds;
    final units = <_TextMotionGlyph>[];
    final before = <_TextMotionGlyph>[];
    final after = <_TextMotionGlyph>[];
    for (final glyph in layout.glyphs) {
      if (glyph.bounds.top != bounds.top || glyph.bounds.bottom != bounds.bottom) return false;
      if (glyph.unit.start < start) {
        before.add(glyph);
      } else if (glyph.unit.start >= end) {
        after.add(glyph);
      } else {
        units.add(glyph);
      }
    }
    if (units.length != end - start ||
        units.first.wordIndex != parts.wordIndex ||
        layout.size.width >= layout._key.constraints.maxWidth - .25) {
      return false;
    }
    final anchorKey = (parts.prefix, text.codeUnitAt(start));
    final left = units.first.bounds.left;
    if (((_anchors[anchorKey] ?? left) - left).abs() > tolerance) {
      _invalidate();
      return false;
    }
    _anchors[anchorKey] = left;
    for (var index = 0; index < units.length - 1; index++) {
      final advance = _NumeralAdvance(
        units[index].bounds.width,
        units[index + 1].bounds.left - units[index].bounds.left,
      );
      final key = (text.codeUnitAt(start + index), text.codeUnitAt(start + index + 1));
      final known = _pairs[key];
      if (known != null &&
          ((advance.boxWidth - known.boxWidth).abs() > tolerance || (advance.step - known.step).abs() > tolerance)) {
        _invalidate();
        return false;
      }
      _pairs[key] = advance;
    }
    final finalCode = text.codeUnitAt(end - 1);
    final lastBounds = units.last.bounds;
    if (((_last[finalCode] ?? lastBounds.width) - lastBounds.width).abs() > tolerance) {
      _invalidate();
      return false;
    }
    _last[finalCode] = lastBounds.width;
    final finalRight = lastBounds.right;
    final tailWidth = layout.size.width - finalRight;
    if (cached != null && (cached.tailWidth - tailWidth).abs() > tolerance) {
      _invalidate();
      return false;
    }
    if (cached == null) _calibratedUnits += affixUnits;
    _templates[templateKey] ??= _NumeralTemplate(
      before: before,
      after: after,
      wordIndex: units.first.wordIndex,
      numericRight: finalRight,
      tailWidth: tailWidth,
      height: layout.size.height,
      lineTop: bounds.top,
      lineBottom: bounds.bottom,
      rollTop: units.first.rollBounds.top,
      rollBottom: units.first.rollBounds.bottom,
    );
    return true;
  }

  void queueInk(_PreparedNumeralTemplate template, _TextMotionLayout reference) {
    final affixes = template.affixes;
    if (_inkPageCount == _maximumPages ||
        _waitingForInkPixels > 0 ||
        _attemptedInk.contains(affixes) ||
        _queuedInk.contains(affixes)) {
      return;
    }
    if (template.prefix.isNotEmpty || template.suffix.isNotEmpty) {
      final ink = _NumeralAffixInk.borrow(reference, template, pixelRatio);
      if (ink == null) return;
      _inkSources[affixes] = ink;
    }
    if (_queuedInk.add(affixes) && _queuedInk.length == 1) {
      final scheduler = SchedulerBinding.instance;
      _inkQueuedAt = scheduler.schedulerPhase == .idle ? null : scheduler.currentFrameTimeStamp;
    }
  }

  void _forgetAffixes() {
    _releaseInk();
    _templates.clear();
    _anchors.clear();
    _calibratedUnits = 0;
  }

  _TextMotionLayout? _carryObservedNativeAtlas(
    _TextMotionLayout native,
    _PreparedNumeralTemplate template,
    _TextMotionLayout previous,
  ) {
    final ink = _inkByAffixes[template.affixes];
    if (ink == null || ink.page.rasterizationFailed) return null;
    final previousPage = previous._preparedGlyphs?.page;
    if (previousPage != null && !identical(ink.page, previousPage)) return null;
    final start = template.numberStart;
    final end = template.numberEnd;
    double? numberRight;
    for (final glyph in native.glyphs) {
      if (glyph.unit.end != end) continue;
      numberRight = glyph.bounds.right;
      break;
    }
    if (numberRight == null) return null;

    final prefix = (template.prefix, 1);
    final suffix = (template.suffix, ink.suffixPhases);
    var nextNumeral = start;
    for (final glyph in native.glyphs) {
      final offset = glyph.unit.start;
      if (offset >= start && offset < end) {
        if (offset != nextNumeral || glyph.unit.end != offset + 1) return null;
        nextNumeral++;
      }
      final fits = offset < start
          ? ink.covers(prefix, glyph.paintBounds)
          : offset >= end
          ? ink.covers(suffix, glyph.paintBounds.shift(Offset(-numberRight, 0)))
          : ink.covers(
              (glyph.unit.text, _NumeralInkPage.phases),
              glyph.paintBounds.shift(Offset(-glyph.bounds.left, 0)),
            );
      if (!fits) return null;
    }
    if (nextNumeral != end) return null;

    _TextMotionTexture? before;
    _TextMotionTexture? after;
    final number = <_TextMotionTexture>[];
    for (final glyph in native.glyphs) {
      final offset = glyph.unit.start;
      if (offset < start) {
        before ??= ink.forPiece(prefix, 0);
      } else if (offset >= end) {
        after ??= ink.forPiece(suffix, numberRight);
      } else {
        number.add(ink.forPiece((glyph.unit.text, _NumeralInkPage.phases), glyph.bounds.left));
      }
    }
    // Preserve the just-shaped rectangles, rolling bands and token offsets.
    // Only the raster source changes after the native observation.
    return _TextMotionLayout._prepared(
      native,
      (native._key.text as TextSpan).text!,
      native.size.width,
      native.size.height,
      native.words,
      native.glyphs,
      _PreparedGlyphTextures(ink.page, pixelRatio, start, before, number, after),
    ).._measuredNumericMetrics = native._measuredNumericMetrics;
  }

  _TextMotionLayout? _prepare(String text, _PreparedNumeralTemplate parts, _TextMotionLayout reference) {
    final template = _templates[parts.geometryKey];
    final ink = _inkByAffixes[parts.affixes];
    if (ink == null || ink.page.rasterizationFailed) {
      return null;
    }
    final referencePage = reference._preparedGlyphs?.page;
    if (referencePage != null && !identical(ink.page, referencePage)) return null;
    final left = _anchors[(parts.prefix, text.codeUnitAt(parts.numberStart))];
    if (template == null || left == null || reference.size.height != template.height) return null;
    final numberStart = parts.numberStart;
    final numberEnd = parts.numberEnd;
    final lastWidth = _last[text.codeUnitAt(numberEnd - 1)];
    if (lastWidth == null) return null;
    final boxes = <(double left, double right)>[];
    var cursor = left;
    for (var index = numberStart; index < numberEnd - 1; index++) {
      final pair = _pairs[(text.codeUnitAt(index), text.codeUnitAt(index + 1))];
      if (pair == null) return null;
      boxes.add((cursor, cursor + pair.boxWidth));
      cursor += pair.step;
    }
    final numericRight = cursor + lastWidth;
    final width = numericRight + template.tailWidth;
    if (!width.isFinite || width >= reference._key.constraints.maxWidth - .25) return null;
    boxes.add((cursor, numericRight));
    final wordIndex = template.wordIndex;
    if (wordIndex >= reference.words.length) return null;
    // Admission fixes the affix text and its offsets. Build only the changed
    // number, leaving every other word on its already segmented endpoint.
    final chars = List<_TextMotionUnit>.generate(numberEnd - numberStart, (index) {
      final offset = numberStart + index;
      return (text: text[offset], start: offset, end: offset + 1);
    }, growable: false);
    final units = List<_TextMotionWord>.of(reference.words, growable: false);
    units[wordIndex] = _TextMotionWord(text.substring(numberStart, numberEnd), chars);
    final prefixTile = (parts.prefix, 1);
    final suffixTile = (parts.suffix, ink.suffixPhases);
    final prefixClip = template.prefixClip;
    final suffixClip = template.suffixClip;
    if ((prefixClip != null && !ink.covers(prefixTile, prefixClip)) ||
        (suffixClip != null && !ink.covers(suffixTile, suffixClip))) {
      return null;
    }
    final overhang = (template.lineBottom - template.lineTop) * .25;
    for (var index = 0; index < boxes.length; index++) {
      final (left, right) = boxes[index];
      final localClip = Rect.fromLTRB(
        left < 1 ? -overhang : 0,
        template.lineTop,
        right - left + (width - right < 1 ? overhang : 0),
        template.lineBottom,
      );
      if (!ink.covers((chars[index].text, _NumeralInkPage.phases), localClip)) return null;
    }
    final afterDelta = Offset(numericRight - template.numericRight, 0);
    final beforeTexture = prefixClip == null ? null : ink.forPiece(prefixTile, 0);
    final afterTexture = suffixClip == null ? null : ink.forPiece(suffixTile, numericRight);
    final glyphs = <_TextMotionGlyph>[...template.before];
    final numberTextures = <_TextMotionTexture>[];
    for (var index = 0; index < boxes.length; index++) {
      final (left, right) = boxes[index];
      final bounds = Rect.fromLTRB(left, template.lineTop, right, template.lineBottom);
      final paintBounds = Rect.fromLTRB(
        left < 1 ? left - bounds.height * .25 : left,
        bounds.top,
        width - right < 1 ? right + bounds.height * .25 : right,
        bounds.bottom,
      );
      final unit = chars[index];
      final isDigit = _isDigit(unit.text);
      final glyph = _TextMotionGlyph(
        unit,
        template.wordIndex,
        bounds,
        paintBounds,
        isDigit ? _TextMotionKind.digit : _TextMotionKind.symbol,
        Rect.fromLTRB(left - 1, template.rollTop, right + 1, template.rollBottom),
      );
      glyphs.add(glyph);
      numberTextures.add(ink.forPiece((unit.text, _NumeralInkPage.phases), left));
    }
    if (afterTexture != null) {
      for (final glyph in template.after) {
        final shifted = _TextMotionGlyph(
          glyph.unit,
          glyph.wordIndex,
          glyph.bounds.shift(afterDelta),
          glyph.paintBounds.shift(afterDelta),
          glyph.kind,
          glyph.rollBounds,
        );
        glyphs.add(shifted);
      }
    }
    return _TextMotionLayout._prepared(
      reference,
      text,
      width,
      template.height,
      units,
      glyphs,
      _PreparedGlyphTextures(ink.page, pixelRatio, numberStart, beforeTexture, numberTextures, afterTexture),
    );
  }
}

class _NumeralAdvance {
  new(this.boxWidth, this.step);
  final double boxWidth;
  final double step;
}

class _NumeralTemplate {
  new({
    required this.before,
    required this.after,
    required this.wordIndex,
    required this.numericRight,
    required this.tailWidth,
    required this.height,
    required this.lineTop,
    required this.lineBottom,
    required this.rollTop,
    required this.rollBottom,
  });

  final List<_TextMotionGlyph> before;
  final List<_TextMotionGlyph> after;
  final int wordIndex;
  final double numericRight;
  final double tailWidth;
  final double height;
  final double lineTop;
  final double lineBottom;
  final double rollTop;
  final double rollBottom;

  late final Rect? prefixClip = _paintClip(before);
  late final Rect? suffixClip = _paintClip(after)?.shift(Offset(-numericRight, 0));

  static Rect? _paintClip(List<_TextMotionGlyph> glyphs) {
    if (glyphs.isEmpty) return null;
    var clip = glyphs.first.paintBounds;
    for (var index = 1; index < glyphs.length; index++) {
      clip = clip.expandToInclude(glyphs[index].paintBounds);
    }
    return clip;
  }
}
