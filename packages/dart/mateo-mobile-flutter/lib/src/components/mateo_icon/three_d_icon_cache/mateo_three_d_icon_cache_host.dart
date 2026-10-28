part of '../mateo_icon.dart';

@internal
class MateoThreeDIconCacheHost extends StatefulWidget {
  const MateoThreeDIconCacheHost({required this.child, super.key});

  final Widget child;

  static _MateoThreeDIconCacheHostState? _active;
  static bool _diagnosticsRegistered = false;

  static ImageCache? cacheOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MateoThreeDIconCacheScope>()?.imageCache;

  @override
  State<MateoThreeDIconCacheHost> createState() => _MateoThreeDIconCacheHostState();
}

class _MateoThreeDIconCacheHostState extends State<MateoThreeDIconCacheHost> with WidgetsBindingObserver {
  final _imageCache = _MateoThreeDIconImageCache()..maximumSizeBytes = 8 * 1024 * 1024;
  List<ThreeDIconUsage> _usages = const [];
  final _prepared = <Map<String, Object>>[];
  bool _ready = false;
  bool _suspended = false;
  double? _pixelRatio;
  AssetBundle? _bundle;

  Map<String, Object?> _diagnostics() => {
    'ready': _ready,
    'hits': _imageCache.hits,
    'misses': _imageCache.misses,
    'generalBytes': PaintingBinding.instance.imageCache.currentSizeBytes,
    'generalEntries': PaintingBinding.instance.imageCache.currentSize,
    'pixelRatio': _pixelRatio,
    'maximumBytes': _imageCache.maximumSizeBytes,
    'bytes': _imageCache.currentSizeBytes,
    'entries': _imageCache.currentSize,
    'pending': _imageCache.pendingImageCount,
    'recorded': [for (final usage in _usages) usage.toJson()],
    'prepared': _prepared,
  };

  Future<void> _warmUp(double pixelRatio, AssetBundle bundle) async {
    try {
      _usages = ThreeDIconMetadataNative.read();
      _prepared.clear();
      _ready = false;
      for (final usage in _usages) {
        if (!mounted || _suspended || _pixelRatio != pixelRatio || !identical(_bundle, bundle)) return;
        final icon = MateoIconData.values.byName(usage.icon);
        var succeeded = true;
        await icon._precacheThreeD(
          context,
          size: usage.artworkSize,
          imageCache: _imageCache,
          onError: (_, _) {
            succeeded = false;
          },
        );
        if (!mounted || _suspended || _pixelRatio != pixelRatio || !identical(_bundle, bundle)) return;
        if (succeeded) _prepared.add({...usage.toJson(), 'pixels': (usage.artworkSize * pixelRatio).ceil()});
      }
      _ready = true;
    } on Object catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stack, library: 'Mateo 3D icon preparation'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MateoThreeDIconCacheHost._active = this;
    if (!kReleaseMode && !MateoThreeDIconCacheHost._diagnosticsRegistered) {
      MateoThreeDIconCacheHost._diagnosticsRegistered = true;
      developer.registerExtension('ext.mateo.threeDIconCache', (_, parameters) async {
        final active = MateoThreeDIconCacheHost._active;
        if (parameters['clear'] == 'true') active?.didHaveMemoryPressure();
        if (parameters['clearGeneral'] == 'true') {
          PaintingBinding.instance.imageCache
            ..clear()
            ..clearLiveImages();
        }
        return developer.ServiceExtensionResponse.result(jsonEncode(active?._diagnostics() ?? {'active': false}));
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final bundle = DefaultAssetBundle.of(context);
    if (_pixelRatio == pixelRatio && identical(_bundle, bundle)) return;
    _suspended = false;
    _pixelRatio = pixelRatio;
    _bundle = bundle;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_warmUp(pixelRatio, bundle));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (identical(MateoThreeDIconCacheHost._active, this)) MateoThreeDIconCacheHost._active = null;
    _imageCache
      ..clear()
      ..clearLiveImages();
    super.dispose();
  }

  @override
  void didHaveMemoryPressure() {
    _suspended = true;
    _imageCache.clear();
    _ready = false;
    _prepared.clear();
  }

  @override
  Widget build(BuildContext context) => _MateoThreeDIconCacheScope(imageCache: _imageCache, child: widget.child);
}
