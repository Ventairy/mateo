part of '../mateo_icon.dart';

class _MateoThreeDIconCacheScope extends InheritedWidget {
  const new({required this.imageCache, required super.child});

  final ImageCache imageCache;

  @override
  bool updateShouldNotify(_MateoThreeDIconCacheScope oldWidget) => !identical(imageCache, oldWidget.imageCache);
}
