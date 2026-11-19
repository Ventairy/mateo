part of '../mateo_text.dart';

typedef _HiddenTextChange = ({String text, Duration startsAt});

class _FixedTextRow {
  new(
    this.row,
    this.sliver,
    this.viewport,
    this.viewportChild,
    this.scrollPosition,
    this.children,
    this.sliverWidget,
    this.childCount,
    this.index,
    this.itemExtent,
    this.viewportConstraints,
    this.viewportExtent,
    this.crossExtent,
  );

  final RenderObject row;
  final RenderSliverFixedExtentList sliver;
  final RenderViewport viewport;
  final RenderSliver viewportChild;
  final ScrollPositionWithSingleContext scrollPosition;
  final SliverMultiBoxAdaptorElement children;
  final Widget sliverWidget;
  final int childCount;
  final int index;
  final double itemExtent;
  final BoxConstraints viewportConstraints;
  final double viewportExtent;
  final double crossExtent;

  static _FixedTextRow? inspect(RenderBox box, BuildContext context) {
    RenderObject row = box;
    var parent = row.parent;
    while (parent is RenderBox) {
      row = parent;
      parent = row.parent;
    }
    if (parent is! RenderSliverFixedExtentList || parent.runtimeType != RenderSliverFixedExtentList) return null;
    final sliver = parent;
    final data = row.parentData;
    if (data is! SliverMultiBoxAdaptorParentData || data.index == null || data.keptAlive) return null;
    SliverMultiBoxAdaptorElement? manager;
    context.visitAncestorElements((element) {
      if (element is! SliverMultiBoxAdaptorElement || !identical(element.renderObject, sliver)) return true;
      manager = element;
      return false;
    });
    final children = manager;
    if (children == null || children.runtimeType != SliverMultiBoxAdaptorElement) return null;
    final widget = children.widget;
    if (widget is! SliverFixedExtentList || widget.runtimeType != SliverFixedExtentList) return null;
    final delegateType = widget.delegate.runtimeType;
    if (delegateType != SliverChildBuilderDelegate && delegateType != SliverChildListDelegate) return null;
    final count = children.estimatedChildCount;
    if (count == null) return null;

    RenderSliver root = sliver;
    parent = sliver.parent;
    if (parent is RenderSliverPadding &&
        parent.runtimeType == RenderSliverPadding &&
        parent.padding.resolve(.ltr) == EdgeInsets.zero) {
      root = parent;
      parent = root.parent;
    }
    if (parent is! RenderViewport ||
        parent.runtimeType != RenderViewport ||
        !parent.hasSize ||
        parent.axisDirection != .down ||
        parent.anchor != 0 ||
        parent.clipBehavior == .none ||
        !identical(root, parent.center) ||
        !identical(root, parent.firstChild) ||
        parent.childAfter(root) != null) {
      return null;
    }

    final scrollPosition = parent.offset;
    if (scrollPosition is! ScrollPositionWithSingleContext ||
        scrollPosition.runtimeType != ScrollPositionWithSingleContext ||
        !_usesStandardScrollPhysics(scrollPosition.physics)) {
      return null;
    }

    final result = _FixedTextRow(
      row,
      sliver,
      parent,
      root,
      scrollPosition,
      children,
      widget,
      count,
      data.index!,
      sliver.itemExtent,
      parent.constraints,
      sliver.constraints.viewportMainAxisExtent,
      sliver.constraints.crossAxisExtent,
    );
    return result.outsidePaintRange() == null ? null : result;
  }

  // A custom scroll position or physics can silently reveal a row between two
  // viewport layout attempts that give the row identical box constraints.
  static bool _usesStandardScrollPhysics(ScrollPhysics physics) {
    for (ScrollPhysics? current = physics; current != null; current = current.parent) {
      final type = current.runtimeType;
      if (type != ScrollPhysics &&
          type != ClampingScrollPhysics &&
          type != BouncingScrollPhysics &&
          type != RangeMaintainingScrollPhysics &&
          type != AlwaysScrollableScrollPhysics &&
          type != NeverScrollableScrollPhysics) {
        return false;
      }
    }
    return true;
  }

  // null means the original geometry can no longer certify visibility.
  bool? outsidePaintRange({bool afterLayout = false}) {
    final data = row.parentData;
    if (!row.attached ||
        data is! SliverMultiBoxAdaptorParentData ||
        data.keptAlive ||
        data.index != index ||
        !identical(children.widget, sliverWidget) ||
        children.estimatedChildCount != childCount ||
        sliver.itemExtent != itemExtent ||
        viewport.constraints != viewportConstraints ||
        viewport.anchor != 0 ||
        viewport.axisDirection != .down ||
        viewport.clipBehavior == .none ||
        !identical(viewport.center, viewportChild) ||
        !identical(viewport.firstChild, viewportChild) ||
        viewport.childAfter(viewportChild) != null ||
        !identical(viewportChild.parent, viewport) ||
        (viewportChild != sliver &&
            (!identical(sliver.parent, viewportChild) ||
                (viewportChild as RenderSliverPadding).padding.resolve(.ltr) != EdgeInsets.zero)) ||
        sliver.constraints.viewportMainAxisExtent != viewportExtent ||
        sliver.constraints.crossAxisExtent != crossExtent ||
        sliver.constraints.axisDirection != .down ||
        sliver.constraints.growthDirection != .forward ||
        sliver.constraints.overlap != 0 ||
        !identical(viewport.offset, scrollPosition) ||
        !scrollPosition.hasPixels) {
      return null;
    }
    final pixels = scrollPosition.pixels;
    final extent = sliver.constraints.viewportMainAxisExtent;
    final maxPixels = childCount * itemExtent - extent;
    if (!(pixels >= 0 && pixels <= maxPixels) ||
        (afterLayout &&
            (sliver.constraints.scrollOffset != pixels || sliver.constraints.remainingPaintExtent != extent))) {
      return null;
    }
    final start = index * itemExtent - pixels;
    return start >= extent || start + itemExtent <= 0;
  }
}

class _HiddenTextMotion {
  new(this.row, this.constraints, this.template, this.step, this.baseText, _HiddenTextChange first) : changes = [first];

  static const _historyLimit = 8;
  static const _maximumPendingHistory = 32;
  // Every laid-out held row can enqueue one input per frame. Reserve enough
  // room to drain the shared late-burst queue, one row per frame, before any
  // row can make the emergency history limit a simultaneous replay.
  static const int _maximumHeldRows = _maximumPendingHistory - _historyLimit - 2;
  static int _heldRows = 0;
  static const _hiddenReplayCodeUnitsPerFrame = 224;
  static Duration? _fallbackBudgetTime;
  static int _fallbackCodeUnits = 0;
  static const _rapidInput = Duration(milliseconds: 80);
  static const _minimumCompactionSpan = Duration(milliseconds: 750);

  final _FixedTextRow row;
  final BoxConstraints constraints;
  final _PreparedNumeralTemplate template;
  bool nativeTrainingAttempted = false;
  final int step;
  final List<_HiddenTextChange> changes;
  final int fontGeneration = _TextMotionLayout._fontGeneration;
  String baseText;
  bool requestFullReplay = false;

  static int numeralDelta(_PreparedNumeralTemplate template, String before, String after) {
    var delta = 0;
    for (var index = template.numberStart; index < template.numberEnd; index++) {
      final code = after.codeUnitAt(index);
      if (code >= 0x30 && code <= 0x39) {
        delta = 10 * delta + (code - before.codeUnitAt(index));
      }
    }
    return delta;
  }

  void update(String data, Duration now) {
    final previous = changes.last;
    final interval = now - previous.startsAt;
    if (!template._matches(data) ||
        !template._matches(previous.text) ||
        numeralDelta(template, previous.text, data) != step ||
        (changes.length < 3 && interval > Duration.zero && interval < _rapidInput)) {
      requestFullReplay = true;
    }
    if (!requestFullReplay && changes.length == _historyLimit) {
      var rapidGaps = interval < _rapidInput ? 1 : 0;
      for (var index = 1; index < changes.length; index++) {
        if (changes[index].startsAt - changes[index - 1].startsAt < _rapidInput) rapidGaps++;
      }
      final validToForget = now - changes.first.startsAt >= _minimumCompactionSpan && rapidGaps <= 1;
      if (validToForget) {
        baseText = changes.removeAt(0).text;
      } else {
        requestFullReplay = true;
      }
    }
    if (previous.startsAt == now) {
      changes[changes.length - 1] = (text: data, startsAt: now);
    } else {
      changes.add((text: data, startsAt: now));
    }
  }

  bool takeHiddenReplayBudget(Duration now) {
    if (_fallbackBudgetTime != now) {
      _fallbackBudgetTime = now;
      _fallbackCodeUnits = 0;
    }
    final units = baseText.length + changes.fold<int>(0, (total, target) => total + target.text.length);
    if (changes.length < _maximumPendingHistory &&
        _fallbackCodeUnits != 0 &&
        _fallbackCodeUnits + units > _hiddenReplayCodeUnitsPerFrame) {
      return false;
    }
    _fallbackCodeUnits += units;
    return true;
  }

  _ActiveTextMotion? replayBeforeCurrent(
    _RenderMateoTextMotion render,
    RenderParagraph paragraph, {
    _PreparedNumeralBank? bank,
  }) {
    final initial = _TextMotionLayout.acquireForReplay(paragraph, baseText, constraints);
    if (!initial.canAnimate) {
      initial.dispose();
      return null;
    }
    final metrics = initial._measuredNumericMetrics;
    final prepared = bank?.prepare(baseText, template, initial);
    if (prepared != null) {
      initial.dispose();
    }
    var motion = _ActiveTextMotion(prepared ?? initial, constraints);
    final separator = _RenderMateoTextMotion._decimalSeparator(paragraph.locale);
    for (var index = 0; index < changes.length - 1; index++) {
      final change = changes[index];
      final target = bank?.prepare(change.text, template, motion.source!.layout);
      final endpoint =
          target ??
          _TextMotionLayout.acquireForReplay(paragraph, change.text, constraints, knownNumericMetrics: metrics);
      if (target == null && bank != null && !bank.observe(endpoint, template)) {
        endpoint.dispose();
        motion.dispose(keepGeometry: false);
        return replayBeforeCurrent(render, paragraph);
      }
      if (!endpoint.canAnimate) {
        endpoint.dispose();
        motion.dispose(keepGeometry: false);
        return null;
      }
      motion.start(motion.source!, endpoint, separator);
      final elapsed = changes[index + 1].startsAt - change.startsAt;
      if (elapsed < _textMotionDuration) motion.advance(elapsed);
      if (elapsed >= _textMotionDuration || render._canSettleEarly(motion)) {
        endpoint._owners++;
        motion.dispose(keepGeometry: false);
        motion = _ActiveTextMotion(endpoint, constraints);
      } else {
        motion.interrupt();
      }
    }
    return motion;
  }
}
