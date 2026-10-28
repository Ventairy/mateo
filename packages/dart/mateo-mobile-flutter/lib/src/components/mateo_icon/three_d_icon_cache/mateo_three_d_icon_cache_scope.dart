part of '../mateo_icon.dart';

class _MateoThreeDIconCacheScope extends InheritedWidget {
  const _MateoThreeDIconCacheScope({required this.imageCache, required super.child});

  final ImageCache imageCache;

  @override
  bool updateShouldNotify(_MateoThreeDIconCacheScope oldWidget) => !identical(imageCache, oldWidget.imageCache);
}
