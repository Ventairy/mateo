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
/// $Icons.arrowLeft(<params>);
/// ```
/// ```dart
/// $Icons.arrowRotateClockwise(<params>);
/// ```
/// ```dart
/// $Icons.arrowUp(<params>);
/// ```
/// ```dart
/// $Icons.chevronDown(<params>);
/// ```
/// ```dart
/// $Icons.circleBlock(<params>);
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
/// $Icons.magnifierGlass(<params>);
/// ```
/// ```dart
/// $Icons.mapPin(<params>);
/// ```
/// ```dart
/// $Icons.phone(<params>);
/// ```
/// ```dart
/// $Icons.pointerHandUp(<params>);
/// ```
/// ```dart
/// $Icons.smartphone(<params>);
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
