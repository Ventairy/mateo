part of '../mateo_text.dart';

typedef _TextMotionAtlasRequest = ({ui.Picture picture, int width, int height, Offset origin});
typedef _TextMotionAtlasRegion = ({int left, int top, int width, int height});

sealed class _TextMotionTextureEntry;

enum _PendingTextMotionTexture implements _TextMotionTextureEntry { rasterizing }

final class _TextMotionTexture extends _TextMotionTextureEntry {
  new(this.page, this.origin) {
    page.owners++;
  }

  static int _activePixels = 0;
  static const int _maxTextureDimension = 2048;
  static const int _maxTexturePixels = 768 * 1024;
  // Allow 10 MiB of RGBA pixels while a new destination overlaps fading pages.
  static const int _maxActivePixels = 2560 * 1024;

  final _TextMotionAtlasImage page;
  final Offset origin;

  Paint get paint => page.paint;

  static _TextMotionAtlasRegion? measure(_TextMotionLayout layout, double pixelRatio) {
    final glyphs = layout.glyphs;
    if (glyphs.isEmpty) return null;
    var bounds = glyphs.first.paintBounds;
    for (var index = 1; index < glyphs.length; index++) {
      bounds = bounds.expandToInclude(glyphs[index].paintBounds);
    }
    return measureBounds(bounds, pixelRatio);
  }

  static _TextMotionAtlasRegion? measureBounds(Rect bounds, double pixelRatio) {
    if (!pixelRatio.isFinite || pixelRatio <= 0) return null;
    final pixelBounds = Rect.fromLTRB(
      bounds.left * pixelRatio,
      bounds.top * pixelRatio,
      bounds.right * pixelRatio,
      bounds.bottom * pixelRatio,
    );
    if (!pixelBounds.isFinite || pixelBounds.shortestSide <= 0) return null;
    final left = pixelBounds.left.floor() - 1;
    final top = pixelBounds.top.floor() - 1;
    final width = pixelBounds.right.ceil() - left + 1;
    final height = pixelBounds.bottom.ceil() - top + 1;
    if (width > _maxTextureDimension || height > _maxTextureDimension || width * height > _maxTexturePixels) {
      return null;
    }
    return (left: left, top: top, width: width, height: height);
  }

  static _TextMotionAtlasRequest? prepare(
    _TextMotionLayout layout,
    double pixelRatio,
    _TextMotionAtlasRegion region,
  ) {
    if (!reserve(region.width, region.height)) return null;
    final recorder = ui.PictureRecorder();
    Canvas(recorder)
      ..translate(-region.left.toDouble(), -region.top.toDouble())
      ..scale(pixelRatio)
      ..drawPicture(layout.picture);
    return (
      picture: recorder.endRecording(),
      width: region.width,
      height: region.height,
      origin: Offset(region.left / pixelRatio, region.top / pixelRatio),
    );
  }

  static bool _canReservePixels(int pixels) =>
      pixels <= _maxTexturePixels && _activePixels + pixels <= _maxActivePixels;

  static bool reserve(int width, int height) {
    final pixels = width * height;
    if (!_canReservePixels(pixels)) return false;
    _activePixels += pixels;
    return true;
  }

  static _TextMotionAtlasImage? rasterizePageSync(ui.Picture picture, int width, int height) {
    ui.Image? image;
    try {
      image = picture.toImageSync(width, height);
      return _TextMotionAtlasImage(image);
    } on Exception {
      image?.dispose();
      _activePixels -= width * height;
      return null;
    } finally {
      picture.dispose();
    }
  }

  static _TextMotionTexture? rasterizeSync(_TextMotionAtlasRequest request) {
    final page = rasterizePageSync(request.picture, request.width, request.height);
    return page == null ? null : _TextMotionTexture(page, request.origin);
  }

  static Future<_TextMotionAtlasImage?> rasterizePage(ui.Picture picture, int width, int height) async {
    ui.Image? image;
    try {
      image = await picture.toImage(width, height);
      return _TextMotionAtlasImage(image);
    } on Exception {
      image?.dispose();
      _activePixels -= width * height;
      return null;
    } finally {
      picture.dispose();
    }
  }

  static Future<_TextMotionTexture?> rasterize(_TextMotionAtlasRequest request) async {
    final page = await rasterizePage(request.picture, request.width, request.height);
    return page == null ? null : _TextMotionTexture(page, request.origin);
  }

  void dispose() {
    if (--page.owners == 0) page.dispose();
  }
}

class _TextMotionAtlasImage {
  new(this.image)
    : _meshPaint = _TextMotionAtlasBatch.usesRawAtlas
          ? null
          : (Paint()..shader = ui.ImageShader(image, TileMode.clamp, TileMode.clamp, _identity, filterQuality: .low));

  static final Float64List _identity = Matrix4.identity().storage;

  final ui.Image image;
  final Paint? _meshPaint;
  int owners = 0;
  bool rasterizationFailed = false;

  Paint get paint => _meshPaint!;

  void dispose() {
    _TextMotionTexture._activePixels -= image.width * image.height;
    _meshPaint?.shader?.dispose();
    image.dispose();
  }
}

// Sorting a batch reads these fields repeatedly. A class avoids the Dart
// runtime type checks incurred by sorting the equivalent record.
final class _QueuedTextMotionAtlas {
  new({required this.layout, required this.textures, required this.pixelRatio, required this.region});

  final _TextMotionLayout layout;
  final Map<double, _TextMotionTextureEntry?> textures;
  final double pixelRatio;
  final _TextMotionAtlasRegion region;
}

typedef _PlacedTextMotionAtlas = ({_QueuedTextMotionAtlas request, int x, int y});

class _TextMotionAtlasBatch {
  // Flutter 3.50 exposes this capability only on Impeller.
  static bool get usesImpeller => ui.ImageFilter.isShaderFilterSupported;

  // Draw Android Skia atlas images directly. Shader paint comparison on this
  // engine may access a deferred Skia texture from the UI thread.
  static final bool usesRawAtlas = !kIsWeb && defaultTargetPlatform == .android && !usesImpeller;
  static bool get usesDeferredImages => usesImpeller || usesRawAtlas;

  static const _maxWidth = 1024;
  static const _maxTileHeight = 320;
  static const _maxPageHeight = 768;
  static final _pending = <(Map<double, _TextMotionTextureEntry?>, double), _QueuedTextMotionAtlas>{};

  static bool fitsPage(_TextMotionAtlasRegion region) => region.width <= _maxWidth && region.height <= _maxTileHeight;

  static bool awaitingTexture(_TextMotionLayout layout, double pixelRatio) {
    final textures = layout._textures;
    return layout.hasPendingTexture(pixelRatio) || (textures != null && hasQueuedTexture(textures, pixelRatio));
  }

  static bool hasQueuedTexture(Map<double, _TextMotionTextureEntry?> textures, double pixelRatio) =>
      _pending.containsKey((textures, pixelRatio));

  static void enqueue(
    _TextMotionLayout layout,
    Map<double, _TextMotionTextureEntry?> textures,
    double pixelRatio,
    _TextMotionAtlasRegion region,
  ) {
    final departure = layout._departureAtlas;
    if (identical(layout._textures, textures) &&
        departure != null &&
        _pending.containsKey((departure.textures, pixelRatio))) {
      layout._releaseDepartureAtlas();
    }
    _pending[(textures, pixelRatio)] = _QueuedTextMotionAtlas(
      layout: layout,
      textures: textures,
      pixelRatio: pixelRatio,
      region: region,
    );
  }

  static void cancel(Map<double, _TextMotionTextureEntry?> textures) {
    if (_pending.isEmpty) return;
    for (final pixelRatio in textures.keys) {
      _pending.remove((textures, pixelRatio));
    }
  }

  static void flush() {
    if (_pending.isEmpty) return;
    final requests = _pending.values.toList()..sort(_compareSize);
    _pending.clear();
    final pages = <_TextMotionAtlasPage>[];
    for (final request in requests) {
      if (pages.any((page) => page.append(request))) continue;
      pages.add(_TextMotionAtlasPage()..append(request));
    }
    for (final page in pages) {
      page.rasterize();
    }
  }

  static int _compareSize(_QueuedTextMotionAtlas a, _QueuedTextMotionAtlas b) {
    final height = b.region.height.compareTo(a.region.height);
    return height == 0 ? b.region.width.compareTo(a.region.width) : height;
  }
}

class _TextMotionAtlasPage {
  final _tiles = <_PlacedTextMotionAtlas>[];
  final _shelves = <({int y, int height, int x})>[];
  int _width = 0;
  int _height = 0;

  bool append(_QueuedTextMotionAtlas request) {
    final region = request.region;
    for (var index = 0; index < _shelves.length; index++) {
      final shelf = _shelves[index];
      final nextX = shelf.x + region.width;
      if (nextX > _TextMotionAtlasBatch._maxWidth || region.height > shelf.height) continue;
      _tiles.add((request: request, x: shelf.x, y: shelf.y));
      _width = math.max(_width, nextX);
      _shelves[index] = (y: shelf.y, height: shelf.height, x: nextX);
      return true;
    }
    final nextHeight = _height + region.height;
    if (nextHeight > _TextMotionAtlasBatch._maxPageHeight) return false;
    _tiles.add((request: request, x: 0, y: _height));
    _shelves.add((y: _height, height: region.height, x: region.width));
    _width = math.max(_width, region.width);
    _height = nextHeight;
    return true;
  }

  void rasterize() {
    if (!_TextMotionTexture.reserve(_width, _height)) {
      for (final tile in _tiles) {
        final request = tile.request;
        request.layout._prepareIndividualTexture(request.textures, request.pixelRatio, request.region);
      }
      return;
    }
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    for (final tile in _tiles) {
      final request = tile.request;
      final region = request.region;
      canvas
        ..save()
        ..clipRect(
          Rect.fromLTWH(tile.x.toDouble(), tile.y.toDouble(), region.width.toDouble(), region.height.toDouble()),
        )
        ..translate((tile.x - region.left).toDouble(), (tile.y - region.top).toDouble())
        ..scale(request.pixelRatio)
        ..drawPicture(request.layout.picture)
        ..restore();
    }
    final picture = recorder.endRecording();
    if (_TextMotionAtlasBatch.usesDeferredImages) {
      _publish(_TextMotionTexture.rasterizePageSync(picture, _width, _height));
    } else {
      for (final tile in _tiles) {
        final request = tile.request;
        request.textures[request.pixelRatio] = _PendingTextMotionTexture.rasterizing;
      }
      unawaited(_load(picture));
    }
  }

  Future<void> _load(ui.Picture picture) async {
    _publish(await _TextMotionTexture.rasterizePage(picture, _width, _height));
  }

  void _publish(_TextMotionAtlasImage? page) {
    for (final tile in _tiles) {
      final request = tile.request;
      if (!request.layout.ownsTextureMap(request.textures)) continue;
      if (page == null) {
        request.textures[request.pixelRatio] = null;
        continue;
      }
      final origin = Offset(
        (request.region.left - tile.x) / request.pixelRatio,
        (request.region.top - tile.y) / request.pixelRatio,
      );
      request.layout._publishTexture(request.textures, request.pixelRatio, _TextMotionTexture(page, origin));
    }
    if (page != null && page.owners == 0) page.dispose();
  }
}
