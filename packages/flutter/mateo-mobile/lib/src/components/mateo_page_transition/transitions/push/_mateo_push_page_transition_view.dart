part of '../../mateo_page_transition.dart';

final class _MateoPushPageTransitionView extends SingleChildRenderObjectWidget {
  _MateoPushPageTransitionView({
    required this.animation,
    required this.transition,
    required this.outgoing,
    required this.allowSnapshotting,
    required this.useLinearProgress,
    required Widget child,
  }) : super(
         child: !outgoing && !kIsWeb && allowSnapshotting && child is! RepaintBoundary
             ? RepaintBoundary(child: child)
             : child,
       );

  final Animation<double> animation;
  final MateoPageTransitionPush transition;
  final bool outgoing;
  final bool allowSnapshotting;
  final bool useLinearProgress;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final allowEdgeSnapshot = !outgoing && !kIsWeb && allowSnapshotting;
    return _RenderMateoPushPageTransition(
      animation: animation,
      transition: transition,
      outgoing: outgoing,
      allowEdgeSnapshot: allowEdgeSnapshot,
      useLinearProgress: useLinearProgress,
      devicePixelRatio: allowEdgeSnapshot ? MediaQuery.devicePixelRatioOf(context) : 1,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMateoPushPageTransition renderObject,
  ) {
    final allowEdgeSnapshot = !outgoing && !kIsWeb && allowSnapshotting;
    renderObject
      ..animation = animation
      ..transition = transition
      ..outgoing = outgoing
      ..allowEdgeSnapshot = allowEdgeSnapshot
      ..useLinearProgress = useLinearProgress
      ..devicePixelRatio = allowEdgeSnapshot ? MediaQuery.devicePixelRatioOf(context) : 1;
  }
}
