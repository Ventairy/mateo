/// Keys available on a Mateo numeric keypad.
enum MateoNumericKeypadKey {
  /// The digit zero.
  zero('0', 0),

  /// The digit one.
  one('1', 1),

  /// The digit two.
  two('2', 2),

  /// The digit three.
  three('3', 3),

  /// The digit four.
  four('4', 4),

  /// The digit five.
  five('5', 5),

  /// The digit six.
  six('6', 6),

  /// The digit seven.
  seven('7', 7),

  /// The digit eight.
  eight('8', 8),

  /// The digit nine.
  nine('9', 9),

  /// The decimal separator used by the current keypad locale.
  decimalSeparator('.', null),

  /// The action that deletes the selected or preceding character.
  backspace(null, null);

  /// Creates a numeric-keypad key with its canonical representations.
  const MateoNumericKeypadKey(this.rawValue, this.numericValue);

  /// The locale-independent character represented by this key.
  ///
  /// The decimal separator uses `.` as its canonical representation even when
  /// the keypad displays another localized character. Backspace has no raw
  /// value.
  final String? rawValue;

  /// The numeric value represented by a digit key.
  ///
  /// Decimal separator and backspace keys have no numeric value.
  final double? numericValue;
}
