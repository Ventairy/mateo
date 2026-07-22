part of 'mateo_hero_group.dart';

class MateoHeroGroupLayout {
  const MateoHeroGroupLayout.flex({
    required this.direction,
    required this.mainAxisAlignment,
    required this.mainAxisSize,
    required this.crossAxisAlignment,
    required this.textDirection,
    required this.verticalDirection,
    required this.textBaseline,
    required this.spacing,
  }) : type = MateoHeroGroupLayoutType.flex,
       alignment = null,
       stackFit = null,
       clipBehavior = Clip.none;

  const MateoHeroGroupLayout.stack({
    required this.alignment,
    required this.textDirection,
    required this.stackFit,
    required this.clipBehavior,
  }) : type = MateoHeroGroupLayoutType.stack,
       direction = Axis.vertical,
       mainAxisAlignment = MainAxisAlignment.start,
       mainAxisSize = MainAxisSize.max,
       crossAxisAlignment = CrossAxisAlignment.center,
       verticalDirection = VerticalDirection.down,
       textBaseline = null,
       spacing = 0;

  factory MateoHeroGroupLayout.fromContext(BuildContext context) {
    MateoHeroGroupLayout? result;

    context.visitAncestorElements((element) {
      final widget = element.widget;

      if (widget is Flex) {
        result = MateoHeroGroupLayout.flex(
          direction: widget.direction,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
          crossAxisAlignment: widget.crossAxisAlignment,
          textDirection: widget.textDirection,
          verticalDirection: widget.verticalDirection,
          textBaseline: widget.textBaseline,
          spacing: widget.spacing,
        );
        return false;
      }

      if (widget is Stack) {
        result = MateoHeroGroupLayout.stack(
          alignment: widget.alignment,
          textDirection: widget.textDirection,
          stackFit: widget.fit,
          clipBehavior: widget.clipBehavior,
        );
        return false;
      }

      return true;
    });

    assert(
      result != null,
      'MateoHero.group must be placed under a Column, Row, Flex, or Stack so it can mirror the parent layout.',
    );

    return result ??
        const MateoHeroGroupLayout.flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: null,
          verticalDirection: VerticalDirection.down,
          textBaseline: null,
          spacing: 0,
        );
  }

  final MateoHeroGroupLayoutType type;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final double spacing;
  final AlignmentGeometry? alignment;
  final StackFit? stackFit;
  final Clip clipBehavior;

  bool get shouldReserveBoundedWidth {
    switch (type) {
      case MateoHeroGroupLayoutType.flex:
        return direction == Axis.vertical;
      case MateoHeroGroupLayoutType.stack:
        return true;
    }
  }

  Widget build({required List<Widget> children}) {
    switch (type) {
      case MateoHeroGroupLayoutType.flex:
        return Flex(
          direction: direction,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
          spacing: spacing,
          children: children,
        );
      case MateoHeroGroupLayoutType.stack:
        return Stack(
          alignment: alignment!,
          textDirection: textDirection,
          fit: stackFit!,
          clipBehavior: clipBehavior,
          children: children,
        );
    }
  }
}
