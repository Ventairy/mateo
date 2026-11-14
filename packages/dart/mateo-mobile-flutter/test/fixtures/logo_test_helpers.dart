import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import 'surface_transform_test_widgets.dart';

Widget logoHost(Widget child, {TextDirection direction = TextDirection.ltr}) => Directionality(
  textDirection: direction,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(800, 600)),
    child: MateoTheme(
      data: surfaceTransformTheme,
      child: Center(child: child),
    ),
  ),
);

Future<void> settleLogoImages(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(() async {
    final deadline = DateTime.now().add(const Duration(seconds: 10));
    while (PaintingBinding.instance.imageCache.pendingImageCount > 0) {
      if (DateTime.now().isAfter(deadline)) throw StateError('Logo image decoding timed out.');
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  });
  await tester.pump();
}

Future<Uint8List> logoPixels(WidgetTester tester, GlobalKey boundaryKey) async {
  final pixels = await tester.runAsync(() async {
    final boundary = boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    try {
      return (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  });
  return pixels!;
}
