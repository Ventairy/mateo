import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  test('plain resolves its three typography sizes', () {
    expect(MateoTextInputVariant.plain.resolveTypography(.small), (fontSize: 16.0, lineHeight: 20.0));
    expect(MateoTextInputVariant.plain.resolveTypography(.standard), (fontSize: 18.0, lineHeight: 24.0));
    expect(MateoTextInputVariant.plain.resolveTypography(.large), (fontSize: 20.0, lineHeight: 28.0));
    expect(MateoTextInputSize.large.height, 57);
  });

  for (final variant in [MateoTextInputVariant.filled.neutral, MateoTextInputVariant.filled.base]) {
    test('$variant preserves filled typography and rejects large', () {
      expect(variant.resolveTypography(.small), (fontSize: 15.0, lineHeight: 20.0));
      expect(variant.resolveTypography(.standard), (fontSize: 16.0, lineHeight: 24.0));
      expect(
        () => variant.resolveTypography(.large),
        throwsA(isA<AssertionError>().having((error) => error.message, 'message', 'Large is not supported by filled')),
      );
    });
  }
}
