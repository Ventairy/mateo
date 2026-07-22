part of 'mateo_hero_group.dart';

class MateoHeroGroupHeightClampScope extends InheritedWidget {
  const MateoHeroGroupHeightClampScope({required super.child, super.key});

  static bool isActive(BuildContext context) {
    return context
            .getElementForInheritedWidgetOfExactType<
              MateoHeroGroupHeightClampScope
            >() !=
        null;
  }

  @override
  bool updateShouldNotify(MateoHeroGroupHeightClampScope oldWidget) => false;
}
