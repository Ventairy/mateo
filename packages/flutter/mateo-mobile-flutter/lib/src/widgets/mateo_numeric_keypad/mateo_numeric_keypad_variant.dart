import 'mateo_numeric_keypad_key.dart';

/// Input layouts available to the Mateo numeric keypad.
///
/// Each variant owns the order and behavior of the keys it presents.
enum MateoNumericKeypadVariant {
  /// A localized keypad for entering non-negative monetary values.
  monetary([
    MateoNumericKeypadKey.one,
    MateoNumericKeypadKey.two,
    MateoNumericKeypadKey.three,
    MateoNumericKeypadKey.four,
    MateoNumericKeypadKey.five,
    MateoNumericKeypadKey.six,
    MateoNumericKeypadKey.seven,
    MateoNumericKeypadKey.eight,
    MateoNumericKeypadKey.nine,
    MateoNumericKeypadKey.decimalSeparator,
    MateoNumericKeypadKey.zero,
    MateoNumericKeypadKey.backspace,
  ]);

  /// Creates a keypad variant with its ordered [keys].
  const MateoNumericKeypadVariant(this.keys);

  /// The immutable keys displayed by this variant in row-major order.
  final List<MateoNumericKeypadKey> keys;
}
