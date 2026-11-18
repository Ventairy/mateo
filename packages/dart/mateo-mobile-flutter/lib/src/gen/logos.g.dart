// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
// *****************************************************

// coverage:ignore-file
// Generated canvas and paint sequences intentionally use repeated receiver calls.
// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter

import 'dart:convert' show base64Decode;
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:flutter/widgets.dart';

class _DotdartSvgImages extends StatefulWidget {
  const _DotdartSvgImages({
    required this.providers,
    required this.patterns,
    required this.builder,
  });

  final List<ImageProvider<Object>> providers;
  final List<List<_DotdartSvgPattern>> patterns;
  final Widget Function(List<_DotdartSvgDecodedImage?> images) builder;

  @override
  State<_DotdartSvgImages> createState() => _DotdartSvgImagesState();
}

class _DotdartSvgImagesState extends State<_DotdartSvgImages> {
  List<_DotdartSvgDecodedImage?> _images = [];
  List<({ImageProvider<Object> provider, ImageConfiguration configuration})?> _resolved = [];
  List<bool> _failed = [];
  ImageStream? _stream;
  ImageStreamListener? _listener;
  ImageConfiguration? _configuration;
  bool _pumping = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final configuration = createLocalImageConfiguration(context);
    if (configuration == _configuration) return;
    _configuration = configuration;
    _reload();
  }

  @override
  void didUpdateWidget(covariant _DotdartSvgImages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.providers.length != widget.providers.length) {
      _reload();
      return;
    }
    for (var index = 0; index < widget.providers.length; index++) {
      if (oldWidget.providers[index] != widget.providers[index]) {
        _reload();
        return;
      }
    }
  }

  Object _source(ImageProvider<Object> provider) => provider is ResizeImage ? provider.imageProvider : provider;

  void _reload() {
    final previousImages = _images;
    final previousResolved = _resolved;
    _images = List.filled(widget.providers.length, null);
    _resolved = List.filled(widget.providers.length, null);
    _failed = List.filled(widget.providers.length, false);
    for (var index = 0; index < previousImages.length; index++) {
      final resolved = previousResolved[index];
      if (index < widget.providers.length &&
          resolved != null &&
          _source(resolved.provider) == _source(widget.providers[index])) {
        _images[index] = previousImages[index];
        _resolved[index] = resolved;
      } else {
        previousImages[index]?.dispose();
      }
    }
    // Keep an active decode until it completes. The image cache may still be
    // decoding after a listener is removed; starting another resize here would
    // allow rapid size changes to create many concurrent decodes.
    _pump();
  }

  void _pump() {
    if (_pumping || !mounted || _configuration == null) return;
    _pumping = true;
    try {
      while (_stream == null) {
        int? next;
        for (var index = 0; index < widget.providers.length; index++) {
          final resolved = _resolved[index];
          if (!_failed[index] &&
              (resolved == null ||
                  resolved.provider != widget.providers[index] ||
                  resolved.configuration != _configuration)) {
            next = index;
            break;
          }
        }
        if (next == null) return;
        _load(next);
      }
    } finally {
      _pumping = false;
    }
  }

  void _load(int index) {
    final provider = widget.providers[index];
    final configuration = _configuration!;
    final stream = provider.resolve(configuration);
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (image, synchronous) {
        stream.removeListener(listener);
        if (!mounted) {
          image.dispose();
          return;
        }
        _stream = null;
        _listener = null;
        if (index < widget.providers.length && _source(provider) == _source(widget.providers[index])) {
          _images[index]?.dispose();
          _images = [..._images]..[index] = _DotdartSvgDecodedImage(image, widget.patterns[index]);
          _resolved[index] = (provider: provider, configuration: configuration);
        } else {
          image.dispose();
        }
        if (!synchronous) setState(() {});
        _pump();
      },
      onError: (error, stack) {
        stream.removeListener(listener);
        if (!mounted) return;
        _stream = null;
        _listener = null;
        if (index < widget.providers.length && provider == widget.providers[index] && configuration == _configuration) {
          _failed[index] = true;
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: stack,
              library: 'dotdart generated SVG',
            ),
          );
        }
        _pump();
      },
    );
    _stream = stream;
    _listener = listener;
    stream.addListener(listener);
  }

  @override
  void dispose() {
    final listener = _listener;
    if (listener != null) _stream?.removeListener(listener);
    _stream = null;
    _listener = null;
    for (final image in _images) {
      image?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(_images);
}

class _DotdartSvgDecodedImage {
  _DotdartSvgDecodedImage(this.info, List<_DotdartSvgPattern> patterns)
    : source = Rect.fromLTWH(
        0,
        0,
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      ) {
    for (final pattern in patterns) {
      final rect = pattern.singleImage;
      if (rect == null) continue;
      final shader = ImageShader(
        info.image,
        TileMode.decal,
        TileMode.decal,
        Float64List.fromList([
          rect.width / info.image.width,
          0,
          0,
          0,
          0,
          rect.height / info.image.height,
          0,
          0,
          0,
          0,
          1,
          0,
          rect.left,
          rect.top,
          0,
          1,
        ]),
        filterQuality: FilterQuality.low,
      );
      _shaders.add(shader);
      _shaderPaints[pattern] = Paint()..shader = shader;
    }
  }

  final ImageInfo info;
  final Rect source;
  final _shaders = <ImageShader>[];
  final _shaderPaints = <_DotdartSvgPattern, Paint>{};

  Paint? shaderPaint(_DotdartSvgPattern pattern) => _shaderPaints[pattern];

  void dispose() {
    for (final shader in _shaders) {
      shader.dispose();
    }
    info.dispose();
  }
}

class _DotdartSvgPattern {
  _DotdartSvgPattern({
    required Rect bounds,
    required bool objectBoundingBox,
    required double x,
    required double y,
    required double width,
    required double height,
    required double imageX,
    required double imageY,
    required double imageWidth,
    required double imageHeight,
  }) : _bounds = bounds {
    final sx = objectBoundingBox ? bounds.width : 1.0;
    final sy = objectBoundingBox ? bounds.height : 1.0;
    final ox = objectBoundingBox ? bounds.left : 0.0;
    final oy = objectBoundingBox ? bounds.top : 0.0;
    this.imageWidth = imageWidth * sx;
    this.imageHeight = imageHeight * sy;
    if (bounds.isEmpty) return;
    final tileWidth = width * sx;
    final tileHeight = height * sy;
    final firstX = ((bounds.left - ox - x * sx) / tileWidth).floor();
    final lastX = ((bounds.right - ox - x * sx) / tileWidth).ceil();
    final firstY = ((bounds.top - oy - y * sy) / tileHeight).floor();
    final lastY = ((bounds.bottom - oy - y * sy) / tileHeight).ceil();
    if ((lastX - firstX) * (lastY - firstY) > 4096) {
      throw FlutterError(
        'SVG image pattern exceeds 4096 visible tiles. Use a larger tile.',
      );
    }
    for (var row = firstY; row < lastY; row++) {
      for (var column = firstX; column < lastX; column++) {
        final dx = ox + column * tileWidth;
        final dy = oy + row * tileHeight;
        final tile = Rect.fromLTWH(
          dx + x * sx,
          dy + y * sy,
          tileWidth,
          tileHeight,
        );
        final image = Rect.fromLTWH(
          dx + (x + imageX) * sx,
          dy + (y + imageY) * sy,
          this.imageWidth,
          this.imageHeight,
        );
        final contained =
            tile.left <= image.left &&
            tile.top <= image.top &&
            tile.right >= image.right &&
            tile.bottom >= image.bottom;
        _tiles.add((clip: contained ? null : tile, image: image));
      }
    }
  }

  Rect? get singleImage => _tiles.length == 1 && _tiles.single.clip == null ? _tiles.single.image : null;

  late final double imageWidth;
  late final double imageHeight;
  final Rect _bounds;
  late final Path ovalClip = Path()..addOval(_bounds);
  final _tiles = <({Rect? clip, Rect image})>[];

  void paint(Canvas canvas, _DotdartSvgDecodedImage? info, Paint paint) {
    if (info == null) return;
    final image = info.info.image;
    for (final rects in _tiles) {
      final clip = rects.clip;
      if (clip != null) {
        canvas.save();
        canvas.clipRect(clip, doAntiAlias: false);
      }
      canvas.drawImageRect(image, info.source, rects.image, paint);
      if (clip != null) canvas.restore();
    }
  }
}

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

/// Namespace for dotdart-generated widgets from `logos/`.
///
/// Call a method named after each asset to render it:
///
/// ```dart
/// $Logos.cataqui(<params>);
/// ```
/// ```dart
/// $Logos.cataquiPlus(<params>);
/// ```
/// ```dart
/// $Logos.gmail(<params>);
/// ```
/// ```dart
/// $Logos.googleMessages(<params>);
/// ```
/// ```dart
/// $Logos.instagram(<params>);
/// ```
/// ```dart
/// $Logos.phoneByGoogle(<params>);
/// ```
/// ```dart
/// $Logos.telegram(<params>);
/// ```
/// ```dart
/// $Logos.whatsapp(<params>);
/// ```
abstract final class $Logos {
  $Logos._();

  /// Builds the `Cataqui` widget from `cataqui.svg`.
  static Widget cataqui({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Cataqui(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `CataquiPlus` widget from `cataquiPlus.svg`.
  static Widget cataquiPlus({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor1,
    Color? mateoOpticalSizeColor2,
    Color? mateoOpticalSizeColor3,
    Color? mateoOpticalSizeColor4,
  }) => _CataquiPlus(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor1: mateoOpticalSizeColor1,
    mateoOpticalSizeColor2: mateoOpticalSizeColor2,
    mateoOpticalSizeColor3: mateoOpticalSizeColor3,
    mateoOpticalSizeColor4: mateoOpticalSizeColor4,
  );

  /// Builds the `Gmail` widget from `gmail.svg`.
  static Widget gmail({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Gmail(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor: mateoOpticalSizeColor,
  );

  /// Builds the `GoogleMessages` widget from `googleMessages.svg`.
  static Widget googleMessages({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor1,
    Color? mateoOpticalSizeColor2,
  }) => _GoogleMessages(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor1: mateoOpticalSizeColor1,
    mateoOpticalSizeColor2: mateoOpticalSizeColor2,
  );

  /// Builds the `Instagram` widget from `instagram.svg`.
  static Widget instagram({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
  }) => _Instagram(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
  );

  /// Builds the `PhoneByGoogle` widget from `phoneByGoogle.svg`.
  static Widget phoneByGoogle({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor1,
    Color? mateoOpticalSizeColor2,
    Color? mateoOpticalSizeColor3,
  }) => _PhoneByGoogle(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    mateoOpticalSizeColor1: mateoOpticalSizeColor1,
    mateoOpticalSizeColor2: mateoOpticalSizeColor2,
    mateoOpticalSizeColor3: mateoOpticalSizeColor3,
  );

  /// Builds the `Telegram` widget from `telegram.svg`.
  static Widget telegram({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    Color? mateoOpticalSizeColor,
  }) => _Telegram(
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
    'cataqui.svg' => cataqui(key: key, width: width, height: height),
    'cataqui-plus.svg' => cataquiPlus(key: key, width: width, height: height),
    'gmail.svg' => gmail(key: key, width: width, height: height),
    'google-messages.svg' => googleMessages(
      key: key,
      width: width,
      height: height,
    ),
    'instagram.svg' => instagram(key: key, width: width, height: height),
    'phone_by_google.svg' => phoneByGoogle(
      key: key,
      width: width,
      height: height,
    ),
    'telegram.svg' => telegram(key: key, width: width, height: height),
    'whatsapp.svg' => whatsapp(key: key, width: width, height: height),
    _ => null,
  };
}

/// A dotdart-generated SVG widget from `assets/logos/cataqui.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Cataqui extends StatelessWidget with _DotdartSvgSizing {
  const _Cataqui({
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

  /// Color from SVG id `mateo-optical-size` — defaults to 0xffff4a4b.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Cataqui._svgWidth;

  @override
  double get svgNativeHeight => _Cataqui._svgHeight;

  @override
  double get svgViewBoxWidth => _Cataqui._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Cataqui._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CataquiPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xffff4a4b),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CataquiPainter extends CustomPainter {
  _CataquiPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  static final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.848452469,
    0.0,
    0.0,
    0.0,
    0.0,
    0.848452469,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.702945659,
    2.047923926,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(8.1325, 0)
    ..cubicTo(11.5981, 0, 14.5137, 2.3544, 15.3672, 5.551)
    ..lineTo(19.3551, 18.883)
    ..lineTo(15.8725, 20)
    ..lineTo(13.4503, 12.7586)
    ..cubicTo(12.0936, 14.1274, 10.2121, 14.9751, 8.1325, 14.9751)
    ..lineTo(8.0841, 14.975)
    ..cubicTo(3.9711, 14.9489, 0.645, 11.6067, 0.645, 7.4876)
    ..cubicTo(0.645, 3.3523, 3.9973, 0, 8.1325, 0)
    ..close()
    ..moveTo(8.1325, 3.9063)
    ..cubicTo(6.1547, 3.9063, 4.5513, 5.5097, 4.5513, 7.4876)
    ..cubicTo(4.5513, 9.4654, 6.1547, 11.0688, 8.1325, 11.0688)
    ..cubicTo(10.1104, 11.0688, 11.7138, 9.4654, 11.7138, 7.4876)
    ..cubicTo(11.7138, 5.5097, 10.1104, 3.9063, 8.1325, 3.9063)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Cataqui._viewBoxWidth;
    final scaleY = size.height / _Cataqui._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Cataqui._viewBoxMinX, -_Cataqui._viewBoxMinY);

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
  bool shouldRepaint(covariant _CataquiPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/logos/cataqui-plus.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _CataquiPlus extends StatelessWidget with _DotdartSvgSizing {
  const _CataquiPlus({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor1,
    this.mateoOpticalSizeColor2,
    this.mateoOpticalSizeColor3,
    this.mateoOpticalSizeColor4,
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

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff8e51ff.
  final Color? mateoOpticalSizeColor1;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xfffb2c36.
  final Color? mateoOpticalSizeColor2;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xffffaa00.
  final Color? mateoOpticalSizeColor3;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff00c2e6.
  final Color? mateoOpticalSizeColor4;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _CataquiPlus._svgWidth;

  @override
  double get svgNativeHeight => _CataquiPlus._svgHeight;

  @override
  double get svgViewBoxWidth => _CataquiPlus._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _CataquiPlus._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CataquiPlusPainter(
            mateoOpticalSizeColor1: mateoOpticalSizeColor1 ?? const Color(0xff8e51ff),
            mateoOpticalSizeColor2: mateoOpticalSizeColor2 ?? const Color(0xfffb2c36),
            mateoOpticalSizeColor3: mateoOpticalSizeColor3 ?? const Color(0xffffaa00),
            mateoOpticalSizeColor4: mateoOpticalSizeColor4 ?? const Color(0xff00c2e6),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _CataquiPlusPainter extends CustomPainter {
  _CataquiPlusPainter({
    required this.mateoOpticalSizeColor1,
    required this.mateoOpticalSizeColor2,
    required this.mateoOpticalSizeColor3,
    required this.mateoOpticalSizeColor4,
  });

  final Color mateoOpticalSizeColor1;
  final Color mateoOpticalSizeColor2;
  final Color mateoOpticalSizeColor3;
  final Color mateoOpticalSizeColor4;

  static final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.786929971,
    0.0,
    0.0,
    0.0,
    0.0,
    0.786929971,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.102728396,
    2.110810892,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(7.7373, 0)
    ..lineTo(7.97, 0)
    ..cubicTo(9.64, 0, 10.475, 0, 11.1036, 0.3455)
    ..cubicTo(11.5681, 0.6009, 11.9504, 0.9832, 12.2057, 1.4477)
    ..cubicTo(12.5513, 2.0762, 12.5513, 2.9113, 12.5513, 4.5813)
    ..lineTo(12.5513, 7.6725)
    ..lineTo(12.3186, 7.6725)
    ..cubicTo(10.6486, 7.6725, 9.8135, 7.6725, 9.185, 7.327)
    ..cubicTo(8.7205, 7.0716, 8.3382, 6.6893, 8.0828, 6.2248)
    ..cubicTo(7.7373, 5.5963, 7.7373, 4.7613, 7.7373, 3.0912)
    ..lineTo(7.7373, 0)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(7.7373, 12.4844)
    ..lineTo(7.9917, 12.4844)
    ..cubicTo(9.6538, 12.4844, 10.4849, 12.4844, 11.1104, 12.8283)
    ..cubicTo(11.5727, 13.0824, 11.9532, 13.4629, 12.2074, 13.9252)
    ..cubicTo(12.5513, 14.5508, 12.5513, 15.3819, 12.5513, 17.044)
    ..lineTo(12.5513, 20.1486)
    ..lineTo(12.3186, 20.1486)
    ..cubicTo(10.6486, 20.1486, 9.8135, 20.1486, 9.185, 19.803)
    ..cubicTo(8.7205, 19.5477, 8.3382, 19.1654, 8.0828, 18.7009)
    ..cubicTo(7.7373, 18.0723, 7.7373, 17.2373, 7.7373, 15.5673)
    ..lineTo(7.7373, 12.4844)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(12.2627, 12.4844)
    ..lineTo(12.2627, 12.23)
    ..cubicTo(12.2627, 10.5678, 12.2627, 9.7368, 12.6066, 9.1112)
    ..cubicTo(12.8608, 8.6489, 13.2412, 8.2684, 13.7036, 8.0142)
    ..cubicTo(14.3291, 7.6704, 15.1602, 7.6704, 16.8223, 7.6704)
    ..lineTo(19.9269, 7.6704)
    ..lineTo(19.9269, 7.9031)
    ..cubicTo(19.9269, 9.5731, 19.9269, 10.4081, 19.5814, 11.0367)
    ..cubicTo(19.326, 11.5012, 18.9437, 11.8835, 18.4792, 12.1388)
    ..cubicTo(17.8507, 12.4844, 17.0156, 12.4844, 15.3456, 12.4844)
    ..lineTo(12.2627, 12.4844)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(0.0732, 12.4844)
    ..lineTo(0.0732, 12.2517)
    ..cubicTo(0.0732, 10.5817, 0.0732, 9.7466, 0.4188, 9.1181)
    ..cubicTo(0.6742, 8.6536, 1.0564, 8.2713, 1.521, 8.0159)
    ..cubicTo(2.1495, 7.6704, 2.9845, 7.6704, 4.6546, 7.6704)
    ..lineTo(7.7374, 7.6704)
    ..lineTo(7.7374, 7.9031)
    ..cubicTo(7.7374, 9.5731, 7.7374, 10.4081, 7.3919, 11.0367)
    ..cubicTo(7.1365, 11.5012, 6.7543, 11.8835, 6.2897, 12.1388)
    ..cubicTo(5.6612, 12.4844, 4.8262, 12.4844, 3.1561, 12.4844)
    ..lineTo(0.0732, 12.4844)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _CataquiPlus._viewBoxWidth;
    final scaleY = size.height / _CataquiPlus._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_CataquiPlus._viewBoxMinX, -_CataquiPlus._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor1);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor2);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor3);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor4);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CataquiPlusPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor1 != mateoOpticalSizeColor1 ||
        oldDelegate.mateoOpticalSizeColor2 != mateoOpticalSizeColor2 ||
        oldDelegate.mateoOpticalSizeColor3 != mateoOpticalSizeColor3 ||
        oldDelegate.mateoOpticalSizeColor4 != mateoOpticalSizeColor4;
  }
}

/// A dotdart-generated SVG widget from `assets/logos/gmail.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Gmail extends StatelessWidget with _DotdartSvgSizing {
  const _Gmail({
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

  /// Color from SVG id `mateo-optical-size` — defaults to 0xfffc413d.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Gmail._svgWidth;

  @override
  double get svgNativeHeight => _Gmail._svgHeight;

  @override
  double get svgViewBoxWidth => _Gmail._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Gmail._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GmailPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xfffc413d),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _GmailPainter extends CustomPainter {
  _GmailPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  static final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.810952697,
    0.0,
    0.0,
    0.0,
    0.0,
    0.810952697,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.890488758,
    2.058857191,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(15.6819, 4.0912)
    ..lineTo(20, 4.0912)
    ..lineTo(20, 16.591)
    ..cubicTo(20, 17.344, 19.3894, 17.9546, 18.6364, 17.9546)
    ..lineTo(16.3637, 17.9546)
    ..cubicTo(16.2742, 17.9546, 16.1855, 17.9369, 16.1028, 17.9027)
    ..cubicTo(16.02, 17.8684, 15.9449, 17.8182, 15.8816, 17.7549)
    ..cubicTo(15.8183, 17.6916, 15.7681, 17.6164, 15.7338, 17.5337)
    ..cubicTo(15.6995, 17.451, 15.6819, 17.3623, 15.6819, 17.2728)
    ..lineTo(15.6819, 4.0912)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(4.3181, 4.0912)
    ..lineTo(0, 4.0912)
    ..lineTo(0, 16.591)
    ..cubicTo(0, 17.344, 0.6106, 17.9546, 1.3636, 17.9546)
    ..lineTo(3.6363, 17.9546)
    ..cubicTo(3.7258, 17.9546, 3.8145, 17.9369, 3.8972, 17.9027)
    ..cubicTo(3.9799, 17.8684, 4.0551, 17.8182, 4.1184, 17.7549)
    ..cubicTo(4.1817, 17.6916, 4.2319, 17.6164, 4.2662, 17.5337)
    ..cubicTo(4.3004, 17.451, 4.3181, 17.3623, 4.3181, 17.2728)
    ..lineTo(4.3181, 4.0912)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(3.5484, 2.5518)
    ..cubicTo(2.6355, 1.7846, 1.2736, 1.9025, 0.5064, 2.8154)
    ..cubicTo(-0.2609, 3.7281, -0.1429, 5.09, 0.7699, 5.8573)
    ..lineTo(9.4149, 13.1241)
    ..cubicTo(9.5787, 13.2618, 9.7858, 13.3373, 9.9998, 13.3373)
    ..cubicTo(10.2138, 13.3373, 10.421, 13.2618, 10.5848, 13.1241)
    ..lineTo(19.2298, 5.8572)
    ..cubicTo(20.1425, 5.09, 20.2604, 3.7281, 19.4932, 2.8153)
    ..cubicTo(18.726, 1.9025, 17.364, 1.7846, 16.4513, 2.5518)
    ..lineTo(9.9998, 7.9749)
    ..lineTo(3.5484, 2.5518)
    ..close();

  static final Paint _gradient0 = Paint()
    ..shader = const LinearGradient(
      begin: Alignment(17.8409, 4.09125),
      end: Alignment(17.8409, 17.9546),
      colors: [
        Color(0xff60d673),
        Color(0xff42c868),
        Color(0xff0ebc5f),
        Color(0xff00a9bb),
        Color(0xff3c90ff),
        Color(0xff3186ff),
      ],
      stops: [0.0, 0.17, 0.39, 0.62, 0.86, 1.0],
    ).createShader(const Rect.fromLTRB(-1, -1, 1, 1));
  static final Paint _gradient1 = Paint()
    ..shader = const LinearGradient(
      begin: Alignment(0.000021546, 4.33295),
      end: Alignment(19.9996, 4.33295),
      colors: [
        Color(0xffff63a0),
        Color(0xfffc413d),
        Color(0xfffc413d),
        Color(0xfffc413d),
        Color(0xfffc5c30),
        Color(0xfffeb10c),
        Color(0xfffec700),
        Color(0xffffdb0f),
      ],
      stops: [0.08, 0.3, 0.5, 0.65, 0.72, 0.86, 0.91, 0.96],
    ).createShader(const Rect.fromLTRB(-1, -1, 1, 1));
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Gmail._viewBoxWidth;
    final scaleY = size.height / _Gmail._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Gmail._viewBoxMinX, -_Gmail._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(
      __path0,
      (_gradient0..color = const Color.from(alpha: 1, red: 1, green: 1, blue: 1)),
    );
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.drawPath(
      __path2,
      (_gradient1..color = const Color.from(alpha: 1, red: 1, green: 1, blue: 1)),
    );
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GmailPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/logos/google-messages.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _GoogleMessages extends StatelessWidget with _DotdartSvgSizing {
  const _GoogleMessages({
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

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff336ef3.
  final Color? mateoOpticalSizeColor1;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff3186ff.
  final Color? mateoOpticalSizeColor2;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _GoogleMessages._svgWidth;

  @override
  double get svgNativeHeight => _GoogleMessages._svgHeight;

  @override
  double get svgViewBoxWidth => _GoogleMessages._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _GoogleMessages._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return Builder(
      builder: (context) {
        final ratio = MediaQuery.devicePixelRatioOf(context);
        return _DotdartSvgImages(
          patterns: _GoogleMessagesPainter._patternDefinitions,
          providers: [
            ResizeImage(
              _GoogleMessagesPainter._image0,
              width: math.min(
                128,
                math.max(
                  1,
                  (width / _viewBoxWidth * _GoogleMessagesPainter._decodeWidth0 * ratio).ceil(),
                ),
              ),
              height: math.min(
                99,
                math.max(
                  1,
                  (height / _viewBoxHeight * _GoogleMessagesPainter._decodeHeight0 * ratio).ceil(),
                ),
              ),
            ),
          ],
          builder: (images) => SizedBox.fromSize(
            size: Size(width, height),
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _GoogleMessagesPainter(
                  mateoOpticalSizeColor1: mateoOpticalSizeColor1 ?? const Color(0xff336ef3),
                  mateoOpticalSizeColor2: mateoOpticalSizeColor2 ?? const Color(0xff3186ff),
                  images: images,
                ),
                size: Size(width, height),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GoogleMessagesPainter extends CustomPainter {
  _GoogleMessagesPainter({
    required this.images,
    required this.mateoOpticalSizeColor1,
    required this.mateoOpticalSizeColor2,
  });

  final Color mateoOpticalSizeColor1;
  final Color mateoOpticalSizeColor2;
  final List<_DotdartSvgDecodedImage?> images;

  static final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.853174108,
    0.0,
    0.0,
    0.0,
    0.0,
    0.853174108,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.475829391,
    2.004137366,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(6.1182, 1.0641)
    ..lineTo(12.236, 1.0641)
    ..cubicTo(15.6153, 1.0641, 18.3542, 3.8031, 18.3542, 7.1823)
    ..cubicTo(18.3542, 10.5612, 15.6153, 13.3002, 12.236, 13.3002)
    ..lineTo(6.1182, 13.3002)
    ..cubicTo(2.7389, 13.3002, 0, 10.5612, 0, 7.1823)
    ..cubicTo(0, 3.8035, 2.7389, 1.0641, 6.1182, 1.0641)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(7.7648, 3.4158)
    ..lineTo(7.5951, 3.4158)
    ..cubicTo(7.5782, 3.4158, 7.5613, 3.4162, 7.5444, 3.4169)
    ..cubicTo(7.5314, 3.4169, 7.5184, 3.4173, 7.5054, 3.4181)
    ..cubicTo(7.4872, 3.4181, 7.4689, 3.4189, 7.4504, 3.4205)
    ..lineTo(7.4458, 3.4205)
    ..cubicTo(6.5113, 3.4685, 5.6004, 3.7305, 4.7832, 4.1862)
    ..cubicTo(3.9659, 4.642, 3.2643, 5.2793, 2.7323, 6.049)
    ..cubicTo(2.6569, 6.1582, 2.589, 6.2692, 2.5287, 6.3821)
    ..cubicTo(1.9496, 7.3401, 1.6442, 8.4387, 1.6458, 9.5582)
    ..cubicTo(1.6458, 11.6243, 2.6882, 13.5657, 4.4175, 14.6951)
    ..lineTo(10.731, 18.8189)
    ..cubicTo(11.2006, 19.1262, 11.823, 18.7885, 11.823, 18.2285)
    ..lineTo(11.823, 15.6506)
    ..lineTo(13.8822, 15.6506)
    ..cubicTo(17.2611, 15.6506, 20, 12.9113, 20, 9.5324)
    ..cubicTo(20, 6.1535, 17.2607, 3.4146, 13.8814, 3.4146)
    ..lineTo(7.7632, 3.4146)
    ..lineTo(7.7648, 3.4158)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(-3.7783, -2.9547)
    ..lineTo(23.0754, -2.9547)
    ..lineTo(23.0754, 17.7714)
    ..lineTo(-3.7783, 17.7714)
    ..lineTo(-3.7783, -2.9547)
    ..close();

  static final Path __clip0 = Path()
    ..moveTo(7.7632, 3.4177)
    ..cubicTo(4.3843, 3.4177, 1.6454, 6.1566, 1.6454, 9.5359)
    ..cubicTo(1.6454, 11.6091, 2.6761, 13.4409, 4.2536, 14.5481)
    ..cubicTo(4.3468, 14.6456, 4.4513, 14.7353, 4.568, 14.8102)
    ..lineTo(10.6702, 18.8189)
    ..cubicTo(11.1397, 19.127, 11.7633, 18.7904, 11.7633, 18.2292)
    ..lineTo(11.7633, 15.6553)
    ..lineTo(13.881, 15.6553)
    ..cubicTo(17.2599, 15.6553, 19.9992, 12.916, 19.9992, 9.5371)
    ..cubicTo(19.9992, 6.1582, 17.2606, 3.4189, 13.8814, 3.4189)
    ..lineTo(7.7632, 3.4189)
    ..lineTo(7.7632, 3.4177)
    ..close();

  static final Path _maskedPattern0 = Path.combine(
    PathOperation.intersect,
    Path.combine(PathOperation.intersect, __clip0, __path2),
    Path()..addRect(const Rect.fromLTWH(1, 3, 19, 16)),
  );
  static final MemoryImage _image0 = MemoryImage(
    base64Decode(
      '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',
    ),
  );
  static final _pattern0Geometry2 = _DotdartSvgPattern(
    bounds: __path2.getBounds(),
    objectBoundingBox: true,
    x: 0,
    y: 0,
    width: 1,
    height: 1,
    imageX: 0,
    imageY: 0,
    imageWidth: 0.99854976,
    imageHeight: 0.9982368,
  );
  static final double _decodeWidth0 = _pattern0Geometry2.imageWidth * 0.853174108;
  static final double _decodeHeight0 = _pattern0Geometry2.imageHeight * 0.853174108;
  static final List<List<_DotdartSvgPattern>> _patternDefinitions = [
    [_pattern0Geometry2],
  ];
  static final Paint _patternPaint = Paint()..filterQuality = FilterQuality.low;
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _GoogleMessages._viewBoxWidth;
    final scaleY = size.height / _GoogleMessages._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_GoogleMessages._viewBoxMinX, -_GoogleMessages._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor1);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor2);
    if (images[0]?.shaderPaint(_pattern0Geometry2) case final maskedPaint?) {
      canvas.drawPath(
        _maskedPattern0,
        maskedPaint..color = const Color.from(alpha: 1, red: 1, green: 1, blue: 1),
      );
    } else {
      canvas.save();
      canvas.clipRect(const Rect.fromLTWH(1, 3, 19, 16));
      canvas.clipPath(__clip0);
      if (images[0]?.shaderPaint(_pattern0Geometry2) case final patternPaint?) {
        canvas.drawPath(
          __path2,
          patternPaint..color = const Color.from(alpha: 1, red: 1, green: 1, blue: 1),
        );
      } else {
        canvas.save();
        canvas.clipPath(__path2);
        _pattern0Geometry2.paint(
          canvas,
          images[0],
          _patternPaint..color = const Color.from(alpha: 1, red: 1, green: 1, blue: 1),
        );
        canvas.restore();
      }
      canvas.restore();
    }
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GoogleMessagesPainter oldDelegate) {
    return !identical(images, oldDelegate.images) ||
        oldDelegate.mateoOpticalSizeColor1 != mateoOpticalSizeColor1 ||
        oldDelegate.mateoOpticalSizeColor2 != mateoOpticalSizeColor2;
  }
}

/// A dotdart-generated SVG widget from `assets/logos/instagram.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Instagram extends StatelessWidget with _DotdartSvgSizing {
  const _Instagram({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
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

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Instagram._svgWidth;

  @override
  double get svgNativeHeight => _Instagram._svgHeight;

  @override
  double get svgViewBoxWidth => _Instagram._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Instagram._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return Builder(
      builder: (context) {
        final ratio = MediaQuery.devicePixelRatioOf(context);
        return _DotdartSvgImages(
          patterns: _InstagramPainter._patternDefinitions,
          providers: [
            ResizeImage(
              _InstagramPainter._image0,
              width: math.min(
                128,
                math.max(
                  1,
                  (width / _viewBoxWidth * _InstagramPainter._decodeWidth0 * ratio).ceil(),
                ),
              ),
              height: math.min(
                128,
                math.max(
                  1,
                  (height / _viewBoxHeight * _InstagramPainter._decodeHeight0 * ratio).ceil(),
                ),
              ),
            ),
          ],
          builder: (images) => SizedBox.fromSize(
            size: Size(width, height),
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _InstagramPainter(images: images),
                size: Size(width, height),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InstagramPainter extends CustomPainter {
  _InstagramPainter({required this.images});

  final List<_DotdartSvgDecodedImage?> images;

  static final Float64List _transform0 = Float64List.fromList([
    0.865585988,
    0.0,
    0.0,
    0.0,
    0.0,
    0.865585988,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.342201528,
    1.346511319,
    0.0,
    1.0,
  ]);
  static const Rect _rect0 = Rect.fromLTWH(-5.6264, -5.6264, 31.2019, 31.2019);

  static final Path __clip0 = Path()
    ..moveTo(10, 1.8015)
    ..cubicTo(12.6701, 1.8015, 12.9864, 1.8115, 14.0409, 1.8597)
    ..cubicTo(15.016, 1.9042, 15.5455, 2.0669, 15.8978, 2.204)
    ..cubicTo(16.3648, 2.3855, 16.6978, 2.6019, 17.0477, 2.9519)
    ..cubicTo(17.3976, 3.3018, 17.6145, 3.6349, 17.7956, 4.1018)
    ..cubicTo(17.9327, 4.4541, 18.0954, 4.9836, 18.1399, 5.9587)
    ..cubicTo(18.188, 7.0132, 18.1981, 7.3294, 18.1981, 9.9996)
    ..cubicTo(18.1981, 12.6699, 18.1881, 12.986, 18.1399, 14.0405)
    ..cubicTo(18.0954, 15.0156, 17.9327, 15.5451, 17.7956, 15.8974)
    ..cubicTo(17.6141, 16.3644, 17.3977, 16.6974, 17.0477, 17.0473)
    ..cubicTo(16.6978, 17.3972, 16.3647, 17.6141, 15.8978, 17.7952)
    ..cubicTo(15.5455, 17.9323, 15.016, 18.095, 14.0409, 18.1395)
    ..cubicTo(12.9865, 18.1876, 12.6702, 18.1977, 10, 18.1977)
    ..cubicTo(7.3297, 18.1977, 7.0136, 18.1877, 5.9591, 18.1395)
    ..cubicTo(4.984, 18.095, 4.4545, 17.9323, 4.1022, 17.7952)
    ..cubicTo(3.6352, 17.6136, 3.3022, 17.3972, 2.9523, 17.0473)
    ..cubicTo(2.6024, 16.6974, 2.3855, 16.3643, 2.2044, 15.8974)
    ..cubicTo(2.0672, 15.5451, 1.9046, 15.0156, 1.8601, 14.0405)
    ..cubicTo(1.812, 12.9861, 1.8019, 12.6698, 1.8019, 9.9996)
    ..cubicTo(1.8019, 7.3295, 1.8119, 7.0133, 1.8601, 5.9587)
    ..cubicTo(1.9046, 4.9836, 2.0673, 4.4541, 2.2044, 4.1018)
    ..cubicTo(2.3859, 3.6348, 2.6023, 3.3018, 2.9523, 2.9519)
    ..cubicTo(3.3022, 2.602, 3.6353, 2.3851, 4.1022, 2.204)
    ..cubicTo(4.4545, 2.0669, 4.984, 1.9042, 5.9591, 1.8597)
    ..cubicTo(7.0135, 1.812, 7.3298, 1.8015, 10, 1.8015)
    ..close()
    ..moveTo(10, 0)
    ..cubicTo(7.2841, 0, 6.9435, 0.0116, 5.8769, 0.0601)
    ..cubicTo(4.8124, 0.1086, 4.0857, 0.2778, 3.4497, 0.525)
    ..cubicTo(2.7919, 0.7807, 2.2344, 1.1226, 1.6785, 1.6785)
    ..cubicTo(1.1226, 2.2344, 0.7804, 2.7919, 0.525, 3.4497)
    ..cubicTo(0.2777, 4.0858, 0.1086, 4.8128, 0.0601, 5.8769)
    ..cubicTo(0.0116, 6.9435, 0, 7.2842, 0, 10)
    ..cubicTo(0, 12.7157, 0.0116, 13.0565, 0.0601, 14.123)
    ..cubicTo(0.1086, 15.1876, 0.2778, 15.9142, 0.525, 16.5503)
    ..cubicTo(0.7807, 17.208, 1.1226, 17.7655, 1.6785, 18.3214)
    ..cubicTo(2.2344, 18.8774, 2.7923, 19.2192, 3.4497, 19.4749)
    ..cubicTo(4.0858, 19.7222, 4.8128, 19.8914, 5.8769, 19.9398)
    ..cubicTo(6.9435, 19.9883, 7.2841, 19.9999, 10, 19.9999)
    ..cubicTo(12.7158, 19.9999, 13.0565, 19.9883, 14.123, 19.9398)
    ..cubicTo(15.1876, 19.8914, 15.9142, 19.7221, 16.5503, 19.4749)
    ..cubicTo(17.208, 19.2192, 17.7655, 18.8773, 18.3214, 18.3214)
    ..cubicTo(18.8774, 17.7655, 19.2192, 17.2076, 19.4749, 16.5503)
    ..cubicTo(19.7222, 15.9142, 19.8914, 15.1872, 19.9398, 14.123)
    ..cubicTo(19.9883, 13.0565, 19.9999, 12.7158, 19.9999, 10)
    ..cubicTo(19.9999, 7.2841, 19.9883, 6.9435, 19.9398, 5.8769)
    ..cubicTo(19.8914, 4.8124, 19.7221, 4.0857, 19.4749, 3.4497)
    ..cubicTo(19.2192, 2.7919, 18.8773, 2.2344, 18.3214, 1.6785)
    ..cubicTo(17.7655, 1.1226, 17.2076, 0.7807, 16.5503, 0.525)
    ..cubicTo(15.9142, 0.2777, 15.1872, 0.1086, 14.123, 0.0601)
    ..cubicTo(13.0565, 0.0116, 12.7158, 0, 10, 0)
    ..close()
    ..moveTo(10, 4.8649)
    ..cubicTo(7.1639, 4.8649, 4.8649, 7.1639, 4.8649, 10)
    ..cubicTo(4.8649, 12.8361, 7.1639, 15.1351, 10, 15.1351)
    ..cubicTo(12.8361, 15.1351, 15.1351, 12.8361, 15.1351, 10)
    ..cubicTo(15.1351, 7.1639, 12.8361, 4.8649, 10, 4.8649)
    ..close()
    ..moveTo(10, 13.3335)
    ..cubicTo(8.1591, 13.3335, 6.6665, 11.8414, 6.6665, 10)
    ..cubicTo(6.6665, 8.1587, 8.1591, 6.6666, 10, 6.6666)
    ..cubicTo(11.8408, 6.6666, 13.3334, 8.1587, 13.3334, 10)
    ..cubicTo(13.3334, 11.8414, 11.8408, 13.3335, 10, 13.3335)
    ..close()
    ..moveTo(15.3379, 3.4621)
    ..cubicTo(14.675, 3.4621, 14.1379, 3.9992, 14.1379, 4.6621)
    ..cubicTo(14.1379, 5.325, 14.675, 5.8622, 15.3379, 5.8622)
    ..cubicTo(16.0008, 5.8622, 16.538, 5.325, 16.538, 4.6621)
    ..cubicTo(16.538, 3.9992, 16.0009, 3.4621, 15.3379, 3.4621)
    ..close();

  static final Path __clip1 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  static final Path _maskedPattern0 = Path.combine(
    PathOperation.intersect,
    Path.combine(PathOperation.intersect, __clip0, (Path()..addRect(_rect0))),
    Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20)),
  );
  static final MemoryImage _image0 = MemoryImage(
    base64Decode(
      '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',
    ),
  );
  static final _pattern0Geometry0 = _DotdartSvgPattern(
    bounds: _rect0,
    objectBoundingBox: true,
    x: 0,
    y: 0,
    width: 1,
    height: 1,
    imageX: 0,
    imageY: 0,
    imageWidth: 1.000001057,
    imageHeight: 1.000001057,
  );
  static final double _decodeWidth0 = _pattern0Geometry0.imageWidth * 0.865585988;
  static final double _decodeHeight0 = _pattern0Geometry0.imageHeight * 0.865585988;
  static final List<List<_DotdartSvgPattern>> _patternDefinitions = [
    [_pattern0Geometry0],
  ];
  static final Paint _patternPaint = Paint()..filterQuality = FilterQuality.low;
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Instagram._viewBoxWidth;
    final scaleY = size.height / _Instagram._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Instagram._viewBoxMinX, -_Instagram._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip1);
    if (images[0]?.shaderPaint(_pattern0Geometry0) case final maskedPaint?) {
      canvas.drawPath(
        _maskedPattern0,
        maskedPaint..color = const Color.from(alpha: 1, red: 1, green: 1, blue: 1),
      );
    } else {
      canvas.save();
      canvas.clipRect(const Rect.fromLTWH(0, 0, 20, 20));
      canvas.clipPath(__clip0);
      if (images[0]?.shaderPaint(_pattern0Geometry0) case final patternPaint?) {
        canvas.drawRect(
          _rect0,
          patternPaint..color = const Color.from(alpha: 1, red: 1, green: 1, blue: 1),
        );
      } else {
        canvas.save();
        canvas.clipRect(_rect0);
        _pattern0Geometry0.paint(
          canvas,
          images[0],
          _patternPaint..color = const Color.from(alpha: 1, red: 1, green: 1, blue: 1),
        );
        canvas.restore();
      }
      canvas.restore();
    }
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InstagramPainter oldDelegate) {
    return !identical(images, oldDelegate.images);
  }
}

/// A dotdart-generated SVG widget from `assets/logos/phone_by_google.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _PhoneByGoogle extends StatelessWidget with _DotdartSvgSizing {
  const _PhoneByGoogle({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.mateoOpticalSizeColor1,
    this.mateoOpticalSizeColor2,
    this.mateoOpticalSizeColor3,
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

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff0057cc.
  final Color? mateoOpticalSizeColor1;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff86a9ff.
  final Color? mateoOpticalSizeColor2;

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff578cff.
  final Color? mateoOpticalSizeColor3;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _PhoneByGoogle._svgWidth;

  @override
  double get svgNativeHeight => _PhoneByGoogle._svgHeight;

  @override
  double get svgViewBoxWidth => _PhoneByGoogle._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _PhoneByGoogle._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PhoneByGooglePainter(
            mateoOpticalSizeColor1: mateoOpticalSizeColor1 ?? const Color(0xff0057cc),
            mateoOpticalSizeColor2: mateoOpticalSizeColor2 ?? const Color(0xff86a9ff),
            mateoOpticalSizeColor3: mateoOpticalSizeColor3 ?? const Color(0xff578cff),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PhoneByGooglePainter extends CustomPainter {
  _PhoneByGooglePainter({
    required this.mateoOpticalSizeColor1,
    required this.mateoOpticalSizeColor2,
    required this.mateoOpticalSizeColor3,
  });

  final Color mateoOpticalSizeColor1;
  final Color mateoOpticalSizeColor2;
  final Color mateoOpticalSizeColor3;

  static final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.768699896,
    0.0,
    0.0,
    0.0,
    0.0,
    0.768699896,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    2.955075787,
    1.842737502,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(10.9587, 14.8867)
    ..lineTo(9.5551, 14.9537)
    ..cubicTo(8.5669, 14.2187, 8.0175, 13.859, 7.0159, 12.416)
    ..cubicTo(5.9608, 10.9059, 5.4648, 10.2915, 5.1451, 9.0762)
    ..lineTo(5.9206, 7.6868)
    ..cubicTo(5.9206, 7.6868, 5.1987, 0.2611, 5.2656, 0.2209)
    ..cubicTo(5.2254, 0.2477, 5.1987, 0.2611, 5.1584, 0.288)
    ..cubicTo(0.5742, 3.1587, 0.5071, 9.3422, 4.0363, 14.3776)
    ..cubicTo(7.5636, 19.4129, 13.3906, 21.4702, 17.6532, 18.1306)
    ..cubicTo(17.6801, 18.1038, 17.7202, 18.077, 17.7471, 18.0503)
    ..cubicTo(17.6935, 18.1057, 10.9587, 14.8867, 10.9587, 14.8867)
    ..close()
    ..moveTo(3.0482, 9.2504)
    ..cubicTo(3.0348, 9.2638, 3.0214, 9.2638, 3.0214, 9.2638)
    ..lineTo(3.0482, 9.2504)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(3.0495, 9.2509)
    ..lineTo(3.0228, 9.2643)
    ..cubicTo(3.0362, 9.2643, 3.0362, 9.2509, 3.0495, 9.2509)
    ..close()
    ..moveTo(6.4427, 12.8049)
    ..cubicTo(7.4443, 14.248, 8.5683, 15.4097, 9.5564, 16.1446)
    ..lineTo(10.9735, 14.8891)
    ..cubicTo(10.0639, 14.1541, 9.0892, 13.2336, 7.9671, 11.6298)
    ..cubicTo(6.8449, 10.028, 6.3241, 8.7993, 5.9353, 7.6893)
    ..lineTo(4.3326, 8.5581)
    ..cubicTo(4.639, 9.7735, 5.3742, 11.2949, 6.4427, 12.8049)
    ..close();

  static final Path __path2 = Path()
    ..moveTo(5.1056, 0.3311)
    ..cubicTo(4.4909, 0.7713, 4.0638, 1.5731, 4.2362, 2.3482)
    ..cubicTo(4.2362, 2.3616, 4.2362, 2.3751, 4.2496, 2.3751)
    ..cubicTo(4.8107, 4.2851, 5.1458, 5.4065, 5.9329, 7.6898)
    ..cubicTo(6.8423, 7.196, 8.5793, 6.3003, 8.5793, 6.3003)
    ..cubicTo(9.4352, 5.8467, 9.7683, 4.777, 9.3012, 3.9099)
    ..lineTo(7.7119, 0.932)
    ..cubicTo(7.258, 0.0765, 6.201, -0.2431, 5.3469, 0.1971)
    ..lineTo(5.2664, 0.2373)
    ..cubicTo(5.2128, 0.2641, 5.1592, 0.3043, 5.1056, 0.3311)
    ..close();

  static final Path __path3 = Path()
    ..moveTo(5.2665, 0.2359)
    ..cubicTo(5.2263, 0.2626, 5.1995, 0.276, 5.1593, 0.3029)
    ..cubicTo(5.1995, 0.276, 5.2263, 0.2493, 5.2665, 0.2359)
    ..close();

  static final Path __path4 = Path()
    ..moveTo(17.9208, 15.5291)
    ..lineTo(15.6632, 13.0181)
    ..cubicTo(15.0083, 12.2966, 13.8995, 12.2297, 13.1775, 12.8842)
    ..cubicTo(13.1775, 12.8842, 11.7471, 14.2066, 10.9735, 14.9014)
    ..cubicTo(12.8444, 16.4247, 13.7788, 17.1176, 15.3836, 18.3061)
    ..cubicTo(15.3969, 18.3061, 15.3969, 18.3195, 15.4104, 18.3195)
    ..cubicTo(16.0787, 18.7462, 16.9729, 18.6275, 17.603, 18.1855)
    ..lineTo(17.7638, 18.0649)
    ..lineTo(17.8308, 18.0113)
    ..cubicTo(18.5221, 17.3473, 18.5623, 16.2506, 17.9208, 15.5291)
    ..close();

  static final Path __path5 = Path()
    ..moveTo(17.6532, 18.1333)
    ..cubicTo(17.6801, 18.1064, 17.7202, 18.0796, 17.7471, 18.0529)
    ..cubicTo(17.7202, 18.093, 17.6801, 18.1064, 17.6532, 18.1333)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _PhoneByGoogle._viewBoxWidth;
    final scaleY = size.height / _PhoneByGoogle._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_PhoneByGoogle._viewBoxMinX, -_PhoneByGoogle._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.drawPath(__path0, _fillPaint..color = mateoOpticalSizeColor1);
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor2);
    canvas.drawPath(__path2, _fillPaint..color = mateoOpticalSizeColor3);
    canvas.drawPath(__path3, _fillPaint..color = mateoOpticalSizeColor3);
    canvas.drawPath(__path4, _fillPaint..color = mateoOpticalSizeColor3);
    canvas.drawPath(__path5, _fillPaint..color = mateoOpticalSizeColor3);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PhoneByGooglePainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor1 != mateoOpticalSizeColor1 ||
        oldDelegate.mateoOpticalSizeColor2 != mateoOpticalSizeColor2 ||
        oldDelegate.mateoOpticalSizeColor3 != mateoOpticalSizeColor3;
  }
}

/// A dotdart-generated SVG widget from `assets/logos/telegram.svg`.
///
/// Renders a 20.0×20.0 SVG
/// on a viewBox of 0.0 0.0 20.0 20.0.
/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].
class _Telegram extends StatelessWidget with _DotdartSvgSizing {
  const _Telegram({
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

  /// Color from SVG id `mateo-optical-size` — defaults to 0xffffffff.
  final Color? mateoOpticalSizeColor;

  @override
  double? get svgWidgetWidth => width;

  @override
  double? get svgWidgetHeight => height;

  @override
  bool get svgMaintainAspectRatio => maintainAspectRatio;

  @override
  double get svgNativeWidth => _Telegram._svgWidth;

  @override
  double get svgNativeHeight => _Telegram._svgHeight;

  @override
  double get svgViewBoxWidth => _Telegram._viewBoxWidth;

  @override
  double get svgViewBoxHeight => _Telegram._viewBoxHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _TelegramPainter(
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xffffffff),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _TelegramPainter extends CustomPainter {
  _TelegramPainter({required this.mateoOpticalSizeColor});

  final Color mateoOpticalSizeColor;

  static final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.892734581,
    0.0,
    0.0,
    0.0,
    0.0,
    0.892734581,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    1.073022643,
    1.072825619,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(10, 20)
    ..cubicTo(15.5229, 20, 20, 15.5229, 20, 10)
    ..cubicTo(20, 4.4771, 15.5229, 0, 10, 0)
    ..cubicTo(4.4771, 0, 0, 4.4771, 0, 10)
    ..cubicTo(0, 15.5229, 4.4771, 20, 10, 20)
    ..close();

  static final Path __path1 = Path()
    ..fillType = PathFillType.evenOdd
    ..moveTo(4.5276, 9.8945)
    ..cubicTo(7.4428, 8.6244, 9.3867, 7.7871, 10.3594, 7.3825)
    ..cubicTo(13.1365, 6.2274, 13.7136, 6.0268, 14.0897, 6.0202)
    ..cubicTo(14.1724, 6.0187, 14.3574, 6.0392, 14.4772, 6.1364)
    ..cubicTo(14.5784, 6.2185, 14.6062, 6.3294, 14.6195, 6.4072)
    ..cubicTo(14.6328, 6.4851, 14.6494, 6.6624, 14.6362, 6.8009)
    ..cubicTo(14.4857, 8.3821, 13.8346, 12.2194, 13.5033, 13.9904)
    ..cubicTo(13.3631, 14.7398, 13.0871, 14.991, 12.8199, 15.0156)
    ..cubicTo(12.2391, 15.069, 11.7982, 14.6318, 11.2357, 14.2632)
    ..cubicTo(10.3556, 13.6862, 9.8584, 13.3271, 9.004, 12.7641)
    ..cubicTo(8.0167, 12.1134, 8.6568, 11.7558, 9.2194, 11.1714)
    ..cubicTo(9.3667, 11.0185, 11.9254, 8.6912, 11.9749, 8.4801)
    ..cubicTo(11.9811, 8.4537, 11.9868, 8.3552, 11.9284, 8.3033)
    ..cubicTo(11.8699, 8.2513, 11.7836, 8.2691, 11.7213, 8.2832)
    ..cubicTo(11.633, 8.3032, 10.227, 9.2326, 7.5033, 11.0712)
    ..cubicTo(7.1041, 11.3452, 6.7427, 11.4788, 6.4188, 11.4718)
    ..cubicTo(6.0617, 11.4641, 5.3749, 11.2699, 4.8643, 11.1039)
    ..cubicTo(4.2381, 10.9003, 3.7403, 10.7927, 3.7837, 10.447)
    ..cubicTo(3.8062, 10.2669, 4.0542, 10.0827, 4.5276, 9.8945)
    ..close();

  static final Path __clip0 = Path()..addRect(const Rect.fromLTWH(0, 0, 20, 20));

  static final Paint _gradient0 = Paint()
    ..shader = const LinearGradient(
      begin: Alignment(10, 0),
      end: Alignment(10, 19.8517),
      colors: [Color(0xff2aabee), Color(0xff229ed9)],
      stops: [0.0, 1.0],
    ).createShader(const Rect.fromLTRB(-1, -1, 1, 1));
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _Telegram._viewBoxWidth;
    final scaleY = size.height / _Telegram._viewBoxHeight;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-_Telegram._viewBoxMinX, -_Telegram._viewBoxMinY);

    canvas.save();
    canvas.transform(_transform0);
    canvas.save();
    canvas.clipPath(__clip0);
    canvas.drawPath(
      __path0,
      (_gradient0..color = const Color.from(alpha: 1, red: 1, green: 1, blue: 1)),
    );
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TelegramPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}

/// A dotdart-generated SVG widget from `assets/logos/whatsapp.svg`.
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

  /// Color from SVG id `mateo-optical-size` — defaults to 0xff25d366.
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
            mateoOpticalSizeColor: mateoOpticalSizeColor ?? const Color(0xff25d366),
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

  static final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  static final Float64List _transform0 = Float64List.fromList([
    0.934523164,
    0.0,
    0.0,
    0.0,
    0.0,
    0.934523164,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    0.79754895,
    0.511075555,
    0.0,
    1.0,
  ]);
  static final Path __path0 = Path()
    ..moveTo(10, 0)
    ..cubicTo(4.4772, 0, 0, 4.4772, 0, 10)
    ..cubicTo(0, 11.8169, 0.4847, 13.5208, 1.3317, 14.9892)
    ..lineTo(0, 20)
    ..lineTo(5.195, 18.7719)
    ..cubicTo(6.6211, 19.5547, 8.2583, 20, 10, 20)
    ..cubicTo(15.5228, 20, 20, 15.5228, 20, 10)
    ..cubicTo(20, 4.4772, 15.5228, 0, 10, 0)
    ..close()
    ..moveTo(10, 18.2089)
    ..cubicTo(8.3286, 18.2089, 6.7742, 17.7094, 5.4772, 16.8514)
    ..lineTo(2.4081, 17.6331)
    ..lineTo(3.2689, 14.6994)
    ..cubicTo(2.3375, 13.3681, 1.7911, 11.7478, 1.7911, 9.9997)
    ..cubicTo(1.7911, 5.4661, 5.4664, 1.7908, 10, 1.7908)
    ..cubicTo(14.5336, 1.7908, 18.2089, 5.4661, 18.2089, 9.9997)
    ..cubicTo(18.2089, 14.5333, 14.5336, 18.2086, 10, 18.2086)
    ..lineTo(10, 18.2089)
    ..close();

  static final Path __path1 = Path()
    ..moveTo(12.3431, 11.32)
    ..lineTo(14.7625, 12.4606)
    ..cubicTo(14.8736, 12.5128, 14.9448, 12.6256, 14.9348, 12.7478)
    ..cubicTo(14.9086, 13.0661, 14.7809, 13.7042, 14.2089, 14.2761)
    ..cubicTo(12.5945, 15.8906, 9.6953, 14.0639, 9.5772, 13.9934)
    ..cubicTo(8.8642, 13.6103, 8.1867, 13.0978, 7.5442, 12.4556)
    ..cubicTo(6.902, 11.8134, 6.3892, 11.1356, 6.0061, 10.4225)
    ..cubicTo(5.9353, 10.3047, 4.1086, 7.4056, 5.7234, 5.7908)
    ..cubicTo(6.2953, 5.2189, 6.9334, 5.0911, 7.2517, 5.065)
    ..cubicTo(7.3742, 5.055, 7.4867, 5.1261, 7.5389, 5.2372)
    ..lineTo(8.6798, 7.6567)
    ..cubicTo(8.7336, 7.7711, 8.71, 7.9072, 8.6206, 7.9967)
    ..lineTo(7.7703, 8.847)
    ..cubicTo(7.5864, 9.0308, 7.5325, 9.3172, 7.6592, 9.5445)
    ..cubicTo(7.9695, 10.1009, 8.3867, 10.6367, 8.87, 11.1297)
    ..cubicTo(9.3631, 11.6131, 9.8989, 12.0306, 10.4553, 12.3406)
    ..cubicTo(10.6825, 12.4672, 10.9686, 12.4134, 11.1528, 12.2295)
    ..lineTo(12.0031, 11.3792)
    ..cubicTo(12.0925, 11.2897, 12.2286, 11.2659, 12.3431, 11.32)
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
    canvas.drawPath(__path1, _fillPaint..color = mateoOpticalSizeColor);
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WhatsappPainter oldDelegate) {
    return oldDelegate.mateoOpticalSizeColor != mateoOpticalSizeColor;
  }
}
