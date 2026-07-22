part of '../mateo_hero.dart';

class _MateoHeroLifecycleEndpoint extends StatelessWidget {
  const _MateoHeroLifecycleEndpoint({
    required this.hero,
    required this.child,
    required this.onStartCallbacks,
    required this.onEndCallbacks,
    required this.onReceivedCallbacks,
  });

  final MateoHero hero;
  final Widget child;
  final List<VoidCallback> onStartCallbacks;
  final List<VoidCallback> onEndCallbacks;
  final List<VoidCallback> onReceivedCallbacks;

  static _MateoHeroLifecycleEndpoint fromHeroContext(BuildContext context) {
    final hero = context.widget as Hero;
    return hero.child as _MateoHeroLifecycleEndpoint;
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
