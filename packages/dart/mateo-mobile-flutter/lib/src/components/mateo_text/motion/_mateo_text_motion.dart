part of '../mateo_text.dart';

class _MateoTextMotion extends SingleChildRenderObjectWidget {
  const new({required this.enabled, required Text child}) : _nativeText = child, super(child: child);

  final bool enabled;
  final Text _nativeText;
  String get _data => _nativeText.data!;

  static double _pixelRatioOf(BuildContext context) {
    // Observe metrics changes without substituting a scoped media override
    // for the pixel ratio of the actual raster surface.
    final reported = MediaQuery.maybeDevicePixelRatioOf(context);
    return View.maybeOf(context)?.devicePixelRatio ?? reported ?? 1;
  }

  _PreparedNumeralConfig? _preparedConfig(BuildContext context) {
    if (context is! _MateoTextMotionElement ||
        !enabled ||
        !_TextMotionAtlasBatch.usesDeferredImages ||
        SemanticsBinding.instance.semanticsEnabled) {
      return null;
    }
    final label = _nativeText;
    final style = label.style;
    final fontSize = style?.fontSize;
    final weight = style?.fontWeight ?? FontWeight.w400;
    if (style == null ||
        fontSize == null ||
        style.fontFamily != MateoTypography.interfaceFontFamily ||
        (fontSize != 14 && fontSize != MateoTextInterfaceFontSize.body.value) ||
        (weight != FontWeight.w400 && !(weight == FontWeight.w500 && fontSize == 14)) ||
        style.letterSpacing != fontSize * -.02 ||
        style.fontFeatures != null ||
        style.height != null ||
        style.leadingDistribution != null ||
        label.textAlign != TextAlign.start ||
        label.maxLines != null ||
        label.overflow != null ||
        label.softWrap != null ||
        label.textHeightBehavior != null ||
        Directionality.maybeOf(context) != TextDirection.ltr ||
        (MediaQuery.maybeBoldTextOf(context) ?? false) ||
        (MediaQuery.maybeTextScalerOf(context) ?? TextScaler.noScaling) != TextScaler.noScaling ||
        MediaQuery.maybeLetterSpacingOverrideOf(context) != null ||
        MediaQuery.maybeWordSpacingOverrideOf(context) != null ||
        MediaQuery.maybeLineHeightScaleFactorOverrideOf(context) != null ||
        DefaultTextHeightBehavior.maybeOf(context) != null) {
      return null;
    }
    return (style: style, locale: Localizations.maybeLocaleOf(context), view: View.maybeOf(context));
  }

  @override
  SingleChildRenderObjectElement createElement() =>
      _data.length <= _maximumLabelLength && _TextMotionAtlasBatch.usesDeferredImages
      ? _MateoTextMotionElement(this)
      : super.createElement();

  @override
  _RenderMateoTextMotion createRenderObject(BuildContext context) =>
      _RenderMateoTextMotion(_data, enabled, _pixelRatioOf(context));

  @override
  void updateRenderObject(BuildContext context, _RenderMateoTextMotion renderObject) {
    final data = _data;
    final changed = !identical(data, renderObject._data) && data != renderObject._data;
    renderObject.updateText(
      data,
      context: context,
      changed: changed,
      color: _nativeText.style?.color,
      enabled: enabled,
      devicePixelRatio: _pixelRatioOf(context),
      config: renderObject._holdingNativeChild || (changed && data.length <= _maximumLabelLength)
          ? _preparedConfig(context)
          : null,
      semanticsLabel: _nativeText.semanticsLabel,
    );
  }
}

typedef _PreparedNumeralConfig = ({TextStyle style, Locale? locale, ui.FlutterView? view});

// The native child always has the same widget type and no key.
class _MateoTextMotionElement extends SingleChildRenderObjectElement {
  new(_MateoTextMotion super.widget);

  @override
  BuildScope get buildScope => _nativeScope;

  late final _nativeScope = BuildScope(scheduleRebuild: _scheduleNativeRebuild);
  bool _nativeFrameScheduled = false;

  void _scheduleNativeRebuild() {
    if (_nativeFrameScheduled) return;
    final scheduler = SchedulerBinding.instance;
    if (scheduler.schedulerPhase case .idle || .postFrameCallbacks) {
      _nativeFrameScheduled = true;
      scheduler.scheduleFrameCallback((_) {
        _nativeFrameScheduled = false;
        if (mounted) renderObject._scheduleNativeRebuild();
      });
    } else {
      renderObject._scheduleNativeRebuild();
    }
  }

  @override
  _RenderMateoTextMotion get renderObject => super.renderObject as _RenderMateoTextMotion;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    renderObject._buildNativeScope = (commit) => owner!.buildScope(this, commit ? _commitText : null);
    renderObject._nativeScopeNeedsBuild = true;
  }

  @override
  Element? updateChild(Element? child, Widget? newWidget, Object? newSlot) {
    if (child != null && newWidget is Text && renderObject._holdingNativeChild) return child;
    renderObject._nativeNeedsCommit = false;
    return super.updateChild(child, newWidget, newSlot);
  }

  void _commitText() {
    final native = (widget as _MateoTextMotion)._nativeText;
    visitChildren((child) {
      final updated = super.updateChild(child, native, null);
      assert(identical(updated, child), 'The unkeyed native Text must keep its element.');
    });
  }

  @override
  void unmount() {
    renderObject._buildNativeScope = null;
    super.unmount();
  }
}

class _RenderMateoTextMotion extends RenderProxyBox with RenderObjectWithLayoutCallbackMixin {
  new(this._data, this._enabled, this._devicePixelRatio);

  String _data;
  bool _enabled;
  double _devicePixelRatio;
  _ActiveTextMotion? _motion;
  void Function(bool commit)? _buildNativeScope;
  bool _nativeScopeNeedsBuild = false;

  void _scheduleNativeRebuild() {
    _nativeScopeNeedsBuild = true;
    scheduleLayoutCallback();
  }

  _PreparedNumeralConfig? _preparedConfig;
  String? _preparedSemanticsLabel;
  _TextMotionLayout? _preparedLayout;
  _TextMotionLayout? _stagedPreparedLayout;
  _HiddenTextMotion? _hiddenText;
  bool get _holdingNativeChild => _preparedLayout != null || _hiddenText != null;

  void updateText(
    String data, {
    required BuildContext context,
    required bool changed,
    required Color? color,
    required bool enabled,
    required double devicePixelRatio,
    required _PreparedNumeralConfig? config,
    required String? semanticsLabel,
  }) {
    final hidden = _hiddenText;
    if (hidden != null) {
      final valid =
          enabled &&
          config != null &&
          config == _preparedConfig &&
          devicePixelRatio == _devicePixelRatio &&
          hidden.fontGeneration == _TextMotionLayout._fontGeneration;
      _enabled = enabled;
      _devicePixelRatio = devicePixelRatio;
      _preparedConfig = config;
      _preparedSemanticsLabel = semanticsLabel;
      if (!valid) {
        _data = data;
        _releaseHiddenText();
        markNeedsLayout();
        return;
      }
      if (changed) {
        _data = data;
        hidden.update(data, SchedulerBinding.instance.currentFrameTimeStamp);
        markNeedsSemanticsUpdate();
        markNeedsLayout();
      }
      return;
    }

    final active = _motion;
    // A paint-only color change does not trigger the native layout check.
    final preparedConfigChanged = _holdingNativeChild && config != _preparedConfig;
    final colorChanged =
        active != null && (active.source?.layout ?? active.transition!.layout)._key.text.style?.color != color;
    if (active != null &&
        (colorChanged || preparedConfigChanged || !enabled || devicePixelRatio != _devicePixelRatio)) {
      _clearMotion();
      markNeedsLayout();
    }
    _enabled = enabled;
    _devicePixelRatio = devicePixelRatio;
    _preparedConfig = config;
    if (_holdingNativeChild && _preparedSemanticsLabel != semanticsLabel) markNeedsSemanticsUpdate();
    _preparedSemanticsLabel = semanticsLabel;
    if (!changed) return;
    if (config != null && active == null && attached && hasSize && _tryHoldHiddenText(data, config, context)) return;
    if (_enabled && !colorChanged && !preparedConfigChanged && attached && hasSize) _captureSource();
    _data = data;
    final motion = _motion;
    if (motion != null && (motion.source != null || motion.needsRetargetLayout)) {
      _stagedPreparedLayout?.dispose();
      _stagedPreparedLayout = null;
      if (config != null) _prepareNumeral(data, config, motion);
      markNeedsLayout();
    }
    if (_stagedPreparedLayout == null) _releasePreparedChild();
  }

  bool _tryHoldHiddenText(String data, _PreparedNumeralConfig config, BuildContext context) {
    if (_HiddenTextMotion._heldRows >= _HiddenTextMotion._maximumHeldRows) return false;
    final scheduler = SchedulerBinding.instance;
    if (scheduler.schedulerPhase == .idle || debugRepaintTextRainbowEnabled) return false;
    final fixed = _FixedTextRow.inspect(this, context);
    if (fixed?.outsidePaintRange() != true) return false;

    final paragraph = _findParagraph(child);
    if (paragraph == null ||
        paragraph.text is! TextSpan ||
        paragraph.text.style != config.style ||
        paragraph.locale != config.locale ||
        paragraph.textDirection != .ltr ||
        paragraph.textAlign != .start ||
        paragraph.textWidthBasis != .parent ||
        paragraph.strutStyle != null ||
        paragraph.textHeightBehavior != null ||
        paragraph.maxLines != null ||
        paragraph.overflow != .clip ||
        !paragraph.softWrap ||
        paragraph.hyphens != ui.Hyphens.manual ||
        paragraph.textScaler != TextScaler.noScaling ||
        !paragraph.hasSize ||
        paragraph.constraints != constraints) {
      return false;
    }
    final span = paragraph.text as TextSpan;
    if (span.text != _data || span.children?.isNotEmpty == true) return false;
    final template = _PreparedNumeralTemplate.infer(_data, data, decimalSeparator: _decimalSeparator(config.locale));
    if (template == null) return false;
    final step = _HiddenTextMotion.numeralDelta(template, _data, data);
    if (step != 1 && step != -1) return false;

    _TextMotionLayout._listenForFontChanges();
    _hiddenText = _HiddenTextMotion(fixed!, constraints, template, step, _data, (
      text: data,
      startsAt: scheduler.currentFrameTimeStamp,
    ));
    _HiddenTextMotion._heldRows++;
    _data = data;
    _textMotionClock.add(this);
    markNeedsSemanticsUpdate();
    markNeedsLayout();
    return true;
  }

  void _releaseHiddenText() {
    if (_hiddenText == null) return;
    _hiddenText = null;
    _HiddenTextMotion._heldRows--;
    _textMotionClock.remove(this);
    _nativeNeedsCommit = true;
    markNeedsSemanticsUpdate();
  }

  void _captureSource() {
    final active = _motion;
    if (active?._borrowedInkInvalid == true) _clearMotion();
    final motion = _motion;
    if (motion != null) {
      motion._borrowedInkBank = null;
      final transition = motion.transition;
      if (transition == null) return;
      // Deferred images can be submitted in the same frame as the handoff.
      // Asynchronous images need the current motion to keep painting until ready.
      if (!_TextMotionAtlasBatch.usesDeferredImages &&
          motion.time > 0 &&
          (transition.layout._preparedGlyphs != null || transition.layout.textureAt(_devicePixelRatio) != null)) {
        motion.requestRetarget();
        return;
      }
      motion.interrupt();
      _textMotionClock.remove(this);
      return;
    }
    // The incoming Text has not updated its RenderParagraph yet.
    final paragraph = _findParagraph(child);
    if (paragraph == null || paragraph.text is! TextSpan || (paragraph.text as TextSpan).text != _data) return;
    final layout = _TextMotionLayout.acquire(paragraph, _data, constraints);
    if (!layout.canAnimate) {
      layout.dispose();
      return;
    }
    _motion = _ActiveTextMotion(layout, constraints);
  }

  void _prepareNumeral(String data, _PreparedNumeralConfig config, _ActiveTextMotion motion) {
    final reference = motion.source?.layout ?? motion.transition!.layout;
    final source = reference._key.text;
    if (source is! TextSpan || source.text == null) {
      motion._clearPreparedTemplate();
      return;
    }

    final previous = source.text!;
    final separator = _decimalSeparator(reference._key.locale);
    final existing = motion._preparedTemplate;
    final template = existing != null && existing.accepts(previous, data, decimalSeparator: separator)
        ? existing
        : reference._preparedGlyphs == null
        ? _PreparedNumeralTemplate.infer(previous, data, decimalSeparator: separator)
        : null;
    final oldBank = motion._preparedBank;
    if (oldBank != null && !oldBank._matchesConfiguration(config, _devicePixelRatio, reference._key.fontGeneration)) {
      motion
        .._clearPreparedTemplate()
        .._releasePreparedBank();
    }
    final bank = template == null ? null : _PreparedNumeralBank.forLayout(reference, config, _devicePixelRatio);
    if (bank == null || template == null) {
      motion._clearPreparedTemplate();
      return;
    }
    if (!identical(template, existing) || !identical(bank, motion._preparedBank)) {
      motion._clearPreparedTemplate();
      if (!bank.observe(reference, template)) return;
      motion
        .._usePreparedBank(bank)
        .._preparedTemplate = template;
    }
    if (!motion._hasNativeTemplate) return;

    bank.queueInk(template, reference);
    final target = bank.prepare(data, template, reference);
    if (target == null) return;
    _stagedPreparedLayout?.dispose();
    _stagedPreparedLayout = target;
    _preparedLayout = target;
    markNeedsSemanticsUpdate();
  }

  bool get _preparedEnvironmentIsCurrent {
    final ratio = _preparedConfig?.view?.devicePixelRatio;
    return !SemanticsBinding.instance.semanticsEnabled &&
        _preparedLayout?._key.fontGeneration == _TextMotionLayout._fontGeneration &&
        _motion?._preparedBank?._valid == true &&
        _preparedLayout?._preparedGlyphs?.page.rasterizationFailed == false &&
        (ratio == null || ratio == _devicePixelRatio);
  }

  void _releasePreparedChild() {
    if (!_holdingNativeChild) return;
    _stagedPreparedLayout?.dispose();
    _stagedPreparedLayout = null;
    _preparedLayout = null;
    markNeedsSemanticsUpdate();
  }

  @override
  void layoutCallback() {
    final needsCommit = _nativeNeedsCommit;
    _nativeNeedsCommit = false;
    _nativeScopeNeedsBuild = false;
    _buildNativeScope?.call(needsCommit);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    if (!_holdingNativeChild) return;
    config
      ..label = _preparedSemanticsLabel ?? _data
      ..textDirection = .ltr;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    if (!_holdingNativeChild) super.visitChildrenForSemantics(visitor);
  }

  // Rare dry/intrinsic queries keep the same latest-value contract as Text.
  // Ordinary constrained layout never uses this painter.
  T _dryPrepared<T>(_TextMotionLayout layout, BoxConstraints constraints, T Function(TextPainter) read) {
    final painter = layout._newPainter(layout._key.text);
    try {
      painter.layout(minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);
      return read(painter);
    } finally {
      painter.dispose();
    }
  }

  T? _preparedIntrinsic<T>(BoxConstraints constraints, T Function(TextPainter) read) {
    final layout = _preparedLayout;
    if (layout != null) return _dryPrepared(layout, constraints, read);
    if (_hiddenText == null) return null;
    final paragraph = _findParagraph(child);
    final span = paragraph?.text;
    if (paragraph == null || span is! TextSpan) return null;
    final latest = TextSpan(text: _data, style: span.style, locale: span.locale);
    final key = _TextMotionLayout._keyFor(paragraph, latest, constraints);
    final painter = _TextMotionLayout._painterFor(key, latest)
      ..layout(minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);
    try {
      return read(painter);
    } finally {
      painter.dispose();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _preparedIntrinsic(const BoxConstraints(), (painter) => painter.minIntrinsicWidth) ??
      super.computeMinIntrinsicWidth(height);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _preparedIntrinsic(const BoxConstraints(), (painter) => painter.maxIntrinsicWidth) ??
      super.computeMaxIntrinsicWidth(height);

  @override
  double computeMinIntrinsicHeight(double width) =>
      _preparedIntrinsic(BoxConstraints.tightFor(width: width), (painter) => painter.height) ??
      super.computeMinIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _preparedIntrinsic(BoxConstraints.tightFor(width: width), (painter) => painter.height) ??
      super.computeMaxIntrinsicHeight(width);

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) =>
      _preparedIntrinsic(constraints, (painter) => constraints.constrain(painter.size)) ??
      super.computeDryLayout(constraints);

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      (_hiddenText == null
          ? null
          : _preparedIntrinsic(constraints, (painter) => painter.computeDistanceToActualBaseline(.alphabetic))) ??
      super.computeDistanceToActualBaseline(baseline);

  @override
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) =>
      _preparedIntrinsic(
        constraints,
        (painter) => painter.computeDistanceToActualBaseline(_hiddenText == null ? baseline : .alphabetic),
      ) ??
      super.computeDryBaseline(constraints, baseline);

  static RenderParagraph? _findParagraph(RenderObject? renderObject) {
    if (renderObject is RenderParagraph) return renderObject;
    RenderParagraph? result;
    renderObject?.visitChildren((child) {
      result ??= _findParagraph(child);
    });
    return result;
  }

  @override
  void performLayout() {
    final hidden = _hiddenText;
    if (hidden != null) {
      _layoutHiddenText(hidden);
      return;
    }
    if (_nativeScopeNeedsBuild) runLayoutCallback();
    final prepared = _preparedLayout;
    if (prepared != null) {
      final config = _preparedConfig;
      if (_motion != null &&
          config != null &&
          _preparedEnvironmentIsCurrent &&
          constraints == prepared._key.constraints) {
        // Keep the retained native child's layout relationship clean. With equal
        // constraints the child's layout is a no-op until the native handoff.
        super.performLayout();
        _performPreparedLayout(_motion!);
        return;
      }
      _clearMotion();
      _releasePreparedChild();
    }
    if (_nativeNeedsCommit) runLayoutCallback();
    super.performLayout();
    final motion = _motion;
    if (motion == null) return;
    if (constraints != motion.constraints) {
      _clearMotion();
      return;
    }
    final paragraph = _findParagraph(child);
    final source = motion.source;
    final reference = source?.layout ?? motion.transition!.layout;
    if (paragraph == null || !reference.matchesParagraph(paragraph)) {
      _clearMotion();
      return;
    }
    if (source != null || motion.needsRetargetLayout) {
      // The reference and target have the same style and font generation.
      var target = _TextMotionLayout.acquire(
        paragraph,
        _data,
        constraints,
        knownNumericMetrics: reference._measuredNumericMetrics,
      );
      if (!target.canAnimate) {
        target.dispose();
        _clearMotion();
        return;
      }
      if (motion._preparedTemplate case final template?) {
        final bank = motion._preparedBank!;
        final hadNativeTemplate = motion._hasNativeTemplate;
        motion._hasNativeTemplate = bank.observe(target, template);
        if (_TextMotionAtlasBatch.usesRawAtlas && hadNativeTemplate && motion._hasNativeTemplate) {
          final carried = bank._carryObservedNativeAtlas(target, template, reference);
          if (carried != null) {
            target.dispose();
            target = carried;
            _preparedLayout = carried;
            // Another label can disprove a shared bank later in the same
            // layout pass. The already-current native child can paint instead.
            motion._borrowedInkBank = bank;
            markNeedsSemanticsUpdate();
          }
        }
      }
      final decimalSeparator = _decimalSeparator(paragraph.locale);
      if (source != null) {
        motion.start(source, target, decimalSeparator);
        _preparePlayback(motion);
      } else {
        _prepareRetarget(motion, target, decimalSeparator);
      }
    }
    size = motion.frameSize;
  }

  void _layoutHiddenText(_HiddenTextMotion hidden) {
    final now = SchedulerBinding.instance.currentFrameTimeStamp;
    final elapsed = now - hidden.changes.last.startsAt;
    final expired = elapsed >= _textMotionDuration;
    final canReplay =
        _enabled &&
        !_nativeScopeNeedsBuild &&
        !SemanticsBinding.instance.semanticsEnabled &&
        constraints == hidden.constraints &&
        hidden.fontGeneration == _TextMotionLayout._fontGeneration;
    final outside = hidden.row.outsidePaintRange(afterLayout: true);
    if (canReplay &&
        !expired &&
        outside == true &&
        (!hidden.requestFullReplay || !hidden.takeHiddenReplayBudget(now))) {
      final trainingBank = _nativeTrainingBank(hidden, now);
      // The laid-out base can supply calibration while the row stays hidden.
      final retainedText = trainingBank == null ? null : _retainedTrainingText(hidden, trainingBank);
      if (trainingBank != null) {
        hidden.nativeTrainingAttempted = true;
        if (retainedText == null) {
          _nativeNeedsCommit = true;
          runLayoutCallback();
        }
      }
      super.performLayout();
      if (trainingBank != null) _observeTrainedNativeParagraph(hidden, trainingBank, retainedText ?? _data);
      return;
    }

    final original = _findParagraph(child);
    final currentConfig = _preparedConfig;
    final replayBank = currentConfig != null && outside == false && !hidden.requestFullReplay
        ? _PreparedNumeralBank.findTrainingBank(
            currentConfig,
            _devicePixelRatio,
            hidden.fontGeneration,
            requireEmpty: false,
          )
        : null;
    var motion = !expired && canReplay && original != null
        ? hidden.replayBeforeCurrent(this, original, bank: replayBank)
        : null;
    _releaseHiddenText();
    runLayoutCallback();
    super.performLayout();

    if (motion == null) return;
    final paragraph = _findParagraph(child);
    final source = motion.source!;
    if (paragraph == null || !source.layout.matchesParagraph(paragraph)) {
      motion.dispose(keepGeometry: false);
      return;
    }
    final latest = _TextMotionLayout.acquire(
      paragraph,
      _data,
      constraints,
      knownNumericMetrics: source.layout._measuredNumericMetrics,
    );
    if (!latest.canAnimate) {
      latest.dispose();
      motion.dispose(keepGeometry: false);
      return;
    }
    final config = _preparedConfig;
    _PreparedNumeralBank? observed;
    final template = hidden.template;
    if (config != null) {
      final bank = _PreparedNumeralBank.forLayout(latest, config, _devicePixelRatio);
      if (bank != null && bank.observe(latest, template)) {
        observed = bank;
        bank.queueInk(template, latest);
      }
    }
    if (replayBank != null && !identical(observed, replayBank)) {
      // The current native endpoint must corroborate speculative replay geometry.
      motion.dispose(keepGeometry: false);
      motion = hidden.replayBeforeCurrent(this, paragraph);
      if (motion == null) {
        latest.dispose();
        return;
      }
    }
    if (observed != null) {
      motion
        .._usePreparedBank(observed)
        .._preparedTemplate = template
        .._hasNativeTemplate = true;
    }
    final preparedLatest = observed == null || !identical(observed, replayBank)
        ? null
        : observed.prepare(_data, template, latest);
    if (preparedLatest != null) {
      latest.dispose();
    }
    motion.start(motion.source!, preparedLatest ?? latest, _decimalSeparator(paragraph.locale));
    motion._playDelay = Duration.zero;
    if (elapsed > Duration.zero) motion.advance(elapsed);
    if (_canSettleEarly(motion)) {
      motion.dispose(keepGeometry: false);
      return;
    }
    _motion = motion;
    motion._borrowedInkBank = identical(observed, replayBank) ? replayBank : null;
    _preparedLayout = preparedLatest;
    size = motion.frameSize;
    _preparePlayback(motion, startedAt: hidden.changes.last.startsAt);
  }

  _PreparedNumeralBank? _nativeTrainingBank(_HiddenTextMotion hidden, Duration now) {
    final config = _preparedConfig;
    if (hidden.nativeTrainingAttempted ||
        hidden.requestFullReplay ||
        hidden.changes.first.startsAt == now ||
        config == null) {
      return null;
    }
    final bank = _PreparedNumeralBank.findTrainingBank(config, _devicePixelRatio, hidden.fontGeneration);
    if (bank == null || !_textMotionClock.reserveNativeTraining(now)) return null;
    return bank;
  }

  String? _retainedTrainingText(_HiddenTextMotion hidden, _PreparedNumeralBank bank) {
    final paragraph = _findParagraph(child);
    if (paragraph == null || !paragraph.hasSize || paragraph.constraints != constraints) return null;
    final span = paragraph.text;
    // History compaction can move the base ahead of the held paragraph.
    if (span is! TextSpan ||
        span.children != null ||
        span.text != hidden.baseText ||
        span.style != bank.config.style ||
        paragraph.locale != bank.config.locale) {
      return null;
    }
    return span.text;
  }

  void _observeTrainedNativeParagraph(_HiddenTextMotion hidden, _PreparedNumeralBank bank, String trainingText) {
    final paragraph = _findParagraph(child);
    if (paragraph == null || paragraph.text is! TextSpan || (paragraph.text as TextSpan).text != trainingText) return;
    final layout = _TextMotionLayout.acquire(paragraph, trainingText, constraints);
    try {
      final template = hidden.template;
      if (bank.observe(layout, template)) {
        bank.queueInk(template, layout);
        if (bank._queuedInk.contains(template.affixes)) bank._collectingCachedInk = true;
      }
    } finally {
      layout.dispose();
    }
  }

  void _performPreparedLayout(_ActiveTextMotion motion) {
    final target = _stagedPreparedLayout;
    if (target != null) {
      _stagedPreparedLayout = null;
      final separator = _decimalSeparator(target._key.locale);
      final source = motion.source;
      if (source != null) {
        motion.start(source, target, separator);
        _preparePlayback(motion);
      } else {
        _prepareRetarget(motion, target, separator);
      }
    }
    size = motion.frameSize;
  }

  bool _nativeNeedsCommit = false;

  void _preparePlayback(_ActiveTextMotion motion, {Duration? startedAt}) {
    if (_TextMotionAtlasBatch.usesDeferredImages && _outsideSliverPaintExtent()) {
      _textMotionClock._deferredTextures.add(this);
    } else {
      motion.transition!.prepareTextures(_devicePixelRatio, retained: startedAt != null ? motion.layouts : null);
    }
    _textMotionClock.add(this, startedAt: startedAt);
  }

  // A cached row can still run motion and affect layout. Its last known sliver
  // extent only hints whether to defer atlas work until after layout.
  bool _outsideSliverPaintExtent({bool layoutComplete = false}) {
    RenderObject row = this;
    var sliver = row.parent;
    while (sliver is RenderBox) {
      row = sliver;
      sliver = row.parent;
    }
    final position = row.parentData;
    if (position is! SliverMultiBoxAdaptorParentData || position.index == null) return false;
    if (sliver is RenderSliverFixedExtentList && sliver.runtimeType == RenderSliverFixedExtentList) {
      final extent = sliver.itemExtent;
      final constraints = sliver.constraints;
      final start = position.index! * extent - constraints.scrollOffset;
      return start >= constraints.remainingPaintExtent || start + extent <= 0;
    }
    final offset = position.layoutOffset;
    if (sliver is RenderSliverList && sliver.runtimeType == RenderSliverList && row is RenderBox && offset != null) {
      final constraints = sliver.constraints;
      final start = offset - constraints.scrollOffset;
      if (start >= constraints.remainingPaintExtent) return true;
      if (layoutComplete && row.hasSize) {
        final extent = constraints.axis == Axis.vertical ? row.size.height : row.size.width;
        return start + extent <= 0;
      }
    }
    return false;
  }

  void _prepareDeferredTextures() {
    final motion = _motion!;
    // A deferred transition may retire invisible exits before its first paint.
    motion.transition!.prepareTextures(_devicePixelRatio, retained: motion.layouts);
  }

  void _prepareRetarget(_ActiveTextMotion motion, _TextMotionLayout target, String decimalSeparator) {
    if (identical(target, motion.transition!.layout)) {
      target.dispose();
      motion.clearRetarget();
      return;
    }
    final retarget = (layout: target, decimalSeparator: decimalSeparator);
    target.prepareTextureAt(_devicePixelRatio);
    if (!_TextMotionAtlasBatch.awaitingTexture(target, _devicePixelRatio)) {
      _startRetarget(motion, retarget);
      return;
    }
    final scheduler = SchedulerBinding.instance;
    final timestamp = scheduler.schedulerPhase == SchedulerPhase.idle ? null : scheduler.currentFrameTimeStamp;
    motion.stageRetarget(retarget, timestamp);
  }

  void _startRetarget(_ActiveTextMotion motion, _PendingTextRetarget retarget) {
    motion.interrupt();
    motion.start(motion.source!, retarget.layout, retarget.decimalSeparator);
    _preparePlayback(motion);
  }

  static Locale? _lastNumberLocale;
  static String _lastDecimalSeparator = '.';

  static String _decimalSeparator(Locale? locale) {
    if (locale == _lastNumberLocale) return _lastDecimalSeparator;
    final name = Intl.canonicalizedLocale(locale?.toLanguageTag() ?? 'en');
    _lastNumberLocale = locale;
    return _lastDecimalSeparator = (numberFormatSymbols[name] ?? numberFormatSymbols['en']!).DECIMAL_SEP;
  }

  void _tick(Duration elapsed, Duration now) {
    if (_hiddenText case final hidden?) {
      // The bucket can keep a child attached without ever laying it out.
      final parentData = hidden.row.row.parentData;
      if (parentData is SliverMultiBoxAdaptorParentData &&
          parentData.keptAlive &&
          now - hidden.changes.last.startsAt >= _textMotionDuration) {
        _releaseHiddenText();
        _scheduleNativeRebuild();
        return;
      }
      // Even a retained repaint boundary must inspect live viewport geometry
      // before a layout pass can make this row visible.
      markNeedsLayout();
      return;
    }
    final motion = _motion!;
    if (motion._borrowedInkInvalid || (_holdingNativeChild && !_preparedEnvironmentIsCurrent)) {
      _clearMotion();
      _scheduleNativeRebuild();
      return;
    }
    final playback = motion.playbackElapsed(elapsed, _devicePixelRatio);
    if (playback == null) return;
    final pending = motion.takeRunnableRetarget(playback, now, _devicePixelRatio);
    final Size nextSize;
    if (pending != null) {
      _startRetarget(motion, pending);
      nextSize = motion.frameSize;
    } else if (playback >= _textMotionDuration) {
      nextSize = motion.transition!.layout.size;
      _clearMotion(keepGeometry: true);
    } else {
      motion.advance(playback);
      if (_canSettleEarly(motion)) {
        nextSize = motion.transition!.layout.size;
        _clearMotion(keepGeometry: true);
      } else {
        nextSize = motion.frameSize;
      }
    }
    // Dirty layout also requests paint and invalidates ancestor intrinsic and
    // baseline caches. An equal-size update only needs a new display list.
    if (_nativeNeedsCommit) {
      _scheduleNativeRebuild();
    } else if (nextSize != size) {
      markNeedsLayout();
    } else {
      markNeedsPaint();
    }
  }

  bool _canSettleEarly(_ActiveTextMotion motion) {
    const settledPixelTolerance = 0.25;
    if (motion.time < 0.6 || motion._pendingRetarget != null || motion.needsRetargetLayout) return false;

    final distance = motion.transition!.remainingDistance(motion.time, motion.travel) * _devicePixelRatio;
    if (!(distance <= settledPixelTolerance)) return false;

    // Keep the motion under magnification until the remaining displacement is
    // also subpixel on screen. Projective transforms keep the full duration.
    final transform = getTransformTo(null).storage;
    if (transform[3] != 0 || transform[7] != 0 || transform[15] != 1) return false;
    final scale = math.max(transform[0].abs() + transform[4].abs(), transform[1].abs() + transform[5].abs());
    return scale.isFinite && scale > 0 && distance * math.max(1, scale) <= settledPixelTolerance;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final motion = _motion;
    final transition = motion?.transition;
    if (motion == null || transition == null) {
      super.paint(context, offset);
      return;
    }
    if (motion._borrowedInkInvalid) {
      super.paint(context, offset);
      return;
    }
    _textMotionClock._prepareVisibleDeferredTextures(this);
    _TextMotionAtlasBatch.flush();
    _PreparedNumeralBank.flushInk();
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    final initial = motion.initialLayout;
    if (motion.time == 0 && initial != null) {
      canvas.drawPicture(initial.picture);
    } else {
      transition.paint(canvas, motion.time, motion.travel, _devicePixelRatio);
    }
    canvas.restore();
  }

  void _clearMotion({bool keepGeometry = false}) {
    final motion = _motion;
    if (motion == null) return;
    _textMotionClock.remove(this);
    if (_holdingNativeChild) {
      _nativeNeedsCommit = true;
      _releasePreparedChild();
    }
    motion.dispose(keepGeometry: keepGeometry);
    _motion = null;
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_nativeNeedsCommit) _scheduleNativeRebuild();
  }

  @override
  void detach() {
    final hadMotion = _motion != null || _hiddenText != null;
    _releaseHiddenText();
    _clearMotion();
    super.detach();
    if (hadMotion) markNeedsLayout();
  }
}
