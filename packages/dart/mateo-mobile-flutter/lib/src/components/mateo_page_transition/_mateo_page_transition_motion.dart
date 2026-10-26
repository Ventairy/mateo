part of 'mateo_page_transition.dart';

class _MateoPageTransitionMotion extends StatelessWidget {
  const _MateoPageTransitionMotion({
    required this.animation,
    required this.builder,
    required this.child,
    this.outgoing = false,
  });

  final Animation<double> animation;
  final bool outgoing;
  final Widget Function(Widget child, Animation<double> animation, {required bool useLinearProgress}) builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return ClipRect(
      child: ValueListenableBuilder<bool>(
        valueListenable: Navigator.of(context).userGestureInProgressNotifier,
        child: child,
        builder: (context, linear, child) => builder(
          child!,
          switch ((reducedMotion, outgoing)) {
            (true, true) => kAlwaysDismissedAnimation,
            (true, false) => kAlwaysCompleteAnimation,
            (false, _) => animation,
          },
          useLinearProgress: linear,
        ),
      ),
    );
  }
}
