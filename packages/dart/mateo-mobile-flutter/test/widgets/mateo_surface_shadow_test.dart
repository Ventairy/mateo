import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<Uint8List> _raster({
  required BoxPainter painter,
  required Size size,
  required double pixelRatio,
  required Color background,
}) async {
  const padding = 96.0;
  final extent = size + const Offset(padding * 2, padding * 2);
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)
    ..drawColor(background, .src)
    ..scale(pixelRatio)
    ..translate(padding + 0.31, padding + 0.67);
  // Both painters receive identical local coordinates, including the same
  // fractional device translation, so this isolates the shadow approximation.
  painter.paint(canvas, .zero, ImageConfiguration(size: size));
  final picture = recorder.endRecording();
  try {
    final image = await picture.toImage((extent.width * pixelRatio).ceil(), (extent.height * pixelRatio).ceil());
    try {
      return (await image.toByteData(format: .rawRgba))!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  } finally {
    picture.dispose();
  }
}

({double meanAbsoluteChannelDelta, List<int> channelMaxima}) _compare(
  Uint8List reference,
  Uint8List actual,
) {
  expect(actual.length, reference.length);
  var totalChannelDelta = 0;
  final channelMaxima = List<int>.filled(4, 0);
  // Include every RGBA channel, including colored backgrounds and translucent
  // fills; checking only one channel could hide a compositing regression.
  for (var index = 0; index < reference.length; index++) {
    final delta = (reference[index] - actual[index]).abs();
    final channel = index % 4;
    channelMaxima[channel] = math.max(channelMaxima[channel], delta);
    totalChannelDelta += delta;
  }
  return (
    meanAbsoluteChannelDelta: totalChannelDelta / reference.length,
    channelMaxima: channelMaxima,
  );
}

void main() {
  testWidgets('when elevated surfaces use native blur shapes, they should retain the authored shadow appearance', (
    tester,
  ) async {
    final previousDebugShadows = debugDisableShadows;
    debugDisableShadows = false;
    try {
      final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
      const samples = <({String name, MateoShape shape, Size size})>[
        (name: 'card radius24', shape: .rounded(radius: 24), size: Size(320, 88)),
        (name: 'square radius32', shape: .rounded(radius: 32), size: Size(320, 320)),
        (name: 'square radius32.01', shape: .rounded(radius: 32.01), size: Size(320, 320)),
        (name: 'square radius48', shape: .rounded(radius: 48), size: Size(320, 320)),
        (name: 'square radius48.01', shape: .rounded(radius: 48.01), size: Size(320, 320)),
        (name: 'small capsule', shape: .capsule(), size: Size(320, 56)),
        (name: 'wide capsule radius44', shape: .capsule(), size: Size(320, 88)),
        (name: 'circle', shape: .capsule(), size: Size(88, 88)),
        (name: 'large circle', shape: .capsule(), size: Size(600, 600)),
        (name: 'square radius120', shape: .rounded(radius: 120), size: Size(320, 320)),
        (name: 'medium capsule', shape: .capsule(), size: Size(640, 320)),
        (name: 'large capsule', shape: .capsule(), size: Size(1200, 600)),
      ];
      var worstRgbChannelDelta = 0;
      var worstAlphaChannelDelta = 0;
      var worstMeanAbsoluteChannelDelta = 0.0;
      var worstRgbSample = '';
      var worstAlphaSample = '';
      var worstMeanSample = '';
      var sampleCount = 0;
      for (final sample in samples) {
        final geometryChannelMaxima = List<int>.filled(4, 0);
        for (final level in [0.1, 0.25, 0.49, 0.5, 1.0, 1.5, 2.0]) {
          final elevation = MateoElevation(level: level);
          for (final fillAlpha in [255, 128, 0]) {
            final fill = theme.palette.accent[5].withValues(alpha: fillAlpha / 255);
            await tester.pumpWidget(
              Directionality(
                textDirection: .ltr,
                child: MateoTheme(
                  data: theme,
                  child: Center(
                    child: MateoSurface(
                      color: fill,
                      shape: sample.shape,
                      elevation: elevation,
                      child: SizedBox(width: sample.size.width, height: sample.size.height),
                    ),
                  ),
                ),
              ),
            );
            final decoration = tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration as ShapeDecoration;
            final actual = decoration.createBoxPainter(() {});
            // Flutter's standard shape painter draws the exact authored path
            // for every shadow. It is the reference, independent of the native
            // blur primitive chosen by MateoSurface's production painter.
            final reference = ShapeDecoration(
              color: fill,
              shape: decoration.shape,
              shadows: elevation.toShadowList(palette: theme.palette),
            ).createBoxPainter(() {});
            try {
              for (final pixelRatio in [1.0, 3.0]) {
                if (sample.size.longestSide > 640 && pixelRatio > 1) continue;
                for (final background in [theme.palette.white, theme.palette.accent[2], const Color(0x00000000)]) {
                  final difference = (await tester.runAsync(() async {
                    final expected = await _raster(
                      painter: reference,
                      size: sample.size,
                      pixelRatio: pixelRatio,
                      background: background,
                    );
                    return _compare(
                      expected,
                      await _raster(
                        painter: actual,
                        size: sample.size,
                        pixelRatio: pixelRatio,
                        background: background,
                      ),
                    );
                  }))!;
                  final reason =
                      '${sample.name}, ${sample.size}, elevation=$level, '
                      'DPR=$pixelRatio, fillAlpha=$fillAlpha, background=$background';
                  final rgbChannelDelta = difference.channelMaxima.take(3).reduce(math.max);
                  final alphaChannelDelta = difference.channelMaxima[3];
                  if (rgbChannelDelta > worstRgbChannelDelta) worstRgbSample = reason;
                  if (alphaChannelDelta > worstAlphaChannelDelta) worstAlphaSample = reason;
                  if (difference.meanAbsoluteChannelDelta > worstMeanAbsoluteChannelDelta) worstMeanSample = reason;
                  worstRgbChannelDelta = math.max(worstRgbChannelDelta, rgbChannelDelta);
                  worstAlphaChannelDelta = math.max(worstAlphaChannelDelta, alphaChannelDelta);
                  worstMeanAbsoluteChannelDelta = math.max(
                    worstMeanAbsoluteChannelDelta,
                    difference.meanAbsoluteChannelDelta,
                  );
                  for (var channel = 0; channel < 4; channel++) {
                    geometryChannelMaxima[channel] = math.max(
                      geometryChannelMaxima[channel],
                      difference.channelMaxima[channel],
                    );
                  }
                  sampleCount++;
                }
              }
            } finally {
              actual.dispose();
              reference.dispose();
            }
          }
        }
        debugPrint('SHADOW_GEOMETRY ${sample.name} maximumRGBA=$geometryChannelMaxima');
      }
      expect(sampleCount, 1449);
      debugPrint(
        'SHADOW_FIDELITY samples=$sampleCount maximumRGBChannelDelta=$worstRgbChannelDelta '
        'maximumAlphaChannelDelta=$worstAlphaChannelDelta '
        'worstMeanAbsoluteRGBAChannelDelta=$worstMeanAbsoluteChannelDelta '
        'rgbSample=$worstRgbSample alphaSample=$worstAlphaSample meanSample=$worstMeanSample',
      );
      // These are raw 8-bit channel units, not percentages. The maximum keeps
      // localized differences small; the mean also limits widespread drift.
      // The native Gaussian renderer can differ by one additional alpha unit
      // on transparent targets. Opaque composites retain the stricter RGB cap.
      expect(worstRgbChannelDelta, lessThanOrEqualTo(2), reason: worstRgbSample);
      expect(worstAlphaChannelDelta, lessThanOrEqualTo(3), reason: worstAlphaSample);
      expect(worstMeanAbsoluteChannelDelta, lessThanOrEqualTo(0.11), reason: worstMeanSample);
    } finally {
      debugDisableShadows = previousDebugShadows;
    }
  });
}
