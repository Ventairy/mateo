import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class MateoGoldenFileComparator extends LocalFileComparator {
  MateoGoldenFileComparator(super.testFile);

  Future<bool> _onlyRgbRoundingDiffers(ComparisonResult result) async {
    final actual = result.diffs?['testImage'];
    final expected = result.diffs?['masterImage'];
    if (actual == null || expected == null) return false;
    if (actual.width != expected.width || actual.height != expected.height) return false;

    final actualPixels = (await actual.toByteData())!.buffer.asUint8List();
    final expectedPixels = (await expected.toByteData())!.buffer.asUint8List();
    for (var channel = 0; channel < actualPixels.length; channel++) {
      // macOS rasterizers vary by up to 3/255 in RGB. Alpha remains exact.
      final tolerance = channel % 4 == 3 ? 0 : 3;
      if ((actualPixels[channel] - expectedPixels[channel]).abs() > tolerance) return false;
    }
    return true;
  }

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(imageBytes, await getGoldenBytes(golden));
    try {
      if (result.passed || await _onlyRgbRoundingDiffers(result)) return true;
      throw FlutterError(await generateFailureOutput(result, golden, basedir));
    } finally {
      result.dispose();
    }
  }
}
