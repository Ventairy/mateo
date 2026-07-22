part of 'mateo_hero_background.dart';

class MateoHeroBackgroundScope extends InheritedWidget {
  const MateoHeroBackgroundScope({
    required this.context,
    required super.child,
    super.key,
  });

  final BuildContext context;

  static MateoHeroBackgroundScope? maybeOf(BuildContext context) {
    return context
            .getElementForInheritedWidgetOfExactType<MateoHeroBackgroundScope>()
            ?.widget
        as MateoHeroBackgroundScope?;
  }

  RenderBox? get boxRenderObject => context.findRenderObject() as RenderBox?;

  @override
  bool updateShouldNotify(MateoHeroBackgroundScope oldWidget) => false;
}
