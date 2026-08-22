part of 'mateo_action_bloom.dart';

class _MateoActionBloomPanel extends StatelessWidget {
  const _MateoActionBloomPanel({
    required this.sourceSize,
    required this.sourceBackgroundColor,
    required this.actionIconForegroundColor,
    required this.sourceBorderRadius,
    required this.sourceBorderSide,
    required this.actions,
    required this.animation,
    required this.opensAtTop,
    required this.sourceOffsetFromPanelAnchor,
    required this.onSelected,
  });

  final Size sourceSize;
  final Color sourceBackgroundColor;
  final Color actionIconForegroundColor;
  final BorderRadius sourceBorderRadius;
  final BorderSide? sourceBorderSide;
  final List<MateoActionBloomAction> actions;
  final Animation<double> animation;
  final bool opensAtTop;
  final Offset sourceOffsetFromPanelAnchor;
  final Future<void> Function(
    MateoActionBloomAction action,
    Future<void> feedbackAnimation,
  )
  onSelected;

  @override
  Widget build(BuildContext context) {
    return _MateoActionBloomSurfaceTransition(
      key: const Key('mateo_action_bloom_surface'),
      sourceSize: sourceSize,
      animation: animation,
      sourceBackgroundColor: sourceBackgroundColor,
      sourceBorderRadius: sourceBorderRadius,
      sourceBorderSide: sourceBorderSide,
      sourceAlignment: opensAtTop ? Alignment.topRight : Alignment.bottomRight,
      sourceOffsetFromPanelAnchor: sourceOffsetFromPanelAnchor,
      child: FadeTransition(
        opacity: animation.drive(
          CurveTween(
            curve: const Interval(0.22, 1, curve: Curves.easeOutCubic),
          ),
        ),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.all(14),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (index, action) in actions.indexed) ...[
                    _MateoActionBloomActionScope(
                      animation: animation,
                      iconForegroundColor: actionIconForegroundColor,
                      onPressed: (pressAnimation) => onSelected(action, pressAnimation),
                      child: action,
                    ),
                    if (index != actions.length - 1) const SizedBox(height: 6),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
