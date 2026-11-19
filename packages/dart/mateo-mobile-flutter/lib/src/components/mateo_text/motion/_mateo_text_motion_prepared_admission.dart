part of '../mateo_text.dart';

const _maximumLabelLength = 96;
const _maximumDigitsPerPart = 6;
const _space = 0x20;
const _comma = 0x2c;
const _point = 0x2e;
const _noDecimal = -1;

/// One fixed-width number between exact, unchanged ASCII text fragments.
///
/// This only establishes token identity. Native observations still have to
/// establish the template’s geometry and rendering for the resolved style.
final class _PreparedNumeralTemplate {
  const new _(this.prefix, this.suffix, this.wordIndex, this.numberEnd, this._separatorOffset, this._decimalUnit);

  final String prefix;
  final String suffix;
  final int wordIndex;
  final int numberEnd;
  final int _separatorOffset;
  final int _decimalUnit;

  int get numberStart => prefix.length;

  /// Nominate a template from two different, already shaped native labels.
  static _PreparedNumeralTemplate? infer(String before, String after, {required String decimalSeparator}) {
    final length = before.length;
    if (length == 0 ||
        length != after.length ||
        length > _maximumLabelLength ||
        before.codeUnitAt(0) == _space ||
        before.codeUnitAt(length - 1) == _space) {
      return null;
    }

    var firstDifference = 0;
    while (firstDifference < length && before.codeUnitAt(firstDifference) == after.codeUnitAt(firstDifference)) {
      firstDifference++;
    }
    if (firstDifference == length) return null;

    // The first change may occur inside a number with unchanged leading digits.
    var start = firstDifference;
    while (start > 0 && before.codeUnitAt(start - 1) != _space) {
      start--;
    }
    final space = before.indexOf(' ', start);
    final end = space < 0 ? length : space;
    final separatorUnit = _decimalCodeUnit(decimalSeparator);
    final separatorOffset = _numberSeparator(before, start, end, separatorUnit);
    if (separatorOffset == null || _numberSeparator(after, start, end, separatorUnit) != separatorOffset) {
      return null;
    }
    for (var position = end; position < length; position++) {
      if (before.codeUnitAt(position) != after.codeUnitAt(position)) return null;
    }

    final allowPoint = separatorUnit == _point;
    final wordIndex = _stableFragmentWordSeparators(before, 0, start, allowPoint: allowPoint);
    if (wordIndex == null || _stableFragmentWordSeparators(before, end, length, allowPoint: allowPoint) == null) {
      return null;
    }
    return _PreparedNumeralTemplate._(
      before.substring(0, start),
      before.substring(end),
      wordIndex,
      end,
      separatorOffset,
      separatorUnit,
    );
  }

  /// Compare with a previously observed template without creating substrings.
  bool accepts(String before, String after, {required String decimalSeparator}) =>
      _decimalUnit == _decimalCodeUnit(decimalSeparator) && before != after && _matches(before) && _matches(after);

  bool _matches(String text) =>
      text.length == numberEnd + suffix.length &&
      text.startsWith(prefix) &&
      text.endsWith(suffix) &&
      _numberSeparator(text, numberStart, numberEnd, _decimalUnit) == _separatorOffset;

  static int _decimalCodeUnit(String separator) => switch (separator) {
    ',' => _comma,
    '.' => _point,
    _ => _noDecimal,
  };

  /// Returns the relative separator offset, -1 for an integer or null for an unsupported token.
  static int? _numberSeparator(String text, int start, int end, int separatorUnit) {
    var separator = _noDecimal;
    var digits = 0;
    for (var index = start; index < end; index++) {
      final unit = text.codeUnitAt(index);
      if (_isDigit(unit)) {
        if (++digits > _maximumDigitsPerPart) return null;
      } else if (unit == separatorUnit && digits > 0 && separator == _noDecimal) {
        separator = index - start;
        digits = 0;
      } else {
        return null;
      }
    }
    return digits == 0 ? null : separator;
  }

  static int? _stableFragmentWordSeparators(String text, int start, int end, {required bool allowPoint}) {
    var spaces = 0;
    var previousWasSpace = false;
    for (var index = start; index < end; index++) {
      final unit = text.codeUnitAt(index);
      if (unit == _space) {
        if (previousWasSpace) return null;
        previousWasSpace = true;
        spaces++;
      } else {
        previousWasSpace = false;
        if (!_isDigit(unit) &&
            !_isLetter(unit) &&
            unit != 0x24 &&
            unit != 0x3a &&
            unit != _comma &&
            !(allowPoint && unit == _point)) {
          return null;
        }
      }
    }
    return spaces;
  }

  static bool _isDigit(int unit) => unit >= 0x30 && unit <= 0x39;

  static bool _isLetter(int unit) {
    final lowercase = unit | 0x20;
    return lowercase >= 0x61 && lowercase <= 0x7a;
  }
}
