part of 'mateo_icon.dart';

/// An icon from the Mateo catalog.
@RecordUse()
enum MateoIconData {
  /// The arrow down icon.
  arrowDown,

  /// The arrow left icon.
  arrowLeft,

  /// The arrow right icon.
  arrowRight,

  /// The arrow rotate clockwise icon.
  arrowRotateClockwise,

  /// The arrow up icon.
  arrowUp,

  /// The bank building icon.
  bankBuilding,

  /// The banknote pin icon.
  banknotePin,

  /// The beer mug icon.
  beerMug,

  /// The bicycle icon.
  bicycle,

  /// The bidirecional horizontal arrow icon.
  bidirecionalHorizontalArrow,

  /// The book icon.
  book,

  /// The box pencil icon.
  boxPencil,

  /// The broom icon.
  broom,

  /// The buildings icon.
  buildings,

  /// The bus front icon.
  busFront,

  /// The checkered flag icon.
  checkeredFlag,

  /// The checkmark icon.
  checkmark,

  /// The chevron down icon.
  chevronDown,

  /// The chevron left icon.
  chevronLeft,

  /// The filled circle icon.
  circle,

  /// The circle block icon.
  circleBlock,

  /// The circle check icon.
  circleCheck,

  /// The circle info icon.
  circleInfo,

  /// The classic building icon.
  classicBuilding,

  /// The clock icon.
  clock,

  /// The cross icon.
  cross,

  /// The cross in a circle icon.
  crossCircle,

  /// The disco ball icon.
  discoBall,

  /// The double cross icon.
  doubleCross,

  /// The drop icon.
  drop,

  /// The drop foam icon.
  dropFoam,

  /// The dumbbell icon.
  dumbbell,

  /// The eraser icon.
  eraser,

  /// The ev plug icon.
  evPlug,

  /// The exclamation circle icon.
  exclamationCircle,

  /// The exclamation triangle icon.
  exclamationTriangle,

  /// The ferris wheel icon.
  ferrisWheel,

  /// The figure crop circle icon.
  figureCropCircle,

  /// The flame icon.
  flame,

  /// The fork knife icon.
  forkKnife,

  /// The gas station icon.
  gasStation,

  /// The gear icon.
  gear,

  /// The gift icon.
  gift,

  /// The government building icon.
  governmentBuilding,

  /// The graduate cap icon.
  graduateCap,

  /// The handshake icon.
  handshake,

  /// The helicopter front icon.
  helicopterFront,

  /// The hookah icon.
  hookah,

  /// The hot coffee cup icon.
  hotCoffeeCup,

  /// The info icon.
  info,

  /// The letters A, B, C, and D icon.
  letters,

  /// The lightning bolt icon.
  lightningBolt,

  /// The logout icon.
  logout,

  /// The magnifier glass icon.
  magnifierGlass,

  /// The magnifying glass sad face icon.
  magnifyingGlassSadFace,

  /// The map pin icon.
  mapPin,

  /// The matini glass icon.
  matiniGlass,

  /// The medical cross icon.
  medicalCross,

  /// The numbers 1, 2, 3, and 4 icon.
  numbers,

  /// The paper plane up right icon.
  paperPlaneUpRight,

  /// The parking sign icon.
  parkingSign,

  /// The pencil icon.
  pencil,

  /// The phone icon.
  phone,

  /// The pills icon.
  pills,

  /// The plane up right icon.
  planeUpRight,

  /// The pointer hand up icon.
  pointerHandUp,

  /// The police badge icon.
  policeBadge,

  /// The popcorn icon.
  popcorn,

  /// The praying figure icon.
  prayingFigure,

  /// The questionmark icon.
  questionmark,

  /// The rectangle stack icon.
  rectangleStack,

  /// The road icon.
  road,

  /// The running figure icon.
  runningFigure,

  /// The sad emoticon icon.
  sadEmoticon,

  /// The sad mask happy mask icon.
  sadMaskHappyMask,

  /// The scissors icon.
  scissors,

  /// The shopping bag icon.
  shoppingBag,

  /// The shopping cart icon.
  shoppingCart,

  /// The sleeping figure icon.
  sleepingFigure,

  /// The smartphone icon.
  smartphone,

  /// The social media post icon.
  socialMediaPost,

  /// The stadium icon.
  stadium,

  /// The star icon.
  star,

  /// The tire icon.
  tire,

  /// The train front icon.
  trainFront,

  /// The trash icon.
  trash,

  /// The tree icon.
  tree,

  /// The whatsapp icon.
  whatsapp,

  /// The wifi icon.
  wifi,

  /// The wifi exclamation icon.
  wifiExclamation,

  /// The wine glass icon.
  wineGlass,

  /// The wrench icon.
  wrench,

  /// The plus signal icon.
  plusSignal,

  /// The closed padlock icon.
  padlock,

  /// The open padlock icon.
  padlockOpen;

  Widget _buildSvg({Color? color}) => switch (this) {
    arrowDown => $Icons.arrowDown(mateoOpticalSizeColor: color),
    arrowLeft => $Icons.arrowLeft(mateoOpticalSizeColor: color),
    arrowRight => $Icons.arrowRight(mateoOpticalSizeColor: color),
    arrowRotateClockwise => $Icons.arrowRotateClockise(mateoOpticalSizeColor: color),
    arrowUp => $Icons.arrowUp(mateoOpticalSizeColor: color),
    bankBuilding => $Icons.bankBuilding(mateoOpticalSizeColor: color),
    banknotePin => $Icons.banknotePin(mateoOpticalSizeColor: color),
    beerMug => $Icons.beerMug(mateoOpticalSizeColor: color),
    bicycle => $Icons.bicycle(mateoOpticalSizeColor: color),
    bidirecionalHorizontalArrow => $Icons.bidirecionalHorizontalArrow(mateoOpticalSizeColor: color),
    book => $Icons.book(mateoOpticalSizeColor: color),
    boxPencil => $Icons.boxPencil(mateoOpticalSizeColor: color),
    broom => $Icons.broom(mateoOpticalSizeColor: color),
    buildings => $Icons.buildings(mateoOpticalSizeColor: color),
    busFront => $Icons.busFront(mateoOpticalSizeColor: color),
    checkeredFlag => $Icons.checkeredFlag(mateoOpticalSizeColor: color),
    checkmark => $Icons.checkmark(mateoOpticalSizeColor: color),
    chevronDown => $Icons.chevronDown(mateoOpticalSizeColor: color),
    chevronLeft => $Icons.chevronLeft(mateoOpticalSizeColor: color),
    circle => $Icons.circle(mateoOpticalSizeColor: color),
    circleBlock => $Icons.circleBlock(mateoOpticalSizeColor: color),
    circleCheck => $Icons.circleCheck(mateoOpticalSizeColor: color),
    circleInfo => $Icons.circleInfo(mateoOpticalSizeColor: color),
    classicBuilding => $Icons.classicBuilding(mateoOpticalSizeColor: color),
    clock => $Icons.clock(mateoOpticalSizeColor: color),
    cross => $Icons.cross(mateoOpticalSizeColor: color),
    crossCircle => $Icons.crossCircle(mateoOpticalSizeColor: color),
    discoBall => $Icons.discoBall(mateoOpticalSizeColor: color),
    doubleCross => $Icons.doubleCross(mateoOpticalSizeColor: color),
    drop => $Icons.drop(mateoOpticalSizeColor: color),
    dropFoam => $Icons.dropFoam(mateoOpticalSizeColor: color),
    dumbbell => $Icons.dumbbell(mateoOpticalSizeColor: color),
    eraser => $Icons.eraser(mateoOpticalSizeColor: color),
    evPlug => $Icons.evPlug(mateoOpticalSizeColor: color),
    exclamationCircle => $Icons.exclamationCircle(mateoOpticalSizeColor: color),
    exclamationTriangle => $Icons.exclamationTriangle(mateoOpticalSizeColor: color),
    ferrisWheel => $Icons.ferrisWheel(mateoOpticalSizeColor: color),
    figureCropCircle => $Icons.figureCropCircle(mateoOpticalSizeColor: color),
    flame => $Icons.flame(mateoOpticalSizeColor: color),
    forkKnife => $Icons.forkKnife(mateoOpticalSizeColor: color),
    gasStation => $Icons.gasStation(mateoOpticalSizeColor: color),
    gear => $Icons.gear(mateoOpticalSizeColor: color),
    gift => $Icons.gift(mateoOpticalSizeColor: color),
    governmentBuilding => $Icons.governmentBuilding(mateoOpticalSizeColor: color),
    graduateCap => $Icons.graduateCap(mateoOpticalSizeColor: color),
    handshake => $Icons.handshake(mateoOpticalSizeColor: color),
    helicopterFront => $Icons.helicopterFront(mateoOpticalSizeColor: color),
    hookah => $Icons.hookah(mateoOpticalSizeColor: color),
    hotCoffeeCup => $Icons.hotCoffeeCup(mateoOpticalSizeColor: color),
    info => $Icons.info(mateoOpticalSizeColor: color),
    letters => $Icons.letters(mateoOpticalSizeColor: color),
    lightningBolt => $Icons.lightningBolt(mateoOpticalSizeColor: color),
    logout => $Icons.logout(mateoOpticalSizeColor: color),
    magnifierGlass => $Icons.magnifyingGlass(mateoOpticalSizeColor: color),
    magnifyingGlassSadFace => $Icons.magnifyingGlassSadFace(mateoOpticalSizeColor: color),
    mapPin => $Icons.locationPin(mateoOpticalSizeColor: color),
    matiniGlass => $Icons.matiniGlass(mateoOpticalSizeColor: color),
    medicalCross => $Icons.medicalCross(mateoOpticalSizeColor: color),
    numbers => $Icons.numbers(mateoOpticalSizeColor: color),
    padlock => $Icons.padlock(mateoOpticalSizeColor: color),
    padlockOpen => $Icons.padlockOpen(mateoOpticalSizeColor: color),
    paperPlaneUpRight => $Icons.paperPlaneUpRight(mateoOpticalSizeColor: color),
    parkingSign => $Icons.parkingSign(mateoOpticalSizeColor: color),
    pencil => $Icons.pencil(mateoOpticalSizeColor: color),
    phone => $Icons.phone(mateoOpticalSizeColor: color),
    pills => $Icons.pills(mateoOpticalSizeColor: color),
    planeUpRight => $Icons.planeUpRight(mateoOpticalSizeColor: color),
    pointerHandUp => $Icons.pointerHandUp(mateoOpticalSizeColor: color),
    policeBadge => $Icons.policeBadge(mateoOpticalSizeColor: color),
    popcorn => $Icons.popcorn(mateoOpticalSizeColor: color),
    prayingFigure => $Icons.prayingFigure(mateoOpticalSizeColor: color),
    questionmark => $Icons.questionmark(mateoOpticalSizeColor: color),
    rectangleStack => $Icons.rectangleStack(mateoOpticalSizeColor: color),
    road => $Icons.road(mateoOpticalSizeColor: color),
    runningFigure => $Icons.runningFigure(mateoOpticalSizeColor: color),
    sadEmoticon => $Icons.sadEmoticon(mateoOpticalSizeColor: color),
    sadMaskHappyMask => $Icons.sadMaskHappyMask(mateoOpticalSizeColor: color),
    scissors => $Icons.scissors(mateoOpticalSizeColor: color),
    shoppingBag => $Icons.shoppingBag(mateoOpticalSizeColor: color),
    shoppingCart => $Icons.shoppingCart(mateoOpticalSizeColor1: color, mateoOpticalSizeColor2: color),
    sleepingFigure => $Icons.sleepingFigure(mateoOpticalSizeColor: color),
    smartphone => $Icons.smartphone(mateoOpticalSizeColor: color),
    socialMediaPost => $Icons.socialMediaPost(mateoOpticalSizeColor: color),
    stadium => $Icons.stadium(mateoOpticalSizeColor1: color, mateoOpticalSizeColor2: color),
    star => $Icons.star(mateoOpticalSizeColor: color),
    tire => $Icons.tire(mateoOpticalSizeColor: color),
    trainFront => $Icons.trainFront(mateoOpticalSizeColor: color),
    trash => $Icons.trash(mateoOpticalSizeColor: color),
    tree => $Icons.tree(mateoOpticalSizeColor: color),
    whatsapp => $Icons.whatsapp(mateoOpticalSizeColor: color),
    wifi => $Icons.wifi(mateoOpticalSizeColor: color),
    wifiExclamation => $Icons.wifiExclamationMark(mateoOpticalSizeColor: color),
    wineGlass => $Icons.wineGlass(mateoOpticalSizeColor: color),
    wrench => $Icons.wrench(mateoOpticalSizeColor: color),
    plusSignal => $Icons.plusSignal(mateoOpticalSizeColor: color),
  };

  Widget _buildThreeD() => switch (this) {
    bidirecionalHorizontalArrow => $ThreeDIcons.bidirecionalHorizontalArrow(package: 'mateo_mobile'),
    handshake => $ThreeDIcons.handshake(package: 'mateo_mobile'),
    padlock => $ThreeDIcons.padlock(package: 'mateo_mobile'),
    padlockOpen => $ThreeDIcons.padlockOpen(package: 'mateo_mobile'),
    pencil => $ThreeDIcons.pencil(package: 'mateo_mobile'),
    pointerHandUp => $ThreeDIcons.pointerHandUp(package: 'mateo_mobile'),
    _ => throw UnsupportedError('Mateo icon $name has no 3D artwork.'),
  };
}
