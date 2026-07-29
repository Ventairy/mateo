part of 'mateo_action_bloom.dart';

/// An internal source surface that expands into an action-bloom panel.
///
/// The [builder] receives a descendant [BuildContext] that can be passed to
/// [MateoActionBloom.open]. The built widget remains the layout anchor while
/// the surface background expands into the nearest safe vertical edge.
@internal
class MateoActionBloomSurface extends StatefulWidget {
  /// Creates an action-bloom source surface.
  const MateoActionBloomSurface({
    required this.backgroundColor,
    required this.borderRadius,
    required this.builder,
    super.key,
    this.borderSide,
  });

  /// The source color from which the panel background expands.
  final Color backgroundColor;

  /// The source border radius from which the panel shape expands.
  final BorderRadius borderRadius;

  /// Builds the complete resting widget anchored by this surface.
  final MateoActionBloomSurfaceBuilder builder;

  /// The optional source border that fades while the panel expands.
  final BorderSide? borderSide;

  @override
  State<MateoActionBloomSurface> createState() =>
      _MateoActionBloomSurfaceState();
}

class _MateoActionBloomSurfaceState extends State<MateoActionBloomSurface>
    with SingleTickerProviderStateMixin {
  late final OverlayPortalController _overlayController;
  AnimationController? _animationController;
  CurvedAnimation? _surfaceAnimation;
  FocusNode? _focusNode;
  LocalHistoryEntry? _localHistoryEntry;
  bool _isPanelOpen = false;
  bool _isPanelMounted = false;
  bool _isDisposing = false;
  bool _panelOpensAtTop = false;
  List<MateoActionBloomAction> _actions = const [];
  Color? _actionIconForegroundColor;
  Completer<void>? _closedCompleter;

  bool get _disableAnimations => MediaQuery.disableAnimationsOf(context);

  @override
  void initState() {
    super.initState();
    _overlayController = OverlayPortalController(
      debugLabel: 'MateoActionBloom',
    );
  }

  void _ensureOverlayResources() {
    if (_animationController != null) return;

    final animationController = AnimationController(
      duration: const Duration(milliseconds: 240),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    )..addStatusListener(_handleAnimationStatus);
    _animationController = animationController;
    _surfaceAnimation = CurvedAnimation(
      parent: animationController,
      curve: const Cubic(0.2, 0, 0, 1),
      reverseCurve: const Cubic(0.4, 0, 1, 1),
    );
    _focusNode = FocusNode(debugLabel: 'MateoActionBloom');
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (!mounted) return;

    if (status == AnimationStatus.completed && _isPanelOpen) {
      _focusNode?.requestFocus();
      return;
    }

    if (status == AnimationStatus.dismissed &&
        !_isPanelOpen &&
        _isPanelMounted) {
      final closedCompleter = _closedCompleter;
      _closedCompleter = null;
      _overlayController.hide();
      setState(() {
        _isPanelMounted = false;
        _actions = const [];
        _actionIconForegroundColor = null;
      });
      closedCompleter?.complete();
    }
  }

  Future<void> _open({
    required List<MateoActionBloomAction> actions,
    required Color actionIconForegroundColor,
  }) {
    final activeClose = _closedCompleter;
    if (_isPanelMounted && activeClose != null) return activeClose.future;

    final route = ModalRoute.of(context);
    if (route == null) {
      throw FlutterError('MateoActionBloom requires a ModalRoute ancestor.');
    }

    _ensureOverlayResources();
    _panelOpensAtTop = _resolvePanelOpensAtTop();
    final historyEntry = LocalHistoryEntry(
      impliesAppBarDismissal: false,
      onRemove: _handleLocalHistoryRemoved,
    );
    _localHistoryEntry = historyEntry;
    route.addLocalHistoryEntry(historyEntry);

    final closedCompleter = Completer<void>();
    _closedCompleter = closedCompleter;
    setState(() {
      _actions = List<MateoActionBloomAction>.unmodifiable(actions);
      _actionIconForegroundColor = actionIconForegroundColor;
      _isPanelOpen = true;
      _isPanelMounted = true;
    });
    _overlayController.show();

    if (_disableAnimations) {
      _animationController!.value = 1;
    } else {
      unawaited(_animationController!.forward());
    }

    return closedCompleter.future;
  }

  bool _resolvePanelOpensAtTop() {
    final sourceRenderBox = context.findRenderObject();
    final overlayRenderBox = Overlay.of(context).context.findRenderObject();
    if (sourceRenderBox is! RenderBox || overlayRenderBox is! RenderBox) {
      return false;
    }

    return _MateoActionBloomOverlayGeometry.shouldOpenAtTop(
      sourceCenterY: sourceRenderBox
          .localToGlobal(
            sourceRenderBox.size.center(Offset.zero),
            ancestor: overlayRenderBox,
          )
          .dy,
      overlayHeight: overlayRenderBox.size.height,
      mediaQuery: _resolveViewMediaQuery(),
    );
  }

  MediaQueryData _resolveViewMediaQuery() => MediaQueryData.fromView(
    View.of(context),
    platformData: MediaQuery.of(context),
  );

  void _requestPanelClose() {
    final historyEntry = _localHistoryEntry;
    if (historyEntry != null) {
      historyEntry.remove();
    } else {
      _startPanelClose();
    }
  }

  void _handleLocalHistoryRemoved() {
    _localHistoryEntry = null;
    if (_isDisposing || !mounted) return;
    _startPanelClose();
  }

  void _startPanelClose() {
    if (!_isPanelOpen) return;

    setState(() => _isPanelOpen = false);

    if (_disableAnimations) {
      _animationController!.value = 0;
    } else {
      unawaited(_animationController!.reverse());
    }
  }

  KeyEventResult _handleOverlayKeyEvent(FocusNode _, KeyEvent event) {
    if (_isPanelMounted &&
        event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      _requestPanelClose();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> _handleActionSelected(
    MateoActionBloomAction action,
    Future<void> feedbackAnimation,
  ) {
    if (!_isPanelOpen) return feedbackAnimation;

    _requestPanelClose();
    return action.onPressed(feedbackAnimation);
  }

  @override
  void dispose() {
    _isDisposing = true;
    final historyEntry = _localHistoryEntry;
    _localHistoryEntry = null;
    historyEntry?.remove();
    _focusNode?.dispose();
    _surfaceAnimation?.dispose();
    _animationController
      ?..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    _closedCompleter?.complete();
    super.dispose();
  }

  Widget _buildOverlay(
    BuildContext _,
    OverlayChildLayoutInfo layoutInfo,
  ) {
    if (!_isPanelMounted) return const SizedBox.shrink();

    final surfaceAnimation = _surfaceAnimation!;
    final viewMediaQuery = _resolveViewMediaQuery();
    final overlaySize = layoutInfo.overlaySize;
    final sourceRect = MatrixUtils.transformRect(
      layoutInfo.childPaintTransform,
      Offset.zero & layoutInfo.childSize,
    );
    final geometry = _MateoActionBloomOverlayGeometry.resolve(
      overlaySize: overlaySize,
      sourceRect: sourceRect,
      mediaQuery: viewMediaQuery,
      opensAtTop: _panelOpensAtTop,
    );

    return Focus(
      focusNode: _focusNode,
      canRequestFocus: _isPanelMounted,
      onKeyEvent: _handleOverlayKeyEvent,
      child: BlockSemantics(
        blocking: true,
        child: Semantics(
          scopesRoute: true,
          explicitChildNodes: true,
          child: SizedBox.fromSize(
            size: overlaySize,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: AnimatedModalBarrier(
                    key: const Key('mateo_action_bloom_barrier'),
                    color: ColorTween(
                      begin: Colors.transparent,
                      end: context.mateo.colorScheme.overlay.scrim,
                    ).animate(surfaceAnimation),
                    dismissible: true,
                    semanticsLabel: MaterialLocalizations.of(
                      context,
                    ).modalBarrierDismissLabel,
                    onDismiss: _requestPanelClose,
                  ),
                ),
                Positioned(
                  key: const Key('mateo_action_bloom_panel'),
                  left: geometry.panelHorizontalInset,
                  right: geometry.panelHorizontalInset,
                  top: geometry.panelTop,
                  bottom: geometry.panelBottom,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: geometry.panelMaxHeight,
                    ),
                    child: MediaQuery(
                      data: viewMediaQuery,
                      child: _MateoActionBloomPanel(
                        sourceSize: sourceRect.size,
                        sourceBackgroundColor: widget.backgroundColor,
                        actionIconForegroundColor: _actionIconForegroundColor!,
                        sourceBorderRadius: widget.borderRadius,
                        sourceBorderSide: widget.borderSide,
                        actions: _actions,
                        animation: surfaceAnimation,
                        opensAtTop: geometry.opensAtTop,
                        sourceOffsetFromPanelAnchor:
                            geometry.sourceOffsetFromPanelAnchor,
                        onSelected: _handleActionSelected,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final source = Builder(builder: widget.builder);

    return OverlayPortal.overlayChildLayoutBuilder(
      controller: _overlayController,
      overlayChildBuilder: _buildOverlay,
      child: _isPanelMounted
          ? IgnorePointer(
              child: ExcludeSemantics(
                child: Opacity(
                  opacity: 0,
                  child: source,
                ),
              ),
            )
          : source,
    );
  }
}
