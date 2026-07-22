part of 'mateo_hero_background.dart';

class MateoHeroBackgroundFlight extends StatelessWidget {
  const MateoHeroBackgroundFlight({super.key, this.decoration});

  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(decoration: decoration ?? const BoxDecoration());
  }
}
