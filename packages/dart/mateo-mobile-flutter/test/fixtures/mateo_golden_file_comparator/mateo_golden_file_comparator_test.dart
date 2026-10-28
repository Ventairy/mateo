import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mateo_golden_file_comparator.dart';

void main() {
  late Directory directory;
  late MateoGoldenFileComparator comparator;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('mateo-golden-comparator-');
    comparator = MateoGoldenFileComparator(directory.uri.resolve('test.dart'));
    await File.fromUri(directory.uri.resolve('reference.png')).writeAsBytes(await _GoldenImage.encode());
  });
  tearDown(() => directory.delete(recursive: true));

  test('when pixels match, it should accept the image', () async {
    expect(await comparator.compare(await _GoldenImage.encode(), Uri.parse('reference.png')), isTrue);
  });

  test('when RGB rounding varies by up to three channel levels, it should accept the image', () async {
    expect(await comparator.compare(await _GoldenImage.encode(rgbOffset: 3), Uri.parse('reference.png')), isTrue);
  });

  test('when a color changes beyond rounding, it should reject the image', () async {
    await expectLater(
      comparator.compare(await _GoldenImage.encode(rgbOffset: 4), Uri.parse('reference.png')),
      throwsA(isA<FlutterError>()),
    );
    expect(File.fromUri(directory.uri.resolve('failures/reference_isolatedDiff.png')).existsSync(), isTrue);
  });

  test('when one contrasting pixel moves, it should reject the image', () async {
    await expectLater(
      comparator.compare(await _GoldenImage.encode(movePixel: true), Uri.parse('reference.png')),
      throwsA(isA<FlutterError>()),
    );
  });

  test('when alpha changes by one level, it should reject the image', () async {
    await expectLater(
      comparator.compare(await _GoldenImage.encode(alpha: 254), Uri.parse('reference.png')),
      throwsA(isA<FlutterError>()),
    );
  });

  test('when image dimensions change, it should reject the image', () async {
    await expectLater(
      comparator.compare(await _GoldenImage.encode(width: 17), Uri.parse('reference.png')),
      throwsA(isA<FlutterError>()),
    );
  });
}

class _GoldenImage {
  static Future<Uint8List> encode({int rgbOffset = 0, bool movePixel = false, int alpha = 255, int width = 16}) async {
    final pixels = Uint8List.fromList([
      for (var pixel = 0; pixel < width * 16; pixel++) ...[
        (pixel == (movePixel ? 1 : 0) ? 64 : 128) + rgbOffset,
        128 + rgbOffset,
        128 + rgbOffset,
        alpha,
      ],
    ]);
    final buffer = await ui.ImmutableBuffer.fromUint8List(pixels);
    final descriptor = ui.ImageDescriptor.raw(buffer, width: width, height: 16, pixelFormat: .rgba8888);
    final codec = await descriptor.instantiateCodec();
    final image = (await codec.getNextFrame()).image;
    try {
      return (await image.toByteData(format: .png))!.buffer.asUint8List();
    } finally {
      image.dispose();
      codec.dispose();
      descriptor.dispose();
      buffer.dispose();
    }
  }
}
