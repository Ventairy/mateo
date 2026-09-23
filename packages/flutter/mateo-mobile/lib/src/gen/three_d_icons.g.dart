// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
// *****************************************************

// coverage:ignore-file
// Generated canvas and paint sequences intentionally use repeated receiver calls.
// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter

import 'package:flutter/widgets.dart';

/// Paints a thumbhash placeholder on a [CustomPainter] canvas.
class _DotdartThumbhashPainter extends CustomPainter {
  _DotdartThumbhashPainter(
    this.thumbWidth,
    this.thumbHeight,
    this.pixels,
    this.dominantColor,
  );

  final int thumbWidth;
  final int thumbHeight;
  final List<Color> pixels;
  final Color dominantColor;
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, _paint..color = dominantColor);
    if (thumbWidth <= 0 || thumbHeight <= 0 || pixels.length < thumbWidth * thumbHeight) {
      return;
    }

    final pixelW = size.width / thumbWidth;
    final pixelH = size.height / thumbHeight;

    for (var y = 0; y < thumbHeight; y++) {
      for (var x = 0; x < thumbWidth; x++) {
        final color = pixels[y * thumbWidth + x];
        if (color.a == 0) continue;
        canvas.drawRect(
          Rect.fromLTWH(
            (x * pixelW).floorToDouble(),
            (y * pixelH).floorToDouble(),
            pixelW.ceilToDouble(),
            pixelH.ceilToDouble(),
          ),
          _paint..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotdartThumbhashPainter oldDelegate) {
    return oldDelegate.thumbWidth != thumbWidth ||
        oldDelegate.thumbHeight != thumbHeight ||
        oldDelegate.pixels != pixels ||
        oldDelegate.dominantColor != dominantColor;
  }
}

/// Returns a frame builder for [Image] that shows a thumbhash placeholder
/// until the image decodes, then swaps to the real image.
ImageFrameBuilder _dotdartImageFrameBuilder(
  int thumbWidth,
  int thumbHeight,
  List<Color> pixels,
  Color color,
) {
  return (context, child, frame, sync) {
    if (sync) return child;
    if (frame != null) return child;
    return CustomPaint(
      painter: _DotdartThumbhashPainter(thumbWidth, thumbHeight, pixels, color),
    );
  };
}

/// Namespace for dotdart-generated widgets from `three_d_icons/`.
///
/// Call a method named after each asset to render it:
///
/// ```dart
/// $ThreeDIcons.bidirecionalHorizontalArrow(<params>);
/// ```
/// ```dart
/// $ThreeDIcons.handshake(<params>);
/// ```
/// ```dart
/// $ThreeDIcons.padlock(<params>);
/// ```
/// ```dart
/// $ThreeDIcons.padlockOpen(<params>);
/// ```
/// ```dart
/// $ThreeDIcons.pencil(<params>);
/// ```
/// ```dart
/// $ThreeDIcons.pointerHandUp(<params>);
/// ```
abstract final class $ThreeDIcons {
  $ThreeDIcons._();

  /// Builds the `BidirecionalHorizontalArrow` widget from `bidirecionalHorizontalArrow.image`.
  /// Pass [package] when this image belongs to a dependency package.
  static Widget bidirecionalHorizontalArrow({
    Key? key,
    double? width,
    double? height,
    String? package,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    BlendMode? colorBlendMode,
  }) => _BidirecionalHorizontalArrow(
    key: key,
    width: width,
    height: height,
    package: package,
    fit: fit,
    alignment: alignment,
    color: color,
    colorBlendMode: colorBlendMode,
  );

  /// Builds the `Handshake` widget from `handshake.image`.
  /// Pass [package] when this image belongs to a dependency package.
  static Widget handshake({
    Key? key,
    double? width,
    double? height,
    String? package,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    BlendMode? colorBlendMode,
  }) => _Handshake(
    key: key,
    width: width,
    height: height,
    package: package,
    fit: fit,
    alignment: alignment,
    color: color,
    colorBlendMode: colorBlendMode,
  );

  /// Builds the `Padlock` widget from `padlock.image`.
  /// Pass [package] when this image belongs to a dependency package.
  static Widget padlock({
    Key? key,
    double? width,
    double? height,
    String? package,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    BlendMode? colorBlendMode,
  }) => _Padlock(
    key: key,
    width: width,
    height: height,
    package: package,
    fit: fit,
    alignment: alignment,
    color: color,
    colorBlendMode: colorBlendMode,
  );

  /// Builds the `PadlockOpen` widget from `padlockOpen.image`.
  /// Pass [package] when this image belongs to a dependency package.
  static Widget padlockOpen({
    Key? key,
    double? width,
    double? height,
    String? package,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    BlendMode? colorBlendMode,
  }) => _PadlockOpen(
    key: key,
    width: width,
    height: height,
    package: package,
    fit: fit,
    alignment: alignment,
    color: color,
    colorBlendMode: colorBlendMode,
  );

  /// Builds the `Pencil` widget from `pencil.image`.
  /// Pass [package] when this image belongs to a dependency package.
  static Widget pencil({
    Key? key,
    double? width,
    double? height,
    String? package,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    BlendMode? colorBlendMode,
  }) => _Pencil(
    key: key,
    width: width,
    height: height,
    package: package,
    fit: fit,
    alignment: alignment,
    color: color,
    colorBlendMode: colorBlendMode,
  );

  /// Builds the `PointerHandUp` widget from `pointerHandUp.image`.
  /// Pass [package] when this image belongs to a dependency package.
  static Widget pointerHandUp({
    Key? key,
    double? width,
    double? height,
    String? package,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    BlendMode? colorBlendMode,
  }) => _PointerHandUp(
    key: key,
    width: width,
    height: height,
    package: package,
    fit: fit,
    alignment: alignment,
    color: color,
    colorBlendMode: colorBlendMode,
  );

  /// Builds the asset matching [fileName], or returns null if it is absent.
  ///
  /// Pass the original filename, including its extension and exact case.
  /// Directory paths and extensionless names do not match.
  /// [key] is forwarded to the generated widget. [width] and [height] are
  /// logical pixels and use the same sizing rules as the named accessor.
  /// All asset-specific options keep their defaults.
  /// [package] identifies the package containing an image or GIF.
  static Widget? findByName(
    String fileName, {
    Key? key,
    double? width,
    double? height,
    String? package,
  }) => switch (fileName) {
    'bidirecional-horizontal-arrow.webp' => bidirecionalHorizontalArrow(
      key: key,
      width: width,
      height: height,
      package: package,
    ),
    'handshake.webp' => handshake(
      key: key,
      width: width,
      height: height,
      package: package,
    ),
    'padlock.webp' => padlock(
      key: key,
      width: width,
      height: height,
      package: package,
    ),
    'padlock-open.webp' => padlockOpen(
      key: key,
      width: width,
      height: height,
      package: package,
    ),
    'pencil.webp' => pencil(
      key: key,
      width: width,
      height: height,
      package: package,
    ),
    'pointer-hand-up.webp' => pointerHandUp(
      key: key,
      width: width,
      height: height,
      package: package,
    ),
    _ => null,
  };
}

/// Manages Flutter image-cache entries for `three_d_icons/`.
///
/// Use the same width and height when caching, rendering, and removing
/// an image so every operation addresses the same decoded entry.
abstract final class $ThreeDIconsCache {
  $ThreeDIconsCache._();

  static const _bidirecionalHorizontalArrowAssetPath = 'assets/three_d_icons/bidirecional-horizontal-arrow.webp';
  static const _handshakeAssetPath = 'assets/three_d_icons/handshake.webp';
  static const _padlockAssetPath = 'assets/three_d_icons/padlock.webp';
  static const _padlockOpenAssetPath = 'assets/three_d_icons/padlock-open.webp';
  static const _pencilAssetPath = 'assets/three_d_icons/pencil.webp';
  static const _pointerHandUpAssetPath = 'assets/three_d_icons/pointer-hand-up.webp';

  /// Decodes `bidirecionalHorizontalArrow` before its first render.
  ///
  /// [width] and [height] are logical pixels. Pass the same values to
  /// `$ThreeDIcons.bidirecionalHorizontalArrow` so it reuses this cache entry.
  /// Pass the same [package] as the image widget for package assets.
  /// Omitting both values uses the widget's default display size.
  static Future<void> precacheBidirecionalHorizontalArrow(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) => precacheImage(
    _provider(
      context,
      asset: AssetImage(
        _bidirecionalHorizontalArrowAssetPath,
        package: package,
      ),
      aspectRatio: 1,
      width: width,
      height: height,
    ),
    context,
  );

  /// Removes the decoded `bidirecionalHorizontalArrow` entry from Flutter's image cache.
  ///
  /// Returns whether the matching entry existed. [width] and [height]
  /// must match the values used to precache or render the image.
  /// [package] must match the image widget and precache call.
  /// An image that is still displayed remains live until its last listener
  /// is removed, preventing a duplicate decode during transitions.
  static Future<bool> removeBidirecionalHorizontalArrow(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) async {
    final configuration = createLocalImageConfiguration(context);
    final provider = _provider(
      context,
      asset: AssetImage(
        _bidirecionalHorizontalArrowAssetPath,
        package: package,
      ),
      aspectRatio: 1,
      width: width,
      height: height,
    );
    final key = await provider.obtainKey(configuration);
    return imageCache.evict(key, includeLive: false);
  }

  /// Decodes `handshake` before its first render.
  ///
  /// [width] and [height] are logical pixels. Pass the same values to
  /// `$ThreeDIcons.handshake` so it reuses this cache entry.
  /// Pass the same [package] as the image widget for package assets.
  /// Omitting both values uses the widget's default display size.
  static Future<void> precacheHandshake(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) => precacheImage(
    _provider(
      context,
      asset: AssetImage(_handshakeAssetPath, package: package),
      aspectRatio: 1,
      width: width,
      height: height,
    ),
    context,
  );

  /// Removes the decoded `handshake` entry from Flutter's image cache.
  ///
  /// Returns whether the matching entry existed. [width] and [height]
  /// must match the values used to precache or render the image.
  /// [package] must match the image widget and precache call.
  /// An image that is still displayed remains live until its last listener
  /// is removed, preventing a duplicate decode during transitions.
  static Future<bool> removeHandshake(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) async {
    final configuration = createLocalImageConfiguration(context);
    final provider = _provider(
      context,
      asset: AssetImage(_handshakeAssetPath, package: package),
      aspectRatio: 1,
      width: width,
      height: height,
    );
    final key = await provider.obtainKey(configuration);
    return imageCache.evict(key, includeLive: false);
  }

  /// Decodes `padlock` before its first render.
  ///
  /// [width] and [height] are logical pixels. Pass the same values to
  /// `$ThreeDIcons.padlock` so it reuses this cache entry.
  /// Pass the same [package] as the image widget for package assets.
  /// Omitting both values uses the widget's default display size.
  static Future<void> precachePadlock(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) => precacheImage(
    _provider(
      context,
      asset: AssetImage(_padlockAssetPath, package: package),
      aspectRatio: 1,
      width: width,
      height: height,
    ),
    context,
  );

  /// Removes the decoded `padlock` entry from Flutter's image cache.
  ///
  /// Returns whether the matching entry existed. [width] and [height]
  /// must match the values used to precache or render the image.
  /// [package] must match the image widget and precache call.
  /// An image that is still displayed remains live until its last listener
  /// is removed, preventing a duplicate decode during transitions.
  static Future<bool> removePadlock(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) async {
    final configuration = createLocalImageConfiguration(context);
    final provider = _provider(
      context,
      asset: AssetImage(_padlockAssetPath, package: package),
      aspectRatio: 1,
      width: width,
      height: height,
    );
    final key = await provider.obtainKey(configuration);
    return imageCache.evict(key, includeLive: false);
  }

  /// Decodes `padlockOpen` before its first render.
  ///
  /// [width] and [height] are logical pixels. Pass the same values to
  /// `$ThreeDIcons.padlockOpen` so it reuses this cache entry.
  /// Pass the same [package] as the image widget for package assets.
  /// Omitting both values uses the widget's default display size.
  static Future<void> precachePadlockOpen(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) => precacheImage(
    _provider(
      context,
      asset: AssetImage(_padlockOpenAssetPath, package: package),
      aspectRatio: 1,
      width: width,
      height: height,
    ),
    context,
  );

  /// Removes the decoded `padlockOpen` entry from Flutter's image cache.
  ///
  /// Returns whether the matching entry existed. [width] and [height]
  /// must match the values used to precache or render the image.
  /// [package] must match the image widget and precache call.
  /// An image that is still displayed remains live until its last listener
  /// is removed, preventing a duplicate decode during transitions.
  static Future<bool> removePadlockOpen(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) async {
    final configuration = createLocalImageConfiguration(context);
    final provider = _provider(
      context,
      asset: AssetImage(_padlockOpenAssetPath, package: package),
      aspectRatio: 1,
      width: width,
      height: height,
    );
    final key = await provider.obtainKey(configuration);
    return imageCache.evict(key, includeLive: false);
  }

  /// Decodes `pencil` before its first render.
  ///
  /// [width] and [height] are logical pixels. Pass the same values to
  /// `$ThreeDIcons.pencil` so it reuses this cache entry.
  /// Pass the same [package] as the image widget for package assets.
  /// Omitting both values uses the widget's default display size.
  static Future<void> precachePencil(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) => precacheImage(
    _provider(
      context,
      asset: AssetImage(_pencilAssetPath, package: package),
      aspectRatio: 1,
      width: width,
      height: height,
    ),
    context,
  );

  /// Removes the decoded `pencil` entry from Flutter's image cache.
  ///
  /// Returns whether the matching entry existed. [width] and [height]
  /// must match the values used to precache or render the image.
  /// [package] must match the image widget and precache call.
  /// An image that is still displayed remains live until its last listener
  /// is removed, preventing a duplicate decode during transitions.
  static Future<bool> removePencil(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) async {
    final configuration = createLocalImageConfiguration(context);
    final provider = _provider(
      context,
      asset: AssetImage(_pencilAssetPath, package: package),
      aspectRatio: 1,
      width: width,
      height: height,
    );
    final key = await provider.obtainKey(configuration);
    return imageCache.evict(key, includeLive: false);
  }

  /// Decodes `pointerHandUp` before its first render.
  ///
  /// [width] and [height] are logical pixels. Pass the same values to
  /// `$ThreeDIcons.pointerHandUp` so it reuses this cache entry.
  /// Pass the same [package] as the image widget for package assets.
  /// Omitting both values uses the widget's default display size.
  static Future<void> precachePointerHandUp(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) => precacheImage(
    _provider(
      context,
      asset: AssetImage(_pointerHandUpAssetPath, package: package),
      aspectRatio: 1,
      width: width,
      height: height,
    ),
    context,
  );

  /// Removes the decoded `pointerHandUp` entry from Flutter's image cache.
  ///
  /// Returns whether the matching entry existed. [width] and [height]
  /// must match the values used to precache or render the image.
  /// [package] must match the image widget and precache call.
  /// An image that is still displayed remains live until its last listener
  /// is removed, preventing a duplicate decode during transitions.
  static Future<bool> removePointerHandUp(
    BuildContext context, {
    double? width,
    double? height,
    String? package,
  }) async {
    final configuration = createLocalImageConfiguration(context);
    final provider = _provider(
      context,
      asset: AssetImage(_pointerHandUpAssetPath, package: package),
      aspectRatio: 1,
      width: width,
      height: height,
    );
    final key = await provider.obtainKey(configuration);
    return imageCache.evict(key, includeLive: false);
  }

  static ImageProvider<Object> _provider(
    BuildContext context, {
    required AssetImage asset,
    required double aspectRatio,
    double? width,
    double? height,
  }) {
    assert(width == null || width > 0, 'width must be greater than zero.');
    assert(height == null || height > 0, 'height must be greater than zero.');
    final resolvedWidth = width ?? (height != null ? height * aspectRatio : 280);
    final resolvedHeight = height ?? resolvedWidth / aspectRatio;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    return ResizeImage.resizeIfNeeded(
      (resolvedWidth * devicePixelRatio).ceil(),
      (resolvedHeight * devicePixelRatio).ceil(),
      asset,
    );
  }
}

/// A dotdart-generated image widget from `assets/three_d_icons/bidirecional-horizontal-arrow.webp`.
///
/// Intrinsic 1254×1254 · WebP · aspect 1.0000.
/// Decodes at display size × device pixel ratio for minimal memory.
/// Renders a thumbhash placeholder in frame 1, then swaps to the image.
class _BidirecionalHorizontalArrow extends StatelessWidget {
  const _BidirecionalHorizontalArrow({
    super.key,
    this.width,
    this.height,
    this.package,
    this.fit,
    this.alignment = Alignment.center,
    this.color,
    this.colorBlendMode,
  });

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// Package containing the image.
  final String? package;

  /// How to inscribe the image in its bounds.
  final BoxFit? fit;

  /// Alignment within the widget bounds.
  final AlignmentGeometry alignment;

  /// A color to blend with the image.
  final Color? color;

  /// The blend mode applied when color is set.
  final BlendMode? colorBlendMode;

  static const double _aspectRatio = 1;
  static const Color _dominantColor = Color(0x3A303030);
  static const int _thumbhashWidth = 8;
  static const int _thumbhashHeight = 8;
  static const List<Color> _thumbhashPixels = <Color>[
    Color(0x1EA9A98F),
    Color(0x2AC0C0B1),
    Color(0x1ABDBDA3),
    Color(0x12EDEDD1),
    Color(0x12EDEDD1),
    Color(0x1ABDBDA3),
    Color(0x2AC0C0B1),
    Color(0x1EA9A98F),
    Color(0x1AE4E4DC),
    Color(0x32B0B0AA),
    Color(0x35BEBEB9),
    Color(0x19BBBBB0),
    Color(0x19BBBBB0),
    Color(0x35BEBEB9),
    Color(0x32B0B0AA),
    Color(0x1AE4E4DC),
    Color(0x20CECED5),
    Color(0x62BABABD),
    Color(0x43B7B7BB),
    Color(0x16D4D4DE),
    Color(0x16D4D4DE),
    Color(0x43B7B7BB),
    Color(0x62BABABD),
    Color(0x20CECED5),
    Color(0x68BFBFC5),
    Color(0x8EBEBEC2),
    Color(0x65BBBBC1),
    Color(0x5DBDBDC3),
    Color(0x5DBDBDC3),
    Color(0x65BBBBC1),
    Color(0x8EBEBEC2),
    Color(0x68BFBFC5),
    Color(0x68BFBFC5),
    Color(0x8EBEBEC2),
    Color(0x65BBBBC1),
    Color(0x5DBDBDC3),
    Color(0x5DBDBDC3),
    Color(0x65BBBBC1),
    Color(0x8EBEBEC2),
    Color(0x68BFBFC5),
    Color(0x20CECED5),
    Color(0x62BABABD),
    Color(0x43B7B7BB),
    Color(0x16D4D4DE),
    Color(0x16D4D4DE),
    Color(0x43B7B7BB),
    Color(0x62BABABD),
    Color(0x20CECED5),
    Color(0x1AE4E4DC),
    Color(0x32B0B0AA),
    Color(0x35BEBEB9),
    Color(0x19BBBBB0),
    Color(0x19BBBBB0),
    Color(0x35BEBEB9),
    Color(0x32B0B0AA),
    Color(0x1AE4E4DC),
    Color(0x1EA9A98F),
    Color(0x2AC0C0B1),
    Color(0x1ABDBDA3),
    Color(0x12EDEDD1),
    Color(0x12EDEDD1),
    Color(0x1ABDBDA3),
    Color(0x2AC0C0B1),
    Color(0x1EA9A98F),
  ];
  static final ImageFrameBuilder _frameBuilder = _dotdartImageFrameBuilder(
    _thumbhashWidth,
    _thumbhashHeight,
    _thumbhashPixels,
    _dominantColor,
  );
  static const String _assetPath = 'assets/three_d_icons/bidirecional-horizontal-arrow.webp';

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    const aspect = _aspectRatio;
    final w = width ?? (height != null ? height! * aspect : 280.0);
    final h = height ?? w / aspect;

    final image = Image.asset(
      _assetPath,
      package: package,
      key: key,
      width: w,
      height: h,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      gaplessPlayback: true,
      filterQuality: FilterQuality.low,
      cacheWidth: (w * dpr).ceil(),
      cacheHeight: (h * dpr).ceil(),
      frameBuilder: _frameBuilder,
    );

    return RepaintBoundary(child: image);
  }
}

/// A dotdart-generated image widget from `assets/three_d_icons/handshake.webp`.
///
/// Intrinsic 1254×1254 · WebP · aspect 1.0000.
/// Decodes at display size × device pixel ratio for minimal memory.
/// Renders a thumbhash placeholder in frame 1, then swaps to the image.
class _Handshake extends StatelessWidget {
  const _Handshake({
    super.key,
    this.width,
    this.height,
    this.package,
    this.fit,
    this.alignment = Alignment.center,
    this.color,
    this.colorBlendMode,
  });

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// Package containing the image.
  final String? package;

  /// How to inscribe the image in its bounds.
  final BoxFit? fit;

  /// Alignment within the widget bounds.
  final AlignmentGeometry alignment;

  /// A color to blend with the image.
  final Color? color;

  /// The blend mode applied when color is set.
  final BlendMode? colorBlendMode;

  static const double _aspectRatio = 1;
  static const Color _dominantColor = Color(0x68535229);
  static const int _thumbhashWidth = 8;
  static const int _thumbhashHeight = 8;
  static const List<Color> _thumbhashPixels = <Color>[
    Color(0x2CBBBCB7),
    Color(0x35C6A6A8),
    Color(0x32FFD164),
    Color(0x41E4BB71),
    Color(0x41E4BB71),
    Color(0x32FFD164),
    Color(0x35C6A6A8),
    Color(0x2CBBBCB7),
    Color(0x32A7CBCD),
    Color(0x30D0D0A9),
    Color(0x2FE7E693),
    Color(0x4DE3D26D),
    Color(0x4DE3D26D),
    Color(0x2FE7E693),
    Color(0x30D0D0A9),
    Color(0x32A7CBCD),
    Color(0x84A9B1C2),
    Color(0x92BABEC1),
    Color(0x85E8D379),
    Color(0xACEAD074),
    Color(0xACEAD074),
    Color(0x85E8D379),
    Color(0x92BABEC1),
    Color(0x84A9B1C2),
    Color(0xAFA2ACCB),
    Color(0xC1D2BCAF),
    Color(0xC4E4C76C),
    Color(0xC6E3CB7F),
    Color(0xC6E3CB7F),
    Color(0xC4E4C76C),
    Color(0xC1D2BCAF),
    Color(0xAFA2ACCB),
    Color(0x7DAEABBC),
    Color(0x9ADDB882),
    Color(0xA5F6CD5D),
    Color(0xB2ECCA65),
    Color(0xB2ECCA65),
    Color(0xA5F6CD5D),
    Color(0x9ADDB882),
    Color(0x7DAEABBC),
    Color(0x44CFAB93),
    Color(0x50DDBE8B),
    Color(0x86F2C851),
    Color(0xA9F1C540),
    Color(0xA9F1C540),
    Color(0x86F2C851),
    Color(0x50DDBE8B),
    Color(0x44CFAB93),
    Color(0x3A9FA1B4),
    Color(0x37CEB091),
    Color(0x41E3CD79),
    Color(0x5DE7CA61),
    Color(0x5DE7CA61),
    Color(0x41E3CD79),
    Color(0x37CEB091),
    Color(0x3A9FA1B4),
    Color(0x2A9AB4B4),
    Color(0x30D2C484),
    Color(0x34E8BF63),
    Color(0x40E3C83D),
    Color(0x40E3C83D),
    Color(0x34E8BF63),
    Color(0x30D2C484),
    Color(0x2A9AB4B4),
  ];
  static final ImageFrameBuilder _frameBuilder = _dotdartImageFrameBuilder(
    _thumbhashWidth,
    _thumbhashHeight,
    _thumbhashPixels,
    _dominantColor,
  );
  static const String _assetPath = 'assets/three_d_icons/handshake.webp';

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    const aspect = _aspectRatio;
    final w = width ?? (height != null ? height! * aspect : 280.0);
    final h = height ?? w / aspect;

    final image = Image.asset(
      _assetPath,
      package: package,
      key: key,
      width: w,
      height: h,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      gaplessPlayback: true,
      filterQuality: FilterQuality.low,
      cacheWidth: (w * dpr).ceil(),
      cacheHeight: (h * dpr).ceil(),
      frameBuilder: _frameBuilder,
    );

    return RepaintBoundary(child: image);
  }
}

/// A dotdart-generated image widget from `assets/three_d_icons/padlock.webp`.
///
/// Intrinsic 1024×1024 · WebP · aspect 1.0000.
/// Decodes at display size × device pixel ratio for minimal memory.
/// Renders a thumbhash placeholder in frame 1, then swaps to the image.
class _Padlock extends StatelessWidget {
  const _Padlock({
    super.key,
    this.width,
    this.height,
    this.package,
    this.fit,
    this.alignment = Alignment.center,
    this.color,
    this.colorBlendMode,
  });

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// Package containing the image.
  final String? package;

  /// How to inscribe the image in its bounds.
  final BoxFit? fit;

  /// Alignment within the widget bounds.
  final AlignmentGeometry alignment;

  /// A color to blend with the image.
  final Color? color;

  /// The blend mode applied when color is set.
  final BlendMode? colorBlendMode;

  static const double _aspectRatio = 1;
  static const Color _dominantColor = Color(0x837D671C);
  static const int _thumbhashWidth = 8;
  static const int _thumbhashHeight = 8;
  static const List<Color> _thumbhashPixels = <Color>[
    Color(0x31DBCA84),
    Color(0x4ADAC76F),
    Color(0x75E0CA7A),
    Color(0x8AE1B994),
    Color(0x8AE1BF94),
    Color(0x75E0C67A),
    Color(0x4ADAA56F),
    Color(0x31DBBF84),
    Color(0x35D6D275),
    Color(0x43E8D231),
    Color(0x9ED4C089),
    Color(0x6EDCAE7C),
    Color(0x6EDCB67C),
    Color(0x9ED4BD89),
    Color(0x43E8AD31),
    Color(0x35D6C875),
    Color(0x31DB9F58),
    Color(0x51E8CA36),
    Color(0xA1DAC07C),
    Color(0x78E5AD57),
    Color(0x78E5B557),
    Color(0xA1DABD7C),
    Color(0x51E8AC36),
    Color(0x31DB8F58),
    Color(0x46E9CF43),
    Color(0x9AEBCD31),
    Color(0xCBEFCC3F),
    Color(0xC7E9C148),
    Color(0xC7E9C548),
    Color(0xCBEFC93F),
    Color(0x9AEBBE31),
    Color(0x46E9C743),
    Color(0x51E4B44B),
    Color(0x9BEEBF00),
    Color(0xC5F7C826),
    Color(0xBBE3B545),
    Color(0xBBE3BA45),
    Color(0xC5F7C526),
    Color(0x9BEEAE00),
    Color(0x51E4AD4B),
    Color(0x4EDFB324),
    Color(0x94E8C004),
    Color(0xC6F1C632),
    Color(0xC0D4A93A),
    Color(0xC0D4AE3A),
    Color(0xC6F1C332),
    Color(0x94E8AF04),
    Color(0x4EDFAB24),
    Color(0x4EEAC400),
    Color(0xA0F0C432),
    Color(0xCDFBC436),
    Color(0xBFF0BA40),
    Color(0xBFF0BF40),
    Color(0xCDFBC236),
    Color(0xA0F0B532),
    Color(0x4EEABD00),
    Color(0x3BE7BA00),
    Color(0x72E2BF10),
    Color(0xB3E1B549),
    Color(0xA7E1B44B),
    Color(0xA7E1B94B),
    Color(0xB3E1B249),
    Color(0x72E2A910),
    Color(0x3BE7B000),
  ];
  static final ImageFrameBuilder _frameBuilder = _dotdartImageFrameBuilder(
    _thumbhashWidth,
    _thumbhashHeight,
    _thumbhashPixels,
    _dominantColor,
  );
  static const String _assetPath = 'assets/three_d_icons/padlock.webp';

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    const aspect = _aspectRatio;
    final w = width ?? (height != null ? height! * aspect : 280.0);
    final h = height ?? w / aspect;

    final image = Image.asset(
      _assetPath,
      package: package,
      key: key,
      width: w,
      height: h,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      gaplessPlayback: true,
      filterQuality: FilterQuality.low,
      cacheWidth: (w * dpr).ceil(),
      cacheHeight: (h * dpr).ceil(),
      frameBuilder: _frameBuilder,
    );

    return RepaintBoundary(child: image);
  }
}

/// A dotdart-generated image widget from `assets/three_d_icons/padlock-open.webp`.
///
/// Intrinsic 1254×1254 · WebP · aspect 1.0000.
/// Decodes at display size × device pixel ratio for minimal memory.
/// Renders a thumbhash placeholder in frame 1, then swaps to the image.
class _PadlockOpen extends StatelessWidget {
  const _PadlockOpen({
    super.key,
    this.width,
    this.height,
    this.package,
    this.fit,
    this.alignment = Alignment.center,
    this.color,
    this.colorBlendMode,
  });

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// Package containing the image.
  final String? package;

  /// How to inscribe the image in its bounds.
  final BoxFit? fit;

  /// Alignment within the widget bounds.
  final AlignmentGeometry alignment;

  /// A color to blend with the image.
  final Color? color;

  /// The blend mode applied when color is set.
  final BlendMode? colorBlendMode;

  static const double _aspectRatio = 1;
  static const Color _dominantColor = Color(0x807E661A);
  static const int _thumbhashWidth = 8;
  static const int _thumbhashHeight = 8;
  static const List<Color> _thumbhashPixels = <Color>[
    Color(0x30DDCAA2),
    Color(0x4CE3BF65),
    Color(0x6EE8BE7A),
    Color(0x8ADAB68F),
    Color(0x8FD7BC8D),
    Color(0x76E1BA76),
    Color(0x4DE1AB64),
    Color(0x29ECE6AE),
    Color(0x2FD6C288),
    Color(0x48E6D440),
    Color(0x85E9CC9B),
    Color(0x5DDAA76D),
    Color(0x61D5B06B),
    Color(0x8DE3C897),
    Color(0x4AE4C13F),
    Color(0x28E5DF92),
    Color(0x31CA9F63),
    Color(0x50E4C268),
    Color(0x7FE5C977),
    Color(0x68E8B55D),
    Color(0x6CE4BC5B),
    Color(0x87DFC574),
    Color(0x52E2B067),
    Color(0x2AD8BD6A),
    Color(0x4FF4C162),
    Color(0x8EF2D032),
    Color(0xC3F5C92F),
    Color(0xC0EFC046),
    Color(0xC5EDC445),
    Color(0xCBF0C72E),
    Color(0x90F1C731),
    Color(0x48FED267),
    Color(0x4FE6A95C),
    Color(0xA8E6B700),
    Color(0xC2F4C83A),
    Color(0xBCDFAB25),
    Color(0xC0DDAF25),
    Color(0xC9F0C639),
    Color(0xA9E5AE00),
    Color(0x48EFBB60),
    Color(0x50E6B244),
    Color(0x9AE0B41F),
    Color(0xC3F1C22F),
    Color(0xB9D4A627),
    Color(0xBDD2AB27),
    Color(0xCBEDC02E),
    Color(0x9BDFAA1F),
    Color(0x49EFC347),
    Color(0x57DFB946),
    Color(0x9FEBBD00),
    Color(0xC1F9C737),
    Color(0xB9F0B637),
    Color(0xBDEEBA36),
    Color(0xC9F4C536),
    Color(0xA1EAB400),
    Color(0x51E7C949),
    Color(0x44E1AB00),
    Color(0x71E7B54C),
    Color(0xAEE6B53A),
    Color(0xA1E1AD40),
    Color(0xA5DFB23F),
    Color(0xB6E1B339),
    Color(0x73E5A74C),
    Color(0x3DEBBF00),
  ];
  static final ImageFrameBuilder _frameBuilder = _dotdartImageFrameBuilder(
    _thumbhashWidth,
    _thumbhashHeight,
    _thumbhashPixels,
    _dominantColor,
  );
  static const String _assetPath = 'assets/three_d_icons/padlock-open.webp';

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    const aspect = _aspectRatio;
    final w = width ?? (height != null ? height! * aspect : 280.0);
    final h = height ?? w / aspect;

    final image = Image.asset(
      _assetPath,
      package: package,
      key: key,
      width: w,
      height: h,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      gaplessPlayback: true,
      filterQuality: FilterQuality.low,
      cacheWidth: (w * dpr).ceil(),
      cacheHeight: (h * dpr).ceil(),
      frameBuilder: _frameBuilder,
    );

    return RepaintBoundary(child: image);
  }
}

/// A dotdart-generated image widget from `assets/three_d_icons/pencil.webp`.
///
/// Intrinsic 1254×1254 · WebP · aspect 1.0000.
/// Decodes at display size × device pixel ratio for minimal memory.
/// Renders a thumbhash placeholder in frame 1, then swaps to the image.
class _Pencil extends StatelessWidget {
  const _Pencil({
    super.key,
    this.width,
    this.height,
    this.package,
    this.fit,
    this.alignment = Alignment.center,
    this.color,
    this.colorBlendMode,
  });

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// Package containing the image.
  final String? package;

  /// How to inscribe the image in its bounds.
  final BoxFit? fit;

  /// Alignment within the widget bounds.
  final AlignmentGeometry alignment;

  /// A color to blend with the image.
  final Color? color;

  /// The blend mode applied when color is set.
  final BlendMode? colorBlendMode;

  static const double _aspectRatio = 1;
  static const Color _dominantColor = Color(0x5854441A);
  static const int _thumbhashWidth = 8;
  static const int _thumbhashHeight = 8;
  static const List<Color> _thumbhashPixels = <Color>[
    Color(0x27D0BC9C),
    Color(0x3BE5C28D),
    Color(0x41ECBE4D),
    Color(0x3FFCC84F),
    Color(0x3CFCB989),
    Color(0x53EBC7A5),
    Color(0x7BE7AB97),
    Color(0x43DD6600),
    Color(0x2DEFC18E),
    Color(0x41ECA19B),
    Color(0x54E4BF75),
    Color(0x49E1B376),
    Color(0x66ECC673),
    Color(0x8FE6CC9B),
    Color(0x8FF0AA9B),
    Color(0x66EE946D),
    Color(0x35E2BB7B),
    Color(0x47EDBF6F),
    Color(0x49DFC331),
    Color(0x63DCCA56),
    Color(0x92F2CD65),
    Color(0x83F7D34B),
    Color(0x8DDAB97A),
    Color(0x49E09E52),
    Color(0x36F4B56C),
    Color(0x3DDDD37D),
    Color(0x5BE0C84B),
    Color(0x8FF1D34C),
    Color(0x86F8CB1D),
    Color(0x9AE4BC52),
    Color(0x61E1B84C),
    Color(0x3EDFA144),
    Color(0x3CE7AA19),
    Color(0x55EFBA67),
    Color(0x8CF4D521),
    Color(0x84FECA30),
    Color(0x92EBBB55),
    Color(0x61E2C000),
    Color(0x45E9CF89),
    Color(0x38EBCB4E),
    Color(0x38E7B57D),
    Color(0x7EEFD459),
    Color(0x8CF4D127),
    Color(0x89F2BC54),
    Color(0x54F2BF57),
    Color(0x4FEDBD4C),
    Color(0x47FBC500),
    Color(0x3BE5D465),
    Color(0x40FFBF9C),
    Color(0xA2DDB584),
    Color(0x82E5C56E),
    Color(0x54EFC265),
    Color(0x4AE1B48B),
    Color(0x4AF7BF68),
    Color(0x46E5B085),
    Color(0x2FFFCB00),
    Color(0x47A3A36E),
    Color(0x55DBAC86),
    Color(0x40D2CF47),
    Color(0x3CEBC044),
    Color(0x3AEFD377),
    Color(0x3FD6CD64),
    Color(0x36ECC64A),
    Color(0x27D7B200),
  ];
  static final ImageFrameBuilder _frameBuilder = _dotdartImageFrameBuilder(
    _thumbhashWidth,
    _thumbhashHeight,
    _thumbhashPixels,
    _dominantColor,
  );
  static const String _assetPath = 'assets/three_d_icons/pencil.webp';

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    const aspect = _aspectRatio;
    final w = width ?? (height != null ? height! * aspect : 280.0);
    final h = height ?? w / aspect;

    final image = Image.asset(
      _assetPath,
      package: package,
      key: key,
      width: w,
      height: h,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      gaplessPlayback: true,
      filterQuality: FilterQuality.low,
      cacheWidth: (w * dpr).ceil(),
      cacheHeight: (h * dpr).ceil(),
      frameBuilder: _frameBuilder,
    );

    return RepaintBoundary(child: image);
  }
}

/// A dotdart-generated image widget from `assets/three_d_icons/pointer-hand-up.webp`.
///
/// Intrinsic 1254×1254 · WebP · aspect 1.0000.
/// Decodes at display size × device pixel ratio for minimal memory.
/// Renders a thumbhash placeholder in frame 1, then swaps to the image.
class _PointerHandUp extends StatelessWidget {
  const _PointerHandUp({
    super.key,
    this.width,
    this.height,
    this.package,
    this.fit,
    this.alignment = Alignment.center,
    this.color,
    this.colorBlendMode,
  });

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// Package containing the image.
  final String? package;

  /// How to inscribe the image in its bounds.
  final BoxFit? fit;

  /// Alignment within the widget bounds.
  final AlignmentGeometry alignment;

  /// A color to blend with the image.
  final Color? color;

  /// The blend mode applied when color is set.
  final BlendMode? colorBlendMode;

  static const double _aspectRatio = 1;
  static const Color _dominantColor = Color(0x5846462B);
  static const int _thumbhashWidth = 8;
  static const int _thumbhashHeight = 8;
  static const List<Color> _thumbhashPixels = <Color>[
    Color(0x1DFF6CCD),
    Color(0x1DE29F86),
    Color(0x53CFC979),
    Color(0x89DBC47C),
    Color(0x4CCDBBA2),
    Color(0x3BDFD58F),
    Color(0x10DBB1B0),
    Color(0x21D35FC0),
    Color(0x1DFFB768),
    Color(0x18FFA68F),
    Color(0x54C9AA64),
    Color(0x91E3C380),
    Color(0x53DFD4A5),
    Color(0x38D3B87A),
    Color(0x1AFF848B),
    Color(0x1AD1B46D),
    Color(0x28F8DF9C),
    Color(0x3BE3BE74),
    Color(0x7DE2C57A),
    Color(0xB0EAC779),
    Color(0x91EAD484),
    Color(0x64E9D687),
    Color(0x2CE6CD85),
    Color(0x2FDAC391),
    Color(0x2EFFD879),
    Color(0x4CEFC835),
    Color(0xADE5C16B),
    Color(0xB1EBCA71),
    Color(0xAFE9D772),
    Color(0x99E7CD72),
    Color(0x31FFEE42),
    Color(0x3EE5B36A),
    Color(0x32D8B57E),
    Color(0x2EE1D665),
    Color(0x8BDAB15E),
    Color(0xABE7BC6D),
    Color(0x9FE7D670),
    Color(0x79DBC165),
    Color(0x2BE6DA69),
    Color(0x34C8A97C),
    Color(0x35D3AF8E),
    Color(0x1FEBDB78),
    Color(0x6FCEBC91),
    Color(0xB5D9B48D),
    Color(0xA3E0CF94),
    Color(0x64D1CE99),
    Color(0x2AC7C868),
    Color(0x2EDABC97),
    Color(0x3197B1DF),
    Color(0x29B0C0D8),
    Color(0x8594B9D1),
    Color(0xB2A0B5D1),
    Color(0xA8A1C3D6),
    Color(0x8598C0D1),
    Color(0x288BD3D9),
    Color(0x31A3C3E0),
    Color(0x30AF87CD),
    Color(0x2C8198B8),
    Color(0x71889DC4),
    Color(0xADA1A1C7),
    Color(0xA68DA8CB),
    Color(0x778DA2BF),
    Color(0x27B1BEC2),
    Color(0x3296A7C9),
  ];
  static final ImageFrameBuilder _frameBuilder = _dotdartImageFrameBuilder(
    _thumbhashWidth,
    _thumbhashHeight,
    _thumbhashPixels,
    _dominantColor,
  );
  static const String _assetPath = 'assets/three_d_icons/pointer-hand-up.webp';

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    const aspect = _aspectRatio;
    final w = width ?? (height != null ? height! * aspect : 280.0);
    final h = height ?? w / aspect;

    final image = Image.asset(
      _assetPath,
      package: package,
      key: key,
      width: w,
      height: h,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      gaplessPlayback: true,
      filterQuality: FilterQuality.low,
      cacheWidth: (w * dpr).ceil(),
      cacheHeight: (h * dpr).ceil(),
      frameBuilder: _frameBuilder,
    );

    return RepaintBoundary(child: image);
  }
}
