part of '../mateo_surface.dart';

final class _MateoSurfaceScrollController extends ScrollController {
  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _MateoSurfaceScrollPosition(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }
}

final class _MateoSurfaceScrollPosition extends ScrollPositionWithSingleContext {
  _MateoSurfaceScrollPosition({
    required super.physics,
    required super.context,
    super.initialPixels,
    super.keepScrollOffset,
    super.oldPosition,
    super.debugLabel,
  });

  @override
  Future<void> ensureVisible(
    RenderObject object, {
    double alignment = 0,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
    ScrollPositionAlignmentPolicy alignmentPolicy = ScrollPositionAlignmentPolicy.explicit,
    RenderObject? targetRenderObject,
  }) {
    assert(object.attached, 'The target must be attached before it can be revealed.');
    assert(
      axisDirection == AxisDirection.down,
      'MateoSurface.scrollable requires its managed position to run downward.',
    );
    RenderObject? ancestor = object;
    while (ancestor != null && ancestor is! _RenderMateoSurfaceObstructionReveal) {
      ancestor = ancestor.parent;
    }
    if (ancestor is! _RenderMateoSurfaceObstructionReveal) {
      return super.ensureVisible(
        object,
        alignment: alignment,
        duration: duration,
        curve: curve,
        alignmentPolicy: alignmentPolicy,
        targetRenderObject: targetRenderObject,
      );
    }

    final viewport = RenderAbstractViewport.maybeOf(object);
    if (viewport == null) return Future<void>.value();
    var targetRect = object.paintBounds;
    if (targetRenderObject != null && targetRenderObject != object) {
      targetRect = MatrixUtils.transformRect(
        targetRenderObject.getTransformTo(object),
        object.paintBounds.intersect(targetRenderObject.paintBounds),
      );
    }
    final localRect = MatrixUtils.transformRect(
      object.getTransformTo(ancestor),
      targetRect,
    );
    final revealRect = Rect.fromLTRB(
      localRect.left,
      localRect.top - ancestor.leadingExtent,
      localRect.right,
      localRect.bottom + ancestor.trailingExtent,
    );
    final target = switch (alignmentPolicy) {
      ScrollPositionAlignmentPolicy.explicit =>
        viewport
            .getOffsetToReveal(
              ancestor,
              alignment,
              rect: revealRect,
              axis: axis,
            )
            .offset
            .clamp(minScrollExtent, maxScrollExtent),
      ScrollPositionAlignmentPolicy.keepVisibleAtEnd => math.max(
        pixels,
        viewport
            .getOffsetToReveal(
              ancestor,
              1,
              rect: revealRect,
              axis: axis,
            )
            .offset
            .clamp(minScrollExtent, maxScrollExtent),
      ),
      ScrollPositionAlignmentPolicy.keepVisibleAtStart => math.min(
        pixels,
        viewport
            .getOffsetToReveal(
              ancestor,
              0,
              rect: revealRect,
              axis: axis,
            )
            .offset
            .clamp(minScrollExtent, maxScrollExtent),
      ),
    };
    if (target == pixels) return Future<void>.value();
    if (duration == Duration.zero) {
      jumpTo(target);
      return Future<void>.value();
    }
    return animateTo(target, duration: duration, curve: curve);
  }
}

final class _MateoSurfaceOverflowOnlyScrollPhysics extends ScrollPhysics {
  const _MateoSurfaceOverflowOnlyScrollPhysics({super.parent});

  static const _minimumScrollExtent = 0.5;

  bool _hasOverflow(ScrollMetrics position) =>
      position.maxScrollExtent - position.minScrollExtent > _minimumScrollExtent;

  @override
  _MateoSurfaceOverflowOnlyScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      _MateoSurfaceOverflowOnlyScrollPhysics(parent: buildParent(ancestor));

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    if (!_hasOverflow(newPosition)) return newPosition.minScrollExtent;
    return super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) =>
      _hasOverflow(position) && super.shouldAcceptUserOffset(position);

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (!_hasOverflow(position)) return value - position.pixels;
    return super.applyBoundaryConditions(position, value);
  }
}

final class _MateoSurfaceFocusRevealObserver extends StatefulWidget {
  const _MateoSurfaceFocusRevealObserver({
    required this.leadingExtent,
    required this.trailingExtent,
    required this.child,
  });

  final double leadingExtent;
  final double trailingExtent;
  final Widget child;

  @override
  State<_MateoSurfaceFocusRevealObserver> createState() => _MateoSurfaceFocusRevealObserverState();
}

class _MateoSurfaceFocusRevealObserverState extends State<_MateoSurfaceFocusRevealObserver> {
  final GlobalKey _obstructionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_revealPrimaryFocus);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_revealPrimaryFocus);
    super.dispose();
  }

  void _revealPrimaryFocus() {
    final focusContext = FocusManager.instance.primaryFocus?.context;
    if (focusContext == null || !focusContext.mounted) return;
    final editableTextState = focusContext.findAncestorStateOfType<EditableTextState>();
    if (editableTextState != null && !editableTextState.widget.readOnly) return;
    final target = focusContext.findRenderObject();
    if (target == null || !target.attached) return;
    RenderObject? ancestor = target;
    while (ancestor != null && ancestor is! _RenderMateoSurfaceObstructionReveal) {
      ancestor = ancestor.parent;
    }
    if (!identical(
      ancestor,
      _obstructionKey.currentContext?.findRenderObject(),
    )) {
      return;
    }
    target.showOnScreen();
  }

  @override
  Widget build(BuildContext context) => _MateoSurfaceObstructionReveal(
    key: _obstructionKey,
    leadingExtent: widget.leadingExtent,
    trailingExtent: widget.trailingExtent,
    child: widget.child,
  );
}

final class _MateoSurfaceObstructionReveal extends SingleChildRenderObjectWidget {
  const _MateoSurfaceObstructionReveal({
    required this.leadingExtent,
    required this.trailingExtent,
    required super.child,
    super.key,
  });

  final double leadingExtent;
  final double trailingExtent;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderMateoSurfaceObstructionReveal(
    leadingExtent: leadingExtent,
    trailingExtent: trailingExtent,
  );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMateoSurfaceObstructionReveal renderObject,
  ) {
    renderObject.updateExtents(
      leadingExtent: leadingExtent,
      trailingExtent: trailingExtent,
    );
  }
}

final class _RenderMateoSurfaceObstructionReveal extends RenderProxyBox {
  _RenderMateoSurfaceObstructionReveal({
    required double leadingExtent,
    required double trailingExtent,
  }) : assert(
         leadingExtent.isFinite && leadingExtent >= 0,
         'leadingExtent must be finite and non-negative.',
       ),
       assert(
         trailingExtent.isFinite && trailingExtent >= 0,
         'trailingExtent must be finite and non-negative.',
       ),
       _leadingExtent = leadingExtent,
       _trailingExtent = trailingExtent;

  double _leadingExtent;
  double _trailingExtent;

  double get leadingExtent => _leadingExtent;
  double get trailingExtent => _trailingExtent;

  void updateExtents({
    required double leadingExtent,
    required double trailingExtent,
  }) {
    assert(
      leadingExtent.isFinite && leadingExtent >= 0,
      'leadingExtent must be finite and non-negative.',
    );
    assert(
      trailingExtent.isFinite && trailingExtent >= 0,
      'trailingExtent must be finite and non-negative.',
    );
    _leadingExtent = leadingExtent;
    _trailingExtent = trailingExtent;
  }

  @override
  void showOnScreen({
    RenderObject? descendant,
    Rect? rect,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
  }) {
    final target = descendant ?? this;
    final targetRect = rect ?? target.paintBounds;
    final localRect = identical(target, this)
        ? targetRect
        : MatrixUtils.transformRect(target.getTransformTo(this), targetRect);
    super.showOnScreen(
      descendant: this,
      rect: Rect.fromLTRB(
        localRect.left,
        localRect.top - _leadingExtent,
        localRect.right,
        localRect.bottom + _trailingExtent,
      ),
      duration: duration,
      curve: curve,
    );
  }
}
