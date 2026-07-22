part of 'mateo_hero_text.dart';

class MateoHeroTextScaledMetrics {
  const MateoHeroTextScaledMetrics({
    required this.style,
    required this.scaleX,
    required this.scaleY,
    required this.lineHeight,
    required this.baselineOffset,
    required this.reservedLayoutWidth,
  });

  final TextStyle style;
  final double scaleX;
  final double scaleY;
  final double lineHeight;
  final double baselineOffset;
  final double? reservedLayoutWidth;
}
