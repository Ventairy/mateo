// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
// *****************************************************

// coverage:ignore-file
// Generated canvas and paint sequences intentionally use repeated receiver calls.
// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:flutter/widgets.dart';

Color _dotdartApplyOpacity(Color color, double opacity) {
  if (opacity == 1) return color;
  return color.withValues(alpha: math.min(1, math.max(0, color.a * opacity)));
}

mixin _DotdartSvgSizing on StatelessWidget {
  double? get svgWidgetWidth;
  double? get svgWidgetHeight;
  double get svgNativeWidth;
  double get svgNativeHeight;
  double get svgViewBoxWidth;
  double get svgViewBoxHeight;
  bool get svgMaintainAspectRatio;

  Widget buildPainter({required double width, required double height});

  Size _defaultSizeFor(BoxConstraints constraints) {
    final aspect = svgViewBoxHeight / svgViewBoxWidth;
    var w = svgNativeWidth;
    if (constraints.hasBoundedWidth) {
      w = math.min(w, constraints.maxWidth);
    }
    if (constraints.hasBoundedHeight) {
      w = math.min(w, constraints.maxHeight / aspect);
    }
    return Size(w, w * aspect);
  }

  Size _resolveSize(double aspect) {
    if (svgWidgetWidth != null && svgWidgetHeight != null) {
      if (!svgMaintainAspectRatio) {
        return Size(svgWidgetWidth!, svgWidgetHeight!);
      }
      return svgWidgetWidth! >= svgWidgetHeight!
          ? Size(svgWidgetWidth!, svgWidgetWidth! * aspect)
          : Size(svgWidgetHeight! / aspect, svgWidgetHeight!);
    }

    final w = svgWidgetWidth ?? svgWidgetHeight! / aspect;
    return Size(w, svgWidgetHeight ?? w * aspect);
  }

  @override
  Widget build(BuildContext context) {
    final hasExplicitSize = svgWidgetWidth != null || svgWidgetHeight != null;

    if (!hasExplicitSize) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final size = _defaultSizeFor(constraints);
          return buildPainter(width: size.width, height: size.height);
        },
      );
    }

    final aspect = svgViewBoxHeight / svgViewBoxWidth;
    final size = _resolveSize(aspect);

    return OverflowBox(
      alignment: Alignment.topLeft,
      fit: OverflowBoxFit.deferToChild,
      minWidth: size.width,
      maxWidth: size.width,
      minHeight: size.height,
      maxHeight: size.height,
      child: buildPainter(width: size.width, height: size.height),
    );
  }
}

/// Namespace for dotdart-generated widgets from `icons/`.
///
/// Call a method named after each asset to render it:
///
/// ```dart
/// $Icons.arrowDown(<params>);
/// ```
/// ```dart
/// $Icons.arrowLeft(<params>);
/// ```
/// ```dart
/// $Icons.arrowRight(<params>);
/// ```
/// ```dart
/// $Icons.arrowRotateClockise(<params>);
/// ```
/// ```dart
/// $Icons.arrowUp(<params>);
/// ```
/// ```dart
/// $Icons.bankBuilding(<params>);
/// ```
/// ```dart
/// $Icons.banknotePin(<params>);
/// ```
/// ```dart
/// $Icons.beerMug(<params>);
/// ```
/// ```dart
/// $Icons.bicycle(<params>);
/// ```
/// ```dart
/// $Icons.bidirecionalHorizontalArrow(<params>);
/// ```
/// ```dart
/// $Icons.book(<params>);
/// ```
/// ```dart
/// $Icons.boxPencil(<params>);
/// ```
/// ```dart
/// $Icons.broom(<params>);
/// ```
/// ```dart
/// $Icons.buildings(<params>);
/// ```
/// ```dart
/// $Icons.busFront(<params>);
/// ```
/// ```dart
/// $Icons.checkeredFlag(<params>);
/// ```
/// ```dart
/// $Icons.checkmark(<params>);
/// ```
/// ```dart
/// $Icons.chevronDown(<params>);
/// ```
/// ```dart
/// $Icons.chevronLeft(<params>);
/// ```
/// ```dart
/// $Icons.circle(<params>);
/// ```
/// ```dart
/// $Icons.circleBlock(<params>);
/// ```
/// ```dart
/// $Icons.circleCheck(<params>);
/// ```
/// ```dart
/// $Icons.circleInfo(<params>);
/// ```
/// ```dart
/// $Icons.classicBuilding(<params>);
/// ```
/// ```dart
/// $Icons.clock(<params>);
/// ```
/// ```dart
/// $Icons.cross(<params>);
/// ```
/// ```dart
/// $Icons.crossCircle(<params>);
/// ```
/// ```dart
/// $Icons.discoBall(<params>);
/// ```
/// ```dart
/// $Icons.doubleCross(<params>);
/// ```
/// ```dart
/// $Icons.drop(<params>);
/// ```
/// ```dart
/// $Icons.dropFoam(<params>);
/// ```
/// ```dart
/// $Icons.dumbbell(<params>);
/// ```
/// ```dart
/// $Icons.eraser(<params>);
/// ```
/// ```dart
/// $Icons.evPlug(<params>);
/// ```
/// ```dart
/// $Icons.exclamationCircle(<params>);
/// ```
/// ```dart
/// $Icons.exclamationTriangle(<params>);
/// ```
/// ```dart
/// $Icons.ferrisWheel(<params>);
/// ```
/// ```dart
/// $Icons.figureCropCircle(<params>);
/// ```
/// ```dart
/// $Icons.flame(<params>);
/// ```
/// ```dart
/// $Icons.forkKnife(<params>);
/// ```
/// ```dart
/// $Icons.gasStation(<params>);
/// ```
/// ```dart
/// $Icons.gear(<params>);
/// ```
/// ```dart
/// $Icons.gift(<params>);
/// ```
/// ```dart
/// $Icons.governmentBuilding(<params>);
/// ```
/// ```dart
/// $Icons.graduateCap(<params>);
/// ```
/// ```dart
/// $Icons.handshake(<params>);
/// ```
/// ```dart
/// $Icons.helicopterFront(<params>);
/// ```
/// ```dart
/// $Icons.hookah(<params>);
/// ```
/// ```dart
/// $Icons.hotCoffeeCup(<params>);
/// ```
/// ```dart
/// $Icons.info(<params>);
/// ```
/// ```dart
/// $Icons.letters(<params>);
/// ```
/// ```dart
/// $Icons.lightningBolt(<params>);
/// ```
/// ```dart
/// $Icons.locationPin(<params>);
/// ```
/// ```dart
/// $Icons.magnifyingGlass(<params>);
/// ```
/// ```dart
/// $Icons.magnifyingGlassSadFace(<params>);
/// ```
/// ```dart
/// $Icons.matiniGlass(<params>);
/// ```
/// ```dart
/// $Icons.medicalCross(<params>);
/// ```
/// ```dart
/// $Icons.numbers(<params>);
/// ```
/// ```dart
/// $Icons.padlock(<params>);
/// ```
/// ```dart
/// $Icons.padlockOpen(<params>);
/// ```
/// ```dart
/// $Icons.paperPlaneUpRight(<params>);
/// ```
/// ```dart
/// $Icons.parkingSign(<params>);
/// ```
/// ```dart
/// $Icons.pencil(<params>);
/// ```
/// ```dart
/// $Icons.phone(<params>);
/// ```
/// ```dart
/// $Icons.pills(<params>);
/// ```
/// ```dart
/// $Icons.planeUpRight(<params>);
/// ```
/// ```dart
/// $Icons.plusSignal(<params>);
/// ```
/// ```dart
/// $Icons.pointerHandUp(<params>);
/// ```
/// ```dart
/// $Icons.policeBadge(<params>);
/// ```
/// ```dart
/// $Icons.popcorn(<params>);
/// ```
/// ```dart
/// $Icons.prayingFigure(<params>);
/// ```
/// ```dart
/// $Icons.questionmark(<params>);
/// ```
/// ```dart
/// $Icons.rectangleStack(<params>);
/// ```
/// ```dart
/// $Icons.road(<params>);
/// ```
/// ```dart
/// $Icons.runningFigure(<params>);
/// ```
/// ```dart
/// $Icons.sadEmoticon(<params>);
/// ```
/// ```dart
/// $Icons.sadMaskHappyMask(<params>);
/// ```
/// ```dart
/// $Icons.scissors(<params>);
/// ```
/// ```dart
/// $Icons.shoppingBag(<params>);
/// ```
/// ```dart
/// $Icons.shoppingCart(<params>);
/// ```
/// ```dart
/// $Icons.sleepingFigure(<params>);
/// ```
/// ```dart
/// $Icons.smartphone(<params>);
/// ```
/// ```dart
/// $Icons.socialMediaPost(<params>);
/// ```
/// ```dart
/// $Icons.stadium(<params>);
/// ```
/// ```dart
/// $Icons.star(<params>);
/// ```
/// ```dart
/// $Icons.tire(<params>);
/// ```
/// ```dart
/// $Icons.trainFront(<params>);
/// ```
/// ```dart
/// $Icons.trash(<params>);
/// ```
/// ```dart
/// $Icons.tree(<params>);
/// ```
/// ```dart
/// $Icons.whatsapp(<params>);
/// ```
/// ```dart
/// $Icons.wifi(<params>);
/// ```
/// ```dart
/// $Icons.wifiExclamationMark(<params>);
/// ```
/// ```dart
/// $Icons.wineGlass(<params>);
/// ```
/// ```dart
/// $Icons.wrench(<params>);
/// ```
abstract final class $Icons {
  $Icons._();

  /// Builds the `ArrowDown` widget from `arrowDown.svg`.
  static Widget arrowDown({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ArrowDown(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ArrowLeft` widget from `arrowLeft.svg`.
  static Widget arrowLeft({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ArrowLeft(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ArrowRight` widget from `arrowRight.svg`.
  static Widget arrowRight({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ArrowRight(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ArrowRotateClockise` widget from `arrowRotateClockise.svg`.
  static Widget arrowRotateClockise({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ArrowRotateClockise(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ArrowUp` widget from `arrowUp.svg`.
  static Widget arrowUp({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ArrowUp(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `BankBuilding` widget from `bankBuilding.svg`.
  static Widget bankBuilding({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _BankBuilding(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `BanknotePin` widget from `banknotePin.svg`.
  static Widget banknotePin({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _BanknotePin(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `BeerMug` widget from `beerMug.svg`.
  static Widget beerMug({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _BeerMug(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Bicycle` widget from `bicycle.svg`.
  static Widget bicycle({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Bicycle(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `BidirecionalHorizontalArrow` widget from `bidirecionalHorizontalArrow.svg`.
  static Widget bidirecionalHorizontalArrow({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _BidirecionalHorizontalArrow(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Book` widget from `book.svg`.
  static Widget book({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Book(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `BoxPencil` widget from `boxPencil.svg`.
  static Widget boxPencil({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _BoxPencil(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Broom` widget from `broom.svg`.
  static Widget broom({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Broom(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Buildings` widget from `buildings.svg`.
  static Widget buildings({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Buildings(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `BusFront` widget from `busFront.svg`.
  static Widget busFront({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _BusFront(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `CheckeredFlag` widget from `checkeredFlag.svg`.
  static Widget checkeredFlag({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _CheckeredFlag(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Checkmark` widget from `checkmark.svg`.
  static Widget checkmark({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Checkmark(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ChevronDown` widget from `chevronDown.svg`.
  static Widget chevronDown({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ChevronDown(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ChevronLeft` widget from `chevronLeft.svg`.
  static Widget chevronLeft({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ChevronLeft(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Circle` widget from `circle.svg`.
  static Widget circle({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Circle(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `CircleBlock` widget from `circleBlock.svg`.
  static Widget circleBlock({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _CircleBlock(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `CircleCheck` widget from `circleCheck.svg`.
  static Widget circleCheck({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _CircleCheck(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `CircleInfo` widget from `circleInfo.svg`.
  static Widget circleInfo({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _CircleInfo(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ClassicBuilding` widget from `classicBuilding.svg`.
  static Widget classicBuilding({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ClassicBuilding(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Clock` widget from `clock.svg`.
  static Widget clock({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Clock(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Cross` widget from `cross.svg`.
  static Widget cross({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Cross(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `CrossCircle` widget from `crossCircle.svg`.
  static Widget crossCircle({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _CrossCircle(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `DiscoBall` widget from `discoBall.svg`.
  static Widget discoBall({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _DiscoBall(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `DoubleCross` widget from `doubleCross.svg`.
  static Widget doubleCross({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _DoubleCross(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Drop` widget from `drop.svg`.
  static Widget drop({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Drop(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `DropFoam` widget from `dropFoam.svg`.
  static Widget dropFoam({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _DropFoam(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Dumbbell` widget from `dumbbell.svg`.
  static Widget dumbbell({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Dumbbell(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Eraser` widget from `eraser.svg`.
  static Widget eraser({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Eraser(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `EvPlug` widget from `evPlug.svg`.
  static Widget evPlug({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _EvPlug(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ExclamationCircle` widget from `exclamationCircle.svg`.
  static Widget exclamationCircle({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ExclamationCircle(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ExclamationTriangle` widget from `exclamationTriangle.svg`.
  static Widget exclamationTriangle({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ExclamationTriangle(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `FerrisWheel` widget from `ferrisWheel.svg`.
  static Widget ferrisWheel({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _FerrisWheel(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `FigureCropCircle` widget from `figureCropCircle.svg`.
  static Widget figureCropCircle({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _FigureCropCircle(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Flame` widget from `flame.svg`.
  static Widget flame({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Flame(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ForkKnife` widget from `forkKnife.svg`.
  static Widget forkKnife({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ForkKnife(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `GasStation` widget from `gasStation.svg`.
  static Widget gasStation({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _GasStation(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Gear` widget from `gear.svg`.
  static Widget gear({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Gear(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Gift` widget from `gift.svg`.
  static Widget gift({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Gift(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `GovernmentBuilding` widget from `governmentBuilding.svg`.
  static Widget governmentBuilding({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _GovernmentBuilding(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `GraduateCap` widget from `graduateCap.svg`.
  static Widget graduateCap({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _GraduateCap(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Handshake` widget from `handshake.svg`.
  static Widget handshake({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Handshake(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `HelicopterFront` widget from `helicopterFront.svg`.
  static Widget helicopterFront({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _HelicopterFront(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Hookah` widget from `hookah.svg`.
  static Widget hookah({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Hookah(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `HotCoffeeCup` widget from `hotCoffeeCup.svg`.
  static Widget hotCoffeeCup({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _HotCoffeeCup(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Info` widget from `info.svg`.
  static Widget info({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Info(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Letters` widget from `letters.svg`.
  static Widget letters({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Letters(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `LightningBolt` widget from `lightningBolt.svg`.
  static Widget lightningBolt({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _LightningBolt(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `LocationPin` widget from `locationPin.svg`.
  static Widget locationPin({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _LocationPin(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `MagnifyingGlass` widget from `magnifyingGlass.svg`.
  static Widget magnifyingGlass({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _MagnifyingGlass(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `MagnifyingGlassSadFace` widget from `magnifyingGlassSadFace.svg`.
  static Widget magnifyingGlassSadFace({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _MagnifyingGlassSadFace(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `MatiniGlass` widget from `matiniGlass.svg`.
  static Widget matiniGlass({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _MatiniGlass(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `MedicalCross` widget from `medicalCross.svg`.
  static Widget medicalCross({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _MedicalCross(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Numbers` widget from `numbers.svg`.
  static Widget numbers({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Numbers(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Padlock` widget from `padlock.svg`.
  static Widget padlock({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Padlock(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `PadlockOpen` widget from `padlockOpen.svg`.
  static Widget padlockOpen({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _PadlockOpen(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `PaperPlaneUpRight` widget from `paperPlaneUpRight.svg`.
  static Widget paperPlaneUpRight({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _PaperPlaneUpRight(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ParkingSign` widget from `parkingSign.svg`.
  static Widget parkingSign({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ParkingSign(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Pencil` widget from `pencil.svg`.
  static Widget pencil({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Pencil(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Phone` widget from `phone.svg`.
  static Widget phone({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Phone(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Pills` widget from `pills.svg`.
  static Widget pills({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Pills(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `PlaneUpRight` widget from `planeUpRight.svg`.
  static Widget planeUpRight({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _PlaneUpRight(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `PlusSignal` widget from `plusSignal.svg`.
  static Widget plusSignal({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _PlusSignal(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `PointerHandUp` widget from `pointerHandUp.svg`.
  static Widget pointerHandUp({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _PointerHandUp(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `PoliceBadge` widget from `policeBadge.svg`.
  static Widget policeBadge({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _PoliceBadge(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Popcorn` widget from `popcorn.svg`.
  static Widget popcorn({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Popcorn(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `PrayingFigure` widget from `prayingFigure.svg`.
  static Widget prayingFigure({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _PrayingFigure(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Questionmark` widget from `questionmark.svg`.
  static Widget questionmark({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Questionmark(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `RectangleStack` widget from `rectangleStack.svg`.
  static Widget rectangleStack({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _RectangleStack(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Road` widget from `road.svg`.
  static Widget road({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Road(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `RunningFigure` widget from `runningFigure.svg`.
  static Widget runningFigure({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _RunningFigure(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `SadEmoticon` widget from `sadEmoticon.svg`.
  static Widget sadEmoticon({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _SadEmoticon(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `SadMaskHappyMask` widget from `sadMaskHappyMask.svg`.
  static Widget sadMaskHappyMask({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _SadMaskHappyMask(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Scissors` widget from `scissors.svg`.
  static Widget scissors({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Scissors(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ShoppingBag` widget from `shoppingBag.svg`.
  static Widget shoppingBag({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _ShoppingBag(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `ShoppingCart` widget from `shoppingCart.svg`.
  static Widget shoppingCart({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor1,
    Color? mateoOpticalSizeColor2,
  }) => _ShoppingCart(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor1: mateoOpticalSizeColor1,
    mateoOpticalSizeColor2: mateoOpticalSizeColor2,
  );

  /// Builds the `SleepingFigure` widget from `sleepingFigure.svg`.
  static Widget sleepingFigure({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _SleepingFigure(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Smartphone` widget from `smartphone.svg`.
  static Widget smartphone({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Smartphone(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `SocialMediaPost` widget from `socialMediaPost.svg`.
  static Widget socialMediaPost({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _SocialMediaPost(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Stadium` widget from `stadium.svg`.
  static Widget stadium({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor1,
    Color? mateoOpticalSizeColor2,
  }) => _Stadium(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor1: mateoOpticalSizeColor1,
    mateoOpticalSizeColor2: mateoOpticalSizeColor2,
  );

  /// Builds the `Star` widget from `star.svg`.
  static Widget star({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Star(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Tire` widget from `tire.svg`.
  static Widget tire({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Tire(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `TrainFront` widget from `trainFront.svg`.
  static Widget trainFront({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _TrainFront(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Trash` widget from `trash.svg`.
  static Widget trash({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Trash(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Tree` widget from `tree.svg`.
  static Widget tree({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Tree(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Whatsapp` widget from `whatsapp.svg`.
  static Widget whatsapp({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Whatsapp(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Wifi` widget from `wifi.svg`.
  static Widget wifi({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Wifi(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `WifiExclamationMark` widget from `wifiExclamationMark.svg`.
  static Widget wifiExclamationMark({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _WifiExclamationMark(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `WineGlass` widget from `wineGlass.svg`.
  static Widget wineGlass({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _WineGlass(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `Wrench` widget from `wrench.svg`.
  static Widget wrench({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Wrench(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the asset matching [fileName], or returns null if it is absent.
  ///
  /// Pass the original filename, including its extension and exact case.
  /// Directory paths and extensionless names do not match.
  /// [key] is forwarded to the generated widget. [width] and [height] are
  /// logical pixels and use the same sizing rules as the named accessor.
  /// All asset-specific options keep their defaults.
  static Widget? findByName(
    String fileName, {
    Key? key,
    double? width,
    double? height,
  }) => switch (fileName) {
    'arrow-down.svg' => arrowDown(key: key, width: width, height: height),
    'arrow-left.svg' => arrowLeft(key: key, width: width, height: height),
    'arrow-right.svg' => arrowRight(key: key, width: width, height: height),
    'arrow-rotate-clockise.svg' => arrowRotateClockise(
      key: key,
      width: width,
      height: height,
    ),
    'arrow-up.svg' => arrowUp(key: key, width: width, height: height),
    'bank-building.svg' => bankBuilding(key: key, width: width, height: height),
    'banknote-pin.svg' => banknotePin(key: key, width: width, height: height),
    'beer-mug.svg' => beerMug(key: key, width: width, height: height),
    'bicycle.svg' => bicycle(key: key, width: width, height: height),
    'bidirecional-horizontal-arrow.svg' => bidirecionalHorizontalArrow(
      key: key,
      width: width,
      height: height,
    ),
    'book.svg' => book(key: key, width: width, height: height),
    'box-pencil.svg' => boxPencil(key: key, width: width, height: height),
    'broom.svg' => broom(key: key, width: width, height: height),
    'buildings.svg' => buildings(key: key, width: width, height: height),
    'bus-front.svg' => busFront(key: key, width: width, height: height),
    'checkered-flag.svg' => checkeredFlag(
      key: key,
      width: width,
      height: height,
    ),
    'checkmark.svg' => checkmark(key: key, width: width, height: height),
    'chevron-down.svg' => chevronDown(key: key, width: width, height: height),
    'chevron-left.svg' => chevronLeft(key: key, width: width, height: height),
    'circle.svg' => circle(key: key, width: width, height: height),
    'circle-block.svg' => circleBlock(key: key, width: width, height: height),
    'circle-check.svg' => circleCheck(key: key, width: width, height: height),
    'circle-info.svg' => circleInfo(key: key, width: width, height: height),
    'classic-building.svg' => classicBuilding(
      key: key,
      width: width,
      height: height,
    ),
    'clock.svg' => clock(key: key, width: width, height: height),
    'cross.svg' => cross(key: key, width: width, height: height),
    'cross-circle.svg' => crossCircle(key: key, width: width, height: height),
    'disco-ball.svg' => discoBall(key: key, width: width, height: height),
    'double-cross.svg' => doubleCross(key: key, width: width, height: height),
    'drop.svg' => drop(key: key, width: width, height: height),
    'drop-foam.svg' => dropFoam(key: key, width: width, height: height),
    'dumbbell.svg' => dumbbell(key: key, width: width, height: height),
    'eraser.svg' => eraser(key: key, width: width, height: height),
    'ev-plug.svg' => evPlug(key: key, width: width, height: height),
    'exclamation-circle.svg' => exclamationCircle(
      key: key,
      width: width,
      height: height,
    ),
    'exclamation-triangle.svg' => exclamationTriangle(
      key: key,
      width: width,
      height: height,
    ),
    'ferris-wheel.svg' => ferrisWheel(key: key, width: width, height: height),
    'figure-crop-circle.svg' => figureCropCircle(
      key: key,
      width: width,
      height: height,
    ),
    'flame.svg' => flame(key: key, width: width, height: height),
    'fork-knife.svg' => forkKnife(key: key, width: width, height: height),
    'gas-station.svg' => gasStation(key: key, width: width, height: height),
    'gear.svg' => gear(key: key, width: width, height: height),
    'gift.svg' => gift(key: key, width: width, height: height),
    'government-building.svg' => governmentBuilding(
      key: key,
      width: width,
      height: height,
    ),
    'graduate-cap.svg' => graduateCap(key: key, width: width, height: height),
    'handshake.svg' => handshake(key: key, width: width, height: height),
    'helicopter-front.svg' => helicopterFront(
      key: key,
      width: width,
      height: height,
    ),
    'hookah.svg' => hookah(key: key, width: width, height: height),
    'hot-coffee-cup.svg' => hotCoffeeCup(
      key: key,
      width: width,
      height: height,
    ),
    'info.svg' => info(key: key, width: width, height: height),
    'letters.svg' => letters(key: key, width: width, height: height),
    'lightning-bolt.svg' => lightningBolt(
      key: key,
      width: width,
      height: height,
    ),
    'location-pin.svg' => locationPin(key: key, width: width, height: height),
    'magnifying-glass.svg' => magnifyingGlass(
      key: key,
      width: width,
      height: height,
    ),
    'magnifying-glass-sad-face.svg' => magnifyingGlassSadFace(
      key: key,
      width: width,
      height: height,
    ),
    'matini-glass.svg' => matiniGlass(key: key, width: width, height: height),
    'medical-cross.svg' => medicalCross(key: key, width: width, height: height),
    'numbers.svg' => numbers(key: key, width: width, height: height),
    'padlock.svg' => padlock(key: key, width: width, height: height),
    'padlock-open.svg' => padlockOpen(key: key, width: width, height: height),
    'paper-plane-up-right.svg' => paperPlaneUpRight(
      key: key,
      width: width,
      height: height,
    ),
    'parking-sign.svg' => parkingSign(key: key, width: width, height: height),
    'pencil.svg' => pencil(key: key, width: width, height: height),
    'phone.svg' => phone(key: key, width: width, height: height),
    'pills.svg' => pills(key: key, width: width, height: height),
    'plane-up-right.svg' => planeUpRight(
      key: key,
      width: width,
      height: height,
    ),
    'plus-signal.svg' => plusSignal(key: key, width: width, height: height),
    'pointer-hand-up.svg' => pointerHandUp(
      key: key,
      width: width,
      height: height,
    ),
    'police-badge.svg' => policeBadge(key: key, width: width, height: height),
    'popcorn.svg' => popcorn(key: key, width: width, height: height),
    'praying-figure.svg' => prayingFigure(
      key: key,
      width: width,
      height: height,
    ),
    'questionmark.svg' => questionmark(key: key, width: width, height: height),
    'rectangle-stack.svg' => rectangleStack(
      key: key,
      width: width,
      height: height,
    ),
    'road.svg' => road(key: key, width: width, height: height),
    'running-figure.svg' => runningFigure(
      key: key,
      width: width,
      height: height,
    ),
    'sad-emoticon.svg' => sadEmoticon(key: key, width: width, height: height),
    'sad-mask-happy-mask.svg' => sadMaskHappyMask(
      key: key,
      width: width,
      height: height,
    ),
    'scissors.svg' => scissors(key: key, width: width, height: height),
    'shopping-bag.svg' => shoppingBag(key: key, width: width, height: height),
    'shopping-cart.svg' => shoppingCart(key: key, width: width, height: height),
    'sleeping-figure.svg' => sleepingFigure(
      key: key,
      width: width,
      height: height,
    ),
    'smartphone.svg' => smartphone(key: key, width: width, height: height),
    'social-media-post.svg' => socialMediaPost(
      key: key,
      width: width,
      height: height,
    ),
    'stadium.svg' => stadium(key: key, width: width, height: height),
    'star.svg' => star(key: key, width: width, height: height),
    'tire.svg' => tire(key: key, width: width, height: height),
    'train-front.svg' => trainFront(key: key, width: width, height: height),
    'trash.svg' => trash(key: key, width: width, height: height),
    'tree.svg' => tree(key: key, width: width, height: height),
    'whatsapp.svg' => whatsapp(key: key, width: width, height: height),
    'wifi.svg' => wifi(key: key, width: width, height: height),
    'wifi-exclamation-mark.svg' => wifiExclamationMark(
      key: key,
      width: width,
      height: height,
    ),
    'wine-glass.svg' => wineGlass(key: key, width: width, height: height),
    'wrench.svg' => wrench(key: key, width: width, height: height),
    _ => null,
  };
}

/// A dotdart-generated SVG widget from `assets/icons/arrow-down.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ArrowDown extends StatelessWidget with _DotdartSvgSizing {
  const _ArrowDown({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ArrowDown._svgWidth;

  @override
  double get svgNativeHeight => _ArrowDown._svgHeight;

  @override
  double get svgViewBoxWidth => _ArrowDown._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ArrowDown._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ArrowDownPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ArrowDownPainter extends CustomPainter {
  _ArrowDownPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.681067105,
    0.0,
    0.0,
    0.0,
    0.0,
    0.681067105,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.529862505,
    3.189328953,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(11.2679, 1.3889)
    ..lineTo(11.2679, 14.6904)
    ..lineTo(15.2402, 11.0556)
    ..cubicTo(15.9285, 10.426, 17.0359, 10.426, 17.7243, 11.0557)
    ..cubicTo(18.4253, 11.6973, 18.4253, 12.7472, 17.7243, 13.3887)
    ..lineTo(10.7421, 19.7776)
    ..cubicTo(10.4107, 20.0808, 9.9643, 20.25, 9.5, 20.25)
    ..cubicTo(9.0357, 20.25, 8.5892, 20.0808, 8.258, 19.7776)
    ..lineTo(1.2758, 13.3887)
    ..cubicTo(0.5747, 12.7472, 0.5747, 11.6973, 1.2758, 11.0556)
    ..cubicTo(1.9641, 10.426, 3.0716, 10.426, 3.7599, 11.0557)
    ..lineTo(7.7322, 14.6904)
    ..lineTo(7.7322, 1.3889)
    ..cubicTo(7.7322, 0.4785, 8.5283, -0.25, 9.5, -0.25)
    ..cubicTo(10.4716, -0.25, 11.2679, 0.4785, 11.2679, 1.3889)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ArrowDown._viewBoxWidth;
    final scaleY = size.height / _ArrowDown._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ArrowDown._viewBoxMinX, -_ArrowDown._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowDownPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/arrow-left.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ArrowLeft extends StatelessWidget with _DotdartSvgSizing {
  const _ArrowLeft({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ArrowLeft._svgWidth;

  @override
  double get svgNativeHeight => _ArrowLeft._svgHeight;

  @override
  double get svgViewBoxWidth => _ArrowLeft._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ArrowLeft._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ArrowLeftPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ArrowLeftPainter extends CustomPainter {
  _ArrowLeftPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.692763225,
    0.0,
    0.0,
    0.0,
    0.0,
    0.692763225,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.072367751,
    3.072367751,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(8.9391, 2.2442)
    ..cubicTo(9.5758, 2.8991, 9.5758, 3.9581, 8.9391, 4.613)
    ..lineTo(5.3337, 8.3214)
    ..lineTo(18.6111, 8.3214)
    ..cubicTo(19.5178, 8.3214, 20.25, 9.0745, 20.25, 10)
    ..cubicTo(20.25, 10.9255, 19.5179, 11.6786, 18.6111, 11.6786)
    ..lineTo(5.3337, 11.6786)
    ..lineTo(8.9392, 15.387)
    ..cubicTo(9.5758, 16.042, 9.5758, 17.1009, 8.9392, 17.7559)
    ..lineTo(8.9391, 17.7559)
    ..cubicTo(8.2985, 18.4147, 7.257, 18.4147, 6.6164, 17.7559)
    ..lineTo(0.2276, 11.1845)
    ..cubicTo(-0.0785, 10.8697, -0.25, 10.4437, -0.25, 10)
    ..cubicTo(-0.25, 9.5563, -0.0785, 9.1304, 0.2276, 8.8156)
    ..lineTo(6.6164, 2.2442)
    ..cubicTo(7.257, 1.5853, 8.2985, 1.5853, 8.9391, 2.2442)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ArrowLeft._viewBoxWidth;
    final scaleY = size.height / _ArrowLeft._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ArrowLeft._viewBoxMinX, -_ArrowLeft._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowLeftPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/arrow-right.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ArrowRight extends StatelessWidget with _DotdartSvgSizing {
  const _ArrowRight({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ArrowRight._svgWidth;

  @override
  double get svgNativeHeight => _ArrowRight._svgHeight;

  @override
  double get svgViewBoxWidth => _ArrowRight._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ArrowRight._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ArrowRightPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ArrowRightPainter extends CustomPainter {
  _ArrowRightPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.691419415,
    0.0,
    0.0,
    0.0,
    0.0,
    0.691419415,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.085805846,
    3.085805846,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(13.3835, 2.2442)
    ..lineTo(19.7725, 8.8156)
    ..cubicTo(20.0785, 9.1304, 20.25, 9.5563, 20.25, 10)
    ..cubicTo(20.25, 10.4438, 20.0785, 10.8698, 19.7724, 11.1845)
    ..lineTo(13.3835, 17.7559)
    ..cubicTo(12.743, 18.4147, 11.7015, 18.4147, 11.0609, 17.7559)
    ..lineTo(11.0608, 17.7559)
    ..cubicTo(10.4242, 17.1009, 10.4242, 16.042, 11.0609, 15.387)
    ..lineTo(14.6663, 11.6786)
    ..lineTo(1.3889, 11.6786)
    ..cubicTo(0.4821, 11.6786, -0.25, 10.9255, -0.25, 10)
    ..cubicTo(-0.25, 9.0745, 0.4821, 8.3214, 1.3889, 8.3214)
    ..lineTo(14.6663, 8.3214)
    ..lineTo(11.0608, 4.613)
    ..cubicTo(10.4242, 3.9581, 10.4242, 2.8991, 11.0609, 2.2441)
    ..cubicTo(11.7015, 1.5853, 12.743, 1.5853, 13.3835, 2.2442)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ArrowRight._viewBoxWidth;
    final scaleY = size.height / _ArrowRight._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ArrowRight._viewBoxMinX, -_ArrowRight._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowRightPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/arrow-rotate-clockise.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ArrowRotateClockise extends StatelessWidget with _DotdartSvgSizing {
  const _ArrowRotateClockise({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ArrowRotateClockise._svgWidth;

  @override
  double get svgNativeHeight => _ArrowRotateClockise._svgHeight;

  @override
  double get svgViewBoxWidth => _ArrowRotateClockise._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ArrowRotateClockise._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ArrowRotateClockisePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ArrowRotateClockisePainter extends CustomPainter {
  _ArrowRotateClockisePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;
  final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;

  static final Float64List _transform0 = Float64List.fromList([
    0.715858073,
    0.0,
    0.0,
    0.0,
    0.0,
    0.715858073,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.483490235,
    2.841419271,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.7463, 2.2222)
    ..cubicTo(6.5598, 2.2222, 3.1658, 5.7045, 3.1658, 10)
    ..cubicTo(3.1658, 14.2956, 6.5598, 17.7778, 10.7463, 17.7778)
    ..cubicTo(14.0453, 17.7778, 16.8546, 15.6151, 17.8957, 12.5927)
    ..cubicTo(18.0951, 12.0141, 18.7138, 11.7109, 19.2776, 11.9153)
    ..cubicTo(19.8415, 12.1199, 20.1372, 12.7547, 19.9378, 13.3332)
    ..cubicTo(18.6004, 17.2157, 14.9916, 20, 10.7463, 20)
    ..cubicTo(5.3636, 20, 1, 15.5229, 1, 10)
    ..cubicTo(1, 4.4772, 5.3636, 0, 10.7463, 0)
    ..cubicTo(12.6156, 0, 14.1741, 0.4698, 15.5634, 1.3447)
    ..cubicTo(16.1704, 1.7269, 16.7358, 2.1808, 17.2745, 2.6925)
    ..lineTo(17.2745, 1.1111)
    ..cubicTo(17.2745, 0.4975, 17.7594, 0, 18.3575, 0)
    ..cubicTo(18.9556, 0, 19.4404, 0.4975, 19.4404, 1.1111)
    ..lineTo(19.4404, 5.5556)
    ..cubicTo(19.4404, 6.1692, 18.9556, 6.6667, 18.3575, 6.6667)
    ..lineTo(14.0258, 6.6667)
    ..cubicTo(13.4277, 6.6667, 12.9428, 6.1692, 12.9428, 5.5556)
    ..cubicTo(12.9428, 4.9419, 13.4277, 4.4444, 14.0258, 4.4444)
    ..lineTo(15.9289, 4.4444)
    ..cubicTo(15.4373, 3.9633, 14.944, 3.562, 14.4305, 3.2386)
    ..cubicTo(13.3939, 2.5858, 12.2297, 2.2222, 10.7463, 2.2222)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ArrowRotateClockise._viewBoxWidth;
    final scaleY = size.height / _ArrowRotateClockise._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_ArrowRotateClockise._viewBoxMinX,
        -_ArrowRotateClockise._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(
      __path0,
      _strokePaint
        ..color = mateoOpticalSizeColor
        ..strokeWidth = 0.75
        ..strokeCap = StrokeCap.butt
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowRotateClockisePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/arrow-up.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ArrowUp extends StatelessWidget with _DotdartSvgSizing {
  const _ArrowUp({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ArrowUp._svgWidth;

  @override
  double get svgNativeHeight => _ArrowUp._svgHeight;

  @override
  double get svgViewBoxWidth => _ArrowUp._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ArrowUp._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ArrowUpPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ArrowUpPainter extends CustomPainter {
  _ArrowUpPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.680581708,
    0.0,
    0.0,
    0.0,
    0.0,
    0.680581708,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.534473776,
    3.194182922,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.7421, 0.2224)
    ..lineTo(17.7243, 6.6113)
    ..cubicTo(18.4253, 7.2528, 18.4253, 8.3028, 17.7243, 8.9443)
    ..cubicTo(17.0359, 9.574, 15.9285, 9.574, 15.2401, 8.9443)
    ..lineTo(11.2679, 5.3096)
    ..lineTo(11.2679, 18.6111)
    ..cubicTo(11.2679, 19.5214, 10.4716, 20.25, 9.5, 20.25)
    ..cubicTo(8.5283, 20.25, 7.7322, 19.5215, 7.7322, 18.6111)
    ..lineTo(7.7322, 5.3096)
    ..lineTo(3.7599, 8.9443)
    ..cubicTo(3.0716, 9.5741, 1.9641, 9.5741, 1.2758, 8.9443)
    ..cubicTo(0.5747, 8.3028, 0.5747, 7.2528, 1.2758, 6.6113)
    ..lineTo(8.2579, 0.2224)
    ..cubicTo(8.5892, -0.0808, 9.0357, -0.25, 9.5, -0.25)
    ..cubicTo(9.9643, -0.25, 10.4107, -0.0808, 10.7421, 0.2224)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ArrowUp._viewBoxWidth;
    final scaleY = size.height / _ArrowUp._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ArrowUp._viewBoxMinX, -_ArrowUp._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowUpPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/bank-building.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _BankBuilding extends StatelessWidget with _DotdartSvgSizing {
  const _BankBuilding({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _BankBuilding._svgWidth;

  @override
  double get svgNativeHeight => _BankBuilding._svgHeight;

  @override
  double get svgViewBoxWidth => _BankBuilding._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _BankBuilding._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BankBuildingPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BankBuildingPainter extends CustomPainter {
  _BankBuildingPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.827133887,
    0.0,
    0.0,
    0.0,
    0.0,
    0.827133887,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.883748736,
    1.741585099,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(6.5101, 15.4311)
    ..cubicTo(6.5101, 15.8659, 6.1963, 16.1318, 5.8094, 16.1318)
    ..lineTo(2.8148, 16.1318)
    ..cubicTo(2.4278, 16.1318, 2.1141, 15.8181, 2.1141, 15.4311)
    ..cubicTo(2.1141, 14.7484, 2.9295, 14.1769, 2.9295, 13.4943)
    ..lineTo(2.9295, 10.6573)
    ..cubicTo(2.9295, 9.9515, 2.0515, 9.3844, 2.0515, 8.6787)
    ..cubicTo(2.0515, 8.2917, 2.3652, 7.9779, 2.7522, 7.9779)
    ..lineTo(5.7451, 7.9779)
    ..cubicTo(6.1321, 7.9779, 6.4458, 8.2917, 6.4458, 8.6787)
    ..cubicTo(6.4458, 9.375, 5.6049, 9.9439, 5.6049, 10.6402)
    ..lineTo(5.6049, 13.404)
    ..cubicTo(5.6049, 14.1365, 6.5101, 14.6986, 6.5101, 15.4311)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(17.4872, 15.5301)
    ..cubicTo(17.4872, 15.9774, 17.1645, 16.2508, 16.7665, 16.2508)
    ..lineTo(13.6864, 16.2508)
    ..cubicTo(13.2883, 16.2508, 12.9656, 15.9281, 12.9656, 15.5301)
    ..cubicTo(12.9656, 14.8279, 13.8043, 14.2401, 13.8043, 13.5379)
    ..lineTo(13.8043, 10.6199)
    ..cubicTo(13.8043, 9.894, 12.9012, 9.3107, 12.9012, 8.5847)
    ..cubicTo(12.9012, 8.1867, 13.2239, 7.864, 13.622, 7.864)
    ..lineTo(16.7004, 7.864)
    ..cubicTo(17.0985, 7.864, 17.4211, 8.1867, 17.4211, 8.5847)
    ..cubicTo(17.4211, 9.301, 16.5563, 9.8861, 16.5563, 10.6023)
    ..lineTo(16.5563, 13.4451)
    ..cubicTo(16.5563, 14.1986, 17.4872, 14.7766, 17.4872, 15.5301)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(2.3696, 17.1828)
    ..cubicTo(2.7574, 17.167, 3.2052, 17.1793, 3.5964, 17.1793)
    ..lineTo(16.7349, 17.179)
    ..cubicTo(16.9148, 17.1791, 17.2463, 17.169, 17.4195, 17.1925)
    ..cubicTo(17.6704, 17.2283, 17.9046, 17.362, 18.087, 17.573)
    ..cubicTo(18.6413, 18.2053, 18.5312, 19.2925, 17.8725, 19.7538)
    ..cubicTo(17.6581, 19.9039, 17.4756, 19.9389, 17.2308, 19.9447)
    ..lineTo(2.6982, 19.944)
    ..cubicTo(2.225, 19.9437, 1.876, 19.9834, 1.5034, 19.5553)
    ..cubicTo(1.2866, 19.3079, 1.1618, 18.9651, 1.1574, 18.605)
    ..cubicTo(1.1454, 17.8824, 1.5673, 17.2927, 2.1576, 17.1955)
    ..cubicTo(2.2273, 17.1841, 2.2992, 17.1841, 2.3696, 17.1828)
    ..close();

  static final Path __path3 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(5.9238, 3.7849)
    ..cubicTo(5.9238, 1.6946, 7.6183, 0, 9.7087, 0)
    ..cubicTo(11.7991, 0, 13.4936, 1.6946, 13.4936, 3.7849)
    ..cubicTo(13.4936, 5.8753, 11.7991, 7.5699, 9.7087, 7.5699)
    ..cubicTo(7.6183, 7.5699, 5.9238, 5.8753, 5.9238, 3.7849)
    ..close()
    ..moveTo(9.7087, 1.3247)
    ..cubicTo(9.8152, 1.3247, 9.9115, 1.3687, 9.9803, 1.4396)
    ..cubicTo(10.0464, 1.5077, 10.0872, 1.6007, 10.0872, 1.7032)
    ..lineTo(10.0872, 1.9393)
    ..cubicTo(10.0898, 1.9399, 10.0924, 1.9406, 10.095, 1.9413)
    ..cubicTo(10.3349, 2.0034, 10.5522, 2.123, 10.7184, 2.2904)
    ..cubicTo(10.7608, 2.3331, 10.7998, 2.3789, 10.8351, 2.4277)
    ..cubicTo(10.9575, 2.5971, 10.9195, 2.8337, 10.7501, 2.9562)
    ..cubicTo(10.599, 3.0655, 10.3944, 3.047, 10.265, 2.9214)
    ..cubicTo(10.2494, 2.9062, 10.2348, 2.8895, 10.2216, 2.8712)
    ..cubicTo(10.211, 2.8565, 10.1986, 2.8419, 10.1847, 2.8276)
    ..cubicTo(10.0908, 2.7313, 9.924, 2.6495, 9.7087, 2.6495)
    ..lineTo(9.6036, 2.6495)
    ..cubicTo(9.2649, 2.6495, 9.141, 2.8557, 9.141, 2.9438)
    ..lineTo(9.141, 2.9727)
    ..cubicTo(9.141, 3.0198, 9.1633, 3.0869, 9.2275, 3.1492)
    ..cubicTo(9.2653, 3.1858, 9.3174, 3.2208, 9.3879, 3.249)
    ..lineTo(10.3106, 3.6181)
    ..cubicTo(10.4703, 3.682, 10.6168, 3.777, 10.7355, 3.8968)
    ..cubicTo(10.9169, 4.0799, 11.0334, 4.3209, 11.0334, 4.5972)
    ..cubicTo(11.0334, 5.1547, 10.5879, 5.5315, 10.0872, 5.643)
    ..lineTo(10.0872, 5.8667)
    ..cubicTo(10.0872, 6.0757, 9.9177, 6.2452, 9.7087, 6.2452)
    ..cubicTo(9.6062, 6.2452, 9.5132, 6.2044, 9.445, 6.1382)
    ..cubicTo(9.3742, 6.0694, 9.3302, 5.9732, 9.3302, 5.8667)
    ..lineTo(9.3302, 5.6364)
    ..lineTo(9.3302, 5.6306)
    ..cubicTo(9.0903, 5.5699, 8.8726, 5.4518, 8.7055, 5.2859)
    ..cubicTo(8.6606, 5.2414, 8.6194, 5.1935, 8.5823, 5.1422)
    ..cubicTo(8.4599, 4.9728, 8.4979, 4.7362, 8.6673, 4.6137)
    ..cubicTo(8.8215, 4.5022, 9.0315, 4.5237, 9.1603, 4.6563)
    ..cubicTo(9.1729, 4.6694, 9.1848, 4.6835, 9.1958, 4.6986)
    ..cubicTo(9.278, 4.8124, 9.4614, 4.9204, 9.7087, 4.9204)
    ..lineTo(9.7777, 4.9204)
    ..cubicTo(10.1363, 4.9204, 10.2764, 4.7012, 10.2764, 4.5972)
    ..cubicTo(10.2764, 4.5225, 10.22, 4.3971, 10.0295, 4.3209)
    ..lineTo(9.1068, 3.9518)
    ..cubicTo(8.703, 3.7903, 8.384, 3.4297, 8.384, 2.9727)
    ..lineTo(8.384, 2.9438)
    ..cubicTo(8.384, 2.3897, 8.8341, 2.0208, 9.3302, 1.9202)
    ..lineTo(9.3302, 1.7032)
    ..cubicTo(9.3302, 1.4942, 9.4997, 1.3247, 9.7087, 1.3247)
    ..close();

  static final Path __path4 = Path()
    ..moveTo(5.1283, 2.6339)
    ..cubicTo(5.0349, 3.0047, 4.9853, 3.3929, 4.9853, 3.7928)
    ..cubicTo(4.9853, 5.0188, 5.4517, 6.1359, 6.2166, 6.9763)
    ..lineTo(2.9371, 6.9763)
    ..cubicTo(1.439, 6.9763, 0.9204, 4.9843, 2.2283, 4.2538)
    ..lineTo(5.1283, 2.6339)
    ..close();

  static final Path __path5 = Path()
    ..moveTo(17.3492, 4.2585)
    ..cubicTo(18.6477, 4.9953, 18.1249, 6.9763, 16.6319, 6.9763)
    ..lineTo(13.2164, 6.9763)
    ..cubicTo(13.9814, 6.1359, 14.4477, 5.0188, 14.4477, 3.7928)
    ..cubicTo(14.4477, 3.3492, 14.3866, 2.9199, 14.2725, 2.5128)
    ..lineTo(17.3492, 4.2585)
    ..close();

  static final Path __path6 = Path()
    ..moveTo(7.7786, 8.1101)
    ..cubicTo(8.37, 8.376, 9.026, 8.5239, 9.7165, 8.5239)
    ..cubicTo(10.3915, 8.5239, 11.0334, 8.3826, 11.6143, 8.1279)
    ..cubicTo(11.7772, 8.2562, 11.8817, 8.4552, 11.8817, 8.6786)
    ..cubicTo(11.8817, 9.375, 11.0409, 9.9439, 11.0409, 10.6402)
    ..lineTo(11.0409, 13.404)
    ..cubicTo(11.0409, 14.1365, 11.946, 14.6986, 11.946, 15.4311)
    ..cubicTo(11.946, 15.8659, 11.6323, 16.1318, 11.2453, 16.1318)
    ..lineTo(8.2507, 16.1318)
    ..cubicTo(7.8637, 16.1318, 7.55, 15.8181, 7.55, 15.4311)
    ..cubicTo(7.55, 14.7484, 8.3654, 14.1769, 8.3654, 13.4943)
    ..lineTo(8.3654, 10.6573)
    ..cubicTo(8.3654, 9.9515, 7.4874, 9.3844, 7.4874, 8.6786)
    ..cubicTo(7.4874, 8.4446, 7.6022, 8.2373, 7.7786, 8.1101)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _BankBuilding._viewBoxWidth;
    final scaleY = size.height / _BankBuilding._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_BankBuilding._viewBoxMinX, -_BankBuilding._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path5, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path6, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BankBuildingPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/banknote-pin.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _BanknotePin extends StatelessWidget with _DotdartSvgSizing {
  const _BanknotePin({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _BanknotePin._svgWidth;

  @override
  double get svgNativeHeight => _BanknotePin._svgHeight;

  @override
  double get svgViewBoxWidth => _BanknotePin._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _BanknotePin._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BanknotePinPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BanknotePinPainter extends CustomPainter {
  _BanknotePinPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.759806071,
    0.0,
    0.0,
    0.0,
    0.0,
    0.759806071,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.401939292,
    2.663122628,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(16.0428, 8.0297)
    ..lineTo(15.1649, 7.3443)
    ..lineTo(14.0609, 8.53)
    ..cubicTo(13.9299, 8.6706, 13.701, 8.6887, 13.5496, 8.5705)
    ..cubicTo(13.3981, 8.4522, 13.3815, 8.2424, 13.5124, 8.1018)
    ..lineTo(14.6164, 6.9162)
    ..lineTo(13.7385, 6.2308)
    ..cubicTo(12.8086, 5.5048, 13.2383, 4.1011, 14.4513, 3.9026)
    ..lineTo(15.5343, 3.7253)
    ..cubicTo(15.7744, 3.686, 15.9786, 3.5391, 16.0781, 3.3342)
    ..lineTo(16.3358, 2.8034)
    ..cubicTo(16.7331, 1.9852, 17.8725, 1.7389, 18.6072, 2.3126)
    ..lineTo(19.4983, 3.0082)
    ..cubicTo(20.233, 3.5818, 20.1477, 4.6509, 19.3281, 5.1394)
    ..lineTo(18.7965, 5.4564)
    ..cubicTo(18.5912, 5.5788, 18.4651, 5.7866, 18.4607, 6.0099)
    ..lineTo(18.4408, 7.0172)
    ..cubicTo(18.4185, 8.1453, 16.9727, 8.7557, 16.0428, 8.0297)
    ..close();

  static final Path __path1 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(12.6281, 4.0379)
    ..cubicTo(12.5198, 4.2093, 12.4343, 4.3942, 12.3749, 4.5883)
    ..cubicTo(12.1214, 5.4164, 12.3562, 6.3676, 13.1487, 6.9864)
    ..lineTo(13.2023, 7.0282)
    ..lineTo(12.8111, 7.4486)
    ..cubicTo(12.2972, 8.0006, 12.3652, 8.8617, 12.9597, 9.3259)
    ..lineTo(12.9599, 9.3261)
    ..cubicTo(13.5031, 9.7501, 14.2928, 9.6876, 14.7624, 9.1833)
    ..lineTo(15.2676, 8.6405)
    ..lineTo(15.4529, 8.7851)
    ..lineTo(15.5258, 8.8402)
    ..cubicTo(16.2862, 9.3906, 17.2198, 9.4122, 17.955, 9.1018)
    ..cubicTo(18.0567, 9.0589, 18.1564, 9.0082, 18.2533, 8.9508)
    ..lineTo(18.2533, 13.9943)
    ..cubicTo(18.2533, 15.8272, 16.7674, 17.3132, 14.9345, 17.3132)
    ..lineTo(3.3188, 17.3132)
    ..cubicTo(1.4859, 17.3132, 0, 15.8272, 0, 13.9943)
    ..lineTo(0, 7.3567)
    ..cubicTo(0, 5.5238, 1.4859, 4.0379, 3.3188, 4.0379)
    ..lineTo(12.6281, 4.0379)
    ..close()
    ..moveTo(14.9345, 13.9943)
    ..cubicTo(14.4763, 13.9944, 14.1049, 14.3658, 14.1049, 14.824)
    ..cubicTo(14.1049, 15.2822, 14.4763, 15.6537, 14.9345, 15.6538)
    ..lineTo(15.7643, 15.6538)
    ..cubicTo(16.2225, 15.6537, 16.5939, 15.2822, 16.5939, 14.824)
    ..cubicTo(16.5939, 14.3658, 16.2225, 13.9944, 15.7643, 13.9943)
    ..lineTo(14.9345, 13.9943)
    ..close()
    ..moveTo(9.1267, 8.6012)
    ..cubicTo(7.9811, 8.6012, 7.0524, 9.53, 7.0524, 10.6755)
    ..cubicTo(7.0524, 11.8211, 7.9811, 12.7498, 9.1267, 12.7498)
    ..cubicTo(10.2722, 12.7498, 11.201, 11.8211, 11.201, 10.6755)
    ..cubicTo(11.201, 9.53, 10.2722, 8.6012, 9.1267, 8.6012)
    ..close()
    ..moveTo(2.489, 5.6973)
    ..cubicTo(2.0308, 5.6973, 1.6594, 6.0689, 1.6594, 6.5271)
    ..cubicTo(1.6594, 6.9853, 2.0308, 7.3567, 2.489, 7.3567)
    ..lineTo(3.3188, 7.3567)
    ..cubicTo(3.777, 7.3567, 4.1484, 6.9853, 4.1484, 6.5271)
    ..cubicTo(4.1484, 6.0689, 3.777, 5.6973, 3.3188, 5.6973)
    ..lineTo(2.489, 5.6973)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _BanknotePin._viewBoxWidth;
    final scaleY = size.height / _BanknotePin._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_BanknotePin._viewBoxMinX, -_BanknotePin._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BanknotePinPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/beer-mug.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _BeerMug extends StatelessWidget with _DotdartSvgSizing {
  const _BeerMug({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _BeerMug._svgWidth;

  @override
  double get svgNativeHeight => _BeerMug._svgHeight;

  @override
  double get svgViewBoxWidth => _BeerMug._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _BeerMug._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BeerMugPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BeerMugPainter extends CustomPainter {
  _BeerMugPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.728175568,
    0.0,
    0.0,
    0.0,
    0.0,
    0.728175568,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.718244318,
    2.877532724,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(7.0614, 0.0532)
    ..cubicTo(7.5582, -0.0178, 8.0634, -0.0177, 8.5602, 0.0532)
    ..lineTo(11.3726, 0.4558)
    ..cubicTo(11.5212, 0.4771, 11.6717, 0.4868, 11.8218, 0.4869)
    ..lineTo(13.6549, 0.4869)
    ..cubicTo(14.6626, 0.487, 15.6039, 0.9911, 16.1629, 1.8294)
    ..lineTo(16.2706, 1.9919)
    ..cubicTo(16.673, 2.5955, 16.8026, 3.3407, 16.6267, 4.0445)
    ..cubicTo(16.4872, 4.6022, 16.1732, 5.0693, 15.7603, 5.4077)
    ..lineTo(15.7603, 5.7866)
    ..cubicTo(18.1018, 5.7866, 19.9998, 7.685, 20, 10.0263)
    ..cubicTo(20, 12.3678, 18.1018, 14.266, 15.7603, 14.266)
    ..lineTo(15.7603, 15.326)
    ..cubicTo(15.7603, 17.6675, 13.8621, 19.5657, 11.5205, 19.5657)
    ..lineTo(5.161, 19.5657)
    ..cubicTo(2.8194, 19.5657, 0.9212, 17.6675, 0.9212, 15.326)
    ..lineTo(0.9212, 5.8984)
    ..cubicTo(0.9212, 5.6574, 0.8231, 5.4303, 0.6894, 5.2297)
    ..lineTo(0.4782, 4.913)
    ..cubicTo(0.0335, 4.2458, -0.1095, 3.4209, 0.0849, 2.643)
    ..cubicTo(0.4017, 1.3762, 1.5407, 0.4871, 2.8465, 0.4869)
    ..lineTo(3.8806, 0.4869)
    ..cubicTo(3.9773, 0.4869, 4.0746, 0.4809, 4.1704, 0.4672)
    ..lineTo(7.0614, 0.0532)
    ..close()
    ..moveTo(15.7603, 12.1462)
    ..cubicTo(16.9311, 12.1462, 17.8801, 11.197, 17.8801, 10.0263)
    ..cubicTo(17.8799, 8.8557, 16.931, 7.9064, 15.7603, 7.9064)
    ..lineTo(15.7603, 12.1462)
    ..close()
    ..moveTo(8.1804, 1.9382)
    ..cubicTo(7.8822, 1.8956, 7.579, 1.8956, 7.2808, 1.9382)
    ..lineTo(4.4706, 2.5654)
    ..cubicTo(4.2754, 2.5932, 4.0777, 2.6067, 3.8806, 2.6068)
    ..lineTo(2.8465, 2.6068)
    ..cubicTo(2.5134, 2.607, 2.2225, 2.8342, 2.1416, 3.1574)
    ..cubicTo(2.0921, 3.3559, 2.1286, 3.5669, 2.242, 3.7371)
    ..lineTo(2.4532, 4.0538)
    ..cubicTo(2.5125, 4.1429, 2.6132, 4.1964, 2.7202, 4.1967)
    ..cubicTo(4.0681, 4.1967, 5.1607, 5.2896, 5.161, 6.6374)
    ..lineTo(5.161, 6.9055)
    ..cubicTo(5.161, 7.458, 5.6095, 7.9059, 6.1619, 7.9064)
    ..lineTo(6.2209, 7.9064)
    ..cubicTo(6.8063, 7.9064, 7.2808, 7.4318, 7.2808, 6.8465)
    ..lineTo(7.2808, 6.7865)
    ..cubicTo(7.2808, 5.0537, 8.8374, 3.7352, 10.5466, 4.0197)
    ..lineTo(11.1428, 4.119)
    ..cubicTo(11.3349, 4.151, 11.5324, 4.136, 11.7173, 4.0745)
    ..lineTo(12.3083, 3.8779)
    ..cubicTo(12.8047, 3.7124, 13.3387, 3.691, 13.8464, 3.8178)
    ..lineTo(14.0183, 3.8613)
    ..cubicTo(14.2619, 3.9221, 14.5089, 3.7737, 14.57, 3.5301)
    ..cubicTo(14.601, 3.4058, 14.5778, 3.2744, 14.5068, 3.1678)
    ..lineTo(14.3992, 3.0053)
    ..cubicTo(14.2332, 2.7567, 13.9538, 2.6069, 13.6549, 2.6068)
    ..lineTo(11.8218, 2.6068)
    ..cubicTo(11.5713, 2.6067, 11.3203, 2.5894, 11.0724, 2.554)
    ..lineTo(8.1804, 1.9382)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _BeerMug._viewBoxWidth;
    final scaleY = size.height / _BeerMug._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_BeerMug._viewBoxMinX, -_BeerMug._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BeerMugPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/bicycle.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Bicycle extends StatelessWidget with _DotdartSvgSizing {
  const _Bicycle({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Bicycle._svgWidth;

  @override
  double get svgNativeHeight => _Bicycle._svgHeight;

  @override
  double get svgViewBoxWidth => _Bicycle._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Bicycle._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BicyclePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BicyclePainter extends CustomPainter {
  _BicyclePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.734897106,
    0.0,
    0.0,
    0.0,
    0.0,
    0.734897106,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.651028943,
    2.892167056,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.8333, 3.8333)
    ..cubicTo(10.8333, 3.3731, 11.2064, 3, 11.6667, 3)
    ..cubicTo(13.0239, 3, 14.2204, 3.8903, 14.6104, 5.1902)
    ..lineTo(15.4583, 8.0167)
    ..cubicTo(15.5818, 8.0057, 15.7069, 8, 15.8333, 8)
    ..cubicTo(18.1345, 8, 20, 9.8655, 20, 12.1667)
    ..cubicTo(20, 14.4678, 18.1345, 16.3333, 15.8333, 16.3333)
    ..cubicTo(13.5322, 16.3333, 11.6667, 14.4678, 11.6667, 12.1667)
    ..cubicTo(11.6667, 10.5787, 12.555, 9.1982, 13.8618, 8.495)
    ..lineTo(13.6277, 7.7149)
    ..lineTo(10.747, 10.9157)
    ..cubicTo(10.7379, 11.1616, 10.6775, 11.4171, 10.5417, 11.6724)
    ..cubicTo(10.1228, 12.4604, 9.2918, 13, 8.3333, 13)
    ..lineTo(8.25, 13)
    ..cubicTo(7.8639, 14.9018, 6.1825, 16.3333, 4.1667, 16.3333)
    ..cubicTo(1.8655, 16.3333, 0, 14.4678, 0, 12.1667)
    ..cubicTo(0, 9.8655, 1.8655, 8, 4.1667, 8)
    ..cubicTo(6.1825, 8, 7.8639, 9.4315, 8.25, 11.3333)
    ..lineTo(8.3333, 11.3333)
    ..cubicTo(8.6512, 11.3333, 8.929, 11.1556, 9.0701, 10.8901)
    ..cubicTo(9.07, 10.8903, 9.0702, 10.8899, 9.0701, 10.8901)
    ..cubicTo(9.0739, 10.883, 9.091, 10.8515, 9.0659, 10.7529)
    ..cubicTo(9.0373, 10.641, 8.9654, 10.4943, 8.8479, 10.3327)
    ..lineTo(5.9927, 6.4068)
    ..cubicTo(5.9753, 6.3829, 5.9594, 6.3584, 5.9449, 6.3333)
    ..lineTo(5.8333, 6.3333)
    ..cubicTo(5.3731, 6.3333, 5, 5.9602, 5, 5.5)
    ..cubicTo(5, 5.0398, 5.3731, 4.6667, 5.8333, 4.6667)
    ..lineTo(8.3333, 4.6667)
    ..cubicTo(8.7936, 4.6667, 9.1667, 5.0398, 9.1667, 5.5)
    ..cubicTo(9.1667, 5.9602, 8.7936, 6.3333, 8.3333, 6.3333)
    ..lineTo(8.0001, 6.3333)
    ..lineTo(10.0688, 9.1778)
    ..lineTo(13.0672, 5.8463)
    ..lineTo(13.0141, 5.6692)
    ..cubicTo(12.8356, 5.0742, 12.2879, 4.6667, 11.6667, 4.6667)
    ..cubicTo(11.2064, 4.6667, 10.8333, 4.2936, 10.8333, 3.8333)
    ..close()
    ..moveTo(6.5244, 11.3333)
    ..cubicTo(6.1812, 10.3623, 5.2552, 9.6667, 4.1667, 9.6667)
    ..cubicTo(2.786, 9.6667, 1.6667, 10.7859, 1.6667, 12.1667)
    ..cubicTo(1.6667, 13.5474, 2.786, 14.6667, 4.1667, 14.6667)
    ..cubicTo(5.2552, 14.6667, 6.1812, 13.971, 6.5244, 13)
    ..lineTo(4.1667, 13)
    ..cubicTo(3.7064, 13, 3.3333, 12.6269, 3.3333, 12.1667)
    ..cubicTo(3.3333, 11.7064, 3.7064, 11.3333, 4.1667, 11.3333)
    ..lineTo(6.5244, 11.3333)
    ..close()
    ..moveTo(15.9542, 9.6695)
    ..lineTo(16.6315, 11.9273)
    ..cubicTo(16.7637, 12.368, 16.5136, 12.8326, 16.0727, 12.9648)
    ..cubicTo(15.632, 13.0971, 15.1674, 12.8469, 15.0352, 12.4061)
    ..lineTo(14.3578, 10.1483)
    ..cubicTo(13.7367, 10.6032, 13.3333, 11.3378, 13.3333, 12.1667)
    ..cubicTo(13.3333, 13.5474, 14.4526, 14.6667, 15.8333, 14.6667)
    ..cubicTo(17.2141, 14.6667, 18.3333, 13.5474, 18.3333, 12.1667)
    ..cubicTo(18.3333, 10.8265, 17.2787, 9.7326, 15.9542, 9.6695)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Bicycle._viewBoxWidth;
    final scaleY = size.height / _Bicycle._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Bicycle._viewBoxMinX, -_Bicycle._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BicyclePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/bidirecional-horizontal-arrow.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _BidirecionalHorizontalArrow extends StatelessWidget with _DotdartSvgSizing {
  const _BidirecionalHorizontalArrow({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _BidirecionalHorizontalArrow._svgWidth;

  @override
  double get svgNativeHeight => _BidirecionalHorizontalArrow._svgHeight;

  @override
  double get svgViewBoxWidth => _BidirecionalHorizontalArrow._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _BidirecionalHorizontalArrow._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BidirecionalHorizontalArrowPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BidirecionalHorizontalArrowPainter extends CustomPainter {
  _BidirecionalHorizontalArrowPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.777215413,
    0.0,
    0.0,
    0.0,
    0.0,
    0.777215413,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.227845869,
    1.924246098,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(13.6156, 15.7573)
    ..cubicTo(14.0109, 16.1526, 14.6518, 16.1526, 15.0472, 15.7573)
    ..lineTo(19.7035, 11.101)
    ..cubicTo(19.8933, 10.9111, 20, 10.6536, 20, 10.3852)
    ..cubicTo(20, 10.1167, 19.8934, 9.8593, 19.7035, 9.6694)
    ..lineTo(15.0472, 5.013)
    ..cubicTo(14.6518, 4.6177, 14.0109, 4.6177, 13.6156, 5.013)
    ..cubicTo(13.2203, 5.4084, 13.2203, 6.0493, 13.6156, 6.4446)
    ..lineTo(16.544, 9.3729)
    ..lineTo(6.4358, 9.3729)
    ..cubicTo(5.8767, 9.3729, 5.4236, 9.8262, 5.4236, 10.3852)
    ..cubicTo(5.4236, 10.9443, 5.8767, 11.3974, 6.4358, 11.3974)
    ..lineTo(16.544, 11.3974)
    ..lineTo(13.6156, 14.3258)
    ..cubicTo(13.2203, 14.7211, 13.2203, 15.362, 13.6156, 15.7573)
    ..close();

  static final Path __path1 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(6.3844, 15.7573)
    ..cubicTo(5.989, 16.1526, 5.3482, 16.1526, 4.9528, 15.7573)
    ..lineTo(0.2965, 11.101)
    ..cubicTo(0.1067, 10.9111, 0, 10.6536, 0, 10.3852)
    ..cubicTo(0, 10.1167, 0.1066, 9.8593, 0.2965, 9.6694)
    ..lineTo(4.9528, 5.013)
    ..cubicTo(5.3482, 4.6177, 5.989, 4.6177, 6.3844, 5.013)
    ..cubicTo(6.7797, 5.4084, 6.7797, 6.0493, 6.3844, 6.4446)
    ..lineTo(3.456, 9.3729)
    ..lineTo(13.5642, 9.3729)
    ..cubicTo(14.1233, 9.3729, 14.5764, 9.8262, 14.5764, 10.3852)
    ..cubicTo(14.5764, 10.9443, 14.1233, 11.3974, 13.5642, 11.3974)
    ..lineTo(3.456, 11.3974)
    ..lineTo(6.3844, 14.3258)
    ..cubicTo(6.7797, 14.7211, 6.7797, 15.362, 6.3844, 15.7573)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _BidirecionalHorizontalArrow._viewBoxWidth;
    final scaleY = size.height / _BidirecionalHorizontalArrow._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_BidirecionalHorizontalArrow._viewBoxMinX,
        -_BidirecionalHorizontalArrow._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(
    covariant _BidirecionalHorizontalArrowPainter oldDelegate,
  ) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/book.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Book extends StatelessWidget with _DotdartSvgSizing {
  const _Book({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Book._svgWidth;

  @override
  double get svgNativeHeight => _Book._svgHeight;

  @override
  double get svgViewBoxWidth => _Book._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Book._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BookPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BookPainter extends CustomPainter {
  _BookPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.855329139,
    0.0,
    0.0,
    0.0,
    0.0,
    0.855329139,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.446708606,
    1.84764414,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(14.8564, 2.0069)
    ..cubicTo(16.3975, 1.8956, 17.7367, 3.1412, 17.9876, 4.6087)
    ..cubicTo(18.0597, 5.0307, 18.0335, 5.4486, 18.0358, 5.8737)
    ..lineTo(18.0381, 8.0143)
    ..lineTo(18.039, 10.0438)
    ..cubicTo(18.0389, 10.5099, 18.0596, 11.038, 17.9864, 11.4927)
    ..cubicTo(17.9204, 11.9255, 17.7531, 12.3365, 17.4981, 12.6923)
    ..cubicTo(16.8251, 13.6509, 15.7603, 13.8409, 14.7032, 14.0328)
    ..lineTo(13.1951, 14.2965)
    ..cubicTo(12.6482, 14.3866, 12.1033, 14.4892, 11.5611, 14.6045)
    ..cubicTo(11.3089, 14.6606, 11.0595, 14.7291, 10.8112, 14.7955)
    ..cubicTo(10.6663, 14.8343, 10.5079, 14.7581, 10.494, 14.6042)
    ..cubicTo(10.4824, 14.4751, 10.489, 14.3157, 10.4892, 14.1846)
    ..lineTo(10.4895, 13.3813)
    ..lineTo(10.4884, 10.5368)
    ..lineTo(10.4883, 5.5805)
    ..lineTo(10.4879, 4.0001)
    ..cubicTo(10.4877, 3.7112, 10.4864, 3.4222, 10.4905, 3.1333)
    ..cubicTo(10.4905, 3.0198, 10.5634, 2.8942, 10.6789, 2.8652)
    ..cubicTo(11.1591, 2.7448, 11.6491, 2.6581, 12.1326, 2.5522)
    ..lineTo(13.5419, 2.2521)
    ..cubicTo(13.9292, 2.1669, 14.4753, 2.0359, 14.8564, 2.0069)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(4.6886, 2.0066)
    ..cubicTo(4.8209, 1.9992, 4.9536, 2.0004, 5.0858, 2.0102)
    ..cubicTo(5.4076, 2.035, 5.8787, 2.1496, 6.2041, 2.2202)
    ..lineTo(7.6788, 2.5351)
    ..cubicTo(7.9986, 2.6047, 8.319, 2.6719, 8.6399, 2.7365)
    ..cubicTo(8.8414, 2.7779, 9.046, 2.8196, 9.2445, 2.8729)
    ..cubicTo(9.3659, 2.9056, 9.4221, 3.0356, 9.4227, 3.1514)
    ..cubicTo(9.4276, 4.0702, 9.4252, 4.989, 9.4251, 5.9078)
    ..lineTo(9.4259, 11.1078)
    ..lineTo(9.4253, 13.5356)
    ..lineTo(9.4258, 14.2425)
    ..cubicTo(9.426, 14.402, 9.4653, 14.6751, 9.3133, 14.7688)
    ..cubicTo(9.1724, 14.8555, 8.9434, 14.7488, 8.7946, 14.7089)
    ..cubicTo(8.2316, 14.558, 7.6575, 14.4603, 7.0841, 14.3596)
    ..cubicTo(6.4341, 14.2335, 5.7682, 14.1381, 5.1166, 14.0158)
    ..cubicTo(4.623, 13.9233, 4.1718, 13.8517, 3.7004, 13.6671)
    ..cubicTo(3.3979, 13.5502, 3.1163, 13.3853, 2.8663, 13.1787)
    ..cubicTo(2.1494, 12.586, 1.8678, 11.726, 1.8776, 10.8228)
    ..cubicTo(1.8804, 10.5629, 1.877, 10.2996, 1.8771, 10.0394)
    ..lineTo(1.8781, 8.0403)
    ..lineTo(1.8772, 6.0951)
    ..cubicTo(1.8764, 5.5963, 1.849, 5.0133, 1.9429, 4.5304)
    ..cubicTo(2.0482, 4.0065, 2.2813, 3.5168, 2.6216, 3.1049)
    ..cubicTo(3.1564, 2.4633, 3.8572, 2.0832, 4.6886, 2.0066)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(19.4771, 5.1076)
    ..cubicTo(19.7651, 5.1076, 19.9986, 5.3322, 19.9986, 5.6094)
    ..lineTo(19.9986, 12.4603)
    ..cubicTo(19.9994, 12.5012, 19.9991, 12.5429, 19.9986, 12.5825)
    ..lineTo(19.9986, 12.7545)
    ..cubicTo(19.9986, 12.7734, 19.9979, 12.7922, 19.9967, 12.8109)
    ..lineTo(19.995, 13.2939)
    ..cubicTo(19.9971, 13.8359, 20.0482, 14.2206, 19.7697, 14.7182)
    ..cubicTo(19.1444, 15.8352, 17.9857, 15.9453, 16.7921, 15.9853)
    ..cubicTo(14.9543, 16.047, 13.0528, 16.0232, 11.316, 16.6614)
    ..cubicTo(11.0433, 16.7615, 10.7883, 16.8936, 10.5115, 16.9819)
    ..cubicTo(9.7162, 17.2319, 9.1323, 16.8202, 8.4219, 16.5852)
    ..cubicTo(8.0142, 16.4537, 7.597, 16.35, 7.1735, 16.2749)
    ..cubicTo(5.8992, 16.0398, 4.5913, 16.0445, 3.2995, 15.9921)
    ..cubicTo(2.8445, 15.9737, 2.3701, 15.959, 1.9238, 15.8735)
    ..cubicTo(1.6806, 15.8291, 1.4452, 15.7526, 1.2249, 15.6461)
    ..cubicTo(0.6829, 15.3808, 0.2762, 14.9514, 0.0936, 14.4003)
    ..cubicTo(0.0516, 14.275, 0.0243, 14.1458, 0.0123, 14.015)
    ..cubicTo(-0.0134, 13.7231, 0.0126, 13.2967, 0.004, 12.9929)
    ..cubicTo(0.0011, 12.8923, -0.0034, 12.4737, 0.0042, 12.3445)
    ..lineTo(0.0042, 5.584)
    ..cubicTo(0.0042, 5.3209, 0.2259, 5.1076, 0.4993, 5.1076)
    ..cubicTo(0.7748, 5.1076, 0.9974, 5.3216, 0.9952, 5.5867)
    ..cubicTo(0.9851, 6.798, 0.965, 10.0203, 1.0191, 11.9058)
    ..cubicTo(1.0191, 12.0609, 1.0359, 12.1992, 1.064, 12.4355)
    ..cubicTo(1.4741, 13.5139, 2.3905, 14.2995, 3.5387, 14.6002)
    ..cubicTo(3.9939, 14.7194, 4.4534, 14.7987, 4.9187, 14.8743)
    ..cubicTo(6.1048, 15.0784, 7.3041, 15.2289, 8.4773, 15.4943)
    ..cubicTo(8.7386, 15.5601, 9.0415, 15.6297, 9.2788, 15.7496)
    ..cubicTo(9.6474, 15.9357, 9.9315, 16.1614, 10.3581, 15.9333)
    ..cubicTo(10.5289, 15.8524, 10.7224, 15.7235, 10.9018, 15.6682)
    ..cubicTo(12.1941, 15.2693, 13.635, 15.125, 14.9669, 14.8898)
    ..cubicTo(16.1031, 14.6891, 17.112, 14.5801, 17.9936, 13.8117)
    ..cubicTo(18.4037, 13.4583, 18.8499, 13.1155, 18.9027, 12.5238)
    ..cubicTo(18.9036, 12.5135, 18.9051, 12.5013, 18.907, 12.4872)
    ..cubicTo(18.9906, 10.7823, 18.9667, 6.9815, 18.9547, 5.6118)
    ..cubicTo(18.9523, 5.3325, 19.1868, 5.1076, 19.4771, 5.1076)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Book._viewBoxWidth;
    final scaleY = size.height / _Book._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Book._viewBoxMinX, -_Book._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BookPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/box-pencil.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _BoxPencil extends StatelessWidget with _DotdartSvgSizing {
  const _BoxPencil({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _BoxPencil._svgWidth;

  @override
  double get svgNativeHeight => _BoxPencil._svgHeight;

  @override
  double get svgViewBoxWidth => _BoxPencil._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _BoxPencil._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BoxPencilPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BoxPencilPainter extends CustomPainter {
  _BoxPencilPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.726662452,
    0.0,
    0.0,
    0.0,
    0.0,
    0.726662452,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.767437784,
    2.733375481,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(13.4913, 1.9463)
    ..lineTo(18.0916, 6.5466)
    ..lineTo(14.2113, 10.427)
    ..cubicTo(14.0158, 10.6224, 13.7508, 10.7323, 13.4744, 10.7323)
    ..lineTo(10.3478, 10.7323)
    ..cubicTo(9.7722, 10.7323, 9.3056, 10.2657, 9.3056, 9.6901)
    ..lineTo(9.3056, 6.5635)
    ..cubicTo(9.3057, 6.2871, 9.4155, 6.022, 9.611, 5.8266)
    ..lineTo(13.4913, 1.9463)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(19.0261, 5.6051)
    ..cubicTo(18.9592, 5.6798, 18.8437, 5.6796, 18.7728, 5.6086)
    ..lineTo(14.4293, 1.2651)
    ..cubicTo(14.3584, 1.1942, 14.3581, 1.0787, 14.4328, 1.0118)
    ..cubicTo(15.7101, -0.1321, 17.674, -0.0905, 18.9012, 1.1367)
    ..cubicTo(20.1285, 2.3639, 20.1701, 4.3278, 19.0261, 5.6051)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(13.6519, 0.1726)
    ..cubicTo(13.6634, 0.1841, 13.6632, 0.2029, 13.6514, 0.2142)
    ..cubicTo(13.6331, 0.2319, 13.6148, 0.2498, 13.5967, 0.2679)
    ..lineTo(8.9704, 4.8941)
    ..cubicTo(8.9578, 4.9067, 8.9455, 4.9194, 8.9333, 4.9322)
    ..cubicTo(8.5791, 5.3038, 8.3661, 5.7864, 8.3288, 6.296)
    ..cubicTo(8.3262, 6.3312, 8.3244, 6.3665, 8.3235, 6.4019)
    ..lineTo(8.3229, 6.4566)
    ..lineTo(8.3229, 9.5412)
    ..cubicTo(8.3229, 9.5603, 8.3232, 9.5794, 8.3236, 9.5983)
    ..cubicTo(8.327, 9.731, 8.342, 9.8608, 8.3678, 9.9867)
    ..cubicTo(8.3751, 10.0227, 8.3833, 10.0584, 8.3924, 10.0937)
    ..cubicTo(8.4651, 10.3762, 8.5923, 10.6368, 8.762, 10.8637)
    ..cubicTo(8.7832, 10.8921, 8.8051, 10.9199, 8.8276, 10.9472)
    ..cubicTo(8.8501, 10.9745, 8.8733, 11.0012, 8.8971, 11.0274)
    ..cubicTo(8.9209, 11.0536, 8.9452, 11.0793, 8.9702, 11.1043)
    ..cubicTo(9.3577, 11.4918, 9.8885, 11.736, 10.4762, 11.7509)
    ..cubicTo(10.4951, 11.7514, 10.5142, 11.7516, 10.5333, 11.7516)
    ..lineTo(13.6175, 11.7516)
    ..cubicTo(14.0389, 11.7516, 14.4479, 11.6313, 14.7984, 11.4097)
    ..cubicTo(14.8594, 11.3712, 14.9186, 11.3296, 14.9757, 11.285)
    ..cubicTo(15.0329, 11.2405, 15.0882, 11.193, 15.1411, 11.1426)
    ..cubicTo(15.1544, 11.13, 15.1674, 11.1172, 15.1804, 11.1043)
    ..lineTo(19.8066, 6.4779)
    ..cubicTo(19.8311, 6.4535, 19.855, 6.4287, 19.8788, 6.4037)
    ..cubicTo(19.8799, 6.4026, 19.8818, 6.4025, 19.883, 6.4037)
    ..cubicTo(19.8835, 6.4042, 19.8838, 6.405, 19.8838, 6.4058)
    ..lineTo(19.8838, 10.3471)
    ..cubicTo(19.8838, 13.6794, 19.8838, 15.3455, 19.2263, 16.6195)
    ..cubicTo(18.6762, 17.6854, 17.8145, 18.5584, 16.7559, 19.1225)
    ..cubicTo(15.4906, 19.7966, 13.8247, 19.8184, 10.4927, 19.862)
    ..lineTo(10.0277, 19.8681)
    ..cubicTo(6.2504, 19.9176, 4.3617, 19.9423, 2.9594, 19.1363)
    ..cubicTo(2.0658, 18.6226, 1.3221, 17.8839, 0.8026, 16.9937)
    ..cubicTo(-0.0127, 15.5968, -0.0005, 13.708, 0.0239, 9.9304)
    ..lineTo(0.0258, 9.6496)
    ..cubicTo(0.0482, 6.1848, 0.0594, 4.4524, 0.7704, 3.1487)
    ..cubicTo(1.3312, 2.1204, 2.1852, 1.2822, 3.2237, 0.7406)
    ..cubicTo(4.5404, 0.054, 6.2727, 0.0749, 9.7373, 0.1169)
    ..lineTo(13.6317, 0.1641)
    ..cubicTo(13.6393, 0.1642, 13.6465, 0.1673, 13.6519, 0.1726)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _BoxPencil._viewBoxWidth;
    final scaleY = size.height / _BoxPencil._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_BoxPencil._viewBoxMinX, -_BoxPencil._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BoxPencilPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/broom.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Broom extends StatelessWidget with _DotdartSvgSizing {
  const _Broom({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Broom._svgWidth;

  @override
  double get svgNativeHeight => _Broom._svgHeight;

  @override
  double get svgViewBoxWidth => _Broom._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Broom._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BroomPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BroomPainter extends CustomPainter {
  _BroomPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.709665773,
    0.0,
    0.0,
    0.0,
    0.0,
    0.709665773,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.147289878,
    2.903342268,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(18.8773, 5.0212)
    ..lineTo(16.4385, 9.4034)
    ..cubicTo(16.327, 9.6037, 16.3994, 9.8564, 16.6001, 9.9673)
    ..cubicTo(18.0994, 10.7955, 18.6428, 12.6832, 17.8105, 14.1803)
    ..cubicTo(17.603, 14.5536, 17.1325, 14.6883, 16.7587, 14.4817)
    ..lineTo(5.9386, 8.4978)
    ..cubicTo(5.5632, 8.2902, 5.4277, 7.8172, 5.6363, 7.4424)
    ..cubicTo(6.4673, 5.9491, 8.3498, 5.4096, 9.8456, 6.2359)
    ..cubicTo(10.0706, 6.3602, 10.3537, 6.2807, 10.4811, 6.0575)
    ..lineTo(12.9609, 1.7106)
    ..cubicTo(13.8801, 0.0992, 15.9289, -0.4733, 17.5544, 0.4241)
    ..cubicTo(19.1932, 1.3288, 19.7868, 3.387, 18.8773, 5.0212)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(7.0366, 10.4294)
    ..cubicTo(6.9131, 10.3611, 6.8514, 10.327, 6.8358, 10.3186)
    ..cubicTo(6.0216, 9.8842, 5.9094, 9.8736, 5.0283, 10.1477)
    ..cubicTo(5.0114, 10.153, 4.7296, 10.2453, 4.1659, 10.43)
    ..cubicTo(3.3615, 10.6935, 2.4229, 10.7233, 1.2566, 10.4757)
    ..cubicTo(0.5479, 10.3253, -0.096, 10.9282, 0.0119, 11.6446)
    ..cubicTo(0.6091, 15.6105, 4.2557, 18.7166, 7.7877, 19.6783)
    ..cubicTo(9.5807, 20.1665, 11.5056, 20.1507, 13.1001, 19.2698)
    ..cubicTo(13.5012, 19.0482, 13.8693, 18.7786, 14.2008, 18.4617)
    ..cubicTo(15.0277, 17.6711, 15.4412, 17.2758, 15.2878, 16.0917)
    ..cubicTo(15.1343, 14.9076, 14.3405, 14.4687, 12.753, 13.5907)
    ..lineTo(7.0366, 10.4294)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Broom._viewBoxWidth;
    final scaleY = size.height / _Broom._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Broom._viewBoxMinX, -_Broom._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BroomPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/buildings.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Buildings extends StatelessWidget with _DotdartSvgSizing {
  const _Buildings({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Buildings._svgWidth;

  @override
  double get svgNativeHeight => _Buildings._svgHeight;

  @override
  double get svgViewBoxWidth => _Buildings._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Buildings._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BuildingsPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BuildingsPainter extends CustomPainter {
  _BuildingsPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.680257375,
    0.0,
    0.0,
    0.0,
    0.0,
    0.680257375,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.197426255,
    3.37811962,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(1.8182, 5.6364)
    ..cubicTo(1.8182, 3.628, 3.4462, 2, 5.4546, 2)
    ..lineTo(9.0909, 2)
    ..cubicTo(11.0992, 2, 12.7273, 3.628, 12.7273, 5.6364)
    ..lineTo(12.7273, 15.1072)
    ..cubicTo(12.7273, 15.3994, 12.9642, 15.6364, 13.2564, 15.6364)
    ..cubicTo(13.5487, 15.6364, 13.7856, 15.3994, 13.7856, 15.1072)
    ..lineTo(13.7856, 6.3962)
    ..cubicTo(13.7856, 5.9765, 14.1258, 5.6364, 14.5455, 5.6364)
    ..cubicTo(16.5537, 5.6364, 18.1818, 7.2644, 18.1818, 9.2727)
    ..lineTo(18.1818, 14.7273)
    ..cubicTo(18.1818, 15.2293, 18.5888, 15.6364, 19.0909, 15.6364)
    ..cubicTo(19.593, 15.6364, 20, 16.0434, 20, 16.5455)
    ..cubicTo(20, 17.0475, 19.593, 17.4545, 19.0909, 17.4545)
    ..lineTo(0.9091, 17.4545)
    ..cubicTo(0.407, 17.4545, 0, 17.0475, 0, 16.5455)
    ..cubicTo(0, 16.0434, 0.407, 15.6364, 0.9091, 15.6364)
    ..cubicTo(1.4112, 15.6364, 1.8182, 15.2293, 1.8182, 14.7273)
    ..lineTo(1.8182, 5.6364)
    ..close()
    ..moveTo(5.4546, 7.4545)
    ..cubicTo(5.4546, 6.9525, 5.8616, 6.5454, 6.3636, 6.5454)
    ..lineTo(8.1818, 6.5454)
    ..cubicTo(8.6839, 6.5454, 9.0909, 6.9525, 9.0909, 7.4545)
    ..cubicTo(9.0909, 7.9566, 8.6839, 8.3636, 8.1818, 8.3636)
    ..lineTo(6.3636, 8.3636)
    ..cubicTo(5.8616, 8.3636, 5.4546, 7.9566, 5.4546, 7.4545)
    ..close()
    ..moveTo(5.4546, 11.0909)
    ..cubicTo(5.4546, 10.5888, 5.8616, 10.1818, 6.3636, 10.1818)
    ..lineTo(8.1818, 10.1818)
    ..cubicTo(8.6839, 10.1818, 9.0909, 10.5888, 9.0909, 11.0909)
    ..cubicTo(9.0909, 11.593, 8.6839, 12, 8.1818, 12)
    ..lineTo(6.3636, 12)
    ..cubicTo(5.8616, 12, 5.4546, 11.593, 5.4546, 11.0909)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Buildings._viewBoxWidth;
    final scaleY = size.height / _Buildings._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Buildings._viewBoxMinX, -_Buildings._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BuildingsPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/bus-front.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _BusFront extends StatelessWidget with _DotdartSvgSizing {
  const _BusFront({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _BusFront._svgWidth;

  @override
  double get svgNativeHeight => _BusFront._svgHeight;

  @override
  double get svgViewBoxWidth => _BusFront._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _BusFront._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BusFrontPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BusFrontPainter extends CustomPainter {
  _BusFrontPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.642253945,
    0.0,
    0.0,
    0.0,
    0.0,
    0.642253945,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.577460546,
    3.577460546,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.0054, 0)
    ..cubicTo(12.3031, 0, 13.452, 0, 14.3717, 0.3355)
    ..cubicTo(15.908, 0.8958, 17.1183, 2.1061, 17.6786, 3.6424)
    ..cubicTo(17.8963, 4.2393, 17.9727, 4.9328, 17.9995, 5.9744)
    ..cubicTo(18.0043, 5.9742, 18.0092, 5.974, 18.0141, 5.974)
    ..cubicTo(18.3488, 5.974, 18.6202, 6.2454, 18.6202, 6.5801)
    ..lineTo(18.6202, 8.4848)
    ..cubicTo(18.6202, 8.8196, 18.3488, 9.0909, 18.0141, 9.0909)
    ..lineTo(18.0141, 10.4722)
    ..lineTo(17.9605, 18.5823)
    ..cubicTo(17.9573, 19.3662, 17.321, 20, 16.5371, 20)
    ..cubicTo(15.751, 20, 15.1137, 19.3627, 15.1137, 18.5766)
    ..lineTo(15.1137, 17.7717)
    ..lineTo(4.8972, 17.7717)
    ..lineTo(4.8972, 18.5766)
    ..cubicTo(4.8972, 19.3627, 4.2599, 20, 3.4738, 20)
    ..cubicTo(2.6899, 20, 2.0536, 19.3662, 2.0504, 18.5823)
    ..lineTo(1.9968, 10.4725)
    ..lineTo(1.9968, 9.0909)
    ..cubicTo(1.6621, 9.0909, 1.3907, 8.8196, 1.3907, 8.4848)
    ..lineTo(1.3907, 6.5801)
    ..cubicTo(1.3907, 6.2454, 1.6621, 5.974, 1.9968, 5.974)
    ..cubicTo(2.0017, 5.974, 2.0065, 5.9742, 2.0113, 5.9744)
    ..cubicTo(2.0382, 4.9328, 2.1145, 4.2393, 2.3323, 3.6424)
    ..cubicTo(2.8926, 2.1061, 4.1029, 0.8958, 5.6392, 0.3355)
    ..cubicTo(6.5589, 0, 7.7078, 0, 10.0054, 0)
    ..close()
    ..moveTo(5.7197, 12.7273)
    ..cubicTo(4.859, 12.7273, 4.1613, 13.425, 4.1613, 14.2857)
    ..cubicTo(4.1613, 15.1464, 4.859, 15.8442, 5.7197, 15.8442)
    ..cubicTo(6.5804, 15.8442, 7.2782, 15.1464, 7.2782, 14.2857)
    ..cubicTo(7.2782, 13.425, 6.5804, 12.7273, 5.7197, 12.7273)
    ..close()
    ..moveTo(14.2912, 12.7273)
    ..cubicTo(13.4305, 12.7273, 12.7327, 13.425, 12.7327, 14.2857)
    ..cubicTo(12.7327, 15.1464, 13.4305, 15.8442, 14.2912, 15.8442)
    ..cubicTo(15.1519, 15.8442, 15.8496, 15.1464, 15.8496, 14.2857)
    ..cubicTo(15.8496, 13.425, 15.1519, 12.7273, 14.2912, 12.7273)
    ..close()
    ..moveTo(7.0182, 4.5022)
    ..cubicTo(5.8885, 4.5022, 5.3236, 4.5022, 4.8804, 4.6933)
    ..cubicTo(4.3327, 4.9296, 3.8961, 5.3662, 3.6598, 5.9139)
    ..cubicTo(3.4686, 6.3571, 3.4686, 6.922, 3.4686, 8.0517)
    ..lineTo(3.4686, 8.0522)
    ..cubicTo(3.4686, 9.1819, 3.4686, 9.7468, 3.6598, 10.19)
    ..cubicTo(3.8961, 10.7377, 4.3327, 11.1743, 4.8804, 11.4106)
    ..cubicTo(5.3236, 11.6017, 5.8885, 11.6017, 7.0182, 11.6017)
    ..lineTo(12.9927, 11.6017)
    ..cubicTo(14.1224, 11.6017, 14.6873, 11.6017, 15.1305, 11.4106)
    ..cubicTo(15.6782, 11.1743, 16.1148, 10.7377, 16.3511, 10.19)
    ..cubicTo(16.5422, 9.7468, 16.5422, 9.1819, 16.5422, 8.0522)
    ..lineTo(16.5422, 8.0517)
    ..cubicTo(16.5422, 6.922, 16.5422, 6.3571, 16.3511, 5.9139)
    ..cubicTo(16.1148, 5.3662, 15.6782, 4.9296, 15.1305, 4.6933)
    ..cubicTo(14.6873, 4.5022, 14.1224, 4.5022, 12.9927, 4.5022)
    ..lineTo(7.0182, 4.5022)
    ..close()
    ..moveTo(7.9275, 1.7316)
    ..cubicTo(7.4733, 1.7316, 7.105, 2.0998, 7.105, 2.5541)
    ..cubicTo(7.105, 3.0084, 7.4733, 3.3766, 7.9275, 3.3766)
    ..lineTo(12.0834, 3.3766)
    ..cubicTo(12.5376, 3.3766, 12.9059, 3.0084, 12.9059, 2.5541)
    ..cubicTo(12.9059, 2.0998, 12.5376, 1.7316, 12.0834, 1.7316)
    ..lineTo(7.9275, 1.7316)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _BusFront._viewBoxWidth;
    final scaleY = size.height / _BusFront._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_BusFront._viewBoxMinX, -_BusFront._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BusFrontPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/checkered-flag.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _CheckeredFlag extends StatelessWidget with _DotdartSvgSizing {
  const _CheckeredFlag({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _CheckeredFlag._svgWidth;

  @override
  double get svgNativeHeight => _CheckeredFlag._svgHeight;

  @override
  double get svgViewBoxWidth => _CheckeredFlag._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _CheckeredFlag._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CheckeredFlagPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CheckeredFlagPainter extends CustomPainter {
  _CheckeredFlagPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.632054191,
    0.0,
    0.0,
    0.0,
    0.0,
    0.632054191,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.679458088,
    3.679458088,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(15.5556, 0)
    ..cubicTo(18.0101, 0, 20, 1.9898, 20, 4.4444)
    ..lineTo(20, 11.1111)
    ..cubicTo(20, 13.5657, 18.0101, 15.5556, 15.5556, 15.5556)
    ..lineTo(2.2222, 15.5556)
    ..lineTo(2.2222, 18.8889)
    ..cubicTo(2.2222, 19.5026, 1.7248, 20, 1.1111, 20)
    ..cubicTo(0.4975, 20, 0, 19.5026, 0, 18.8889)
    ..lineTo(0, 2.2222)
    ..cubicTo(0, 0.9949, 0.9949, 0, 2.2222, 0)
    ..lineTo(15.5556, 0)
    ..close()
    ..moveTo(4.4444, 11.1111)
    ..lineTo(4.4444, 13.3333)
    ..lineTo(6.6667, 13.3333)
    ..lineTo(6.6667, 11.1111)
    ..lineTo(4.4444, 11.1111)
    ..close()
    ..moveTo(8.8889, 11.1111)
    ..lineTo(8.8889, 13.3333)
    ..lineTo(11.1111, 13.3333)
    ..lineTo(11.1111, 11.1111)
    ..lineTo(8.8889, 11.1111)
    ..close()
    ..moveTo(13.3333, 11.1111)
    ..lineTo(13.3333, 13.3333)
    ..lineTo(15.5556, 13.3333)
    ..lineTo(15.5556, 11.1111)
    ..lineTo(13.3333, 11.1111)
    ..close()
    ..moveTo(2.2222, 8.8889)
    ..lineTo(2.2222, 11.1111)
    ..lineTo(4.4444, 11.1111)
    ..lineTo(4.4444, 8.8889)
    ..lineTo(2.2222, 8.8889)
    ..close()
    ..moveTo(6.6667, 8.8889)
    ..lineTo(6.6667, 11.1111)
    ..lineTo(8.8889, 11.1111)
    ..lineTo(8.8889, 8.8889)
    ..lineTo(6.6667, 8.8889)
    ..close()
    ..moveTo(11.1111, 8.8889)
    ..lineTo(11.1111, 11.1111)
    ..lineTo(13.3333, 11.1111)
    ..lineTo(13.3333, 8.8889)
    ..lineTo(11.1111, 8.8889)
    ..close()
    ..moveTo(15.5556, 8.8889)
    ..lineTo(15.5556, 11.1111)
    ..lineTo(17.7778, 11.1111)
    ..lineTo(17.7778, 8.8889)
    ..lineTo(15.5556, 8.8889)
    ..close()
    ..moveTo(4.4444, 6.6667)
    ..lineTo(4.4444, 8.8889)
    ..lineTo(6.6667, 8.8889)
    ..lineTo(6.6667, 6.6667)
    ..lineTo(4.4444, 6.6667)
    ..close()
    ..moveTo(8.8889, 6.6667)
    ..lineTo(8.8889, 8.8889)
    ..lineTo(11.1111, 8.8889)
    ..lineTo(11.1111, 6.6667)
    ..lineTo(8.8889, 6.6667)
    ..close()
    ..moveTo(13.3333, 6.6667)
    ..lineTo(13.3333, 8.8889)
    ..lineTo(15.5556, 8.8889)
    ..lineTo(15.5556, 6.6667)
    ..lineTo(13.3333, 6.6667)
    ..close()
    ..moveTo(2.2222, 4.4444)
    ..lineTo(2.2222, 6.6667)
    ..lineTo(4.4444, 6.6667)
    ..lineTo(4.4444, 4.4444)
    ..lineTo(2.2222, 4.4444)
    ..close()
    ..moveTo(6.6667, 4.4444)
    ..lineTo(6.6667, 6.6667)
    ..lineTo(8.8889, 6.6667)
    ..lineTo(8.8889, 4.4444)
    ..lineTo(6.6667, 4.4444)
    ..close()
    ..moveTo(11.1111, 4.4444)
    ..lineTo(11.1111, 6.6667)
    ..lineTo(13.3333, 6.6667)
    ..lineTo(13.3333, 4.4444)
    ..lineTo(11.1111, 4.4444)
    ..close()
    ..moveTo(15.5556, 4.4444)
    ..lineTo(15.5556, 6.6667)
    ..lineTo(17.7778, 6.6667)
    ..lineTo(17.7778, 4.4444)
    ..lineTo(15.5556, 4.4444)
    ..close()
    ..moveTo(4.4444, 2.2222)
    ..lineTo(4.4444, 4.4444)
    ..lineTo(6.6667, 4.4444)
    ..lineTo(6.6667, 2.2222)
    ..lineTo(4.4444, 2.2222)
    ..close()
    ..moveTo(8.8889, 2.2222)
    ..lineTo(8.8889, 4.4444)
    ..lineTo(11.1111, 4.4444)
    ..lineTo(11.1111, 2.2222)
    ..lineTo(8.8889, 2.2222)
    ..close()
    ..moveTo(13.3333, 2.2222)
    ..lineTo(13.3333, 4.4444)
    ..lineTo(15.5556, 4.4444)
    ..lineTo(15.5556, 2.2222)
    ..lineTo(13.3333, 2.2222)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _CheckeredFlag._viewBoxWidth;
    final scaleY = size.height / _CheckeredFlag._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_CheckeredFlag._viewBoxMinX, -_CheckeredFlag._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CheckeredFlagPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/checkmark.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Checkmark extends StatelessWidget with _DotdartSvgSizing {
  const _Checkmark({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Checkmark._svgWidth;

  @override
  double get svgNativeHeight => _Checkmark._svgHeight;

  @override
  double get svgViewBoxWidth => _Checkmark._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Checkmark._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CheckmarkPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  _CheckmarkPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.725472497,
    0.0,
    0.0,
    0.0,
    0.0,
    0.725472497,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.745275033,
    2.745275033,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(19.1509, 0.3059)
    ..cubicTo(20.0176, 0.8726, 20.2608, 2.0346, 19.6941, 2.9013)
    ..lineTo(9.0693, 19.151)
    ..cubicTo(8.7464, 19.6449, 8.21, 19.9579, 7.6213, 19.996)
    ..cubicTo(7.0326, 20.0343, 6.4603, 19.7931, 6.0763, 19.3453)
    ..lineTo(0.4514, 12.7828)
    ..cubicTo(-0.2225, 11.9966, -0.1314, 10.8129, 0.6548, 10.139)
    ..cubicTo(1.441, 9.4651, 2.6247, 9.5561, 3.2986, 10.3424)
    ..lineTo(6.2572, 13.7941)
    ..cubicTo(6.7777, 14.4013, 7.7351, 14.3392, 8.1727, 13.6699)
    ..lineTo(16.5555, 0.8491)
    ..cubicTo(17.1222, -0.0176, 18.2842, -0.2608, 19.1509, 0.3059)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Checkmark._viewBoxWidth;
    final scaleY = size.height / _Checkmark._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Checkmark._viewBoxMinX, -_Checkmark._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/chevron-down.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ChevronDown extends StatelessWidget with _DotdartSvgSizing {
  const _ChevronDown({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ChevronDown._svgWidth;

  @override
  double get svgNativeHeight => _ChevronDown._svgHeight;

  @override
  double get svgViewBoxWidth => _ChevronDown._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ChevronDown._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ChevronDownPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ChevronDownPainter extends CustomPainter {
  _ChevronDownPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.650262159,
    0.0,
    0.0,
    0.0,
    0.0,
    0.650262159,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.497378405,
    3.497378405,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(0.554, 5.0022)
    ..cubicTo(-0.1269, 5.6906, -0.1641, 6.7987, 0.4687, 7.5315)
    ..lineTo(0.4717, 7.5354)
    ..lineTo(0.4727, 7.5364)
    ..lineTo(0.4923, 7.5589)
    ..lineTo(0.4942, 7.5619)
    ..lineTo(0.5001, 7.5677)
    ..lineTo(6.3013, 13.9469)
    ..cubicTo(8.1454, 15.9745, 11.2526, 16.0787, 13.2291, 14.1801)
    ..lineTo(19.4123, 7.6539)
    ..cubicTo(20.0917, 7.0011, 20.1682, 5.9416, 19.618, 5.1991)
    ..lineTo(19.4995, 5.0551)
    ..lineTo(19.4955, 5.0502)
    ..lineTo(19.3662, 4.9218)
    ..cubicTo(18.6687, 4.2971, 17.6003, 4.3042, 16.9094, 4.9679)
    ..lineTo(10.7272, 11.494)
    ..cubicTo(10.2251, 11.9762, 9.448, 11.9501, 8.9795, 11.4352)
    ..lineTo(3.1774, 5.056)
    ..cubicTo(2.4899, 4.3004, 1.3263, 4.2617, 0.5892, 4.9688)
    ..lineTo(0.5883, 4.9679)
    ..lineTo(0.554, 5.0022)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ChevronDown._viewBoxWidth;
    final scaleY = size.height / _ChevronDown._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ChevronDown._viewBoxMinX, -_ChevronDown._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ChevronDownPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/chevron-left.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ChevronLeft extends StatelessWidget with _DotdartSvgSizing {
  const _ChevronLeft({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ChevronLeft._svgWidth;

  @override
  double get svgNativeHeight => _ChevronLeft._svgHeight;

  @override
  double get svgViewBoxWidth => _ChevronLeft._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ChevronLeft._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ChevronLeftPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ChevronLeftPainter extends CustomPainter {
  _ChevronLeftPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.624213231,
    0.0,
    0.0,
    0.0,
    0.0,
    0.624213231,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.75786769,
    3.767621022,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(14.9985, 0.5363)
    ..cubicTo(14.3101, -0.1446, 13.202, -0.1817, 12.4692, 0.4511)
    ..lineTo(12.4653, 0.454)
    ..lineTo(12.4643, 0.455)
    ..lineTo(12.4418, 0.4746)
    ..lineTo(12.4388, 0.4766)
    ..lineTo(12.433, 0.4824)
    ..lineTo(6.0538, 6.2836)
    ..cubicTo(4.0263, 8.1277, 3.922, 11.235, 5.8206, 13.2114)
    ..lineTo(12.3468, 19.3946)
    ..cubicTo(12.9996, 20.0741, 14.0591, 20.1506, 14.8016, 19.6003)
    ..lineTo(14.9456, 19.4818)
    ..lineTo(14.9505, 19.4779)
    ..lineTo(15.0789, 19.3486)
    ..cubicTo(15.7036, 18.651, 15.6965, 17.5827, 15.0328, 16.8917)
    ..lineTo(8.5067, 10.7095)
    ..cubicTo(8.0245, 10.2075, 8.0506, 9.4304, 8.5655, 8.9619)
    ..lineTo(14.9447, 3.1597)
    ..cubicTo(15.7003, 2.4722, 15.739, 1.3087, 15.0319, 0.5716)
    ..lineTo(15.0328, 0.5706)
    ..lineTo(14.9985, 0.5363)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ChevronLeft._viewBoxWidth;
    final scaleY = size.height / _ChevronLeft._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ChevronLeft._viewBoxMinX, -_ChevronLeft._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ChevronLeftPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/circle.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Circle extends StatelessWidget with _DotdartSvgSizing {
  const _Circle({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Circle._svgWidth;

  @override
  double get svgNativeHeight => _Circle._svgHeight;

  @override
  double get svgViewBoxWidth => _Circle._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Circle._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CirclePainter(
            mateoOpticalSizeColor:
                mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.774999966,
    0.0,
    0.0,
    0.0,
    0.0,
    0.774999966,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.250000338,
    2.250000338,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10, 0)
    ..cubicTo(4.4771, 0, 0, 4.4771, 0, 10)
    ..cubicTo(0, 15.5228, 4.4771, 20, 10, 20)
    ..cubicTo(15.5228, 20, 20, 15.5228, 20, 10)
    ..cubicTo(20, 4.4771, 15.5228, 0, 10, 0)
    ..close();

  static final Path __clip0 = _buildClip0();

  static Path _buildClip0() {
    final path = Path();
    final clipShape0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));
    path.addPath(
      clipShape0,
      Offset.zero,
      matrix4: Float64List.fromList([
        -1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        20.0,
        0.0,
        0.0,
        1.0,
      ]),
    );
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Circle._viewBoxWidth;
    final scaleY = size.height / _Circle._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Circle._viewBoxMinX, -_Circle._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/circle-block.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _CircleBlock extends StatelessWidget with _DotdartSvgSizing {
  const _CircleBlock({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _CircleBlock._svgWidth;

  @override
  double get svgNativeHeight => _CircleBlock._svgHeight;

  @override
  double get svgViewBoxWidth => _CircleBlock._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _CircleBlock._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CircleBlockPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CircleBlockPainter extends CustomPainter {
  _CircleBlockPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.737612707,
    0.0,
    0.0,
    0.0,
    0.0,
    0.737612707,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.623872929,
    2.623872929,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10, 0)
    ..cubicTo(12.7611, 0, 15.2627, 1.1202, 17.0713, 2.9287)
    ..cubicTo(18.8798, 4.7373, 20, 7.2389, 20, 10)
    ..cubicTo(20, 15.5228, 15.5228, 20, 10, 20)
    ..cubicTo(7.2389, 20, 4.7373, 18.8798, 2.9287, 17.0713)
    ..cubicTo(1.1202, 15.2627, 0, 12.7611, 0, 10)
    ..cubicTo(0, 4.4771, 4.4771, 0, 10, 0)
    ..close()
    ..moveTo(5.0947, 16.3184)
    ..cubicTo(6.45, 17.3721, 8.1507, 18, 10, 18)
    ..cubicTo(14.4183, 18, 18, 14.4183, 18, 10)
    ..cubicTo(18, 8.1507, 17.3721, 6.45, 16.3184, 5.0947)
    ..lineTo(5.0947, 16.3184)
    ..close()
    ..moveTo(10, 2)
    ..cubicTo(5.5817, 2, 2, 5.5817, 2, 10)
    ..cubicTo(2, 11.8488, 2.6274, 13.5492, 3.6807, 14.9043)
    ..lineTo(14.9043, 3.6807)
    ..cubicTo(13.5492, 2.6274, 11.8488, 2, 10, 2)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _CircleBlock._viewBoxWidth;
    final scaleY = size.height / _CircleBlock._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_CircleBlock._viewBoxMinX, -_CircleBlock._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CircleBlockPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/circle-check.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _CircleCheck extends StatelessWidget with _DotdartSvgSizing {
  const _CircleCheck({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _CircleCheck._svgWidth;

  @override
  double get svgNativeHeight => _CircleCheck._svgHeight;

  @override
  double get svgViewBoxWidth => _CircleCheck._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _CircleCheck._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CircleCheckPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CircleCheckPainter extends CustomPainter {
  _CircleCheckPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.776161202,
    0.0,
    0.0,
    0.0,
    0.0,
    0.776161202,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.238387977,
    2.238387977,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10, 0)
    ..cubicTo(15.5228, 0, 20, 4.4771, 20, 10)
    ..cubicTo(20, 15.5228, 15.5228, 20, 10, 20)
    ..cubicTo(4.4771, 20, 0, 15.5228, 0, 10)
    ..cubicTo(0, 4.4771, 4.4771, 0, 10, 0)
    ..close()
    ..moveTo(13.667, 6.1269)
    ..cubicTo(13.3228, 5.8966, 12.8574, 5.9889, 12.627, 6.333)
    ..lineTo(8.4482, 12.5723)
    ..lineTo(6.2813, 10.3945)
    ..cubicTo(5.9891, 10.1009, 5.5143, 10.0995, 5.2207, 10.3916)
    ..cubicTo(4.9273, 10.6838, 4.9267, 11.1586, 5.2188, 11.4521)
    ..lineTo(8.0312, 14.2793)
    ..cubicTo(8.1897, 14.4384, 8.4112, 14.5177, 8.6348, 14.4961)
    ..cubicTo(8.8584, 14.4744, 9.0605, 14.3537, 9.1855, 14.167)
    ..lineTo(13.873, 7.167)
    ..cubicTo(14.1034, 6.8228, 14.0111, 6.3574, 13.667, 6.1269)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _CircleCheck._viewBoxWidth;
    final scaleY = size.height / _CircleCheck._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_CircleCheck._viewBoxMinX, -_CircleCheck._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CircleCheckPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/circle-info.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _CircleInfo extends StatelessWidget with _DotdartSvgSizing {
  const _CircleInfo({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _CircleInfo._svgWidth;

  @override
  double get svgNativeHeight => _CircleInfo._svgHeight;

  @override
  double get svgViewBoxWidth => _CircleInfo._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _CircleInfo._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CircleInfoPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CircleInfoPainter extends CustomPainter {
  _CircleInfoPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.777932892,
    0.0,
    0.0,
    0.0,
    0.0,
    0.777932892,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.220671075,
    2.220671075,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10, 0)
    ..cubicTo(4.4771, 0, 0, 4.4771, 0, 10)
    ..cubicTo(0, 15.5228, 4.4771, 20, 10, 20)
    ..cubicTo(15.5228, 20, 20, 15.5228, 20, 10)
    ..cubicTo(20, 4.4771, 15.5228, 0, 10, 0)
    ..close()
    ..moveTo(8, 9)
    ..cubicTo(8, 8.5858, 8.3358, 8.25, 8.75, 8.25)
    ..lineTo(10, 8.25)
    ..cubicTo(10.4142, 8.25, 10.75, 8.5858, 10.75, 9)
    ..lineTo(10.75, 14.25)
    ..cubicTo(10.75, 14.6642, 10.4142, 15, 10, 15)
    ..cubicTo(9.5858, 15, 9.25, 14.6642, 9.25, 14.25)
    ..lineTo(9.25, 9.75)
    ..lineTo(8.75, 9.75)
    ..cubicTo(8.3358, 9.75, 8, 9.4142, 8, 9)
    ..close()
    ..moveTo(10, 5.25)
    ..cubicTo(9.5858, 5.25, 9.25, 5.5858, 9.25, 6)
    ..cubicTo(9.25, 6.4142, 9.5858, 6.75, 10, 6.75)
    ..cubicTo(10.4142, 6.75, 10.75, 6.4142, 10.75, 6)
    ..cubicTo(10.75, 5.5858, 10.4142, 5.25, 10, 5.25)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _CircleInfo._viewBoxWidth;
    final scaleY = size.height / _CircleInfo._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_CircleInfo._viewBoxMinX, -_CircleInfo._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CircleInfoPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/classic-building.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ClassicBuilding extends StatelessWidget with _DotdartSvgSizing {
  const _ClassicBuilding({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ClassicBuilding._svgWidth;

  @override
  double get svgNativeHeight => _ClassicBuilding._svgHeight;

  @override
  double get svgViewBoxWidth => _ClassicBuilding._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ClassicBuilding._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ClassicBuildingPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ClassicBuildingPainter extends CustomPainter {
  _ClassicBuildingPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.811333066,
    0.0,
    0.0,
    0.0,
    0.0,
    0.811333066,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.038794287,
    1.709190229,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(6.5101, 15.4311)
    ..cubicTo(6.5101, 15.8659, 6.1963, 16.1318, 5.8094, 16.1318)
    ..lineTo(2.8148, 16.1318)
    ..cubicTo(2.4278, 16.1318, 2.1141, 15.8181, 2.1141, 15.4311)
    ..cubicTo(2.1141, 14.7484, 2.9295, 14.177, 2.9295, 13.4943)
    ..lineTo(2.9295, 10.6573)
    ..cubicTo(2.9295, 9.9515, 2.0515, 9.3844, 2.0515, 8.6787)
    ..cubicTo(2.0515, 8.2917, 2.3652, 7.9779, 2.7522, 7.9779)
    ..lineTo(5.7451, 7.9779)
    ..cubicTo(6.1321, 7.9779, 6.4458, 8.2917, 6.4458, 8.6787)
    ..cubicTo(6.4458, 9.375, 5.6049, 9.9439, 5.6049, 10.6402)
    ..lineTo(5.6049, 13.404)
    ..cubicTo(5.6049, 14.1365, 6.5101, 14.6986, 6.5101, 15.4311)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(11.946, 15.4311)
    ..cubicTo(11.946, 15.8659, 11.6323, 16.1318, 11.2453, 16.1318)
    ..lineTo(8.2507, 16.1318)
    ..cubicTo(7.8637, 16.1318, 7.55, 15.8181, 7.55, 15.4311)
    ..cubicTo(7.55, 14.7484, 8.3654, 14.177, 8.3654, 13.4943)
    ..lineTo(8.3654, 10.6573)
    ..cubicTo(8.3654, 9.9515, 7.4874, 9.3844, 7.4874, 8.6787)
    ..cubicTo(7.4874, 8.2917, 7.8011, 7.9779, 8.1881, 7.9779)
    ..lineTo(11.181, 7.9779)
    ..cubicTo(11.568, 7.9779, 11.8817, 8.2917, 11.8817, 8.6787)
    ..cubicTo(11.8817, 9.375, 11.0409, 9.9439, 11.0409, 10.6402)
    ..lineTo(11.0409, 13.404)
    ..cubicTo(11.0409, 14.1365, 11.946, 14.6986, 11.946, 15.4311)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(17.4872, 15.5301)
    ..cubicTo(17.4872, 15.9773, 17.1646, 16.2508, 16.7665, 16.2508)
    ..lineTo(13.6864, 16.2508)
    ..cubicTo(13.2883, 16.2508, 12.9656, 15.9281, 12.9656, 15.5301)
    ..cubicTo(12.9656, 14.8279, 13.8043, 14.2401, 13.8043, 13.5379)
    ..lineTo(13.8043, 10.6199)
    ..cubicTo(13.8043, 9.894, 12.9013, 9.3107, 12.9013, 8.5847)
    ..cubicTo(12.9013, 8.1867, 13.2239, 7.864, 13.622, 7.864)
    ..lineTo(16.7004, 7.864)
    ..cubicTo(17.0985, 7.864, 17.4212, 8.1867, 17.4212, 8.5847)
    ..cubicTo(17.4212, 9.301, 16.5563, 9.8861, 16.5563, 10.6023)
    ..lineTo(16.5563, 13.4451)
    ..cubicTo(16.5563, 14.1985, 17.4872, 14.7766, 17.4872, 15.5301)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(2.3696, 17.1828)
    ..cubicTo(2.7574, 17.167, 3.2052, 17.1793, 3.5964, 17.1793)
    ..lineTo(5.8465, 17.18)
    ..lineTo(11.945, 17.1793)
    ..lineTo(15.5182, 17.1799)
    ..lineTo(16.7349, 17.179)
    ..cubicTo(16.9148, 17.1791, 17.2463, 17.169, 17.4195, 17.1925)
    ..cubicTo(17.6704, 17.2283, 17.9046, 17.362, 18.087, 17.573)
    ..cubicTo(18.6413, 18.2053, 18.5312, 19.2925, 17.8725, 19.7538)
    ..cubicTo(17.6581, 19.9039, 17.4756, 19.9389, 17.2308, 19.9447)
    ..lineTo(6.8087, 19.9442)
    ..lineTo(3.6405, 19.9444)
    ..lineTo(2.6982, 19.944)
    ..cubicTo(2.225, 19.9436, 1.876, 19.9834, 1.5034, 19.5553)
    ..cubicTo(1.2866, 19.3079, 1.1618, 18.9651, 1.1574, 18.605)
    ..cubicTo(1.1454, 17.8824, 1.5673, 17.2927, 2.1576, 17.1955)
    ..cubicTo(2.2273, 17.1841, 2.2992, 17.1841, 2.3696, 17.1828)
    ..close();

  static final Path __path4 = Path()
    ..moveTo(8.2562, 0.8868)
    ..cubicTo(9.2418, 0.3362, 10.4434, 0.3402, 11.4254, 0.8974)
    ..lineTo(17.3493, 4.2585)
    ..cubicTo(18.6477, 4.9953, 18.1249, 6.9763, 16.632, 6.9763)
    ..lineTo(2.9371, 6.9763)
    ..cubicTo(1.439, 6.9763, 0.9204, 4.9843, 2.2283, 4.2538)
    ..lineTo(8.2562, 0.8868)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ClassicBuilding._viewBoxWidth;
    final scaleY = size.height / _ClassicBuilding._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_ClassicBuilding._viewBoxMinX,
        -_ClassicBuilding._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ClassicBuildingPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/clock.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Clock extends StatelessWidget with _DotdartSvgSizing {
  const _Clock({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Clock._svgWidth;

  @override
  double get svgNativeHeight => _Clock._svgHeight;

  @override
  double get svgViewBoxWidth => _Clock._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Clock._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ClockPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  _ClockPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.778271927,
    0.0,
    0.0,
    0.0,
    0.0,
    0.778271927,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.217280729,
    2.217280729,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10, 0)
    ..cubicTo(15.5228, 0, 20, 4.4771, 20, 10)
    ..cubicTo(20, 15.5228, 15.5228, 20, 10, 20)
    ..cubicTo(4.4771, 20, 0, 15.5228, 0, 10)
    ..cubicTo(0, 4.4771, 4.4771, 0, 10, 0)
    ..close()
    ..moveTo(10, 4)
    ..cubicTo(9.5858, 4, 9.25, 4.3358, 9.25, 4.75)
    ..lineTo(9.25, 9.25)
    ..lineTo(5.75, 9.25)
    ..cubicTo(5.3358, 9.25, 5, 9.5858, 5, 10)
    ..cubicTo(5, 10.4142, 5.3358, 10.75, 5.75, 10.75)
    ..lineTo(10, 10.75)
    ..cubicTo(10.4142, 10.75, 10.75, 10.4142, 10.75, 10)
    ..lineTo(10.75, 4.75)
    ..cubicTo(10.75, 4.3358, 10.4142, 4, 10, 4)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Clock._viewBoxWidth;
    final scaleY = size.height / _Clock._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Clock._viewBoxMinX, -_Clock._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/cross.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Cross extends StatelessWidget with _DotdartSvgSizing {
  const _Cross({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Cross._svgWidth;

  @override
  double get svgNativeHeight => _Cross._svgHeight;

  @override
  double get svgViewBoxWidth => _Cross._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Cross._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CrossPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CrossPainter extends CustomPainter {
  _CrossPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.678403974,
    0.0,
    0.0,
    0.0,
    0.0,
    0.678403974,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.215960256,
    3.215960256,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(0.5323, 0.5325)
    ..cubicTo(1.2424, -0.1775, 2.3936, -0.1775, 3.1036, 0.5325)
    ..lineTo(9.9998, 7.4287)
    ..lineTo(16.8959, 0.5325)
    ..cubicTo(17.606, -0.1775, 18.7572, -0.1775, 19.4673, 0.5325)
    ..cubicTo(20.1773, 1.2426, 20.1773, 2.3938, 19.4673, 3.1038)
    ..lineTo(12.5711, 10)
    ..lineTo(19.4673, 16.8961)
    ..cubicTo(20.1773, 17.6062, 20.1773, 18.7575, 19.4673, 19.4675)
    ..cubicTo(18.7572, 20.1775, 17.606, 20.1775, 16.8959, 19.4675)
    ..lineTo(9.9998, 12.5713)
    ..lineTo(3.1036, 19.4675)
    ..cubicTo(2.3936, 20.1775, 1.2424, 20.1775, 0.5323, 19.4675)
    ..cubicTo(-0.1777, 18.7575, -0.1777, 17.6062, 0.5323, 16.8961)
    ..lineTo(7.4285, 10)
    ..lineTo(0.5323, 3.1038)
    ..cubicTo(-0.1777, 2.3938, -0.1777, 1.2426, 0.5323, 0.5325)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Cross._viewBoxWidth;
    final scaleY = size.height / _Cross._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Cross._viewBoxMinX, -_Cross._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CrossPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/cross-circle.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _CrossCircle extends StatelessWidget with _DotdartSvgSizing {
  const _CrossCircle({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _CrossCircle._svgWidth;

  @override
  double get svgNativeHeight => _CrossCircle._svgHeight;

  @override
  double get svgViewBoxWidth => _CrossCircle._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _CrossCircle._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CrossCirclePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CrossCirclePainter extends CustomPainter {
  _CrossCirclePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.781124619,
    0.0,
    0.0,
    0.0,
    0.0,
    0.781124619,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.188753811,
    2.188753811,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10, 0)
    ..cubicTo(4.4771, 0, 0, 4.4771, 0, 10)
    ..cubicTo(0, 15.5228, 4.4771, 20, 10, 20)
    ..cubicTo(15.5228, 20, 20, 15.5228, 20, 10)
    ..cubicTo(20, 4.4771, 15.5228, 0, 10, 0)
    ..close()
    ..moveTo(6.124, 6.124)
    ..cubicTo(6.4146, 5.8334, 6.8861, 5.8335, 7.1768, 6.124)
    ..lineTo(10, 8.9473)
    ..lineTo(12.8232, 6.124)
    ..cubicTo(13.1139, 5.8335, 13.5854, 5.8334, 13.876, 6.124)
    ..cubicTo(14.1665, 6.4146, 14.1664, 6.8861, 13.876, 7.1768)
    ..lineTo(11.0527, 10)
    ..lineTo(13.876, 12.8232)
    ..cubicTo(14.1664, 13.1139, 14.1665, 13.5854, 13.876, 13.876)
    ..cubicTo(13.5854, 14.1665, 13.1139, 14.1664, 12.8232, 13.876)
    ..lineTo(10, 11.0527)
    ..lineTo(7.1768, 13.876)
    ..cubicTo(6.8861, 14.1664, 6.4146, 14.1665, 6.124, 13.876)
    ..cubicTo(5.8334, 13.5854, 5.8335, 13.1139, 6.124, 12.8232)
    ..lineTo(8.9473, 10)
    ..lineTo(6.124, 7.1768)
    ..cubicTo(5.8335, 6.8861, 5.8334, 6.4146, 6.124, 6.124)
    ..close();

  static final Path __clip0 = _buildClip0();

  static Path _buildClip0() {
    final path = Path();
    final clipShape0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));
    path.addPath(
      clipShape0,
      Offset.zero,
      matrix4: Float64List.fromList([
        -1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        20.0,
        0.0,
        0.0,
        1.0,
      ]),
    );
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _CrossCircle._viewBoxWidth;
    final scaleY = size.height / _CrossCircle._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_CrossCircle._viewBoxMinX, -_CrossCircle._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CrossCirclePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/disco-ball.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _DiscoBall extends StatelessWidget with _DotdartSvgSizing {
  const _DiscoBall({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _DiscoBall._svgWidth;

  @override
  double get svgNativeHeight => _DiscoBall._svgHeight;

  @override
  double get svgViewBoxWidth => _DiscoBall._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _DiscoBall._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _DiscoBallPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _DiscoBallPainter extends CustomPainter {
  _DiscoBallPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.83526336,
    0.0,
    0.0,
    0.0,
    0.0,
    0.83526336,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.608213431,
    1.647366401,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.0302, 0)
    ..cubicTo(10.5331, 0, 10.9407, 0.4076, 10.9407, 0.9104)
    ..lineTo(10.9407, 1.7649)
    ..cubicTo(10.9407, 1.9386, 11.0396, 2.0949, 11.183, 2.1929)
    ..cubicTo(11.4156, 2.3517, 11.619, 2.5484, 11.7924, 2.7562)
    ..cubicTo(12.2142, 3.2616, 12.5532, 3.9389, 12.8203, 4.6954)
    ..cubicTo(13.0482, 5.3415, 13.2358, 6.0816, 13.3766, 6.8887)
    ..cubicTo(13.4161, 7.1153, 13.6108, 7.2835, 13.8408, 7.2835)
    ..lineTo(17.4285, 7.2835)
    ..cubicTo(17.8281, 7.2835, 18.1814, 7.5443, 18.2988, 7.9263)
    ..cubicTo(18.5463, 8.7317, 18.6794, 9.5863, 18.6794, 10.4701)
    ..cubicTo(18.6794, 15.2469, 14.807, 19.1193, 10.0302, 19.1193)
    ..cubicTo(9.2767, 19.1193, 8.6855, 18.6842, 8.2681, 18.184)
    ..cubicTo(7.8463, 17.6785, 7.5072, 17.0012, 7.2402, 16.2448)
    ..cubicTo(7.0122, 15.5987, 6.8246, 14.8586, 6.6839, 14.0514)
    ..cubicTo(6.6444, 13.8249, 6.4497, 13.6566, 6.2197, 13.6566)
    ..lineTo(2.632, 13.6566)
    ..cubicTo(2.2323, 13.6566, 1.8791, 13.3959, 1.7616, 13.0137)
    ..cubicTo(1.5141, 12.2085, 1.381, 11.3538, 1.381, 10.4701)
    ..cubicTo(1.381, 6.1441, 4.5568, 2.5598, 8.7042, 1.9217)
    ..cubicTo(8.9396, 1.8855, 9.1198, 1.6871, 9.1198, 1.449)
    ..lineTo(9.1198, 0.9104)
    ..cubicTo(9.1198, 0.4076, 9.5274, 0, 10.0302, 0)
    ..close()
    ..moveTo(13.8408, 13.6566)
    ..cubicTo(13.6108, 13.6566, 13.4161, 13.8249, 13.3766, 14.0514)
    ..cubicTo(13.2358, 14.8586, 13.0482, 15.5987, 12.8203, 16.2448)
    ..cubicTo(12.7481, 16.4491, 12.949, 16.647, 13.1418, 16.5481)
    ..cubicTo(14.1598, 16.0259, 15.0296, 15.2559, 15.6712, 14.3173)
    ..cubicTo(15.8689, 14.028, 15.6483, 13.6566, 15.2979, 13.6566)
    ..lineTo(13.8408, 13.6566)
    ..close()
    ..moveTo(9.6223, 9.1044)
    ..cubicTo(8.8534, 9.1044, 8.2094, 9.7012, 8.2094, 10.4701)
    ..cubicTo(8.2094, 11.2389, 8.8534, 11.8357, 9.6223, 11.8357)
    ..lineTo(10.4382, 11.8357)
    ..cubicTo(11.207, 11.8357, 11.8511, 11.2389, 11.8511, 10.4701)
    ..cubicTo(11.8511, 9.7012, 11.207, 9.1044, 10.4382, 9.1044)
    ..lineTo(9.6223, 9.1044)
    ..close()
    ..moveTo(7.2402, 4.6954)
    ..cubicTo(7.3124, 4.4909, 7.1102, 4.2925, 6.9173, 4.3915)
    ..cubicTo(5.8998, 4.9138, 5.0305, 5.6842, 4.3892, 6.6228)
    ..cubicTo(4.1915, 6.9121, 4.4122, 7.2835, 4.7626, 7.2835)
    ..lineTo(6.2197, 7.2835)
    ..cubicTo(6.4497, 7.2835, 6.6444, 7.1153, 6.6839, 6.8887)
    ..cubicTo(6.8246, 6.0816, 7.0122, 5.3415, 7.2402, 4.6954)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(3.8126, 14.8838)
    ..cubicTo(3.9987, 14.8879, 4.2194, 14.9934, 4.3055, 15.2315)
    ..lineTo(4.3095, 15.2429)
    ..lineTo(4.3181, 15.2681)
    ..cubicTo(4.499, 15.7954, 4.6253, 16.0909, 4.8964, 16.3636)
    ..cubicTo(5.1721, 16.641, 5.3896, 16.7697, 5.8901, 16.9515)
    ..cubicTo(6.1538, 17.0473, 6.2448, 17.2984, 6.2383, 17.4837)
    ..cubicTo(6.2318, 17.6688, 6.1241, 17.9111, 5.8574, 17.9902)
    ..cubicTo(5.3407, 18.1436, 5.1662, 18.2315, 4.8964, 18.5001)
    ..cubicTo(4.6267, 18.7686, 4.4605, 19.114, 4.3082, 19.6212)
    ..cubicTo(4.2295, 19.8833, 3.9923, 19.9939, 3.8038, 19.9998)
    ..cubicTo(3.6147, 20.0056, 3.3672, 19.9084, 3.2767, 19.6445)
    ..cubicTo(3.1061, 19.1468, 2.9703, 18.7751, 2.7088, 18.5001)
    ..cubicTo(2.4504, 18.2281, 2.251, 18.1521, 1.6802, 17.9785)
    ..cubicTo(1.4276, 17.9017, 1.3134, 17.6753, 1.3049, 17.4864)
    ..cubicTo(1.2963, 17.2969, 1.391, 17.058, 1.6419, 16.9621)
    ..lineTo(1.6912, 16.9431)
    ..cubicTo(2.1957, 16.7461, 2.3501, 16.6275, 2.6152, 16.3636)
    ..cubicTo(2.8887, 16.0914, 3.0889, 15.7905, 3.3004, 15.2251)
    ..lineTo(3.3048, 15.2137)
    ..cubicTo(3.3995, 14.9765, 3.6261, 14.8798, 3.8126, 14.8838)
    ..close()
    ..moveTo(3.8126, 15.7796)
    ..cubicTo(3.6239, 16.1871, 3.4048, 16.6654, 3.1259, 16.9431)
    ..cubicTo(2.8548, 17.2129, 2.5406, 17.2717, 2.1665, 17.4488)
    ..cubicTo(2.5946, 17.6275, 2.9614, 17.7007, 3.2366, 17.9902)
    ..cubicTo(3.4914, 18.2583, 3.6509, 18.7204, 3.8038, 19.0675)
    ..cubicTo(3.9635, 18.6915, 4.1145, 18.2602, 4.3857, 17.9902)
    ..cubicTo(4.6636, 17.7136, 5.0518, 17.6138, 5.445, 17.452)
    ..cubicTo(5.0764, 17.2796, 4.6577, 17.1479, 4.3857, 16.8743)
    ..cubicTo(4.1076, 16.5946, 3.9908, 16.1825, 3.8126, 15.7796)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(3.8126, 15.7796)
    ..cubicTo(3.6239, 16.1871, 3.4048, 16.6654, 3.1259, 16.9431)
    ..cubicTo(2.8548, 17.2129, 2.5406, 17.2717, 2.1665, 17.4488)
    ..cubicTo(2.5946, 17.6275, 2.9614, 17.7007, 3.2366, 17.9902)
    ..cubicTo(3.4914, 18.2583, 3.6509, 18.7204, 3.8038, 19.0675)
    ..cubicTo(3.9635, 18.6915, 4.1145, 18.2602, 4.3857, 17.9902)
    ..cubicTo(4.6636, 17.7136, 5.0518, 17.6138, 5.445, 17.452)
    ..cubicTo(5.0764, 17.2796, 4.6577, 17.1479, 4.3857, 16.8743)
    ..cubicTo(4.1076, 16.5946, 3.9908, 16.1825, 3.8126, 15.7796)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(16.3707, 0.4652)
    ..cubicTo(16.5568, 0.4693, 16.7775, 0.5748, 16.8636, 0.8129)
    ..lineTo(16.8676, 0.8243)
    ..lineTo(16.8762, 0.8495)
    ..cubicTo(17.0572, 1.3768, 17.1834, 1.6723, 17.4545, 1.945)
    ..cubicTo(17.7303, 2.2224, 17.9477, 2.3511, 18.4482, 2.5329)
    ..cubicTo(18.712, 2.6287, 18.803, 2.8798, 18.7965, 3.0651)
    ..cubicTo(18.7899, 3.2502, 18.6822, 3.4925, 18.4156, 3.5716)
    ..cubicTo(17.8989, 3.725, 17.7243, 3.8129, 17.4545, 4.0815)
    ..cubicTo(17.1848, 4.35, 17.0186, 4.6954, 16.8663, 5.2026)
    ..cubicTo(16.7876, 5.4647, 16.5504, 5.5753, 16.3619, 5.5812)
    ..cubicTo(16.1728, 5.587, 15.9254, 5.4898, 15.8349, 5.2259)
    ..cubicTo(15.6642, 4.7282, 15.5284, 4.3565, 15.267, 4.0815)
    ..cubicTo(15.0085, 3.8095, 14.8092, 3.7336, 14.2383, 3.5599)
    ..cubicTo(13.9857, 3.4831, 13.8715, 3.2567, 13.863, 3.0678)
    ..cubicTo(13.8545, 2.8783, 13.9491, 2.6394, 14.2, 2.5435)
    ..lineTo(14.2494, 2.5245)
    ..cubicTo(14.7538, 2.3275, 14.9082, 2.2089, 15.1733, 1.945)
    ..cubicTo(15.4468, 1.6728, 15.647, 1.3719, 15.8586, 0.8065)
    ..lineTo(15.863, 0.7951)
    ..cubicTo(15.9576, 0.5579, 16.1843, 0.4612, 16.3707, 0.4652)
    ..close()
    ..moveTo(16.3707, 1.361)
    ..cubicTo(16.182, 1.7685, 15.963, 2.2468, 15.6841, 2.5245)
    ..cubicTo(15.413, 2.7943, 15.0987, 2.8531, 14.7247, 3.0302)
    ..cubicTo(15.1527, 3.2089, 15.5196, 3.2822, 15.7947, 3.5716)
    ..cubicTo(16.0495, 3.8397, 16.2091, 4.3018, 16.3619, 4.6489)
    ..cubicTo(16.5216, 4.2729, 16.6726, 3.8416, 16.9438, 3.5716)
    ..cubicTo(17.2217, 3.295, 17.6099, 3.1952, 18.0031, 3.0334)
    ..cubicTo(17.6345, 2.861, 17.2158, 2.7293, 16.9438, 2.4557)
    ..cubicTo(16.6657, 2.1759, 16.549, 1.7639, 16.3707, 1.361)
    ..close();

  static final Path __path4 = Path()
    ..moveTo(16.3707, 1.361)
    ..cubicTo(16.182, 1.7685, 15.963, 2.2468, 15.6841, 2.5245)
    ..cubicTo(15.413, 2.7943, 15.0987, 2.8531, 14.7247, 3.0302)
    ..cubicTo(15.1527, 3.2089, 15.5196, 3.2822, 15.7947, 3.5716)
    ..cubicTo(16.0495, 3.8397, 16.2091, 4.3018, 16.3619, 4.6489)
    ..cubicTo(16.5216, 4.2729, 16.6726, 3.8416, 16.9438, 3.5716)
    ..cubicTo(17.2217, 3.295, 17.6099, 3.1952, 18.0031, 3.0334)
    ..cubicTo(17.6345, 2.861, 17.2158, 2.7293, 16.9438, 2.4557)
    ..cubicTo(16.6657, 2.1759, 16.549, 1.7639, 16.3707, 1.361)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _DiscoBall._viewBoxWidth;
    final scaleY = size.height / _DiscoBall._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_DiscoBall._viewBoxMinX, -_DiscoBall._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DiscoBallPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/double-cross.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _DoubleCross extends StatelessWidget with _DotdartSvgSizing {
  const _DoubleCross({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _DoubleCross._svgWidth;

  @override
  double get svgNativeHeight => _DoubleCross._svgHeight;

  @override
  double get svgViewBoxWidth => _DoubleCross._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _DoubleCross._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _DoubleCrossPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _DoubleCrossPainter extends CustomPainter {
  _DoubleCrossPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.816970182,
    0.0,
    0.0,
    0.0,
    0.0,
    0.816970182,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.830298182,
    1.830298182,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(0.3926, 5.8926)
    ..cubicTo(0.9161, 5.3692, 1.7648, 5.3692, 2.2883, 5.8926)
    ..lineTo(4.5, 8.1044)
    ..lineTo(6.7117, 5.8926)
    ..cubicTo(7.2352, 5.3691, 8.084, 5.3691, 8.6074, 5.8926)
    ..cubicTo(9.1308, 6.4161, 9.1308, 7.2648, 8.6074, 7.7883)
    ..lineTo(6.3956, 10)
    ..lineTo(8.6075, 12.2117)
    ..cubicTo(9.1309, 12.7352, 9.1309, 13.584, 8.6075, 14.1075)
    ..cubicTo(8.084, 14.6309, 7.2352, 14.6309, 6.7117, 14.1075)
    ..lineTo(4.5, 11.8957)
    ..lineTo(2.2883, 14.1075)
    ..cubicTo(1.7648, 14.6309, 0.9161, 14.6309, 0.3926, 14.1075)
    ..cubicTo(-0.1309, 13.584, -0.1309, 12.7352, 0.3926, 12.2117)
    ..lineTo(2.6043, 10)
    ..lineTo(0.3926, 7.7883)
    ..cubicTo(-0.1309, 7.2648, -0.1309, 6.4161, 0.3926, 5.8926)
    ..close();

  static final Path __path1 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(11.3926, 5.8926)
    ..cubicTo(11.9161, 5.3692, 12.7648, 5.3692, 13.2883, 5.8926)
    ..lineTo(15.5, 8.1044)
    ..lineTo(17.7117, 5.8926)
    ..cubicTo(18.2352, 5.3691, 19.084, 5.3691, 19.6074, 5.8926)
    ..cubicTo(20.1308, 6.4161, 20.1308, 7.2648, 19.6074, 7.7883)
    ..lineTo(17.3956, 10)
    ..lineTo(19.6074, 12.2117)
    ..cubicTo(20.1308, 12.7352, 20.1308, 13.584, 19.6074, 14.1075)
    ..cubicTo(19.084, 14.6309, 18.2352, 14.6309, 17.7117, 14.1075)
    ..lineTo(15.5, 11.8957)
    ..lineTo(13.2883, 14.1075)
    ..cubicTo(12.7648, 14.6308, 11.9161, 14.6308, 11.3926, 14.1075)
    ..cubicTo(10.8691, 13.584, 10.8691, 12.7352, 11.3926, 12.2117)
    ..lineTo(13.6043, 10)
    ..lineTo(11.3926, 7.7883)
    ..cubicTo(10.8691, 7.2648, 10.8691, 6.4161, 11.3926, 5.8926)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _DoubleCross._viewBoxWidth;
    final scaleY = size.height / _DoubleCross._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_DoubleCross._viewBoxMinX, -_DoubleCross._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DoubleCrossPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/drop.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Drop extends StatelessWidget with _DotdartSvgSizing {
  const _Drop({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Drop._svgWidth;

  @override
  double get svgNativeHeight => _Drop._svgHeight;

  @override
  double get svgViewBoxWidth => _Drop._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Drop._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _DropPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _DropPainter extends CustomPainter {
  _DropPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.73427968,
    0.0,
    0.0,
    0.0,
    0.0,
    0.73427968,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.657203197,
    2.657203197,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(11.984, 0.8458)
    ..cubicTo(10.8881, -0.2819, 9.115, -0.2819, 8.0191, 0.8458)
    ..cubicTo(6.9858, 1.909, 5.501, 3.5751, 4.2686, 5.5076)
    ..cubicTo(3.0497, 7.4189, 2, 9.7099, 2, 11.9984)
    ..cubicTo(2, 16.4175, 5.5824, 20, 10.0016, 20)
    ..cubicTo(14.4207, 20, 18.0031, 16.4175, 18.0031, 11.9984)
    ..cubicTo(18.0031, 9.7099, 16.9534, 7.4189, 15.7346, 5.5076)
    ..cubicTo(14.5021, 3.5751, 13.0174, 1.909, 11.984, 0.8458)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Drop._viewBoxWidth;
    final scaleY = size.height / _Drop._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Drop._viewBoxMinX, -_Drop._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DropPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/drop-foam.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _DropFoam extends StatelessWidget with _DotdartSvgSizing {
  const _DropFoam({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _DropFoam._svgWidth;

  @override
  double get svgNativeHeight => _DropFoam._svgHeight;

  @override
  double get svgViewBoxWidth => _DropFoam._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _DropFoam._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _DropFoamPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _DropFoamPainter extends CustomPainter {
  _DropFoamPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.852658809,
    0.0,
    0.0,
    0.0,
    0.0,
    0.852658809,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.566671464,
    1.513380289,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(11.5079, 0.8131)
    ..cubicTo(10.843, 0.129, 9.7673, 0.129, 9.1024, 0.8131)
    ..cubicTo(8.4755, 1.4582, 7.5747, 2.469, 6.827, 3.6414)
    ..cubicTo(6.0875, 4.8009, 5.4507, 6.1909, 5.4507, 7.5793)
    ..cubicTo(5.4507, 10.2603, 7.6241, 12.4337, 10.3051, 12.4337)
    ..cubicTo(12.9862, 12.4337, 15.1596, 10.2603, 15.1596, 7.5793)
    ..cubicTo(15.1596, 6.1909, 14.5227, 4.8009, 13.7833, 3.6414)
    ..cubicTo(13.0356, 2.469, 12.1348, 1.4582, 11.5079, 0.8131)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(3.3881, 7.0507)
    ..cubicTo(4.3766, 6.9579, 4.2342, 7.5327, 4.2822, 8.2293)
    ..cubicTo(4.4958, 11.3312, 7.3402, 13.8419, 10.4485, 13.6556)
    ..cubicTo(10.704, 13.638, 10.9583, 13.6044, 11.2095, 13.5546)
    ..cubicTo(11.325, 13.5308, 11.5819, 13.4648, 11.6789, 13.4555)
    ..cubicTo(11.7413, 13.4498, 11.8044, 13.4562, 11.8646, 13.4741)
    ..cubicTo(12.4105, 13.6396, 12.1805, 14.2521, 12.1635, 14.6684)
    ..cubicTo(12.1351, 15.3596, 12.292, 16.0457, 12.618, 16.6557)
    ..cubicTo(12.6671, 16.7481, 12.7218, 16.8361, 12.7761, 16.9236)
    ..cubicTo(12.8889, 17.1052, 12.9114, 17.328, 12.8265, 17.5241)
    ..cubicTo(12.5073, 18.261, 11.9411, 18.8683, 11.2202, 19.2375)
    ..cubicTo(10.3635, 19.6801, 9.4616, 19.7409, 8.5449, 19.4522)
    ..cubicTo(8.436, 19.4149, 8.3287, 19.3729, 8.2235, 19.3263)
    ..cubicTo(7.7504, 19.1179, 7.3358, 18.8069, 7.0065, 18.4213)
    ..cubicTo(6.6378, 17.9899, 5.9411, 17.8199, 5.422, 18.0491)
    ..cubicTo(4.9096, 18.2753, 4.3479, 18.3849, 3.7781, 18.3631)
    ..cubicTo(2.791, 18.313, 1.8639, 17.8742, 1.1994, 17.1425)
    ..cubicTo(0.5271, 16.3993, 0.1774, 15.4195, 0.2271, 14.4184)
    ..cubicTo(0.2716, 13.4739, 0.6798, 12.6461, 1.3057, 11.9732)
    ..cubicTo(1.4689, 11.7977, 1.4797, 11.5285, 1.3408, 11.3331)
    ..cubicTo(0.1096, 9.6008, 1.2818, 7.2062, 3.3881, 7.0507)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(16.0508, 11.3214)
    ..cubicTo(17.9449, 11.1771, 19.5977, 12.5945, 19.7438, 14.4885)
    ..cubicTo(19.8898, 16.3825, 18.4739, 18.0367, 16.5801, 18.1844)
    ..cubicTo(14.6838, 18.3324, 13.0269, 16.9143, 12.8807, 15.0179)
    ..cubicTo(12.7344, 13.1214, 14.1543, 11.4659, 16.0508, 11.3214)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(1.7131, 2.5612)
    ..cubicTo(2.7593, 2.4553, 3.6935, 3.2171, 3.8001, 4.2632)
    ..cubicTo(3.9068, 5.3094, 3.1455, 6.244, 2.0995, 6.3514)
    ..cubicTo(1.0524, 6.4588, 0.1167, 5.6967, 0.01, 4.6496)
    ..cubicTo(-0.0968, 3.6025, 0.6659, 2.6673, 1.7131, 2.5612)
    ..close();

  static final Path __path4 = Path()
    ..moveTo(17.7022, 6.6367)
    ..cubicTo(18.7394, 6.5349, 19.6627, 7.2936, 19.7637, 8.331)
    ..cubicTo(19.8648, 9.3682, 19.1056, 10.291, 18.0683, 10.3914)
    ..cubicTo(17.0318, 10.4918, 16.11, 9.7333, 16.009, 8.697)
    ..cubicTo(15.908, 7.6606, 16.6658, 6.7384, 17.7022, 6.6367)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _DropFoam._viewBoxWidth;
    final scaleY = size.height / _DropFoam._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_DropFoam._viewBoxMinX, -_DropFoam._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DropFoamPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/dumbbell.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Dumbbell extends StatelessWidget with _DotdartSvgSizing {
  const _Dumbbell({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Dumbbell._svgWidth;

  @override
  double get svgNativeHeight => _Dumbbell._svgHeight;

  @override
  double get svgViewBoxWidth => _Dumbbell._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Dumbbell._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _DumbbellPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _DumbbellPainter extends CustomPainter {
  _DumbbellPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.774085504,
    0.0,
    0.0,
    0.0,
    0.0,
    0.774085504,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.259144963,
    2.380095823,
    0.0,
    1.0,
  ]);
  static final RRect _rrect0 = RRect.fromRectAndRadius(
    const Rect.fromLTWH(3.1056, 4, 3.6025, 11.677),
    const Radius.circular(1.8012),
  );

  static final RRect _rrect1 = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 5.7391, 2.3603, 8.323),
    const Radius.circular(1.1801),
  );

  static final RRect _rrect2 = RRect.fromRectAndRadius(
    const Rect.fromLTWH(17.6397, 5.7391, 2.3603, 8.323),
    const Radius.circular(1.1801),
  );

  static final RRect _rrect3 = RRect.fromRectAndRadius(
    const Rect.fromLTWH(13.44, 4, 3.4783, 11.677),
    const Radius.circular(1.7391),
  );

  static final RRect _rrect4 = RRect.fromRectAndRadius(
    const Rect.fromLTWH(7.55, 11.5776, 3.4783, 5.0932),
    const Radius.circular(1.7391),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Dumbbell._viewBoxWidth;
    final scaleY = size.height / _Dumbbell._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Dumbbell._viewBoxMinX, -_Dumbbell._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawRRect(_rrect0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawRRect(_rrect1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawRRect(_rrect2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawRRect(_rrect3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.save();
    canvas
      ..translate(7.55, 11.5776)
      ..rotate(-90 * math.pi / 180)
      ..translate(-7.55, -11.5776);
    canvas.drawRRect(_rrect4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DumbbellPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/eraser.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Eraser extends StatelessWidget with _DotdartSvgSizing {
  const _Eraser({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Eraser._svgWidth;

  @override
  double get svgNativeHeight => _Eraser._svgHeight;

  @override
  double get svgViewBoxWidth => _Eraser._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Eraser._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _EraserPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _EraserPainter extends CustomPainter {
  _EraserPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.746554577,
    0.0,
    0.0,
    0.0,
    0.0,
    0.746554577,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.53445423,
    2.546119146,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(7.0828, 2.7004)
    ..cubicTo(7.7916, 1.9847, 8.146, 1.6268, 8.4847, 1.3675)
    ..cubicTo(10.7017, -0.3302, 13.7776, -0.3451, 16.011, 1.3311)
    ..cubicTo(16.3521, 1.5871, 16.71, 1.9415, 17.4256, 2.6503)
    ..cubicTo(18.1413, 3.3591, 18.4992, 3.7135, 18.7585, 4.0521)
    ..cubicTo(20.4562, 6.2691, 20.4711, 9.3451, 18.7949, 11.5784)
    ..cubicTo(18.5389, 11.9196, 18.1845, 12.2774, 17.4757, 12.9931)
    ..lineTo(13.5856, 16.9211)
    ..lineTo(3.1927, 6.6284)
    ..lineTo(7.0828, 2.7004)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(2.1803, 7.3848)
    ..lineTo(12.5732, 17.6775)
    ..cubicTo(11.8925, 18.3648, 11.5522, 18.7084, 11.2203, 18.9488)
    ..cubicTo(9.4847, 20.2055, 7.1414, 20.2169, 5.3937, 18.977)
    ..cubicTo(5.0595, 18.7399, 4.7158, 18.3996, 4.0286, 17.7189)
    ..lineTo(2.2216, 15.9294)
    ..cubicTo(1.5344, 15.2488, 1.1907, 14.9084, 0.9504, 14.5765)
    ..cubicTo(-0.3063, 12.841, -0.3177, 10.4976, 0.9222, 8.7499)
    ..cubicTo(1.1593, 8.4157, 1.4996, 8.0721, 2.1803, 7.3848)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Eraser._viewBoxWidth;
    final scaleY = size.height / _Eraser._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Eraser._viewBoxMinX, -_Eraser._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _EraserPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/ev-plug.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _EvPlug extends StatelessWidget with _DotdartSvgSizing {
  const _EvPlug({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _EvPlug._svgWidth;

  @override
  double get svgNativeHeight => _EvPlug._svgHeight;

  @override
  double get svgViewBoxWidth => _EvPlug._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _EvPlug._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _EvPlugPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _EvPlugPainter extends CustomPainter {
  _EvPlugPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.654126563,
    0.0,
    0.0,
    0.0,
    0.0,
    0.654126563,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.468955093,
    3.458734365,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(10.712, 1.2242)
    ..cubicTo(10.712, 0.5481, 11.2601, 0, 11.9362, 0)
    ..cubicTo(12.6123, 0, 13.1605, 0.5481, 13.1605, 1.2242)
    ..lineTo(13.1605, 2.542)
    ..cubicTo(13.1605, 2.8646, 12.8989, 3.1261, 12.5763, 3.1261)
    ..lineTo(11.2961, 3.1261)
    ..cubicTo(10.9735, 3.1261, 10.712, 2.8646, 10.712, 2.542)
    ..lineTo(10.712, 1.2242)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(6.8207, 1.2242)
    ..cubicTo(6.8207, 0.5481, 7.3688, 0, 8.0449, 0)
    ..cubicTo(8.721, 0, 9.2691, 0.5481, 9.2691, 1.2242)
    ..lineTo(9.2691, 2.542)
    ..cubicTo(9.2691, 2.8646, 9.0076, 3.1261, 8.685, 3.1261)
    ..lineTo(7.4048, 3.1261)
    ..cubicTo(7.0822, 3.1261, 6.8207, 2.8646, 6.8207, 2.542)
    ..lineTo(6.8207, 1.2242)
    ..close();

  static final Path __path2 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(11.5166, 4.0303)
    ..cubicTo(12.6824, 4.0303, 13.2653, 4.03, 13.7236, 4.2246)
    ..cubicTo(14.3072, 4.4724, 14.7717, 4.937, 15.0195, 5.5205)
    ..cubicTo(15.2141, 5.9788, 15.2139, 6.5619, 15.2139, 7.7275)
    ..lineTo(15.2139, 8.1992)
    ..cubicTo(15.2139, 8.7615, 15.2146, 9.0428, 15.1914, 9.3174)
    ..cubicTo(15.1114, 10.2643, 14.8257, 11.1826, 14.3545, 12.0078)
    ..cubicTo(14.2178, 12.2472, 14.0584, 12.4791, 13.7392, 12.9424)
    ..lineTo(13.1348, 13.8184)
    ..cubicTo(12.567, 14.6427, 12.2637, 15.6202, 12.2637, 16.6211)
    ..lineTo(12.2637, 17.7676)
    ..cubicTo(12.2637, 19.0004, 11.264, 19.9998, 10.0312, 20)
    ..cubicTo(8.7983, 20, 7.7988, 19.0005, 7.7988, 17.7676)
    ..lineTo(7.7988, 16.6777)
    ..cubicTo(7.7988, 15.6429, 7.4682, 14.6347, 6.8555, 13.8008)
    ..lineTo(6.2842, 13.0225)
    ..cubicTo(6.041, 12.6915, 5.9192, 12.5262, 5.8105, 12.3574)
    ..cubicTo(5.2046, 11.4168, 4.8499, 10.3365, 4.7812, 9.2197)
    ..cubicTo(4.7689, 9.0194, 4.7695, 8.8139, 4.7695, 8.4033)
    ..lineTo(4.7695, 7.7256)
    ..cubicTo(4.7695, 6.5621, 4.7691, 5.98, 4.9629, 5.5225)
    ..cubicTo(5.2107, 4.9374, 5.6766, 4.4715, 6.2617, 4.2236)
    ..cubicTo(6.7191, 4.03, 7.3009, 4.0303, 8.4639, 4.0303)
    ..lineTo(11.5166, 4.0303)
    ..close()
    ..moveTo(10.7197, 7.0908)
    ..cubicTo(10.8211, 6.5838, 10.159, 6.2971, 9.8584, 6.7178)
    ..lineTo(8.3799, 8.7881)
    ..cubicTo(8.1533, 9.1057, 8.3803, 9.5469, 8.7705, 9.5469)
    ..lineTo(9.4512, 9.5469)
    ..lineTo(9.248, 10.5625)
    ..cubicTo(9.1466, 11.0695, 9.8078, 11.3562, 10.1084, 10.9355)
    ..lineTo(11.5879, 8.8652)
    ..cubicTo(11.8141, 8.5477, 11.5872, 8.1066, 11.1973, 8.1065)
    ..lineTo(10.5166, 8.1065)
    ..lineTo(10.7197, 7.0908)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _EvPlug._viewBoxWidth;
    final scaleY = size.height / _EvPlug._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_EvPlug._viewBoxMinX, -_EvPlug._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _EvPlugPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/exclamation-circle.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ExclamationCircle extends StatelessWidget with _DotdartSvgSizing {
  const _ExclamationCircle({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ExclamationCircle._svgWidth;

  @override
  double get svgNativeHeight => _ExclamationCircle._svgHeight;

  @override
  double get svgViewBoxWidth => _ExclamationCircle._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ExclamationCircle._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ExclamationCirclePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ExclamationCirclePainter extends CustomPainter {
  _ExclamationCirclePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.777314759,
    0.0,
    0.0,
    0.0,
    0.0,
    0.777314759,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.226852413,
    2.226852413,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10, 0)
    ..cubicTo(15.5228, 0, 20, 4.4771, 20, 10)
    ..cubicTo(20, 15.5228, 15.5228, 20, 10, 20)
    ..cubicTo(4.4771, 20, 0, 15.5228, 0, 10)
    ..cubicTo(0, 4.4771, 4.4771, 0, 10, 0)
    ..close()
    ..moveTo(10, 12.7998)
    ..cubicTo(9.3926, 12.7998, 8.9006, 13.2921, 8.9004, 13.8994)
    ..cubicTo(8.9004, 14.5069, 9.3925, 15, 10, 15)
    ..cubicTo(10.6075, 14.9999, 11.0996, 14.5069, 11.0996, 13.8994)
    ..cubicTo(11.0994, 13.2921, 10.6073, 12.7999, 10, 12.7998)
    ..close()
    ..moveTo(10, 5)
    ..cubicTo(9.4575, 5, 9.0271, 5.4565, 9.0586, 5.9981)
    ..lineTo(9.3125, 10.3516)
    ..cubicTo(9.334, 10.7157, 9.6352, 11, 10, 11)
    ..cubicTo(10.3648, 11, 10.666, 10.7157, 10.6875, 10.3516)
    ..lineTo(10.9414, 5.9981)
    ..cubicTo(10.9729, 5.4565, 10.5425, 5, 10, 5)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ExclamationCircle._viewBoxWidth;
    final scaleY = size.height / _ExclamationCircle._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_ExclamationCircle._viewBoxMinX,
        -_ExclamationCircle._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ExclamationCirclePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/exclamation-triangle.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ExclamationTriangle extends StatelessWidget with _DotdartSvgSizing {
  const _ExclamationTriangle({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ExclamationTriangle._svgWidth;

  @override
  double get svgNativeHeight => _ExclamationTriangle._svgHeight;

  @override
  double get svgViewBoxWidth => _ExclamationTriangle._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ExclamationTriangle._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ExclamationTrianglePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ExclamationTrianglePainter extends CustomPainter {
  _ExclamationTrianglePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.756356925,
    0.0,
    0.0,
    0.0,
    0.0,
    0.756356925,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.436430745,
    2.058252282,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(6.8495, 3.6981)
    ..cubicTo(8.2973, 1.434, 11.7026, 1.434, 13.1505, 3.6981)
    ..lineTo(19.4404, 13.5337)
    ..cubicTo(20.9665, 15.9201, 19.1915, 19, 16.2898, 19)
    ..lineTo(3.7102, 19)
    ..cubicTo(0.8086, 19, -0.9665, 15.9201, 0.5597, 13.5337)
    ..lineTo(6.8495, 3.6981)
    ..close()
    ..moveTo(10.0016, 7.5368)
    ..cubicTo(10.4108, 7.5368, 10.7425, 7.8576, 10.7425, 8.2533)
    ..lineTo(10.7425, 12.0743)
    ..cubicTo(10.7425, 12.47, 10.4108, 12.7907, 10.0016, 12.7907)
    ..cubicTo(9.5925, 12.7907, 9.2608, 12.47, 9.2608, 12.0743)
    ..lineTo(9.2608, 8.2533)
    ..cubicTo(9.2608, 7.8576, 9.5925, 7.5368, 10.0016, 7.5368)
    ..close()
    ..moveTo(10.9894, 14.7012)
    ..cubicTo(10.9894, 15.2288, 10.5472, 15.6565, 10.0016, 15.6565)
    ..cubicTo(9.456, 15.6565, 9.0138, 15.2288, 9.0138, 14.7012)
    ..cubicTo(9.0138, 14.1737, 9.456, 13.746, 10.0016, 13.746)
    ..cubicTo(10.5472, 13.746, 10.9894, 14.1737, 10.9894, 14.7012)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ExclamationTriangle._viewBoxWidth;
    final scaleY = size.height / _ExclamationTriangle._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_ExclamationTriangle._viewBoxMinX,
        -_ExclamationTriangle._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ExclamationTrianglePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/ferris-wheel.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _FerrisWheel extends StatelessWidget with _DotdartSvgSizing {
  const _FerrisWheel({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _FerrisWheel._svgWidth;

  @override
  double get svgNativeHeight => _FerrisWheel._svgHeight;

  @override
  double get svgViewBoxWidth => _FerrisWheel._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _FerrisWheel._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _FerrisWheelPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _FerrisWheelPainter extends CustomPainter {
  _FerrisWheelPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.683741366,
    0.0,
    0.0,
    0.0,
    0.0,
    0.683741366,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.301471309,
    3.162586344,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.2523, 0)
    ..cubicTo(10.5933, 0, 10.7638, 0, 10.9056, 0.0282)
    ..cubicTo(11.4879, 0.144, 11.9431, 0.5993, 12.059, 1.1816)
    ..cubicTo(12.0871, 1.3233, 12.0872, 1.4938, 12.0872, 1.8349)
    ..cubicTo(12.0872, 2.1759, 12.0871, 2.3464, 12.059, 2.4882)
    ..cubicTo(11.9431, 3.0705, 11.4879, 3.5257, 10.9056, 3.6415)
    ..cubicTo(10.7638, 3.6697, 10.5933, 3.6697, 10.2523, 3.6697)
    ..lineTo(9.5184, 3.6697)
    ..cubicTo(9.1774, 3.6697, 9.0068, 3.6697, 8.8651, 3.6415)
    ..cubicTo(8.2828, 3.5257, 7.8275, 3.0705, 7.7117, 2.4882)
    ..cubicTo(7.6835, 2.3464, 7.6835, 2.1759, 7.6835, 1.8349)
    ..cubicTo(7.6835, 1.4938, 7.6835, 1.3233, 7.7117, 1.1816)
    ..cubicTo(7.8275, 0.5993, 8.2828, 0.144, 8.8651, 0.0282)
    ..cubicTo(9.0068, 0, 9.1774, 0, 9.5184, 0)
    ..lineTo(10.2523, 0)
    ..close()
    ..moveTo(9.0138, 0.5505)
    ..cubicTo(8.6338, 0.5505, 8.3257, 0.8585, 8.3257, 1.2385)
    ..lineTo(8.3257, 1.3303)
    ..cubicTo(8.3257, 1.7103, 8.6338, 2.0183, 9.0138, 2.0183)
    ..cubicTo(9.3938, 2.0183, 9.7019, 1.7103, 9.7019, 1.3303)
    ..lineTo(9.7019, 1.2385)
    ..cubicTo(9.7019, 0.8585, 9.3938, 0.5505, 9.0138, 0.5505)
    ..close()
    ..moveTo(10.7569, 0.5505)
    ..cubicTo(10.3769, 0.5505, 10.0688, 0.8585, 10.0688, 1.2385)
    ..lineTo(10.0688, 1.3303)
    ..cubicTo(10.0688, 1.7103, 10.3769, 2.0183, 10.7569, 2.0183)
    ..cubicTo(11.1369, 2.0183, 11.445, 1.7103, 11.445, 1.3303)
    ..lineTo(11.445, 1.2385)
    ..cubicTo(11.445, 0.8585, 11.1369, 0.5505, 10.7569, 0.5505)
    ..close();

  static final Path __path1 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(16.8578, 3.9449)
    ..cubicTo(17.1988, 3.9449, 17.3693, 3.945, 17.5111, 3.9732)
    ..cubicTo(18.0934, 4.089, 18.5486, 4.5442, 18.6644, 5.1265)
    ..cubicTo(18.6926, 5.2683, 18.6927, 5.4388, 18.6927, 5.7798)
    ..cubicTo(18.6927, 6.1208, 18.6926, 6.2913, 18.6644, 6.4331)
    ..cubicTo(18.5486, 7.0154, 18.0934, 7.4706, 17.5111, 7.5865)
    ..cubicTo(17.3693, 7.6147, 17.1988, 7.6147, 16.8578, 7.6147)
    ..lineTo(16.1239, 7.6147)
    ..cubicTo(15.7829, 7.6147, 15.6123, 7.6147, 15.4706, 7.5865)
    ..cubicTo(14.8883, 7.4706, 14.433, 7.0154, 14.3172, 6.4331)
    ..cubicTo(14.289, 6.2913, 14.289, 6.1208, 14.289, 5.7798)
    ..cubicTo(14.289, 5.4388, 14.289, 5.2683, 14.3172, 5.1265)
    ..cubicTo(14.433, 4.5442, 14.8883, 4.089, 15.4706, 3.9732)
    ..cubicTo(15.6123, 3.945, 15.7829, 3.9449, 16.1239, 3.9449)
    ..lineTo(16.8578, 3.9449)
    ..close()
    ..moveTo(15.6193, 4.4954)
    ..cubicTo(15.2393, 4.4954, 14.9312, 4.8035, 14.9312, 5.1835)
    ..lineTo(14.9312, 5.2752)
    ..cubicTo(14.9312, 5.6552, 15.2393, 5.9633, 15.6193, 5.9633)
    ..cubicTo(15.9993, 5.9633, 16.3074, 5.6552, 16.3074, 5.2752)
    ..lineTo(16.3074, 5.1835)
    ..cubicTo(16.3074, 4.8035, 15.9993, 4.4954, 15.6193, 4.4954)
    ..close()
    ..moveTo(17.3624, 4.4954)
    ..cubicTo(16.9824, 4.4954, 16.6743, 4.8035, 16.6743, 5.1835)
    ..lineTo(16.6743, 5.2752)
    ..cubicTo(16.6743, 5.6552, 16.9824, 5.9633, 17.3624, 5.9633)
    ..cubicTo(17.7424, 5.9633, 18.0505, 5.6552, 18.0505, 5.2752)
    ..lineTo(18.0505, 5.1835)
    ..cubicTo(18.0505, 4.8035, 17.7424, 4.4954, 17.3624, 4.4954)
    ..close();

  static final Path __path2 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(16.5826, 10.367)
    ..cubicTo(16.9236, 10.367, 17.0941, 10.367, 17.2359, 10.3952)
    ..cubicTo(17.8182, 10.511, 18.2734, 10.9662, 18.3892, 11.5485)
    ..cubicTo(18.4174, 11.6903, 18.4174, 11.8608, 18.4174, 12.2018)
    ..cubicTo(18.4174, 12.5428, 18.4174, 12.7134, 18.3892, 12.8551)
    ..cubicTo(18.2734, 13.4374, 17.8182, 13.8927, 17.2359, 14.0085)
    ..cubicTo(17.0941, 14.0367, 16.9236, 14.0367, 16.5826, 14.0367)
    ..lineTo(15.8486, 14.0367)
    ..cubicTo(15.5076, 14.0367, 15.3371, 14.0367, 15.1953, 14.0085)
    ..cubicTo(14.613, 13.8927, 14.1578, 13.4374, 14.042, 12.8551)
    ..cubicTo(14.0138, 12.7134, 14.0138, 12.5428, 14.0138, 12.2018)
    ..cubicTo(14.0138, 11.8608, 14.0138, 11.6903, 14.042, 11.5485)
    ..cubicTo(14.1578, 10.9662, 14.613, 10.511, 15.1953, 10.3952)
    ..cubicTo(15.3371, 10.367, 15.5076, 10.367, 15.8486, 10.367)
    ..lineTo(16.5826, 10.367)
    ..close()
    ..moveTo(15.344, 10.9174)
    ..cubicTo(14.964, 10.9174, 14.656, 11.2255, 14.656, 11.6055)
    ..lineTo(14.656, 11.6972)
    ..cubicTo(14.656, 12.0773, 14.964, 12.3853, 15.344, 12.3853)
    ..cubicTo(15.7241, 12.3853, 16.0321, 12.0773, 16.0321, 11.6972)
    ..lineTo(16.0321, 11.6055)
    ..cubicTo(16.0321, 11.2255, 15.7241, 10.9174, 15.344, 10.9174)
    ..close()
    ..moveTo(17.0872, 10.9174)
    ..cubicTo(16.7071, 10.9174, 16.3991, 11.2255, 16.3991, 11.6055)
    ..lineTo(16.3991, 11.6972)
    ..cubicTo(16.3991, 12.0773, 16.7071, 12.3853, 17.0872, 12.3853)
    ..cubicTo(17.4672, 12.3853, 17.7752, 12.0773, 17.7752, 11.6972)
    ..lineTo(17.7752, 11.6055)
    ..cubicTo(17.7752, 11.2255, 17.4672, 10.9174, 17.0872, 10.9174)
    ..close();

  static final Path __path3 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(9.8395, 7.3395)
    ..cubicTo(10.8782, 7.3395, 11.7202, 8.1815, 11.7202, 9.2202)
    ..cubicTo(11.7202, 9.5644, 11.6277, 9.887, 11.4662, 10.1645)
    ..lineTo(15.6266, 18.5321)
    ..lineTo(15.7569, 18.5321)
    ..cubicTo(16.1622, 18.5321, 16.4908, 18.8607, 16.4908, 19.2661)
    ..cubicTo(16.4908, 19.6714, 16.1622, 20, 15.7569, 20)
    ..lineTo(3.8303, 20)
    ..cubicTo(3.4249, 20, 3.0963, 19.6714, 3.0963, 19.2661)
    ..cubicTo(3.0963, 18.8607, 3.4249, 18.5321, 3.8303, 18.5321)
    ..lineTo(4.3019, 18.5321)
    ..lineTo(8.2854, 10.2796)
    ..cubicTo(8.0793, 9.9779, 7.9587, 9.6131, 7.9587, 9.2202)
    ..cubicTo(7.9587, 8.1815, 8.8008, 7.3395, 9.8395, 7.3395)
    ..close()
    ..moveTo(10.4474, 11.0004)
    ..cubicTo(10.2567, 11.0655, 10.0522, 11.1009, 9.8395, 11.1009)
    ..cubicTo(9.6689, 11.1009, 9.5037, 11.0781, 9.3466, 11.0355)
    ..lineTo(5.7281, 18.5321)
    ..lineTo(14.1922, 18.5321)
    ..lineTo(10.4474, 11.0004)
    ..close();

  static final Path __path4 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.344, 14.5872)
    ..cubicTo(10.6851, 14.5872, 10.8556, 14.5872, 10.9974, 14.6154)
    ..cubicTo(11.5797, 14.7312, 12.0349, 15.1864, 12.1507, 15.7687)
    ..cubicTo(12.1789, 15.9105, 12.1789, 16.081, 12.1789, 16.422)
    ..cubicTo(12.1789, 16.763, 12.1789, 16.9335, 12.1507, 17.0753)
    ..cubicTo(12.0349, 17.6576, 11.5797, 18.1128, 10.9974, 18.2287)
    ..cubicTo(10.8556, 18.2569, 10.6851, 18.2569, 10.344, 18.2569)
    ..lineTo(9.6101, 18.2569)
    ..cubicTo(9.2691, 18.2569, 9.0986, 18.2569, 8.9568, 18.2287)
    ..cubicTo(8.3745, 18.1128, 7.9193, 17.6576, 7.8035, 17.0753)
    ..cubicTo(7.7753, 16.9335, 7.7752, 16.763, 7.7752, 16.422)
    ..cubicTo(7.7752, 16.081, 7.7753, 15.9105, 7.8035, 15.7687)
    ..cubicTo(7.9193, 15.1864, 8.3745, 14.7312, 8.9568, 14.6154)
    ..cubicTo(9.0986, 14.5872, 9.2691, 14.5872, 9.6101, 14.5872)
    ..lineTo(10.344, 14.5872)
    ..close()
    ..moveTo(9.1055, 15.1376)
    ..cubicTo(8.7255, 15.1376, 8.4174, 15.4457, 8.4174, 15.8257)
    ..lineTo(8.4174, 15.9174)
    ..cubicTo(8.4174, 16.2974, 8.7255, 16.6055, 9.1055, 16.6055)
    ..cubicTo(9.4855, 16.6055, 9.7936, 16.2974, 9.7936, 15.9174)
    ..lineTo(9.7936, 15.8257)
    ..cubicTo(9.7936, 15.4457, 9.4855, 15.1376, 9.1055, 15.1376)
    ..close()
    ..moveTo(10.8486, 15.1376)
    ..cubicTo(10.4686, 15.1376, 10.1606, 15.4457, 10.1606, 15.8257)
    ..lineTo(10.1606, 15.9174)
    ..cubicTo(10.1606, 16.2974, 10.4686, 16.6055, 10.8486, 16.6055)
    ..cubicTo(11.2286, 16.6055, 11.5367, 16.2974, 11.5367, 15.9174)
    ..lineTo(11.5367, 15.8257)
    ..cubicTo(11.5367, 15.4457, 11.2286, 15.1376, 10.8486, 15.1376)
    ..close();

  static final Path __path5 = Path()
    ..moveTo(4.9791, 13.6729)
    ..cubicTo(5.7595, 14.516, 6.7577, 15.1546, 7.8853, 15.4971)
    ..cubicTo(7.8498, 15.5837, 7.822, 15.6744, 7.8033, 15.7686)
    ..cubicTo(7.7751, 15.9103, 7.775, 16.0809, 7.775, 16.4219)
    ..cubicTo(7.775, 16.7628, 7.7751, 16.9334, 7.8033, 17.0752)
    ..cubicTo(7.8112, 17.1151, 7.8205, 17.1547, 7.8316, 17.1934)
    ..cubicTo(5.9181, 16.724, 4.2684, 15.584, 3.1451, 14.0371)
    ..lineTo(3.647, 14.0371)
    ..cubicTo(3.9879, 14.0371, 4.1586, 14.037, 4.3003, 14.0088)
    ..cubicTo(4.5579, 13.9575, 4.7896, 13.8385, 4.9791, 13.6729)
    ..close()
    ..moveTo(14.567, 13.7158)
    ..cubicTo(14.7465, 13.8591, 14.9601, 13.962, 15.1949, 14.0088)
    ..cubicTo(15.3366, 14.037, 15.5075, 14.0371, 15.8482, 14.0371)
    ..lineTo(16.441, 14.0371)
    ..cubicTo(15.3955, 15.4776, 13.8936, 16.5634, 12.148, 17.0859)
    ..cubicTo(12.1487, 17.0824, 12.1502, 17.0788, 12.1509, 17.0752)
    ..cubicTo(12.1791, 16.9334, 12.1793, 16.7627, 12.1793, 16.4219)
    ..cubicTo(12.1793, 16.0809, 12.1791, 15.9103, 12.1509, 15.7686)
    ..cubicTo(12.1243, 15.6344, 12.0782, 15.5077, 12.0181, 15.3896)
    ..cubicTo(12.9965, 15.036, 13.8675, 14.4584, 14.567, 13.7158)
    ..close()
    ..moveTo(17.8199, 7.4883)
    ..cubicTo(17.9398, 8.0465, 18.0044, 8.6256, 18.0045, 9.2197)
    ..cubicTo(18.0045, 9.7226, 17.9563, 10.2144, 17.8697, 10.6924)
    ..cubicTo(17.689, 10.5468, 17.4733, 10.4427, 17.2359, 10.3955)
    ..cubicTo(17.0941, 10.3673, 16.9236, 10.3672, 16.5826, 10.3672)
    ..lineTo(16.2515, 10.3672)
    ..cubicTo(16.3173, 9.9945, 16.3531, 9.6113, 16.3531, 9.2197)
    ..cubicTo(16.3531, 8.6657, 16.2832, 8.1281, 16.1539, 7.6143)
    ..lineTo(16.858, 7.6143)
    ..cubicTo(17.1989, 7.6143, 17.3695, 7.6151, 17.5113, 7.5869)
    ..cubicTo(17.619, 7.5655, 17.7222, 7.5316, 17.8199, 7.4883)
    ..close()
    ..moveTo(1.7652, 7.4873)
    ..cubicTo(1.8635, 7.5311, 1.9673, 7.5653, 2.0757, 7.5869)
    ..cubicTo(2.2175, 7.6151, 2.3882, 7.6143, 2.7291, 7.6143)
    ..lineTo(3.4312, 7.6143)
    ..cubicTo(3.302, 8.128, 3.234, 8.6659, 3.234, 9.2197)
    ..cubicTo(3.234, 9.6113, 3.2697, 9.9945, 3.3355, 10.3672)
    ..lineTo(2.9127, 10.3672)
    ..cubicTo(2.5718, 10.3672, 2.4011, 10.3673, 2.2593, 10.3955)
    ..cubicTo(2.0552, 10.4361, 1.8664, 10.5179, 1.7027, 10.6328)
    ..cubicTo(1.6231, 10.1738, 1.5826, 9.7015, 1.5826, 9.2197)
    ..cubicTo(1.5826, 8.6254, 1.6452, 8.0458, 1.7652, 7.4873)
    ..close()
    ..moveTo(12.0777, 1.333)
    ..cubicTo(13.663, 1.7913, 15.05, 2.7149, 16.0836, 3.9453)
    ..cubicTo(15.7692, 3.9454, 15.6064, 3.9466, 15.4703, 3.9736)
    ..cubicTo(15.0582, 4.0557, 14.71, 4.3075, 14.5005, 4.6543)
    ..cubicTo(13.7732, 3.9049, 12.8694, 3.3278, 11.855, 2.9922)
    ..cubicTo(11.9518, 2.8409, 12.0228, 2.6712, 12.0591, 2.4883)
    ..cubicTo(12.0873, 2.3465, 12.0875, 2.1759, 12.0875, 1.835)
    ..cubicTo(12.0875, 1.6043, 12.0864, 1.4515, 12.0777, 1.333)
    ..close()
    ..moveTo(7.6978, 1.2793)
    ..cubicTo(7.6843, 1.4053, 7.6832, 1.5678, 7.6832, 1.835)
    ..cubicTo(7.6832, 2.1759, 7.6833, 2.3465, 7.7115, 2.4883)
    ..cubicTo(7.7439, 2.6514, 7.8043, 2.8039, 7.8853, 2.9424)
    ..cubicTo(6.8087, 3.2692, 5.8493, 3.8653, 5.0855, 4.6523)
    ..cubicTo(4.8759, 4.3065, 4.5282, 4.0555, 4.1168, 3.9736)
    ..cubicTo(3.9804, 3.9465, 3.8173, 3.9453, 3.5015, 3.9453)
    ..cubicTo(4.5759, 2.6652, 6.0334, 1.7174, 7.6978, 1.2793)
    ..close();

  static final Path __path6 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(3.4633, 3.9449)
    ..cubicTo(3.8043, 3.9449, 3.9748, 3.945, 4.1166, 3.9732)
    ..cubicTo(4.6989, 4.089, 5.1541, 4.5442, 5.2699, 5.1265)
    ..cubicTo(5.2981, 5.2683, 5.2982, 5.4388, 5.2982, 5.7798)
    ..cubicTo(5.2982, 6.1208, 5.2981, 6.2913, 5.2699, 6.4331)
    ..cubicTo(5.1541, 7.0154, 4.6989, 7.4706, 4.1166, 7.5865)
    ..cubicTo(3.9748, 7.6147, 3.8043, 7.6147, 3.4633, 7.6147)
    ..lineTo(2.7294, 7.6147)
    ..cubicTo(2.3883, 7.6147, 2.2178, 7.6147, 2.076, 7.5865)
    ..cubicTo(1.4937, 7.4706, 1.0386, 7.0154, 0.9227, 6.4331)
    ..cubicTo(0.8945, 6.2913, 0.8945, 6.1208, 0.8945, 5.7798)
    ..cubicTo(0.8945, 5.4388, 0.8945, 5.2683, 0.9227, 5.1265)
    ..cubicTo(1.0386, 4.5442, 1.4937, 4.089, 2.076, 3.9732)
    ..cubicTo(2.2178, 3.945, 2.3883, 3.9449, 2.7294, 3.9449)
    ..lineTo(3.4633, 3.9449)
    ..close()
    ..moveTo(2.2248, 4.4954)
    ..cubicTo(1.8448, 4.4954, 1.5367, 4.8035, 1.5367, 5.1835)
    ..lineTo(1.5367, 5.2752)
    ..cubicTo(1.5367, 5.6552, 1.8448, 5.9633, 2.2248, 5.9633)
    ..cubicTo(2.6048, 5.9633, 2.9129, 5.6552, 2.9129, 5.2752)
    ..lineTo(2.9129, 5.1835)
    ..cubicTo(2.9129, 4.8035, 2.6048, 4.4954, 2.2248, 4.4954)
    ..close()
    ..moveTo(3.9679, 4.4954)
    ..cubicTo(3.5879, 4.4954, 3.2798, 4.8035, 3.2798, 5.1835)
    ..lineTo(3.2798, 5.2752)
    ..cubicTo(3.2798, 5.6552, 3.5879, 5.9633, 3.9679, 5.9633)
    ..cubicTo(4.3479, 5.9633, 4.656, 5.6552, 4.656, 5.2752)
    ..lineTo(4.656, 5.1835)
    ..cubicTo(4.656, 4.8035, 4.3479, 4.4954, 3.9679, 4.4954)
    ..close();

  static final Path __path7 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(3.6468, 10.367)
    ..cubicTo(3.9878, 10.367, 4.1583, 10.367, 4.3001, 10.3952)
    ..cubicTo(4.8824, 10.511, 5.3376, 10.9662, 5.4534, 11.5485)
    ..cubicTo(5.4816, 11.6903, 5.4816, 11.8608, 5.4816, 12.2018)
    ..cubicTo(5.4816, 12.5428, 5.4816, 12.7134, 5.4534, 12.8551)
    ..cubicTo(5.3376, 13.4374, 4.8824, 13.8927, 4.3001, 14.0085)
    ..cubicTo(4.1583, 14.0367, 3.9878, 14.0367, 3.6468, 14.0367)
    ..lineTo(2.9128, 14.0367)
    ..cubicTo(2.5718, 14.0367, 2.4013, 14.0367, 2.2595, 14.0085)
    ..cubicTo(1.6772, 13.8927, 1.222, 13.4374, 1.1062, 12.8551)
    ..cubicTo(1.078, 12.7134, 1.078, 12.5428, 1.078, 12.2018)
    ..cubicTo(1.078, 11.8608, 1.078, 11.6903, 1.1062, 11.5485)
    ..cubicTo(1.222, 10.9662, 1.6772, 10.511, 2.2595, 10.3952)
    ..cubicTo(2.4013, 10.367, 2.5718, 10.367, 2.9128, 10.367)
    ..lineTo(3.6468, 10.367)
    ..close()
    ..moveTo(2.4082, 10.9174)
    ..cubicTo(2.0282, 10.9174, 1.7202, 11.2255, 1.7202, 11.6055)
    ..lineTo(1.7202, 11.6972)
    ..cubicTo(1.7202, 12.0773, 2.0282, 12.3853, 2.4082, 12.3853)
    ..cubicTo(2.7883, 12.3853, 3.0963, 12.0773, 3.0963, 11.6972)
    ..lineTo(3.0963, 11.6055)
    ..cubicTo(3.0963, 11.2255, 2.7883, 10.9174, 2.4082, 10.9174)
    ..close()
    ..moveTo(4.1514, 10.9174)
    ..cubicTo(3.7713, 10.9174, 3.4633, 11.2255, 3.4633, 11.6055)
    ..lineTo(3.4633, 11.6972)
    ..cubicTo(3.4633, 12.0773, 3.7713, 12.3853, 4.1514, 12.3853)
    ..cubicTo(4.5314, 12.3853, 4.8394, 12.0773, 4.8394, 11.6972)
    ..lineTo(4.8394, 11.6055)
    ..cubicTo(4.8394, 11.2255, 4.5314, 10.9174, 4.1514, 10.9174)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _FerrisWheel._viewBoxWidth;
    final scaleY = size.height / _FerrisWheel._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_FerrisWheel._viewBoxMinX, -_FerrisWheel._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path5, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path6, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path7, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FerrisWheelPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/figure-crop-circle.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _FigureCropCircle extends StatelessWidget with _DotdartSvgSizing {
  const _FigureCropCircle({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _FigureCropCircle._svgWidth;

  @override
  double get svgNativeHeight => _FigureCropCircle._svgHeight;

  @override
  double get svgViewBoxWidth => _FigureCropCircle._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _FigureCropCircle._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _FigureCropCirclePainter(
            mateoOpticalSizeColor:
                mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _FigureCropCirclePainter extends CustomPainter {
  _FigureCropCirclePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.795934967,
    0.0,
    0.0,
    0.0,
    0.0,
    0.795934967,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.040650334,
    2.040650334,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10, 0)
    ..cubicTo(15.5234, 0, 20, 4.4772, 20, 10)
    ..cubicTo(20, 15.5228, 15.5234, 20, 10, 20)
    ..cubicTo(4.4766, 20, 0, 15.5228, 0, 10)
    ..cubicTo(0, 4.4772, 4.4766, 0, 10, 0)
    ..close()
    ..moveTo(10, 13)
    ..cubicTo(7.6055, 13, 5.6172, 14.0055, 4.2852, 15.5996)
    ..cubicTo(5.7383, 17.081, 7.7618, 18, 10, 18)
    ..cubicTo(12.2382, 18, 14.2617, 17.081, 15.7148, 15.5996)
    ..cubicTo(14.3828, 14.0055, 12.3945, 13, 10, 13)
    ..close()
    ..moveTo(10, 4.75)
    ..cubicTo(8.2045, 4.75, 6.75, 6.2051, 6.75, 8)
    ..cubicTo(6.75, 9.7949, 8.2045, 11.25, 10, 11.25)
    ..cubicTo(11.7955, 11.25, 13.25, 9.7949, 13.25, 8)
    ..cubicTo(13.25, 6.2051, 11.7955, 4.75, 10, 4.75)
    ..close();

  static final Path __clip0 = _buildClip0();

  static Path _buildClip0() {
    final path = Path();
    final clipShape0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));
    path.addPath(
      clipShape0,
      Offset.zero,
      matrix4: Float64List.fromList([
        -1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        20.0,
        0.0,
        0.0,
        1.0,
      ]),
    );
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _FigureCropCircle._viewBoxWidth;
    final scaleY = size.height / _FigureCropCircle._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_FigureCropCircle._viewBoxMinX,
        -_FigureCropCircle._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FigureCropCirclePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/flame.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Flame extends StatelessWidget with _DotdartSvgSizing {
  const _Flame({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Flame._svgWidth;

  @override
  double get svgNativeHeight => _Flame._svgHeight;

  @override
  double get svgViewBoxWidth => _Flame._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Flame._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _FlamePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _FlamePainter extends CustomPainter {
  _FlamePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.753823589,
    0.0,
    0.0,
    0.0,
    0.0,
    0.753823589,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.237972734,
    2.461764112,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(10.3072, 0.203)
    ..cubicTo(10.0501, 0.0048, 9.7114, -0.0525, 9.4035, 0.0499)
    ..cubicTo(9.0955, 0.1523, 8.8587, 0.4012, 8.7716, 0.7138)
    ..cubicTo(8.247, 2.5961, 7.1714, 3.6324, 5.7889, 4.9642)
    ..cubicTo(5.6026, 5.1436, 5.4108, 5.3284, 5.214, 5.5214)
    ..lineTo(5.2133, 5.5221)
    ..cubicTo(4.5988, 6.1258, 3.9645, 6.8097, 3.4435, 7.5847)
    ..cubicTo(1.8973, 9.8863, 1.5173, 12.4933, 2.6751, 15.1143)
    ..lineTo(2.6756, 15.1154)
    ..cubicTo(4.6055, 19.4708, 8.9256, 20.7255, 12.5345, 19.6215)
    ..cubicTo(16.1573, 18.5131, 19.1281, 15.0237, 18.5038, 9.9949)
    ..cubicTo(18.3109, 8.4286, 17.7814, 6.8091, 16.4728, 5.5333)
    ..cubicTo(16.2672, 5.333, 15.9837, 5.2333, 15.6981, 5.2608)
    ..cubicTo(15.4123, 5.2884, 15.1531, 5.4404, 14.9896, 5.6763)
    ..cubicTo(14.8529, 5.8738, 14.5416, 6.2542, 14.1683, 6.6942)
    ..cubicTo(14.1037, 5.9112, 13.9408, 5.158, 13.664, 4.4308)
    ..cubicTo(13.0568, 2.8355, 11.9379, 1.4603, 10.3072, 0.203)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Flame._viewBoxWidth;
    final scaleY = size.height / _Flame._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Flame._viewBoxMinX, -_Flame._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FlamePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/fork-knife.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ForkKnife extends StatelessWidget with _DotdartSvgSizing {
  const _ForkKnife({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ForkKnife._svgWidth;

  @override
  double get svgNativeHeight => _ForkKnife._svgHeight;

  @override
  double get svgViewBoxWidth => _ForkKnife._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ForkKnife._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ForkKnifePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ForkKnifePainter extends CustomPainter {
  _ForkKnifePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.620621329,
    0.0,
    0.0,
    0.0,
    0.0,
    0.620621329,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.803483913,
    3.793786705,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(18.5762, -0.0717)
    ..cubicTo(19.1921, -0.0717, 19.6913, 0.4276, 19.6913, 1.0434)
    ..lineTo(19.6913, 17.7698)
    ..cubicTo(19.6913, 19.0015, 18.6929, 20, 17.4611, 20)
    ..cubicTo(16.2295, 20, 15.231, 19.0015, 15.231, 17.7698)
    ..lineTo(15.231, 14.4245)
    ..lineTo(13.0008, 14.4245)
    ..cubicTo(12.3622, 14.4245, 11.854, 13.8892, 11.8872, 13.2514)
    ..cubicTo(12.1278, 8.6325, 13.287, 5.3801, 14.5939, 3.2483)
    ..cubicTo(15.2453, 2.1858, 15.9392, 1.3929, 16.5823, 0.8521)
    ..cubicTo(16.903, 0.5823, 17.2246, 0.364, 17.5353, 0.208)
    ..cubicTo(17.8259, 0.0621, 18.1905, -0.0717, 18.5762, -0.0717)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(8.8774, 0.0023)
    ..cubicTo(9.2197, -0.0277, 9.5204, 0.24, 9.5489, 0.6004)
    ..lineTo(10.099, 7.5492)
    ..cubicTo(10.1598, 8.3169, 9.8964, 9.0738, 9.3789, 9.6185)
    ..lineTo(8.3943, 10.655)
    ..cubicTo(7.9558, 11.1165, 7.45, 11.8207, 7.4157, 12.4772)
    ..lineTo(7.4157, 17.7778)
    ..cubicTo(7.4157, 19.0051, 6.4208, 20, 5.1935, 20)
    ..cubicTo(3.9662, 20, 2.9712, 19.0051, 2.9712, 17.7778)
    ..lineTo(2.9712, 12.4772)
    ..cubicTo(2.9712, 11.8012, 2.4541, 11.133, 2, 10.655)
    ..lineTo(1.0154, 9.6185)
    ..cubicTo(0.498, 9.0738, 0.2346, 8.3169, 0.2953, 7.5492)
    ..lineTo(0.8455, 0.6004)
    ..cubicTo(0.874, 0.24, 1.1746, -0.0277, 1.517, 0.0023)
    ..lineTo(1.5664, 0.0066)
    ..cubicTo(1.8888, 0.0349, 2.1368, 0.3186, 2.1368, 0.6591)
    ..lineTo(2.1368, 6.5733)
    ..cubicTo(2.1368, 6.9205, 2.4042, 7.202, 2.734, 7.202)
    ..cubicTo(3.0639, 7.202, 3.3312, 6.9205, 3.3312, 6.5733)
    ..lineTo(3.3312, 0.6548)
    ..cubicTo(3.3312, 0.2932, 3.6097, 0, 3.9532, 0)
    ..cubicTo(4.2967, 0, 4.5752, 0.2932, 4.5752, 0.6548)
    ..lineTo(4.5752, 6.5473)
    ..cubicTo(4.5752, 6.9088, 4.8537, 7.202, 5.1972, 7.202)
    ..cubicTo(5.5407, 7.202, 5.8192, 6.9088, 5.8192, 6.5473)
    ..lineTo(5.8192, 0.6548)
    ..cubicTo(5.8192, 0.2932, 6.0976, 0, 6.4412, 0)
    ..cubicTo(6.7846, 0, 7.0632, 0.2932, 7.0632, 0.6548)
    ..lineTo(7.0632, 6.5733)
    ..cubicTo(7.0632, 6.9205, 7.3305, 7.202, 7.6604, 7.202)
    ..cubicTo(7.9902, 7.202, 8.2576, 6.9205, 8.2576, 6.5733)
    ..lineTo(8.2576, 0.6591)
    ..cubicTo(8.2576, 0.3186, 8.5056, 0.0349, 8.8279, 0.0066)
    ..lineTo(8.8774, 0.0023)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ForkKnife._viewBoxWidth;
    final scaleY = size.height / _ForkKnife._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ForkKnife._viewBoxMinX, -_ForkKnife._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ForkKnifePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/gas-station.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _GasStation extends StatelessWidget with _DotdartSvgSizing {
  const _GasStation({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _GasStation._svgWidth;

  @override
  double get svgNativeHeight => _GasStation._svgHeight;

  @override
  double get svgViewBoxWidth => _GasStation._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _GasStation._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GasStationPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _GasStationPainter extends CustomPainter {
  _GasStationPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.682985528,
    0.0,
    0.0,
    0.0,
    0.0,
    0.682985528,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.170144717,
    3.170144717,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(1, 5)
    ..cubicTo(1, 2.7909, 2.7909, 1, 5, 1)
    ..lineTo(9, 1)
    ..cubicTo(11.2091, 1, 13, 2.7909, 13, 5)
    ..lineTo(13, 7)
    ..cubicTo(15.2091, 7, 17, 8.7909, 17, 11)
    ..lineTo(17, 13.5)
    ..cubicTo(17, 13.7761, 17.2239, 14, 17.5, 14)
    ..cubicTo(17.7761, 14, 18, 13.7761, 18, 13.5)
    ..lineTo(18, 7.2426)
    ..cubicTo(18, 6.7122, 17.7893, 6.2035, 17.4142, 5.8284)
    ..lineTo(16.2929, 4.7071)
    ..cubicTo(15.9024, 4.3166, 15.9024, 3.6834, 16.2929, 3.2929)
    ..cubicTo(16.6834, 2.9024, 17.3166, 2.9024, 17.7071, 3.2929)
    ..lineTo(18.8284, 4.4142)
    ..cubicTo(19.5786, 5.1644, 20, 6.1818, 20, 7.2426)
    ..lineTo(20, 13.5)
    ..cubicTo(20, 14.8807, 18.8807, 16, 17.5, 16)
    ..cubicTo(16.1193, 16, 15, 14.8807, 15, 13.5)
    ..lineTo(15, 11)
    ..cubicTo(15, 9.8954, 14.1046, 9, 13, 9)
    ..lineTo(13, 15.4291)
    ..cubicTo(13, 16.2967, 14, 17.1324, 14, 18)
    ..cubicTo(14, 18.5523, 13.5523, 19, 13, 19)
    ..lineTo(1, 19)
    ..cubicTo(0.4477, 19, 0, 18.5523, 0, 18)
    ..cubicTo(0, 17.1324, 1, 16.2967, 1, 15.4291)
    ..lineTo(1, 5)
    ..close()
    ..moveTo(8.3897, 2.9499)
    ..lineTo(5.6292, 2.9499)
    ..cubicTo(5.2773, 2.9499, 5.1013, 2.9499, 4.9536, 2.9691)
    ..cubicTo(3.9185, 3.1038, 3.1038, 3.9185, 2.9691, 4.9536)
    ..cubicTo(2.9499, 5.1013, 2.9499, 5.2773, 2.9499, 5.6292)
    ..cubicTo(2.9499, 5.9812, 2.9499, 6.1571, 2.9691, 6.3049)
    ..cubicTo(3.1038, 7.34, 3.9185, 8.1547, 4.9536, 8.2893)
    ..cubicTo(5.1013, 8.3085, 5.2773, 8.3085, 5.6292, 8.3085)
    ..lineTo(8.3897, 8.3085)
    ..cubicTo(8.7416, 8.3085, 8.9176, 8.3085, 9.0654, 8.2893)
    ..cubicTo(10.1004, 8.1547, 10.9151, 7.34, 11.0498, 6.3049)
    ..cubicTo(11.069, 6.1571, 11.069, 5.9812, 11.069, 5.6292)
    ..cubicTo(11.069, 5.2773, 11.069, 5.1013, 11.0498, 4.9536)
    ..cubicTo(10.9151, 3.9185, 10.1004, 3.1038, 9.0654, 2.9691)
    ..cubicTo(8.9176, 2.9499, 8.7416, 2.9499, 8.3897, 2.9499)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _GasStation._viewBoxWidth;
    final scaleY = size.height / _GasStation._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_GasStation._viewBoxMinX, -_GasStation._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GasStationPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/gear.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Gear extends StatelessWidget with _DotdartSvgSizing {
  const _Gear({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Gear._svgWidth;

  @override
  double get svgNativeHeight => _Gear._svgHeight;

  @override
  double get svgViewBoxWidth => _Gear._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Gear._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GearPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _GearPainter extends CustomPainter {
  _GearPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.806142311,
    0.0,
    0.0,
    0.0,
    0.0,
    0.806142311,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.93857689,
    1.93857689,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(7.7852, 1.1853)
    ..cubicTo(8.2789, 0.4448, 9.11, 0, 10, 0)
    ..cubicTo(10.89, 0, 11.7211, 0.4448, 12.2148, 1.1853)
    ..lineTo(12.5924, 1.7518)
    ..cubicTo(12.925, 2.2506, 13.5315, 2.4915, 14.1157, 2.3567)
    ..lineTo(14.4882, 2.2707)
    ..cubicTo(15.3962, 2.0612, 16.348, 2.3342, 17.0069, 2.9931)
    ..cubicTo(17.6658, 3.652, 17.9388, 4.6038, 17.7293, 5.5118)
    ..lineTo(17.6433, 5.8843)
    ..cubicTo(17.5085, 6.4685, 17.7494, 7.075, 18.2482, 7.4075)
    ..lineTo(18.8147, 7.7852)
    ..cubicTo(19.5552, 8.2789, 20, 9.11, 20, 10)
    ..cubicTo(20, 10.89, 19.5552, 11.7211, 18.8147, 12.2148)
    ..lineTo(18.2482, 12.5924)
    ..cubicTo(17.7494, 12.925, 17.5085, 13.5315, 17.6433, 14.1157)
    ..lineTo(17.7293, 14.4882)
    ..cubicTo(17.9388, 15.3962, 17.6658, 16.348, 17.0069, 17.0069)
    ..cubicTo(16.348, 17.6658, 15.3962, 17.9388, 14.4882, 17.7293)
    ..lineTo(14.1157, 17.6433)
    ..cubicTo(13.5315, 17.5085, 12.925, 17.7494, 12.5924, 18.2482)
    ..lineTo(12.2148, 18.8147)
    ..cubicTo(11.7211, 19.5552, 10.89, 20, 10, 20)
    ..cubicTo(9.11, 20, 8.2789, 19.5552, 7.7852, 18.8147)
    ..lineTo(7.4075, 18.2482)
    ..cubicTo(7.075, 17.7494, 6.4685, 17.5085, 5.8843, 17.6433)
    ..lineTo(5.5118, 17.7293)
    ..cubicTo(4.6038, 17.9388, 3.652, 17.6658, 2.9931, 17.0069)
    ..cubicTo(2.3342, 16.348, 2.0612, 15.3962, 2.2707, 14.4882)
    ..lineTo(2.3567, 14.1157)
    ..cubicTo(2.4915, 13.5315, 2.2506, 12.925, 1.7518, 12.5924)
    ..lineTo(1.1853, 12.2148)
    ..cubicTo(0.4448, 11.7211, 0, 10.89, 0, 10)
    ..cubicTo(0, 9.11, 0.4448, 8.2789, 1.1853, 7.7852)
    ..lineTo(1.7518, 7.4075)
    ..cubicTo(2.2506, 7.075, 2.4915, 6.4685, 2.3567, 5.8843)
    ..lineTo(2.2707, 5.5118)
    ..cubicTo(2.0612, 4.6038, 2.3342, 3.652, 2.9931, 2.9931)
    ..cubicTo(3.652, 2.3342, 4.6038, 2.0612, 5.5118, 2.2707)
    ..lineTo(5.8843, 2.3567)
    ..cubicTo(6.4685, 2.4915, 7.075, 2.2506, 7.4075, 1.7518)
    ..lineTo(7.7852, 1.1853)
    ..close()
    ..moveTo(6.5, 10)
    ..cubicTo(6.5, 8.067, 8.067, 6.5, 10, 6.5)
    ..cubicTo(11.933, 6.5, 13.5, 8.067, 13.5, 10)
    ..cubicTo(13.5, 11.933, 11.933, 13.5, 10, 13.5)
    ..cubicTo(8.067, 13.5, 6.5, 11.933, 6.5, 10)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Gear._viewBoxWidth;
    final scaleY = size.height / _Gear._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Gear._viewBoxMinX, -_Gear._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GearPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/gift.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Gift extends StatelessWidget with _DotdartSvgSizing {
  const _Gift({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Gift._svgWidth;

  @override
  double get svgNativeHeight => _Gift._svgHeight;

  @override
  double get svgViewBoxWidth => _Gift._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Gift._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GiftPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _GiftPainter extends CustomPainter {
  _GiftPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.826247507,
    0.0,
    0.0,
    0.0,
    0.0,
    0.826247507,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.047367747,
    1.737524932,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(10.1375, 14.3171)
    ..cubicTo(10.1375, 12.8999, 10.1375, 12.1913, 10.5777, 11.751)
    ..cubicTo(11.018, 11.3107, 11.7266, 11.3107, 13.1439, 11.3107)
    ..lineTo(16.3385, 11.3107)
    ..cubicTo(16.8284, 11.3107, 17.0734, 11.3107, 17.2738, 11.3673)
    ..cubicTo(17.7767, 11.5093, 18.1698, 11.9024, 18.3119, 12.4054)
    ..cubicTo(18.3684, 12.6058, 18.3685, 12.8507, 18.3685, 13.3407)
    ..cubicTo(18.3685, 14.948, 18.3684, 15.7517, 18.1829, 16.4089)
    ..cubicTo(17.7169, 18.0589, 16.4273, 19.3485, 14.7773, 19.8144)
    ..cubicTo(14.1201, 20, 13.3165, 20, 11.7091, 20)
    ..lineTo(10.1375, 20)
    ..lineTo(10.1375, 14.3171)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(9.0926, 14.3538)
    ..cubicTo(9.0926, 12.9193, 9.0926, 12.202, 8.6469, 11.7564)
    ..cubicTo(8.2013, 11.3107, 7.484, 11.3107, 6.0495, 11.3107)
    ..lineTo(2.8916, 11.3107)
    ..cubicTo(2.4016, 11.3107, 2.1566, 11.3107, 1.9563, 11.3673)
    ..cubicTo(1.4533, 11.5093, 1.0602, 11.9024, 0.9182, 12.4054)
    ..cubicTo(0.8616, 12.6058, 0.8616, 12.8507, 0.8616, 13.3407)
    ..cubicTo(0.8616, 14.948, 0.8616, 15.7517, 1.0472, 16.4089)
    ..cubicTo(1.5131, 18.0589, 2.8027, 19.3485, 4.4527, 19.8144)
    ..cubicTo(5.1099, 20, 5.9136, 20, 7.5209, 20)
    ..lineTo(9.0926, 20)
    ..lineTo(9.0926, 14.3538)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(13.4287, 0)
    ..cubicTo(15.1143, 0, 16.4812, 1.3663, 16.4814, 3.0518)
    ..cubicTo(16.4814, 4.0338, 16.1955, 4.9494, 15.7031, 5.7197)
    ..lineTo(16.9385, 5.7197)
    ..cubicTo(18.2039, 5.7197, 19.2303, 6.7453, 19.2305, 8.0107)
    ..cubicTo(19.2305, 9.2763, 18.204, 10.3027, 16.9385, 10.3027)
    ..lineTo(11.6406, 10.3027)
    ..cubicTo(10.8104, 10.3027, 10.1377, 9.629, 10.1377, 8.7988)
    ..lineTo(10.1377, 7.4063)
    ..cubicTo(10.1377, 6.494, 10.8618, 5.753, 11.7666, 5.7227)
    ..cubicTo(13.2414, 5.7225, 14.1924, 4.5267, 14.1924, 3.0518)
    ..cubicTo(14.1921, 2.6305, 13.85, 2.2891, 13.4287, 2.2891)
    ..cubicTo(11.9538, 2.2891, 10.1377, 3.485, 10.1377, 4.96)
    ..lineTo(10.1377, 5.8477)
    ..cubicTo(10.1377, 6.1008, 9.9318, 6.3057, 9.6787, 6.3057)
    ..lineTo(9.5508, 6.3057)
    ..cubicTo(9.2977, 6.3056, 9.0928, 6.1007, 9.0928, 5.8477)
    ..lineTo(9.0928, 4.96)
    ..cubicTo(9.0928, 3.485, 7.2728, 2.2891, 5.7979, 2.2891)
    ..cubicTo(5.3768, 2.2893, 5.0354, 2.6307, 5.0352, 3.0518)
    ..cubicTo(5.0352, 4.5267, 6.1726, 5.7226, 7.6475, 5.7227)
    ..cubicTo(8.4507, 5.7532, 9.0927, 6.412, 9.0928, 7.2227)
    ..lineTo(9.0928, 8.7988)
    ..cubicTo(9.0928, 9.6289, 8.4198, 10.3025, 7.5898, 10.3027)
    ..lineTo(2.291, 10.3027)
    ..cubicTo(1.0257, 10.3025, 0, 9.2761, 0, 8.0107)
    ..cubicTo(0.0001, 6.7455, 1.0258, 5.72, 2.291, 5.7197)
    ..lineTo(3.5234, 5.7197)
    ..cubicTo(3.0312, 4.9495, 2.7461, 4.0336, 2.7461, 3.0518)
    ..cubicTo(2.7463, 1.3664, 4.1125, 0.0003, 5.7979, 0)
    ..cubicTo(7.3318, 0, 8.7035, 0.6963, 9.6133, 1.79)
    ..cubicTo(10.5231, 0.6961, 11.8947, 0, 13.4287, 0)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Gift._viewBoxWidth;
    final scaleY = size.height / _Gift._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Gift._viewBoxMinX, -_Gift._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GiftPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/government-building.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _GovernmentBuilding extends StatelessWidget with _DotdartSvgSizing {
  const _GovernmentBuilding({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _GovernmentBuilding._svgWidth;

  @override
  double get svgNativeHeight => _GovernmentBuilding._svgHeight;

  @override
  double get svgViewBoxWidth => _GovernmentBuilding._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _GovernmentBuilding._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GovernmentBuildingPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _GovernmentBuildingPainter extends CustomPainter {
  _GovernmentBuildingPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.812176044,
    0.0,
    0.0,
    0.0,
    0.0,
    0.812176044,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.687885804,
    1.878239564,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(3.799, 17.8766)
    ..cubicTo(4.1435, 17.8644, 4.5411, 17.8739, 4.8886, 17.8739)
    ..lineTo(6.887, 17.8744)
    ..lineTo(12.3032, 17.8739)
    ..lineTo(15.4767, 17.8743)
    ..lineTo(16.5573, 17.8736)
    ..cubicTo(16.7171, 17.8737, 17.0115, 17.866, 17.1654, 17.884)
    ..cubicTo(17.3881, 17.9116, 17.5962, 18.0143, 17.7581, 18.1766)
    ..cubicTo(18.2504, 18.6627, 18.1526, 19.4985, 17.5677, 19.8531)
    ..cubicTo(17.3773, 19.9685, 17.2152, 19.9954, 16.9977, 19.9999)
    ..lineTo(7.7415, 19.9995)
    ..lineTo(4.9278, 19.9997)
    ..lineTo(4.0909, 19.9994)
    ..cubicTo(3.6706, 19.9991, 3.3606, 20.0297, 3.0297, 19.7005)
    ..cubicTo(2.8372, 19.5103, 2.7264, 19.2468, 2.7224, 18.9699)
    ..cubicTo(2.7118, 18.4144, 3.0865, 17.9611, 3.6107, 17.8864)
    ..cubicTo(3.6727, 17.8775, 3.7365, 17.8775, 3.799, 17.8766)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(6.029, 16.2396)
    ..cubicTo(6.029, 16.5301, 5.8194, 16.7077, 5.5609, 16.7077)
    ..lineTo(3.5607, 16.7077)
    ..cubicTo(3.3022, 16.7077, 3.0926, 16.4981, 3.0926, 16.2396)
    ..cubicTo(3.0926, 15.7836, 3.6373, 15.4019, 3.6373, 14.9459)
    ..lineTo(3.6373, 13.051)
    ..cubicTo(3.6373, 12.5796, 3.0508, 12.2008, 3.0508, 11.7294)
    ..cubicTo(3.0508, 11.4709, 3.2604, 11.2613, 3.5189, 11.2613)
    ..lineTo(5.518, 11.2613)
    ..cubicTo(5.7765, 11.2613, 5.986, 11.4709, 5.986, 11.7294)
    ..cubicTo(5.986, 12.1945, 5.4244, 12.5745, 5.4244, 13.0396)
    ..lineTo(5.4244, 14.8856)
    ..cubicTo(5.4244, 15.3749, 6.029, 15.7503, 6.029, 16.2396)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(9.7473, 16.2396)
    ..cubicTo(9.7473, 16.5301, 9.5378, 16.7077, 9.2793, 16.7077)
    ..lineTo(7.2791, 16.7077)
    ..cubicTo(7.0206, 16.7077, 6.811, 16.4981, 6.811, 16.2396)
    ..cubicTo(6.811, 15.7836, 7.3557, 15.4019, 7.3557, 14.9459)
    ..lineTo(7.3557, 13.051)
    ..cubicTo(7.3557, 12.5796, 6.7692, 12.2008, 6.7692, 11.7294)
    ..cubicTo(6.7692, 11.4709, 6.9788, 11.2613, 7.2373, 11.2613)
    ..lineTo(9.2364, 11.2613)
    ..cubicTo(9.4949, 11.2613, 9.7044, 11.4709, 9.7044, 11.7294)
    ..cubicTo(9.7044, 12.1945, 9.1428, 12.5745, 9.1428, 13.0396)
    ..lineTo(9.1428, 14.8856)
    ..cubicTo(9.1428, 15.3749, 9.7473, 15.7503, 9.7473, 16.2396)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(13.5508, 16.3057)
    ..cubicTo(13.5508, 16.6045, 13.3352, 16.7872, 13.0694, 16.7872)
    ..lineTo(11.012, 16.7872)
    ..cubicTo(10.7461, 16.7872, 10.5306, 16.5716, 10.5306, 16.3057)
    ..cubicTo(10.5306, 15.8367, 11.0908, 15.4441, 11.0908, 14.9751)
    ..lineTo(11.0908, 13.026)
    ..cubicTo(11.0908, 12.5411, 10.4876, 12.1515, 10.4876, 11.6666)
    ..cubicTo(10.4876, 11.4007, 10.7031, 11.1852, 10.969, 11.1852)
    ..lineTo(13.0252, 11.1852)
    ..cubicTo(13.2911, 11.1852, 13.5066, 11.4007, 13.5066, 11.6666)
    ..cubicTo(13.5066, 12.145, 12.9289, 12.5359, 12.9289, 13.0143)
    ..lineTo(12.9289, 14.9131)
    ..cubicTo(12.9289, 15.4163, 13.5508, 15.8025, 13.5508, 16.3057)
    ..close();

  static final Path __path4 = Path()
    ..moveTo(17.2692, 16.3057)
    ..cubicTo(17.2692, 16.6045, 17.0536, 16.7872, 16.7877, 16.7872)
    ..lineTo(14.7304, 16.7872)
    ..cubicTo(14.4645, 16.7872, 14.249, 16.5716, 14.249, 16.3057)
    ..cubicTo(14.249, 15.8367, 14.8092, 15.4441, 14.8092, 14.9751)
    ..lineTo(14.8092, 13.026)
    ..cubicTo(14.8092, 12.5411, 14.206, 12.1515, 14.206, 11.6666)
    ..cubicTo(14.206, 11.4007, 14.4215, 11.1852, 14.6874, 11.1852)
    ..lineTo(16.7436, 11.1852)
    ..cubicTo(17.0095, 11.1852, 17.225, 11.4007, 17.225, 11.6666)
    ..cubicTo(17.225, 12.145, 16.6473, 12.5359, 16.6473, 13.0143)
    ..lineTo(16.6473, 14.9131)
    ..cubicTo(16.6473, 15.4163, 17.2692, 15.8025, 17.2692, 16.3057)
    ..close();

  static final Path __path5 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(13.0016, 10.1078)
    ..lineTo(15.5908, 10.1078)
    ..lineTo(17.1459, 10.1078)
    ..cubicTo(17.5753, 10.1078, 17.9234, 9.7597, 17.9234, 9.3303)
    ..cubicTo(17.9234, 8.9009, 17.5753, 8.5528, 17.1459, 8.5528)
    ..cubicTo(17.0433, 8.5528, 16.9547, 8.4815, 16.9294, 8.382)
    ..cubicTo(16.2226, 5.5958, 13.8458, 3.477, 10.9257, 3.1541)
    ..lineTo(10.9257, 2.3326)
    ..lineTo(11.7032, 2.3326)
    ..cubicTo(12.1057, 2.3326, 12.437, 2.0267, 12.4769, 1.6348)
    ..lineTo(12.4807, 1.5551)
    ..lineTo(12.4807, 0.7775)
    ..cubicTo(12.4807, 0.375, 12.1749, 0.0437, 11.7829, 0.0038)
    ..lineTo(11.7032, 0)
    ..lineTo(10.1481, 0)
    ..cubicTo(9.7187, 0, 9.3706, 0.3481, 9.3706, 0.7775)
    ..lineTo(9.3706, 3.1541)
    ..cubicTo(6.4505, 3.477, 4.0737, 5.5958, 3.3668, 8.3821)
    ..cubicTo(3.3416, 8.4815, 3.253, 8.5528, 3.1504, 8.5528)
    ..cubicTo(2.721, 8.5528, 2.3729, 8.9009, 2.3729, 9.3303)
    ..cubicTo(2.3729, 9.7597, 2.721, 10.1078, 3.1504, 10.1078)
    ..lineTo(4.7055, 10.1078)
    ..lineTo(7.2947, 10.1078)
    ..lineTo(8.8498, 10.1078)
    ..lineTo(11.4465, 10.1078)
    ..lineTo(13.0016, 10.1078)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _GovernmentBuilding._viewBoxWidth;
    final scaleY = size.height / _GovernmentBuilding._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_GovernmentBuilding._viewBoxMinX,
        -_GovernmentBuilding._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path5, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GovernmentBuildingPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/graduate-cap.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _GraduateCap extends StatelessWidget with _DotdartSvgSizing {
  const _GraduateCap({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _GraduateCap._svgWidth;

  @override
  double get svgNativeHeight => _GraduateCap._svgHeight;

  @override
  double get svgViewBoxWidth => _GraduateCap._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _GraduateCap._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GraduateCapPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _GraduateCapPainter extends CustomPainter {
  _GraduateCapPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.82054839,
    0.0,
    0.0,
    0.0,
    0.0,
    0.82054839,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.794516102,
    1.999653199,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(9.7987, 2.0066)
    ..cubicTo(10.0895, 1.9859, 10.3816, 2.014, 10.6631, 2.0896)
    ..cubicTo(11.0562, 2.1937, 11.256, 2.3226, 11.6069, 2.5055)
    ..lineTo(12.573, 3.0175)
    ..lineTo(15.6953, 4.6709)
    ..lineTo(18.1801, 5.9867)
    ..lineTo(18.9946, 6.4179)
    ..cubicTo(19.3288, 6.5951, 19.6549, 6.7293, 19.8527, 7.0733)
    ..cubicTo(20.0003, 7.3354, 20.0388, 7.6451, 19.96, 7.9353)
    ..cubicTo(19.9046, 8.1346, 19.7946, 8.3145, 19.6423, 8.4545)
    ..cubicTo(19.5743, 8.5175, 19.485, 8.5878, 19.4045, 8.6341)
    ..cubicTo(18.7965, 8.9834, 18.158, 9.2839, 17.5491, 9.6305)
    ..cubicTo(18.1013, 10.4217, 18.0606, 11.2014, 18.0602, 12.0993)
    ..lineTo(18.0587, 13.4337)
    ..cubicTo(18.5925, 13.7797, 18.6131, 14.1002, 18.6126, 14.6934)
    ..lineTo(18.6116, 15.3251)
    ..cubicTo(18.6113, 15.6473, 18.6217, 15.9884, 18.6066, 16.3063)
    ..cubicTo(18.585, 16.6553, 18.4381, 16.9403, 18.1802, 17.1711)
    ..cubicTo(17.7492, 17.5568, 17.1639, 17.4901, 16.628, 17.4746)
    ..cubicTo(16.1116, 17.4597, 15.6332, 17.0281, 15.5545, 16.5163)
    ..cubicTo(15.5001, 16.1621, 15.5345, 15.7511, 15.5269, 15.3886)
    ..cubicTo(15.5536, 14.7132, 15.3667, 14.0416, 15.9549, 13.5671)
    ..lineTo(15.9549, 12.2018)
    ..cubicTo(15.9552, 11.9074, 15.971, 11.4791, 15.9269, 11.2058)
    ..cubicTo(15.919, 11.1766, 15.9108, 11.1475, 15.9022, 11.1183)
    ..cubicTo(15.8231, 10.8528, 15.6565, 10.6457, 15.4128, 10.5149)
    ..cubicTo(15.0875, 10.643, 14.649, 10.8482, 14.3252, 10.9905)
    ..lineTo(12.2414, 11.9028)
    ..lineTo(11.554, 12.204)
    ..cubicTo(11.1237, 12.3944, 10.8027, 12.5497, 10.3223, 12.6085)
    ..cubicTo(9.8727, 12.6657, 9.416, 12.6236, 8.9844, 12.485)
    ..cubicTo(8.6332, 12.3732, 8.0311, 12.0758, 7.6775, 11.9164)
    ..lineTo(5.1429, 10.7723)
    ..lineTo(1.7188, 9.2412)
    ..cubicTo(1.0155, 8.9211, 0.1059, 8.7145, 0.0076, 7.8143)
    ..cubicTo(-0.0289, 7.4881, 0.0671, 7.161, 0.274, 6.9062)
    ..cubicTo(0.3707, 6.7889, 0.4872, 6.6894, 0.6181, 6.6122)
    ..cubicTo(0.753, 6.5314, 0.9144, 6.4562, 1.0557, 6.3814)
    ..lineTo(1.9363, 5.9134)
    ..lineTo(4.9219, 4.3315)
    ..lineTo(7.6842, 2.8734)
    ..lineTo(8.3867, 2.5044)
    ..cubicTo(8.899, 2.232, 9.1994, 2.0627, 9.7987, 2.0066)
    ..close()
    ..moveTo(10.9176, 7.9631)
    ..cubicTo(11.2049, 8.0647, 11.5908, 8.2449, 11.8831, 8.3678)
    ..lineTo(13.8124, 9.1769)
    ..lineTo(15.0522, 9.6972)
    ..cubicTo(15.2595, 9.7844, 15.6177, 9.9234, 15.7982, 10.036)
    ..cubicTo(16.0143, 10.1714, 16.1878, 10.3652, 16.2988, 10.5948)
    ..cubicTo(16.3776, 10.7633, 16.4289, 10.9433, 16.4506, 11.1281)
    ..cubicTo(16.4726, 11.3029, 16.4641, 11.5961, 16.4641, 11.7795)
    ..lineTo(16.4636, 12.8871)
    ..lineTo(16.4633, 13.4478)
    ..lineTo(17.5639, 13.4471)
    ..cubicTo(17.5858, 13.0763, 17.5713, 12.6386, 17.5722, 12.2608)
    ..cubicTo(17.5743, 11.269, 17.6655, 10.3431, 16.9563, 9.5413)
    ..cubicTo(16.7914, 9.3552, 16.5973, 9.1972, 16.3816, 9.0733)
    ..cubicTo(16.083, 8.9005, 15.415, 8.6399, 15.0731, 8.4944)
    ..lineTo(12.8877, 7.5697)
    ..cubicTo(12.5, 7.4076, 11.9694, 7.2025, 11.603, 7.0264)
    ..cubicTo(11.5676, 6.6771, 11.4817, 6.4871, 11.2023, 6.2488)
    ..cubicTo(10.8788, 5.9731, 10.2857, 5.8228, 9.8633, 5.8582)
    ..cubicTo(9.1856, 5.8974, 8.2896, 6.2433, 8.3201, 7.0848)
    ..cubicTo(8.336, 7.5241, 8.7484, 7.8747, 9.1255, 8.0158)
    ..cubicTo(9.6181, 8.2132, 10.2271, 8.2292, 10.7276, 8.0336)
    ..cubicTo(10.7874, 8.0103, 10.857, 7.9824, 10.9176, 7.9631)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(3.717, 11.1674)
    ..cubicTo(3.8568, 11.1548, 4.0753, 11.2777, 4.2094, 11.3389)
    ..lineTo(4.8902, 11.6514)
    ..lineTo(7.3635, 12.7861)
    ..lineTo(8.1471, 13.1414)
    ..cubicTo(8.3809, 13.2468, 8.6138, 13.3591, 8.8602, 13.4304)
    ..cubicTo(9.229, 13.537, 9.6677, 13.5855, 10.0523, 13.5764)
    ..cubicTo(10.4192, 13.5695, 10.7832, 13.5073, 11.1316, 13.3917)
    ..cubicTo(11.4725, 13.2794, 11.9303, 13.0625, 12.2707, 12.9147)
    ..lineTo(14.0985, 12.1263)
    ..cubicTo(14.3596, 12.0129, 14.6331, 11.8681, 14.9013, 11.7773)
    ..cubicTo(14.9316, 11.7671, 14.966, 11.7578, 14.998, 11.7663)
    ..cubicTo(15.0369, 11.7764, 15.0708, 11.8007, 15.0886, 11.8374)
    ..cubicTo(15.1295, 11.9224, 15.1181, 13.9641, 15.095, 14.1894)
    ..cubicTo(15.0767, 14.3673, 15.0269, 14.5372, 14.9623, 14.7035)
    ..cubicTo(14.8413, 14.986, 14.6056, 15.2427, 14.3564, 15.4165)
    ..cubicTo(13.1306, 16.2716, 11.1899, 16.554, 9.7401, 16.5518)
    ..cubicTo(9.0654, 16.5466, 8.3921, 16.4898, 7.7261, 16.3817)
    ..cubicTo(6.4611, 16.176, 4.7776, 15.6453, 3.9735, 14.559)
    ..cubicTo(3.8288, 14.3634, 3.7093, 14.1094, 3.6593, 13.8701)
    ..cubicTo(3.6394, 13.7732, 3.6267, 13.675, 3.6212, 13.5762)
    ..cubicTo(3.6115, 13.3902, 3.6176, 13.1845, 3.6175, 12.9969)
    ..lineTo(3.6161, 12.0527)
    ..cubicTo(3.6161, 11.8094, 3.6071, 11.5162, 3.6246, 11.2716)
    ..cubicTo(3.6277, 11.2275, 3.6821, 11.1902, 3.717, 11.1674)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _GraduateCap._viewBoxWidth;
    final scaleY = size.height / _GraduateCap._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_GraduateCap._viewBoxMinX, -_GraduateCap._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GraduateCapPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/handshake.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Handshake extends StatelessWidget with _DotdartSvgSizing {
  const _Handshake({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Handshake._svgWidth;

  @override
  double get svgNativeHeight => _Handshake._svgHeight;

  @override
  double get svgViewBoxWidth => _Handshake._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Handshake._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _HandshakePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _HandshakePainter extends CustomPainter {
  _HandshakePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.819780031,
    0.0,
    0.0,
    0.0,
    0.0,
    0.819780031,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.802199693,
    1.494782181,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(0.6245, 6.2102)
    ..cubicTo(1.1632, 6.1641, 1.8015, 6.2197, 2.3467, 6.2001)
    ..cubicTo(2.6773, 6.1882, 3.2631, 6.1567, 3.5153, 6.3724)
    ..cubicTo(3.6321, 6.4723, 3.672, 7.0017, 3.7561, 7.1611)
    ..cubicTo(3.8597, 7.3875, 3.952, 7.5514, 4.1076, 7.7459)
    ..cubicTo(4.6769, 8.4454, 5.4975, 8.8942, 6.3937, 8.9963)
    ..cubicTo(7.1964, 9.0805, 7.8848, 8.9121, 8.5472, 8.44)
    ..cubicTo(8.8729, 8.1997, 9.1719, 7.9272, 9.4804, 7.6662)
    ..cubicTo(9.7588, 7.4307, 10.1135, 7.3837, 10.4054, 7.6274)
    ..cubicTo(10.7927, 7.9509, 11.1614, 8.2992, 11.5395, 8.6345)
    ..cubicTo(12.4282, 9.4236, 13.3123, 10.218, 14.1919, 11.0174)
    ..lineTo(15.3679, 12.0816)
    ..cubicTo(15.6101, 12.3001, 15.8886, 12.5118, 16.0879, 12.7705)
    ..cubicTo(16.2679, 13.004, 16.3478, 13.2847, 16.3031, 13.5769)
    ..cubicTo(16.2576, 13.8738, 16.0823, 14.143, 15.8368, 14.3141)
    ..cubicTo(15.6685, 14.4317, 15.4793, 14.4894, 15.2746, 14.4953)
    ..cubicTo(14.3549, 14.5218, 13.8207, 13.3504, 13.4644, 13.3344)
    ..cubicTo(13.4134, 13.3321, 13.4027, 13.3422, 13.3639, 13.3711)
    ..cubicTo(13.3092, 13.4955, 13.404, 13.5846, 13.4998, 13.6604)
    ..cubicTo(14.1075, 14.1413, 14.4651, 14.8774, 13.8307, 15.547)
    ..cubicTo(13.4071, 15.9148, 12.8985, 15.9798, 12.4223, 15.6423)
    ..cubicTo(12.2514, 15.5212, 12.0914, 15.3348, 11.9414, 15.1872)
    ..cubicTo(11.6729, 14.923, 11.4111, 14.6495, 11.1495, 14.3784)
    ..cubicTo(11.0661, 14.2911, 10.9631, 14.2272, 10.8532, 14.3144)
    ..cubicTo(10.8045, 14.5059, 11.1593, 14.7312, 11.2743, 14.9222)
    ..cubicTo(11.689, 15.6102, 11.2396, 16.4708, 10.4456, 16.5535)
    ..cubicTo(9.8975, 16.6109, 9.5079, 16.1237, 9.1656, 15.7557)
    ..cubicTo(8.9636, 15.5378, 8.7627, 15.3187, 8.5629, 15.0987)
    ..cubicTo(8.459, 14.9835, 8.2232, 14.6119, 8.0592, 14.8168)
    ..cubicTo(8.0426, 14.9598, 8.218, 15.0544, 8.2696, 15.2182)
    ..cubicTo(8.321, 15.3809, 8.3496, 15.4691, 8.3463, 15.6479)
    ..cubicTo(8.3434, 15.9406, 8.221, 16.2194, 8.0075, 16.4196)
    ..cubicTo(7.6423, 16.7675, 7.0907, 16.8297, 6.6776, 16.5417)
    ..cubicTo(6.4612, 16.3906, 6.203, 16.1014, 6.0169, 15.9073)
    ..cubicTo(5.7169, 15.5963, 5.4201, 15.2825, 5.1263, 14.9657)
    ..lineTo(2.4369, 12.0698)
    ..cubicTo(2.0505, 12.053, 1.6395, 12.0729, 1.2512, 12.0665)
    ..cubicTo(1.0749, 12.0635, 0.8396, 12.0773, 0.6713, 12.0508)
    ..cubicTo(0.5729, 12.0361, 0.4778, 12.0049, 0.3899, 11.9586)
    ..cubicTo(-0.091, 11.699, 0.0092, 11.0907, 0.0077, 10.6229)
    ..lineTo(0.0063, 9.0307)
    ..lineTo(0.007, 7.6676)
    ..cubicTo(0.0083, 7.0786, -0.1067, 6.3979, 0.6245, 6.2102)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(9.2076, 4.017)
    ..cubicTo(9.4904, 3.9808, 10.0849, 4.0153, 10.4027, 4.0051)
    ..cubicTo(10.7263, 3.9947, 11.2734, 4.0006, 11.578, 4.0602)
    ..cubicTo(11.931, 4.129, 12.2714, 4.2509, 12.5878, 4.4217)
    ..cubicTo(12.9558, 4.6229, 13.2301, 4.8656, 13.5583, 5.11)
    ..cubicTo(14.3143, 5.6727, 15.0623, 6.3512, 15.8969, 6.7893)
    ..cubicTo(16.1546, 6.601, 16.5385, 6.2207, 16.8592, 6.2148)
    ..cubicTo(17.6945, 6.1993, 18.5533, 6.1811, 19.3876, 6.2233)
    ..cubicTo(19.5005, 6.2417, 19.6074, 6.3145, 19.6933, 6.3782)
    ..cubicTo(20.084, 6.6669, 19.9902, 7.2376, 19.9894, 7.6801)
    ..lineTo(19.9875, 9.1192)
    ..lineTo(19.9913, 10.5695)
    ..cubicTo(19.9923, 10.941, 20.0592, 11.493, 19.805, 11.7894)
    ..cubicTo(19.662, 11.9563, 19.4485, 12.0565, 19.228, 12.0624)
    ..cubicTo(18.8086, 12.0739, 18.385, 12.0568, 17.9649, 12.0638)
    ..cubicTo(17.6766, 12.0555, 17.3598, 12.0856, 17.0749, 12.0476)
    ..cubicTo(16.8253, 12.0143, 16.5519, 11.7291, 16.3651, 11.5634)
    ..cubicTo(16.1457, 11.369, 15.9252, 11.1759, 15.7035, 10.9841)
    ..cubicTo(15.3728, 10.7082, 14.9984, 10.3604, 14.6687, 10.0714)
    ..lineTo(12.2828, 7.9622)
    ..lineTo(11.3117, 7.0916)
    ..cubicTo(10.9394, 6.7609, 10.6667, 6.4463, 10.1494, 6.3884)
    ..cubicTo(9.0758, 6.2683, 8.3977, 7.4627, 7.6373, 7.8808)
    ..cubicTo(6.8771, 8.2989, 6.1302, 8.2423, 5.4646, 7.7495)
    ..cubicTo(4.7989, 7.2568, 4.9783, 7.0156, 5.4212, 6.6444)
    ..cubicTo(5.864, 6.2732, 5.7646, 6.3593, 6.1381, 6.0452)
    ..cubicTo(6.5117, 5.7311, 6.6674, 5.5956, 7.331, 5.032)
    ..cubicTo(7.9946, 4.4684, 8.3039, 4.1302, 9.2076, 4.017)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Handshake._viewBoxWidth;
    final scaleY = size.height / _Handshake._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Handshake._viewBoxMinX, -_Handshake._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HandshakePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/helicopter-front.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _HelicopterFront extends StatelessWidget with _DotdartSvgSizing {
  const _HelicopterFront({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _HelicopterFront._svgWidth;

  @override
  double get svgNativeHeight => _HelicopterFront._svgHeight;

  @override
  double get svgViewBoxWidth => _HelicopterFront._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _HelicopterFront._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _HelicopterFrontPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _HelicopterFrontPainter extends CustomPainter {
  _HelicopterFrontPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.76916772,
    0.0,
    0.0,
    0.0,
    0.0,
    0.76916772,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.284286309,
    2.308322801,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.2168, 0)
    ..cubicTo(10.5343, 0, 10.7793, 0.2577, 10.7793, 0.5752)
    ..lineTo(17.8242, 0.5752)
    ..cubicTo(18.0358, 0.5752, 18.2078, 0.7465, 18.208, 0.958)
    ..cubicTo(18.2079, 1.1696, 18.0358, 1.3418, 17.8242, 1.3418)
    ..lineTo(10.543, 1.3418)
    ..lineTo(10.543, 3.0019)
    ..lineTo(11.2314, 3.0019)
    ..cubicTo(11.7329, 3.0021, 12.1395, 3.4087, 12.1396, 3.9102)
    ..lineTo(12.1396, 3.9394)
    ..lineTo(12.1533, 3.9414)
    ..cubicTo(14.6698, 4.3389, 16.6436, 6.3126, 17.041, 8.8291)
    ..cubicTo(17.1129, 9.2842, 17.1133, 9.8281, 17.1133, 10.915)
    ..lineTo(17.1133, 10.917)
    ..cubicTo(17.1133, 11.8486, 17.1133, 12.3153, 17.0518, 12.7051)
    ..cubicTo(16.7868, 14.3825, 15.7033, 15.7785, 14.2197, 16.4746)
    ..cubicTo(14.5564, 17.1864, 14.7489, 17.8873, 14.8018, 18.7363)
    ..cubicTo(14.875, 18.7364, 14.9483, 18.7366, 15.0215, 18.7373)
    ..cubicTo(15.2125, 18.7391, 15.4038, 18.7405, 15.5947, 18.7324)
    ..cubicTo(15.89, 18.7358, 15.9997, 18.5391, 16.1074, 18.3447)
    ..cubicTo(16.1738, 18.225, 16.2393, 18.1063, 16.3477, 18.0361)
    ..cubicTo(16.9185, 17.6671, 17.5403, 18.1986, 17.2656, 18.8525)
    ..cubicTo(16.9572, 19.5865, 16.38, 19.9473, 15.5928, 19.9922)
    ..cubicTo(15.4092, 20.0025, 15.2154, 19.9996, 15.0254, 19.9971)
    ..cubicTo(14.946, 19.996, 14.8673, 19.9952, 14.79, 19.9951)
    ..lineTo(13.3174, 19.9941)
    ..lineTo(12.4639, 19.9961)
    ..cubicTo(12.4213, 19.9962, 12.3774, 19.9971, 12.334, 19.998)
    ..cubicTo(12.0762, 20.004, 11.8099, 20.0101, 11.6123, 19.8242)
    ..cubicTo(11.4886, 19.7087, 11.4167, 19.548, 11.4131, 19.3789)
    ..cubicTo(11.409, 19.2118, 11.4626, 19.0537, 11.5811, 18.9336)
    ..cubicTo(11.6679, 18.8464, 11.7775, 18.7847, 11.8975, 18.7568)
    ..cubicTo(12.0156, 18.7287, 12.2515, 18.7322, 12.4209, 18.7344)
    ..cubicTo(12.4573, 18.7348, 12.4911, 18.7353, 12.5195, 18.7354)
    ..cubicTo(12.8459, 18.7383, 13.1727, 18.7383, 13.499, 18.7354)
    ..cubicTo(13.4746, 18.0846, 13.2783, 17.4455, 12.9746, 16.8691)
    ..lineTo(12.9365, 16.877)
    ..cubicTo(12.914, 16.8813, 12.8909, 16.8851, 12.8682, 16.8887)
    ..cubicTo(12.4784, 16.9502, 12.0116, 16.9512, 11.0801, 16.9512)
    ..lineTo(9.0098, 16.9512)
    ..cubicTo(8.0453, 16.9512, 7.5625, 16.9507, 7.1592, 16.8848)
    ..cubicTo(7.1462, 16.8826, 7.133, 16.8796, 7.1201, 16.877)
    ..cubicTo(7.11, 16.8749, 7.1, 16.8729, 7.0898, 16.8711)
    ..cubicTo(6.7868, 17.447, 6.5928, 18.0854, 6.5684, 18.7354)
    ..cubicTo(6.8945, 18.7383, 7.2207, 18.7383, 7.5469, 18.7354)
    ..cubicTo(7.5751, 18.7353, 7.6083, 18.7348, 7.6445, 18.7344)
    ..cubicTo(7.8139, 18.7322, 8.0505, 18.7288, 8.169, 18.7568)
    ..cubicTo(8.289, 18.7847, 8.3995, 18.8463, 8.4863, 18.9336)
    ..cubicTo(8.6047, 19.0537, 8.6583, 19.2118, 8.6543, 19.3789)
    ..cubicTo(8.6507, 19.5479, 8.5786, 19.7088, 8.4551, 19.8242)
    ..cubicTo(8.2574, 20.0102, 7.9904, 20.004, 7.7324, 19.998)
    ..cubicTo(7.6891, 19.9971, 7.646, 19.9962, 7.6035, 19.9961)
    ..lineTo(6.749, 19.9941)
    ..lineTo(5.2764, 19.9951)
    ..cubicTo(5.1992, 19.9952, 5.1203, 19.996, 5.041, 19.9971)
    ..cubicTo(4.851, 19.9996, 4.6572, 20.0025, 4.4736, 19.9922)
    ..cubicTo(3.6865, 19.9473, 3.1091, 19.5865, 2.8008, 18.8525)
    ..cubicTo(2.5261, 18.1986, 3.1489, 17.6668, 3.7197, 18.0361)
    ..cubicTo(3.828, 18.1063, 3.8937, 18.225, 3.96, 18.3447)
    ..cubicTo(4.0675, 18.5391, 4.1766, 18.7357, 4.4717, 18.7324)
    ..cubicTo(4.6627, 18.7405, 4.8548, 18.7391, 5.0459, 18.7373)
    ..cubicTo(5.1188, 18.7366, 5.1917, 18.7364, 5.2646, 18.7363)
    ..cubicTo(5.3174, 17.889, 5.5092, 17.1889, 5.8447, 16.4785)
    ..cubicTo(4.3646, 15.7876, 3.2809, 14.4011, 3.0078, 12.7324)
    ..cubicTo(2.9423, 12.3314, 2.9424, 11.8514, 2.9424, 10.8975)
    ..lineTo(2.9424, 10.8613)
    ..cubicTo(2.9424, 9.7604, 2.9418, 9.2063, 3.0176, 8.7432)
    ..cubicTo(3.4207, 6.2798, 5.3521, 4.3485, 7.8154, 3.9453)
    ..cubicTo(7.8506, 3.9396, 7.8872, 3.9346, 7.9238, 3.9297)
    ..lineTo(7.9238, 3.9102)
    ..cubicTo(7.924, 3.4087, 8.3306, 3.0021, 8.832, 3.0019)
    ..lineTo(9.457, 3.0019)
    ..lineTo(9.457, 1.3418)
    ..lineTo(2.2393, 1.3418)
    ..cubicTo(2.0277, 1.3417, 1.8565, 1.1695, 1.8564, 0.958)
    ..cubicTo(1.8566, 0.7465, 2.0278, 0.5753, 2.2393, 0.5752)
    ..lineTo(9.2012, 0.5752)
    ..cubicTo(9.2012, 0.2577, 9.4657, 0, 9.7832, 0)
    ..lineTo(10.2168, 0)
    ..close()
    ..moveTo(10.665, 12.3984)
    ..lineTo(13.584, 12.3984)
    ..cubicTo(14.7406, 12.3914, 15.6765, 11.4555, 15.6836, 10.2988)
    ..lineTo(15.6836, 10.2012)
    ..cubicTo(15.6671, 7.5084, 13.4886, 5.329, 10.7959, 5.3125)
    ..lineTo(10.665, 5.3125)
    ..lineTo(10.665, 12.3984)
    ..close()
    ..moveTo(9.2354, 5.3125)
    ..cubicTo(6.5426, 5.329, 4.3632, 7.5084, 4.3467, 10.2012)
    ..lineTo(4.3467, 10.2988)
    ..cubicTo(4.3538, 11.4553, 5.2898, 12.3911, 6.4463, 12.3984)
    ..lineTo(9.3926, 12.3984)
    ..lineTo(9.3926, 5.3125)
    ..lineTo(9.2354, 5.3125)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _HelicopterFront._viewBoxWidth;
    final scaleY = size.height / _HelicopterFront._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_HelicopterFront._viewBoxMinX,
        -_HelicopterFront._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HelicopterFrontPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/hookah.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Hookah extends StatelessWidget with _DotdartSvgSizing {
  const _Hookah({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Hookah._svgWidth;

  @override
  double get svgNativeHeight => _Hookah._svgHeight;

  @override
  double get svgViewBoxWidth => _Hookah._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Hookah._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _HookahPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _HookahPainter extends CustomPainter {
  _HookahPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.804749581,
    0.0,
    0.0,
    0.0,
    0.0,
    0.804749581,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.040523673,
    1.952504188,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(10.0125, 11.0867)
    ..cubicTo(9.9676, 10.7075, 10.2443, 10.3843, 10.6261, 10.3841)
    ..lineTo(12.6294, 10.3832)
    ..lineTo(13.6211, 10.3827)
    ..cubicTo(13.9567, 10.3828, 14.1957, 10.6559, 14.1465, 10.9879)
    ..cubicTo(14.1221, 11.1529, 14.1039, 11.3189, 14.1144, 11.4821)
    ..cubicTo(14.1338, 11.9826, 14.3894, 12.229, 14.774, 12.5044)
    ..cubicTo(15.4677, 13.0011, 16.0618, 13.6546, 16.2917, 14.4946)
    ..cubicTo(16.5468, 15.4274, 16.3181, 16.4033, 15.6449, 17.1056)
    ..cubicTo(15.2598, 17.5073, 14.7855, 17.8118, 14.2158, 17.8304)
    ..lineTo(11.1699, 17.8308)
    ..lineTo(10.3297, 17.8318)
    ..cubicTo(10.0969, 17.832, 9.7732, 17.8503, 9.5536, 17.792)
    ..cubicTo(8.583, 17.5343, 7.8227, 16.5229, 7.7481, 15.5447)
    ..cubicTo(7.6615, 14.4107, 8.1858, 13.477, 9.0304, 12.7713)
    ..cubicTo(9.283, 12.5601, 9.5658, 12.3723, 9.789, 12.1322)
    ..cubicTo(10.0506, 11.8385, 10.0573, 11.4648, 10.0125, 11.0867)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(11.6049, 4.8074)
    ..cubicTo(11.6057, 4.4696, 11.8736, 4.1968, 12.2114, 4.1983)
    ..cubicTo(12.5554, 4.1999, 12.8386, 4.476, 12.8374, 4.8201)
    ..cubicTo(12.8367, 5.0282, 12.8347, 5.2366, 12.8344, 5.4372)
    ..lineTo(12.8349, 6.306)
    ..cubicTo(12.8348, 6.6716, 12.8278, 7.0588, 12.8401, 7.4225)
    ..cubicTo(13.4207, 7.7189, 13.476, 7.9773, 13.4757, 8.5839)
    ..cubicTo(13.4749, 8.8925, 13.2231, 9.1403, 12.9144, 9.1403)
    ..lineTo(10.2095, 9.1402)
    ..lineTo(9.4184, 8.2768)
    ..cubicTo(8.9733, 8.1939, 8.7702, 7.9077, 8.7718, 7.4666)
    ..cubicTo(8.6185, 7.2828, 8.416, 7.0833, 8.2512, 6.9086)
    ..cubicTo(7.7288, 6.355, 7.19, 5.9225, 6.3879, 5.9176)
    ..cubicTo(5.2564, 5.9107, 4.5729, 6.7583, 4.2702, 7.7603)
    ..cubicTo(3.9854, 8.6955, 4.0248, 9.7319, 4.3129, 10.6626)
    ..cubicTo(4.5807, 11.5278, 4.8898, 12.4174, 4.8442, 13.3403)
    ..cubicTo(4.8186, 13.7987, 4.7284, 14.2513, 4.5765, 14.6846)
    ..cubicTo(4.391, 15.2308, 4.0777, 15.8143, 4.079, 16.3997)
    ..cubicTo(4.0799, 16.8106, 4.2665, 17.1734, 4.5535, 17.4587)
    ..cubicTo(6.0886, 18.985, 10.3661, 18.8047, 12.455, 18.7946)
    ..cubicTo(12.7341, 18.3714, 13.215, 18.3731, 13.5646, 18.7121)
    ..cubicTo(13.7866, 18.7215, 14.0208, 18.7155, 14.2441, 18.716)
    ..lineTo(15.5063, 18.7162)
    ..cubicTo(15.7567, 18.7157, 16.014, 18.709, 16.2639, 18.7208)
    ..cubicTo(16.5987, 18.7366, 16.8196, 18.9891, 16.7773, 19.3261)
    ..cubicTo(16.7152, 19.3753, 16.6962, 19.593, 16.5176, 19.671)
    ..cubicTo(16.2853, 19.7722, 16.101, 19.746, 15.8572, 19.7451)
    ..lineTo(14.985, 19.7333)
    ..cubicTo(14.5356, 19.7253, 14.0788, 19.7593, 13.63, 19.7361)
    ..cubicTo(13.5834, 19.7337, 13.5295, 19.7828, 13.4947, 19.8085)
    ..cubicTo(13.2415, 20.0051, 13.0825, 20.0548, 12.7783, 19.9368)
    ..cubicTo(12.5989, 19.8671, 12.6048, 19.8028, 12.4688, 19.7405)
    ..cubicTo(12.4428, 19.7285, 12.1659, 19.731, 12.1144, 19.731)
    ..lineTo(11.4374, 19.7325)
    ..cubicTo(10.8367, 19.7334, 10.2344, 19.7244, 9.6337, 19.7447)
    ..cubicTo(9.5658, 19.747, 9.5004, 19.7416, 9.4329, 19.7517)
    ..cubicTo(9.3172, 19.7638, 8.9794, 19.7451, 8.8438, 19.7369)
    ..cubicTo(7.1125, 19.6312, 4.9062, 19.4128, 3.6598, 18.0631)
    ..cubicTo(2.9223, 17.2606, 2.8479, 16.2357, 3.2281, 15.2529)
    ..cubicTo(3.42, 14.7351, 3.6557, 14.2639, 3.7382, 13.7123)
    ..cubicTo(3.8643, 12.8689, 3.627, 12.0903, 3.3743, 11.2971)
    ..cubicTo(3.1138, 10.4793, 2.9543, 9.6049, 3.0117, 8.7446)
    ..cubicTo(3.0866, 7.6212, 3.5125, 6.4131, 4.3737, 5.6517)
    ..cubicTo(4.9703, 5.1134, 5.7587, 4.8381, 6.5607, 4.8879)
    ..cubicTo(7.8916, 4.9704, 8.7077, 5.8106, 9.5328, 6.7457)
    ..cubicTo(9.9727, 6.761, 10.2889, 6.9707, 10.3448, 7.4282)
    ..cubicTo(10.6409, 7.7163, 10.9153, 8.0579, 11.2066, 8.3397)
    ..cubicTo(11.2106, 8.2379, 11.21, 8.1637, 11.2052, 8.0619)
    ..lineTo(11.2052, 7.9774)
    ..cubicTo(11.2052, 7.8607, 11.245, 7.7204, 11.3131, 7.6256)
    ..cubicTo(11.4523, 7.4317, 11.6052, 7.2669, 11.6081, 7.0282)
    ..cubicTo(11.6166, 6.3381, 11.6053, 6.1976, 11.6062, 5.2905)
    ..cubicTo(11.6049, 5.1295, 11.6045, 4.9684, 11.6049, 4.8074)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(11.2103, 0.0123)
    ..cubicTo(11.5555, -0.0114, 12.0364, 0.0143, 12.3948, 0.0069)
    ..cubicTo(12.5999, 0.0027, 13.0963, -0.0079, 13.2798, 0.0105)
    ..cubicTo(13.4826, 0.0307, 13.6685, 0.1323, 13.7953, 0.2919)
    ..cubicTo(13.913, 0.44, 13.9734, 0.6174, 13.9812, 0.8055)
    ..cubicTo(14.0099, 1.4857, 13.8072, 2.0355, 13.292, 2.4678)
    ..cubicTo(13.2595, 2.4951, 13.24, 2.5351, 13.2402, 2.5776)
    ..cubicTo(13.2404, 2.6517, 13.299, 2.7125, 13.3731, 2.7145)
    ..cubicTo(14.0348, 2.7322, 14.7137, 2.6925, 15.3742, 2.7228)
    ..cubicTo(15.4278, 2.7253, 15.5004, 2.7614, 15.5399, 2.7975)
    ..cubicTo(15.7661, 3.0045, 15.5967, 3.3159, 15.4115, 3.4833)
    ..cubicTo(14.9972, 3.8847, 14.6001, 3.8737, 14.0642, 3.8722)
    ..lineTo(13.3068, 3.8719)
    ..lineTo(10.9676, 3.8716)
    ..cubicTo(10.6177, 3.8719, 10.2669, 3.8774, 9.9109, 3.8679)
    ..cubicTo(9.4879, 3.8565, 8.8654, 3.5141, 8.8293, 3.0419)
    ..cubicTo(8.8164, 2.8728, 8.9413, 2.7366, 9.1091, 2.7239)
    ..cubicTo(9.3354, 2.7069, 9.5733, 2.7142, 9.8024, 2.7143)
    ..lineTo(11.0816, 2.7129)
    ..cubicTo(11.1598, 2.7128, 11.2234, 2.6498, 11.2242, 2.5716)
    ..cubicTo(11.2247, 2.5274, 11.2045, 2.4857, 11.1706, 2.4575)
    ..cubicTo(10.813, 2.159, 10.6332, 1.8484, 10.5457, 1.374)
    ..cubicTo(10.4353, 0.7752, 10.504, 0.1327, 11.2103, 0.0123)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(9.8062, 9.3108)
    ..cubicTo(10.1231, 9.3025, 10.4563, 9.3098, 10.7746, 9.31)
    ..lineTo(12.5408, 9.3102)
    ..lineTo(13.6752, 9.3082)
    ..cubicTo(13.8873, 9.3078, 14.3696, 9.2722, 14.5409, 9.3833)
    ..cubicTo(14.8452, 9.5807, 14.7505, 10.0945, 14.3501, 10.1427)
    ..cubicTo(14.0441, 10.1579, 13.7011, 10.1492, 13.3908, 10.1494)
    ..lineTo(11.777, 10.15)
    ..lineTo(10.517, 10.1493)
    ..cubicTo(10.3005, 10.1491, 10.0833, 10.1457, 9.8672, 10.1455)
    ..cubicTo(9.3239, 10.145, 9.2366, 9.4037, 9.8062, 9.3108)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Hookah._viewBoxWidth;
    final scaleY = size.height / _Hookah._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Hookah._viewBoxMinX, -_Hookah._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HookahPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/hot-coffee-cup.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _HotCoffeeCup extends StatelessWidget with _DotdartSvgSizing {
  const _HotCoffeeCup({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _HotCoffeeCup._svgWidth;

  @override
  double get svgNativeHeight => _HotCoffeeCup._svgHeight;

  @override
  double get svgViewBoxWidth => _HotCoffeeCup._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _HotCoffeeCup._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _HotCoffeeCupPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _HotCoffeeCupPainter extends CustomPainter {
  _HotCoffeeCupPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.778184717,
    0.0,
    0.0,
    0.0,
    0.0,
    0.778184717,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.218152831,
    2.218152831,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(15.4133, 6.7324)
    ..cubicTo(15.9155, 6.7324, 16.6708, 6.7049, 17.137, 6.79)
    ..cubicTo(17.8315, 6.9167, 18.4719, 7.2515, 18.9719, 7.75)
    ..cubicTo(19.6301, 8.4026, 20.0005, 9.2918, 20.0002, 10.2187)
    ..cubicTo(20.0037, 11.1485, 19.6348, 12.0413, 18.9758, 12.6972)
    ..cubicTo(18.3961, 13.2766, 17.6303, 13.6325, 16.8137, 13.7031)
    ..cubicTo(16.506, 13.7295, 16.074, 13.7163, 15.7571, 13.7158)
    ..cubicTo(15.5065, 14.7985, 14.9182, 15.876, 14.2317, 16.7422)
    ..cubicTo(14.1525, 16.8386, 14.0719, 16.9338, 13.9895, 17.0273)
    ..cubicTo(12.5872, 18.6057, 10.6156, 19.5631, 8.5081, 19.6884)
    ..cubicTo(6.3868, 19.8189, 4.3014, 19.0958, 2.7161, 17.6806)
    ..cubicTo(1.1326, 16.2731, 0.2791, 14.2803, 0.0569, 12.1767)
    ..cubicTo(-0.0162, 11.485, -0.0172, 10.7513, 0.0442, 10.0693)
    ..cubicTo(0.2277, 8.0318, 0.9308, 6.7533, 2.8713, 6.7353)
    ..cubicTo(2.9263, 6.7348, 2.9814, 6.7328, 3.0364, 6.7324)
    ..lineTo(15.4133, 6.7324)
    ..close()
    ..moveTo(16.009, 8.7285)
    ..lineTo(16.009, 11.7197)
    ..cubicTo(16.6165, 11.7211, 17.0867, 11.763, 17.5627, 11.2871)
    ..cubicTo(17.5662, 11.2836, 17.5701, 11.2799, 17.5735, 11.2763)
    ..cubicTo(17.8581, 10.9805, 18.012, 10.612, 18.0051, 10.1992)
    ..cubicTo(17.9983, 9.8008, 17.8326, 9.4214, 17.5452, 9.1455)
    ..cubicTo(17.0298, 8.6507, 16.668, 8.7264, 16.009, 8.7285)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(4.1122, 0.9732)
    ..cubicTo(4.2614, 0.5014, 4.7469, 0.2106, 5.2416, 0.3136)
    ..cubicTo(5.7362, 0.4168, 6.065, 0.8769, 6.0138, 1.3687)
    ..lineTo(5.9976, 1.4679)
    ..cubicTo(5.8414, 2.2179, 5.8222, 2.9361, 5.9394, 3.6782)
    ..lineTo(5.9976, 3.9975)
    ..lineTo(6.0138, 4.0966)
    ..cubicTo(6.0649, 4.5884, 5.7361, 5.0486, 5.2416, 5.1517)
    ..cubicTo(4.747, 5.2547, 4.2615, 4.9637, 4.1122, 4.4922)
    ..lineTo(4.0874, 4.3959)
    ..lineTo(4.0102, 3.9775)
    ..cubicTo(3.8572, 3.004, 3.8834, 2.0493, 4.0874, 1.0694)
    ..lineTo(4.1122, 0.9732)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(7.4885, 0.9732)
    ..cubicTo(7.6378, 0.5014, 8.1232, 0.2106, 8.618, 0.3136)
    ..cubicTo(9.1125, 0.4168, 9.4413, 0.8769, 9.3901, 1.3687)
    ..lineTo(9.3739, 1.4679)
    ..cubicTo(9.2177, 2.2179, 9.1985, 2.9361, 9.3157, 3.6782)
    ..lineTo(9.3739, 3.9975)
    ..lineTo(9.3901, 4.0966)
    ..cubicTo(9.4412, 4.5884, 9.1124, 5.0486, 8.618, 5.1517)
    ..cubicTo(8.1233, 5.2547, 7.6379, 4.9637, 7.4885, 4.4922)
    ..lineTo(7.4637, 4.3959)
    ..lineTo(7.3865, 3.9775)
    ..cubicTo(7.2335, 3.004, 7.2598, 2.0493, 7.4637, 1.0694)
    ..lineTo(7.4885, 0.9732)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(10.8649, 0.9732)
    ..cubicTo(11.0141, 0.5014, 11.4996, 0.2106, 11.9943, 0.3136)
    ..cubicTo(12.4888, 0.4168, 12.8177, 0.8769, 12.7664, 1.3687)
    ..lineTo(12.7502, 1.4679)
    ..cubicTo(12.5941, 2.2179, 12.5748, 2.9361, 12.692, 3.6782)
    ..lineTo(12.7502, 3.9975)
    ..lineTo(12.7664, 4.0966)
    ..cubicTo(12.8176, 4.5884, 12.4887, 5.0486, 11.9943, 5.1517)
    ..cubicTo(11.4996, 5.2547, 11.0142, 4.9637, 10.8649, 4.4922)
    ..lineTo(10.8401, 4.3959)
    ..lineTo(10.7629, 3.9775)
    ..cubicTo(10.6098, 3.004, 10.6361, 2.0493, 10.8401, 1.0694)
    ..lineTo(10.8649, 0.9732)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _HotCoffeeCup._viewBoxWidth;
    final scaleY = size.height / _HotCoffeeCup._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_HotCoffeeCup._viewBoxMinX, -_HotCoffeeCup._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HotCoffeeCupPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/info.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Info extends StatelessWidget with _DotdartSvgSizing {
  const _Info({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Info._svgWidth;

  @override
  double get svgNativeHeight => _Info._svgHeight;

  @override
  double get svgViewBoxWidth => _Info._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Info._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _InfoPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _InfoPainter extends CustomPainter {
  _InfoPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.567118292,
    0.0,
    0.0,
    0.0,
    0.0,
    0.567118292,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    4.479457878,
    4.328817082,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(8.5005, 6.1674)
    ..cubicTo(9.9308, 6.1674, 11.3517, 7.5629, 11.3517, 8.9933)
    ..lineTo(11.3517, 16.3767)
    ..cubicTo(11.3517, 16.9475, 11.8144, 17.4102, 12.3852, 17.4102)
    ..cubicTo(13.1004, 17.4102, 13.6801, 17.9899, 13.6801, 18.7051)
    ..cubicTo(13.6801, 19.4203, 13.1004, 20, 12.3852, 20)
    ..lineTo(7.2056, 20)
    ..cubicTo(6.4904, 20, 5.9107, 19.4203, 5.9107, 18.7051)
    ..cubicTo(5.9107, 17.9899, 6.4904, 17.4102, 7.2056, 17.4102)
    ..cubicTo(7.7868, 17.4102, 8.2581, 16.939, 8.2581, 16.3577)
    ..lineTo(8.2581, 10.2736)
    ..cubicTo(8.2581, 9.6923, 7.7868, 9.2211, 7.2056, 9.2211)
    ..cubicTo(6.4904, 9.2211, 5.8031, 8.6024, 5.8031, 7.7042)
    ..cubicTo(5.8031, 6.806, 6.4904, 6.1674, 7.2056, 6.1674)
    ..lineTo(8.5005, 6.1674)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(9.7954, 0)
    ..cubicTo(10.8681, 0, 11.7377, 0.8696, 11.7377, 1.9424)
    ..cubicTo(11.7377, 3.0151, 10.8681, 3.8847, 9.7954, 3.8847)
    ..cubicTo(8.7227, 3.8847, 7.853, 3.0151, 7.853, 1.9424)
    ..cubicTo(7.853, 0.8696, 8.7227, 0, 9.7954, 0)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Info._viewBoxWidth;
    final scaleY = size.height / _Info._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Info._viewBoxMinX, -_Info._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InfoPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/letters.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Letters extends StatelessWidget with _DotdartSvgSizing {
  const _Letters({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Letters._svgWidth;

  @override
  double get svgNativeHeight => _Letters._svgHeight;

  @override
  double get svgViewBoxWidth => _Letters._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Letters._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _LettersPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _LettersPainter extends CustomPainter {
  _LettersPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.701405735,
    0.0,
    0.0,
    0.0,
    0.0,
    0.701405735,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.985942649,
    2.985942649,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(12.6846, 11.7939)
    ..cubicTo(12.9684, 11.794, 13.2081, 11.8369, 13.4033, 11.9238)
    ..cubicTo(13.6005, 12.0109, 13.7503, 12.1618, 13.8516, 12.375)
    ..cubicTo(13.9544, 12.5881, 14.0059, 12.8848, 14.0059, 13.2646)
    ..cubicTo(14.0058, 13.6447, 13.9548, 13.9411, 13.8535, 14.1543)
    ..cubicTo(13.7541, 14.3674, 13.6088, 14.5174, 13.417, 14.6045)
    ..cubicTo(13.2269, 14.6915, 12.9966, 14.7354, 12.7266, 14.7354)
    ..lineTo(12.3867, 14.7354)
    ..cubicTo(12.2626, 14.7352, 12.1623, 14.6348, 12.1621, 14.5107)
    ..lineTo(12.1621, 12.0186)
    ..cubicTo(12.1622, 11.8944, 12.2626, 11.794, 12.3867, 11.7939)
    ..lineTo(12.6846, 11.7939)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(6.9814, 5.8301)
    ..cubicTo(7.0099, 5.7358, 7.1434, 5.7351, 7.1729, 5.8291)
    ..lineTo(7.6279, 7.2842)
    ..lineTo(6.542, 7.2842)
    ..lineTo(6.9814, 5.8301)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(12.9277, 7.1064)
    ..cubicTo(13.0757, 7.1065, 13.2022, 7.1296, 13.3066, 7.1748)
    ..cubicTo(13.4127, 7.2201, 13.4944, 7.2861, 13.5518, 7.3731)
    ..cubicTo(13.6092, 7.46, 13.6376, 7.5662, 13.6377, 7.6914)
    ..cubicTo(13.6377, 7.8708, 13.577, 8.0073, 13.4551, 8.0996)
    ..cubicTo(13.3332, 8.1901, 13.1499, 8.2354, 12.9062, 8.2354)
    ..lineTo(12.3623, 8.2354)
    ..cubicTo(12.2879, 8.2353, 12.2278, 8.1749, 12.2275, 8.1006)
    ..lineTo(12.2275, 7.2412)
    ..cubicTo(12.2278, 7.1669, 12.2879, 7.1065, 12.3623, 7.1064)
    ..lineTo(12.9277, 7.1064)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(12.8438, 5.1836)
    ..cubicTo(13.0249, 5.1836, 13.1745, 5.2286, 13.293, 5.3174)
    ..cubicTo(13.4114, 5.4045, 13.4707, 5.5308, 13.4707, 5.6963)
    ..cubicTo(13.4706, 5.8058, 13.4433, 5.8991, 13.3877, 5.9756)
    ..cubicTo(13.3338, 6.0504, 13.2575, 6.1074, 13.1602, 6.1475)
    ..cubicTo(13.0627, 6.1875, 12.9503, 6.208, 12.8232, 6.208)
    ..lineTo(12.3623, 6.208)
    ..cubicTo(12.2879, 6.208, 12.2277, 6.1477, 12.2275, 6.0732)
    ..lineTo(12.2275, 5.3193)
    ..cubicTo(12.2275, 5.2448, 12.2878, 5.1836, 12.3623, 5.1836)
    ..lineTo(12.8438, 5.1836)
    ..close();

  static final Path __path4 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.4854, 0)
    ..cubicTo(13.8156, 0, 15.4809, 0.0003, 16.7529, 0.6484)
    ..cubicTo(17.8718, 1.2186, 18.7815, 2.1282, 19.3516, 3.2471)
    ..cubicTo(19.9997, 4.5191, 20, 6.1843, 20, 9.5146)
    ..lineTo(20, 10.4854)
    ..cubicTo(20, 13.8156, 19.9997, 15.4809, 19.3516, 16.7529)
    ..cubicTo(18.7814, 17.8718, 17.8718, 18.7814, 16.7529, 19.3516)
    ..cubicTo(15.4809, 19.9997, 13.8156, 20, 10.4854, 20)
    ..lineTo(9.5146, 20)
    ..cubicTo(6.1843, 20, 4.5191, 19.9997, 3.2471, 19.3516)
    ..cubicTo(2.1282, 18.7815, 1.2186, 17.8718, 0.6484, 16.7529)
    ..cubicTo(0.0003, 15.4809, 0, 13.8156, 0, 10.4854)
    ..lineTo(0, 9.5146)
    ..cubicTo(0, 6.1842, 0.0003, 4.5191, 0.6484, 3.2471)
    ..cubicTo(1.2186, 2.1281, 2.1281, 1.2186, 3.2471, 0.6484)
    ..cubicTo(4.5191, 0.0003, 6.1842, 0, 9.5146, 0)
    ..lineTo(10.4854, 0)
    ..close()
    ..moveTo(7.1484, 10.3936)
    ..cubicTo(6.6542, 10.3936, 6.2058, 10.5021, 5.8047, 10.7188)
    ..cubicTo(5.4038, 10.9336, 5.0849, 11.2512, 4.8486, 11.6719)
    ..cubicTo(4.6123, 12.0908, 4.4942, 12.6065, 4.4941, 13.2188)
    ..cubicTo(4.4941, 13.8276, 4.6098, 14.3429, 4.8408, 14.7637)
    ..cubicTo(5.0736, 15.1844, 5.3898, 15.5031, 5.7891, 15.7197)
    ..cubicTo(6.1901, 15.9364, 6.6435, 16.0449, 7.1484, 16.0449)
    ..cubicTo(7.5511, 16.0449, 7.9047, 15.9829, 8.209, 15.8594)
    ..cubicTo(8.5134, 15.7358, 8.7687, 15.5724, 8.9746, 15.3701)
    ..cubicTo(9.1822, 15.1661, 9.3423, 14.9439, 9.4551, 14.7041)
    ..cubicTo(9.5371, 14.5283, 9.5942, 14.3546, 9.626, 14.1836)
    ..cubicTo(9.6448, 14.0812, 9.5622, 13.992, 9.458, 13.9912)
    ..lineTo(8.292, 13.9834)
    ..cubicTo(8.2027, 13.9829, 8.1289, 14.0485, 8.1025, 14.1338)
    ..cubicTo(8.0843, 14.1932, 8.0599, 14.2494, 8.0313, 14.3018)
    ..cubicTo(7.9811, 14.3947, 7.9164, 14.4748, 7.8359, 14.541)
    ..cubicTo(7.7554, 14.6073, 7.66, 14.6575, 7.5508, 14.6934)
    ..cubicTo(7.4417, 14.7273, 7.3184, 14.7451, 7.1807, 14.7451)
    ..cubicTo(6.9389, 14.7451, 6.7315, 14.688, 6.5596, 14.5752)
    ..cubicTo(6.3879, 14.4606, 6.2563, 14.2908, 6.165, 14.0654)
    ..cubicTo(6.0755, 13.838, 6.0303, 13.5554, 6.0303, 13.2188)
    ..cubicTo(6.0303, 12.9004, 6.0745, 12.6276, 6.1621, 12.4004)
    ..cubicTo(6.2516, 12.173, 6.3828, 11.9977, 6.5547, 11.876)
    ..cubicTo(6.7283, 11.7543, 6.9409, 11.6934, 7.1914, 11.6934)
    ..cubicTo(7.3345, 11.6934, 7.4625, 11.7137, 7.5752, 11.7549)
    ..cubicTo(7.688, 11.7943, 7.7835, 11.8525, 7.8623, 11.9277)
    ..cubicTo(7.9428, 12.0011, 8.006, 12.0884, 8.0508, 12.1904)
    ..cubicTo(8.0762, 12.2461, 8.0956, 12.3055, 8.1104, 12.3682)
    ..cubicTo(8.1317, 12.4591, 8.2083, 12.5312, 8.3018, 12.5312)
    ..lineTo(9.456, 12.5312)
    ..cubicTo(9.5612, 12.531, 9.6445, 12.4409, 9.6289, 12.3369)
    ..cubicTo(9.5893, 12.0733, 9.5154, 11.8347, 9.4072, 11.6211)
    ..cubicTo(9.2729, 11.3561, 9.0953, 11.133, 8.875, 10.9521)
    ..cubicTo(8.6548, 10.7695, 8.3983, 10.631, 8.1065, 10.5361)
    ..cubicTo(7.8148, 10.4413, 7.4955, 10.3936, 7.1484, 10.3936)
    ..close()
    ..moveTo(11.4004, 10.5361)
    ..cubicTo(11.0028, 10.5361, 10.6807, 10.8583, 10.6807, 11.2559)
    ..lineTo(10.6807, 15.2734)
    ..cubicTo(10.6808, 15.6709, 11.0028, 15.9932, 11.4004, 15.9932)
    ..lineTo(12.7803, 15.9932)
    ..cubicTo(13.3345, 15.9931, 13.8149, 15.8847, 14.2217, 15.668)
    ..cubicTo(14.6284, 15.4495, 14.943, 15.1371, 15.165, 14.7305)
    ..cubicTo(15.3871, 14.3219, 15.498, 13.8331, 15.498, 13.2646)
    ..cubicTo(15.498, 12.6962, 15.3859, 12.2086, 15.1621, 11.8018)
    ..cubicTo(14.9401, 11.3932, 14.6242, 11.08, 14.2139, 10.8633)
    ..cubicTo(13.8053, 10.6448, 13.3201, 10.5361, 12.7588, 10.5361)
    ..lineTo(11.4004, 10.5361)
    ..close()
    ..moveTo(7.0967, 4.0449)
    ..cubicTo(6.5042, 4.0449, 5.9777, 4.4247, 5.792, 4.9873)
    ..lineTo(4.6572, 8.4268)
    ..cubicTo(4.4999, 8.9038, 4.8551, 9.3955, 5.3574, 9.3955)
    ..cubicTo(5.6825, 9.3955, 5.9695, 9.1823, 6.0635, 8.8711)
    ..lineTo(6.2139, 8.3711)
    ..lineTo(7.9678, 8.3711)
    ..lineTo(8.125, 8.876)
    ..cubicTo(8.2215, 9.1847, 8.5076, 9.3953, 8.831, 9.3955)
    ..cubicTo(9.3352, 9.3955, 9.6922, 8.9016, 9.5342, 8.4229)
    ..lineTo(8.4004, 4.9873)
    ..cubicTo(8.2147, 4.4249, 7.6889, 4.0451, 7.0967, 4.0449)
    ..close()
    ..moveTo(11.4951, 4.0449)
    ..cubicTo(11.0976, 4.0449, 10.7745, 4.3671, 10.7744, 4.7646)
    ..lineTo(10.7744, 8.6748)
    ..cubicTo(10.7744, 9.0724, 11.0975, 9.3955, 11.4951, 9.3955)
    ..lineTo(13.293, 9.3955)
    ..cubicTo(13.6812, 9.3955, 14.0156, 9.3297, 14.2959, 9.1992)
    ..cubicTo(14.5763, 9.0686, 14.7928, 8.8893, 14.9443, 8.6611)
    ..cubicTo(15.0976, 8.433, 15.1738, 8.1725, 15.1738, 7.8799)
    ..cubicTo(15.1738, 7.6274, 15.1183, 7.408, 15.0068, 7.2217)
    ..cubicTo(14.8954, 7.0336, 14.7457, 6.8865, 14.5576, 6.7803)
    ..cubicTo(14.3695, 6.6723, 14.1605, 6.6142, 13.9307, 6.6055)
    ..lineTo(13.9307, 6.5527)
    ..cubicTo(14.1378, 6.511, 14.3187, 6.436, 14.4736, 6.3281)
    ..cubicTo(14.6286, 6.2184, 14.7496, 6.0828, 14.835, 5.9209)
    ..cubicTo(14.922, 5.759, 14.9648, 5.5795, 14.9648, 5.3828)
    ..cubicTo(14.9648, 5.1112, 14.8937, 4.875, 14.751, 4.6748)
    ..cubicTo(14.6099, 4.4745, 14.3997, 4.3197, 14.1211, 4.21)
    ..cubicTo(13.8442, 4.1003, 13.5022, 4.0449, 13.0947, 4.0449)
    ..lineTo(11.4951, 4.0449)
    ..close();

  static final Path __clip0 = _buildClip0();

  static Path _buildClip0() {
    final path = Path();
    final clipShape0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));
    path.addPath(
      clipShape0,
      Offset.zero,
      matrix4: Float64List.fromList([
        -1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        20.0,
        0.0,
        0.0,
        1.0,
      ]),
    );
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Letters._viewBoxWidth;
    final scaleY = size.height / _Letters._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Letters._viewBoxMinX, -_Letters._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LettersPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/lightning-bolt.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _LightningBolt extends StatelessWidget with _DotdartSvgSizing {
  const _LightningBolt({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _LightningBolt._svgWidth;

  @override
  double get svgNativeHeight => _LightningBolt._svgHeight;

  @override
  double get svgViewBoxWidth => _LightningBolt._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _LightningBolt._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _LightningBoltPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _LightningBoltPainter extends CustomPainter {
  _LightningBoltPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.731214854,
    0.0,
    0.0,
    0.0,
    0.0,
    0.731214854,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.447921589,
    2.687851463,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(9.7859, 0.8776)
    ..cubicTo(11.086, -0.9417, 13.9478, 0.2983, 13.5095, 2.4911)
    ..lineTo(12.7548, 6.2659)
    ..cubicTo(12.6906, 6.587, 12.9362, 6.8865, 13.2637, 6.8865)
    ..lineTo(15.575, 6.8865)
    ..cubicTo(17.2628, 6.8867, 18.2449, 8.7944, 17.2644, 10.1682)
    ..lineTo(10.8684, 19.1222)
    ..cubicTo(9.5684, 20.9418, 6.7063, 19.7017, 7.1449, 17.5087)
    ..lineTo(7.8995, 13.734)
    ..cubicTo(7.9637, 13.4129, 7.7181, 13.1133, 7.3907, 13.1133)
    ..lineTo(5.0794, 13.1133)
    ..cubicTo(3.3913, 13.1133, 2.4092, 11.2053, 3.3899, 9.8316)
    ..lineTo(9.7859, 0.8776)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _LightningBolt._viewBoxWidth;
    final scaleY = size.height / _LightningBolt._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_LightningBolt._viewBoxMinX, -_LightningBolt._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LightningBoltPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/location-pin.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _LocationPin extends StatelessWidget with _DotdartSvgSizing {
  const _LocationPin({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _LocationPin._svgWidth;

  @override
  double get svgNativeHeight => _LocationPin._svgHeight;

  @override
  double get svgViewBoxWidth => _LocationPin._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _LocationPin._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _LocationPinPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _LocationPinPainter extends CustomPainter {
  _LocationPinPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.74488657,
    0.0,
    0.0,
    0.0,
    0.0,
    0.74488657,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.434745771,
    2.551134298,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(2, 8.1443)
    ..cubicTo(2, 3.6463, 5.6463, 0, 10.1443, 0)
    ..cubicTo(14.6423, 0, 18.2886, 3.6463, 18.2886, 8.1443)
    ..cubicTo(18.2886, 10.6845, 17.1569, 13.0485, 15.8174, 14.9669)
    ..cubicTo(14.472, 16.894, 12.8659, 18.4442, 11.8024, 19.373)
    ..cubicTo(10.8452, 20.209, 9.4434, 20.209, 8.4862, 19.373)
    ..cubicTo(7.4226, 18.4442, 5.8166, 16.894, 4.4712, 14.9669)
    ..cubicTo(3.1318, 13.0485, 2, 10.6845, 2, 8.1443)
    ..close()
    ..moveTo(6.9629, 8.1443)
    ..cubicTo(6.9629, 6.3873, 8.3873, 4.9629, 10.1443, 4.9629)
    ..cubicTo(11.9014, 4.9629, 13.3257, 6.3873, 13.3257, 8.1443)
    ..cubicTo(13.3257, 9.9014, 11.9014, 11.3257, 10.1443, 11.3257)
    ..cubicTo(8.3873, 11.3257, 6.9629, 9.9014, 6.9629, 8.1443)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _LocationPin._viewBoxWidth;
    final scaleY = size.height / _LocationPin._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_LocationPin._viewBoxMinX, -_LocationPin._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LocationPinPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/magnifying-glass.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _MagnifyingGlass extends StatelessWidget with _DotdartSvgSizing {
  const _MagnifyingGlass({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _MagnifyingGlass._svgWidth;

  @override
  double get svgNativeHeight => _MagnifyingGlass._svgHeight;

  @override
  double get svgViewBoxWidth => _MagnifyingGlass._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _MagnifyingGlass._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _MagnifyingGlassPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _MagnifyingGlassPainter extends CustomPainter {
  _MagnifyingGlassPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.653434793,
    0.0,
    0.0,
    0.0,
    0.0,
    0.653434793,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.465652074,
    3.465652074,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(15.5548, 8.8906)
    ..cubicTo(15.5548, 5.2081, 12.5704, 2.2223, 8.8887, 2.2222)
    ..cubicTo(5.2069, 2.2222, 2.2217, 5.208, 2.2217, 8.8906)
    ..cubicTo(2.2219, 12.5732, 5.207, 15.5582, 8.8887, 15.5582)
    ..cubicTo(12.5704, 15.5581, 15.5547, 12.5731, 15.5548, 8.8906)
    ..close()
    ..moveTo(17.7774, 8.8906)
    ..cubicTo(17.7774, 10.9439, 17.0786, 12.8326, 15.9098, 14.3377)
    ..lineTo(19.6746, 18.1033)
    ..cubicTo(20.1085, 18.5373, 20.1085, 19.2405, 19.6746, 19.6745)
    ..cubicTo(19.2407, 20.1085, 18.5376, 20.1085, 18.1037, 19.6745)
    ..lineTo(14.3398, 15.9097)
    ..cubicTo(12.8343, 17.0811, 10.9438, 17.7812, 8.8887, 17.7813)
    ..cubicTo(3.9797, 17.7813, 0.0001, 13.8007, 0, 8.8906)
    ..cubicTo(0, 3.9805, 3.9796, 0, 8.8887, 0)
    ..cubicTo(13.7977, 0.0001, 17.7774, 3.9806, 17.7774, 8.8906)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _MagnifyingGlass._viewBoxWidth;
    final scaleY = size.height / _MagnifyingGlass._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_MagnifyingGlass._viewBoxMinX,
        -_MagnifyingGlass._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MagnifyingGlassPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/magnifying-glass-sad-face.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _MagnifyingGlassSadFace extends StatelessWidget with _DotdartSvgSizing {
  const _MagnifyingGlassSadFace({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _MagnifyingGlassSadFace._svgWidth;

  @override
  double get svgNativeHeight => _MagnifyingGlassSadFace._svgHeight;

  @override
  double get svgViewBoxWidth => _MagnifyingGlassSadFace._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _MagnifyingGlassSadFace._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _MagnifyingGlassSadFacePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _MagnifyingGlassSadFacePainter extends CustomPainter {
  _MagnifyingGlassSadFacePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.677844185,
    0.0,
    0.0,
    0.0,
    0.0,
    0.677844185,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.316879984,
    4.037089431,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(14.2725, 7.6575)
    ..cubicTo(13.6461, 4.3217, 10.4344, 2.1248, 7.0987, 2.7511)
    ..cubicTo(3.7628, 3.3774, 1.566, 6.5899, 2.1924, 9.9257)
    ..cubicTo(2.8188, 13.2614, 6.0311, 15.4575, 9.3669, 14.8311)
    ..cubicTo(12.7025, 14.2047, 14.8987, 10.9932, 14.2725, 7.6575)
    ..close()
    ..moveTo(16.2862, 7.2793)
    ..cubicTo(16.6354, 9.1393, 16.3235, 10.969, 15.5205, 12.5312)
    ..lineTo(19.2328, 15.0768)
    ..cubicTo(19.6997, 15.3961, 19.8193, 16.0331, 19.5, 16.5)
    ..cubicTo(19.1807, 16.9669, 18.5437, 17.0865, 18.0768, 16.7672)
    ..lineTo(14.3655, 14.2223)
    ..cubicTo(13.2007, 15.5395, 11.6069, 16.4952, 9.745, 16.8449)
    ..cubicTo(5.2973, 17.68, 1.0147, 14.7513, 0.1794, 10.3036)
    ..cubicTo(-0.6557, 5.8559, 2.2729, 1.5732, 6.7207, 0.7381)
    ..cubicTo(11.1684, -0.0969, 15.4511, 2.8317, 16.2862, 7.2793)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(10.0707, 5.5618)
    ..cubicTo(9.4891, 5.5618, 9.0175, 6.1206, 9.0175, 6.8962)
    ..cubicTo(9.0176, 7.6716, 9.4891, 8.1949, 10.0707, 8.1949)
    ..cubicTo(10.6523, 8.1949, 11.1238, 7.6716, 11.1239, 6.8962)
    ..cubicTo(11.1239, 6.1206, 10.6524, 5.5618, 10.0707, 5.5618)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(6.2089, 5.5618)
    ..cubicTo(5.6272, 5.5618, 5.1556, 6.1206, 5.1556, 6.8962)
    ..cubicTo(5.1558, 7.6716, 5.6273, 8.1949, 6.2089, 8.1949)
    ..cubicTo(6.7905, 8.1949, 7.262, 7.6716, 7.2621, 6.8962)
    ..cubicTo(7.2621, 6.1206, 6.7905, 5.5618, 6.2089, 5.5618)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(8.1412, 10.0202)
    ..cubicTo(7.1538, 10.0168, 6.1674, 10.4168, 5.4766, 11.1015)
    ..cubicTo(5.3994, 11.1773, 5.3266, 11.2556, 5.2565, 11.3374)
    ..cubicTo(5.1698, 11.4407, 5.12, 11.5728, 5.1234, 11.7091)
    ..cubicTo(5.1268, 11.8454, 5.1822, 11.9744, 5.2784, 12.0684)
    ..cubicTo(5.3746, 12.1623, 5.5049, 12.2148, 5.6411, 12.2151)
    ..cubicTo(5.7773, 12.2153, 5.9082, 12.1627, 6.0093, 12.0738)
    ..cubicTo(6.07, 12.0218, 6.1318, 11.9727, 6.1952, 11.9258)
    ..cubicTo(6.7646, 11.5031, 7.4524, 11.2847, 8.1418, 11.2846)
    ..cubicTo(8.8314, 11.2837, 9.5189, 11.5011, 10.0865, 11.9244)
    ..cubicTo(10.1497, 11.9715, 10.2112, 12.0203, 10.2716, 12.0725)
    ..cubicTo(10.3726, 12.1618, 10.5035, 12.215, 10.6398, 12.2151)
    ..cubicTo(10.7761, 12.2152, 10.9069, 12.1634, 11.0032, 12.0698)
    ..cubicTo(11.0996, 11.976, 11.1551, 11.8466, 11.1589, 11.7104)
    ..cubicTo(11.1627, 11.5743, 11.1135, 11.4423, 11.0272, 11.3388)
    ..cubicTo(10.9572, 11.2567, 10.8843, 11.1783, 10.8071, 11.1022)
    ..cubicTo(10.117, 10.4147, 9.1283, 10.0152, 8.1412, 10.0202)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _MagnifyingGlassSadFace._viewBoxWidth;
    final scaleY = size.height / _MagnifyingGlassSadFace._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_MagnifyingGlassSadFace._viewBoxMinX,
        -_MagnifyingGlassSadFace._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MagnifyingGlassSadFacePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/matini-glass.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _MatiniGlass extends StatelessWidget with _DotdartSvgSizing {
  const _MatiniGlass({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _MatiniGlass._svgWidth;

  @override
  double get svgNativeHeight => _MatiniGlass._svgHeight;

  @override
  double get svgViewBoxWidth => _MatiniGlass._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _MatiniGlass._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _MatiniGlassPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _MatiniGlassPainter extends CustomPainter {
  _MatiniGlassPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.66567439,
    0.0,
    0.0,
    0.0,
    0.0,
    0.66567439,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.343256101,
    3.676093296,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(2.5313, 0.0066)
    ..cubicTo(3.6137, -0.0068, 4.7158, 0.0044, 5.8, 0.004)
    ..lineTo(16.9461, 0.0035)
    ..cubicTo(17.1828, 0.0033, 17.4493, -0.0027, 17.683, 0.015)
    ..cubicTo(17.9908, 0.0353, 18.2915, 0.1154, 18.5684, 0.2509)
    ..cubicTo(19.2223, 0.5703, 19.6386, 1.1039, 19.8682, 1.7812)
    ..cubicTo(20.1526, 2.6356, 19.9934, 3.5756, 19.4433, 4.2885)
    ..cubicTo(19.1585, 4.6554, 18.8456, 4.8467, 18.4723, 5.1041)
    ..lineTo(17.7657, 5.5907)
    ..lineTo(14.2376, 8.0362)
    ..lineTo(13.1199, 8.8087)
    ..cubicTo(12.8106, 9.0241, 12.5356, 9.2031, 12.2591, 9.4615)
    ..cubicTo(11.8838, 9.8068, 11.5775, 10.2205, 11.3565, 10.6801)
    ..cubicTo(10.9709, 11.4661, 10.9468, 12.2432, 10.9668, 13.0964)
    ..cubicTo(10.9757, 13.4771, 10.9478, 13.8457, 10.994, 14.2283)
    ..cubicTo(11.0224, 14.4569, 11.0746, 14.6818, 11.1498, 14.8996)
    ..cubicTo(11.5279, 16.0019, 12.5324, 16.8437, 13.7085, 16.9357)
    ..cubicTo(14.0058, 16.9589, 14.1545, 16.9311, 14.4333, 17.0673)
    ..cubicTo(14.4881, 17.0981, 14.5401, 17.1337, 14.5886, 17.1739)
    ..cubicTo(14.7973, 17.3474, 14.9241, 17.6085, 14.9475, 17.8776)
    ..cubicTo(14.9739, 18.1604, 14.8843, 18.4417, 14.6993, 18.6571)
    ..cubicTo(14.3533, 19.0602, 13.9356, 18.9964, 13.4562, 18.9962)
    ..lineTo(12.4618, 18.9951)
    ..lineTo(6.3446, 18.9944)
    ..cubicTo(5.9699, 18.9939, 5.6841, 19.0212, 5.3842, 18.7527)
    ..cubicTo(5.1809, 18.5724, 5.058, 18.3187, 5.0427, 18.0475)
    ..cubicTo(5.0116, 17.4606, 5.4249, 16.9507, 6.0264, 16.9487)
    ..cubicTo(6.1171, 16.9483, 6.2309, 16.9383, 6.322, 16.9303)
    ..cubicTo(6.495, 16.9142, 6.6662, 16.8821, 6.8335, 16.8346)
    ..cubicTo(7.3541, 16.681, 7.8227, 16.3879, 8.1885, 15.9868)
    ..cubicTo(8.6512, 15.4828, 8.9401, 14.8437, 9.0128, 14.1633)
    ..cubicTo(9.0408, 13.8881, 9.0392, 13.5285, 9.0359, 13.2472)
    ..cubicTo(9.0319, 12.919, 9.0465, 12.5473, 9.0302, 12.2241)
    ..cubicTo(8.9954, 11.378, 8.6932, 10.5647, 8.1672, 9.901)
    ..cubicTo(7.6201, 9.2186, 6.8812, 8.7901, 6.1651, 8.2958)
    ..lineTo(2.3824, 5.6898)
    ..cubicTo(2.0898, 5.4859, 1.7958, 5.2841, 1.5004, 5.0844)
    ..cubicTo(1.2859, 4.9377, 1.0406, 4.778, 0.8506, 4.6048)
    ..cubicTo(0.3353, 4.1317, 0.0301, 3.4726, 0.0026, 2.7737)
    ..cubicTo(-0.0371, 1.8608, 0.3866, 0.9129, 1.1637, 0.4081)
    ..cubicTo(1.6038, 0.1223, 2.0145, 0.0258, 2.5313, 0.0066)
    ..close()
    ..moveTo(10.2943, 0.8618)
    ..cubicTo(9.6762, 0.8606, 9.0247, 0.8556, 8.4071, 0.8742)
    ..cubicTo(7.5652, 0.8853, 2.6627, 0.9784, 2.283, 1.3856)
    ..cubicTo(2.2694, 1.4001, 2.2637, 1.4152, 2.2572, 1.4336)
    ..cubicTo(2.2647, 1.4756, 2.274, 1.4959, 2.31, 1.5205)
    ..cubicTo(3.0021, 1.9928, 10.2175, 2.0296, 11.5866, 1.9877)
    ..cubicTo(12.4358, 1.9808, 17.302, 1.8879, 17.7072, 1.4957)
    ..cubicTo(17.7232, 1.4802, 17.7311, 1.4636, 17.74, 1.4436)
    ..cubicTo(17.7331, 1.3401, 17.6303, 1.3162, 17.5429, 1.2922)
    ..cubicTo(17.1409, 1.1821, 16.7106, 1.1384, 16.2989, 1.0947)
    ..cubicTo(15.5374, 1.0204, 14.7737, 0.9687, 14.0092, 0.9398)
    ..cubicTo(12.7716, 0.8858, 11.533, 0.8598, 10.2943, 0.8618)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _MatiniGlass._viewBoxWidth;
    final scaleY = size.height / _MatiniGlass._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_MatiniGlass._viewBoxMinX, -_MatiniGlass._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MatiniGlassPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/medical-cross.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _MedicalCross extends StatelessWidget with _DotdartSvgSizing {
  const _MedicalCross({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _MedicalCross._svgWidth;

  @override
  double get svgNativeHeight => _MedicalCross._svgHeight;

  @override
  double get svgViewBoxWidth => _MedicalCross._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _MedicalCross._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _MedicalCrossPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _MedicalCrossPainter extends CustomPainter {
  _MedicalCrossPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.746056838,
    0.0,
    0.0,
    0.0,
    0.0,
    0.746056838,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.539431615,
    2.539431615,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(9.9912, 20)
    ..cubicTo(11.9242, 20, 13.4912, 18.433, 13.4912, 16.5)
    ..lineTo(13.4912, 13.4921)
    ..lineTo(16.5, 13.4921)
    ..cubicTo(18.433, 13.4921, 20, 11.9251, 20, 9.9921)
    ..cubicTo(20, 8.0591, 18.433, 6.4921, 16.5, 6.4921)
    ..lineTo(13.4912, 6.4921)
    ..lineTo(13.4912, 3.5)
    ..cubicTo(13.4912, 1.567, 11.9242, -0, 9.9912, -0)
    ..cubicTo(8.0582, 0, 6.4912, 1.567, 6.4912, 3.5)
    ..lineTo(6.4912, 6.4921)
    ..lineTo(3.5, 6.4921)
    ..cubicTo(1.567, 6.4921, 0, 8.0591, 0, 9.9921)
    ..cubicTo(0, 11.9251, 1.567, 13.4921, 3.5, 13.4921)
    ..lineTo(6.4912, 13.4921)
    ..lineTo(6.4912, 16.5)
    ..cubicTo(6.4912, 18.433, 8.0582, 20, 9.9912, 20)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _MedicalCross._viewBoxWidth;
    final scaleY = size.height / _MedicalCross._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_MedicalCross._viewBoxMinX, -_MedicalCross._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MedicalCrossPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/numbers.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Numbers extends StatelessWidget with _DotdartSvgSizing {
  const _Numbers({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Numbers._svgWidth;

  @override
  double get svgNativeHeight => _Numbers._svgHeight;

  @override
  double get svgViewBoxWidth => _Numbers._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Numbers._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _NumbersPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _NumbersPainter extends CustomPainter {
  _NumbersPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.759353304,
    0.0,
    0.0,
    0.0,
    0.0,
    0.759353304,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.406466957,
    2.394602061,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(13.1543, 12.2432)
    ..cubicTo(13.0934, 12.2732, 13.0403, 12.3187, 13.0029, 12.3779)
    ..lineTo(11.9678, 14.0186)
    ..cubicTo(11.9645, 14.0237, 11.9629, 14.0301, 11.9629, 14.0361)
    ..cubicTo(11.9631, 14.0537, 11.9775, 14.0684, 11.9951, 14.0684)
    ..lineTo(13.1543, 14.0684)
    ..lineTo(13.1543, 12.2432)
    ..close();

  static final Path __path1 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(9.8164, 0.0566)
    ..cubicTo(6.2734, 0.0566, 4.5017, 0.0562, 3.1631, 0.7783)
    ..cubicTo(2.1291, 1.3362, 1.2806, 2.1848, 0.7227, 3.2188)
    ..cubicTo(0.0003, 4.5575, 0, 6.3295, 0, 9.873)
    ..lineTo(0, 10.2393)
    ..cubicTo(0, 13.7829, 0.0003, 15.5548, 0.7227, 16.8936)
    ..cubicTo(1.2806, 17.9276, 2.129, 18.776, 3.1631, 19.334)
    ..cubicTo(4.5017, 20.0561, 6.2734, 20.0566, 9.8164, 20.0566)
    ..lineTo(10.1836, 20.0566)
    ..cubicTo(13.7266, 20.0566, 15.4983, 20.0561, 16.8369, 19.334)
    ..cubicTo(17.871, 18.776, 18.7194, 17.9276, 19.2773, 16.8936)
    ..cubicTo(19.9997, 15.5548, 20, 13.7829, 20, 10.2393)
    ..lineTo(20, 9.873)
    ..cubicTo(20, 6.3295, 19.9997, 4.5575, 19.2773, 3.2188)
    ..cubicTo(18.7194, 2.1848, 17.8709, 1.3362, 16.8369, 0.7783)
    ..cubicTo(15.4983, 0.0562, 13.7266, 0.0566, 10.1836, 0.0566)
    ..lineTo(9.8164, 0.0566)
    ..close()
    ..moveTo(7.126, 10.6025)
    ..cubicTo(7.5262, 10.6025, 7.8807, 10.6699, 8.1875, 10.8057)
    ..cubicTo(8.4959, 10.9414, 8.7364, 11.1283, 8.9092, 11.3662)
    ..cubicTo(9.0837, 11.6025, 9.1697, 11.8737, 9.168, 12.1787)
    ..cubicTo(9.1714, 12.4819, 9.068, 12.7309, 8.8565, 12.9248)
    ..cubicTo(8.6512, 13.1145, 8.3913, 13.2277, 8.0781, 13.2656)
    ..cubicTo(8.0664, 13.2672, 8.0578, 13.2773, 8.0576, 13.2891)
    ..cubicTo(8.0576, 13.3009, 8.0664, 13.3109, 8.0781, 13.3125)
    ..cubicTo(8.5049, 13.3621, 8.8271, 13.496, 9.044, 13.7129)
    ..cubicTo(9.2643, 13.9315, 9.3727, 14.2067, 9.3691, 14.5381)
    ..cubicTo(9.3708, 14.8553, 9.2761, 15.1368, 9.084, 15.3818)
    ..cubicTo(8.8935, 15.6269, 8.6274, 15.8187, 8.2871, 15.958)
    ..cubicTo(7.9487, 16.0972, 7.5585, 16.167, 7.1162, 16.167)
    ..cubicTo(6.6895, 16.167, 6.31, 16.0936, 5.9785, 15.9473)
    ..cubicTo(5.649, 15.7992, 5.3898, 15.5959, 5.2012, 15.3369)
    ..cubicTo(5.1295, 15.2385, 5.0711, 15.134, 5.0264, 15.0244)
    ..cubicTo(4.9788, 14.9077, 4.9553, 14.8491, 4.9775, 14.7393)
    ..cubicTo(4.9932, 14.6624, 5.0695, 14.5485, 5.1348, 14.5049)
    ..cubicTo(5.2281, 14.4428, 5.3231, 14.4424, 5.5117, 14.4424)
    ..lineTo(6.0957, 14.4424)
    ..cubicTo(6.2625, 14.4426, 6.3915, 14.5888, 6.4912, 14.7227)
    ..cubicTo(6.5547, 14.8038, 6.6417, 14.8672, 6.751, 14.9131)
    ..cubicTo(6.8602, 14.9589, 6.9851, 14.9824, 7.126, 14.9824)
    ..cubicTo(7.2617, 14.9824, 7.3823, 14.9587, 7.4863, 14.9111)
    ..cubicTo(7.5904, 14.8618, 7.6713, 14.7934, 7.7295, 14.707)
    ..cubicTo(7.7876, 14.6207, 7.8162, 14.5221, 7.8144, 14.4111)
    ..cubicTo(7.8162, 14.3019, 7.7825, 14.2047, 7.7139, 14.1201)
    ..cubicTo(7.6469, 14.0355, 7.5522, 13.9695, 7.4307, 13.9219)
    ..cubicTo(7.309, 13.8743, 7.1685, 13.8496, 7.0098, 13.8496)
    ..lineTo(6.9678, 13.8496)
    ..cubicTo(6.6873, 13.8496, 6.46, 13.6223, 6.46, 13.3418)
    ..cubicTo(6.4602, 13.0615, 6.6875, 12.834, 6.9678, 12.834)
    ..lineTo(7.0098, 12.834)
    ..cubicTo(7.1561, 12.834, 7.2854, 12.8103, 7.3965, 12.7627)
    ..cubicTo(7.5092, 12.7151, 7.5965, 12.649, 7.6582, 12.5645)
    ..cubicTo(7.7216, 12.4799, 7.7527, 12.3827, 7.751, 12.2734)
    ..cubicTo(7.7527, 12.1678, 7.7267, 12.0742, 7.6738, 11.9932)
    ..cubicTo(7.5671, 11.8297, 7.3604, 11.7541, 7.166, 11.7363)
    ..cubicTo(7.1523, 11.7351, 7.1384, 11.7344, 7.126, 11.7344)
    ..cubicTo(6.9922, 11.7344, 6.8723, 11.7581, 6.7666, 11.8057)
    ..cubicTo(6.6627, 11.8533, 6.5804, 11.9193, 6.5205, 12.0039)
    ..cubicTo(6.4211, 12.1443, 6.2901, 12.2949, 6.1182, 12.2949)
    ..lineTo(5.6172, 12.2949)
    ..cubicTo(5.428, 12.2949, 5.3335, 12.2944, 5.2402, 12.2324)
    ..cubicTo(5.175, 12.1889, 5.0979, 12.0759, 5.082, 11.999)
    ..cubicTo(5.0596, 11.8895, 5.0834, 11.8302, 5.1309, 11.7129)
    ..cubicTo(5.1729, 11.609, 5.2278, 11.5104, 5.2939, 11.417)
    ..cubicTo(5.4755, 11.1632, 5.7236, 10.9639, 6.0391, 10.8193)
    ..cubicTo(6.3546, 10.6748, 6.7171, 10.6026, 7.126, 10.6025)
    ..close()
    ..moveTo(13.6934, 10.7109)
    ..lineTo(13.6934, 10.7158)
    ..cubicTo(13.7265, 10.7168, 13.7531, 10.7155, 13.7773, 10.7188)
    ..cubicTo(14.1506, 10.7685, 14.4445, 11.0623, 14.4941, 11.4355)
    ..cubicTo(14.5014, 11.4902, 14.501, 11.5554, 14.501, 11.6855)
    ..lineTo(14.501, 14.0684)
    ..lineTo(14.5527, 14.0684)
    ..cubicTo(14.8616, 14.0684, 15.1121, 14.3182, 15.1123, 14.627)
    ..cubicTo(15.1123, 14.9359, 14.8617, 15.1865, 14.5527, 15.1865)
    ..lineTo(14.501, 15.1865)
    ..lineTo(14.501, 15.3262)
    ..cubicTo(14.501, 15.7065, 14.1928, 16.0154, 13.8125, 16.0156)
    ..cubicTo(13.432, 16.0156, 13.123, 15.7067, 13.123, 15.3262)
    ..lineTo(13.123, 15.1865)
    ..lineTo(11.4102, 15.1865)
    ..cubicTo(10.9317, 15.1864, 10.544, 14.7988, 10.5439, 14.3203)
    ..cubicTo(10.5439, 14.1557, 10.5905, 13.9944, 10.6787, 13.8555)
    ..lineTo(12.1973, 11.4668)
    ..cubicTo(12.3725, 11.1912, 12.4602, 11.0531, 12.5781, 10.9531)
    ..cubicTo(12.6825, 10.8646, 12.8039, 10.7975, 12.9346, 10.7568)
    ..cubicTo(13.0002, 10.7364, 13.0695, 10.726, 13.1543, 10.7197)
    ..lineTo(13.1543, 10.7109)
    ..lineTo(13.6934, 10.7109)
    ..close()
    ..moveTo(12.668, 3.833)
    ..cubicTo(13.1112, 3.833, 13.495, 3.9046, 13.8193, 4.0469)
    ..cubicTo(14.1455, 4.1874, 14.3976, 4.3857, 14.5742, 4.6416)
    ..cubicTo(14.7523, 4.8973, 14.8418, 5.1972, 14.8418, 5.541)
    ..cubicTo(14.8418, 5.7537, 14.7973, 5.9659, 14.709, 6.1768)
    ..cubicTo(14.6207, 6.3857, 14.4621, 6.6172, 14.2334, 6.8711)
    ..cubicTo(14.0046, 7.1251, 13.6794, 7.428, 13.2578, 7.7793)
    ..lineTo(12.7461, 8.2051)
    ..cubicTo(12.7413, 8.2092, 12.7384, 8.2154, 12.7383, 8.2217)
    ..cubicTo(12.7383, 8.2339, 12.7485, 8.2441, 12.7607, 8.2441)
    ..lineTo(14.3008, 8.2441)
    ..cubicTo(14.6322, 8.2441, 14.9004, 8.5133, 14.9004, 8.8447)
    ..cubicTo(14.9001, 9.1759, 14.632, 9.4443, 14.3008, 9.4443)
    ..lineTo(11.3867, 9.4443)
    ..cubicTo(10.9808, 9.4442, 10.6514, 9.1149, 10.6514, 8.709)
    ..cubicTo(10.6514, 8.49, 10.7493, 8.2822, 10.918, 8.1426)
    ..lineTo(12.7168, 6.6553)
    ..cubicTo(12.8537, 6.5418, 12.9711, 6.4351, 13.0684, 6.3359)
    ..cubicTo(13.1673, 6.2352, 13.2427, 6.1315, 13.2949, 6.0254)
    ..cubicTo(13.349, 5.9191, 13.376, 5.8006, 13.376, 5.6709)
    ..cubicTo(13.376, 5.5286, 13.3454, 5.4066, 13.2842, 5.3057)
    ..cubicTo(13.2248, 5.205, 13.1422, 5.1272, 13.0361, 5.0732)
    ..cubicTo(12.9298, 5.0174, 12.8067, 4.9902, 12.668, 4.9902)
    ..cubicTo(12.5294, 4.9903, 12.407, 5.0175, 12.3008, 5.0732)
    ..cubicTo(12.1964, 5.1291, 12.1153, 5.2114, 12.0576, 5.3193)
    ..cubicTo(11.9516, 5.5182, 11.7879, 5.7139, 11.5625, 5.7139)
    ..lineTo(11.2568, 5.7139)
    ..cubicTo(10.8629, 5.7136, 10.5237, 5.3839, 10.6582, 5.0137)
    ..cubicTo(10.6974, 4.9059, 10.7464, 4.8043, 10.8057, 4.709)
    ..cubicTo(10.9805, 4.4279, 11.2279, 4.2109, 11.5469, 4.0596)
    ..cubicTo(11.8657, 3.9084, 12.2394, 3.833, 12.668, 3.833)
    ..close()
    ..moveTo(6.9678, 3.9668)
    ..cubicTo(7.5087, 3.9669, 7.9473, 4.4053, 7.9473, 4.9463)
    ..lineTo(7.9473, 8.7471)
    ..cubicTo(7.9473, 9.1319, 7.6349, 9.4443, 7.25, 9.4443)
    ..cubicTo(6.8702, 9.4441, 6.5605, 9.1396, 6.5537, 8.7598)
    ..lineTo(6.4941, 5.4541)
    ..cubicTo(6.4939, 5.4411, 6.4836, 5.4308, 6.4707, 5.4307)
    ..cubicTo(6.4665, 5.4307, 6.4617, 5.4315, 6.458, 5.4336)
    ..lineTo(5.6689, 5.8945)
    ..cubicTo(5.3228, 6.0965, 4.8878, 5.8471, 4.8877, 5.4463)
    ..cubicTo(4.8877, 5.2739, 4.9734, 5.1122, 5.1162, 5.0156)
    ..lineTo(6.4189, 4.1348)
    ..cubicTo(6.581, 4.0252, 6.7722, 3.9668, 6.9678, 3.9668)
    ..close();

  static final Path __clip0 = _buildClip0();

  static Path _buildClip0() {
    final path = Path();
    final clipShape0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));
    path.addPath(
      clipShape0,
      Offset.zero,
      matrix4: Float64List.fromList([
        -1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        20.0,
        0.0,
        0.0,
        1.0,
      ]),
    );
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Numbers._viewBoxWidth;
    final scaleY = size.height / _Numbers._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Numbers._viewBoxMinX, -_Numbers._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NumbersPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/padlock.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Padlock extends StatelessWidget with _DotdartSvgSizing {
  const _Padlock({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Padlock._svgWidth;

  @override
  double get svgNativeHeight => _Padlock._svgHeight;

  @override
  double get svgViewBoxWidth => _Padlock._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Padlock._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PadlockPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PadlockPainter extends CustomPainter {
  _PadlockPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.709365856,
    0.0,
    0.0,
    0.0,
    0.0,
    0.709365856,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.906341444,
    2.906341444,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10, 0)
    ..cubicTo(7.2386, 0, 5, 2.2386, 5, 5)
    ..lineTo(5, 7.126)
    ..cubicTo(3.2748, 7.5701, 2, 9.1362, 2, 11)
    ..lineTo(2, 16)
    ..cubicTo(2, 18.2091, 3.7909, 20, 6, 20)
    ..lineTo(14, 20)
    ..cubicTo(16.2091, 20, 18, 18.2091, 18, 16)
    ..lineTo(18, 11)
    ..cubicTo(18, 9.1362, 16.7252, 7.5701, 15, 7.126)
    ..lineTo(15, 5)
    ..cubicTo(15, 2.2386, 12.7614, 0, 10, 0)
    ..close()
    ..moveTo(13, 7)
    ..lineTo(13, 5)
    ..cubicTo(13, 3.3432, 11.6569, 2, 10, 2)
    ..cubicTo(8.3431, 2, 7, 3.3432, 7, 5)
    ..lineTo(7, 7)
    ..lineTo(13, 7)
    ..close()
    ..moveTo(10, 11)
    ..cubicTo(10.5523, 11, 11, 11.4477, 11, 12)
    ..lineTo(11, 15)
    ..cubicTo(11, 15.5523, 10.5523, 16, 10, 16)
    ..cubicTo(9.4477, 16, 9, 15.5523, 9, 15)
    ..lineTo(9, 12)
    ..cubicTo(9, 11.4477, 9.4477, 11, 10, 11)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Padlock._viewBoxWidth;
    final scaleY = size.height / _Padlock._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Padlock._viewBoxMinX, -_Padlock._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PadlockPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/padlock-open.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _PadlockOpen extends StatelessWidget with _DotdartSvgSizing {
  const _PadlockOpen({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _PadlockOpen._svgWidth;

  @override
  double get svgNativeHeight => _PadlockOpen._svgHeight;

  @override
  double get svgViewBoxWidth => _PadlockOpen._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _PadlockOpen._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PadlockOpenPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PadlockOpenPainter extends CustomPainter {
  _PadlockOpenPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.742909706,
    0.0,
    0.0,
    0.0,
    0.0,
    0.742909706,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.570902943,
    2.570902943,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.0368, 0)
    ..cubicTo(12.7983, 0, 15.0368, 2.2386, 15.0368, 5)
    ..lineTo(15.0368, 7.1306)
    ..cubicTo(16.743, 7.5848, 18, 9.1404, 18, 10.9896)
    ..lineTo(18, 16.0069)
    ..cubicTo(18, 18.2122, 16.2122, 20, 14.0069, 20)
    ..lineTo(5.9931, 20)
    ..cubicTo(3.7878, 20, 2, 18.2122, 2, 16.0069)
    ..lineTo(2, 10.9896)
    ..cubicTo(2, 8.7843, 3.7878, 6.9965, 5.9931, 6.9965)
    ..lineTo(13.0368, 6.9965)
    ..lineTo(13.0368, 5)
    ..cubicTo(13.0368, 3.3432, 11.6937, 2, 10.0368, 2)
    ..cubicTo(8.6403, 2, 7.4643, 2.9551, 7.1314, 4.2493)
    ..cubicTo(6.9936, 4.7841, 6.4484, 5.1061, 5.9136, 4.9684)
    ..cubicTo(5.3788, 4.8308, 5.0568, 4.2856, 5.1944, 3.7507)
    ..cubicTo(5.7495, 1.5944, 7.7057, 0, 10.0368, 0)
    ..close()
    ..moveTo(9.9965, 11.0035)
    ..cubicTo(9.4366, 11.0035, 8.9827, 11.4574, 8.9827, 12.0173)
    ..lineTo(8.9827, 14.9792)
    ..cubicTo(8.9827, 15.5392, 9.4366, 15.9931, 9.9965, 15.9931)
    ..cubicTo(10.5565, 15.9931, 11.0104, 15.5392, 11.0104, 14.9792)
    ..lineTo(11.0104, 12.0173)
    ..cubicTo(11.0104, 11.4574, 10.5565, 11.0035, 9.9965, 11.0035)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _PadlockOpen._viewBoxWidth;
    final scaleY = size.height / _PadlockOpen._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_PadlockOpen._viewBoxMinX, -_PadlockOpen._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PadlockOpenPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/paper-plane-up-right.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _PaperPlaneUpRight extends StatelessWidget with _DotdartSvgSizing {
  const _PaperPlaneUpRight({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _PaperPlaneUpRight._svgWidth;

  @override
  double get svgNativeHeight => _PaperPlaneUpRight._svgHeight;

  @override
  double get svgViewBoxWidth => _PaperPlaneUpRight._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _PaperPlaneUpRight._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PaperPlaneUpRightPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PaperPlaneUpRightPainter extends CustomPainter {
  _PaperPlaneUpRightPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.720495795,
    0.0,
    0.0,
    0.0,
    0.0,
    0.720495795,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.795042047,
    2.7837843,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(9.8881, 2.3655)
    ..cubicTo(13.9333, 0.7362, 15.956, -0.0785, 17.3313, 0.4705)
    ..cubicTo(18.1188, 0.7849, 18.7742, 1.3607, 19.1873, 2.1012)
    ..cubicTo(19.9088, 3.3944, 19.3614, 5.5051, 18.2664, 9.7265)
    ..lineTo(16.4318, 16.7998)
    ..cubicTo(15.7074, 19.5924, 12.3147, 20.67, 10.1116, 18.8072)
    ..cubicTo(8.6478, 17.5694, 8.295, 15.4541, 9.2779, 13.8082)
    ..lineTo(12.394, 9.0162)
    ..cubicTo(12.4931, 8.8503, 12.4372, 8.6354, 12.2698, 8.5389)
    ..cubicTo(12.1535, 8.4718, 12.0089, 8.478, 11.8988, 8.5548)
    ..lineTo(6.6009, 11.9674)
    ..cubicTo(5.1503, 12.9795, 3.1995, 12.8852, 1.8534, 11.7379)
    ..cubicTo(-0.3709, 9.8424, 0.2121, 6.2627, 2.9229, 5.1709)
    ..lineTo(9.8881, 2.3655)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _PaperPlaneUpRight._viewBoxWidth;
    final scaleY = size.height / _PaperPlaneUpRight._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_PaperPlaneUpRight._viewBoxMinX,
        -_PaperPlaneUpRight._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PaperPlaneUpRightPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/parking-sign.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ParkingSign extends StatelessWidget with _DotdartSvgSizing {
  const _ParkingSign({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ParkingSign._svgWidth;

  @override
  double get svgNativeHeight => _ParkingSign._svgHeight;

  @override
  double get svgViewBoxWidth => _ParkingSign._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ParkingSign._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ParkingSignPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ParkingSignPainter extends CustomPainter {
  _ParkingSignPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.631978074,
    0.0,
    0.0,
    0.0,
    0.0,
    0.631978074,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.719717891,
    3.660469947,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(4.5897, 20)
    ..cubicTo(5.5674, 20, 6.1815, 19.3588, 6.1815, 18.3531)
    ..lineTo(6.1815, 13.0125)
    ..lineTo(10.1886, 13.0125)
    ..cubicTo(14.1305, 13.0125, 16.8556, 10.3732, 16.8556, 6.5391)
    ..cubicTo(16.8556, 2.6797, 14.1723, 0.0625, 10.2694, 0.0625)
    ..lineTo(4.5897, 0.0625)
    ..cubicTo(3.6141, 0.0625, 3, 0.6945, 3, 1.7097)
    ..lineTo(3, 18.3531)
    ..cubicTo(3, 19.368, 3.6141, 20, 4.5897, 20)
    ..close()
    ..moveTo(6.1815, 10.2805)
    ..lineTo(6.1815, 2.8101)
    ..lineTo(9.59, 2.8101)
    ..cubicTo(12.1469, 2.8101, 13.6265, 4.1533, 13.6265, 6.5412)
    ..cubicTo(13.6265, 8.9226, 12.1451, 10.2805, 9.5835, 10.2805)
    ..lineTo(6.1815, 10.2805)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ParkingSign._viewBoxWidth;
    final scaleY = size.height / _ParkingSign._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ParkingSign._viewBoxMinX, -_ParkingSign._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ParkingSignPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/pencil.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Pencil extends StatelessWidget with _DotdartSvgSizing {
  const _Pencil({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Pencil._svgWidth;

  @override
  double get svgNativeHeight => _Pencil._svgHeight;

  @override
  double get svgViewBoxWidth => _Pencil._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Pencil._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PencilPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PencilPainter extends CustomPainter {
  _PencilPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.728379511,
    0.0,
    0.0,
    0.0,
    0.0,
    0.728379511,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.727585815,
    2.727585815,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(12.46, 1.2844)
    ..cubicTo(14.1726, -0.4281, 16.9491, -0.4281, 18.6616, 1.2844)
    ..cubicTo(20.3742, 2.9969, 20.3742, 5.7735, 18.6616, 7.486)
    ..lineTo(6.8159, 19.3318)
    ..cubicTo(6.4226, 19.7251, 5.8891, 19.946, 5.3329, 19.946)
    ..lineTo(1.0486, 19.946)
    ..cubicTo(0.4695, 19.946, -0, 19.4765, -0, 18.8974)
    ..lineTo(-0, 14.6132)
    ..cubicTo(-0, 14.0569, 0.2209, 13.5235, 0.6143, 13.1301)
    ..lineTo(10.5761, 3.1683)
    ..lineTo(16.7775, 9.3697)
    ..lineTo(17.5681, 8.5792)
    ..lineTo(11.3667, 2.3778)
    ..lineTo(12.46, 1.2844)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Pencil._viewBoxWidth;
    final scaleY = size.height / _Pencil._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Pencil._viewBoxMinX, -_Pencil._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PencilPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/phone.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Phone extends StatelessWidget with _DotdartSvgSizing {
  const _Phone({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Phone._svgWidth;

  @override
  double get svgNativeHeight => _Phone._svgHeight;

  @override
  double get svgViewBoxWidth => _Phone._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Phone._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PhonePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PhonePainter extends CustomPainter {
  _PhonePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.665233439,
    0.0,
    0.0,
    0.0,
    0.0,
    0.665233439,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.285299976,
    3.420425518,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(4.1169, 0)
    ..cubicTo(1.8904, 0, -0.1442, 1.8333, 0.2599, 4.2409)
    ..cubicTo(0.633, 6.4635, 1.4008, 8.6175, 2.5377, 10.5771)
    ..cubicTo(4.1918, 13.4281, 6.5699, 15.8062, 9.421, 17.4603)
    ..cubicTo(11.3865, 18.6007, 13.511, 19.341, 15.7075, 19.7132)
    ..cubicTo(18.1293, 20.1237, 19.998, 18.082, 19.998, 15.83)
    ..cubicTo(19.998, 13.9823, 18.781, 12.3519, 17.0071, 11.8301)
    ..lineTo(15.9357, 11.515)
    ..cubicTo(14.8643, 11.1999, 13.7066, 11.5077, 12.9332, 12.3133)
    ..cubicTo(12.515, 12.7489, 11.9187, 12.8161, 11.5061, 12.5493)
    ..cubicTo(9.8834, 11.5, 8.4981, 10.1146, 7.4487, 8.4919)
    ..cubicTo(7.1819, 8.0794, 7.2492, 7.483, 7.6848, 7.0648)
    ..cubicTo(8.4903, 6.2915, 8.7982, 5.1338, 8.4831, 4.0624)
    ..lineTo(8.0905, 2.7276)
    ..cubicTo(7.6149, 1.1105, 6.1307, 0, 4.4451, 0)
    ..lineTo(4.1169, 0)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Phone._viewBoxWidth;
    final scaleY = size.height / _Phone._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Phone._viewBoxMinX, -_Phone._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PhonePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/pills.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Pills extends StatelessWidget with _DotdartSvgSizing {
  const _Pills({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Pills._svgWidth;

  @override
  double get svgNativeHeight => _Pills._svgHeight;

  @override
  double get svgViewBoxWidth => _Pills._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Pills._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PillsPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PillsPainter extends CustomPainter {
  _PillsPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.831750879,
    0.0,
    0.0,
    0.0,
    0.0,
    0.831750879,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.085370542,
    1.68249121,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(14.2505, 19.9024)
    ..cubicTo(11.2424, 20.4622, 8.28, 18.5896, 7.5267, 15.5813)
    ..cubicTo(6.7726, 12.5696, 8.5078, 9.5184, 11.4308, 8.5985)
    ..lineTo(14.2505, 19.9024)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(18.8492, 12.7462)
    ..cubicTo(19.6049, 15.7643, 17.8607, 18.8221, 14.9265, 19.7348)
    ..lineTo(12.1064, 8.4288)
    ..cubicTo(15.121, 7.8574, 18.0943, 9.7316, 18.8492, 12.7462)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(7.6182, 10.0788)
    ..cubicTo(5.838, 12.5034, 5.7964, 15.9044, 7.7321, 18.3984)
    ..cubicTo(7.8557, 18.5577, 7.9859, 18.7094, 8.1203, 18.8549)
    ..cubicTo(6.5769, 19.7471, 4.4187, 19.6731, 2.6074, 18.5019)
    ..cubicTo(0.168, 16.9245, -0.7176, 13.9561, 0.63, 11.8719)
    ..lineTo(3.5102, 7.4181)
    ..lineTo(7.6182, 10.0788)
    ..close()
    ..moveTo(7.0933, 1.8773)
    ..cubicTo(8.4409, -0.2069, 11.5115, -0.6184, 13.951, 0.959)
    ..cubicTo(16.3905, 2.5364, 17.275, 5.5048, 15.9274, 7.5889)
    ..lineTo(15.8073, 7.7732)
    ..cubicTo(13.8057, 6.9551, 11.4695, 7.0981, 9.5438, 8.2971)
    ..cubicTo(9.5324, 8.304, 9.1626, 8.5306, 8.9423, 8.7019)
    ..cubicTo(8.7738, 8.8329, 8.5515, 9.0412, 8.4536, 9.1346)
    ..lineTo(4.1872, 6.3715)
    ..lineTo(7.0933, 1.8773)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Pills._viewBoxWidth;
    final scaleY = size.height / _Pills._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Pills._viewBoxMinX, -_Pills._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PillsPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/plane-up-right.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _PlaneUpRight extends StatelessWidget with _DotdartSvgSizing {
  const _PlaneUpRight({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _PlaneUpRight._svgWidth;

  @override
  double get svgNativeHeight => _PlaneUpRight._svgHeight;

  @override
  double get svgViewBoxWidth => _PlaneUpRight._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _PlaneUpRight._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PlaneUpRightPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PlaneUpRightPainter extends CustomPainter {
  _PlaneUpRightPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.780209705,
    0.0,
    0.0,
    0.0,
    0.0,
    0.780209705,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.197902946,
    2.051613626,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(18.485, 1.0107)
    ..cubicTo(18.878, 0.9549, 19.4547, 1.1199, 19.7117, 1.4364)
    ..cubicTo(20.3591, 2.2338, 19.7857, 3.3923, 19.267, 4.0953)
    ..cubicTo(18.924, 4.5599, 18.5073, 4.9512, 18.0911, 5.3466)
    ..cubicTo(17.7549, 5.6671, 17.4169, 5.9857, 17.0768, 6.3023)
    ..cubicTo(16.2481, 7.0793, 15.4144, 7.8511, 14.5757, 8.6177)
    ..cubicTo(14.7552, 9.5589, 14.942, 10.4987, 15.1361, 11.4369)
    ..lineTo(15.7331, 14.4494)
    ..lineTo(16.0202, 15.9067)
    ..cubicTo(16.0996, 16.3082, 16.264, 16.9509, 16.1832, 17.3356)
    ..cubicTo(16.0403, 18.0168, 15.2148, 18.7452, 14.4837, 18.5587)
    ..cubicTo(14.2919, 18.5092, 14.1207, 18.3999, 13.9949, 18.2468)
    ..cubicTo(13.8672, 18.0904, 13.6965, 17.7817, 13.5875, 17.5951)
    ..lineTo(12.9997, 16.5841)
    ..cubicTo(12.1341, 15.0924, 11.2984, 13.5502, 10.4204, 12.0725)
    ..cubicTo(10.0383, 12.3683, 9.5727, 12.7846, 9.2011, 13.1013)
    ..lineTo(7.014, 14.9592)
    ..lineTo(7.258, 16.8705)
    ..cubicTo(7.3074, 17.2585, 7.355, 17.6404, 7.3946, 18.0296)
    ..cubicTo(7.5011, 18.9357, 6.1486, 19.8922, 5.4713, 19.0516)
    ..cubicTo(5.2952, 18.833, 5.0876, 18.4124, 4.9447, 18.1565)
    ..lineTo(3.9104, 16.2906)
    ..cubicTo(3.7515, 16.0067, 3.5225, 15.76, 3.2401, 15.5986)
    ..cubicTo(2.607, 15.2369, 1.9759, 14.872, 1.3466, 14.5038)
    ..cubicTo(1.022, 14.3134, 0.6925, 14.1291, 0.3722, 13.9324)
    ..cubicTo(0.0938, 13.7654, -0.0416, 13.4824, 0.0112, 13.1592)
    ..cubicTo(0.0977, 12.6299, 0.7529, 12.0648, 1.289, 12.0648)
    ..cubicTo(1.6019, 12.0648, 1.9838, 12.1833, 2.2976, 12.2423)
    ..cubicTo(3.0933, 12.3917, 3.8868, 12.6092, 4.6837, 12.7444)
    ..lineTo(7.8604, 9.5682)
    ..cubicTo(7.6937, 9.4351, 7.1404, 9.1225, 6.9256, 8.989)
    ..lineTo(3.3668, 6.794)
    ..lineTo(2.3328, 6.1516)
    ..cubicTo(2.0971, 6.0045, 1.6417, 5.7545, 1.5025, 5.529)
    ..cubicTo(1.1242, 4.9166, 1.6912, 4.3367, 2.1688, 4.0136)
    ..cubicTo(2.7862, 3.5959, 3.2675, 3.7684, 3.9237, 3.9364)
    ..cubicTo(4.2998, 4.034, 4.6765, 4.1292, 5.0538, 4.2222)
    ..lineTo(9.4449, 5.3271)
    ..cubicTo(10.161, 5.5075, 10.975, 5.7362, 11.6873, 5.8778)
    ..cubicTo(11.8653, 5.7043, 12.0871, 5.5301, 12.2739, 5.3615)
    ..cubicTo(12.8003, 4.8867, 13.3462, 4.4341, 13.8822, 3.9708)
    ..cubicTo(14.4306, 3.4882, 14.9843, 3.0116, 15.5433, 2.5411)
    ..cubicTo(16.4311, 1.8003, 17.29, 1.1449, 18.485, 1.0107)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _PlaneUpRight._viewBoxWidth;
    final scaleY = size.height / _PlaneUpRight._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_PlaneUpRight._viewBoxMinX, -_PlaneUpRight._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PlaneUpRightPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/plus-signal.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _PlusSignal extends StatelessWidget with _DotdartSvgSizing {
  const _PlusSignal({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _PlusSignal._svgWidth;

  @override
  double get svgNativeHeight => _PlusSignal._svgHeight;

  @override
  double get svgViewBoxWidth => _PlusSignal._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _PlusSignal._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PlusSignalPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PlusSignalPainter extends CustomPainter {
  _PlusSignalPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.807095968,
    0.0,
    0.0,
    0.0,
    0.0,
    0.807095968,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.929040319,
    1.929040319,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(0, 10)
    ..cubicTo(0, 9.1716, 0.6716, 8.5, 1.5, 8.5)
    ..lineTo(18.5, 8.5)
    ..cubicTo(19.3284, 8.5, 20, 9.1716, 20, 10)
    ..cubicTo(20, 10.8284, 19.3284, 11.5, 18.5, 11.5)
    ..lineTo(1.5, 11.5)
    ..cubicTo(0.6716, 11.5, 0, 10.8284, 0, 10)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(10, 20)
    ..cubicTo(9.1716, 20, 8.5, 19.3284, 8.5, 18.5)
    ..lineTo(8.5, 1.5)
    ..cubicTo(8.5, 0.6716, 9.1716, 0, 10, 0)
    ..cubicTo(10.8284, 0, 11.5, 0.6716, 11.5, 1.5)
    ..lineTo(11.5, 18.5)
    ..cubicTo(11.5, 19.3284, 10.8284, 20, 10, 20)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _PlusSignal._viewBoxWidth;
    final scaleY = size.height / _PlusSignal._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_PlusSignal._viewBoxMinX, -_PlusSignal._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PlusSignalPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/pointer-hand-up.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _PointerHandUp extends StatelessWidget with _DotdartSvgSizing {
  const _PointerHandUp({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _PointerHandUp._svgWidth;

  @override
  double get svgNativeHeight => _PointerHandUp._svgHeight;

  @override
  double get svgViewBoxWidth => _PointerHandUp._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _PointerHandUp._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PointerHandUpPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PointerHandUpPainter extends CustomPainter {
  _PointerHandUpPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.700644037,
    0.0,
    0.0,
    0.0,
    0.0,
    0.700644037,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.168720644,
    2.993559635,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(9.4375, 7.1233)
    ..lineTo(14.2353, 7.1233)
    ..cubicTo(16.5906, 7.1233, 18.5, 9.0859, 18.5, 11.5069)
    ..lineTo(18.5, 12.1416)
    ..cubicTo(18.5, 16.4817, 15.0771, 20, 10.8547, 20)
    ..cubicTo(8.0161, 20, 5.4112, 18.3835, 4.0892, 15.8016)
    ..lineTo(1.0558, 9.8777)
    ..cubicTo(0.966, 9.7022, 0.9858, 9.4891, 1.1064, 9.3341)
    ..lineTo(1.7083, 8.5608)
    ..cubicTo(2.444, 7.6156, 3.7859, 7.4623, 4.7055, 8.2185)
    ..lineTo(5.7058, 9.0411)
    ..lineTo(5.7058, 1.9178)
    ..cubicTo(5.7058, 0.8586, 6.5412, 0, 7.5716, 0)
    ..cubicTo(8.6021, 0, 9.4375, 0.8586, 9.4375, 1.9178)
    ..lineTo(9.4375, 7.1233)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _PointerHandUp._viewBoxWidth;
    final scaleY = size.height / _PointerHandUp._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_PointerHandUp._viewBoxMinX, -_PointerHandUp._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PointerHandUpPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/police-badge.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _PoliceBadge extends StatelessWidget with _DotdartSvgSizing {
  const _PoliceBadge({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _PoliceBadge._svgWidth;

  @override
  double get svgNativeHeight => _PoliceBadge._svgHeight;

  @override
  double get svgViewBoxWidth => _PoliceBadge._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _PoliceBadge._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PoliceBadgePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PoliceBadgePainter extends CustomPainter {
  _PoliceBadgePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.733174458,
    0.0,
    0.0,
    0.0,
    0.0,
    0.733174458,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.565152758,
    2.668255416,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.0003, 0.0044)
    ..cubicTo(10.514, -0.0309, 11.0196, 0.1479, 11.3968, 0.4985)
    ..cubicTo(11.6226, 0.7059, 11.8176, 0.9433, 12.0676, 1.1636)
    ..cubicTo(12.9096, 1.9053, 14.1061, 2.0509, 15.0501, 1.4126)
    ..cubicTo(15.6317, 1.0061, 15.8785, 0.4721, 16.6731, 0.4263)
    ..cubicTo(17.4895, 0.3792, 17.8918, 0.8353, 18.4319, 1.3462)
    ..cubicTo(18.8723, 1.7628, 19.2194, 2.0754, 19.26, 2.7261)
    ..cubicTo(19.2839, 3.1267, 19.1493, 3.5208, 18.886, 3.8237)
    ..cubicTo(18.7796, 3.9472, 18.6455, 4.0626, 18.5354, 4.1919)
    ..cubicTo(18.2345, 4.5453, 18.022, 4.9527, 17.8831, 5.393)
    ..cubicTo(17.3479, 7.091, 18.2712, 8.4116, 18.8186, 9.9477)
    ..cubicTo(19.0526, 10.5942, 19.1958, 11.2698, 19.2444, 11.9556)
    ..cubicTo(19.2392, 11.9635, 19.223, 11.9891, 19.2229, 11.9985)
    ..cubicTo(19.2215, 12.1313, 19.2108, 12.4419, 19.2337, 12.5581)
    ..cubicTo(19.2359, 12.5698, 19.2387, 12.5816, 19.2415, 12.5932)
    ..cubicTo(19.239, 12.7934, 19.205, 12.9959, 19.1721, 13.1919)
    ..lineTo(19.1682, 13.2153)
    ..cubicTo(18.7299, 15.8359, 16.2094, 17.1068, 14.0393, 18.1304)
    ..cubicTo(13.0846, 18.5807, 12.0822, 19.0244, 11.1497, 19.5259)
    ..cubicTo(10.8436, 19.6905, 10.5814, 19.969, 10.218, 19.9966)
    ..cubicTo(9.8105, 20.0335, 9.5531, 19.7979, 9.2317, 19.5952)
    ..cubicTo(7.7823, 18.7806, 6.2073, 18.19, 4.7483, 17.394)
    ..cubicTo(3.7711, 16.861, 2.8665, 16.2903, 2.137, 15.435)
    ..cubicTo(0.721, 13.7752, 0.7892, 11.5802, 1.5657, 9.6538)
    ..cubicTo(1.9885, 8.605, 2.5737, 7.4924, 2.5403, 6.354)
    ..cubicTo(2.5198, 5.6116, 2.2684, 4.8938, 1.8206, 4.3012)
    ..cubicTo(1.6825, 4.1214, 1.5261, 3.9859, 1.3792, 3.8208)
    ..cubicTo(1.1659, 3.5804, 1.0346, 3.2775, 1.0051, 2.9575)
    ..cubicTo(0.9697, 2.5647, 1.1072, 2.1191, 1.3645, 1.8198)
    ..cubicTo(1.5285, 1.6292, 1.7195, 1.4585, 1.9036, 1.2847)
    ..cubicTo(2.361, 0.8526, 2.6778, 0.4882, 3.3489, 0.4282)
    ..cubicTo(3.7443, 0.3929, 4.1951, 0.531, 4.4993, 0.7847)
    ..cubicTo(4.6499, 0.9103, 4.793, 1.0736, 4.9475, 1.2065)
    ..cubicTo(5.36, 1.5614, 5.835, 1.778, 6.3821, 1.811)
    ..cubicTo(7.1595, 1.8578, 7.8427, 1.5397, 8.386, 0.9975)
    ..cubicTo(8.5806, 0.8034, 8.8656, 0.4878, 9.0813, 0.3335)
    ..cubicTo(9.3522, 0.1428, 9.6699, 0.0288, 10.0003, 0.0044)
    ..close()
    ..moveTo(10.6995, 5.9761)
    ..cubicTo(10.4084, 5.3418, 9.5442, 5.3418, 9.2532, 5.9761)
    ..lineTo(8.4905, 7.6382)
    ..cubicTo(8.4848, 7.6506, 8.4719, 7.6613, 8.4553, 7.6636)
    ..lineTo(6.6995, 7.9048)
    ..cubicTo(6.0352, 7.9958, 5.7573, 8.8553, 6.2522, 9.3442)
    ..lineTo(7.5374, 10.6128)
    ..cubicTo(7.5478, 10.623, 7.5512, 10.6365, 7.5491, 10.6489)
    ..lineTo(7.2268, 12.4604)
    ..cubicTo(7.1019, 13.1622, 7.8115, 13.6814, 8.3968, 13.3511)
    ..lineTo(9.9534, 12.4722)
    ..cubicTo(9.9674, 12.4642, 9.9853, 12.4643, 9.9993, 12.4722)
    ..lineTo(11.5569, 13.3511)
    ..cubicTo(12.1421, 13.6811, 12.8508, 13.1621, 12.7259, 12.4604)
    ..lineTo(12.4036, 10.6489)
    ..cubicTo(12.4015, 10.6366, 12.4051, 10.623, 12.4153, 10.6128)
    ..lineTo(13.7005, 9.3442)
    ..cubicTo(14.1957, 8.8554, 13.9184, 7.996, 13.2542, 7.9048)
    ..lineTo(11.4973, 7.6636)
    ..cubicTo(11.4809, 7.6612, 11.4688, 7.6505, 11.4632, 7.6382)
    ..lineTo(10.6995, 5.9761)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _PoliceBadge._viewBoxWidth;
    final scaleY = size.height / _PoliceBadge._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_PoliceBadge._viewBoxMinX, -_PoliceBadge._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PoliceBadgePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/popcorn.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Popcorn extends StatelessWidget with _DotdartSvgSizing {
  const _Popcorn({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff060605.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Popcorn._svgWidth;

  @override
  double get svgNativeHeight => _Popcorn._svgHeight;

  @override
  double get svgViewBoxWidth => _Popcorn._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Popcorn._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PopcornPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff060605),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PopcornPainter extends CustomPainter {
  _PopcornPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.797835108,
    0.0,
    0.0,
    0.0,
    0.0,
    0.797835108,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.034115096,
    2.021648922,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(8.5395, 0.0118)
    ..cubicTo(8.74, -0.0176, 9.0854, 0.013, 9.2884, 0.048)
    ..cubicTo(10.1015, 0.1882, 10.8111, 0.6593, 11.2073, 1.39)
    ..cubicTo(11.2951, 1.5522, 11.4008, 1.9016, 11.4534, 1.9777)
    ..cubicTo(11.5023, 1.9931, 11.6085, 1.9518, 11.6541, 1.9321)
    ..cubicTo(12.7984, 1.4379, 14.2631, 1.9043, 14.5651, 3.205)
    ..cubicTo(14.5998, 3.3542, 14.5794, 3.5488, 14.6347, 3.6895)
    ..cubicTo(14.6557, 3.743, 15.0032, 3.805, 15.0626, 3.8452)
    ..cubicTo(15.6722, 4.0736, 16.1328, 4.6135, 16.141, 5.281)
    ..cubicTo(16.1451, 5.6197, 16.0321, 6.076, 15.6186, 6.0887)
    ..cubicTo(15.4222, 6.0968, 15.231, 6.096, 15.034, 6.096)
    ..lineTo(13.9155, 6.0956)
    ..lineTo(10.0985, 6.095)
    ..lineTo(4.9821, 6.0946)
    ..lineTo(3.5015, 6.0949)
    ..cubicTo(3.2418, 6.0949, 2.9696, 6.1026, 2.7112, 6.0861)
    ..cubicTo(2.4193, 6.0674, 2.2975, 5.7343, 2.2644, 5.4909)
    ..cubicTo(2.1894, 4.9392, 2.5083, 4.3973, 3.0062, 4.1616)
    ..cubicTo(3.0919, 4.121, 3.2687, 4.0744, 3.3478, 4.0152)
    ..cubicTo(3.4277, 3.8487, 3.4359, 3.6772, 3.5096, 3.4975)
    ..cubicTo(3.8276, 2.7226, 4.5807, 2.2391, 5.4032, 2.1726)
    ..cubicTo(5.5108, 2.1639, 5.9281, 2.2104, 5.96, 2.1195)
    ..cubicTo(6.0801, 1.7766, 6.199, 1.4568, 6.4296, 1.1655)
    ..cubicTo(6.9736, 0.4405, 7.6692, 0.1375, 8.5395, 0.0118)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(7.655, 7.1212)
    ..cubicTo(8.3885, 7.1055, 9.1337, 7.1285, 9.867, 7.1195)
    ..cubicTo(10.3, 7.1142, 10.8322, 7.0374, 11.1092, 7.4361)
    ..cubicTo(11.2095, 7.5804, 11.2592, 7.7306, 11.2562, 7.9081)
    ..cubicTo(11.2358, 8.3086, 11.1827, 8.7169, 11.1449, 9.1157)
    ..lineTo(10.8492, 12.0386)
    ..cubicTo(10.7221, 13.3809, 10.5876, 14.7224, 10.4455, 16.0632)
    ..cubicTo(10.3816, 16.6847, 10.3333, 17.4383, 10.2368, 18.0435)
    ..cubicTo(10.2056, 18.1845, 10.0759, 18.3143, 9.9277, 18.3153)
    ..cubicTo(9.3112, 18.3193, 8.6874, 18.3302, 8.0715, 18.3128)
    ..cubicTo(7.8424, 18.3062, 7.8031, 18.0502, 7.7855, 17.8712)
    ..lineTo(7.1982, 11.2897)
    ..lineTo(7.0057, 9.1098)
    ..lineTo(6.9354, 8.3338)
    ..cubicTo(6.9222, 8.1815, 6.9032, 8.0278, 6.905, 7.875)
    ..cubicTo(6.9102, 7.4258, 7.2286, 7.1573, 7.655, 7.1212)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(2.9381, 7.1217)
    ..cubicTo(3.3843, 7.1082, 3.824, 7.1223, 4.2878, 7.1184)
    ..cubicTo(4.9098, 7.1131, 5.6713, 6.9989, 5.7968, 7.8252)
    ..cubicTo(5.8206, 7.9819, 5.8433, 8.1451, 5.8643, 8.3023)
    ..lineTo(6.0072, 9.3816)
    ..lineTo(6.4786, 12.8982)
    ..lineTo(6.9183, 16.2703)
    ..cubicTo(6.969, 16.6532, 7.0174, 17.0362, 7.0637, 17.4196)
    ..cubicTo(7.0878, 17.6165, 7.1126, 17.8094, 7.13, 18.0074)
    ..cubicTo(7.1632, 18.3864, 6.7511, 18.3207, 6.49, 18.3207)
    ..cubicTo(5.8257, 18.3231, 5.4121, 18.3281, 4.8895, 17.855)
    ..cubicTo(4.4285, 17.4376, 4.3627, 16.946, 4.2328, 16.3818)
    ..cubicTo(4.1269, 15.9296, 4.0244, 15.4765, 3.9252, 15.0228)
    ..lineTo(3.1024, 11.3856)
    ..lineTo(2.5461, 8.9941)
    ..lineTo(2.3669, 8.2264)
    ..cubicTo(2.2974, 7.9231, 2.1553, 7.5561, 2.416, 7.305)
    ..cubicTo(2.5816, 7.1455, 2.7216, 7.1277, 2.9381, 7.1217)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(14.5875, 13.9096)
    ..cubicTo(15.3007, 13.8587, 16.0172, 14.3738, 16.1979, 15.0674)
    ..cubicTo(16.24, 15.2289, 16.2265, 15.4022, 16.2727, 15.5594)
    ..cubicTo(16.2791, 15.5813, 16.4301, 15.6223, 16.4618, 15.6296)
    ..cubicTo(16.7177, 15.6898, 16.9571, 15.8106, 17.1582, 15.9799)
    ..cubicTo(17.4805, 16.2463, 17.6815, 16.6316, 17.7156, 17.0483)
    ..cubicTo(17.7812, 17.8272, 17.3137, 18.4877, 16.5845, 18.737)
    ..cubicTo(16.525, 18.7694, 16.1635, 18.8044, 16.1386, 18.8464)
    ..cubicTo(16.042, 19.0088, 15.9504, 19.2256, 15.8131, 19.3765)
    ..cubicTo(15.4381, 19.7886, 15.0173, 19.9564, 14.4722, 20)
    ..cubicTo(13.6755, 20.001, 13.0553, 19.5968, 12.7648, 18.8536)
    ..cubicTo(12.3942, 18.7721, 12.1481, 18.7083, 11.8517, 18.4546)
    ..cubicTo(11.5199, 18.1584, 11.3418, 17.7934, 11.3057, 17.3477)
    ..cubicTo(11.2346, 16.473, 11.8867, 15.7053, 12.7597, 15.6299)
    ..cubicTo(13.1818, 15.5937, 13.0268, 15.5025, 13.0921, 15.1884)
    ..cubicTo(13.2488, 14.4343, 13.832, 13.9661, 14.5875, 13.9096)
    ..close();

  static final Path __path4 = Path()
    ..moveTo(13.0688, 7.1212)
    ..cubicTo(13.532, 7.1039, 14.0196, 7.1264, 14.4863, 7.1185)
    ..cubicTo(14.6727, 7.1153, 15.247, 7.0957, 15.406, 7.1341)
    ..cubicTo(16.1126, 7.3047, 15.8164, 8.0025, 15.6962, 8.4842)
    ..cubicTo(15.5838, 8.946, 15.4678, 9.4069, 15.3485, 9.8669)
    ..cubicTo(15.2529, 10.2488, 14.9552, 11.4128, 14.7253, 12.2558)
    ..cubicTo(14.5918, 12.745, 14.2308, 13.0906, 13.7446, 13.2349)
    ..cubicTo(13.3499, 13.3551, 12.9983, 13.587, 12.7324, 13.9026)
    ..cubicTo(12.618, 14.0459, 12.5714, 14.1464, 12.4818, 14.2968)
    ..cubicTo(12.4615, 14.3309, 12.4407, 14.3791, 12.4195, 14.4336)
    ..cubicTo(12.2965, 14.7505, 12.0489, 14.9549, 11.7315, 15.0764)
    ..cubicTo(11.4705, 15.1761, 11.294, 15.1033, 11.3307, 14.8264)
    ..cubicTo(11.3534, 14.6552, 11.3904, 14.4804, 11.4019, 14.3965)
    ..cubicTo(11.4979, 13.648, 11.6014, 12.9005, 11.7123, 12.1541)
    ..lineTo(12.1224, 9.2136)
    ..cubicTo(12.19, 8.7299, 12.2515, 8.2426, 12.329, 7.7607)
    ..cubicTo(12.3914, 7.3723, 12.6943, 7.1546, 13.0688, 7.1212)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Popcorn._viewBoxWidth;
    final scaleY = size.height / _Popcorn._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Popcorn._viewBoxMinX, -_Popcorn._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PopcornPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/praying-figure.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _PrayingFigure extends StatelessWidget with _DotdartSvgSizing {
  const _PrayingFigure({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _PrayingFigure._svgWidth;

  @override
  double get svgNativeHeight => _PrayingFigure._svgHeight;

  @override
  double get svgViewBoxWidth => _PrayingFigure._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _PrayingFigure._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PrayingFigurePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PrayingFigurePainter extends CustomPainter {
  _PrayingFigurePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.777398573,
    0.0,
    0.0,
    0.0,
    0.0,
    0.777398573,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.995224064,
    2.226014266,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(10.7739, 4.9322)
    ..cubicTo(11.7791, 4.8637, 12.7105, 5.3699, 13.1221, 6.3056)
    ..cubicTo(13.2325, 6.5568, 13.3206, 6.819, 13.4248, 7.0735)
    ..lineTo(14.0334, 8.586)
    ..cubicTo(14.3114, 8.0893, 14.6291, 7.5954, 14.9187, 7.1034)
    ..cubicTo(15.3277, 6.4085, 15.7327, 5.4649, 16.7238, 5.701)
    ..cubicTo(17.0175, 5.7735, 17.2706, 5.9591, 17.4279, 6.2173)
    ..cubicTo(17.6803, 6.6353, 17.6156, 7.0656, 17.4099, 7.4825)
    ..cubicTo(17.252, 7.8025, 17.1011, 8.1234, 16.9381, 8.442)
    ..cubicTo(16.6427, 9.0253, 16.3346, 9.6021, 16.014, 10.172)
    ..cubicTo(15.8304, 10.4978, 15.6617, 10.8057, 15.442, 11.1101)
    ..cubicTo(14.8458, 11.9355, 13.7705, 12.178, 12.9394, 11.5433)
    ..cubicTo(12.5777, 11.2671, 12.3852, 10.9029, 12.1619, 10.5172)
    ..cubicTo(12.023, 10.2781, 11.8819, 10.0404, 11.7387, 9.8038)
    ..cubicTo(11.2907, 10.561, 10.8382, 11.3154, 10.3811, 12.0671)
    ..cubicTo(10.2286, 12.3152, 10.0693, 12.5935, 9.9122, 12.8331)
    ..cubicTo(10.2708, 13.2425, 10.6792, 13.6702, 11.0504, 14.071)
    ..lineTo(12.3798, 15.5221)
    ..cubicTo(12.6225, 15.7848, 12.8635, 16.049, 13.1027, 16.3147)
    ..cubicTo(13.6352, 16.905, 14.004, 17.3608, 13.8838, 18.2159)
    ..cubicTo(13.8351, 18.6378, 13.5934, 19.0486, 13.3001, 19.3414)
    ..cubicTo(12.8236, 19.817, 12.4264, 19.9949, 11.7623, 19.9952)
    ..cubicTo(10.0515, 19.9963, 8.3398, 19.9997, 6.6297, 19.9975)
    ..lineTo(5.1601, 19.9972)
    ..cubicTo(4.8883, 19.997, 4.5722, 20.0119, 4.3066, 19.975)
    ..cubicTo(3.5753, 19.8731, 3.0031, 19.2667, 3, 18.5173)
    ..cubicTo(2.9976, 18.0918, 3.1671, 17.6833, 3.4701, 17.3847)
    ..cubicTo(3.7062, 17.1469, 4.0051, 16.9813, 4.3318, 16.907)
    ..cubicTo(4.665, 16.8313, 5.5234, 16.8586, 5.9045, 16.8587)
    ..lineTo(8.5856, 16.8587)
    ..cubicTo(8.4817, 16.7662, 8.3487, 16.6263, 8.2458, 16.5259)
    ..lineTo(7.4424, 15.7385)
    ..cubicTo(7.1526, 15.4597, 6.8643, 15.1793, 6.5775, 14.8976)
    ..cubicTo(6.3151, 14.6391, 6.0537, 14.3989, 5.8505, 14.0884)
    ..cubicTo(5.6444, 13.7708, 5.5159, 13.4094, 5.4753, 13.0331)
    ..cubicTo(5.3813, 12.0865, 5.8366, 11.3813, 6.2653, 10.5899)
    ..lineTo(7.2616, 8.7648)
    ..lineTo(8.1276, 7.19)
    ..cubicTo(8.3358, 6.8115, 8.6169, 6.2682, 8.8848, 5.9413)
    ..cubicTo(9.3535, 5.365, 10.0343, 5.0013, 10.7739, 4.9322)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(14.3574, 0.0001)
    ..cubicTo(15.7841, -0.0094, 16.948, 1.14, 16.9566, 2.5666)
    ..cubicTo(16.9652, 3.9933, 15.8151, 5.1566, 14.3885, 5.1643)
    ..cubicTo(12.9631, 5.1721, 11.801, 4.0232, 11.7924, 2.5977)
    ..cubicTo(11.7838, 1.1723, 12.932, 0.0095, 14.3574, 0.0001)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _PrayingFigure._viewBoxWidth;
    final scaleY = size.height / _PrayingFigure._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_PrayingFigure._viewBoxMinX, -_PrayingFigure._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PrayingFigurePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/questionmark.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Questionmark extends StatelessWidget with _DotdartSvgSizing {
  const _Questionmark({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Questionmark._svgWidth;

  @override
  double get svgNativeHeight => _Questionmark._svgHeight;

  @override
  double get svgViewBoxWidth => _Questionmark._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Questionmark._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _QuestionmarkPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _QuestionmarkPainter extends CustomPainter {
  _QuestionmarkPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.671589851,
    0.0,
    0.0,
    0.0,
    0.0,
    0.671589851,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.326075855,
    3.284101489,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(4, 4.8158)
    ..cubicTo(4, 4.3587, 4.107, 3.8275, 4.3441, 3.2968)
    ..cubicTo(5.2926, 1.1464, 7.4822, 0, 9.8893, 0)
    ..cubicTo(11.4952, 0, 12.983, 0.455, 14.0807, 1.3475)
    ..cubicTo(15.1895, 2.2492, 15.8672, 3.5732, 15.8674, 5.2224)
    ..cubicTo(15.8674, 7.3922, 14.6196, 8.8637, 12.842, 10.0632)
    ..lineTo(12.8433, 10.0644)
    ..cubicTo(12.0464, 10.6123, 11.603, 10.9775, 11.3444, 11.3331)
    ..cubicTo(11.1094, 11.6563, 11.0042, 12.0041, 10.9953, 12.5881)
    ..lineTo(10.9953, 12.9184)
    ..cubicTo(10.9952, 13.3169, 10.8965, 13.7302, 10.6262, 14.0532)
    ..cubicTo(10.3434, 14.3909, 9.9302, 14.5612, 9.4514, 14.5612)
    ..cubicTo(8.9875, 14.5611, 8.5752, 14.4058, 8.284, 14.0832)
    ..cubicTo(8.0003, 13.7688, 7.8874, 13.3574, 7.8874, 12.9471)
    ..lineTo(7.8874, 12.3216)
    ..cubicTo(7.8874, 10.2912, 9.2348, 8.9885, 10.8189, 7.8887)
    ..cubicTo(12.0875, 6.9964, 12.7492, 6.3424, 12.7495, 5.2136)
    ..cubicTo(12.7495, 4.5203, 12.4505, 3.9643, 11.9487, 3.5696)
    ..cubicTo(11.4368, 3.1671, 10.6937, 2.9202, 9.8192, 2.9202)
    ..cubicTo(9.0962, 2.9203, 8.501, 3.0818, 8.0388, 3.4144)
    ..cubicTo(7.581, 3.7441, 7.2001, 4.2806, 6.9715, 5.1323)
    ..lineTo(6.9665, 5.1498)
    ..cubicTo(6.8684, 5.4702, 6.6962, 5.7648, 6.431, 5.9806)
    ..cubicTo(6.161, 6.2002, 5.8284, 6.3096, 5.4651, 6.3097)
    ..cubicTo(5.0409, 6.3097, 4.6565, 6.167, 4.3816, 5.8705)
    ..cubicTo(4.1123, 5.58, 4.0001, 5.1986, 4, 4.8158)
    ..close()
    ..moveTo(11.4032, 18.0582)
    ..cubicTo(11.4029, 19.1262, 10.5393, 20, 9.4514, 20)
    ..cubicTo(8.3834, 19.9999, 7.5098, 19.1261, 7.5095, 18.0582)
    ..cubicTo(7.5095, 16.9776, 8.3856, 16.1152, 9.4514, 16.1151)
    ..cubicTo(10.5371, 16.1151, 11.4032, 16.9775, 11.4032, 18.0582)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Questionmark._viewBoxWidth;
    final scaleY = size.height / _Questionmark._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Questionmark._viewBoxMinX, -_Questionmark._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _QuestionmarkPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/rectangle-stack.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _RectangleStack extends StatelessWidget with _DotdartSvgSizing {
  const _RectangleStack({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _RectangleStack._svgWidth;

  @override
  double get svgNativeHeight => _RectangleStack._svgHeight;

  @override
  double get svgViewBoxWidth => _RectangleStack._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _RectangleStack._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _RectangleStackPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _RectangleStackPainter extends CustomPainter {
  _RectangleStackPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.747177688,
    0.0,
    0.0,
    0.0,
    0.0,
    0.747177688,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.52822312,
    2.52822312,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(17.9429, 4.2286)
    ..cubicTo(17.6371, 4.1729, 17.3129, 4.1453, 16.972, 4.1453)
    ..lineTo(3.0278, 4.1453)
    ..cubicTo(2.6869, 4.1453, 2.3628, 4.1729, 2.0571, 4.2285)
    ..cubicTo(2.1606, 3.183, 2.7786, 2.6, 3.7882, 2.6)
    ..lineTo(16.2211, 2.6)
    ..cubicTo(17.2308, 2.6, 17.8409, 3.183, 17.9429, 4.2286)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(3.7143, 1.3714)
    ..lineTo(16.2857, 1.3714)
    ..cubicTo(16.2448, 0.5006, 15.734, 0, 14.8855, 0)
    ..lineTo(5.1145, 0)
    ..cubicTo(4.2661, 0, 3.7552, 0.5006, 3.7143, 1.3714)
    ..close();

  static final RRect _rrect0 = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 5.4286, 20, 14.5714),
    const Radius.circular(3.8988),
  );

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _RectangleStack._viewBoxWidth;
    final scaleY = size.height / _RectangleStack._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_RectangleStack._viewBoxMinX, -_RectangleStack._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawRRect(_rrect0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RectangleStackPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/road.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Road extends StatelessWidget with _DotdartSvgSizing {
  const _Road({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Road._svgWidth;

  @override
  double get svgNativeHeight => _Road._svgHeight;

  @override
  double get svgViewBoxWidth => _Road._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Road._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _RoadPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _RoadPainter extends CustomPainter {
  _RoadPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.809329733,
    0.0,
    0.0,
    0.0,
    0.0,
    0.809329733,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.906702669,
    1.906702669,
    0.0,
    1.0,
  ]);
  static final RRect _rrect0 = RRect.fromRectAndRadius(
    const Rect.fromLTWH(8.3402, 0.6846, 2.7386, 4.4191),
    const Radius.circular(1.3693),
  );

  static final RRect _rrect1 = RRect.fromRectAndRadius(
    const Rect.fromLTWH(8.3402, 7.78, 2.7386, 4.4191),
    const Radius.circular(1.3693),
  );

  static final RRect _rrect2 = RRect.fromRectAndRadius(
    const Rect.fromLTWH(8.3402, 14.8754, 2.7386, 4.4191),
    const Radius.circular(1.3693),
  );

  static final RRect _rrect3 = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 0, 2.9253, 19.9791),
    const Radius.circular(1.4626),
  );

  static final RRect _rrect4 = RRect.fromRectAndRadius(
    const Rect.fromLTWH(17.0538, 0, 2.9253, 19.9791),
    const Radius.circular(1.4626),
  );

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Road._viewBoxWidth;
    final scaleY = size.height / _Road._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Road._viewBoxMinX, -_Road._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawRRect(_rrect0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawRRect(_rrect1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawRRect(_rrect2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawRRect(_rrect3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawRRect(_rrect4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RoadPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/running-figure.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _RunningFigure extends StatelessWidget with _DotdartSvgSizing {
  const _RunningFigure({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _RunningFigure._svgWidth;

  @override
  double get svgNativeHeight => _RunningFigure._svgHeight;

  @override
  double get svgViewBoxWidth => _RunningFigure._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _RunningFigure._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _RunningFigurePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _RunningFigurePainter extends CustomPainter {
  _RunningFigurePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.823381148,
    0.0,
    0.0,
    0.0,
    0.0,
    0.823381148,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.521747239,
    1.766188517,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(8.0221, 4.2466)
    ..cubicTo(8.5126, 4.2562, 9.1967, 4.3744, 9.7106, 4.4399)
    ..cubicTo(10.5039, 4.541, 11.5114, 4.5869, 12.2584, 4.8369)
    ..cubicTo(12.6534, 4.9691, 13.403, 5.4136, 13.6657, 5.7158)
    ..cubicTo(14.2232, 6.3563, 14.6511, 7.1926, 15.1274, 7.9097)
    ..cubicTo(15.4894, 7.6003, 15.8423, 7.2706, 16.2, 6.9553)
    ..cubicTo(16.6415, 6.566, 17.0176, 6.0976, 17.682, 6.2156)
    ..cubicTo(17.9736, 6.2675, 18.2307, 6.4381, 18.3917, 6.6866)
    ..cubicTo(18.7104, 7.1732, 18.592, 7.8219, 18.165, 8.1965)
    ..cubicTo(17.7976, 8.5187, 17.4306, 8.8412, 17.0625, 9.1627)
    ..cubicTo(16.7319, 9.4522, 16.4, 9.7398, 16.0666, 10.026)
    ..cubicTo(15.8735, 10.1911, 15.6728, 10.3652, 15.4671, 10.5122)
    ..cubicTo(15.1063, 10.7701, 14.3973, 10.6947, 14.1111, 10.3518)
    ..cubicTo(13.6659, 9.8185, 13.2787, 9.1463, 12.9094, 8.5507)
    ..cubicTo(12.7511, 8.8675, 12.4906, 9.2959, 12.3102, 9.6095)
    ..cubicTo(11.9859, 10.1853, 11.6553, 10.7571, 11.318, 11.3251)
    ..cubicTo(11.9757, 11.7361, 12.6631, 12.1122, 13.3329, 12.5032)
    ..cubicTo(13.6416, 12.6836, 13.9917, 12.8667, 14.2828, 13.0703)
    ..cubicTo(14.4029, 13.1544, 14.5891, 13.3632, 14.6466, 13.4958)
    ..cubicTo(14.8267, 13.9116, 14.8397, 14.2222, 14.6739, 14.6449)
    ..cubicTo(14.2661, 15.6837, 13.8237, 16.7066, 13.4058, 17.7402)
    ..lineTo(12.9816, 18.8017)
    ..cubicTo(12.7906, 19.2806, 12.6638, 19.6842, 12.1452, 19.9062)
    ..cubicTo(11.8634, 20.0274, 11.5452, 20.0313, 11.2606, 19.9172)
    ..cubicTo(10.956, 19.7941, 10.7156, 19.5509, 10.5958, 19.245)
    ..cubicTo(10.3623, 18.658, 10.6725, 18.1306, 10.8971, 17.5911)
    ..lineTo(11.5506, 16.0318)
    ..cubicTo(11.749, 15.5614, 11.9432, 15.0893, 12.1335, 14.6157)
    ..cubicTo(11.0625, 14.0206, 9.9887, 13.3514, 8.9036, 12.7454)
    ..lineTo(7.8525, 14.7214)
    ..cubicTo(7.5727, 15.2491, 7.3312, 15.9341, 6.7621, 16.1879)
    ..cubicTo(5.8114, 16.6121, 4.7927, 16.9947, 3.8457, 17.4111)
    ..cubicTo(2.4016, 18.0458, 1.3372, 16.2896, 2.4858, 15.3)
    ..cubicTo(2.7435, 15.0802, 3.3934, 14.8736, 3.7305, 14.7305)
    ..cubicTo(4.335, 14.4743, 4.9737, 14.2458, 5.5816, 13.981)
    ..cubicTo(6.2461, 12.8143, 6.8856, 11.5928, 7.5397, 10.4177)
    ..cubicTo(8.2222, 9.1919, 8.9712, 7.9539, 9.6275, 6.7188)
    ..cubicTo(9.3712, 6.7142, 8.7263, 6.6312, 8.4657, 6.5898)
    ..lineTo(7.0744, 8.3226)
    ..cubicTo(6.7126, 8.77, 6.3883, 9.3303, 5.7696, 9.3953)
    ..cubicTo(5.47, 9.4251, 5.1706, 9.3357, 4.9363, 9.1466)
    ..cubicTo(4.7031, 8.9555, 4.5573, 8.6781, 4.5323, 8.3777)
    ..cubicTo(4.5085, 8.0779, 4.6016, 7.8214, 4.7889, 7.5899)
    ..cubicTo(5.5572, 6.6405, 6.3154, 5.6826, 7.0856, 4.7347)
    ..cubicTo(7.3426, 4.4184, 7.6214, 4.2823, 8.0221, 4.2466)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(13.7463, 0.0152)
    ..cubicTo(15.0029, -0.1291, 16.1386, 0.7726, 16.2827, 2.0292)
    ..cubicTo(16.4271, 3.2858, 15.5253, 4.4215, 14.2687, 4.5657)
    ..cubicTo(13.0121, 4.7099, 11.8766, 3.8082, 11.7323, 2.5516)
    ..cubicTo(11.5881, 1.2951, 12.4897, 0.1594, 13.7463, 0.0152)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _RunningFigure._viewBoxWidth;
    final scaleY = size.height / _RunningFigure._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_RunningFigure._viewBoxMinX, -_RunningFigure._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RunningFigurePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/sad-emoticon.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _SadEmoticon extends StatelessWidget with _DotdartSvgSizing {
  const _SadEmoticon({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _SadEmoticon._svgWidth;

  @override
  double get svgNativeHeight => _SadEmoticon._svgHeight;

  @override
  double get svgViewBoxWidth => _SadEmoticon._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _SadEmoticon._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _SadEmoticonPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _SadEmoticonPainter extends CustomPainter {
  _SadEmoticonPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.71944682,
    0.0,
    0.0,
    0.0,
    0.0,
    0.71944682,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.839255869,
    2.805531799,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(14.078, 19.1552)
    ..cubicTo(10.6663, 13.1367, 10.761, 6.0186, 14.1889, 0.7573)
    ..cubicTo(14.6913, -0.0137, 15.7238, -0.2321, 16.495, 0.2701)
    ..cubicTo(17.266, 0.7725, 17.4844, 1.805, 16.9823, 2.5762)
    ..cubicTo(14.2971, 6.697, 14.1217, 12.4724, 16.9782, 17.5114)
    ..cubicTo(17.432, 18.312, 17.151, 19.3288, 16.3506, 19.7829)
    ..cubicTo(15.5498, 20.2368, 14.532, 19.956, 14.078, 19.1552)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(7.8677, 14.5)
    ..cubicTo(7.8677, 15.9382, 6.7018, 17.1041, 5.2636, 17.1041)
    ..cubicTo(3.8253, 17.1041, 2.6594, 15.9382, 2.6594, 14.5)
    ..cubicTo(2.6594, 13.0618, 3.8253, 11.8959, 5.2636, 11.8959)
    ..cubicTo(6.7018, 11.8959, 7.8677, 13.0618, 7.8677, 14.5)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(7.8677, 6.1667)
    ..cubicTo(7.8677, 7.605, 6.7018, 8.7709, 5.2636, 8.7709)
    ..cubicTo(3.8253, 8.7709, 2.6594, 7.605, 2.6594, 6.1667)
    ..cubicTo(2.6594, 4.7285, 3.8253, 3.5626, 5.2636, 3.5626)
    ..cubicTo(6.7018, 3.5626, 7.8677, 4.7285, 7.8677, 6.1667)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _SadEmoticon._viewBoxWidth;
    final scaleY = size.height / _SadEmoticon._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_SadEmoticon._viewBoxMinX, -_SadEmoticon._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SadEmoticonPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/sad-mask-happy-mask.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _SadMaskHappyMask extends StatelessWidget with _DotdartSvgSizing {
  const _SadMaskHappyMask({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _SadMaskHappyMask._svgWidth;

  @override
  double get svgNativeHeight => _SadMaskHappyMask._svgHeight;

  @override
  double get svgViewBoxWidth => _SadMaskHappyMask._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _SadMaskHappyMask._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _SadMaskHappyMaskPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _SadMaskHappyMaskPainter extends CustomPainter {
  _SadMaskHappyMaskPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.820724592,
    0.0,
    0.0,
    0.0,
    0.0,
    0.820724592,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.805577902,
    1.57474911,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(8.9694, 0.6141)
    ..cubicTo(9.5669, 0.5714, 10.3042, 0.6785, 10.7655, 1.0865)
    ..cubicTo(11.0204, 1.3119, 11.2099, 1.6124, 11.3267, 1.9315)
    ..cubicTo(11.5758, 2.6126, 11.6528, 3.4121, 11.7523, 4.1307)
    ..cubicTo(11.8302, 4.6925, 11.8906, 5.2811, 11.9407, 5.8442)
    ..cubicTo(11.9566, 6.0221, 12.0328, 6.5077, 11.8896, 6.6048)
    ..cubicTo(11.784, 6.6765, 11.5497, 6.5891, 11.3554, 6.5563)
    ..cubicTo(11.0972, 6.5126, 10.7726, 6.5077, 10.4812, 6.5563)
    ..cubicTo(9.4128, 6.6534, 8.5134, 7.3515, 8.1715, 8.4223)
    ..cubicTo(8.154, 8.4771, 8.0243, 8.5574, 7.9604, 8.5409)
    ..cubicTo(7.6454, 8.4595, 7.3461, 8.349, 7.0129, 8.3556)
    ..cubicTo(5.7643, 8.3468, 4.53, 9.202, 4.4946, 10.5263)
    ..cubicTo(4.4958, 11.0693, 4.7278, 11.2789, 5.2258, 10.9712)
    ..cubicTo(5.81, 10.6108, 6.4409, 10.3678, 7.1284, 10.3093)
    ..cubicTo(7.3027, 10.2945, 7.584, 10.2886, 7.5276, 10.5384)
    ..cubicTo(7.328, 11.4243, 7.1747, 12.2312, 7.165, 13.146)
    ..cubicTo(7.1411, 13.2829, 7.0553, 13.3341, 6.9192, 13.3411)
    ..cubicTo(6.7218, 13.3512, 6.5166, 13.3282, 6.3207, 13.3013)
    ..cubicTo(5.2065, 13.1482, 4.201, 12.5696, 3.3603, 11.8437)
    ..cubicTo(1.6371, 10.3544, 0.8302, 8.3223, 0.4249, 6.1333)
    ..cubicTo(0.3151, 5.5396, 0.1982, 4.9466, 0.1495, 4.3402)
    ..cubicTo(0.0986, 3.7067, 0.1892, 3.1319, 0.6182, 2.6374)
    ..cubicTo(0.8873, 2.3274, 1.2915, 2.0928, 1.6792, 1.9636)
    ..cubicTo(2.044, 1.842, 2.4909, 1.7844, 2.8735, 1.7233)
    ..cubicTo(3.3186, 1.6538, 3.7625, 1.5763, 4.2049, 1.4908)
    ..cubicTo(4.996, 1.3384, 5.7852, 1.1764, 6.5724, 1.0047)
    ..cubicTo(7.3353, 0.8446, 8.1937, 0.6646, 8.9694, 0.6141)
    ..close()
    ..moveTo(9.3258, 5.6939)
    ..cubicTo(9.5423, 5.5565, 9.7884, 5.3379, 9.8434, 5.0759)
    ..cubicTo(9.926, 4.6826, 9.3634, 4.6796, 9.112, 4.6344)
    ..cubicTo(8.6011, 4.5425, 8.2031, 4.2642, 7.7703, 4.0034)
    ..cubicTo(7.6562, 3.9346, 7.5269, 3.9045, 7.3919, 3.9177)
    ..cubicTo(7.0028, 4.0104, 7.0752, 4.5042, 7.1492, 4.7955)
    ..cubicTo(7.3563, 5.61, 8.0971, 6.102, 8.9306, 5.8709)
    ..cubicTo(9.07, 5.8308, 9.2031, 5.7712, 9.3258, 5.6939)
    ..close()
    ..moveTo(3.0384, 6.699)
    ..cubicTo(3.8571, 6.9481, 4.6558, 6.5113, 4.9084, 5.6953)
    ..cubicTo(5.0192, 5.3376, 5.0724, 4.3862, 4.4947, 4.4321)
    ..cubicTo(4.2022, 4.5104, 4.0286, 4.8107, 3.8231, 5.0235)
    ..cubicTo(3.6827, 5.169, 3.5961, 5.269, 3.4269, 5.3951)
    ..cubicTo(3.2765, 5.5056, 3.1173, 5.6036, 2.951, 5.6882)
    ..cubicTo(2.7362, 5.7999, 2.3743, 5.9343, 2.459, 6.2442)
    ..cubicTo(2.5229, 6.4782, 2.8288, 6.625, 3.0384, 6.699)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(10.7431, 7.583)
    ..cubicTo(11.2051, 7.5401, 11.7286, 7.7061, 12.1591, 7.8679)
    ..cubicTo(12.6719, 8.0607, 13.1792, 8.2655, 13.6976, 8.4438)
    ..cubicTo(14.4344, 8.6941, 15.1828, 8.9087, 15.9404, 9.0869)
    ..cubicTo(16.3861, 9.1917, 16.784, 9.2671, 17.2351, 9.3468)
    ..cubicTo(17.6606, 9.4221, 18.0616, 9.4859, 18.469, 9.6317)
    ..cubicTo(19.4004, 9.9652, 19.9626, 10.7187, 19.798, 11.7265)
    ..cubicTo(19.7083, 12.2765, 19.5436, 12.7913, 19.3746, 13.3261)
    ..cubicTo(18.8394, 15.0197, 18.096, 16.7265, 16.86, 18.0309)
    ..cubicTo(16.621, 18.2818, 16.274, 18.5689, 15.9996, 18.7742)
    ..cubicTo(15.0734, 19.4084, 14.1874, 19.8262, 13.0526, 19.9213)
    ..cubicTo(11.9612, 20.0164, 10.9173, 19.7267, 10.0897, 18.9926)
    ..cubicTo(8.7709, 17.8227, 8.2055, 16.1692, 8.074, 14.4583)
    ..cubicTo(8.0382, 13.9271, 8.0481, 13.3938, 8.1037, 12.8643)
    ..cubicTo(8.1989, 11.944, 8.4126, 10.9826, 8.6607, 10.093)
    ..cubicTo(8.98, 8.9482, 9.3481, 7.6802, 10.7431, 7.583)
    ..close()
    ..moveTo(14.736, 16.9598)
    ..cubicTo(14.9224, 16.808, 15.0964, 16.6208, 15.2381, 16.4269)
    ..cubicTo(15.3613, 16.258, 15.6285, 15.8927, 15.4562, 15.6889)
    ..cubicTo(15.2865, 15.4881, 14.8472, 15.6732, 14.6222, 15.7089)
    ..cubicTo(13.9532, 15.8164, 13.2683, 15.767, 12.6218, 15.5645)
    ..cubicTo(12.0699, 15.3925, 11.5535, 15.1227, 11.0973, 14.7681)
    ..cubicTo(10.8896, 14.6083, 10.7202, 14.342, 10.4425, 14.357)
    ..cubicTo(10.356, 14.3832, 10.3017, 14.4134, 10.2581, 14.4979)
    ..cubicTo(10.1127, 14.7797, 10.2587, 15.3983, 10.3462, 15.6851)
    ..cubicTo(10.5742, 16.4333, 11.0213, 17.058, 11.7244, 17.424)
    ..cubicTo(12.3293, 17.7389, 13.0236, 17.7776, 13.6711, 17.5681)
    ..cubicTo(14.0638, 17.4402, 14.4263, 17.2332, 14.736, 16.9598)
    ..close()
    ..moveTo(16.3373, 13.522)
    ..cubicTo(16.4144, 13.57, 16.4803, 13.6141, 16.5489, 13.6705)
    ..cubicTo(16.6585, 13.7606, 16.8299, 13.9185, 16.9841, 13.8713)
    ..cubicTo(17.2958, 13.7761, 17.2066, 13.2651, 17.1349, 13.0331)
    ..cubicTo(17.0025, 12.6213, 16.7326, 12.2518, 16.3463, 12.0491)
    ..cubicTo(16.1472, 11.9449, 15.8156, 11.8668, 15.5943, 11.9047)
    ..cubicTo(15.2083, 11.9485, 14.8908, 12.1211, 14.6408, 12.4304)
    ..cubicTo(14.5145, 12.5868, 14.2454, 13.0512, 14.4795, 13.2323)
    ..cubicTo(14.5815, 13.3113, 14.8762, 13.2349, 15.0159, 13.2201)
    ..cubicTo(15.0991, 13.2119, 15.1826, 13.2085, 15.2661, 13.2099)
    ..cubicTo(15.6362, 13.2163, 16.0256, 13.3187, 16.3373, 13.522)
    ..close()
    ..moveTo(12.0511, 12.3079)
    ..cubicTo(12.0981, 12.3385, 12.1877, 12.3946, 12.2286, 12.4325)
    ..cubicTo(12.5609, 12.74, 12.8632, 12.9153, 12.9742, 12.3009)
    ..cubicTo(13.072, 11.7589, 12.7932, 11.2304, 12.3251, 10.9448)
    ..cubicTo(12.1187, 10.8198, 11.7553, 10.719, 11.5119, 10.7599)
    ..cubicTo(11.0688, 10.8009, 10.6779, 10.9865, 10.3918, 11.3321)
    ..cubicTo(10.2788, 11.4683, 10.1774, 11.626, 10.1853, 11.8082)
    ..cubicTo(10.1902, 11.9224, 10.3062, 12.0109, 10.4095, 12.0047)
    ..cubicTo(10.673, 11.989, 10.8947, 11.9526, 11.1644, 11.9859)
    ..cubicTo(11.4806, 12.0243, 11.7839, 12.1346, 12.0511, 12.3079)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _SadMaskHappyMask._viewBoxWidth;
    final scaleY = size.height / _SadMaskHappyMask._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_SadMaskHappyMask._viewBoxMinX,
        -_SadMaskHappyMask._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SadMaskHappyMaskPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/scissors.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Scissors extends StatelessWidget with _DotdartSvgSizing {
  const _Scissors({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Scissors._svgWidth;

  @override
  double get svgNativeHeight => _Scissors._svgHeight;

  @override
  double get svgViewBoxWidth => _Scissors._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Scissors._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ScissorsPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ScissorsPainter extends CustomPainter {
  _ScissorsPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.797848742,
    0.0,
    0.0,
    0.0,
    0.0,
    0.797848742,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.02151258,
    2.196041992,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(3.5891, 2.0106)
    ..cubicTo(3.9789, 1.9628, 4.6334, 2.0847, 5.0015, 2.2146)
    ..cubicTo(6.3595, 2.6825, 7.2873, 3.8971, 7.3473, 5.2855)
    ..cubicTo(7.3576, 5.5129, 7.2762, 6.0445, 7.367, 6.2239)
    ..cubicTo(7.4444, 6.3766, 7.5808, 6.5288, 7.7075, 6.646)
    ..cubicTo(8.0068, 6.9228, 9.5375, 8.0562, 9.9027, 8.1676)
    ..cubicTo(10.0103, 8.2004, 10.0973, 8.1749, 10.1971, 8.1301)
    ..cubicTo(10.3614, 8.0565, 10.5179, 7.9547, 10.6729, 7.8645)
    ..lineTo(11.4769, 7.398)
    ..cubicTo(12.4608, 6.8353, 13.5211, 6.2149, 14.5179, 5.7006)
    ..cubicTo(15.6927, 5.0946, 17.3843, 4.2743, 18.7282, 4.6891)
    ..cubicTo(19.1895, 4.817, 19.6831, 5.1211, 19.9098, 5.5442)
    ..cubicTo(20.3378, 6.3434, 19.135, 6.9097, 18.565, 7.2043)
    ..cubicTo(18.1321, 7.4269, 17.6949, 7.6418, 17.2536, 7.8487)
    ..cubicTo(16.4235, 8.2452, 15.5899, 8.6352, 14.7532, 9.0186)
    ..cubicTo(14.1355, 9.3003, 13.4638, 9.5874, 12.8594, 9.8834)
    ..cubicTo(13, 9.9593, 13.2404, 10.0561, 13.3939, 10.1223)
    ..cubicTo(13.7475, 10.2763, 14.1032, 10.4259, 14.4609, 10.5708)
    ..cubicTo(15.4154, 10.9653, 16.3288, 11.3478, 17.2994, 11.7111)
    ..lineTo(18.4195, 12.1313)
    ..cubicTo(19.1156, 12.3992, 20.3583, 12.9025, 19.734, 13.8137)
    ..cubicTo(19.0278, 14.8446, 17.6619, 15.1075, 16.4835, 14.8788)
    ..cubicTo(15.1482, 14.6199, 14.056, 14.0666, 12.9185, 13.3931)
    ..cubicTo(12.5462, 13.1246, 12.1471, 12.89, 11.7751, 12.6179)
    ..cubicTo(11.4208, 12.3588, 11.071, 12.0939, 10.7129, 11.8393)
    ..cubicTo(10.5539, 11.7263, 10.3945, 11.5983, 10.2204, 11.5087)
    ..cubicTo(10.0812, 11.437, 9.9742, 11.4264, 9.8222, 11.4713)
    ..cubicTo(9.2567, 11.6379, 7.4919, 12.7873, 7.3337, 13.3385)
    ..cubicTo(7.2736, 13.548, 7.3205, 13.7685, 7.3304, 13.9815)
    ..cubicTo(7.3565, 14.547, 7.1989, 15.1354, 6.9203, 15.6316)
    ..cubicTo(6.4334, 16.4987, 5.557, 17.1312, 4.582, 17.4081)
    ..cubicTo(3.6651, 17.6684, 2.6161, 17.587, 1.7752, 17.141)
    ..cubicTo(0.9746, 16.7165, 0.3843, 15.9999, 0.137, 15.1523)
    ..cubicTo(-0.7089, 12.2691, 2.5329, 10.2012, 5.1826, 11.1559)
    ..cubicTo(5.8017, 11.379, 5.8669, 11.6295, 6.5557, 11.2344)
    ..cubicTo(7.2813, 10.8186, 7.9229, 10.2809, 8.3852, 9.5971)
    ..lineTo(8.3921, 9.5841)
    ..cubicTo(8.244, 9.4566, 8.093, 9.3323, 7.9393, 9.2113)
    ..cubicTo(7.4544, 8.8283, 6.7205, 8.3076, 6.095, 8.1619)
    ..cubicTo(5.8515, 8.1052, 5.5033, 8.3134, 5.2725, 8.4217)
    ..cubicTo(3.9717, 9.0321, 2.3699, 8.9387, 1.2378, 8.0341)
    ..cubicTo(0.5489, 7.4785, 0.117, 6.6821, 0.0371, 5.8198)
    ..cubicTo(-0.0492, 4.9251, 0.2356, 4.0339, 0.8292, 3.3408)
    ..cubicTo(1.5519, 2.5067, 2.4835, 2.1053, 3.5891, 2.0106)
    ..close()
    ..moveTo(5.6448, 14.1141)
    ..cubicTo(5.684, 15.1638, 4.832, 16.0451, 3.7424, 16.0819)
    ..cubicTo(2.6544, 16.1185, 1.7412, 15.299, 1.702, 14.2508)
    ..cubicTo(1.6629, 13.2024, 2.5126, 12.3219, 3.6005, 12.2831)
    ..cubicTo(4.69, 12.2442, 5.6056, 13.0643, 5.6448, 14.1141)
    ..close()
    ..moveTo(5.6437, 5.3624)
    ..cubicTo(5.7008, 6.3979, 4.8793, 7.2836, 3.8049, 7.345)
    ..cubicTo(2.721, 7.4069, 1.792, 6.607, 1.7345, 5.5624)
    ..cubicTo(1.6769, 4.5178, 2.5128, 3.6276, 3.5973, 3.5785)
    ..cubicTo(4.6725, 3.5299, 5.5867, 4.3268, 5.6437, 5.3624)
    ..close()
    ..moveTo(11.0505, 9.7756)
    ..cubicTo(11.0707, 10.1063, 10.8086, 10.3903, 10.4653, 10.4097)
    ..cubicTo(10.122, 10.429, 9.8274, 10.1766, 9.8073, 9.8459)
    ..cubicTo(9.7871, 9.5151, 10.0492, 9.2312, 10.3925, 9.2118)
    ..cubicTo(10.7358, 9.1924, 11.0303, 9.4448, 11.0505, 9.7756)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Scissors._viewBoxWidth;
    final scaleY = size.height / _Scissors._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Scissors._viewBoxMinX, -_Scissors._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScissorsPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/shopping-bag.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ShoppingBag extends StatelessWidget with _DotdartSvgSizing {
  const _ShoppingBag({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ShoppingBag._svgWidth;

  @override
  double get svgNativeHeight => _ShoppingBag._svgHeight;

  @override
  double get svgViewBoxWidth => _ShoppingBag._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ShoppingBag._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ShoppingBagPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ShoppingBagPainter extends CustomPainter {
  _ShoppingBagPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.748048865,
    0.0,
    0.0,
    0.0,
    0.0,
    0.748048865,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.51951135,
    2.51951135,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(9.8478, 0.0015)
    ..cubicTo(11.3695, -0.0336, 12.9879, 0.5701, 13.9845, 1.8794)
    ..cubicTo(14.574, 2.6539, 14.7865, 3.5015, 14.8703, 4.4077)
    ..cubicTo(14.9037, 4.7699, 14.9144, 5.17, 14.9211, 5.5991)
    ..cubicTo(15.211, 5.6572, 15.4664, 5.7375, 15.7052, 5.8482)
    ..cubicTo(16.4677, 6.2015, 17.1107, 6.7692, 17.5558, 7.482)
    ..cubicTo(18.061, 8.291, 18.1957, 9.3643, 18.464, 11.5113)
    ..lineTo(18.5519, 12.2173)
    ..cubicTo(18.8881, 14.9067, 19.0564, 16.2518, 18.6349, 17.2945)
    ..cubicTo(18.2648, 18.2099, 17.5931, 18.9718, 16.7306, 19.4527)
    ..cubicTo(15.7483, 20.0003, 14.3923, 19.9995, 11.6818, 19.9995)
    ..lineTo(8.3136, 19.9995)
    ..cubicTo(5.6104, 19.9995, 4.2585, 20.0003, 3.2775, 19.4546)
    ..cubicTo(2.4162, 18.9755, 1.7446, 18.2162, 1.3732, 17.3032)
    ..cubicTo(0.9503, 16.2633, 1.1141, 14.9212, 1.4416, 12.2378)
    ..lineTo(1.5275, 11.5318)
    ..cubicTo(1.7904, 9.378, 1.9212, 8.3005, 2.4259, 7.4888)
    ..cubicTo(2.8706, 6.7737, 3.5147, 6.2039, 4.2785, 5.8491)
    ..cubicTo(4.5231, 5.7355, 4.7853, 5.6547, 5.0841, 5.5962)
    ..cubicTo(5.0888, 5.2485, 5.0982, 4.9193, 5.1242, 4.6099)
    ..cubicTo(5.1963, 3.7505, 5.3773, 2.9519, 5.8283, 2.2046)
    ..cubicTo(6.7225, 0.723, 8.3198, 0.0368, 9.8478, 0.0015)
    ..close()
    ..moveTo(14.0441, 10.2427)
    ..cubicTo(13.8256, 10.0686, 13.5073, 10.1043, 13.3332, 10.3228)
    ..cubicTo(11.7778, 12.2743, 8.6941, 12.4403, 6.6691, 10.5064)
    ..cubicTo(6.467, 10.3137, 6.1471, 10.3211, 5.9543, 10.523)
    ..cubicTo(5.7613, 10.725, 5.7688, 11.0458, 5.9709, 11.2388)
    ..cubicTo(8.377, 13.5364, 12.1576, 13.421, 14.1242, 10.9536)
    ..cubicTo(14.2983, 10.7351, 14.2626, 10.4168, 14.0441, 10.2427)
    ..close()
    ..moveTo(9.8937, 1.982)
    ..cubicTo(8.8876, 2.0052, 7.9943, 2.4481, 7.5236, 3.2281)
    ..cubicTo(7.2861, 3.6217, 7.1564, 4.0886, 7.0988, 4.7749)
    ..cubicTo(7.081, 4.9867, 7.071, 5.2108, 7.0656, 5.4517)
    ..cubicTo(7.46, 5.4468, 7.9012, 5.4468, 8.3996, 5.4468)
    ..lineTo(11.5939, 5.4468)
    ..cubicTo(12.097, 5.4468, 12.5416, 5.4466, 12.9386, 5.4517)
    ..cubicTo(12.9322, 5.1405, 12.9224, 4.8572, 12.8976, 4.5894)
    ..cubicTo(12.8322, 3.8824, 12.6879, 3.4469, 12.4084, 3.0796)
    ..cubicTo(11.8661, 2.3672, 10.9063, 1.9586, 9.8937, 1.982)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ShoppingBag._viewBoxWidth;
    final scaleY = size.height / _ShoppingBag._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ShoppingBag._viewBoxMinX, -_ShoppingBag._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShoppingBagPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/shopping-cart.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ShoppingCart extends StatelessWidget with _DotdartSvgSizing {
  const _ShoppingCart({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor1,
    this.mateoOpticalSizeColor2,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff0d0c0c.
  final Color? mateoOpticalSizeColor1;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor2;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ShoppingCart._svgWidth;

  @override
  double get svgNativeHeight => _ShoppingCart._svgHeight;

  @override
  double get svgViewBoxWidth => _ShoppingCart._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ShoppingCart._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ShoppingCartPainter(
            mateoOpticalSizeColor1: mateoOpticalSizeColor1 ?? const Color(0xff0d0c0c),
            mateoOpticalSizeColor2: mateoOpticalSizeColor2 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ShoppingCartPainter extends CustomPainter {
  _ShoppingCartPainter({
    required this.mateoOpticalSizeColor1,
    required this.mateoOpticalSizeColor2,
  });

  final Color mateoOpticalSizeColor1;
  final Color mateoOpticalSizeColor2;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.68616386,
    0.0,
    0.0,
    0.0,
    0.0,
    0.68616386,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.138361397,
    3.138361397,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(15.523, 15.8282)
    ..cubicTo(16.4908, 15.7441, 17.3424, 16.4634, 17.4215, 17.4315)
    ..cubicTo(17.5007, 18.3998, 16.7773, 19.2478, 15.8087, 19.3222)
    ..cubicTo(14.8469, 19.396, 14.0061, 18.6788, 13.9275, 17.7173)
    ..cubicTo(13.8489, 16.7559, 14.5619, 15.9115, 15.523, 15.8282)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(8.7944, 15.8327)
    ..cubicTo(9.7603, 15.7533, 10.6063, 16.475, 10.6803, 17.4413)
    ..cubicTo(10.7542, 18.4075, 10.0279, 19.2495, 9.0612, 19.3182)
    ..cubicTo(8.1021, 19.3863, 7.2681, 18.6668, 7.1947, 17.708)
    ..cubicTo(7.1213, 16.7493, 7.8361, 15.9113, 8.7944, 15.8327)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(1.3678, 0.6544)
    ..lineTo(3.3401, 0.6544)
    ..cubicTo(3.4456, 0.6564, 3.5506, 0.6619, 3.6413, 0.6762)
    ..cubicTo(3.8998, 0.716, 4.148, 0.8054, 4.3735, 0.938)
    ..cubicTo(5.0836, 1.3548, 5.3326, 1.9804, 5.5378, 2.7275)
    ..cubicTo(5.5693, 2.8424, 5.6023, 3.1213, 5.6375, 3.4244)
    ..lineTo(16.6207, 3.4244)
    ..cubicTo(17.5372, 3.4244, 17.996, 3.4246, 18.3198, 3.5199)
    ..cubicTo(19.4264, 3.8459, 20.1312, 4.9293, 19.9795, 6.0728)
    ..cubicTo(19.9353, 6.4061, 19.75, 6.8229, 19.3806, 7.6539)
    ..lineTo(19.3761, 7.6639)
    ..lineTo(19.0458, 8.4065)
    ..cubicTo(18.6165, 9.3723, 18.4016, 9.8552, 18.081, 10.2251)
    ..cubicTo(17.6762, 10.692, 17.1483, 11.0357, 16.5573, 11.216)
    ..cubicTo(16.0906, 11.3583, 15.5635, 11.3583, 14.5134, 11.3583)
    ..lineTo(14.503, 11.3583)
    ..lineTo(9.1043, 11.3583)
    ..cubicTo(8.471, 11.3583, 7.9973, 11.3582, 7.6212, 11.3281)
    ..cubicTo(7.6483, 11.6593, 7.6734, 12.0382, 7.7801, 12.2473)
    ..cubicTo(8.1986, 12.9659, 8.671, 12.9509, 9.4159, 12.9463)
    ..cubicTo(9.7316, 12.9433, 10.0474, 12.9416, 10.3631, 12.9421)
    ..lineTo(16.5708, 12.9473)
    ..lineTo(17.2625, 12.9525)
    ..cubicTo(17.6268, 12.9721, 17.9585, 13.2378, 18.0238, 13.6006)
    ..cubicTo(18.0609, 13.7997, 18.0159, 14.0062, 17.8992, 14.1718)
    ..cubicTo(17.6019, 14.5995, 17.2049, 14.5454, 16.7453, 14.5457)
    ..lineTo(13.1777, 14.5437)
    ..lineTo(8.9651, 14.5468)
    ..cubicTo(8.7378, 14.5474, 8.5084, 14.5528, 8.2828, 14.5312)
    ..cubicTo(7.3731, 14.4437, 6.6163, 13.8232, 6.2014, 13.0314)
    ..cubicTo(5.9807, 12.6102, 5.8858, 12.1168, 5.7746, 11.6563)
    ..lineTo(5.4827, 10.4453)
    ..lineTo(4.1803, 5.1131)
    ..lineTo(3.8573, 3.7796)
    ..cubicTo(3.7953, 3.5253, 3.7419, 3.2773, 3.66, 3.0287)
    ..cubicTo(3.4781, 2.477, 3.1069, 2.5152, 2.6307, 2.5156)
    ..lineTo(1.4675, 2.5166)
    ..cubicTo(1.2438, 2.5167, 0.9518, 2.5342, 0.7342, 2.4928)
    ..cubicTo(0.0822, 2.3685, -0.2219, 1.6119, 0.1827, 1.0792)
    ..cubicTo(0.3845, 0.8139, 0.6342, 0.7071, 0.9575, 0.6617)
    ..cubicTo(1.0521, 0.6499, 1.2648, 0.6545, 1.3678, 0.6544)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ShoppingCart._viewBoxWidth;
    final scaleY = size.height / _ShoppingCart._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ShoppingCart._viewBoxMinX, -_ShoppingCart._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor1);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor1);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor2);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShoppingCartPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor1 != mateoOpticalSizeColor1 ||
        oldDelegate.mateoOpticalSizeColor2 != mateoOpticalSizeColor2;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/sleeping-figure.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _SleepingFigure extends StatelessWidget with _DotdartSvgSizing {
  const _SleepingFigure({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _SleepingFigure._svgWidth;

  @override
  double get svgNativeHeight => _SleepingFigure._svgHeight;

  @override
  double get svgViewBoxWidth => _SleepingFigure._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _SleepingFigure._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _SleepingFigurePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _SleepingFigurePainter extends CustomPainter {
  _SleepingFigurePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.748477091,
    0.0,
    0.0,
    0.0,
    0.0,
    0.748477091,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.538618997,
    2.234550179,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(2.7305, 11.1303)
    ..lineTo(7.7373, 11.1303)
    ..cubicTo(7.7493, 9.6447, 7.8185, 8.8078, 8.2588, 8.1869)
    ..cubicTo(8.4452, 7.9241, 8.6747, 7.6946, 8.9375, 7.5082)
    ..cubicTo(9.681, 6.981, 10.7344, 6.9808, 12.8398, 6.9808)
    ..lineTo(15.9219, 6.9808)
    ..cubicTo(17.8162, 6.9808, 18.763, 6.9812, 19.3516, 7.5697)
    ..cubicTo(19.9401, 8.1582, 19.9404, 9.105, 19.9404, 10.9994)
    ..lineTo(19.9404, 11.9388)
    ..cubicTo(19.9404, 12.1177, 19.9396, 12.2722, 19.9355, 12.4066)
    ..cubicTo(19.9374, 12.436, 19.9404, 12.4656, 19.9404, 12.4955)
    ..lineTo(19.9404, 16.3878)
    ..cubicTo(19.9404, 17.1417, 19.3291, 17.7531, 18.5752, 17.7531)
    ..cubicTo(17.8215, 17.7529, 17.2109, 17.1416, 17.2109, 16.3878)
    ..lineTo(17.2109, 13.8822)
    ..lineTo(2.7305, 13.8822)
    ..lineTo(2.7305, 16.3636)
    ..cubicTo(2.7305, 17.1176, 2.1192, 17.7289, 1.3652, 17.7289)
    ..cubicTo(0.6112, 17.7289, 0, 17.1176, 0, 16.3636)
    ..lineTo(0, 4.3652)
    ..cubicTo(0, 3.6112, 0.6112, 3, 1.3652, 3)
    ..cubicTo(2.1192, 3, 2.7305, 3.6112, 2.7305, 4.3652)
    ..lineTo(2.7305, 11.1303)
    ..close();

  static final Rect _ellipseRect0 = Rect.fromCircle(
    center: const Offset(5.1871, 9.0011),
    radius: 1.8455,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _SleepingFigure._viewBoxWidth;
    final scaleY = size.height / _SleepingFigure._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_SleepingFigure._viewBoxMinX, -_SleepingFigure._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawOval(_ellipseRect0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SleepingFigurePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/smartphone.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Smartphone extends StatelessWidget with _DotdartSvgSizing {
  const _Smartphone({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Smartphone._svgWidth;

  @override
  double get svgNativeHeight => _Smartphone._svgHeight;

  @override
  double get svgViewBoxWidth => _Smartphone._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Smartphone._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _SmartphonePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _SmartphonePainter extends CustomPainter {
  _SmartphonePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.688075008,
    0.0,
    0.0,
    0.0,
    0.0,
    0.688075008,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.463287424,
    3.11924992,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(6.4821, 20)
    ..cubicTo(4.559, 20, 3, 18.4737, 3, 16.5909)
    ..lineTo(3, 3.4091)
    ..cubicTo(3, 1.5263, 4.559, 0, 6.4821, 0)
    ..lineTo(12.5178, 0)
    ..cubicTo(14.441, 0, 16, 1.5263, 16, 3.4091)
    ..lineTo(16, 16.5909)
    ..cubicTo(16, 18.4737, 14.441, 20, 12.5178, 20)
    ..lineTo(6.4821, 20)
    ..close()
    ..moveTo(8.3393, 2.2636)
    ..cubicTo(7.9547, 2.2636, 7.6429, 2.5689, 7.6429, 2.9455)
    ..cubicTo(7.6429, 3.322, 7.9547, 3.6273, 8.3393, 3.6273)
    ..lineTo(10.6607, 3.6273)
    ..cubicTo(11.0453, 3.6273, 11.3571, 3.322, 11.3571, 2.9455)
    ..cubicTo(11.3571, 2.5689, 11.0453, 2.2636, 10.6607, 2.2636)
    ..lineTo(8.3393, 2.2636)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Smartphone._viewBoxWidth;
    final scaleY = size.height / _Smartphone._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Smartphone._viewBoxMinX, -_Smartphone._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SmartphonePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/social-media-post.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _SocialMediaPost extends StatelessWidget with _DotdartSvgSizing {
  const _SocialMediaPost({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _SocialMediaPost._svgWidth;

  @override
  double get svgNativeHeight => _SocialMediaPost._svgHeight;

  @override
  double get svgViewBoxWidth => _SocialMediaPost._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _SocialMediaPost._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _SocialMediaPostPainter(
            mateoOpticalSizeColor:
                mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _SocialMediaPostPainter extends CustomPainter {
  _SocialMediaPostPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.677058669,
    0.0,
    0.0,
    0.0,
    0.0,
    0.677058669,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.229413314,
    3.229413314,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(9.5068, 0)
    ..cubicTo(5.9376, -0, 4.1528, 0.0004, 2.8252, 0.7715)
    ..cubicTo(1.969, 1.2689, 1.2572, 1.9807, 0.7598, 2.8369)
    ..cubicTo(-0.0113, 4.1645, -0.0117, 5.9493, -0.0117, 9.5185)
    ..lineTo(-0.0117, 10.4814)
    ..cubicTo(-0.0117, 14.0507, -0.0113, 15.8355, 0.7598, 17.1631)
    ..cubicTo(1.2572, 18.0193, 1.969, 18.7311, 2.8252, 19.2285)
    ..cubicTo(4.1528, 19.9996, 5.9376, 20, 9.5068, 20)
    ..lineTo(10.4932, 20)
    ..cubicTo(14.0624, 20, 15.8473, 19.9996, 17.1748, 19.2285)
    ..cubicTo(18.031, 18.7311, 18.7428, 18.0193, 19.2402, 17.1631)
    ..cubicTo(20.0113, 15.8355, 20.0117, 14.0507, 20.0117, 10.4814)
    ..lineTo(20.0117, 9.5185)
    ..cubicTo(20.0117, 5.9493, 20.0113, 4.1645, 19.2402, 2.8369)
    ..cubicTo(18.7428, 1.9807, 18.031, 1.2689, 17.1748, 0.7715)
    ..cubicTo(15.8473, 0.0004, 14.0624, 0, 10.4932, 0)
    ..lineTo(9.5068, 0)
    ..close()
    ..moveTo(12.5762, 9.9385)
    ..cubicTo(13.2589, 9.9385, 13.8125, 10.4921, 13.8125, 11.1748)
    ..cubicTo(13.8124, 11.8574, 13.2588, 12.4111, 12.5762, 12.4111)
    ..lineTo(5.4199, 12.4111)
    ..cubicTo(4.7373, 12.4111, 4.1837, 11.8574, 4.1836, 11.1748)
    ..cubicTo(4.1836, 10.4921, 4.7372, 9.9385, 5.4199, 9.9385)
    ..lineTo(12.5762, 9.9385)
    ..close()
    ..moveTo(5.5518, 4.1484)
    ..cubicTo(6.5265, 4.1486, 7.3164, 4.9393, 7.3164, 5.9141)
    ..cubicTo(7.3162, 6.8886, 6.5263, 7.6785, 5.5518, 7.6787)
    ..cubicTo(4.577, 7.6787, 3.7863, 6.8887, 3.7861, 5.9141)
    ..cubicTo(3.7861, 4.9392, 4.5769, 4.1484, 5.5518, 4.1484)
    ..close()
    ..moveTo(14.9775, 4.6777)
    ..cubicTo(15.6602, 4.6777, 16.2139, 5.2314, 16.2139, 5.9141)
    ..cubicTo(16.2137, 6.5966, 15.6601, 7.1494, 14.9775, 7.1494)
    ..lineTo(10.083, 7.1494)
    ..cubicTo(9.4004, 7.1494, 8.8469, 6.5966, 8.8467, 5.9141)
    ..cubicTo(8.8467, 5.2314, 9.4003, 4.6777, 10.083, 4.6777)
    ..lineTo(14.9775, 4.6777)
    ..close();

  static final Path __clip0 = _buildClip0();

  static Path _buildClip0() {
    final path = Path();
    final clipShape0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));
    path.addPath(
      clipShape0,
      Offset.zero,
      matrix4: Float64List.fromList([
        -1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        20.0,
        0.0,
        0.0,
        1.0,
      ]),
    );
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _SocialMediaPost._viewBoxWidth;
    final scaleY = size.height / _SocialMediaPost._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_SocialMediaPost._viewBoxMinX,
        -_SocialMediaPost._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SocialMediaPostPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/stadium.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Stadium extends StatelessWidget with _DotdartSvgSizing {
  const _Stadium({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor1,
    this.mateoOpticalSizeColor2,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff080706.
  final Color? mateoOpticalSizeColor1;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor2;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Stadium._svgWidth;

  @override
  double get svgNativeHeight => _Stadium._svgHeight;

  @override
  double get svgViewBoxWidth => _Stadium._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Stadium._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _StadiumPainter(
            mateoOpticalSizeColor1: mateoOpticalSizeColor1 ?? const Color(0xff080706),
            mateoOpticalSizeColor2: mateoOpticalSizeColor2 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _StadiumPainter extends CustomPainter {
  _StadiumPainter({
    required this.mateoOpticalSizeColor1,
    required this.mateoOpticalSizeColor2,
  });

  final Color mateoOpticalSizeColor1;
  final Color mateoOpticalSizeColor2;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.818833214,
    0.0,
    0.0,
    0.0,
    0.0,
    0.818833214,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.811667859,
    2.29785008,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(5.7574, 1)
    ..cubicTo(5.973, 1.0113, 6.166, 1.0653, 6.3417, 1.1949)
    ..cubicTo(6.5529, 1.3503, 6.6924, 1.5843, 6.7287, 1.8439)
    ..cubicTo(6.7424, 1.9442, 6.7416, 2.2778, 6.7381, 2.3917)
    ..cubicTo(6.7245, 2.8319, 6.8146, 3.2001, 6.5353, 3.5699)
    ..cubicTo(6.1948, 4.0207, 5.5841, 4.0041, 5.0494, 4.0715)
    ..lineTo(5.0482, 5.1931)
    ..cubicTo(5.0477, 5.4511, 5.0404, 5.7422, 5.0552, 5.9976)
    ..cubicTo(5.5632, 5.8722, 6.15, 5.7744, 6.6687, 5.6988)
    ..cubicTo(9.4175, 5.2999, 12.2159, 5.4008, 14.9288, 5.9965)
    ..cubicTo(14.9375, 5.3531, 14.9393, 4.7096, 14.9341, 4.0662)
    ..cubicTo(14.4377, 3.9997, 13.8175, 4.0255, 13.4778, 3.6185)
    ..cubicTo(13.395, 3.5194, 13.2928, 3.3363, 13.272, 3.2047)
    ..cubicTo(13.2113, 2.8211, 13.2454, 2.312, 13.2438, 1.9215)
    ..cubicTo(13.2428, 1.6908, 13.4131, 1.3716, 13.5905, 1.2324)
    ..cubicTo(13.8385, 1.0374, 14.0649, 0.9858, 14.3728, 1.0133)
    ..cubicTo(14.8014, 1.0516, 15.2173, 1.1233, 15.6404, 1.1711)
    ..lineTo(16.4445, 1.261)
    ..cubicTo(16.658, 1.2851, 16.9432, 1.3071, 17.1412, 1.3758)
    ..cubicTo(17.3273, 1.4383, 17.492, 1.5521, 17.6162, 1.7041)
    ..cubicTo(17.713, 1.8203, 17.7821, 1.9568, 17.8185, 2.1035)
    ..cubicTo(17.8723, 2.326, 17.8418, 3.1541, 17.8404, 3.4255)
    ..cubicTo(17.8393, 3.6404, 17.6593, 3.9447, 17.4798, 4.0849)
    ..cubicTo(17.0937, 4.3864, 16.7134, 4.2865, 16.2648, 4.2376)
    ..cubicTo(16.2567, 4.9085, 16.2529, 5.6763, 16.2661, 6.346)
    ..cubicTo(16.5014, 6.4378, 16.7478, 6.515, 16.9883, 6.6097)
    ..cubicTo(17.4887, 6.8039, 17.9694, 7.0456, 18.4238, 7.3313)
    ..cubicTo(19.0972, 7.7481, 19.7677, 8.427, 19.9441, 9.2187)
    ..cubicTo(20.0928, 9.8865, 19.9356, 10.4002, 19.5817, 10.9659)
    ..cubicTo(19.5654, 11.6332, 19.5888, 12.3279, 19.5798, 12.9973)
    ..cubicTo(19.575, 13.3577, 19.5946, 13.7018, 19.5579, 14.062)
    ..cubicTo(19.4849, 14.7781, 19.1152, 15.3379, 18.5823, 15.8019)
    ..cubicTo(18.4639, 15.905, 18.3401, 15.987, 18.2175, 16.0854)
    ..cubicTo(17.0193, 16.9378, 14.9746, 17.4196, 13.5332, 17.6391)
    ..cubicTo(13.1181, 17.7024, 12.6788, 17.7601, 12.2591, 17.7886)
    ..cubicTo(12.0909, 17.798, 11.9707, 17.7968, 11.8417, 17.6749)
    ..cubicTo(11.6926, 17.5341, 11.6963, 17.3376, 11.6989, 17.1467)
    ..cubicTo(11.7062, 16.5941, 11.7088, 16.0406, 11.7027, 15.4879)
    ..cubicTo(11.7, 15.2219, 11.6229, 14.9936, 11.4246, 14.8093)
    ..cubicTo(11.1996, 14.5983, 10.9156, 14.571, 10.6215, 14.5797)
    ..cubicTo(10.1263, 14.5865, 9.6315, 14.5771, 9.1361, 14.5824)
    ..cubicTo(8.7146, 14.5871, 8.3519, 14.866, 8.2766, 15.287)
    ..cubicTo(8.2436, 15.4773, 8.2556, 15.6995, 8.2562, 15.8955)
    ..lineTo(8.2601, 16.8405)
    ..cubicTo(8.2614, 17.0343, 8.2839, 17.2501, 8.2478, 17.4403)
    ..cubicTo(8.2312, 17.5273, 8.1939, 17.6119, 8.1316, 17.6761)
    ..cubicTo(8.0356, 17.7749, 7.8885, 17.8113, 7.7546, 17.812)
    ..cubicTo(7.3957, 17.8139, 7.0105, 17.7467, 6.6538, 17.6989)
    ..cubicTo(4.988, 17.476, 2.4519, 16.8909, 1.2357, 15.6746)
    ..cubicTo(0.932, 15.3709, 0.6698, 14.9945, 0.5401, 14.5814)
    ..cubicTo(0.3559, 13.9951, 0.4164, 13.2678, 0.4167, 12.6512)
    ..lineTo(0.4153, 10.9596)
    ..cubicTo(0.2756, 10.7685, 0.1423, 10.4785, 0.0811, 10.2513)
    ..cubicTo(-0.4949, 8.1133, 2.1305, 6.8356, 3.7213, 6.3487)
    ..cubicTo(3.7392, 6.1296, 3.7298, 5.8086, 3.7297, 5.5825)
    ..lineTo(3.7287, 4.2279)
    ..cubicTo(3.2929, 4.2823, 2.8716, 4.3871, 2.501, 4.0909)
    ..cubicTo(2.0685, 3.7535, 2.1658, 3.3115, 2.1407, 2.8624)
    ..cubicTo(2.0903, 1.9598, 2.2595, 1.3955, 3.2803, 1.2943)
    ..cubicTo(4.0754, 1.2155, 4.9361, 1.0768, 5.7574, 1)
    ..close()
    ..moveTo(10.6488, 12.7226)
    ..cubicTo(12.6719, 12.69, 15.5767, 12.318, 17.3418, 11.3186)
    ..cubicTo(17.6327, 11.1539, 17.9171, 10.9704, 18.1499, 10.7277)
    ..cubicTo(18.4028, 10.4644, 18.5951, 10.142, 18.5884, 9.7666)
    ..cubicTo(18.5816, 9.3883, 18.3549, 9.0635, 18.0887, 8.8125)
    ..cubicTo(16.4297, 7.248, 11.6911, 6.8486, 9.4536, 6.9248)
    ..cubicTo(9.4298, 6.9256, 9.406, 6.9265, 9.3822, 6.9276)
    ..cubicTo(8.6959, 6.9465, 8.0107, 6.9934, 7.3283, 7.0682)
    ..cubicTo(5.7895, 7.2429, 2.9014, 7.7436, 1.811, 8.9025)
    ..cubicTo(1.5855, 9.142, 1.398, 9.4744, 1.4121, 9.8127)
    ..cubicTo(1.4292, 10.2199, 1.7119, 10.5941, 2.0035, 10.8562)
    ..cubicTo(3.366, 12.0805, 6.4814, 12.5547, 8.2788, 12.6774)
    ..cubicTo(9.0682, 12.7314, 9.8583, 12.73, 10.6488, 12.7226)
    ..close()
    ..moveTo(3.6821, 3.4017)
    ..cubicTo(4.0108, 3.334, 4.2218, 3.012, 4.1525, 2.6836)
    ..cubicTo(4.0833, 2.3553, 3.7603, 2.1458, 3.4323, 2.2166)
    ..cubicTo(3.1064, 2.2869, 2.8987, 2.6073, 2.9674, 2.9335)
    ..cubicTo(3.0362, 3.2597, 3.3556, 3.4689, 3.6821, 3.4017)
    ..close()
    ..moveTo(16.5347, 3.4043)
    ..cubicTo(16.7498, 3.3666, 16.928, 3.2158, 17.001, 3.0098)
    ..cubicTo(17.0738, 2.8038, 17.03, 2.5745, 16.8863, 2.4098)
    ..cubicTo(16.7426, 2.2452, 16.5214, 2.1707, 16.3075, 2.215)
    ..cubicTo(15.9835, 2.282, 15.7733, 2.5966, 15.8354, 2.9215)
    ..cubicTo(15.8974, 3.2464, 16.2088, 3.4614, 16.5347, 3.4043)
    ..close()
    ..moveTo(14.6867, 3.175)
    ..cubicTo(14.9032, 3.152, 15.0907, 3.0145, 15.1777, 2.8149)
    ..cubicTo(15.2647, 2.6152, 15.2377, 2.3842, 15.1071, 2.21)
    ..cubicTo(14.9764, 2.0358, 14.7622, 1.9451, 14.5462, 1.9727)
    ..cubicTo(14.2171, 2.0146, 13.9831, 2.3137, 14.0216, 2.6433)
    ..cubicTo(14.0601, 2.9728, 14.3567, 3.21, 14.6867, 3.175)
    ..close()
    ..moveTo(5.4751, 3.1698)
    ..cubicTo(5.69, 3.1292, 5.8663, 2.9757, 5.9361, 2.7683)
    ..cubicTo(6.0059, 2.561, 5.9584, 2.3322, 5.8118, 2.1698)
    ..cubicTo(5.6653, 2.0074, 5.4424, 1.9368, 5.2291, 1.9851)
    ..cubicTo(4.9072, 2.0579, 4.7031, 2.3752, 4.7702, 2.6983)
    ..cubicTo(4.8373, 3.0213, 5.1509, 3.2311, 5.4751, 3.1698)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(6.4405, 11.4132)
    ..cubicTo(4.2565, 11.1101, 2.7849, 10.5396, 2.7849, 9.8858)
    ..cubicTo(2.7849, 9.274, 4.0737, 8.7351, 6.0292, 8.42)
    ..lineTo(6.4405, 11.4132)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(17.2951, 9.8813)
    ..cubicTo(17.2951, 9.0719, 15.64, 8.4048, 12.5697, 8.2)
    ..lineTo(13.0159, 11.4856)
    ..cubicTo(15.5387, 11.2102, 17.295, 10.5956, 17.2951, 9.8813)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(6.6018, 8.3297)
    ..cubicTo(7.625, 8.1959, 8.7959, 8.12, 10.0399, 8.12)
    ..cubicTo(10.7081, 8.12, 11.3504, 8.1408, 11.9648, 8.1818)
    ..lineTo(11.9695, 8.2174)
    ..lineTo(12.426, 11.5401)
    ..cubicTo(11.6787, 11.6032, 10.8758, 11.6376, 10.0399, 11.6376)
    ..cubicTo(8.9734, 11.6376, 7.9607, 11.5819, 7.0487, 11.4817)
    ..lineTo(6.6166, 8.3325)
    ..lineTo(6.6018, 8.3297)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Stadium._viewBoxWidth;
    final scaleY = size.height / _Stadium._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Stadium._viewBoxMinX, -_Stadium._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor1);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor2);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor2);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor2);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StadiumPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor1 != mateoOpticalSizeColor1 ||
        oldDelegate.mateoOpticalSizeColor2 != mateoOpticalSizeColor2;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/star.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Star extends StatelessWidget with _DotdartSvgSizing {
  const _Star({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Star._svgWidth;

  @override
  double get svgNativeHeight => _Star._svgHeight;

  @override
  double get svgViewBoxWidth => _Star._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Star._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _StarPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  _StarPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.746469931,
    0.0,
    0.0,
    0.0,
    0.0,
    0.746469931,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.535300685,
    2.535300685,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(11.8188, 1.1962)
    ..cubicTo(11.0869, -0.3987, 8.9132, -0.3987, 8.1812, 1.1962)
    ..lineTo(6.2625, 5.3774)
    ..cubicTo(6.2482, 5.4086, 6.2169, 5.4351, 6.1752, 5.4408)
    ..lineTo(1.7581, 6.0463)
    ..cubicTo(0.0873, 6.2753, -0.6102, 8.4379, 0.6353, 9.6673)
    ..lineTo(3.8665, 12.8568)
    ..cubicTo(3.8929, 12.8828, 3.9022, 12.9175, 3.8966, 12.9489)
    ..lineTo(3.0854, 17.5044)
    ..cubicTo(2.7712, 19.269, 4.5553, 20.5744, 6.0271, 19.7437)
    ..lineTo(9.9427, 17.5339)
    ..cubicTo(9.9782, 17.5139, 10.0219, 17.5139, 10.0572, 17.5339)
    ..lineTo(13.973, 19.7437)
    ..cubicTo(15.4447, 20.5744, 17.2288, 19.269, 16.9146, 17.5044)
    ..lineTo(16.1033, 12.9489)
    ..cubicTo(16.0978, 12.9175, 16.1071, 12.8828, 16.1334, 12.8568)
    ..lineTo(19.3647, 9.6673)
    ..cubicTo(20.6102, 8.4379, 19.9127, 6.2753, 18.2419, 6.0463)
    ..lineTo(13.8248, 5.4408)
    ..cubicTo(13.7831, 5.4351, 13.7518, 5.4086, 13.7375, 5.3774)
    ..lineTo(11.8188, 1.1962)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Star._viewBoxWidth;
    final scaleY = size.height / _Star._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Star._viewBoxMinX, -_Star._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/tire.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Tire extends StatelessWidget with _DotdartSvgSizing {
  const _Tire({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Tire._svgWidth;

  @override
  double get svgNativeHeight => _Tire._svgHeight;

  @override
  double get svgViewBoxWidth => _Tire._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Tire._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _TirePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _TirePainter extends CustomPainter {
  _TirePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.791184276,
    0.0,
    0.0,
    0.0,
    0.0,
    0.791184276,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.088157238,
    2.088157238,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10, 0)
    ..cubicTo(15.5228, 0, 20, 4.4771, 20, 10)
    ..cubicTo(20, 15.5228, 15.5228, 20, 10, 20)
    ..cubicTo(4.4771, 20, 0, 15.5228, 0, 10)
    ..cubicTo(0, 4.4771, 4.4771, 0, 10, 0)
    ..close()
    ..moveTo(9.7559, 2.3106)
    ..cubicTo(7.6616, 2.4199, 5.8344, 3.2423, 4.4209, 4.8096)
    ..cubicTo(3.0425, 6.3434, 2.328, 8.3613, 2.4326, 10.4209)
    ..cubicTo(2.5448, 12.4872, 3.4794, 14.4227, 5.0283, 15.7949)
    ..cubicTo(6.462, 17.0814, 8.3386, 17.7633, 10.2637, 17.6973)
    ..cubicTo(12.1672, 17.6686, 14.0802, 16.7611, 15.3975, 15.4014)
    ..cubicTo(16.833, 13.9276, 17.6204, 11.9409, 17.584, 9.8838)
    ..cubicTo(17.5488, 7.8144, 16.6922, 5.8437, 15.2041, 4.4053)
    ..cubicTo(13.7709, 3.0229, 11.8462, 2.2679, 9.8555, 2.3076)
    ..cubicTo(9.8245, 2.3082, 9.7856, 2.3084, 9.7559, 2.3106)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(9.8108, 12.669)
    ..cubicTo(9.8548, 12.6666, 9.8989, 12.6653, 9.943, 12.6651)
    ..cubicTo(10.6655, 12.6548, 10.7135, 12.8317, 11.1273, 13.3638)
    ..lineTo(11.8165, 14.2567)
    ..lineTo(12.4396, 15.0665)
    ..cubicTo(12.5963, 15.2707, 12.9472, 15.5928, 12.6914, 15.8529)
    ..cubicTo(12.5904, 15.9555, 12.4125, 16.0152, 12.276, 16.067)
    ..cubicTo(11.6214, 16.317, 10.9292, 16.4551, 10.2287, 16.4756)
    ..cubicTo(9.4083, 16.5216, 8.5018, 16.3603, 7.7365, 16.0651)
    ..cubicTo(7.6219, 16.0098, 7.4488, 15.9744, 7.353, 15.8881)
    ..cubicTo(7.0669, 15.6305, 7.3469, 15.3595, 7.4959, 15.1686)
    ..cubicTo(7.6256, 15.0021, 7.7544, 14.835, 7.8822, 14.6671)
    ..cubicTo(8.1777, 14.275, 8.4767, 13.8857, 8.7791, 13.4991)
    ..cubicTo(8.9281, 13.3075, 9.0777, 13.114, 9.23, 12.9252)
    ..cubicTo(9.3624, 12.7609, 9.6051, 12.6867, 9.8108, 12.669)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(3.8918, 8.9997)
    ..cubicTo(3.9842, 8.9918, 4.0242, 8.9932, 4.1122, 9.0252)
    ..cubicTo(4.3273, 9.1033, 4.5404, 9.1877, 4.7535, 9.2708)
    ..cubicTo(5.2117, 9.4498, 5.6689, 9.6312, 6.1251, 9.815)
    ..lineTo(6.7475, 10.0616)
    ..cubicTo(6.8601, 10.1061, 7.0446, 10.1715, 7.1409, 10.2324)
    ..cubicTo(7.4556, 10.432, 7.6688, 11.1856, 7.4757, 11.502)
    ..cubicTo(7.0916, 12.1314, 6.6337, 12.7336, 6.2504, 13.3606)
    ..cubicTo(6.1236, 13.551, 5.998, 13.7422, 5.8734, 13.9341)
    ..cubicTo(5.7368, 14.1427, 5.5839, 14.4739, 5.2781, 14.3409)
    ..cubicTo(5.1521, 14.286, 5.0257, 14.1031, 4.9425, 13.9925)
    ..cubicTo(4.5833, 13.5238, 4.2894, 13.0085, 4.0689, 12.4606)
    ..cubicTo(3.7099, 11.5742, 3.5524, 10.6191, 3.6078, 9.6643)
    ..cubicTo(3.6233, 9.382, 3.5788, 9.1191, 3.8918, 8.9997)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(15.9645, 8.9999)
    ..cubicTo(16.3956, 8.9433, 16.3873, 9.3055, 16.4064, 9.6065)
    ..cubicTo(16.4388, 10.1193, 16.4145, 10.6154, 16.3275, 11.1219)
    ..cubicTo(16.1546, 12.135, 15.7442, 13.0929, 15.1296, 13.9168)
    ..cubicTo(15.0475, 14.0265, 14.8945, 14.2507, 14.7845, 14.319)
    ..cubicTo(14.4773, 14.51, 14.3023, 14.1792, 14.1618, 13.9647)
    ..lineTo(13.8392, 13.473)
    ..cubicTo(13.5264, 13.0019, 13.2163, 12.5289, 12.9089, 12.0542)
    ..cubicTo(12.8005, 11.8881, 12.5971, 11.5943, 12.5158, 11.428)
    ..cubicTo(12.414, 11.1581, 12.5297, 10.7953, 12.6315, 10.5534)
    ..cubicTo(12.7664, 10.2332, 12.9773, 10.1785, 13.2698, 10.0624)
    ..lineTo(13.8617, 9.828)
    ..cubicTo(14.5583, 9.5523, 15.2644, 9.2648, 15.9645, 8.9999)
    ..close();

  static final Path __path4 = Path()
    ..moveTo(11.3201, 3.6724)
    ..cubicTo(11.5532, 3.66, 12.1809, 3.8865, 12.4168, 3.985)
    ..cubicTo(13.5195, 4.4505, 14.4731, 5.2101, 15.1733, 6.1809)
    ..cubicTo(15.2807, 6.3318, 15.4128, 6.5121, 15.4902, 6.6815)
    ..cubicTo(15.5617, 6.838, 15.4847, 7.0457, 15.316, 7.1085)
    ..cubicTo(15.0539, 7.2061, 14.7778, 7.2872, 14.5086, 7.3707)
    ..lineTo(12.9515, 7.8646)
    ..cubicTo(12.7047, 7.9424, 12.4406, 8.0289, 12.1901, 8.0952)
    ..cubicTo(12.1246, 8.1125, 12.0169, 8.113, 11.9495, 8.0855)
    ..cubicTo(11.6762, 7.975, 11.2499, 7.7044, 11.1324, 7.4267)
    ..cubicTo(11.0687, 7.2762, 11.0862, 6.8325, 11.0843, 6.6521)
    ..lineTo(11.0717, 5.6591)
    ..cubicTo(11.0665, 5.1088, 11.0538, 4.5588, 11.0584, 4.0084)
    ..cubicTo(11.06, 3.8232, 11.151, 3.734, 11.3201, 3.6724)
    ..close();

  static final Path __path5 = Path()
    ..moveTo(8.577, 3.6731)
    ..cubicTo(8.6215, 3.6722, 8.6547, 3.6717, 8.698, 3.684)
    ..cubicTo(8.7781, 3.706, 8.846, 3.7594, 8.8864, 3.832)
    ..cubicTo(8.9173, 3.8881, 8.929, 3.9634, 8.929, 4.027)
    ..cubicTo(8.9292, 4.4577, 8.9203, 4.8916, 8.9183, 5.322)
    ..lineTo(8.9148, 6.606)
    ..cubicTo(8.9142, 6.7992, 8.9262, 7.2053, 8.8894, 7.3703)
    ..cubicTo(8.8199, 7.682, 8.2247, 8.1137, 7.9171, 8.1106)
    ..cubicTo(7.8469, 8.1099, 7.3539, 7.9474, 7.2568, 7.9171)
    ..lineTo(5.5979, 7.3914)
    ..cubicTo(5.2911, 7.2974, 4.9218, 7.2059, 4.6374, 7.0706)
    ..cubicTo(4.547, 7.0276, 4.5089, 6.9582, 4.502, 6.8799)
    ..cubicTo(4.4903, 6.747, 4.5682, 6.5884, 4.6323, 6.4894)
    ..cubicTo(5.5171, 5.1203, 6.9614, 4.0102, 8.577, 3.6731)
    ..close();

  static final Path __path6 = Path()
    ..moveTo(10.8578, 11.0596)
    ..cubicTo(11.1701, 10.9987, 11.4729, 11.2031, 11.5326, 11.5156)
    ..cubicTo(11.5923, 11.8281, 11.3864, 12.13, 11.0736, 12.1885)
    ..cubicTo(10.7627, 12.2464, 10.4632, 12.0421, 10.4037, 11.7315)
    ..cubicTo(10.3443, 11.4207, 10.5474, 11.1203, 10.8578, 11.0596)
    ..close();

  static final Path __path7 = Path()
    ..moveTo(8.9639, 11.0585)
    ..cubicTo(9.2777, 10.9999, 9.5793, 11.209, 9.6348, 11.5234)
    ..cubicTo(9.6902, 11.8375, 9.4787, 12.1367, 9.1641, 12.1894)
    ..cubicTo(8.8535, 12.241, 8.5587, 12.0325, 8.5039, 11.7226)
    ..cubicTo(8.4495, 11.4127, 8.6547, 11.1162, 8.9639, 11.0585)
    ..close();

  static final Path __path8 = Path()
    ..moveTo(11.5592, 9.2339)
    ..cubicTo(11.8705, 9.1835, 12.1631, 9.3952, 12.2126, 9.7065)
    ..cubicTo(12.262, 10.0178, 12.0494, 10.3102, 11.738, 10.3589)
    ..cubicTo(11.4278, 10.4072, 11.1369, 10.1953, 11.0876, 9.8852)
    ..cubicTo(11.0382, 9.5752, 11.2493, 9.2841, 11.5592, 9.2339)
    ..close();

  static final Path __path9 = Path()
    ..moveTo(9.9293, 7.915)
    ..cubicTo(10.2393, 7.8665, 10.5301, 8.0779, 10.5797, 8.3877)
    ..cubicTo(10.6292, 8.6973, 10.4193, 8.9891, 10.11, 9.04)
    ..cubicTo(9.7986, 9.0912, 9.5047, 8.8788, 9.4547, 8.5673)
    ..cubicTo(9.405, 8.2561, 9.6178, 7.9638, 9.9293, 7.915)
    ..close();

  static final Path __path10 = Path()
    ..moveTo(8.2934, 9.2334)
    ..cubicTo(8.6049, 9.1847, 8.8969, 9.3992, 8.9438, 9.7109)
    ..cubicTo(8.9904, 10.0225, 8.7742, 10.3123, 8.4624, 10.3574)
    ..cubicTo(8.1532, 10.4019, 7.8664, 10.1887, 7.8198, 9.8799)
    ..cubicTo(7.7733, 9.5708, 7.9846, 9.2818, 8.2934, 9.2334)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Tire._viewBoxWidth;
    final scaleY = size.height / _Tire._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Tire._viewBoxMinX, -_Tire._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path5, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path6, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path7, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path8, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path9, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path10, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TirePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/train-front.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _TrainFront extends StatelessWidget with _DotdartSvgSizing {
  const _TrainFront({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _TrainFront._svgWidth;

  @override
  double get svgNativeHeight => _TrainFront._svgHeight;

  @override
  double get svgViewBoxWidth => _TrainFront._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _TrainFront._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _TrainFrontPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _TrainFrontPainter extends CustomPainter {
  _TrainFrontPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.688466379,
    0.0,
    0.0,
    0.0,
    0.0,
    0.688466379,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.115336205,
    3.115336205,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(9.9891, 0)
    ..cubicTo(12.1019, 0, 13.1583, 0, 14.0041, 0.3085)
    ..cubicTo(15.4167, 0.8238, 16.5296, 1.9367, 17.0449, 3.3493)
    ..cubicTo(17.3534, 4.1951, 17.3534, 5.2515, 17.3534, 7.3644)
    ..lineTo(17.3534, 9.6297)
    ..cubicTo(17.3534, 12.6256, 17.3534, 14.1236, 16.5134, 15.1231)
    ..cubicTo(16.3805, 15.2813, 16.234, 15.4277, 16.0759, 15.5607)
    ..cubicTo(15.8254, 15.7712, 15.5436, 15.9288, 15.2149, 16.0471)
    ..lineTo(16.7758, 18.7701)
    ..cubicTo(17.0786, 19.2982, 16.7218, 19.9607, 16.1142, 19.9984)
    ..cubicTo(15.8008, 20.0179, 15.5037, 19.8569, 15.3487, 19.5838)
    ..lineTo(13.5131, 16.3473)
    ..cubicTo(12.7318, 16.4004, 11.7761, 16.4007, 10.5825, 16.4007)
    ..lineTo(9.3956, 16.4007)
    ..cubicTo(8.1627, 16.4007, 7.1835, 16.4006, 6.3883, 16.342)
    ..lineTo(4.5497, 19.5838)
    ..cubicTo(4.3948, 19.8569, 4.0978, 20.0179, 3.7844, 19.9984)
    ..cubicTo(3.1768, 19.9607, 2.8199, 19.2982, 3.1227, 18.7701)
    ..lineTo(4.6975, 16.0226)
    ..cubicTo(4.3967, 15.9074, 4.1358, 15.757, 3.9022, 15.5607)
    ..cubicTo(3.7441, 15.4277, 3.5976, 15.2813, 3.4647, 15.1231)
    ..cubicTo(2.6246, 14.1236, 2.6247, 12.6256, 2.6247, 9.6297)
    ..lineTo(2.6247, 7.3644)
    ..cubicTo(2.6247, 5.2515, 2.6247, 4.1951, 2.9332, 3.3493)
    ..cubicTo(3.4484, 1.9367, 4.5614, 0.8238, 5.974, 0.3085)
    ..cubicTo(6.8197, 0, 7.8762, 0, 9.9891, 0)
    ..close()
    ..moveTo(6.0481, 11.7034)
    ..cubicTo(5.2566, 11.7034, 4.615, 12.345, 4.615, 13.1365)
    ..cubicTo(4.615, 13.9279, 5.2566, 14.5695, 6.0481, 14.5695)
    ..cubicTo(6.8396, 14.5695, 7.4812, 13.9279, 7.4812, 13.1365)
    ..cubicTo(7.4812, 12.345, 6.8396, 11.7034, 6.0481, 11.7034)
    ..close()
    ..moveTo(13.93, 11.7034)
    ..cubicTo(13.1385, 11.7034, 12.4969, 12.345, 12.4969, 13.1365)
    ..cubicTo(12.4969, 13.9279, 13.1385, 14.5695, 13.93, 14.5695)
    ..cubicTo(14.7214, 14.5695, 15.3631, 13.9279, 15.3631, 13.1365)
    ..cubicTo(15.3631, 12.345, 14.7214, 11.7034, 13.93, 11.7034)
    ..close()
    ..moveTo(7.2423, 4.14)
    ..cubicTo(6.2034, 4.14, 5.6838, 4.14, 5.2763, 4.3158)
    ..cubicTo(4.7727, 4.533, 4.3712, 4.9345, 4.1539, 5.4382)
    ..cubicTo(3.9781, 5.8457, 3.9781, 6.3652, 3.9781, 7.4042)
    ..cubicTo(3.9781, 8.4432, 3.9781, 8.9627, 4.1539, 9.3702)
    ..cubicTo(4.3712, 9.8738, 4.7727, 10.2754, 5.2763, 10.4926)
    ..cubicTo(5.6838, 10.6684, 6.2034, 10.6684, 7.2423, 10.6684)
    ..lineTo(12.7358, 10.6684)
    ..cubicTo(13.7747, 10.6684, 14.2942, 10.6684, 14.7018, 10.4926)
    ..cubicTo(15.2054, 10.2754, 15.6069, 9.8738, 15.8242, 9.3702)
    ..cubicTo(16, 8.9627, 16, 8.4432, 16, 7.4042)
    ..cubicTo(16, 6.3652, 16, 5.8457, 15.8242, 5.4382)
    ..cubicTo(15.6069, 4.9345, 15.2054, 4.533, 14.7018, 4.3158)
    ..cubicTo(14.2942, 4.14, 13.7747, 4.14, 12.7358, 4.14)
    ..lineTo(7.2423, 4.14)
    ..close()
    ..moveTo(8.0783, 1.5923)
    ..cubicTo(7.6606, 1.5923, 7.322, 1.9309, 7.322, 2.3486)
    ..cubicTo(7.322, 2.7664, 7.6606, 3.105, 8.0783, 3.105)
    ..lineTo(11.8998, 3.105)
    ..cubicTo(12.3175, 3.105, 12.6561, 2.7664, 12.6561, 2.3486)
    ..cubicTo(12.6561, 1.9309, 12.3175, 1.5923, 11.8998, 1.5923)
    ..lineTo(8.0783, 1.5923)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _TrainFront._viewBoxWidth;
    final scaleY = size.height / _TrainFront._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_TrainFront._viewBoxMinX, -_TrainFront._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TrainFrontPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/trash.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Trash extends StatelessWidget with _DotdartSvgSizing {
  const _Trash({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Trash._svgWidth;

  @override
  double get svgNativeHeight => _Trash._svgHeight;

  @override
  double get svgViewBoxWidth => _Trash._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Trash._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _TrashPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _TrashPainter extends CustomPainter {
  _TrashPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.714064942,
    0.0,
    0.0,
    0.0,
    0.0,
    0.714064942,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.915136903,
    2.85935058,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.0195, 0.0007)
    ..cubicTo(8.9062, -0.017, 7.7515, 0.3208, 6.8599, 1.0793)
    ..cubicTo(6.0572, 1.7622, 5.5188, 2.7442, 5.4013, 3.975)
    ..lineTo(1.7732, 3.975)
    ..cubicTo(1.2325, 3.975, 0.7941, 4.4134, 0.7941, 4.9541)
    ..cubicTo(0.7941, 5.4948, 1.2325, 5.9332, 1.7732, 5.9332)
    ..lineTo(2.5585, 5.9332)
    ..lineTo(2.9002, 13.3169)
    ..cubicTo(3.0224, 15.9572, 3.0835, 17.2773, 3.7333, 18.2289)
    ..cubicTo(4.0542, 18.6988, 4.4703, 19.0961, 4.9546, 19.3949)
    ..cubicTo(5.9351, 20, 7.2567, 20, 9.8998, 20)
    ..cubicTo(12.5031, 20, 13.8048, 20, 14.7777, 19.4078)
    ..cubicTo(15.2585, 19.1151, 15.6731, 18.7257, 15.9954, 18.2643)
    ..cubicTo(16.6476, 17.3305, 16.7294, 16.0314, 16.893, 13.4333)
    ..lineTo(17.3652, 5.9332)
    ..lineTo(18.0741, 5.9332)
    ..cubicTo(18.6148, 5.9332, 19.0532, 5.4948, 19.0532, 4.9541)
    ..cubicTo(19.0531, 4.4134, 18.6148, 3.975, 18.0741, 3.975)
    ..lineTo(14.6064, 3.975)
    ..cubicTo(14.4841, 2.7859, 13.9405, 1.8267, 13.1539, 1.1492)
    ..cubicTo(12.275, 0.3922, 11.1327, 0.0184, 10.0195, 0.0007)
    ..close()
    ..moveTo(7.9998, 8.6308)
    ..cubicTo(8.6159, 8.6308, 9.1153, 9.1303, 9.1153, 9.7463)
    ..lineTo(9.1153, 14.4857)
    ..cubicTo(9.1153, 15.1018, 8.6159, 15.6012, 7.9998, 15.6012)
    ..cubicTo(7.3838, 15.6012, 6.8844, 15.1018, 6.8844, 14.4857)
    ..lineTo(6.8844, 9.7462)
    ..cubicTo(6.8844, 9.1302, 7.3838, 8.6308, 7.9998, 8.6308)
    ..close()
    ..moveTo(11.9354, 8.5441)
    ..cubicTo(12.5514, 8.5441, 13.0508, 9.0435, 13.0508, 9.6596)
    ..lineTo(13.0508, 14.399)
    ..cubicTo(13.0508, 15.015, 12.5514, 15.5144, 11.9354, 15.5144)
    ..cubicTo(11.3193, 15.5144, 10.8199, 15.0151, 10.8199, 14.399)
    ..lineTo(10.8199, 9.6596)
    ..cubicTo(10.8199, 9.0435, 11.3193, 8.5441, 11.9354, 8.5441)
    ..close()
    ..moveTo(9.99, 1.8584)
    ..cubicTo(10.7261, 1.8701, 11.4333, 2.1193, 11.9414, 2.5569)
    ..cubicTo(12.3298, 2.8915, 12.6261, 3.3551, 12.732, 3.975)
    ..lineTo(7.2725, 3.975)
    ..cubicTo(7.3752, 3.2978, 7.6799, 2.8211, 8.0638, 2.4945)
    ..cubicTo(8.5592, 2.0731, 9.2539, 1.8467, 9.99, 1.8584)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Trash._viewBoxWidth;
    final scaleY = size.height / _Trash._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Trash._viewBoxMinX, -_Trash._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TrashPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/tree.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Tree extends StatelessWidget with _DotdartSvgSizing {
  const _Tree({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Tree._svgWidth;

  @override
  double get svgNativeHeight => _Tree._svgHeight;

  @override
  double get svgViewBoxWidth => _Tree._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Tree._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _TreePainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _TreePainter extends CustomPainter {
  _TreePainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.772150335,
    0.0,
    0.0,
    0.0,
    0.0,
    0.772150335,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.278496648,
    2.278496648,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(8.971, 15.8774)
    ..lineTo(11.0319, 15.8774)
    ..lineTo(11.0319, 17.9383)
    ..lineTo(12.8319, 17.9383)
    ..cubicTo(13.401, 17.9383, 13.8623, 18.3996, 13.8623, 18.9687)
    ..cubicTo(13.8623, 19.5378, 13.401, 19.9991, 12.8319, 19.9991)
    ..lineTo(7.1387, 19.9991)
    ..cubicTo(6.5697, 19.9991, 6.1083, 19.5378, 6.1083, 18.9687)
    ..cubicTo(6.1083, 18.3996, 6.5697, 17.9383, 7.1387, 17.9383)
    ..lineTo(8.971, 17.9383)
    ..lineTo(8.971, 15.8774)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(0.2782, 11.6502)
    ..cubicTo(0.2782, 13.5126, 1.5301, 14.8032, 3.3385, 14.8032)
    ..cubicTo(3.9104, 14.8032, 4.1621, 14.8032, 4.8995, 14.8032)
    ..cubicTo(5.3787, 15.236, 6.5533, 15.8465, 7.9212, 15.9005)
    ..lineTo(10.1511, 15.9005)
    ..lineTo(12.0789, 15.9005)
    ..cubicTo(13.4467, 15.8465, 14.6214, 15.236, 15.1005, 14.8032)
    ..cubicTo(15.734, 14.8032, 16.082, 14.8032, 16.6538, 14.8032)
    ..cubicTo(18.4622, 14.8032, 19.7141, 13.5126, 19.7141, 11.6502)
    ..cubicTo(19.7141, 10.7073, 19.6137, 10.1819, 18.7249, 9.2931)
    ..cubicTo(19.4282, 8.559, 19.7141, 7.6857, 19.7141, 6.8279)
    ..cubicTo(19.7141, 4.9809, 18.2921, 3.273, 16.5147, 3.0644)
    ..cubicTo(16.4374, 1.2792, 14.4513, 0.0041, 12.5503, 0.0041)
    ..cubicTo(11.5765, 0.0041, 10.6723, 0.3055, 10, 1.001)
    ..cubicTo(9.3277, 0.3055, 8.4235, 0.0041, 7.4498, 0.0041)
    ..cubicTo(5.5487, 0.0041, 3.5626, 1.2792, 3.4853, 3.0644)
    ..cubicTo(1.7079, 3.273, 0.2782, 4.9809, 0.2782, 6.8279)
    ..cubicTo(0.2782, 7.6857, 0.5719, 8.559, 1.2751, 9.2931)
    ..cubicTo(0.3864, 10.1819, 0.2782, 10.7073, 0.2782, 11.6502)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Tree._viewBoxWidth;
    final scaleY = size.height / _Tree._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Tree._viewBoxMinX, -_Tree._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TreePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/whatsapp.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Whatsapp extends StatelessWidget with _DotdartSvgSizing {
  const _Whatsapp({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Whatsapp._svgWidth;

  @override
  double get svgNativeHeight => _Whatsapp._svgHeight;

  @override
  double get svgViewBoxWidth => _Whatsapp._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Whatsapp._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _WhatsappPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _WhatsappPainter extends CustomPainter {
  _WhatsappPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.683032086,
    0.0,
    0.0,
    0.0,
    0.0,
    0.683032086,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.169679137,
    3.169679137,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(10.0589, -0)
    ..cubicTo(12.6376, 0.0152, 15.1111, 1.0175, 16.9622, 2.7969)
    ..cubicTo(18.8132, 4.5763, 19.899, 6.9957, 19.9931, 9.5498)
    ..cubicTo(20.0421, 10.8574, 19.8297, 12.1621, 19.3674, 13.3877)
    ..cubicTo(18.9052, 14.6131, 18.2024, 15.7355, 17.3002, 16.6904)
    ..cubicTo(16.3978, 17.6455, 15.3133, 18.4146, 14.1097, 18.9522)
    ..cubicTo(12.906, 19.4897, 11.6063, 19.7859, 10.2865, 19.8232)
    ..lineTo(10.0008, 19.8232)
    ..cubicTo(8.5005, 19.8236, 7.0188, 19.4892, 5.6663, 18.8457)
    ..lineTo(0.4322, 20)
    ..lineTo(0.4174, 20)
    ..cubicTo(0.4064, 19.9999, 0.3948, 19.9977, 0.3849, 19.9932)
    ..cubicTo(0.375, 19.9886, 0.3664, 19.9818, 0.3592, 19.9736)
    ..cubicTo(0.3521, 19.9655, 0.3466, 19.9557, 0.3435, 19.9453)
    ..cubicTo(0.3404, 19.935, 0.3391, 19.9237, 0.3405, 19.9131)
    ..lineTo(1.2254, 14.668)
    ..cubicTo(0.3926, 13.1578, -0.0291, 11.459, 0.0016, 9.7383)
    ..cubicTo(0.0323, 8.0174, 0.5144, 6.3336, 1.4007, 4.8535)
    ..cubicTo(2.2871, 3.3735, 3.547, 2.1479, 5.0564, 1.2969)
    ..cubicTo(6.5658, 0.4459, 8.273, -0.0012, 10.0097, -0)
    ..lineTo(10.0589, -0)
    ..close()
    ..moveTo(6.4319, 5.1328)
    ..cubicTo(6.3402, 5.1437, 6.2505, 5.1687, 6.1658, 5.2061)
    ..cubicTo(6.053, 5.256, 5.9507, 5.3275, 5.8663, 5.417)
    ..cubicTo(5.628, 5.6593, 4.9619, 6.2425, 4.9233, 7.4668)
    ..cubicTo(4.8848, 8.6905, 5.7469, 9.9014, 5.8683, 10.0723)
    ..cubicTo(5.989, 10.2421, 7.5188, 12.8874, 10.0382, 13.96)
    ..cubicTo(11.519, 14.5922, 12.1684, 14.7002, 12.5893, 14.7002)
    ..cubicTo(12.7626, 14.7002, 12.8939, 14.6829, 13.0307, 14.6748)
    ..cubicTo(13.4924, 14.6464, 14.5337, 14.1177, 14.761, 13.543)
    ..cubicTo(14.9882, 12.968, 15.0032, 12.4648, 14.9432, 12.3643)
    ..cubicTo(14.8834, 12.2637, 14.7187, 12.1912, 14.4713, 12.0625)
    ..cubicTo(14.2231, 11.9334, 13.0096, 11.2906, 12.7815, 11.2002)
    ..cubicTo(12.697, 11.1613, 12.6062, 11.1377, 12.5134, 11.1309)
    ..cubicTo(12.4528, 11.134, 12.3931, 11.1518, 12.3409, 11.1826)
    ..cubicTo(12.289, 11.2134, 12.2454, 11.2564, 12.2139, 11.3076)
    ..cubicTo(12.0111, 11.5579, 11.5454, 12.1019, 11.3892, 12.2588)
    ..cubicTo(11.3551, 12.2977, 11.313, 12.3287, 11.266, 12.3506)
    ..cubicTo(11.2189, 12.3724, 11.1673, 12.3848, 11.1152, 12.3857)
    ..cubicTo(11.0194, 12.3815, 10.9253, 12.3566, 10.8403, 12.3125)
    ..cubicTo(10.1049, 12.003, 9.4346, 11.5589, 8.8637, 11.0049)
    ..cubicTo(8.3304, 10.4839, 7.8776, 9.8878, 7.5207, 9.2354)
    ..cubicTo(7.3828, 8.982, 7.521, 8.851, 7.6468, 8.7324)
    ..cubicTo(7.7725, 8.6138, 7.9074, 8.4503, 8.037, 8.3086)
    ..cubicTo(8.1436, 8.1875, 8.2326, 8.0519, 8.3011, 7.9063)
    ..cubicTo(8.3364, 7.8388, 8.3535, 7.7635, 8.3523, 7.6875)
    ..cubicTo(8.3511, 7.6113, 8.3308, 7.5362, 8.2932, 7.4697)
    ..cubicTo(8.2328, 7.3413, 7.7867, 6.0981, 7.5769, 5.5986)
    ..cubicTo(7.4065, 5.1716, 7.2035, 5.1566, 7.026, 5.1436)
    ..cubicTo(6.8801, 5.1335, 6.7125, 5.1291, 6.5452, 5.124)
    ..lineTo(6.5235, 5.124)
    ..lineTo(6.4319, 5.1328)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Whatsapp._viewBoxWidth;
    final scaleY = size.height / _Whatsapp._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Whatsapp._viewBoxMinX, -_Whatsapp._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WhatsappPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/wifi.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Wifi extends StatelessWidget with _DotdartSvgSizing {
  const _Wifi({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Wifi._svgWidth;

  @override
  double get svgNativeHeight => _Wifi._svgHeight;

  @override
  double get svgViewBoxWidth => _Wifi._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Wifi._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _WifiPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _WifiPainter extends CustomPainter {
  _WifiPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.829757384,
    0.0,
    0.0,
    0.0,
    0.0,
    0.829757384,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.702426155,
    1.922830461,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(10.2765, 2.0521)
    ..cubicTo(13.8984, 2.1023, 17.0889, 3.4632, 19.5924, 6.1955)
    ..cubicTo(20.1346, 6.7873, 20.0953, 7.7062, 19.5038, 8.2485)
    ..cubicTo(18.9119, 8.7909, 17.9918, 8.7505, 17.4495, 8.1586)
    ..cubicTo(15.5924, 6.1319, 13.2269, 5.0009, 10.2353, 4.9596)
    ..cubicTo(7.2428, 4.9183, 4.365, 5.9469, 2.5234, 7.9157)
    ..cubicTo(1.9751, 8.502, 1.0547, 8.5334, 0.4684, 7.985)
    ..cubicTo(-0.1178, 7.4366, -0.148, 6.5162, 0.4003, 5.9299)
    ..cubicTo(2.9194, 3.2368, 6.6556, 2.002, 10.2765, 2.0521)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(10.1709, 7.7996)
    ..cubicTo(12.2003, 7.8279, 13.6538, 8.3742, 15.1729, 9.6772)
    ..cubicTo(15.7619, 10.1824, 15.8299, 11.0691, 15.3247, 11.6581)
    ..cubicTo(14.8194, 12.2471, 13.9327, 12.3152, 13.3437, 11.8099)
    ..cubicTo(12.4403, 11.035, 11.6751, 10.6313, 10.1315, 10.6098)
    ..cubicTo(8.5767, 10.5882, 7.2605, 11.05, 6.5328, 11.8099)
    ..cubicTo(5.9962, 12.3704, 5.1067, 12.3897, 4.5461, 11.853)
    ..cubicTo(3.9858, 11.3163, 3.9664, 10.4268, 4.503, 9.8663)
    ..cubicTo(5.9558, 8.3491, 8.1525, 7.7715, 10.1709, 7.7996)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(8.5081, 16.6962)
    ..cubicTo(9.0677, 17.6651, 10.4664, 17.6649, 11.0257, 16.6958)
    ..lineTo(11.8065, 15.343)
    ..cubicTo(12.3658, 14.3738, 11.6662, 13.1626, 10.5473, 13.1628)
    ..lineTo(8.9853, 13.1631)
    ..cubicTo(7.8664, 13.1633, 7.1672, 14.3747, 7.7269, 15.3436)
    ..lineTo(8.5081, 16.6962)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Wifi._viewBoxWidth;
    final scaleY = size.height / _Wifi._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Wifi._viewBoxMinX, -_Wifi._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WifiPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/wifi-exclamation-mark.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _WifiExclamationMark extends StatelessWidget with _DotdartSvgSizing {
  const _WifiExclamationMark({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _WifiExclamationMark._svgWidth;

  @override
  double get svgNativeHeight => _WifiExclamationMark._svgHeight;

  @override
  double get svgViewBoxWidth => _WifiExclamationMark._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _WifiExclamationMark._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _WifiExclamationMarkPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _WifiExclamationMarkPainter extends CustomPainter {
  _WifiExclamationMarkPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.820632519,
    0.0,
    0.0,
    0.0,
    0.0,
    0.820632519,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.793674808,
    1.614161444,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(0.4013, 8.2886)
    ..cubicTo(-0.0658, 7.9216, -0.1444, 7.2473, 0.2675, 6.8211)
    ..cubicTo(5.0995, 1.8201, 13.3513, 1.6412, 18.349, 6.7981)
    ..cubicTo(18.7614, 7.2237, 18.6859, 7.8985, 18.2203, 8.2673)
    ..lineTo(17.8312, 8.5755)
    ..cubicTo(17.3655, 8.9443, 16.6873, 8.8668, 16.2652, 8.4505)
    ..cubicTo(12.3752, 4.6136, 6.1329, 4.7343, 2.3582, 8.4654)
    ..cubicTo(1.9366, 8.8822, 1.2589, 8.9622, 0.7918, 8.5952)
    ..lineTo(0.4013, 8.2886)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(0.4013, 8.2886)
    ..cubicTo(-0.0658, 7.9216, -0.1444, 7.2473, 0.2675, 6.8211)
    ..cubicTo(5.0995, 1.8201, 13.3513, 1.6412, 18.349, 6.7981)
    ..cubicTo(18.7614, 7.2237, 18.6859, 7.8985, 18.2203, 8.2673)
    ..lineTo(17.8312, 8.5755)
    ..cubicTo(17.3655, 8.9443, 16.6873, 8.8668, 16.2652, 8.4505)
    ..cubicTo(12.3752, 4.6136, 6.1329, 4.7343, 2.3582, 8.4654)
    ..cubicTo(1.9366, 8.8822, 1.2589, 8.9622, 0.7918, 8.5952)
    ..lineTo(0.4013, 8.2886)
    ..close();

  static final Path __path2 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(17.0953, 10.6603)
    ..cubicTo(16.418, 9.5894, 14.8324, 9.5894, 14.155, 10.6603)
    ..lineTo(11.514, 14.836)
    ..cubicTo(10.7972, 15.9693, 11.6264, 17.4355, 12.9842, 17.4355)
    ..lineTo(18.2662, 17.4355)
    ..cubicTo(19.6239, 17.4355, 20.4531, 15.9693, 19.7364, 14.836)
    ..lineTo(17.0953, 10.6603)
    ..close()
    ..moveTo(15.625, 12.3315)
    ..cubicTo(15.386, 12.3315, 15.1923, 12.5219, 15.1923, 12.7568)
    ..lineTo(15.1923, 14.0328)
    ..cubicTo(15.1923, 14.2677, 15.386, 14.4581, 15.625, 14.4581)
    ..cubicTo(15.8641, 14.4581, 16.0578, 14.2677, 16.0578, 14.0328)
    ..lineTo(16.0578, 12.7568)
    ..cubicTo(16.0578, 12.5219, 15.8641, 12.3315, 15.625, 12.3315)
    ..close()
    ..moveTo(16.166, 15.3088)
    ..cubicTo(16.166, 15.0152, 15.9239, 14.7771, 15.625, 14.7771)
    ..cubicTo(15.3263, 14.7771, 15.0841, 15.0152, 15.0841, 15.3088)
    ..cubicTo(15.0841, 15.6025, 15.3263, 15.8404, 15.625, 15.8404)
    ..cubicTo(15.9239, 15.8404, 16.166, 15.6025, 16.166, 15.3088)
    ..close();

  static final Path __path3 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(17.0953, 10.6603)
    ..cubicTo(16.418, 9.5894, 14.8324, 9.5894, 14.155, 10.6603)
    ..lineTo(11.514, 14.836)
    ..cubicTo(10.7972, 15.9693, 11.6264, 17.4355, 12.9842, 17.4355)
    ..lineTo(18.2662, 17.4355)
    ..cubicTo(19.6239, 17.4355, 20.4531, 15.9693, 19.7364, 14.836)
    ..lineTo(17.0953, 10.6603)
    ..close()
    ..moveTo(15.625, 12.3315)
    ..cubicTo(15.386, 12.3315, 15.1923, 12.5219, 15.1923, 12.7568)
    ..lineTo(15.1923, 14.0328)
    ..cubicTo(15.1923, 14.2677, 15.386, 14.4581, 15.625, 14.4581)
    ..cubicTo(15.8641, 14.4581, 16.0578, 14.2677, 16.0578, 14.0328)
    ..lineTo(16.0578, 12.7568)
    ..cubicTo(16.0578, 12.5219, 15.8641, 12.3315, 15.625, 12.3315)
    ..close()
    ..moveTo(16.166, 15.3088)
    ..cubicTo(16.166, 15.0152, 15.9239, 14.7771, 15.625, 14.7771)
    ..cubicTo(15.3263, 14.7771, 15.0841, 15.0152, 15.0841, 15.3088)
    ..cubicTo(15.0841, 15.6025, 15.3263, 15.8404, 15.625, 15.8404)
    ..cubicTo(15.9239, 15.8404, 16.166, 15.6025, 16.166, 15.3088)
    ..close();

  static final Path __path4 = Path()
    ..moveTo(9.2371, 12.84)
    ..cubicTo(9.8153, 12.8767, 10.2721, 12.9639, 10.6587, 13.1174)
    ..cubicTo(10.9444, 13.2308, 11.0183, 13.5743, 10.8558, 13.8314)
    ..lineTo(10.5821, 14.2644)
    ..cubicTo(10.2759, 14.7485, 10.1425, 15.2696, 10.1519, 15.7756)
    ..cubicTo(10.1553, 15.9577, 10.0912, 16.1382, 9.9539, 16.2606)
    ..lineTo(9.8976, 16.3109)
    ..cubicTo(9.5227, 16.6443, 8.9511, 16.6421, 8.5788, 16.3059)
    ..lineTo(7.0948, 14.9655)
    ..cubicTo(6.698, 14.6069, 6.6609, 13.9859, 7.076, 13.6415)
    ..cubicTo(7.7988, 13.0419, 8.4246, 12.8484, 9.2357, 12.84)
    ..lineTo(9.2371, 12.84)
    ..close();

  static final Path __path5 = Path()
    ..moveTo(9.2371, 12.84)
    ..cubicTo(9.779, 12.8745, 10.2143, 12.9531, 10.585, 13.0892)
    ..cubicTo(10.9149, 13.2103, 10.9999, 13.6035, 10.814, 13.8975)
    ..lineTo(10.5821, 14.2644)
    ..cubicTo(10.2843, 14.7352, 10.15, 15.2412, 10.1515, 15.734)
    ..cubicTo(10.1521, 15.9422, 10.0795, 16.1485, 9.9226, 16.2886)
    ..lineTo(9.8976, 16.3109)
    ..cubicTo(9.5227, 16.6443, 8.9511, 16.6421, 8.5788, 16.3059)
    ..lineTo(7.0948, 14.9655)
    ..cubicTo(6.698, 14.6069, 6.6609, 13.9859, 7.076, 13.6415)
    ..cubicTo(7.7988, 13.0419, 8.4246, 12.8484, 9.2357, 12.84)
    ..lineTo(9.2371, 12.84)
    ..close();

  static final Path __path6 = Path()
    ..moveTo(9.4518, 8.0674)
    ..cubicTo(10.8007, 8.0696, 11.9952, 8.5263, 13.1114, 9.2767)
    ..cubicTo(13.4068, 9.4754, 13.4242, 9.8871, 13.2353, 10.1858)
    ..lineTo(12.9979, 10.561)
    ..cubicTo(12.5671, 11.2423, 11.6354, 11.356, 10.8957, 11.0172)
    ..cubicTo(10.4293, 10.8035, 9.9527, 10.6877, 9.4474, 10.6869)
    ..cubicTo(8.1959, 10.685, 7.1157, 10.9567, 5.8189, 12.0145)
    ..cubicTo(5.3587, 12.3898, 4.6782, 12.4009, 4.2531, 11.9874)
    ..lineTo(3.8975, 11.6422)
    ..cubicTo(3.4726, 11.2289, 3.4654, 10.5501, 3.917, 10.1652)
    ..cubicTo(5.6647, 8.6765, 7.3731, 8.0642, 9.4518, 8.0674)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _WifiExclamationMark._viewBoxWidth;
    final scaleY = size.height / _WifiExclamationMark._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_WifiExclamationMark._viewBoxMinX,
        -_WifiExclamationMark._viewBoxMinY,
      );

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path4, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path5, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(__path6, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WifiExclamationMarkPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/wine-glass.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _WineGlass extends StatelessWidget with _DotdartSvgSizing {
  const _WineGlass({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _WineGlass._svgWidth;

  @override
  double get svgNativeHeight => _WineGlass._svgHeight;

  @override
  double get svgViewBoxWidth => _WineGlass._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _WineGlass._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _WineGlassPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _WineGlassPainter extends CustomPainter {
  _WineGlassPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.695727558,
    0.0,
    0.0,
    0.0,
    0.0,
    0.695727558,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    3.097078133,
    3.042724417,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(9.9248, 20)
    ..cubicTo(13.0096, 19.9983, 14.8486, 19.2172, 14.8486, 17.8764)
    ..cubicTo(14.8486, 16.9419, 13.9518, 16.2808, 12.3653, 15.9654)
    ..cubicTo(11.4166, 15.7768, 10.6476, 15.0093, 10.6476, 14.0421)
    ..cubicTo(10.6476, 13.1003, 11.3844, 12.3458, 12.283, 12.0637)
    ..cubicTo(14.64, 11.3237, 16.096, 9.4219, 16.096, 6.8552)
    ..cubicTo(16.096, 5.12, 15.3782, 2.855, 14.3177, 1.2316)
    ..cubicTo(13.8053, 0.4388, 12.2071, 0, 9.9277, 0)
    ..cubicTo(7.6526, 0, 6.0511, 0.4388, 5.5364, 1.2316)
    ..cubicTo(4.4832, 2.8532, 3.7671, 5.1183, 3.7671, 6.8552)
    ..cubicTo(3.7671, 9.4294, 5.2259, 11.3279, 7.588, 12.0655)
    ..cubicTo(8.4857, 12.3458, 9.2213, 13.0992, 9.2213, 14.0397)
    ..cubicTo(9.2213, 15.0075, 8.4504, 15.7745, 7.501, 15.9621)
    ..cubicTo(5.9109, 16.2762, 5.0145, 16.9417, 5.0145, 17.8764)
    ..cubicTo(5.0145, 19.2187, 6.8433, 19.9983, 9.9248, 20)
    ..close()
    ..moveTo(9.9277, 2.1682)
    ..cubicTo(8.1096, 2.1682, 6.8498, 1.9495, 6.8498, 1.6803)
    ..cubicTo(6.8498, 1.4216, 8.1198, 1.2102, 9.9277, 1.2102)
    ..cubicTo(11.7489, 1.2102, 13.0116, 1.4216, 13.0116, 1.6803)
    ..cubicTo(13.0116, 1.9495, 11.7518, 2.1682, 9.9277, 2.1682)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _WineGlass._viewBoxWidth;
    final scaleY = size.height / _WineGlass._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_WineGlass._viewBoxMinX, -_WineGlass._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WineGlassPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/wrench.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Wrench extends StatelessWidget with _DotdartSvgSizing {
  const _Wrench({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor,
  });

  static const double _svgWidth = 20;
  static const double _svgHeight = 20;
  static const double _viewBoxMinX = 0;
  static const double _viewBoxMinY = 0;
  static const double _viewBoxWidth = 20;
  static const double _viewBoxHeight = 20;

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff000000.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Wrench._svgWidth;

  @override
  double get svgNativeHeight => _Wrench._svgHeight;

  @override
  double get svgViewBoxWidth => _Wrench._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Wrench._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _WrenchPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _WrenchPainter extends CustomPainter {
  _WrenchPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.725366177,
    0.0,
    0.0,
    0.0,
    0.0,
    0.725366177,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.746338228,
    2.735004382,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(20.0001, 7.5086)
    ..cubicTo(20.0001, 11.6367, 16.6536, 14.9832, 12.5255, 14.9832)
    ..cubicTo(11.4958, 14.9832, 10.5147, 14.775, 9.6222, 14.3984)
    ..lineTo(4.6433, 19.3772)
    ..cubicTo(3.7675, 20.253, 2.3478, 20.253, 1.4721, 19.3772)
    ..lineTo(0.6568, 18.562)
    ..cubicTo(-0.2189, 17.6863, -0.2189, 16.2665, 0.6568, 15.3908)
    ..lineTo(5.6357, 10.4119)
    ..cubicTo(5.2591, 9.5193, 5.0509, 8.5383, 5.0509, 7.5086)
    ..cubicTo(5.0509, 3.3805, 8.3973, 0.034, 12.5255, 0.034)
    ..cubicTo(13.466, 0.034, 14.3659, 0.2077, 15.195, 0.5248)
    ..cubicTo(15.661, 0.7031, 15.7477, 1.2965, 15.3949, 1.6493)
    ..lineTo(12.0272, 5.0171)
    ..cubicTo(11.2015, 5.8427, 11.2015, 7.1813, 12.0272, 8.0069)
    ..cubicTo(12.8528, 8.8325, 14.1913, 8.8325, 15.017, 8.0069)
    ..lineTo(18.3848, 4.6391)
    ..cubicTo(18.7376, 4.2863, 19.331, 4.373, 19.5093, 4.839)
    ..cubicTo(19.8264, 5.6681, 20.0001, 6.568, 20.0001, 7.5086)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Wrench._viewBoxWidth;
    final scaleY = size.height / _Wrench._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Wrench._viewBoxMinX, -_Wrench._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WrenchPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}
