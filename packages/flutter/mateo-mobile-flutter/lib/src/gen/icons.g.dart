// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
// *****************************************************

// coverage:ignore-file
// Generated canvas and paint sequences intentionally use repeated receiver calls.
// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;

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
/// $Icons.arrowRotateClockwise(<params>);
/// ```
/// ```dart
/// $Icons.arrowUp(<params>);
/// ```
/// ```dart
/// $Icons.banknotePin(<params>);
/// ```
/// ```dart
/// $Icons.bidirecionalHorizontalArrow(<params>);
/// ```
/// ```dart
/// $Icons.boxPen(<params>);
/// ```
/// ```dart
/// $Icons.chevronDown(<params>);
/// ```
/// ```dart
/// $Icons.chevronLeft(<params>);
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
/// $Icons.clock(<params>);
/// ```
/// ```dart
/// $Icons.cross(<params>);
/// ```
/// ```dart
/// $Icons.exclamationCircle(<params>);
/// ```
/// ```dart
/// $Icons.exclamationTriangle(<params>);
/// ```
/// ```dart
/// $Icons.handshake(<params>);
/// ```
/// ```dart
/// $Icons.magnifierGlass(<params>);
/// ```
/// ```dart
/// $Icons.mapPin(<params>);
/// ```
/// ```dart
/// $Icons.phone(<params>);
/// ```
/// ```dart
/// $Icons.plusSignal(<params>);
/// ```
/// ```dart
/// $Icons.pointerHandUp(<params>);
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
/// $Icons.smartphone(<params>);
/// ```
/// ```dart
/// $Icons.tree(<params>);
/// ```
/// ```dart
/// $Icons.whatsapp(<params>);
/// ```
/// ```dart
/// $Icons.wifiExclamation(<params>);
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
    Color? color1,
  }) => _ArrowDown(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `ArrowLeft` widget from `arrowLeft.svg`.
  static Widget arrowLeft({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _ArrowLeft(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `ArrowRight` widget from `arrowRight.svg`.
  static Widget arrowRight({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _ArrowRight(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `ArrowRotateClockwise` widget from `arrowRotateClockwise.svg`.
  static Widget arrowRotateClockwise({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _ArrowRotateClockwise(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `ArrowUp` widget from `arrowUp.svg`.
  static Widget arrowUp({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _ArrowUp(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `BanknotePin` widget from `banknotePin.svg`.
  static Widget banknotePin({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _BanknotePin(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `BidirecionalHorizontalArrow` widget from `bidirecionalHorizontalArrow.svg`.
  static Widget bidirecionalHorizontalArrow({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _BidirecionalHorizontalArrow(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `BoxPen` widget from `boxPen.svg`.
  static Widget boxPen({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _BoxPen(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `ChevronDown` widget from `chevronDown.svg`.
  static Widget chevronDown({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _ChevronDown(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `ChevronLeft` widget from `chevronLeft.svg`.
  static Widget chevronLeft({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _ChevronLeft(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `CircleBlock` widget from `circleBlock.svg`.
  static Widget circleBlock({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _CircleBlock(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `CircleCheck` widget from `circleCheck.svg`.
  static Widget circleCheck({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _CircleCheck(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `CircleInfo` widget from `circleInfo.svg`.
  static Widget circleInfo({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _CircleInfo(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `Clock` widget from `clock.svg`.
  static Widget clock({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _Clock(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `Cross` widget from `cross.svg`.
  static Widget cross({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _Cross(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `ExclamationCircle` widget from `exclamationCircle.svg`.
  static Widget exclamationCircle({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _ExclamationCircle(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `ExclamationTriangle` widget from `exclamationTriangle.svg`.
  static Widget exclamationTriangle({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _ExclamationTriangle(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `Handshake` widget from `handshake.svg`.
  static Widget handshake({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _Handshake(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `MagnifierGlass` widget from `magnifierGlass.svg`.
  static Widget magnifierGlass({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _MagnifierGlass(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `MapPin` widget from `mapPin.svg`.
  static Widget mapPin({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _MapPin(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `Phone` widget from `phone.svg`.
  static Widget phone({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _Phone(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `PlusSignal` widget from `plusSignal.svg`.
  static Widget plusSignal({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _PlusSignal(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `PointerHandUp` widget from `pointerHandUp.svg`.
  static Widget pointerHandUp({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _PointerHandUp(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `Questionmark` widget from `questionmark.svg`.
  static Widget questionmark({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _Questionmark(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `RectangleStack` widget from `rectangleStack.svg`.
  static Widget rectangleStack({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _RectangleStack(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `Road` widget from `road.svg`.
  static Widget road({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _Road(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `Smartphone` widget from `smartphone.svg`.
  static Widget smartphone({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _Smartphone(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `Tree` widget from `tree.svg`.
  static Widget tree({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _Tree(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `Whatsapp` widget from `whatsapp.svg`.
  static Widget whatsapp({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _Whatsapp(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `WifiExclamation` widget from `wifiExclamation.svg`.
  static Widget wifiExclamation({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _WifiExclamation(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );

  /// Builds the `Wrench` widget from `wrench.svg`.
  static Widget wrench({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? color1,
  }) => _Wrench(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    color1: color1,
  );
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
          painter: _ArrowDownPainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ArrowDownPainter extends CustomPainter {
  _ArrowDownPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(9.5, 20)
    ..cubicTo(9.9025, 20, 10.2886, 19.8537, 10.5733, 19.5932)
    ..lineTo(17.5555, 13.2043)
    ..cubicTo(18.1482, 12.6619, 18.1482, 11.7826, 17.5555, 11.2401)
    ..cubicTo(16.9627, 10.6978, 16.0017, 10.6978, 15.4089, 11.2401)
    ..lineTo(11.0179, 15.258)
    ..lineTo(11.0179, 1.3889)
    ..cubicTo(11.0179, 0.6218, 10.3382, -0, 9.5, -0)
    ..cubicTo(8.6617, -0, 7.9822, 0.6218, 7.9822, 1.3889)
    ..lineTo(7.9822, 15.258)
    ..lineTo(3.5911, 11.2401)
    ..cubicTo(2.9984, 10.6978, 2.0373, 10.6978, 1.4446, 11.2401)
    ..cubicTo(0.8518, 11.7826, 0.8518, 12.6619, 1.4446, 13.2043)
    ..lineTo(8.4267, 19.5932)
    ..cubicTo(8.7113, 19.8537, 9.0975, 20, 9.5, 20)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ArrowDown._viewBoxWidth;
    final scaleY = size.height / _ArrowDown._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ArrowDown._viewBoxMinX, -_ArrowDown._viewBoxMinY);

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowDownPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/arrow_left.svg`.
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
          painter: _ArrowLeftPainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ArrowLeftPainter extends CustomPainter {
  _ArrowLeftPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(8.7599, 17.5816)
    ..cubicTo(8.2174, 18.1395, 7.3381, 18.1395, 6.7957, 17.5816)
    ..lineTo(0.4068, 11.0102)
    ..cubicTo(0.1463, 10.7423, 0, 10.3789, 0, 10)
    ..cubicTo(0, 9.6212, 0.1463, 9.2578, 0.4068, 8.9898)
    ..lineTo(6.7957, 2.4184)
    ..cubicTo(7.3381, 1.8605, 8.2174, 1.8605, 8.7599, 2.4184)
    ..cubicTo(9.3022, 2.9763, 9.3022, 3.8808, 8.7599, 4.4387)
    ..lineTo(4.742, 8.5714)
    ..lineTo(18.6111, 8.5714)
    ..cubicTo(19.3782, 8.5714, 20, 9.2111, 20, 10)
    ..cubicTo(20, 10.789, 19.3782, 11.4286, 18.6111, 11.4286)
    ..lineTo(4.742, 11.4286)
    ..lineTo(8.7599, 15.5613)
    ..cubicTo(9.3022, 16.1192, 9.3022, 17.0237, 8.7599, 17.5816)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ArrowLeft._viewBoxWidth;
    final scaleY = size.height / _ArrowLeft._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ArrowLeft._viewBoxMinX, -_ArrowLeft._viewBoxMinY);

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowLeftPainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ArrowRightPainter extends CustomPainter {
  _ArrowRightPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(11.2401, 17.5816)
    ..cubicTo(11.7826, 18.1395, 12.6619, 18.1395, 13.2043, 17.5816)
    ..lineTo(19.5932, 11.0102)
    ..cubicTo(19.8537, 10.7423, 20, 10.3789, 20, 10)
    ..cubicTo(20, 9.6212, 19.8537, 9.2578, 19.5932, 8.9898)
    ..lineTo(13.2043, 2.4184)
    ..cubicTo(12.6619, 1.8605, 11.7826, 1.8605, 11.2401, 2.4184)
    ..cubicTo(10.6978, 2.9763, 10.6978, 3.8808, 11.2401, 4.4387)
    ..lineTo(15.258, 8.5714)
    ..lineTo(1.3889, 8.5714)
    ..cubicTo(0.6218, 8.5714, -0, 9.2111, -0, 10)
    ..cubicTo(-0, 10.789, 0.6218, 11.4286, 1.3889, 11.4286)
    ..lineTo(15.258, 11.4286)
    ..lineTo(11.2401, 15.5613)
    ..cubicTo(10.6978, 16.1192, 10.6978, 17.0237, 11.2401, 17.5816)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ArrowRight._viewBoxWidth;
    final scaleY = size.height / _ArrowRight._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ArrowRight._viewBoxMinX, -_ArrowRight._viewBoxMinY);

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowRightPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/arrow_rotate_clockwise.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _ArrowRotateClockwise extends StatelessWidget with _DotdartSvgSizing {
  const _ArrowRotateClockwise({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _ArrowRotateClockwise._svgWidth;

  @override
  double get svgNativeHeight => _ArrowRotateClockwise._svgHeight;

  @override
  double get svgViewBoxWidth => _ArrowRotateClockwise._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _ArrowRotateClockwise._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ArrowRotateClockwisePainter(
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ArrowRotateClockwisePainter extends CustomPainter {
  _ArrowRotateClockwisePainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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
    final scaleX = size.width / _ArrowRotateClockwise._viewBoxWidth;
    final scaleY = size.height / _ArrowRotateClockwise._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_ArrowRotateClockwise._viewBoxMinX,
        -_ArrowRotateClockwise._viewBoxMinY,
      );

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowRotateClockwisePainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/arrow_up.svg`.
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
          painter: _ArrowUpPainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ArrowUpPainter extends CustomPainter {
  _ArrowUpPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(9.5, 0)
    ..cubicTo(9.9025, 0, 10.2886, 0.1463, 10.5733, 0.4068)
    ..lineTo(17.5555, 6.7957)
    ..cubicTo(18.1482, 7.3381, 18.1482, 8.2174, 17.5555, 8.7599)
    ..cubicTo(16.9627, 9.3022, 16.0017, 9.3022, 15.4089, 8.7599)
    ..lineTo(11.0179, 4.742)
    ..lineTo(11.0179, 18.6111)
    ..cubicTo(11.0179, 19.3782, 10.3382, 20, 9.5, 20)
    ..cubicTo(8.6617, 20, 7.9822, 19.3782, 7.9822, 18.6111)
    ..lineTo(7.9822, 4.742)
    ..lineTo(3.5911, 8.7599)
    ..cubicTo(2.9984, 9.3022, 2.0373, 9.3022, 1.4446, 8.7599)
    ..cubicTo(0.8518, 8.2174, 0.8518, 7.3381, 1.4446, 6.7957)
    ..lineTo(8.4267, 0.4068)
    ..cubicTo(8.7113, 0.1463, 9.0975, 0, 9.5, 0)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ArrowUp._viewBoxWidth;
    final scaleY = size.height / _ArrowUp._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ArrowUp._viewBoxMinX, -_ArrowUp._viewBoxMinY);

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowUpPainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BanknotePinPainter extends CustomPainter {
  _BanknotePinPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.drawPath(__path1, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BanknotePinPainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BidirecionalHorizontalArrowPainter extends CustomPainter {
  _BidirecionalHorizontalArrowPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.drawPath(__path1, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(
    covariant _BidirecionalHorizontalArrowPainter oldDelegate,
  ) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/box-pen.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _BoxPen extends StatelessWidget with _DotdartSvgSizing {
  const _BoxPen({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _BoxPen._svgWidth;

  @override
  double get svgNativeHeight => _BoxPen._svgHeight;

  @override
  double get svgViewBoxWidth => _BoxPen._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _BoxPen._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BoxPenPainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _BoxPenPainter extends CustomPainter {
  _BoxPenPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Path __path0 = Path()
    ..moveTo(13.5598, 0.0087)
    ..cubicTo(13.5714, 0.0204, 13.5712, 0.0394, 13.5593, 0.0508)
    ..cubicTo(13.5406, 0.0688, 13.522, 0.0871, 13.5036, 0.1055)
    ..lineTo(8.8021, 4.8069)
    ..cubicTo(8.7893, 4.8196, 8.7768, 4.8326, 8.7644, 4.8456)
    ..cubicTo(8.4045, 5.2232, 8.188, 5.7136, 8.1501, 6.2315)
    ..cubicTo(8.1474, 6.2673, 8.1456, 6.3031, 8.1447, 6.3391)
    ..lineTo(8.1441, 6.3948)
    ..lineTo(8.1441, 9.5295)
    ..cubicTo(8.1441, 9.5489, 8.1443, 9.5682, 8.1448, 9.5875)
    ..cubicTo(8.1483, 9.7224, 8.1635, 9.8542, 8.1897, 9.9822)
    ..cubicTo(8.1972, 10.0187, 8.2055, 10.055, 8.2147, 10.0909)
    ..cubicTo(8.2886, 10.378, 8.4179, 10.6428, 8.5903, 10.8734)
    ..cubicTo(8.6119, 10.9023, 8.6341, 10.9306, 8.657, 10.9583)
    ..cubicTo(8.6799, 10.9861, 8.7035, 11.0132, 8.7276, 11.0398)
    ..cubicTo(8.7518, 11.0664, 8.7765, 11.0925, 8.8019, 11.1179)
    ..cubicTo(9.1957, 11.5117, 9.7351, 11.7599, 10.3324, 11.775)
    ..cubicTo(10.3516, 11.7755, 10.371, 11.7758, 10.3904, 11.7758)
    ..lineTo(13.5247, 11.7758)
    ..cubicTo(13.953, 11.7758, 14.3686, 11.6535, 14.7249, 11.4283)
    ..cubicTo(14.7868, 11.3892, 14.8469, 11.3469, 14.905, 11.3016)
    ..cubicTo(14.9632, 11.2563, 15.0193, 11.2081, 15.0731, 11.1569)
    ..cubicTo(15.0865, 11.1441, 15.0998, 11.1311, 15.113, 11.1179)
    ..lineTo(19.8144, 6.4164)
    ..cubicTo(19.8392, 6.3915, 19.8636, 6.3663, 19.8878, 6.341)
    ..cubicTo(19.8889, 6.3398, 19.8908, 6.3398, 19.892, 6.341)
    ..cubicTo(19.8925, 6.3415, 19.8929, 6.3423, 19.8929, 6.343)
    ..lineTo(19.8929, 13.893)
    ..cubicTo(19.8929, 17.2067, 17.2066, 19.893, 13.8929, 19.893)
    ..lineTo(6, 19.893)
    ..cubicTo(2.6863, 19.893, 0, 17.2067, 0, 13.893)
    ..lineTo(0, 6.0001)
    ..cubicTo(0, 2.6864, 2.6863, 0.0001, 6, 0.0001)
    ..lineTo(13.539, 0.0001)
    ..cubicTo(13.5468, 0.0001, 13.5543, 0.0032, 13.5598, 0.0087)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(13.5961, 1.7737)
    ..lineTo(18.2263, 6.4039)
    ..lineTo(14.3207, 10.3094)
    ..cubicTo(14.1241, 10.5061, 13.8573, 10.6167, 13.5791, 10.6167)
    ..lineTo(10.4322, 10.6167)
    ..cubicTo(9.8529, 10.6167, 9.3833, 10.147, 9.3833, 9.5677)
    ..lineTo(9.3833, 6.4208)
    ..cubicTo(9.3834, 6.1427, 9.4939, 5.8758, 9.6906, 5.6792)
    ..lineTo(13.5961, 1.7737)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(19.1667, 5.4563)
    ..cubicTo(19.0994, 5.5315, 18.9832, 5.5312, 18.9118, 5.4598)
    ..lineTo(14.5402, 1.0881)
    ..cubicTo(14.4688, 1.0167, 14.4685, 0.9005, 14.5437, 0.8332)
    ..cubicTo(15.8292, -0.3181, 17.8059, -0.2763, 19.0411, 0.9589)
    ..cubicTo(20.2763, 2.1941, 20.3182, 4.1707, 19.1667, 5.4563)
    ..close();

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _BoxPen._viewBoxWidth;
    final scaleY = size.height / _BoxPen._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_BoxPen._viewBoxMinX, -_BoxPen._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.drawPath(__path1, _fillPaint..color = color1);
    canvas.drawPath(__path2, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BoxPenPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/chevron_down.svg`.
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ChevronDownPainter extends CustomPainter {
  _ChevronDownPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Path __path0 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(0.3254, 5.3345)
    ..cubicTo(0.7594, 4.8885, 1.4629, 4.8885, 1.8968, 5.3345)
    ..lineTo(8.4287, 12.0473)
    ..cubicTo(9.2965, 12.9391, 10.7036, 12.9391, 11.5713, 12.0473)
    ..lineTo(18.1032, 5.3345)
    ..cubicTo(18.5371, 4.8885, 19.2407, 4.8885, 19.6746, 5.3345)
    ..cubicTo(20.1085, 5.7804, 20.1085, 6.5034, 19.6746, 6.9493)
    ..lineTo(13.1427, 13.6622)
    ..cubicTo(11.407, 15.4459, 8.593, 15.4459, 6.8573, 13.6622)
    ..lineTo(0.3254, 6.9493)
    ..cubicTo(-0.1085, 6.5034, -0.1085, 5.7804, 0.3254, 5.3345)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ChevronDown._viewBoxWidth;
    final scaleY = size.height / _ChevronDown._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ChevronDown._viewBoxMinX, -_ChevronDown._viewBoxMinY);

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ChevronDownPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/chevron_left.svg`.
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ChevronLeftPainter extends CustomPainter {
  _ChevronLeftPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Path __path0 = Path()
    ..moveTo(14.7449, 2.4213)
    ..cubicTo(15.3141, 1.8674, 15.314, 0.9654, 14.7448, 0.4115)
    ..lineTo(14.7182, 0.3862)
    ..cubicTo(14.1615, -0.1287, 13.2897, -0.1287, 12.7331, 0.3862)
    ..lineTo(12.7063, 0.4115)
    ..lineTo(6.224, 6.7191)
    ..cubicTo(4.3629, 8.53, 4.363, 11.47, 6.224, 13.2809)
    ..lineTo(12.7063, 19.5884)
    ..cubicTo(13.2703, 20.1372, 14.1809, 20.1372, 14.7448, 19.5884)
    ..cubicTo(15.314, 19.0345, 15.3141, 18.1326, 14.7449, 17.5787)
    ..lineTo(8.2625, 11.2712)
    ..cubicTo(7.54, 10.5681, 7.54, 9.4319, 8.2625, 8.7288)
    ..lineTo(14.7449, 2.4213)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _ChevronLeft._viewBoxWidth;
    final scaleY = size.height / _ChevronLeft._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_ChevronLeft._viewBoxMinX, -_ChevronLeft._viewBoxMinY);

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ChevronLeftPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/circle_block.svg`.
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CircleBlockPainter extends CustomPainter {
  _CircleBlockPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _CircleBlock._viewBoxWidth;
    final scaleY = size.height / _CircleBlock._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_CircleBlock._viewBoxMinX, -_CircleBlock._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CircleBlockPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/circle_check.svg`.
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CircleCheckPainter extends CustomPainter {
  _CircleCheckPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _CircleCheck._viewBoxWidth;
    final scaleY = size.height / _CircleCheck._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_CircleCheck._viewBoxMinX, -_CircleCheck._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CircleCheckPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/circle_info.svg`.
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CircleInfoPainter extends CustomPainter {
  _CircleInfoPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _CircleInfo._viewBoxWidth;
    final scaleY = size.height / _CircleInfo._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_CircleInfo._viewBoxMinX, -_CircleInfo._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CircleInfoPainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
          painter: _ClockPainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  _ClockPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Clock._viewBoxWidth;
    final scaleY = size.height / _Clock._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Clock._viewBoxMinX, -_Clock._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
          painter: _CrossPainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CrossPainter extends CustomPainter {
  _CrossPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Cross._viewBoxWidth;
    final scaleY = size.height / _Cross._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Cross._viewBoxMinX, -_Cross._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CrossPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/exclamation_circle.svg`.
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ExclamationCirclePainter extends CustomPainter {
  _ExclamationCirclePainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

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
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ExclamationCirclePainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/exclamation_triangle.svg`.
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _ExclamationTrianglePainter extends CustomPainter {
  _ExclamationTrianglePainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ExclamationTrianglePainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
          painter: _HandshakePainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _HandshakePainter extends CustomPainter {
  _HandshakePainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.drawPath(__path1, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HandshakePainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/magnifier_glass.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _MagnifierGlass extends StatelessWidget with _DotdartSvgSizing {
  const _MagnifierGlass({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _MagnifierGlass._svgWidth;

  @override
  double get svgNativeHeight => _MagnifierGlass._svgHeight;

  @override
  double get svgViewBoxWidth => _MagnifierGlass._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _MagnifierGlass._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _MagnifierGlassPainter(
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _MagnifierGlassPainter extends CustomPainter {
  _MagnifierGlassPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _MagnifierGlass._viewBoxWidth;
    final scaleY = size.height / _MagnifierGlass._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_MagnifierGlass._viewBoxMinX, -_MagnifierGlass._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MagnifierGlassPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/map_pin.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _MapPin extends StatelessWidget with _DotdartSvgSizing {
  const _MapPin({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _MapPin._svgWidth;

  @override
  double get svgNativeHeight => _MapPin._svgHeight;

  @override
  double get svgViewBoxWidth => _MapPin._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _MapPin._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _MapPinPainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _MapPinPainter extends CustomPainter {
  _MapPinPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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
    final scaleX = size.width / _MapPin._viewBoxWidth;
    final scaleY = size.height / _MapPin._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_MapPin._viewBoxMinX, -_MapPin._viewBoxMinY);

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MapPinPainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
          painter: _PhonePainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PhonePainter extends CustomPainter {
  _PhonePainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Phone._viewBoxWidth;
    final scaleY = size.height / _Phone._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Phone._viewBoxMinX, -_Phone._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PhonePainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PlusSignalPainter extends CustomPainter {
  _PlusSignalPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _PlusSignal._viewBoxWidth;
    final scaleY = size.height / _PlusSignal._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_PlusSignal._viewBoxMinX, -_PlusSignal._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.drawPath(__path1, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PlusSignalPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/pointer_hand_up.svg`.
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PointerHandUpPainter extends CustomPainter {
  _PointerHandUpPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PointerHandUpPainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _QuestionmarkPainter extends CustomPainter {
  _QuestionmarkPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _QuestionmarkPainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _RectangleStackPainter extends CustomPainter {
  _RectangleStackPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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
    Rect.fromLTWH(0, 5.4286, 20, 14.5714),
    const Radius.circular(3.8988),
  );

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _RectangleStack._viewBoxWidth;
    final scaleY = size.height / _RectangleStack._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_RectangleStack._viewBoxMinX, -_RectangleStack._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.drawPath(__path1, _fillPaint..color = color1);
    canvas.drawRRect(_rrect0, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RectangleStackPainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
          painter: _RoadPainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _RoadPainter extends CustomPainter {
  _RoadPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final RRect _rrect0 = RRect.fromRectAndRadius(
    Rect.fromLTWH(8.3402, 0.6846, 2.7386, 4.4191),
    const Radius.circular(1.3693),
  );

  static final RRect _rrect1 = RRect.fromRectAndRadius(
    Rect.fromLTWH(8.3402, 7.78, 2.7386, 4.4191),
    const Radius.circular(1.3693),
  );

  static final RRect _rrect2 = RRect.fromRectAndRadius(
    Rect.fromLTWH(8.3402, 14.8754, 2.7386, 4.4191),
    const Radius.circular(1.3693),
  );

  static final RRect _rrect3 = RRect.fromRectAndRadius(
    Rect.fromLTWH(0, 0, 2.9253, 19.9791),
    const Radius.circular(1.4626),
  );

  static final RRect _rrect4 = RRect.fromRectAndRadius(
    Rect.fromLTWH(17.0538, 0, 2.9253, 19.9791),
    const Radius.circular(1.4626),
  );

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Road._viewBoxWidth;
    final scaleY = size.height / _Road._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Road._viewBoxMinX, -_Road._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawRRect(_rrect0, _fillPaint..color = color1);
    canvas.drawRRect(_rrect1, _fillPaint..color = color1);
    canvas.drawRRect(_rrect2, _fillPaint..color = color1);
    canvas.drawRRect(_rrect3, _fillPaint..color = color1);
    canvas.drawRRect(_rrect4, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RoadPainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _SmartphonePainter extends CustomPainter {
  _SmartphonePainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SmartphonePainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
          painter: _TreePainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _TreePainter extends CustomPainter {
  _TreePainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Tree._viewBoxWidth;
    final scaleY = size.height / _Tree._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Tree._viewBoxMinX, -_Tree._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.drawPath(__path1, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TreePainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
          painter: _WhatsappPainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _WhatsappPainter extends CustomPainter {
  _WhatsappPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Whatsapp._viewBoxWidth;
    final scaleY = size.height / _Whatsapp._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Whatsapp._viewBoxMinX, -_Whatsapp._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WhatsappPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}

/// A dotdart-generated SVG widget from `assets/icons/wifi_exclamation.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _WifiExclamation extends StatelessWidget with _DotdartSvgSizing {
  const _WifiExclamation({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _WifiExclamation._svgWidth;

  @override
  double get svgNativeHeight => _WifiExclamation._svgHeight;

  @override
  double get svgViewBoxWidth => _WifiExclamation._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _WifiExclamation._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _WifiExclamationPainter(
            color1: color1 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _WifiExclamationPainter extends CustomPainter {
  _WifiExclamationPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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
    final scaleX = size.width / _WifiExclamation._viewBoxWidth;
    final scaleY = size.height / _WifiExclamation._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(
        -_WifiExclamation._viewBoxMinX,
        -_WifiExclamation._viewBoxMinY,
      );

    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.drawPath(__path1, _fillPaint..color = color1);
    canvas.drawPath(__path2, _fillPaint..color = color1);
    canvas.drawPath(__path3, _fillPaint..color = color1);
    canvas.drawPath(__path4, _fillPaint..color = color1);
    canvas.drawPath(__path5, _fillPaint..color = color1);
    canvas.drawPath(__path6, _fillPaint..color = color1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WifiExclamationPainter oldDelegate) {
    return oldDelegate.color1 != color1;
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
    this.color1,
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

  /// Color 1 — defaults to 0xff000000.
  final Color? color1;

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
          painter: _WrenchPainter(color1: color1 ?? const Color(0xff000000)),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _WrenchPainter extends CustomPainter {
  _WrenchPainter({required this.color1});

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

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

  static final Path __clip0 = Path()..addRect(Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Wrench._viewBoxWidth;
    final scaleY = size.height / _Wrench._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Wrench._viewBoxMinX, -_Wrench._viewBoxMinY);

    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = color1);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WrenchPainter oldDelegate) {
    return oldDelegate.color1 != color1;
  }
}
