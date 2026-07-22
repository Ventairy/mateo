part of 'mateo_hero_group.dart';

class MateoHeroGroupScope extends InheritedWidget {
  const MateoHeroGroupScope({required super.child, super.key});

  static MateoHeroGroupScope? maybeOf(BuildContext context) {
    return context
            .getElementForInheritedWidgetOfExactType<MateoHeroGroupScope>()
            ?.widget
        as MateoHeroGroupScope?;
  }

  @override
  bool updateShouldNotify(MateoHeroGroupScope oldWidget) {
    return false;
  }
}
