import 'package:flutter/material.dart';
import 'package:mateo_mobile_old/src/gen/icons.g.dart';

/// Mateo-design-system icons.
///
/// Each static method returns a [Widget] rendered via a [CustomPainter]
/// — no runtime SVG parser dependency.
///
/// All current icons are monochrome; the `color` param recolors the entire
/// icon.
///
/// ```dart
/// MateoIcon.cross(width: 16, height: 16, color: Colors.red);
/// ```
abstract final class MateoIcon {
  MateoIcon._();

  /// Arrow pointing down.
  static Widget arrowDown({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.arrowDown(key: key, width: width, height: height, color1: color);

  /// Arrow pointing left.
  static Widget arrowLeft({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.arrowLeft(key: key, width: width, height: height, color1: color);

  /// Arrow pointing right.
  static Widget arrowRight({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.arrowRight(key: key, width: width, height: height, color1: color);

  /// Circular arrow (retry/refresh).
  static Widget arrowRotateClockwise({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.arrowRotateClockwise(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Arrow pointing up.
  static Widget arrowUp({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.arrowUp(key: key, width: width, height: height, color1: color);

  /// Bank building icon.
  static Widget bankBuilding({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.bankBuilding(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Banknote with a pin icon.
  static Widget banknotePin({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.banknotePin(key: key, width: width, height: height, color1: color);

  /// Beer mug icon.
  static Widget beerMug({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.beerMug(key: key, width: width, height: height, color1: color);

  /// Bicycle icon.
  static Widget bicycle({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.bicycle(key: key, width: width, height: height, color1: color);

  /// Horizontal range or two-direction icon.
  static Widget bidirecionalHorizontalArrow({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.bidirecionalHorizontalArrow(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Book icon.
  static Widget book({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.book(key: key, width: width, height: height, color1: color);

  /// Box with a pencil icon.
  static Widget boxPencil({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.boxPencil(key: key, width: width, height: height, color1: color);

  /// Broom icon.
  static Widget broom({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.broom(key: key, width: width, height: height, color1: color);

  /// Buildings icon.
  static Widget buildings({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.buildings(key: key, width: width, height: height, color1: color);

  /// Bus viewed from the front.
  static Widget busFront({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.busFront(key: key, width: width, height: height, color1: color);

  /// Checkered flag icon.
  static Widget checkeredFlag({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.checkeredFlag(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Checkmark icon.
  static Widget checkmark({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.checkmark(key: key, width: width, height: height, color1: color);

  /// Chevron pointing down.
  static Widget chevronDown({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.chevronDown(key: key, width: width, height: height, color1: color);

  /// Chevron pointing left.
  static Widget chevronLeft({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.chevronLeft(key: key, width: width, height: height, color1: color);

  /// Blocked / circle-slash icon.
  static Widget circleBlock({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.circleBlock(key: key, width: width, height: height, color1: color);

  /// Checkmark in a circle.
  static Widget circleCheck({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.circleCheck(key: key, width: width, height: height, color1: color);

  /// Information mark in a circle.
  static Widget circleInfo({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.circleInfo(key: key, width: width, height: height, color1: color);

  /// Classical columned building icon.
  static Widget classicBuilding({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.classicBuilding(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Clock icon.
  static Widget clock({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.clock(key: key, width: width, height: height, color1: color);

  /// Close / cross icon.
  static Widget cross({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.cross(key: key, width: width, height: height, color1: color);

  /// Disco ball icon.
  static Widget discoBall({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.discoBall(key: key, width: width, height: height, color1: color);

  /// Two crosses icon.
  static Widget doubleCross({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.doubleCross(key: key, width: width, height: height, color1: color);

  /// Drop icon.
  static Widget drop({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.drop(key: key, width: width, height: height, color1: color);

  /// Drop with foam icon.
  static Widget dropFoam({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.dropFoam(key: key, width: width, height: height, color1: color);

  /// Dumbbell icon.
  static Widget dumbbell({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.dumbbell(key: key, width: width, height: height, color1: color);

  /// Eraser icon.
  static Widget eraser({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.eraser(key: key, width: width, height: height, color1: color);

  /// Electric vehicle plug icon.
  static Widget evPlug({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.evPlug(key: key, width: width, height: height, color1: color);

  /// Exclamation circle icon.
  static Widget exclamationCircle({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.exclamationCircle(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Exclamation triangle icon.
  static Widget exclamationTriangle({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.exclamationTriangle(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Ferris wheel icon.
  static Widget ferrisWheel({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.ferrisWheel(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Flame icon.
  static Widget flame({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.flame(key: key, width: width, height: height, color1: color);

  /// Fork and knife icon.
  static Widget forkKnife({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.forkKnife(key: key, width: width, height: height, color1: color);

  /// Gas station icon.
  static Widget gasStation({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.gasStation(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Gear icon.
  static Widget gear({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.gear(key: key, width: width, height: height, color1: color);

  /// Gift icon.
  static Widget gift({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.gift(key: key, width: width, height: height, color1: color);

  /// Government building icon.
  static Widget governmentBuilding({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.governmentBuilding(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Graduation cap icon.
  static Widget graduateCap({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.graduateCap(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Handshake icon.
  static Widget handshake({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.handshake(key: key, width: width, height: height, color1: color);

  /// Helicopter viewed from the front.
  static Widget helicopterFront({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.helicopterFront(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Hookah icon.
  static Widget hookah({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.hookah(key: key, width: width, height: height, color1: color);

  /// Hot coffee cup icon.
  static Widget hotCoffeeCup({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.hotCoffeeCup(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Information icon.
  static Widget info({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.info(key: key, width: width, height: height, color1: color);

  /// Lightning bolt icon.
  static Widget lightningBolt({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.lightningBolt(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Magnifying glass icon.
  static Widget magnifierGlass({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.magnifierGlass(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Magnifying glass with a sad face icon.
  static Widget magnifyingGlassSadFace({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.magnifyingGlassSadFace(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Map pin icon.
  static Widget mapPin({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.mapPin(key: key, width: width, height: height, color1: color);

  /// Martini glass icon.
  static Widget matiniGlass({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.matiniGlass(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Medical cross icon.
  static Widget medicalCross({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.medicalCross(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Paper plane pointing up and right.
  static Widget paperPlaneUpRight({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.paperPlaneUpRight(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Parking sign icon.
  static Widget parkingSign({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.parkingSign(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Pencil icon.
  static Widget pencil({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.pencil(key: key, width: width, height: height, color1: color);

  /// Phone handset icon.
  static Widget phone({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.phone(key: key, width: width, height: height, color1: color);

  /// Pills icon.
  static Widget pills({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.pills(key: key, width: width, height: height, color1: color);

  /// Plane pointing up and right.
  static Widget planeUpRight({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.planeUpRight(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Pointer hand pointing up icon.
  static Widget pointerHandUp({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.pointerHandUp(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Police badge icon.
  static Widget policeBadge({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.policeBadge(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Popcorn icon.
  static Widget popcorn({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.popcorn(key: key, width: width, height: height, color1: color);

  /// Praying figure icon.
  static Widget prayingFigure({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.prayingFigure(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Question mark icon.
  static Widget questionmark({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.questionmark(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Stack of rectangles icon.
  static Widget rectangleStack({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.rectangleStack(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Road icon.
  static Widget road({Key? key, double? width, double? height, Color? color}) =>
      $Icons.road(key: key, width: width, height: height, color1: color);

  /// Running figure icon.
  static Widget runningFigure({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.runningFigure(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Sad emoticon icon.
  static Widget sadEmoticon({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.sadEmoticon(key: key, width: width, height: height, color1: color);

  /// Sad and happy theatre masks icon.
  static Widget sadMaskHappyMask({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.sadMaskHappyMask(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Scissors icon.
  static Widget scissors({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.scissors(key: key, width: width, height: height, color1: color);

  /// Shopping bag icon.
  static Widget shoppingBag({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.shoppingBag(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Shopping cart icon.
  static Widget shoppingCart({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.shoppingCart(
    key: key,
    width: width,
    height: height,
    color1: color,
    color2: color,
  );

  /// Sleeping figure icon.
  static Widget sleepingFigure({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.sleepingFigure(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Smartphone icon.
  static Widget smartphone({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.smartphone(key: key, width: width, height: height, color1: color);

  /// Stadium icon.
  static Widget stadium({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.stadium(
    key: key,
    width: width,
    height: height,
    color1: color,
    color2: color,
  );

  /// Star icon.
  static Widget star({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.star(key: key, width: width, height: height, color1: color);

  /// Tire icon.
  static Widget tire({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.tire(key: key, width: width, height: height, color1: color);

  /// Train viewed from the front.
  static Widget trainFront({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.trainFront(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Trash can icon.
  static Widget trash({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.trash(key: key, width: width, height: height, color1: color);

  /// Tree icon.
  static Widget tree({Key? key, double? width, double? height, Color? color}) =>
      $Icons.tree(key: key, width: width, height: height, color1: color);

  /// WhatsApp icon.
  static Widget whatsapp({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.whatsapp(key: key, width: width, height: height, color1: color);

  /// Wi-Fi icon.
  static Widget wifi({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.wifi(key: key, width: width, height: height, color1: color);

  /// WiFi connection with exclamation mark (no internet).
  static Widget wifiExclamation({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.wifiExclamation(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Wine glass icon.
  static Widget wineGlass({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.wineGlass(
    key: key,
    width: width,
    height: height,
    color1: color,
  );

  /// Wrench / tool icon.
  static Widget wrench({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.wrench(key: key, width: width, height: height, color1: color);

  /// Plus / More Icon
  static Widget plusSignal({
    Key? key,
    double? width,
    double? height,
    Color? color,
  }) => $Icons.plusSignal(key: key, width: width, height: height, color1: color);
}
