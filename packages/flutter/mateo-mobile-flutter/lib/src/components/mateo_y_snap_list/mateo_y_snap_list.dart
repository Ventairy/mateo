library;

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mateo_mobile_old/src/components/mateo_dots_loading_indicator/mateo_dots_loading_indicator.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

part 'mateo_y_snap_list_cached_item.dart';
part 'mateo_y_snap_list_controller.dart';
part 'mateo_y_snap_list_enums.dart';
part 'mateo_y_snap_list_loading_indicator.dart';
part 'mateo_y_snap_list_types.dart';
part 'mateo_y_snap_list_viewport.dart';
part 'mateo_y_snap_list_window.dart';

/// A Mateo Y-Snap List that presents one item at a time.
///
/// Swipe **up** → next item; swipe **down** → previous item.
/// Smooth animated transitions with fling-to-commit.
///
/// Vertical scrollables inside the active page keep their normal scrolling
/// behavior until they reach an edge. At an edge with an adjacent page, the
/// drag transfers to the list without platform overscroll. At an edge with no
/// adjacent page, the scrollable keeps its native boundary behavior, including
/// iOS bounce, when its content genuinely overflows. A scrollable with no
/// scroll extent stays still in both directions.
///
/// The parent MUST supply a bounded height (e.g. `Expanded`, `SizedBox`,
/// full-screen `Scaffold` body) — the widget throws [FlutterError] if the
/// vertical constraints are unbounded.
///
/// ```dart
/// MateoYSnapList<String>(
///   items: (
///     count: items.length,
///     provider: (i) => items[i],
///     keyBuilder: null,
///   ),
///   builder: (context, item, index) => ItemCard(item: item),
///   onNext: (item, index) => print('Left $item behind'),
/// )
/// ```
class MateoYSnapList<T> extends StatefulWidget {
  /// Creates a Mateo Y-Snap List.
  MateoYSnapList({
    required this.items,
    required this.builder,
    super.key,
    this.controller,
    this.loadMoreErrorBuilder,
    this.endBuilder,
    this.spacing = 0,
    this.onSwipeProgress,
    this.onNext,
    this.onPrevious,
    this.onLoadMore,
    this.onMotionStart,
    this.onMotionEnd,
    this.loadMoreThreshold = 1,
    this.loadingMoreOffset = 200,
  }) : assert(
         loadMoreThreshold >= 0 && loadMoreThreshold <= 1,
         'loadMoreThreshold must be greater than or equal to 0 and less than or equal to 1.',
       ),
       assert(
         loadingMoreOffset >= 0,
         'loadingMoreOffset must be greater than or equal to 0.',
       ),
       assert(spacing >= 0, 'spacing must be greater than or equal to 0.'),
       assert(
         items.count >= 0,
         'items.count must be greater than or equal to 0.',
       );

  /// Items for the list as a record of `count`, `provider`, and optional
  /// `keyBuilder`.
  ///
  /// ## Fields
  ///
  /// * `count` — total number of items in the list.
  /// * `provider` — lazy accessor called only for the current and adjacent
  ///   indexes. Must return a non-null item for every valid index in
  ///   `0..count - 1`.
  /// * `keyBuilder` — optional stable identity for an item. See below.
  ///
  /// ## When to provide `keyBuilder`
  ///
  /// Provide `keyBuilder` when items have a **stable identity** that
  /// survives list mutations — typically a database ID, UUID, or natural
  /// key. Stable keys let the list preserve each card's underlying
  /// `Element` and `State` as the user swipes between positions and as
  /// pagination inserts or reorders items.
  ///
  /// Without a stable key, the list falls back to the item **index**. This
  /// is safe for static lists that never change after initial load, but
  /// breaks down when the list mutates: if pagination prepends new items,
  /// every card's index shifts and the `Element` tree reuses the wrong
  /// `State` for each item — causing stale content, lost scroll position,
  /// or visual glitches.
  ///
  /// ### Example: stable IDs
  ///
  /// ```dart
  /// MateoYSnapList<Job>(
  ///   items: (
  ///     count: jobs.length,
  ///     provider: (i) => jobs[i],
  ///     keyBuilder: (job, index) => job.id,
  ///   ),
  ///   builder: (context, job, index) => JobCard(job: job),
  /// )
  /// ```
  ///
  /// ## When to omit `keyBuilder`
  ///
  /// Omit `keyBuilder` when items lack a stable identity or when the list's
  /// item list is immutable after the initial load. The index-based
  /// fallback is lightweight and correct for fixed-length, append-only, or
  /// non-paginated feeds.
  ///
  /// ## Key uniqueness
  ///
  /// Keys returned by `keyBuilder` must be unique across all items in the
  /// list. Duplicate keys cause undefined behavior in the internal card
  /// cache and may result in stale or mismatched cards being displayed.
  final MateoYSnapListItems<T> items;

  /// Builds the widget for each list item.
  ///
  /// A descendant vertical scrollable hands an outward boundary drag to the
  /// adjacent list page when one exists. Its platform boundary behavior is
  /// preserved on an edge without an adjacent page when its content overflows.
  /// Content with no scroll extent provides no overscroll feedback.
  final MateoYSnapListItemBuilder<T> builder;

  /// Controls this list from parent code.
  final MateoYSnapListController? controller;

  /// Builds the load-more error card shown at the end of the list.
  ///
  /// When this builder is non-null, the list treats pagination as errored and
  /// shows the returned card instead of automatically requesting more items.
  /// A descendant vertical scrollable hands a downward drag at its top edge
  /// back to the last loaded item.
  final MateoYSnapListLoadMoreErrorBuilder? loadMoreErrorBuilder;

  /// Builds content when pagination ends after all loaded cards are dismissed.
  ///
  /// A descendant vertical scrollable hands a downward drag at its top edge
  /// back to the last loaded item. Its bottom edge keeps the platform's native
  /// boundary behavior when its content overflows because no page follows the
  /// terminal content. Content with no scroll extent provides no overscroll
  /// feedback.
  final WidgetBuilder? endBuilder;

  /// Called whenever the swipe position changes.
  ///
  /// This callback runs synchronously with pointer and animation updates. Keep
  /// its work lightweight so it does not consume the list's frame budget.
  final MateoYSnapListProgressCallback? onSwipeProgress;

  /// Called when the list advances to the next item.
  final MateoYSnapListItemCallback<T>? onNext;

  /// Called when the list goes back to the previous item.
  final MateoYSnapListItemCallback<T>? onPrevious;

  /// Called when the current index reaches [loadMoreThreshold].
  final MateoYSnapListLoadMoreCallback? onLoadMore;

  /// Called once when a drag or programmatic settle motion begins.
  final VoidCallback? onMotionStart;

  /// Called once after a drag or programmatic settle motion completes.
  final VoidCallback? onMotionEnd;

  /// Loaded-list progress required to call [onLoadMore].
  final double loadMoreThreshold;

  /// How many pixels the current card lifts up while loading more items.
  ///
  /// When the user is on the last card and [onLoadMore] is in flight, swiping
  /// up reveals the loading indicator below the card. This property controls
  /// how far the card translates upward to make room for the indicator.
  ///
  /// * A value of `0` disables the lift entirely (the card stays in place).
  /// * Larger values push the card higher, creating more visible space for
  ///   the loading animation.
  ///
  /// The dragging feel is always 1:1 with the finger, clamped to this value.
  ///
  /// Defaults to `200` (pixels).
  final double loadingMoreOffset;

  /// Vertical gap between the current card and its adjacent cards.
  ///
  /// The current card always settles at the same position regardless of this
  /// value. Changing [spacing] only adjusts the visible gap to the next and
  /// previous cards during a swipe — the settled card position is preserved.
  ///
  /// Defaults to `0` (cards sit edge-to-edge).
  ///
  /// ```dart
  /// MateoYSnapList<String>(
  ///   items: (count: jobs.length, provider: (i) => jobs[i], keyBuilder: null),
  ///   spacing: 12,
  ///   builder: (context, job, index) => JobCard(job: job),
  /// )
  /// ```
  final double spacing;

  @override
  State<MateoYSnapList<T>> createState() => _MateoYSnapListState<T>();
}

class _MateoYSnapListState<T> extends State<MateoYSnapList<T>>
    with SingleTickerProviderStateMixin
    implements _MateoYSnapListControllerClient {
  static const _settleDuration = Duration(milliseconds: 260);
  static const _commitDuration = Duration(milliseconds: 180);
  static const _swipeThreshold = 0.25;
  static const _nestedScrollDirectionMinIntentDistance = 10.0;
  static const _scrollBoundaryTolerance = 0.5;
  static const _nestedVelocitySampleCapacity = 20;

  late final AnimationController _animationController;

  Animation<double>? _offsetAnimation;
  double _dragOffsetY = 0;
  MateoYSnapListAction _lastAction = MateoYSnapListAction.next;
  int _currentIndex = 0;
  int? _exhaustedItemCount;
  double _viewportHeight = 1;
  double get _commitDistance => _viewportHeight + widget.spacing;
  bool _isLoadingMore = false;
  bool _isLoadMoreScheduled = false;
  bool _isControllerActionRunning = false;
  bool _isDirectDragActive = false;
  bool _isDirectDragMotionActive = false;
  bool _isMotionActive = false;
  bool _isNestedScrollDragActive = false;
  bool _isStartingScrollHold = false;
  int _motionGeneration = 0;
  int _activeDragGeneration = 0;
  int? _activePointer;
  PointerDeviceKind? _activePointerKind;
  _MateoYSnapListAwaitPhase _awaitPhase = _MateoYSnapListAwaitPhase.inactive;
  MateoYSnapListAction? _nestedScrollAction;
  double _nestedScrollDragOffset = 0;
  Offset _nestedScrollIntentOffset = Offset.zero;
  double _awaitDragProgress = 0;
  bool _isCommitting = false;
  Animation<double>? _loadingLiftAnimation;
  ScrollHoldController? _activeScrollHold;
  BuildContext? _activeScrollNotificationContext;
  ScrollPosition? _activeScrollPosition;
  Duration? _pointerDownTimeStamp;
  Offset? _pointerDownPosition;
  Duration? _latestPointerTimeStamp;
  Offset? _latestPointerPosition;
  VelocityTracker? _velocityTracker;
  final Map<Object, _MateoYSnapListCachedItem<T>> _cardCache = <Object, _MateoYSnapListCachedItem<T>>{};
  final Map<int, _MateoYSnapListCachedItem<T>> _indexedCardCache = <int, _MateoYSnapListCachedItem<T>>{};
  final List<Duration?> _nestedVelocitySampleTimes = List<Duration?>.filled(
    _nestedVelocitySampleCapacity,
    null,
    growable: false,
  );
  final List<Offset?> _nestedVelocitySamplePositions = List<Offset?>.filled(
    _nestedVelocitySampleCapacity,
    null,
    growable: false,
  );
  int _nestedVelocitySampleCount = 0;
  int _nestedVelocitySampleWriteIndex = 0;

  final ValueNotifier<double> _dragOffsetNotifier = ValueNotifier<double>(0);
  final ValueNotifier<double> _loadingLiftNotifier = ValueNotifier<double>(0);
  final ValueNotifier<bool> _cardMotionNotifier = ValueNotifier<bool>(false);

  bool get _hasCurrentItem => _currentIndex < widget.items.count;
  bool get _hasPreviousTarget => _currentIndex > 0;
  bool get _shouldShowLoadMoreErrorCard => widget.loadMoreErrorBuilder != null;

  bool get _hasNextTarget {
    if (!_hasCurrentItem) return false;
    if (_currentIndex + 1 < widget.items.count) return true;
    if (_isLoadingMore || _paginationMayBringMore || _shouldShowLoadMoreErrorCard) return true;

    return widget.endBuilder != null;
  }

  bool get _canEnterAwaitMode => _hasCurrentItem && _currentIndex + 1 >= widget.items.count && _isLoadingMore;

  bool get _isAwaitDeciding => _awaitPhase == _MateoYSnapListAwaitPhase.deciding;

  bool get _isAwaitDragging => _awaitPhase == _MateoYSnapListAwaitPhase.dragging;

  bool get _isAwaitWaiting => _awaitPhase == _MateoYSnapListAwaitPhase.waiting;

  bool get _isAwaitActive => _isAwaitDragging || _isAwaitWaiting;

  bool get _paginationMayBringMore =>
      widget.onLoadMore != null && !_shouldShowLoadMoreErrorCard && _exhaustedItemCount != widget.items.count;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _settleDuration,
    )..addListener(_syncAnimatedOffset);

    widget.controller?._attach(this);

    _scheduleLoadMoreIfNeeded();
  }

  @override
  void didUpdateWidget(covariant MateoYSnapList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Widget updates may replace, reorder, or mutate the item source. Indexed
    // entries are trusted only across this State's own window rotations.
    _indexedCardCache.clear();

    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }

    if (_currentIndex > widget.items.count) {
      _currentIndex = widget.items.count;
      _dragOffsetY = 0;
      _dragOffsetNotifier.value = 0;
    }

    if (widget.items.count > oldWidget.items.count || widget.items.count > (_exhaustedItemCount ?? -1)) {
      _exhaustedItemCount = null;
    }

    if (widget.items.count != oldWidget.items.count) {
      _scheduleLoadMoreIfNeeded();
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    _releaseActiveScrollHold();

    _animationController
      ..removeListener(_syncAnimatedOffset)
      ..dispose();

    _dragOffsetNotifier.dispose();
    _loadingLiftNotifier.dispose();
    _cardMotionNotifier.dispose();
    _cardCache.clear();
    _indexedCardCache.clear();

    super.dispose();
  }

  void _syncAnimatedOffset() {
    final offsetAnimation = _offsetAnimation;
    final loadingLiftAnimation = _loadingLiftAnimation;
    if (offsetAnimation != null) {
      _setDragOffset(offsetAnimation.value);
    }

    if (loadingLiftAnimation != null) {
      _loadingLiftNotifier.value = loadingLiftAnimation.value;
    }
  }

  void _onVerticalDragStart(DragStartDetails details) {
    if (_isControllerActionRunning || _isNestedScrollDragActive) return;

    _animationController.stop(canceled: false);
    _isDirectDragActive = true;
    _isDirectDragMotionActive = false;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_isControllerActionRunning || !_isDirectDragActive) return;

    if (!_isDirectDragMotionActive) {
      if (!_hasTargetForDragDelta(details.delta.dy)) return;

      _isDirectDragMotionActive = true;
      _beginDrag();
    }

    _updateDrag(details.delta.dy);
  }

  Future<void> _onVerticalDragEnd(DragEndDetails details) async {
    if (_isControllerActionRunning || !_isDirectDragActive) return;

    _isDirectDragActive = false;
    if (!_isDirectDragMotionActive) return;

    _isDirectDragMotionActive = false;
    await _finishDrag(velocity: details.velocity);
  }

  void _onVerticalDragCancel() {
    if (_isControllerActionRunning || !_isDirectDragActive) return;

    _isDirectDragActive = false;
    if (!_isDirectDragMotionActive) return;

    _isDirectDragMotionActive = false;
    _cancelDrag();
  }

  bool _hasTargetForDragDelta(double dragDeltaY) {
    if (dragDeltaY < 0) return _hasNextTarget;
    if (dragDeltaY > 0) return _hasPreviousTarget;

    return false;
  }

  void _beginDrag() {
    _animationController.stop(canceled: false);
    _activeDragGeneration = _startMotion();
    _handleAwaitDragStart();
  }

  void _updateDrag(double dragDeltaY) {
    if (dragDeltaY == 0) return;

    if (_isAwaitDeciding) {
      _handleAwaitDecisionUpdate(dragDeltaY);
      return;
    }

    if (_isAwaitActive) {
      _handleAwaitDragUpdate(dragDeltaY);
      return;
    }

    _handleRegularDragUpdate(dragDeltaY);
  }

  Future<void> _finishDrag({required Velocity velocity}) async {
    final motionGeneration = _activeDragGeneration;

    try {
      if (_isAwaitDeciding) {
        _resetAwaitPhase();
        return;
      }

      if (_isAwaitActive) {
        await _finishAwaitDrag(velocity: velocity);
        return;
      }

      await _finishRegularDrag(velocity: velocity);
    } finally {
      _endMotion(motionGeneration);
    }
  }

  void _cancelDrag() {
    final motionGeneration = _activeDragGeneration;

    if (_isAwaitDeciding) {
      _resetAwaitPhase();
      _endMotion(motionGeneration);
      return;
    }

    if (_isAwaitActive) {
      _completeCanceledMotion(
        _exitAwaitDrag(),
        motionGeneration: motionGeneration,
      );
      return;
    }

    if (_isCommitting) {
      _completeCanceledMotion(
        _dragOffsetY < 0 ? _commitNext() : _commitPrevious(),
        motionGeneration: motionGeneration,
      );
      return;
    }

    _completeCanceledMotion(_snapBack(), motionGeneration: motionGeneration);
  }

  void _completeCanceledMotion(
    Future<void> motion, {
    required int motionGeneration,
  }) {
    unawaited(
      motion.whenComplete(() {
        if (!mounted) return;
        _endMotion(motionGeneration);
      }),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    final scrollContext = notification.context;
    if (scrollContext == null) return false;

    final isUserScrollStart =
        notification is ScrollStartNotification && notification.dragDetails != null && _activePointer != null;
    if (isUserScrollStart) {
      _releaseActiveScrollHold();
      _activeScrollNotificationContext = scrollContext;
      _activeScrollPosition = Scrollable.of(scrollContext).position;
      _startNestedVelocitySampling();
      _resetNestedScrollIntent();
    } else if (!identical(scrollContext, _activeScrollNotificationContext)) {
      return false;
    }

    if (_activeScrollPosition == null) return false;

    if (notification is ScrollUpdateNotification || notification is OverscrollNotification) {
      _correctActiveScrollPosition();
    }

    if (notification is ScrollEndNotification && _activePointer == null && !_isNestedScrollDragActive) {
      _activeScrollPosition = null;
      _activeScrollNotificationContext = null;
    }

    return false;
  }

  void _correctActiveScrollPosition() {
    final scrollPosition = _activeScrollPosition;
    if (scrollPosition == null) return;

    final hasScrollExtent = scrollPosition.maxScrollExtent - scrollPosition.minScrollExtent > _scrollBoundaryTolerance;
    if (!hasScrollExtent) {
      if (scrollPosition.pixels != scrollPosition.minScrollExtent) {
        scrollPosition.correctPixels(scrollPosition.minScrollExtent);
      }
      return;
    }

    if (_hasPreviousTarget && scrollPosition.pixels < scrollPosition.minScrollExtent) {
      scrollPosition.correctPixels(scrollPosition.minScrollExtent);
      return;
    }

    if (_hasNextTarget && scrollPosition.pixels > scrollPosition.maxScrollExtent) {
      scrollPosition.correctPixels(scrollPosition.maxScrollExtent);
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_activePointer != null) return;

    _activePointer = event.pointer;
    _activePointerKind = event.kind;
    _pointerDownTimeStamp = event.timeStamp;
    _pointerDownPosition = event.position;
    _latestPointerTimeStamp = event.timeStamp;
    _latestPointerPosition = event.position;
    _velocityTracker = null;
    _activeScrollPosition = null;
    _activeScrollNotificationContext = null;
    _resetNestedScrollIntent();
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_activePointer != event.pointer) return;

    _latestPointerTimeStamp = event.timeStamp;
    _latestPointerPosition = event.position;
    _trackNestedVelocitySample(event.timeStamp, event.position);
    if (_activeScrollPosition == null) return;

    if (_isNestedScrollDragActive) {
      _updateNestedScrollDrag(event.delta.dy);
      _correctActiveScrollPosition();
      return;
    }

    final action = _nestedScrollActionFor(event.delta);
    if (action == null) {
      _resetNestedScrollIntent();
      return;
    }

    if (_nestedScrollAction != action) {
      _nestedScrollAction = action;
      _nestedScrollIntentOffset = Offset.zero;
    }

    _nestedScrollIntentOffset += event.delta;
    if (_nestedScrollIntentOffset.dy.abs() < _nestedScrollDirectionMinIntentDistance ||
        _nestedScrollIntentOffset.dy.abs() <= _nestedScrollIntentOffset.dx.abs()) {
      return;
    }

    _startNestedScrollDrag();
  }

  void _startNestedVelocitySampling() {
    _velocityTracker = null;
    _nestedVelocitySampleCount = 0;
    _nestedVelocitySampleWriteIndex = 0;

    final downTimeStamp = _pointerDownTimeStamp;
    final downPosition = _pointerDownPosition;
    if (downTimeStamp == null || downPosition == null) return;

    _bufferNestedVelocitySample(downTimeStamp, downPosition);
    final latestTimeStamp = _latestPointerTimeStamp;
    final latestPosition = _latestPointerPosition;
    if (latestTimeStamp != null && latestPosition != null && latestTimeStamp != downTimeStamp) {
      _bufferNestedVelocitySample(latestTimeStamp, latestPosition);
    }
  }

  void _trackNestedVelocitySample(Duration timeStamp, Offset position) {
    final velocityTracker = _velocityTracker;
    if (velocityTracker != null) {
      velocityTracker.addPosition(timeStamp, position);
      return;
    }

    if (_activeScrollPosition != null) {
      _bufferNestedVelocitySample(timeStamp, position);
    }
  }

  void _bufferNestedVelocitySample(Duration timeStamp, Offset position) {
    _nestedVelocitySampleTimes[_nestedVelocitySampleWriteIndex] = timeStamp;
    _nestedVelocitySamplePositions[_nestedVelocitySampleWriteIndex] = position;
    _nestedVelocitySampleWriteIndex = (_nestedVelocitySampleWriteIndex + 1) % _nestedVelocitySampleCapacity;
    if (_nestedVelocitySampleCount < _nestedVelocitySampleCapacity) {
      _nestedVelocitySampleCount += 1;
    }
  }

  void _materializeNestedVelocityTracker() {
    if (_velocityTracker != null) return;

    final pointerKind = _activePointerKind;
    if (pointerKind == null) return;

    final velocityTracker = VelocityTracker.withKind(pointerKind);
    var sampleIndex =
        (_nestedVelocitySampleWriteIndex - _nestedVelocitySampleCount + _nestedVelocitySampleCapacity) %
        _nestedVelocitySampleCapacity;
    for (var replayed = 0; replayed < _nestedVelocitySampleCount; replayed += 1) {
      velocityTracker.addPosition(
        _nestedVelocitySampleTimes[sampleIndex]!,
        _nestedVelocitySamplePositions[sampleIndex]!,
      );
      sampleIndex = (sampleIndex + 1) % _nestedVelocitySampleCapacity;
    }

    _velocityTracker = velocityTracker;
  }

  MateoYSnapListAction? _nestedScrollActionFor(Offset pointerDelta) {
    final scrollPosition = _activeScrollPosition;
    if (scrollPosition == null || _isControllerActionRunning || _isDirectDragActive) {
      return null;
    }

    final isAtTop = scrollPosition.pixels <= scrollPosition.minScrollExtent + _scrollBoundaryTolerance;
    if (pointerDelta.dy > 0 && isAtTop && _hasPreviousTarget) {
      return MateoYSnapListAction.previous;
    }

    final isAtBottom = scrollPosition.pixels >= scrollPosition.maxScrollExtent - _scrollBoundaryTolerance;
    if (pointerDelta.dy < 0 && isAtBottom && _hasNextTarget) {
      return MateoYSnapListAction.next;
    }

    return null;
  }

  void _startNestedScrollDrag() {
    _materializeNestedVelocityTracker();
    _isNestedScrollDragActive = true;
    _nestedScrollDragOffset = 0;
    _holdActiveScrollPosition();
    _correctActiveScrollPosition();
    _beginDrag();
    _updateNestedScrollDrag(_nestedScrollIntentOffset.dy);
  }

  void _updateNestedScrollDrag(double pointerDeltaY) {
    final action = _nestedScrollAction;
    if (action == null) return;

    final nextDragOffset = switch (action) {
      MateoYSnapListAction.previous => (_nestedScrollDragOffset + pointerDeltaY).clamp(0.0, double.infinity),
      MateoYSnapListAction.next => (_nestedScrollDragOffset + pointerDeltaY).clamp(double.negativeInfinity, 0.0),
    };
    final dragDelta = nextDragOffset - _nestedScrollDragOffset;
    _nestedScrollDragOffset = nextDragOffset;
    _updateDrag(dragDelta);
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_activePointer != event.pointer) return;

    _velocityTracker?.addPosition(event.timeStamp, event.position);
    final wasNestedScrollDragActive = _isNestedScrollDragActive;
    final velocity = wasNestedScrollDragActive ? _velocityTracker?.getVelocity() ?? Velocity.zero : Velocity.zero;
    _resetPointerTracking(clearScrollPosition: wasNestedScrollDragActive);
    if (!wasNestedScrollDragActive) return;

    unawaited(_finishDrag(velocity: velocity));
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_activePointer != event.pointer) return;

    final wasNestedScrollDragActive = _isNestedScrollDragActive;
    _resetPointerTracking(clearScrollPosition: wasNestedScrollDragActive);
    if (!wasNestedScrollDragActive) return;

    _cancelDrag();
  }

  void _holdActiveScrollPosition() {
    if (_activeScrollHold != null || _isStartingScrollHold) return;

    final scrollPosition = _activeScrollPosition;
    if (scrollPosition == null) return;

    _isStartingScrollHold = true;
    try {
      _activeScrollHold = scrollPosition.hold(() {
        _activeScrollHold = null;
      });
    } finally {
      _isStartingScrollHold = false;
    }
  }

  void _releaseActiveScrollHold() {
    final activeScrollHold = _activeScrollHold;
    if (activeScrollHold == null) return;

    _activeScrollHold = null;
    activeScrollHold.cancel();
  }

  void _resetNestedScrollIntent() {
    if (_isNestedScrollDragActive) return;

    _nestedScrollAction = null;
    _nestedScrollIntentOffset = Offset.zero;
  }

  void _resetPointerTracking({bool clearScrollPosition = true}) {
    _activePointer = null;
    _activePointerKind = null;
    _isNestedScrollDragActive = false;
    _nestedScrollAction = null;
    _nestedScrollDragOffset = 0;
    _nestedScrollIntentOffset = Offset.zero;
    _pointerDownTimeStamp = null;
    _pointerDownPosition = null;
    _latestPointerTimeStamp = null;
    _latestPointerPosition = null;
    _velocityTracker = null;
    _nestedVelocitySampleCount = 0;
    _nestedVelocitySampleWriteIndex = 0;
    if (clearScrollPosition) {
      _activeScrollPosition = null;
      _activeScrollNotificationContext = null;
    }
    _releaseActiveScrollHold();
  }

  void _handleAwaitDragStart() {
    if (!_canEnterAwaitMode) return;

    if (_isAwaitWaiting) {
      _awaitDragProgress = 1.0;
      _loadingLiftNotifier.value = -widget.loadingMoreOffset;
      return;
    }

    _awaitPhase = _MateoYSnapListAwaitPhase.deciding;
  }

  void _handleAwaitDecisionUpdate(double dragDeltaY) {
    if (dragDeltaY == 0) return;

    _awaitPhase = _MateoYSnapListAwaitPhase.inactive;

    if (dragDeltaY < 0 && _canEnterAwaitMode) {
      setState(() {
        _awaitPhase = _MateoYSnapListAwaitPhase.dragging;
        _loadingLiftNotifier.value = dragDeltaY.clamp(
          -widget.loadingMoreOffset,
          0.0,
        );
        _awaitDragProgress = _progressForLoadingLift(
          _loadingLiftNotifier.value,
        );
      });
      return;
    }

    _setDragOffset(_dragOffsetY + dragDeltaY);
  }

  void _handleAwaitDragUpdate(double dragDeltaY) {
    final loadingLift = (_loadingLiftNotifier.value + dragDeltaY).clamp(-widget.loadingMoreOffset, 0.0);
    if (loadingLift == _loadingLiftNotifier.value) return;

    _loadingLiftNotifier.value = loadingLift;
    _awaitDragProgress = _progressForLoadingLift(loadingLift);

    widget.onSwipeProgress?.call(
      action: MateoYSnapListAction.next,
      percentage: _awaitDragProgress,
    );
  }

  void _handleRegularDragUpdate(double dragDeltaY) {
    final minimumOffset = _hasNextTarget ? double.negativeInfinity : 0.0;
    final maximumOffset = _hasPreviousTarget ? double.infinity : 0.0;
    final nextOffset = (_dragOffsetY + dragDeltaY).clamp(minimumOffset, maximumOffset);

    _setDragOffset(nextOffset);
  }

  Future<void> _finishAwaitDrag({required Velocity velocity}) async {
    if (_isAwaitWaiting) {
      await _finishWaitingAwaitDrag(velocity: velocity);
      return;
    }

    if (_shouldCommitAwait(velocity: velocity)) {
      await _commitAwaitDrag();
      return;
    }

    await _exitAwaitDrag();
  }

  Future<void> _finishWaitingAwaitDrag({required Velocity velocity}) async {
    if (_shouldExitWaiting(velocity: velocity)) {
      await _exitAwaitDrag();
      return;
    }

    await _settleBackToAwait();
  }

  Future<void> _finishRegularDrag({required Velocity velocity}) async {
    final shouldCommit = _shouldCommitSwipe(velocity: velocity);

    if (!shouldCommit) {
      await _snapBack();
      return;
    }

    final isNextSwipe = _isNextSwipe(velocity: velocity);

    if (isNextSwipe && _hasCurrentItem) {
      await _commitNext();
      return;
    }

    if (!isNextSwipe && _currentIndex > 0) {
      await _commitPrevious();
      return;
    }

    await _snapBack();
  }

  bool _shouldCommitSwipe({required Velocity velocity}) {
    final progress = (_dragOffsetY.abs() / _viewportHeight).clamp(0, 1);

    return progress >= _swipeThreshold ||
        velocity.isSwipeUp(requireVerticalDominance: false) ||
        velocity.isSwipeDown(requireVerticalDominance: false);
  }

  bool _isNextSwipe({required Velocity velocity}) {
    return _dragOffsetY < 0 || (_dragOffsetY == 0 && velocity.isSwipeUp(requireVerticalDominance: false));
  }

  bool _shouldCommitAwait({required Velocity velocity}) {
    final metThreshold =
        _awaitDragProgress >= _swipeThreshold ||
        velocity.isSwipeUp(requireVerticalDominance: false) ||
        velocity.isSwipeDown(requireVerticalDominance: false);

    return metThreshold && (_awaitDragProgress > 0 || velocity.isSwipeUp(requireVerticalDominance: false));
  }

  bool _shouldExitWaiting({required Velocity velocity}) {
    return velocity.pixelsPerSecond.dy > 0 || _awaitDragProgress < 0.95;
  }

  Future<void> _commitAwaitDrag() async {
    _awaitPhase = _MateoYSnapListAwaitPhase.waiting;
    await _animateLoadingLift(
      to: -widget.loadingMoreOffset,
      duration: _settleDuration,
    );

    if (!mounted) return;

    _loadingLiftNotifier.value = -widget.loadingMoreOffset;
  }

  Future<void> _exitAwaitDrag() async {
    await _animateLoadingLift(to: 0, duration: _settleDuration);

    if (!mounted) return;

    setState(_resetAwaitPhase);
  }

  Future<void> _settleBackToAwait() async {
    await _animateLoadingLift(
      to: -widget.loadingMoreOffset,
      duration: _settleDuration,
    );

    if (!mounted) return;

    _awaitPhase = _MateoYSnapListAwaitPhase.waiting;
    _loadingLiftNotifier.value = -widget.loadingMoreOffset;
  }

  Future<void> _commitNext() async {
    if (!_hasCurrentItem) return;

    _isCommitting = true;
    try {
      if (_currentIndex + 1 >= widget.items.count && _paginationMayBringMore) {
        await _enterAwaitModeFromCommit();
        return;
      }

      final itemIndex = _currentIndex;
      final item = (_indexedCardCache[itemIndex] ?? _cardFor(index: itemIndex)).item;

      await _animateTo(
        -_commitDistance,
        duration: _commitDuration,
        curve: Curves.easeOutCubic,
      );

      if (!mounted) return;

      setState(() {
        _currentIndex += 1;
        _dragOffsetY = 0;
      });

      _dragOffsetNotifier.value = 0;

      widget.onNext?.call(item, itemIndex);
      widget.controller?._notify(MateoYSnapListNotification.nextItem);
      _scheduleLoadMoreIfNeeded();
    } finally {
      _isCommitting = false;
    }
  }

  Future<void> _enterAwaitModeFromCommit() async {
    setState(() {
      _awaitPhase = _MateoYSnapListAwaitPhase.waiting;
      _awaitDragProgress = 1.0;
    });

    await _animateIntoAwait();

    if (!mounted) return;

    _dragOffsetY = 0;
    _loadingLiftNotifier.value = -widget.loadingMoreOffset;

    _dragOffsetNotifier.value = 0;

    _scheduleLoadMoreIfNeeded();
  }

  Future<void> _animateIntoAwait() async {
    await _animateFeedPosition(
      offsetTarget: 0,
      loadingLiftTarget: -widget.loadingMoreOffset,
      duration: _settleDuration,
    );
  }

  Future<void> _commitPrevious() async {
    final itemIndex = _currentIndex;
    final hadRealItem = _hasCurrentItem;
    late final T item;
    if (hadRealItem) {
      item = (_indexedCardCache[itemIndex] ?? _cardFor(index: itemIndex)).item;
    }

    _isCommitting = true;
    try {
      await _animateTo(
        _commitDistance,
        duration: _commitDuration,
        curve: Curves.easeOutCubic,
      );
    } finally {
      _isCommitting = false;
    }

    if (!mounted) return;

    setState(() {
      _currentIndex -= 1;
      _dragOffsetY = 0;
    });

    _dragOffsetNotifier.value = 0;

    if (hadRealItem) {
      widget.onPrevious?.call(item, itemIndex);
    }
  }

  Future<void> _snapBack() async {
    await _animateTo(0, duration: _settleDuration);
  }

  Future<void> _animateTo(
    double target, {
    required Duration duration,
    Curve curve = Curves.easeOutCubic,
  }) {
    return _animateFeedPosition(
      offsetTarget: target,
      duration: duration,
      curve: curve,
    );
  }

  Future<void> _animateLoadingLift({
    required double to,
    required Duration duration,
    Curve curve = Curves.easeOutCubic,
  }) {
    return _animateFeedPosition(
      loadingLiftTarget: to,
      duration: duration,
      curve: curve,
    );
  }

  Future<void> _animateCommitFromAwait() async {
    await _animateFeedPosition(
      offsetTarget: -_commitDistance,
      loadingLiftTarget: 0,
      duration: _commitDuration,
    );
  }

  Future<void> _animateFeedPosition({
    required Duration duration,
    double? offsetTarget,
    double? loadingLiftTarget,
    Curve curve = Curves.easeOutCubic,
  }) {
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (disableAnimations) {
      _applyAnimationTargets(
        offsetTarget: offsetTarget,
        loadingLiftTarget: loadingLiftTarget,
      );
      return Future<void>.value();
    }

    final shouldAnimateOffset = offsetTarget != null && _dragOffsetY != offsetTarget;
    final shouldAnimateLoadingLift = loadingLiftTarget != null && _loadingLiftNotifier.value != loadingLiftTarget;

    if (!shouldAnimateOffset && !shouldAnimateLoadingLift) {
      _applyAnimationTargets(
        offsetTarget: offsetTarget,
        loadingLiftTarget: loadingLiftTarget,
      );
      return Future<void>.value();
    }

    _offsetAnimation = _offsetAnimationForTarget(
      shouldAnimate: shouldAnimateOffset,
      target: offsetTarget,
      curve: curve,
    );
    _loadingLiftAnimation = _loadingLiftAnimationForTarget(
      shouldAnimate: shouldAnimateLoadingLift,
      target: loadingLiftTarget,
      curve: curve,
    );

    _animationController
      ..duration = duration
      ..reset();

    return _forwardAnimation();
  }

  Future<void> _forwardAnimation() async {
    try {
      await _animationController.forward().orCancel;
    } on TickerCanceled {
      // Disposing the list cancels its active ticker. The caller already
      // guards post-animation work with mounted checks.
    }
  }

  Animation<double> _doubleAnimation({
    required double from,
    required double to,
    required Curve curve,
  }) {
    return Tween<double>(
      begin: from,
      end: to,
    ).chain(CurveTween(curve: curve)).animate(_animationController);
  }

  Animation<double>? _offsetAnimationForTarget({
    required bool shouldAnimate,
    required double? target,
    required Curve curve,
  }) {
    if (!shouldAnimate || target == null) return null;

    return _doubleAnimation(from: _dragOffsetY, to: target, curve: curve);
  }

  Animation<double>? _loadingLiftAnimationForTarget({
    required bool shouldAnimate,
    required double? target,
    required Curve curve,
  }) {
    if (!shouldAnimate || target == null) return null;

    return _doubleAnimation(
      from: _loadingLiftNotifier.value,
      to: target,
      curve: curve,
    );
  }

  void _applyAnimationTargets({
    required double? offsetTarget,
    required double? loadingLiftTarget,
  }) {
    if (offsetTarget != null) _setDragOffset(offsetTarget);
    if (loadingLiftTarget != null) {
      _loadingLiftNotifier.value = loadingLiftTarget;
    }
  }

  void _resetAwaitPhase() {
    _awaitPhase = _MateoYSnapListAwaitPhase.inactive;
    _awaitDragProgress = 0;
    _loadingLiftNotifier.value = 0;
  }

  double _progressForLoadingLift(double loadingLiftOffset) {
    if (widget.loadingMoreOffset == 0) return 0;

    return (-loadingLiftOffset / widget.loadingMoreOffset).clamp(0.0, 1.0);
  }

  void _setDragOffset(double value) {
    if (value == _dragOffsetY) return;

    final action = value == 0
        ? _lastAction
        : value < 0
        ? MateoYSnapListAction.next
        : MateoYSnapListAction.previous;

    _lastAction = action;
    _dragOffsetY = value;
    _dragOffsetNotifier.value = value;

    widget.onSwipeProgress?.call(
      action: action,
      percentage: (value.abs() / _viewportHeight).clamp(0, 1),
    );
  }

  int _startMotion() {
    _motionGeneration += 1;
    if (_isMotionActive) return _motionGeneration;

    _isMotionActive = true;
    _cardMotionNotifier.value = true;
    try {
      widget.onMotionStart?.call();
    } catch (_) {
      _isMotionActive = false;
      _cardMotionNotifier.value = false;
      rethrow;
    }
    return _motionGeneration;
  }

  void _endMotion(int generation) {
    if (!_isMotionActive || generation != _motionGeneration) return;

    _isMotionActive = false;
    if (!mounted) return;

    _cardMotionNotifier.value = false;
    widget.onMotionEnd?.call();
  }

  void _retryLoadMore() {
    _exhaustedItemCount = null;
    unawaited(_startLoadMore());
  }

  void _scheduleLoadMoreIfNeeded() {
    if (!_shouldLoadMore || _isLoadMoreScheduled) return;

    _isLoadMoreScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoadMoreScheduled = false;
      if (!mounted || !_shouldLoadMore) return;

      unawaited(_startLoadMore());
    });
  }

  bool get _shouldLoadMore {
    final onLoadMore = widget.onLoadMore;

    if (onLoadMore == null ||
        widget.items.count == 0 ||
        _shouldShowLoadMoreErrorCard ||
        _isLoadingMore ||
        _exhaustedItemCount == widget.items.count) {
      return false;
    }

    final loadedProgress = (_currentIndex + 1) / widget.items.count;
    return loadedProgress >= widget.loadMoreThreshold;
  }

  Future<void> _startLoadMore() async {
    final onLoadMore = widget.onLoadMore;
    if (onLoadMore == null || _isLoadingMore) return;

    final itemCountBeforeLoad = widget.items.count;

    setState(() => _isLoadingMore = true);

    try {
      await onLoadMore();
    } catch (error, stackTrace) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _exhaustedItemCount = itemCountBeforeLoad;
          _resetAwaitPhase();
        });
      }

      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'mateo_mobile_old',
          context: ErrorDescription('while loading more MateoYSnapList items'),
        ),
      );
      return;
    }

    if (!mounted) return;

    final hadItemsGrowth = widget.items.count > itemCountBeforeLoad;

    setState(() {
      _isLoadingMore = false;
      if (!hadItemsGrowth) {
        _exhaustedItemCount = itemCountBeforeLoad;
      }
    });

    if (_isAwaitWaiting && mounted) {
      unawaited(_navigateFromAwait());
    }
  }

  Future<void> _navigateFromAwait() async {
    if (!mounted) return;

    _isControllerActionRunning = true;
    final motionGeneration = _startMotion();
    final itemIndex = _currentIndex;
    final item = (_indexedCardCache[itemIndex] ?? _cardFor(index: itemIndex)).item;

    try {
      setState(() {
        _awaitPhase = _MateoYSnapListAwaitPhase.inactive;
        _awaitDragProgress = 0;
      });

      await _animateCommitFromAwait();

      if (!mounted) return;

      setState(() {
        _currentIndex += 1;
        _dragOffsetY = 0;
      });

      _dragOffsetNotifier.value = 0;
      _loadingLiftNotifier.value = 0;

      widget.onNext?.call(item, itemIndex);
      widget.controller?._notify(MateoYSnapListNotification.nextItem);
      _scheduleLoadMoreIfNeeded();
    } finally {
      if (mounted) {
        _endMotion(motionGeneration);
        _isControllerActionRunning = false;
      }
    }
  }

  void _enterAwaitModeFromController() {
    setState(() {
      _awaitPhase = _MateoYSnapListAwaitPhase.waiting;
      _awaitDragProgress = 1.0;
      _loadingLiftNotifier.value = -widget.loadingMoreOffset;
    });
  }

  @override
  Future<bool> nextFromController() async {
    if (_isControllerActionRunning || _isDirectDragActive || _isNestedScrollDragActive || !_hasCurrentItem) {
      return false;
    }

    _animationController.stop(canceled: false);
    _isControllerActionRunning = true;
    final motionGeneration = _startMotion();

    try {
      if (_canEnterAwaitMode) {
        _enterAwaitModeFromController();
        return mounted;
      }

      await _commitNext();
    } finally {
      _endMotion(motionGeneration);
      if (mounted) {
        _isControllerActionRunning = false;
      }
    }

    return mounted;
  }

  @override
  Future<bool> previousFromController() async {
    if (_isControllerActionRunning || _isDirectDragActive || _isNestedScrollDragActive || _currentIndex == 0) {
      return false;
    }

    _animationController.stop(canceled: false);
    _isControllerActionRunning = true;
    final motionGeneration = _startMotion();

    try {
      await _commitPrevious();
    } finally {
      _endMotion(motionGeneration);
      if (mounted) {
        _isControllerActionRunning = false;
      }
    }

    return mounted;
  }

  _MateoYSnapListCachedItem<T> _cardFor({required int index}) {
    final indexedCard = _indexedCardCache[index];
    if (indexedCard != null) return indexedCard;

    final item = widget.items.provider(index);
    final itemKey = widget.items.keyBuilder?.call(item, index) ?? index;
    final cachedCard = _cardCache[itemKey];

    if (cachedCard != null && cachedCard.item == item && cachedCard.index == index) {
      _indexedCardCache[index] = cachedCard;
      return cachedCard;
    }

    final card = _MateoYSnapListCachedItem<T>(
      item: item,
      itemKey: itemKey,
      index: index,
      child: RepaintBoundary(
        child: widget.builder(context, item, index),
      ),
    );

    _cardCache[itemKey] = card;
    _indexedCardCache[index] = card;
    return card;
  }

  void _retainCardWindow({
    required _MateoYSnapListCachedItem<T>? previousCard,
    required _MateoYSnapListCachedItem<T>? currentCard,
    required _MateoYSnapListCachedItem<T>? nextCard,
  }) {
    _cardCache.removeWhere(
      (key, value) => key != previousCard?.itemKey && key != currentCard?.itemKey && key != nextCard?.itemKey,
    );
    _indexedCardCache.removeWhere(
      (index, value) => index != previousCard?.index && index != currentCard?.index && index != nextCard?.index,
    );
  }

  void _ensureBoundedHeight(BoxConstraints constraints) {
    if (constraints.hasBoundedHeight) return;

    throw FlutterError(
      'Vertical viewport was given unbounded height.\n'
      'MateoYSnapList requires its parent widget to have a bounded '
      'height.\n'
      'When the parent widget does not have a bounded height, the list '
      'cannot determine how large to make its pages. Consider wrapping '
      'the MateoYSnapList with an Expanded, a SizedBox, or ensuring the '
      'parent provides bounded constraints.',
    );
  }

  void _syncViewportSize(BoxConstraints constraints) {
    _viewportHeight = constraints.maxHeight;
  }

  _MateoYSnapListWindow<T> _listWindowFor(BuildContext context) {
    final nextIndex = _currentIndex + 1;
    final hasNextItem = nextIndex < widget.items.count;
    final previousCard = _currentIndex > 0 ? _cardFor(index: _currentIndex - 1) : null;
    final currentCard = _hasCurrentItem ? _cardFor(index: _currentIndex) : null;
    final nextCard = hasNextItem ? _cardFor(index: nextIndex) : null;

    _retainCardWindow(
      previousCard: previousCard,
      currentCard: currentCard,
      nextCard: nextCard,
    );

    return _MateoYSnapListWindow<T>(
      previousCard: previousCard,
      currentCard: currentCard,
      nextCard: nextCard,
      paginationCard: _hasCurrentItem ? _buildPaginationCard(context) : null,
      terminalCard: _hasCurrentItem ? null : _buildTerminalCard(context),
    );
  }

  bool _hasGestureTarget(_MateoYSnapListWindow<T> listWindow) {
    return listWindow.currentCard != null || listWindow.previousCard != null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _ensureBoundedHeight(constraints);
        _syncViewportSize(constraints);

        return _buildGestureLayer(_listWindowFor(context));
      },
    );
  }

  Widget _buildGestureLayer(_MateoYSnapListWindow<T> listWindow) {
    final isGestureActive = _hasGestureTarget(listWindow);

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragStart: isGestureActive ? _onVerticalDragStart : null,
          onVerticalDragUpdate: isGestureActive ? _onVerticalDragUpdate : null,
          onVerticalDragEnd: isGestureActive ? _onVerticalDragEnd : null,
          onVerticalDragCancel: isGestureActive ? _onVerticalDragCancel : null,
          child: _buildViewport(listWindow),
        ),
      ),
    );
  }

  Widget _buildViewport(_MateoYSnapListWindow<T> listWindow) {
    return _MateoYSnapListViewport(
      key: const ValueKey('mateo_y_snap_list_viewport'),
      offsetListenable: _dragOffsetNotifier,
      loadingLiftListenable: _loadingLiftNotifier,
      spacing: widget.spacing,
      hasPreviousCard: listWindow.previousCard != null,
      hasNextCard: listWindow.nextCard != null || listWindow.paginationCard != null,
      isAwaitMode: _isAwaitActive,
      loadingMoreOffset: widget.loadingMoreOffset,
      currentCard: _buildCurrentViewportChild(listWindow),
      nextCard: _buildNextViewportChild(listWindow),
      previousCard: _buildPreviousViewportChild(listWindow),
      loadingIndicator: _MateoYSnapListLoadingIndicator(
        visible: _isAwaitActive && widget.loadingMoreOffset > 0,
      ),
    );
  }

  Widget _buildCurrentViewportChild(_MateoYSnapListWindow<T> listWindow) {
    final currentCard = listWindow.currentCard;
    if (currentCard != null) {
      return _retainedCard(card: currentCard, isCurrent: true);
    }

    final terminalCard = listWindow.terminalCard;
    if (terminalCard != null) {
      return _retainedTerminalCard(child: terminalCard, isCurrent: true);
    }

    return const SizedBox.shrink(
      key: ValueKey('mateo_y_snap_list_empty_current'),
    );
  }

  Widget _buildNextViewportChild(_MateoYSnapListWindow<T> listWindow) {
    final nextCard = listWindow.nextCard;
    if (nextCard != null) {
      return _retainedCard(card: nextCard, isCurrent: false);
    }

    final paginationCard = listWindow.paginationCard;
    if (paginationCard != null) {
      return _retainedTerminalCard(child: paginationCard, isCurrent: false);
    }

    return const SizedBox.shrink(key: ValueKey('mateo_y_snap_list_empty_next'));
  }

  Widget _buildPreviousViewportChild(_MateoYSnapListWindow<T> listWindow) {
    final previousCard = listWindow.previousCard;
    if (previousCard != null) {
      return _retainedCard(card: previousCard, isCurrent: false);
    }

    return const SizedBox.shrink(
      key: ValueKey('mateo_y_snap_list_empty_previous'),
    );
  }

  Widget _retainedCard({required _MateoYSnapListCachedItem<T> card, required bool isCurrent}) {
    return _MateoYSnapListCardTickerMode(
      key: _MateoYSnapListCardKey(card.itemKey),
      motionListenable: _cardMotionNotifier,
      isCurrent: isCurrent,
      child: card.child,
    );
  }

  Widget _retainedTerminalCard({required Widget child, required bool isCurrent}) {
    return _MateoYSnapListCardTickerMode(
      key: const ValueKey('mateo_y_snap_list_terminal_card'),
      motionListenable: _cardMotionNotifier,
      isCurrent: isCurrent,
      child: RepaintBoundary(child: child),
    );
  }

  Widget _buildTerminalCard(BuildContext context) {
    if (_shouldShowLoadMoreErrorCard) return _loadMoreErrorBuilderCard(context);

    return widget.endBuilder?.call(context) ?? const SizedBox.shrink();
  }

  Widget? _buildPaginationCard(BuildContext context) {
    if (_isLoadingMore) return null;

    if (_shouldShowLoadMoreErrorCard) return _loadMoreErrorBuilderCard(context);

    final hasNextItem = _currentIndex + 1 < widget.items.count;
    if (!hasNextItem && !_paginationMayBringMore) {
      return widget.endBuilder?.call(context);
    }

    return null;
  }

  Widget _loadMoreErrorBuilderCard(BuildContext context) {
    final loadMoreErrorBuilder = widget.loadMoreErrorBuilder;
    if (loadMoreErrorBuilder == null) return const SizedBox.shrink();

    return loadMoreErrorBuilder(context, _retryLoadMore);
  }
}
