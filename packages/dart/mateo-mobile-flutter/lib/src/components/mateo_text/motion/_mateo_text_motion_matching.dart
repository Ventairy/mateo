part of '../mateo_text.dart';

const _numberSeparators = ".,'\u00a0\u202f\u2009\u2007";
final _digit = RegExp(r'^\p{Nd}$', unicode: true);
final _currency = RegExp(r'^\p{Sc}$', unicode: true);
final _whitespace = RegExp(r'^\s+$', unicode: true);

bool _isDigit(String character) {
  final code = character.codeUnitAt(0);
  return code < 0x80 ? code >= 0x30 && code <= 0x39 && character.length == 1 : _digit.hasMatch(character);
}

enum _TextMotionKind { text, digit, symbol }

typedef _TextMotionUnit = ({String text, int start, int end});

class _TextMotionWord {
  new(this.text, this.units) : numeric = _isNumeric(units);

  final List<_TextMotionUnit> units;
  final String text;
  final bool numeric;

  String get matchKey => numeric ? '\u0000' : text;

  late final List<String> characters = [for (final unit in units) unit.text];

  late final String numericSkeleton = [
    for (final unit in units)
      if (!_isDigit(unit.text) && !_numberSeparators.contains(unit.text)) unit.text,
  ].join();

  static bool _isNumeric(List<_TextMotionUnit> units) {
    var start = 0;
    var end = units.length;
    while (start < end && _isAffix(units[start].text, '+-−(#')) {
      start++;
    }
    while (end > start && _isAffix(units[end - 1].text, "%.,!?:;)\"'”’")) {
      end--;
    }
    if (start >= end || !_isDigit(units[start].text) || !_isDigit(units[end - 1].text)) return false;
    for (var index = start + 1; index < end - 1; index++) {
      final character = units[index].text;
      if (!_isDigit(character) && !_numberSeparators.contains(character)) return false;
    }
    return true;
  }

  static bool _isAffix(String character, String symbols) =>
      symbols.contains(character) ||
      character == r'$' ||
      (character.codeUnitAt(0) >= 0x80 && _currency.hasMatch(character));
}

bool _isAsciiSpace(int codeUnit) => codeUnit == 0x20 || (codeUnit >= 0x09 && codeUnit <= 0x0d);

List<_TextMotionWord> _textMotionWords(String data) {
  for (var offset = 0; offset < data.length; offset++) {
    if (data.codeUnitAt(offset) >= 0x80) return _unicodeWords(data);
  }

  final words = <_TextMotionWord>[];
  var start = 0;
  while (start < data.length) {
    if (_isAsciiSpace(data.codeUnitAt(start))) {
      start++;
      continue;
    }
    var end = start + 1;
    while (end < data.length && !_isAsciiSpace(data.codeUnitAt(end))) {
      end++;
    }
    final units = List<_TextMotionUnit>.generate(end - start, (index) {
      final offset = start + index;
      return (text: data[offset], start: offset, end: offset + 1);
    }, growable: false);
    words.add(_TextMotionWord(data.substring(start, end), units));
    start = end;
  }
  return words;
}

List<_TextMotionWord> _unicodeWords(String data) {
  final words = <_TextMotionWord>[];
  var word = <_TextMotionUnit>[];
  var offset = 0;
  final characters = data.characters.iterator;
  if (!characters.moveNext()) return words;
  var character = characters.current;
  var previous = '';
  while (true) {
    final end = offset + character.length;
    final next = characters.moveNext() ? characters.current : null;
    final codeUnit = character.codeUnitAt(0);
    final isSpace = codeUnit < 0x80 && character.length == 1
        ? _isAsciiSpace(codeUnit)
        : _whitespace.hasMatch(character);
    final isGroupingSpace =
        isSpace &&
        _numberSeparators.contains(character) &&
        previous.isNotEmpty &&
        next != null &&
        _isDigit(previous) &&
        _isDigit(next);
    if (isSpace && !isGroupingSpace) {
      if (word.isNotEmpty) {
        words.add(_TextMotionWord(data.substring(word.first.start, offset), word));
        word = [];
      }
    } else {
      word.add((text: character, start: offset, end: end));
    }
    if (next == null) break;
    offset = end;
    previous = character;
    character = next;
  }
  if (word.isNotEmpty) words.add(_TextMotionWord(data.substring(word.first.start), word));
  return words;
}

class _TextMotionMatching {
  new(List<_TextMotionWord> before, List<_TextMotionWord> after, String decimalSeparator)
    : _targetWordCount = after.length {
    if (before.isEmpty || after.isEmpty) return;
    if (before.length == 1 && after.length == 1 && before.single.numeric == after.single.numeric) {
      _matchWord(before.single, after.single, 0, 0, decimalSeparator);
      return;
    }

    if (_sameWordKeys(before, after)) {
      for (var index = 0; index < before.length; index++) {
        _matchWord(before[index], after[index], index, index, decimalSeparator);
      }
      return;
    }

    final oldKeys = before.map((word) => word.matchKey).toList();
    final newKeys = after.map((word) => word.matchKey).toList();
    final anchors = _sequenceMatches(oldKeys, newKeys);
    final wordMatches = {...anchors};
    final used = anchors.values.toSet();

    // Exact matches outside the ordered anchors can travel across words and lines.
    final unmatchedByKey = <String, List<int>>{};
    for (var oldIndex = before.length - 1; oldIndex >= 0; oldIndex--) {
      if (!used.contains(oldIndex)) (unmatchedByKey[oldKeys[oldIndex]] ??= []).add(oldIndex);
    }
    final unmatchedTargets = <int>[];
    for (var newIndex = 0; newIndex < after.length; newIndex++) {
      if (anchors.containsKey(newIndex)) continue;
      final candidates = unmatchedByKey[newKeys[newIndex]];
      if (candidates == null || candidates.isEmpty) {
        unmatchedTargets.add(newIndex);
        continue;
      }
      final oldIndex = candidates.removeLast();
      wordMatches[newIndex] = oldIndex;
      used.add(oldIndex);
    }

    final unmatchedSources = [
      for (var i = 0; i < before.length; i++)
        if (!used.contains(i)) i,
    ];
    if (unmatchedSources.isNotEmpty &&
        unmatchedTargets.isNotEmpty &&
        unmatchedSources.length * unmatchedTargets.length <= 2500) {
      final oldGaps = _gaps(before.length, anchors.values.toSet());
      final newGaps = _gaps(after.length, anchors.keys.toSet());
      final sourcesByGap = <int, List<int>>{};
      for (final index in unmatchedSources) {
        (sourcesByGap[oldGaps[index]] ??= []).add(index);
      }
      var workRemaining = _maxAffinityWork;
      for (final newIndex in unmatchedTargets) {
        final candidates = sourcesByGap[newGaps[newIndex]];
        if (candidates == null) continue;
        final target = after[newIndex];
        _LcsTarget? masks;
        var bestScore = 0.4;
        int? bestIndex;
        for (var index = 0; index < candidates.length; index++) {
          final source = before[candidates[index]];
          if ((source.numeric || target.numeric) && source.numericSkeleton == target.numericSkeleton) {
            bestIndex = index;
            break;
          }
          final maxLength = math.max(source.units.length, target.units.length);
          if (math.min(source.units.length, target.units.length) / maxLength <= bestScore ||
              source.units.length * target.units.length > _maxLcsCells) {
            continue;
          }
          final work = source.units.length * _LcsTarget.chunkCount(target.units.length);
          if (work > workRemaining) continue;
          workRemaining -= work;
          masks ??= _LcsTarget(target.characters, 0);
          final score = masks.score(source.characters) / maxLength;
          if (score > bestScore) {
            bestScore = score;
            bestIndex = index;
            if (score == 1) break;
          }
        }
        if (bestIndex != null) wordMatches[newIndex] = candidates.removeAt(bestIndex);
      }
    }

    for (final MapEntry(key: newIndex, value: oldIndex) in wordMatches.entries) {
      _matchWord(before[oldIndex], after[newIndex], oldIndex, newIndex, decimalSeparator);
    }
  }

  final int _targetWordCount;
  List<int?>? _wordShifts;
  final sources = <int, int>{};

  int? sourceStartFor(int wordIndex, int targetStart) {
    final shift = _wordShifts?[wordIndex];
    return shift == null ? sources[targetStart] : targetStart + shift;
  }

  final splitSources = <int>{};
  final splitTargets = <int>{};

  // Bound total speculative comparisons before their synchronous UI-frame setup.
  static const _maxAffinityWork = 65536;

  // Every position is an LCS prefix match when all the keys are equal.
  static bool _sameWordKeys(List<_TextMotionWord> before, List<_TextMotionWord> after) {
    if (before.length != after.length) return false;
    for (var index = 0; index < before.length; index++) {
      if (before[index].matchKey != after[index].matchKey) return false;
    }
    return true;
  }

  void _matchWord(_TextMotionWord source, _TextMotionWord target, int oldIndex, int newIndex, String decimalSeparator) {
    if (source.text == target.text) {
      // One UTF-16 displacement covers all units when each is one code unit.
      if (source.units.length == source.text.length && target.units.length == target.text.length) {
        final shifts = _wordShifts ??= List<int?>.filled(_targetWordCount, null);
        shifts[newIndex] = source.units.first.start - target.units.first.start;
        return;
      }
      for (var index = 0; index < target.units.length; index++) {
        sources[target.units[index].start] = source.units[index].start;
      }
      return;
    }
    if (!source.numeric && !target.numeric) {
      splitSources.add(oldIndex);
      splitTargets.add(newIndex);
    }
    if (source.numeric && target.numeric && _matchAlignedNumber(source.units, target.units, decimalSeparator)) return;
    final unitMatches = target.numeric
        ? _numberMatches(source.characters, target.characters, decimalSeparator)
        : _sequenceMatches(source.characters, target.characters);
    for (final MapEntry(key: to, value: from) in unitMatches.entries) {
      sources[target.units[to].start] = source.units[from].start;
    }
  }

  bool _matchAlignedNumber(List<_TextMotionUnit> before, List<_TextMotionUnit> after, String decimalSeparator) {
    if (before.length != after.length) return false;
    // Each digit still has the same place when only digit values changed.
    // Affixes, separators and the decimal pivot keep their original positions.
    for (var index = 0; index < before.length; index++) {
      final source = before[index].text;
      final target = after[index].text;
      if (source == target) continue;
      if (source == decimalSeparator || target == decimalSeparator || !_isDigit(source) || !_isDigit(target)) {
        return false;
      }
    }
    for (var index = 0; index < before.length; index++) {
      final source = before[index];
      final target = after[index];
      if (source.text == target.text) sources[target.start] = source.start;
    }
    return true;
  }

  static List<int> _gaps(int length, Set<int> anchors) {
    var gap = 0;
    return List.generate(length, (index) {
      final previous = gap;
      if (anchors.contains(index)) gap++;
      return previous;
    });
  }

  static Map<int, int> _numberMatches(List<String> before, List<String> after, String decimal) {
    final matches = <int, int>{};
    var start = 0;
    while (start < before.length && start < after.length && before[start] == after[start] && !_isDigit(before[start])) {
      matches[start] = start;
      start++;
    }
    var oldEnd = before.length;
    var newEnd = after.length;
    while (oldEnd > start &&
        newEnd > start &&
        before[oldEnd - 1] == after[newEnd - 1] &&
        !_isDigit(before[oldEnd - 1])) {
      matches[--newEnd] = --oldEnd;
    }

    final oldPivot = _decimalPivot(before, start, oldEnd, decimal);
    final newPivot = _decimalPivot(after, start, newEnd, decimal);
    final oldInteger = _digitIndices(before, start, oldPivot);
    final newInteger = _digitIndices(after, start, newPivot);
    if (oldInteger.isNotEmpty && newInteger.isNotEmpty && (oldInteger.length - newInteger.length).abs() >= 3) {
      return matches;
    }

    var reshaped = false;
    if (oldInteger.length == newInteger.length) {
      _matchPlaces(before, after, oldInteger, newInteger, matches);
    } else {
      final oldDigits = oldInteger.reversed.toList();
      final newDigits = newInteger.reversed.toList();
      final shared = _sequenceMatches(
        [for (final index in oldDigits) before[index]],
        [for (final index in newDigits) after[index]],
      );
      for (final MapEntry(key: to, value: from) in shared.entries) {
        matches[newDigits[to]] = oldDigits[from];
      }
      reshaped = shared.isNotEmpty;
    }

    if (!reshaped) {
      for (var offset = 1; oldPivot - offset >= start && newPivot - offset >= start; offset++) {
        _matchSeparator(before, after, oldPivot - offset, newPivot - offset, matches);
      }
    }
    if (oldPivot < oldEnd && newPivot < newEnd) {
      matches[newPivot] = oldPivot;
      for (var offset = 1; oldPivot + offset < oldEnd && newPivot + offset < newEnd; offset++) {
        _matchSeparator(before, after, oldPivot + offset, newPivot + offset, matches);
      }
      _matchPlaces(
        before,
        after,
        _digitIndices(before, oldPivot + 1, oldEnd),
        _digitIndices(after, newPivot + 1, newEnd),
        matches,
      );
    }
    return matches;
  }

  static int _decimalPivot(List<String> characters, int start, int end, String decimal) {
    for (var index = end - 1; index >= start; index--) {
      if (characters[index] == decimal) return index;
    }
    return end;
  }

  static List<int> _digitIndices(List<String> characters, int start, int end) => [
    for (var index = start; index < end; index++)
      if (_isDigit(characters[index])) index,
  ];

  static void _matchPlaces(
    List<String> before,
    List<String> after,
    List<int> oldPlaces,
    List<int> newPlaces,
    Map<int, int> matches,
  ) {
    for (var index = 0; index < math.min(oldPlaces.length, newPlaces.length); index++) {
      final from = oldPlaces[index];
      final to = newPlaces[index];
      if (before[from] == after[to]) matches[to] = from;
    }
  }

  static void _matchSeparator(List<String> before, List<String> after, int from, int to, Map<int, int> matches) {
    if (!_isDigit(before[from]) && before[from] == after[to]) matches[to] = from;
  }
}

const _maxLcsCells = 1000000;

/// Maps target indices to source indices in their longest common subsequence.
Map<int, int> _sequenceMatches(List<String> before, List<String> after) {
  final length = math.min(before.length, after.length);
  var prefix = 0;
  while (prefix < length && before[prefix] == after[prefix]) {
    prefix++;
  }
  final matches = <int, int>{
    for (var index = 0; index < prefix; index++) index: index,
  };
  if (prefix == length || (before.length - prefix) * (after.length - prefix) > _maxLcsCells) {
    return matches;
  }
  if (before.length - prefix == 1) {
    final to = after.indexOf(before[prefix], prefix);
    if (to >= 0) matches[to] = prefix;
  } else if (after.length - prefix == 1) {
    final from = before.indexOf(after[prefix], prefix);
    if (from >= 0) matches[prefix] = from;
  } else {
    _LcsTarget(after, prefix).match(before, prefix, matches);
  }
  return matches;
}

// Allison and Dix's bit-string LCS stores each row's horizontal increments.
// Keep the rows to recover the ordered match, or one row when scoring candidates.
class _LcsTarget {
  new(List<String> target, int prefix) : _target = target, _chunks = chunkCount(target.length - prefix) {
    if (_chunks == 1) {
      for (var index = prefix; index < target.length; index++) {
        final key = target[index];
        final bit = 1 << (target.length - index - 1);
        _shortMasks[key] = (_shortMasks[key] ?? 0) | bit;
      }
    } else {
      // Store only chunks containing this token. A long target can have mostly
      // unique tokens, so a dense vector per token could consume quadratic space.
      for (var index = target.length - 1; index >= prefix; index--) {
        final bit = target.length - index - 1;
        final chunk = bit ~/ _chunkBits;
        final mask = _wideMasks.putIfAbsent(target[index], () => []);
        final flag = 1 << (bit % _chunkBits);
        if (mask.isEmpty || mask[mask.length - 2] != chunk) {
          mask
            ..add(chunk)
            ..add(flag);
        } else {
          mask[mask.length - 1] |= flag;
        }
      }
    }
  }

  final List<String> _target;
  final int _chunks;
  final _shortMasks = <String, int>{};
  final _wideMasks = <String, List<int>>{};
  late final _scoreRow = Uint32List(_chunks);

  // The carry and subtraction remain immediate integers on 32-bit Dart too.
  static const _chunkBits = 29;
  static const int _chunkMask = (1 << _chunkBits) - 1;

  static int chunkCount(int length) => (length + _chunkBits - 1) ~/ _chunkBits;

  int score(List<String> source) {
    if (_chunks == 1) {
      var row = 0;
      for (var index = source.length - 1; index >= 0; index--) {
        final mask = _shortMasks[source[index]];
        if (mask != null) row = _extendShortRow(row, mask);
      }
      return _popCount(row);
    }
    final row = _scoreRow..fillRange(0, _chunks, 0);
    for (var index = source.length - 1; index >= 0; index--) {
      final mask = _wideMasks[source[index]];
      if (mask != null) _extendRow(row, 0, 0, mask);
    }
    var length = 0;
    for (final bits in row) {
      length += _popCount(bits);
    }
    return length;
  }

  void match(List<String> source, int prefix, Map<int, int> matches) {
    final rows = Uint32List((source.length - prefix + 1) * _chunks);
    for (var index = source.length - 1; index >= prefix; index--) {
      final row = (index - prefix) * _chunks;
      final nextRow = row + _chunks;
      if (_chunks == 1) {
        rows[row] = _extendShortRow(rows[nextRow], _shortMasks[source[index]] ?? 0);
      } else {
        final mask = _wideMasks[source[index]];
        if (mask == null) {
          rows.setRange(row, nextRow, rows, nextRow);
        } else {
          _extendRow(rows, row, nextRow, mask);
        }
      }
    }

    var from = prefix;
    var to = prefix;
    while (from < source.length && to < _target.length) {
      if (source[from] == _target[to]) {
        matches[to++] = from++;
        continue;
      }
      final bit = _target.length - to - 1;
      final chunk = (from - prefix) * _chunks + bit ~/ _chunkBits;
      // If removing the target reduces the LCS length, skip the source.
      // Otherwise prefer advancing the target, as in the original diff.
      if ((rows[chunk] & (1 << (bit % _chunkBits))) != 0) {
        from++;
      } else {
        to++;
      }
    }
  }

  static int _extendShortRow(int row, int mask) {
    final candidates = row | mask;
    return candidates & ~(candidates - ((row << 1) | 1));
  }

  void _extendRow(Uint32List rows, int output, int input, List<int> mask) {
    var carry = 1;
    var borrow = 0;
    var piece = 0;
    var nextChunk = mask[0];
    for (var chunk = 0; chunk < _chunks; chunk++) {
      final previous = rows[input + chunk];
      var candidates = previous;
      if (chunk == nextChunk) {
        candidates |= mask[piece + 1];
        piece += 2;
        nextChunk = piece < mask.length ? mask[piece] : _chunks;
      }
      final shifted = ((previous << 1) | carry) & _chunkMask;
      final difference = candidates - shifted - borrow;
      carry = previous >>> (_chunkBits - 1);
      borrow = difference < 0 ? 1 : 0;
      rows[output + chunk] = candidates & ~difference;
    }
  }

  static int _popCount(int bits) {
    var count = bits - ((bits >>> 1) & 0x55555555);
    count = (count & 0x33333333) + ((count >>> 2) & 0x33333333);
    count = (count + (count >>> 4)) & 0x0f0f0f0f;
    count += count >>> 8;
    return (count + (count >>> 16)) & 0x3f;
  }
}
