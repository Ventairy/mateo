part of 'mateo_page_transition.dart';

class _MateoPageTransitionMotion extends StatelessWidget {
  const _MateoPageTransitionMotion({required this.builder, required this.child});

  final Widget Function(Widget child, {required bool useLinearProgress}) builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;
    return ClipRect(
      child: ValueListenableBuilder<bool>(
        valueListenable: Navigator.of(context).userGestureInProgressNotifier,
        child: child,
        builder: (context, linear, child) => builder(child!, useLinearProgress: linear),
      ),
    );
  }
}
