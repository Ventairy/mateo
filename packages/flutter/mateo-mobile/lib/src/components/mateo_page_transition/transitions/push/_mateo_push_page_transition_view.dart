part of '../../mateo_page_transition.dart';

final class _MateoPushPageTransitionView extends StatefulWidget {
  const _MateoPushPageTransitionView({
    required this.animation,
    required this.transition,
    required this.outgoing,
    required this.allowSnapshotting,
    required this.useLinearProgress,
    required this.child,
  });

  final Animation<double> animation;
  final MateoPageTransitionPush transition;
  final bool outgoing;
  final bool allowSnapshotting;
  final bool useLinearProgress;
  final Widget child;

  @override
  State<_MateoPushPageTransitionView> createState() => _MateoPushPageTransitionViewState();
}

final class _MateoPushPageTransitionViewState extends State<_MateoPushPageTransitionView> {
  final _snapshotController = SnapshotController();
  late final _MateoPushPageSnapshotPainter _snapshotPainter;
  bool _snapshotReady = false;
  bool _snapshotWarmupScheduled = false;
  ({EdgeInsets padding, EdgeInsets viewInsets, Size viewSize, double pixelRatio})? _snapshotGeometry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final geometry = (
      padding: MediaQuery.maybePaddingOf(context) ?? .zero,
      viewInsets: MediaQuery.maybeViewInsetsOf(context) ?? .zero,
      viewSize: MediaQuery.maybeSizeOf(context) ?? .zero,
      pixelRatio: MediaQuery.maybeDevicePixelRatioOf(context) ?? 1.0,
    );
    if (_snapshotGeometry != null && geometry != _snapshotGeometry) {
      _snapshotController.clear();
      _snapshotReady = false;
      _updateSnapshotting();
    }
    _snapshotGeometry = geometry;
  }

  @override
  void initState() {
    super.initState();
    _snapshotPainter = _MateoPushPageSnapshotPainter()..retainEdgeSource = !widget.outgoing;
    _snapshotController.addListener(_snapshotPainter.clearSnapshot);
    widget.animation.addStatusListener(_handleAnimationStatus);
    _updateSnapshotting();
  }

  @override
  void didUpdateWidget(_MateoPushPageTransitionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _snapshotPainter.retainEdgeSource = !widget.outgoing;
    if (oldWidget.animation != widget.animation) {
      oldWidget.animation.removeStatusListener(_handleAnimationStatus);
      widget.animation.addStatusListener(_handleAnimationStatus);
      _snapshotController.clear();
      _snapshotReady = false;
    }
    // Flutter rebuilds the route's child wrapper on every animation tick.
    // Keep one frozen page for the flight instead of invalidating by identity.
    _updateSnapshotting();
  }

  void _handleAnimationStatus(AnimationStatus status) => _updateSnapshotting();

  void _updateSnapshotting() {
    final wantsSnapshot = !kIsWeb && widget.allowSnapshotting && widget.animation.isAnimating;
    if (!wantsSnapshot) {
      _snapshotReady = false;
      _snapshotController.allowSnapshotting = false;
      return;
    }
    _snapshotController.allowSnapshotting = _snapshotReady;
    if (_snapshotReady || _snapshotWarmupScheduled) return;
    _snapshotWarmupScheduled = true;
    // Allow initial layout and its safe-area clearance notifications to finish
    // before freezing the page. The flight still captures each page only once.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _snapshotWarmupScheduled = false;
      if (!mounted) return;
      setState(() => _snapshotReady = true);
      _updateSnapshotting();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  _MateoPushPageSnapshot? _readSnapshot() => _snapshotPainter.snapshot;

  @override
  Widget build(BuildContext context) => _MateoPushPageTransitionRenderer(
    animation: widget.animation,
    transition: widget.transition,
    outgoing: widget.outgoing,
    allowSnapshotting: widget.allowSnapshotting,
    useLinearProgress: widget.useLinearProgress,
    snapshot: _readSnapshot,
    snapshotReady: _snapshotReady,
    child: SnapshotWidget(
      controller: _snapshotController,
      painter: _snapshotPainter,
      // Platform views continue painting live when they cannot be captured.
      mode: .permissive,
      autoresize: true,
      child: widget.child,
    ),
  );

  @override
  void dispose() {
    widget.animation.removeStatusListener(_handleAnimationStatus);
    _snapshotController.removeListener(_snapshotPainter.clearSnapshot);
    _snapshotPainter.dispose();
    _snapshotController.dispose();
    super.dispose();
  }
}
