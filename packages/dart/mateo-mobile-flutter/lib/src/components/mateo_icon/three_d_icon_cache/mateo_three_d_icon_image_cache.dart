part of '../mateo_icon.dart';

class _MateoThreeDIconImageCache extends ImageCache {
  int hits = 0;
  int misses = 0;

  @override
  ImageStreamCompleter? putIfAbsent(Object key, ImageStreamCompleter Function() loader, {ImageErrorListener? onError}) {
    if (!kReleaseMode) {
      final status = statusForKey(key);
      if (status.pending || status.keepAlive || status.live) {
        hits++;
      } else {
        misses++;
      }
    }
    return super.putIfAbsent(key, loader, onError: onError);
  }
}
