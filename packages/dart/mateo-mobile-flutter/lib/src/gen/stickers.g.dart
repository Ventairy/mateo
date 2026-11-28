// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
// *****************************************************

// coverage:ignore-file
// Generated canvas and paint sequences intentionally use repeated receiver calls.
// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show ImageFilter;

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

/// Namespace for dotdart-generated widgets from `stickers/`.
///
/// Call a method named after each asset to render it:
///
/// ```dart
/// $Stickers.crossSeal(<params>);
/// ```
abstract final class $Stickers {
  $Stickers._();

  /// Builds the `CrossSeal` widget from `crossSeal.svg`.
  static Widget crossSeal({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor1,
    Color? mateoOpticalSizeColor2,
  }) => _CrossSeal(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor1: mateoOpticalSizeColor1,
    mateoOpticalSizeColor2: mateoOpticalSizeColor2,
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
    'cross-seal.svg' => crossSeal(key: key, width: width, height: height),
    _ => null,
  };
}

/// A dotdart-generated SVG widget from `assets/stickers/cross-seal.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _CrossSeal extends StatelessWidget with _DotdartSvgSizing {
  const _CrossSeal({
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

  /// Color from SVG id `mateo-optical-size` — defaults to 0xffffffff.
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
  double get svgNativeWidth => _CrossSeal._svgWidth;

  @override
  double get svgNativeHeight => _CrossSeal._svgHeight;

  @override
  double get svgViewBoxWidth => _CrossSeal._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _CrossSeal._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CrossSealPainter(
            mateoOpticalSizeColor1: mateoOpticalSizeColor1 ?? const Color(0xffffffff),
            mateoOpticalSizeColor2: mateoOpticalSizeColor2 ?? const Color(0xff000000),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CrossSealPainter extends CustomPainter {
  _CrossSealPainter({
    required this.mateoOpticalSizeColor1,
    required this.mateoOpticalSizeColor2,
  });

  final Color mateoOpticalSizeColor1;
  final Color mateoOpticalSizeColor2;

  static final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static const Rect _shadowBounds0 = Rect.fromLTWH(-4.0, -4.0, 28.0, 28.0);
  final Paint _shadowColor0 = Paint()
    ..colorFilter = const ColorFilter.matrix([
      0,
      0,
      0,
      0,
      0.0,
      0,
      0,
      0,
      0,
      0.0,
      0,
      0,
      0,
      0,
      0.0,
      0,
      0,
      0,
      0.32,
      0,
    ]);
  final Paint _shadowBlur0 = Paint()
    ..imageFilter = ImageFilter.blur(
      sigmaX: 0.259012,
      sigmaY: 0.259012,
      tileMode: TileMode.decal,
    );
  final Paint _shadowAlpha0 = Paint()
    ..colorFilter = const ColorFilter.matrix([
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      127.0,
      0,
    ]);
  final Paint _shadowOut0 = Paint()
    ..blendMode = BlendMode.dstOut
    ..colorFilter = const ColorFilter.matrix([
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      127.0,
      0,
    ]);
  static final Float64List _transform0 = Float64List.fromList([
    0.981033653,
    0.0,
    0.0,
    0.0,
    0.0,
    0.981033653,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    0.191728532,
    -0.269304347,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(9.7859, 1.1299)
    ..cubicTo(10.221, 1.0923, 10.6182, 1.1739, 10.8367, 1.2274)
    ..cubicTo(11.8704, 1.4811, 12.44, 2.0992, 12.8161, 2.5926)
    ..cubicTo(12.8457, 2.5865, 12.8787, 2.5799, 12.9166, 2.5724)
    ..cubicTo(13.0307, 2.5497, 13.2189, 2.5139, 13.4065, 2.5008)
    ..lineTo(13.4102, 2.5001)
    ..cubicTo(13.7372, 2.4782, 14.0656, 2.5087, 14.3829, 2.589)
    ..lineTo(14.518, 2.6266)
    ..lineTo(14.5224, 2.6273)
    ..cubicTo(15.9108, 3.0505, 16.7909, 4.2733, 16.9651, 5.5744)
    ..cubicTo(16.9922, 5.7771, 16.9924, 5.9683, 16.9911, 6.0926)
    ..cubicTo(16.9909, 6.1114, 16.99, 6.1303, 16.9896, 6.149)
    ..cubicTo(17.4704, 6.4384, 17.9855, 6.8375, 18.3757, 7.4924)
    ..lineTo(18.4639, 7.6485)
    ..lineTo(18.4682, 7.6572)
    ..cubicTo(18.7247, 8.1468, 18.8591, 8.6905, 18.8621, 9.2428)
    ..lineTo(18.8628, 9.258)
    ..cubicTo(18.867, 9.8763, 18.6998, 10.4837, 18.3794, 11.0126)
    ..lineTo(18.3765, 11.017)
    ..cubicTo(18.2475, 11.2283, 18.1068, 11.4023, 18.0036, 11.525)
    ..cubicTo(17.9872, 11.5445, 17.9717, 11.5617, 17.958, 11.5778)
    ..cubicTo(18.1823, 12.1856, 18.3929, 13.0446, 18.078, 14.0053)
    ..lineTo(18.0787, 14.006)
    ..cubicTo(18.078, 14.0084, 18.0766, 14.0108, 18.0758, 14.0132)
    ..cubicTo(18.0737, 14.0197, 18.0722, 14.0263, 18.07, 14.0328)
    ..lineTo(18.0693, 14.032)
    ..cubicTo(17.8985, 14.5563, 17.5934, 15.0476, 17.205, 15.4304)
    ..cubicTo(16.8928, 15.7382, 16.4941, 16.0144, 16.0429, 16.1907)
    ..cubicTo(15.7297, 16.313, 15.3954, 16.3777, 15.167, 16.4184)
    ..cubicTo(15.1167, 16.5628, 15.0554, 16.7321, 14.9856, 16.8867)
    ..cubicTo(14.6458, 17.6396, 14.0532, 18.1787, 13.413, 18.5055)
    ..lineTo(13.4073, 18.5084)
    ..cubicTo(12.1692, 19.1339, 10.9753, 18.9009, 10.0092, 18.3147)
    ..cubicTo(9.9987, 18.3083, 9.9877, 18.3009, 9.9759, 18.2937)
    ..cubicTo(9.8326, 18.3779, 9.6505, 18.4831, 9.4462, 18.5756)
    ..lineTo(9.4419, 18.577)
    ..cubicTo(9.0869, 18.7364, 8.7071, 18.8347, 8.3188, 18.8668)
    ..lineTo(8.3138, 18.8668)
    ..cubicTo(7.6375, 18.9205, 7.0172, 18.7461, 6.507, 18.4715)
    ..cubicTo(6.5009, 18.4684, 6.4951, 18.4653, 6.489, 18.4621)
    ..cubicTo(6.4802, 18.4573, 6.4709, 18.4532, 6.4622, 18.4484)
    ..lineTo(6.4622, 18.4469)
    ..cubicTo(5.5057, 17.9391, 5.0389, 17.124, 4.7784, 16.4155)
    ..cubicTo(4.2704, 16.3219, 3.5814, 16.1299, 2.9854, 15.6046)
    ..cubicTo(2.5602, 15.2299, 2.1603, 14.7397, 1.9324, 14.0653)
    ..lineTo(1.931, 14.066)
    ..cubicTo(1.9264, 14.0534, 1.923, 14.0403, 1.9187, 14.0277)
    ..cubicTo(1.9172, 14.0231, 1.9151, 14.0186, 1.9136, 14.014)
    ..lineTo(1.9143, 14.0132)
    ..cubicTo(1.5881, 13.0591, 1.7996, 12.1817, 2.0278, 11.5677)
    ..cubicTo(1.6472, 11.1122, 1.2029, 10.4538, 1.144, 9.4899)
    ..cubicTo(1.0689, 8.2618, 1.6228, 7.1987, 2.4925, 6.5002)
    ..lineTo(2.671, 6.3658)
    ..cubicTo(2.7325, 6.3198, 2.7889, 6.2806, 2.8358, 6.2508)
    ..cubicTo(2.8981, 6.2113, 2.9586, 6.1763, 3.0092, 6.1475)
    ..cubicTo(3.009, 6.1277, 3.0094, 6.1068, 3.0092, 6.0846)
    ..cubicTo(3.0087, 5.9924, 3.008, 5.8472, 3.0186, 5.7103)
    ..lineTo(3.0193, 5.7023)
    ..cubicTo(3.082, 4.946, 3.3874, 4.2302, 3.8895, 3.6615)
    ..lineTo(4.0022, 3.5379)
    ..cubicTo(4.2713, 3.2539, 4.5874, 3.0033, 4.972, 2.8181)
    ..cubicTo(5.4102, 2.6071, 5.862, 2.517, 6.3083, 2.4936)
    ..lineTo(6.4268, 2.4907)
    ..cubicTo(6.5418, 2.4911, 6.6437, 2.5001, 6.7224, 2.5095)
    ..cubicTo(6.8313, 2.5225, 6.9341, 2.5411, 7.018, 2.5572)
    ..cubicTo(7.0754, 2.5682, 7.1337, 2.5808, 7.1864, 2.5919)
    ..cubicTo(7.1909, 2.5858, 7.1956, 2.5799, 7.2001, 2.5738)
    ..cubicTo(7.2559, 2.4983, 7.3359, 2.392, 7.4205, 2.2941)
    ..lineTo(7.4256, 2.2883)
    ..cubicTo(8.0257, 1.6019, 8.8758, 1.185, 9.7859, 1.1299)
    ..close()
    ..moveTo(9.684, 2.628)
    ..cubicTo(9.2423, 2.6995, 8.837, 2.9227, 8.5399, 3.2625)
    ..lineTo(8.3904, 3.4533)
    ..cubicTo(8.2285, 3.6723, 8.0367, 3.9506, 7.8888, 4.0633)
    ..cubicTo(7.5808, 4.2974, 6.7683, 3.9516, 6.3856, 3.9715)
    ..cubicTo(5.7909, 4.0026, 5.3842, 4.2002, 5.0046, 4.6349)
    ..lineTo(4.8998, 4.7628)
    ..cubicTo(4.6677, 5.0704, 4.5264, 5.4383, 4.4943, 5.8245)
    ..cubicTo(4.4735, 6.093, 4.5275, 6.6816, 4.4293, 6.9172)
    ..lineTo(4.4026, 6.9678)
    ..cubicTo(4.2462, 7.2157, 3.7444, 7.3952, 3.5303, 7.5705)
    ..cubicTo(2.9284, 7.9996, 2.5755, 8.6535, 2.6211, 9.3996)
    ..cubicTo(2.6606, 10.0459, 2.991, 10.4342, 3.3988, 10.8898)
    ..cubicTo(3.6998, 11.2262, 3.6878, 11.4247, 3.5194, 11.8184)
    ..cubicTo(3.2814, 12.375, 3.1077, 12.9664, 3.3229, 13.5623)
    ..cubicTo(3.4446, 13.9428, 3.6687, 14.2344, 3.9639, 14.4946)
    ..cubicTo(4.3551, 14.8393, 4.8481, 14.9371, 5.3464, 15.0091)
    ..cubicTo(5.8009, 15.0749, 5.9401, 15.173, 6.0713, 15.6147)
    ..cubicTo(6.2631, 16.261, 6.5537, 16.8337, 7.182, 17.1555)
    ..cubicTo(7.4511, 17.3052, 7.7518, 17.3957, 8.063, 17.3969)
    ..lineTo(8.1967, 17.3918)
    ..cubicTo(8.3623, 17.3781, 8.5252, 17.3433, 8.6816, 17.2885)
    ..lineTo(8.8355, 17.227)
    ..cubicTo(9.1317, 17.0929, 9.4036, 16.9034, 9.6898, 16.7501)
    ..cubicTo(9.8306, 16.6746, 9.9595, 16.6525, 10.1161, 16.6865)
    ..cubicTo(10.2989, 16.7454, 10.6012, 16.9423, 10.7774, 17.0493)
    ..cubicTo(11.3715, 17.4097, 11.9764, 17.5186, 12.6123, 17.2466)
    ..lineTo(12.7402, 17.1873)
    ..cubicTo(13.1292, 16.9888, 13.4555, 16.6782, 13.6364, 16.2774)
    ..cubicTo(13.6812, 16.178, 13.7207, 16.0732, 13.7578, 15.9674)
    ..lineTo(13.8647, 15.6523)
    ..cubicTo(13.9466, 15.4136, 14.0093, 15.1763, 14.2752, 15.085)
    ..cubicTo(14.4182, 15.036, 14.5696, 15.0217, 14.7182, 14.9968)
    ..cubicTo(14.9148, 14.9618, 15.1191, 14.9302, 15.3137, 14.8754)
    ..lineTo(15.5045, 14.8118)
    ..cubicTo(15.7483, 14.7165, 15.9803, 14.5588, 16.1658, 14.376)
    ..cubicTo(16.3916, 14.1535, 16.5728, 13.8603, 16.668, 13.5594)
    ..cubicTo(16.8677, 12.9674, 16.7078, 12.4122, 16.4801, 11.8604)
    ..cubicTo(16.4264, 11.7302, 16.3677, 11.5851, 16.3573, 11.4398)
    ..lineTo(16.3558, 11.3776)
    ..cubicTo(16.3606, 11.2225, 16.4304, 11.1088, 16.517, 10.9967)
    ..lineTo(16.608, 10.8833)
    ..cubicTo(16.7342, 10.7256, 16.8758, 10.576, 16.9983, 10.4135)
    ..lineTo(17.1132, 10.2459)
    ..cubicTo(17.2933, 9.9487, 17.3866, 9.6068, 17.3828, 9.2594)
    ..cubicTo(17.3824, 8.9804, 17.3233, 8.7051, 17.2093, 8.4514)
    ..lineTo(17.1573, 8.3438)
    ..cubicTo(16.9286, 7.9142, 16.611, 7.6484, 16.2185, 7.4129)
    ..lineTo(16.0458, 7.3132)
    ..cubicTo(15.9396, 7.2543, 15.7425, 7.1424, 15.6476, 7.0379)
    ..lineTo(15.6136, 6.9938)
    ..cubicTo(15.4527, 6.7285, 15.5228, 6.2761, 15.5096, 5.9177)
    ..lineTo(15.498, 5.7703)
    ..cubicTo(15.3912, 4.9733, 14.8607, 4.2777, 14.0909, 4.043)
    ..cubicTo(13.9026, 3.9862, 13.7054, 3.9642, 13.5092, 3.9773)
    ..cubicTo(13.1942, 3.9991, 12.5788, 4.1998, 12.2705, 4.1355)
    ..lineTo(12.2134, 4.1189)
    ..cubicTo(12.0507, 4.0566, 11.9437, 3.9024, 11.8448, 3.767)
    ..cubicTo(11.4832, 3.2717, 11.2029, 2.8833, 10.6076, 2.6988)
    ..lineTo(10.484, 2.6649)
    ..cubicTo(10.295, 2.6185, 10.07, 2.5812, 9.8755, 2.6063)
    ..lineTo(9.684, 2.628)
    ..close()
    ..moveTo(8.0384, 7.3913)
    ..cubicTo(8.1523, 7.3712, 8.3512, 7.4231, 8.4381, 7.5004)
    ..cubicTo(8.5178, 7.5716, 8.5995, 7.6537, 8.6751, 7.7295)
    ..lineTo(8.7962, 7.8509)
    ..lineTo(8.9172, 7.9723)
    ..lineTo(9.0921, 8.1472)
    ..lineTo(9.6775, 8.7355)
    ..cubicTo(9.7812, 8.8393, 9.9106, 8.9613, 10.0063, 9.0693)
    ..cubicTo(10.3821, 8.7114, 10.7499, 8.3116, 11.125, 7.9499)
    ..cubicTo(11.2881, 7.8102, 11.4539, 7.5815, 11.6352, 7.4686)
    ..cubicTo(11.8594, 7.329, 12.1756, 7.3968, 12.3536, 7.569)
    ..cubicTo(12.477, 7.6892, 12.5475, 7.8535, 12.5502, 8.0258)
    ..cubicTo(12.5526, 8.3088, 12.4087, 8.4507, 12.2177, 8.6343)
    ..cubicTo(12.1392, 8.7098, 12.0587, 8.7932, 11.9814, 8.8706)
    ..lineTo(10.8887, 9.964)
    ..lineTo(11.9879, 11.0654)
    ..cubicTo(12.0851, 11.1637, 12.4033, 11.4667, 12.4613, 11.5691)
    ..cubicTo(12.699, 11.9895, 12.4521, 12.4915, 11.9532, 12.5462)
    ..cubicTo(11.9421, 12.547, 11.9311, 12.5475, 11.92, 12.5476)
    ..lineTo(11.8304, 12.5404)
    ..cubicTo(11.6327, 12.5067, 11.508, 12.3597, 11.3671, 12.2138)
    ..cubicTo(11.2837, 12.1273, 11.1975, 12.0418, 11.1127, 11.9565)
    ..lineTo(10.0034, 10.8493)
    ..lineTo(8.9035, 11.9485)
    ..lineTo(8.6975, 12.1574)
    ..cubicTo(8.6283, 12.2273, 8.5589, 12.2965, 8.4886, 12.3597)
    ..cubicTo(7.9061, 12.8841, 7.1525, 12.1369, 7.5723, 11.512)
    ..cubicTo(7.5885, 11.4879, 7.6182, 11.4568, 7.6489, 11.4267)
    ..lineTo(7.7305, 11.3487)
    ..cubicTo(7.8439, 11.235, 7.9579, 11.1215, 8.0724, 11.009)
    ..cubicTo(8.4077, 10.6794, 8.7901, 10.3013, 9.1145, 9.9611)
    ..cubicTo(8.6135, 9.4351, 8.0622, 8.9323, 7.5687, 8.398)
    ..cubicTo(7.5266, 8.3524, 7.4905, 8.2627, 7.4718, 8.1855)
    ..lineTo(7.4595, 8.1147)
    ..cubicTo(7.4228, 7.7378, 7.6606, 7.4348, 8.0384, 7.3913)
    ..close()
    ..moveTo(8.6751, 7.7295)
    ..lineTo(8.9172, 7.9723)
    ..lineTo(8.7962, 7.8509)
    ..lineTo(8.6751, 7.7295)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(9.8754, 2.6065)
    ..cubicTo(10.0699, 2.5813, 10.2948, 2.6185, 10.4838, 2.6649)
    ..cubicTo(11.1657, 2.8322, 11.4591, 3.2384, 11.8449, 3.7668)
    ..cubicTo(11.9438, 3.9022, 12.0504, 4.0568, 12.2131, 4.1192)
    ..cubicTo(12.4955, 4.2274, 13.1731, 4.0004, 13.509, 3.9771)
    ..cubicTo(13.7053, 3.964, 13.9024, 3.9863, 14.0907, 4.0432)
    ..cubicTo(14.8606, 4.2778, 15.3911, 4.9734, 15.4978, 5.7705)
    ..cubicTo(15.5476, 6.143, 15.4295, 6.6903, 15.6135, 6.9935)
    ..cubicTo(15.6838, 7.1093, 15.9242, 7.2459, 16.0457, 7.3132)
    ..cubicTo(16.5187, 7.5754, 16.8957, 7.8529, 17.157, 8.3439)
    ..cubicTo(17.3051, 8.6265, 17.3825, 8.9406, 17.3828, 9.2596)
    ..cubicTo(17.3867, 9.6069, 17.2933, 9.9484, 17.1132, 10.2456)
    ..cubicTo(16.9719, 10.477, 16.7761, 10.673, 16.6078, 10.8834)
    ..cubicTo(16.4845, 11.0374, 16.362, 11.1707, 16.3558, 11.3778)
    ..cubicTo(16.3507, 11.5436, 16.4185, 11.7116, 16.4799, 11.8603)
    ..cubicTo(16.7076, 12.4123, 16.8675, 12.9674, 16.6677, 13.5595)
    ..cubicTo(16.5725, 13.8604, 16.3917, 14.1536, 16.1659, 14.3761)
    ..cubicTo(15.9804, 14.559, 15.7483, 14.7167, 15.5044, 14.812)
    ..cubicTo(15.2559, 14.9091, 14.9802, 14.9504, 14.7182, 14.9971)
    ..cubicTo(14.5696, 15.0219, 14.4186, 15.036, 14.2755, 15.085)
    ..cubicTo(14.0093, 15.1762, 13.9466, 15.4132, 13.8648, 15.652)
    ..cubicTo(13.7942, 15.8578, 13.7262, 16.0786, 13.6364, 16.2775)
    ..cubicTo(13.4555, 16.6783, 13.1291, 16.9888, 12.74, 17.1873)
    ..cubicTo(12.0571, 17.5324, 11.4109, 17.4338, 10.7771, 17.0492)
    ..cubicTo(10.6008, 16.9422, 10.299, 16.7454, 10.1163, 16.6864)
    ..cubicTo(9.9596, 16.6524, 9.8307, 16.6746, 9.6898, 16.7501)
    ..cubicTo(9.4037, 16.9034, 9.1319, 17.0928, 8.8357, 17.227)
    ..cubicTo(8.6335, 17.3177, 8.4174, 17.3734, 8.1966, 17.3917)
    ..cubicTo(7.838, 17.4202, 7.4895, 17.3263, 7.182, 17.1552)
    ..cubicTo(6.5536, 16.8333, 6.2632, 16.2609, 6.0714, 15.6146)
    ..cubicTo(5.9402, 15.1728, 5.8008, 15.075, 5.346, 15.0093)
    ..cubicTo(4.8477, 14.9372, 4.3553, 14.8392, 3.9642, 14.4945)
    ..cubicTo(3.6689, 14.2343, 3.445, 13.9432, 3.3232, 13.5626)
    ..cubicTo(3.1077, 12.9666, 3.2815, 12.3752, 3.5196, 11.8185)
    ..cubicTo(3.688, 11.4247, 3.6998, 11.2262, 3.3986, 10.8897)
    ..cubicTo(2.9909, 10.4341, 2.6609, 10.0459, 2.6214, 9.3996)
    ..cubicTo(2.5758, 8.6535, 2.928, 7.9999, 3.5299, 7.5708)
    ..cubicTo(3.758, 7.3838, 4.3144, 7.1921, 4.4292, 6.9175)
    ..cubicTo(4.5276, 6.6821, 4.4736, 6.0933, 4.4944, 5.8246)
    ..cubicTo(4.531, 5.3833, 4.71, 4.9658, 5.0043, 4.6349)
    ..cubicTo(5.3841, 4.2002, 5.7906, 4.0028, 6.3853, 3.9717)
    ..cubicTo(6.768, 3.9516, 7.5812, 4.2976, 7.8891, 4.063)
    ..cubicTo(8.0863, 3.9128, 8.3614, 3.4686, 8.5398, 3.2623)
    ..cubicTo(8.8794, 2.8739, 9.3604, 2.6377, 9.8754, 2.6065)
    ..close()
    ..moveTo(9.1144, 9.9608)
    ..cubicTo(8.7899, 10.3011, 8.4077, 10.6795, 8.0722, 11.0092)
    ..cubicTo(7.9577, 11.1217, 7.8438, 11.2349, 7.7304, 11.3486)
    ..cubicTo(7.6891, 11.3898, 7.6044, 11.4642, 7.5724, 11.5119)
    ..cubicTo(7.1525, 12.1368, 7.9056, 12.884, 8.4883, 12.3596)
    ..cubicTo(8.6289, 12.233, 8.7673, 12.0844, 8.9032, 11.9488)
    ..lineTo(10.0034, 10.8491)
    ..lineTo(11.1126, 11.9566)
    ..cubicTo(11.1974, 12.0421, 11.2838, 12.1274, 11.3673, 12.2139)
    ..cubicTo(11.5284, 12.3807, 11.6678, 12.549, 11.9198, 12.5478)
    ..cubicTo(11.931, 12.5476, 11.9422, 12.5472, 11.9535, 12.5463)
    ..cubicTo(12.4524, 12.4916, 12.699, 11.9893, 12.4611, 11.569)
    ..cubicTo(12.4032, 11.4666, 12.0851, 11.1639, 11.9879, 11.0657)
    ..lineTo(10.8884, 9.964)
    ..lineTo(11.9811, 8.8708)
    ..cubicTo(12.0584, 8.7933, 12.1389, 8.7102, 12.2176, 8.6346)
    ..cubicTo(12.4086, 8.4509, 12.5528, 8.3089, 12.5504, 8.0258)
    ..cubicTo(12.5477, 7.8535, 12.477, 7.6894, 12.3536, 7.5692)
    ..cubicTo(12.1756, 7.3968, 11.8595, 7.3286, 11.6352, 7.4682)
    ..cubicTo(11.4539, 7.5811, 11.2884, 7.8103, 11.1253, 7.95)
    ..cubicTo(10.7501, 8.3117, 10.3823, 8.7111, 10.0065, 9.0691)
    ..cubicTo(9.9107, 8.961, 9.7812, 8.839, 9.6774, 8.7351)
    ..lineTo(9.0917, 8.1469)
    ..lineTo(8.6749, 7.7293)
    ..cubicTo(8.5994, 7.6535, 8.518, 7.5719, 8.4382, 7.5007)
    ..cubicTo(8.3515, 7.4233, 8.1524, 7.3712, 8.0384, 7.3912)
    ..cubicTo(7.6606, 7.4348, 7.4224, 7.7379, 7.4592, 8.1148)
    ..cubicTo(7.4673, 8.1983, 7.5124, 8.3373, 7.5684, 8.3979)
    ..cubicTo(8.062, 8.9323, 8.6133, 9.4347, 9.1144, 9.9608)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _CrossSeal._viewBoxWidth;
    final scaleY = size.height / _CrossSeal._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_CrossSeal._viewBoxMinX, -_CrossSeal._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipRect(_shadowBounds0);
    canvas.saveLayer(_shadowBounds0, _shadowColor0);
    canvas.saveLayer(_shadowBounds0, _shadowBlur0);
    canvas.translate(0, 0.74);
    canvas.clipRect(_shadowBounds0);
    canvas.saveLayer(_shadowBounds0, _shadowAlpha0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor1);
    canvas.restore();
    canvas.restore();
    canvas.saveLayer(_shadowBounds0, _shadowOut0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor1);
    canvas.restore();
    canvas.restore();
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor1);
    canvas.restore();
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor2);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CrossSealPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor1 != mateoOpticalSizeColor1 ||
        oldDelegate.mateoOpticalSizeColor2 != mateoOpticalSizeColor2;
  }
}
