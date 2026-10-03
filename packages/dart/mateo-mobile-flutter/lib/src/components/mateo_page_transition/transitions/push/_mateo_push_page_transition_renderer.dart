part of '../../mateo_page_transition.dart';

final class _MateoPushPageTransitionRenderer extends SingleChildRenderObjectWidget {
  _MateoPushPageTransitionRenderer({
    required this.animation,
    required this.transition,
    required this.outgoing,
    required this.allowSnapshotting,
    required this.useLinearProgress,
    required this.snapshot,
    required this.snapshotReady,
    required Widget child,
  }) : super(
         // Keep this boundary stable when a route opts out during a flight.
         child: !outgoing && !kIsWeb && child is! RepaintBoundary ? RepaintBoundary(child: child) : child,
       );

  final Animation<double> animation;
  final MateoPageTransitionPush transition;
  final bool outgoing;
  final bool allowSnapshotting;
  final bool snapshotReady;
  final bool useLinearProgress;
  final _MateoPushPageSnapshot? Function() snapshot;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final allowEdgeSnapshot = !outgoing && !kIsWeb && allowSnapshotting && snapshotReady;
    return _RenderMateoPushPageTransition(
      animation: animation,
      transition: transition,
      outgoing: outgoing,
      allowPageSnapshot: !kIsWeb && allowSnapshotting,
      allowEdgeSnapshot: allowEdgeSnapshot,
      useLinearProgress: useLinearProgress,
      snapshot: snapshot,
      devicePixelRatio: allowEdgeSnapshot ? MediaQuery.devicePixelRatioOf(context) : 1,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMateoPushPageTransition renderObject,
  ) {
    final allowEdgeSnapshot = !outgoing && !kIsWeb && allowSnapshotting && snapshotReady;
    renderObject
      ..animation = animation
      ..transition = transition
      ..outgoing = outgoing
      ..allowPageSnapshot = !kIsWeb && allowSnapshotting
      ..allowEdgeSnapshot = allowEdgeSnapshot
      ..useLinearProgress = useLinearProgress
      ..snapshot = snapshot
      ..devicePixelRatio = allowEdgeSnapshot ? MediaQuery.devicePixelRatioOf(context) : 1;
  }
}
