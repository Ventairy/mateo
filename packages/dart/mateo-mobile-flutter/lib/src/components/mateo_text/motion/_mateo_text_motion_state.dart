part of '../mateo_text.dart';

typedef _PendingTextRetarget = ({_TextMotionLayout layout, String decimalSeparator});
const _textMotionTextureWait = Duration(milliseconds: 40);

class _ActiveTextMotion {
  new(_TextMotionLayout layout, this.constraints)
    : initialLayout = layout,
      source = layout.restFrame,
      frameSize = layout.size,
      layouts = {layout};

  _PreparedNumeralBank? _preparedBank;
  _PreparedNumeralBank? _borrowedInkBank;
  bool get _borrowedInkInvalid => _borrowedInkBank?._valid == false;
  _PreparedNumeralTemplate? _preparedTemplate;
  bool _hasNativeTemplate = false;

  void _clearPreparedTemplate() {
    _preparedTemplate = null;
    _hasNativeTemplate = false;
  }

  void _usePreparedBank(_PreparedNumeralBank bank) {
    if (identical(_preparedBank, bank)) return;
    _releasePreparedBank();
    _preparedBank = bank;
    bank._motionUsers++;
  }

  void _releasePreparedBank() {
    final bank = _preparedBank;
    if (bank == null) return;
    _preparedBank = null;
    if (--bank._motionUsers == 0) {
      bank._forgetAffixes();
      _PreparedNumeralBank._retireIdleBank(bank);
    }
  }

  final BoxConstraints constraints;
  final Set<_TextMotionLayout> layouts;
  _TextMotionLayout? initialLayout;
  _TextMotionFrame? source;
  _TextMotionTransition? transition;
  (Object, _TextMotionLayout)? _sharedKey;
  bool _interrupted = false;
  int _nextDeparture = 0;
  Duration? _playDelay;
  Duration _heldElapsed = Duration.zero;
  bool needsRetargetLayout = false;
  _PendingTextRetarget? _pendingRetarget;
  Duration? _pendingRetargetSince;
  static final _sharedTransitions = <(Object, _TextMotionLayout), _SharedTextMotion>{};
  static final _latestFrames = Expando<({double time, _TextMotionFrame frame})>();

  double time = 0;
  double travel = 0;
  Size frameSize;

  void start(_TextMotionFrame from, _TextMotionLayout target, String decimalSeparator) {
    target._wasDestination = true;
    if (!layouts.add(target)) target.dispose();
    final _TextMotionTransition transition;
    if (target._preparedGlyphs != null) {
      // Prepared destinations belong to one render object and never enter
      // the shared native layout caches.
      transition = _TextMotionTransition(from, target, decimalSeparator);
    } else {
      final key = (_interrupted ? from.identity : from.layout, target);
      _sharedKey = key;
      final shared = _sharedTransitions.putIfAbsent(
        key,
        () => _SharedTextMotion(_TextMotionTransition(from, target, decimalSeparator)),
      );
      shared.users++;
      transition = shared.transition;
    }
    this.transition = transition;
    source = null;
    time = 0;
    travel = 0;
    _heldElapsed = Duration.zero;
    _playDelay = _interrupted || _TextMotionAtlasBatch.usesImpeller ? Duration.zero : null;
    frameSize = constraints.constrain(transition.initialSize);
    _nextDeparture = 0;
    final used = {
      transition.layout,
      ?initialLayout,
      for (final departure in transition.departureExpirations) departure.layout,
    };
    layouts.removeWhere((layout) {
      if (used.contains(layout)) return false;
      layout.retire(afterInterruption: _interrupted);
      return true;
    });
  }

  void requestRetarget() {
    _releasePendingRetarget();
    needsRetargetLayout = true;
  }

  void stageRetarget(_PendingTextRetarget retarget, Duration? timestamp) {
    needsRetargetLayout = false;
    _pendingRetarget = retarget;
    _pendingRetargetSince ??= timestamp;
  }

  _PendingTextRetarget? takeRunnableRetarget(Duration playback, Duration now, double pixelRatio) {
    final pending = _pendingRetarget;
    if (pending == null) return null;
    if (playback < _textMotionDuration &&
        now - (_pendingRetargetSince ??= now) < _textMotionTextureWait &&
        _TextMotionAtlasBatch.awaitingTexture(pending.layout, pixelRatio)) {
      return null;
    }
    // Transfer this owner's destination to the new transition before
    // interrupting the old one and releasing its resources.
    _pendingRetarget = null;
    return pending;
  }

  void _releasePendingRetarget() {
    _pendingRetarget?.layout.dispose();
    _pendingRetarget = null;
  }

  void clearRetarget() {
    _releasePendingRetarget();
    _pendingRetargetSince = null;
    needsRetargetLayout = false;
  }

  Duration? playbackElapsed(Duration elapsed, double pixelRatio) {
    final delay = _playDelay;
    if (delay != null) return elapsed - delay;
    if (elapsed < _textMotionTextureWait && transition!.hasPendingTextures(pixelRatio)) {
      _heldElapsed = elapsed;
      return null;
    }
    // The last held frame is the time-zero frame. Advance on this frame and
    // keep the full motion duration from that visible source.
    _playDelay = _heldElapsed;
    return elapsed - _heldElapsed;
  }

  void advance(Duration elapsed) {
    time = elapsed.inMicroseconds / _textMotionDuration.inMicroseconds;
    travel = _textMotionCurve.transform(time);
    final current = transition!;
    _retireExpiredDepartures(current);
    frameSize = current.initialSize == current.layout.size
        ? current.layout.size
        : constraints.constrain(Size.lerp(current.initialSize, current.layout.size, travel)!);
  }

  void _retireExpiredDepartures(_TextMotionTransition current) {
    if (time <= 0) return;
    final departures = current.departureExpirations;
    final initial = initialLayout;
    if (initial != null) {
      initialLayout = null;
      if (!identical(initial, current.layout) && !departures.any((departure) => identical(departure.layout, initial))) {
        _releaseDeparture(initial);
      }
    }
    // Every sprite from this layout has zero opacity after its final exit.
    // Releasing now gives the next requested destination room in the atlas.
    while (_nextDeparture < departures.length && time >= departures[_nextDeparture].end) {
      final departure = departures[_nextDeparture];
      _nextDeparture++;
      _releaseDeparture(departure.layout);
    }
  }

  void _releaseDeparture(_TextMotionLayout layout) {
    if (layouts.remove(layout)) layout.retire(afterInterruption: _interrupted);
  }

  void interrupt() {
    clearRetarget();
    final current = transition!;
    final initial = initialLayout;
    if (time == 0 && initial != null) {
      source = initial.restFrame;
    } else {
      final canShareFrame = _sharedKey != null;
      final sampled = canShareFrame ? _latestFrames[current] : null;
      if (sampled != null && sampled.time == time) {
        source = sampled.frame;
      } else {
        final frame = current.frameAt(time, travel);
        if (canShareFrame) _latestFrames[current] = (time: time, frame: frame);
        source = frame;
      }
      initialLayout = null;
    }
    _releaseSharedTransition();
    _interrupted = true;
    transition = null;
  }

  void _releaseSharedTransition() {
    final key = _sharedKey;
    if (key == null) return;
    if (--_sharedTransitions[key]!.users == 0) _sharedTransitions.remove(key);
    _sharedKey = null;
  }

  void dispose({required bool keepGeometry}) {
    _releasePreparedBank();
    clearRetarget();
    final destination = keepGeometry ? transition?.layout : null;
    _releaseSharedTransition();
    for (final layout in layouts) {
      layout.dispose(keepGeometry: identical(layout, destination));
    }
  }
}

class _SharedTextMotion {
  new(this.transition);

  final _TextMotionTransition transition;
  int users = 0;
}

final _textMotionClock = _TextMotionClock();

/// A single frame callback advances all currently moving labels.
class _TextMotionClock {
  final _started = <_RenderMateoTextMotion, Duration?>{};
  final _frameMembers = <_RenderMateoTextMotion>[];
  final _deferredTextures = <_RenderMateoTextMotion>{};
  Duration? _lastAtlasDemandFrame;
  PipelineOwner? _lastAtlasDemandOwner;
  Ticker? _ticker;
  Duration? _nativeTrainingFrame;
  int _nativeTrainings = 0;
  static const _nativeTrainingRowsPerFrame = 3;

  bool reserveNativeTraining(Duration now) {
    if (now != _nativeTrainingFrame) {
      _nativeTrainingFrame = now;
      _nativeTrainings = 0;
    }
    if (_nativeTrainings >= _nativeTrainingRowsPerFrame) return false;
    _nativeTrainings++;
    return true;
  }

  bool hasPendingNativeTraining(_PreparedNumeralBank bank) {
    return _started.keys.any((render) {
      final motion = render._motion;
      final template = motion?._preparedTemplate;
      if (template != null &&
          identical(motion!._preparedBank, bank) &&
          motion._hasNativeTemplate &&
          !bank._queuedInk.contains(template.affixes) &&
          !bank._attemptedInk.contains(template.affixes)) {
        return true;
      }
      final hidden = render._hiddenText;
      final parentData = hidden?.row.row.parentData;
      return hidden != null &&
          parentData is SliverMultiBoxAdaptorParentData &&
          !parentData.keptAlive &&
          !hidden.requestFullReplay &&
          !hidden.nativeTrainingAttempted &&
          hidden.fontGeneration == bank.fontGeneration &&
          render._devicePixelRatio == bank.pixelRatio &&
          render._preparedConfig == bank.config;
    });
  }

  void _prepareVisibleDeferredTextures(_RenderMateoTextMotion painting) {
    if (_deferredTextures.isEmpty) return;
    final scheduler = SchedulerBinding.instance;
    final frame = scheduler.schedulerPhase == .idle ? null : scheduler.currentFrameTimeStamp;
    final owner = painting.owner;
    if (frame != null && (frame != _lastAtlasDemandFrame || !identical(owner, _lastAtlasDemandOwner))) {
      _lastAtlasDemandFrame = frame;
      _lastAtlasDemandOwner = owner;
      // Preserve atlas batching for multiple cached rows revealed together.
      _deferredTextures.removeWhere((motion) {
        if (!identical(motion.owner, owner) || motion._outsideSliverPaintExtent(layoutComplete: true)) return false;
        motion._prepareDeferredTextures();
        return true;
      });
    }
    // A dirty repaint boundary can record outside its parent's paint range.
    if (_deferredTextures.remove(painting)) painting._prepareDeferredTextures();
  }

  void add(_RenderMateoTextMotion motion, {Duration? startedAt}) {
    final scheduler = SchedulerBinding.instance;
    _started[motion] =
        startedAt ?? (scheduler.schedulerPhase == SchedulerPhase.idle ? null : scheduler.currentFrameTimeStamp);
    _ticker ??= Ticker(_tick)..start();
  }

  void remove(_RenderMateoTextMotion motion) {
    _deferredTextures.remove(motion);
    if (_deferredTextures.isEmpty) {
      _lastAtlasDemandFrame = null;
      _lastAtlasDemandOwner = null;
    }
    _started.remove(motion);
    if (_started.isNotEmpty) return;
    _TextMotionLayout._clearIdleNumericMetrics();
    _ticker?.dispose();
    _ticker = null;
  }

  void _tick(Duration _) {
    final now = SchedulerBinding.instance.currentFrameTimeStamp;
    _frameMembers.addAll(_started.keys);
    try {
      for (final motion in _frameMembers) {
        final start = _started[motion];
        if (start != null) {
          motion._tick(now - start, now);
        } else if (_started.containsKey(motion)) {
          _started[motion] = now;
        }
      }
    } finally {
      _frameMembers.clear();
    }
  }
}
