import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mateo_mobile/src/icons/mateo_icons.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile/src/theme/mateo_typography.dart';
import 'package:mateo_mobile/src/widgets/mateo_numeric_keypad/mateo_numeric_keypad_key.dart';
import 'package:mateo_mobile/src/widgets/mateo_numeric_keypad/mateo_numeric_keypad_variant.dart';
import 'package:mateo_mobile/src/widgets/mateo_tap/mateo_tap.dart';
import 'package:mateo_mobile/src/widgets/mateo_text_input/mateo_text_input.dart';

/// A numeric keypad that edits attached text inputs.
///
/// The keypad sends each successful edit directly to the focused controller in
/// [controllers]. When none is focused, the first controller receives focus
/// and the edit. Configure each corresponding [MateoTextInput] with
/// `keyboardType: TextInputType.none` to keep its caret and selection without
/// opening the platform keyboard.
///
/// The configured [variant] owns the key layout, formatting, and editing
/// behavior. [onChanged] receives the complete numeric value, so consumers do
/// not need to parse the controller text.
///
/// ```dart
/// Widget buildKeypad({
///   required MateoTextInputController controller,
///   required MateoNumericKeypadVariant variant,
///   required ValueChanged<double?> onChanged,
/// }) {
///   return MateoNumericKeypad(
///     controllers: [controller],
///     variant: variant,
///     onChanged: onChanged,
///   );
/// }
/// ```
class MateoNumericKeypad extends StatefulWidget {
  /// Creates a numeric keypad that uses [variant] to edit [controllers].
  const MateoNumericKeypad({
    required this.controllers,
    required this.variant,
    super.key,
    this.maxDecimals = 2,
    this.onChanged,
    this.onChangeRejected,
  }) : assert(
         controllers.length > 0,
         'MateoNumericKeypad requires at least one controller.',
       ),
       assert(
         maxDecimals > 0,
         'MateoNumericKeypad maxDecimals must be greater than zero.',
       );

  /// Controllers the keypad can edit, ordered by their fallback priority.
  ///
  /// The focused controller receives edits. When none is focused, the first
  /// controller receives focus and the edit. The consuming application owns
  /// and disposes every controller in this list.
  final List<MateoTextInputController> controllers;

  /// The key layout and editing behavior presented by this keypad.
  final MateoNumericKeypadVariant variant;

  /// The maximum number of digits accepted after the decimal separator.
  final int maxDecimals;

  /// Reports the complete numeric value after each successful edit.
  ///
  /// The callback receives `null` when an edit leaves the active controller
  /// empty. Rejected edits invoke [onChangeRejected] instead.
  final ValueChanged<double?>? onChanged;

  /// Reports that a keypad interaction could not change the active value.
  ///
  /// This callback fires for edits rejected by the configured rules, such as
  /// inserting another decimal separator, exceeding [maxDecimals], or
  /// backspacing when there is nothing before the caret.
  final VoidCallback? onChangeRejected;

  @override
  State<MateoNumericKeypad> createState() => _MateoNumericKeypadState();
}

class _MateoNumericKeypadState extends State<MateoNumericKeypad> {
  static const _numberFontSize = 28.0;
  static const _minimumRowHeight = 72.0;
  static const _keyVerticalPadding = 12.0;
  static const _backspaceIconSize = 22.0;
  static const _backspaceRepeatDelay = Duration(milliseconds: 450);
  static const _backspaceRepeatInterval = Duration(milliseconds: 80);

  final Map<MateoTextInputController, String> _canonicalValues = {};
  final Map<MateoTextInputController, VoidCallback> _controllerListeners = {};
  final Set<MateoTextInputController> _internallyEditedControllers = {};

  late NumberFormat _integerFormat;
  late String _decimalSeparator;
  late String _groupingSeparator;
  late int _localeZeroCodeUnit;
  late int _rightmostGroupingSize;
  late int _repeatingGroupingSize;
  String? _localeName;
  Timer? _backspaceRepeatTimer;
  bool _didRepeatBackspace = false;

  @override
  void initState() {
    super.initState();
    _attachControllerListeners(widget.controllers);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final localeName = Localizations.localeOf(context).toLanguageTag();
    if (_localeName == localeName) return;

    _localeName = localeName;
    _integerFormat = _createIntegerFormat(localeName);
    _decimalSeparator = _integerFormat.symbols.DECIMAL_SEP;
    _groupingSeparator = _integerFormat.symbols.GROUP_SEP;
    _localeZeroCodeUnit = _integerFormat.symbols.ZERO_DIGIT.codeUnitAt(0);

    final groupingSizes = _readGroupingSizes(
      _integerFormat.symbols.DECIMAL_PATTERN,
    );

    _rightmostGroupingSize = groupingSizes.rightmost;
    _repeatingGroupingSize = groupingSizes.repeating;

    for (final controller in widget.controllers) {
      _canonicalValues.putIfAbsent(
        controller,
        () => _parseLocalized(controller.text),
      );
    }
    _scheduleControllerFormatting(widget.controllers);
  }

  @override
  void didUpdateWidget(covariant MateoNumericKeypad oldWidget) {
    super.didUpdateWidget(oldWidget);

    final removedControllers = oldWidget.controllers
        .where((controller) => !widget.controllers.contains(controller))
        .toList();
    final addedControllers = widget.controllers
        .where((controller) => !oldWidget.controllers.contains(controller))
        .toList();

    _detachControllerListeners(removedControllers);
    for (final controller in removedControllers) {
      _canonicalValues.remove(controller);
      _internallyEditedControllers.remove(controller);
    }

    _attachControllerListeners(addedControllers);
    if (_localeName != null) {
      for (final controller in addedControllers) {
        _canonicalValues[controller] = _parseLocalized(controller.text);
      }
      _scheduleControllerFormatting(addedControllers);
    }
  }

  @override
  void dispose() {
    _backspaceRepeatTimer?.cancel();
    _detachControllerListeners(widget.controllers);
    super.dispose();
  }

  NumberFormat _createIntegerFormat(String localeName) {
    final supportedLocale = Intl.verifiedLocale(
      localeName,
      NumberFormat.localeExists,
      onFailure: (_) => 'en_US',
    );
    return NumberFormat.decimalPattern(supportedLocale)
      ..maximumFractionDigits = 0
      ..minimumFractionDigits = 0;
  }

  ({int rightmost, int repeating}) _readGroupingSizes(String pattern) {
    final integerPattern = pattern.split(';').first.split('.').first;
    final separatorIndexes = <int>[];

    for (var index = 0; index < integerPattern.length; index += 1) {
      if (integerPattern[index] == ',') separatorIndexes.add(index);
    }
    if (separatorIndexes.isEmpty) return (rightmost: 0, repeating: 0);

    int countDigitSlots(int start, int end) {
      var count = 0;
      for (var index = start; index < end; index += 1) {
        final character = integerPattern[index];
        if (character == '#' || character == '0') count += 1;
      }
      return count;
    }

    final lastSeparator = separatorIndexes.last;
    final rightmost = countDigitSlots(
      lastSeparator + 1,
      integerPattern.length,
    );
    final repeating = separatorIndexes.length == 1
        ? rightmost
        : countDigitSlots(
            separatorIndexes[separatorIndexes.length - 2] + 1,
            lastSeparator,
          );
    return (rightmost: rightmost, repeating: repeating);
  }

  void _attachControllerListeners(
    Iterable<MateoTextInputController> controllers,
  ) {
    for (final controller in controllers) {
      void listener() => _handleControllerChanged(controller);

      _controllerListeners[controller] = listener;
      controller.addListener(listener);
    }
  }

  void _detachControllerListeners(
    Iterable<MateoTextInputController> controllers,
  ) {
    for (final controller in controllers) {
      final listener = _controllerListeners.remove(controller);
      if (listener != null) controller.removeListener(listener);
    }
  }

  void _handleControllerChanged(MateoTextInputController controller) {
    if (_localeName == null ||
        _internallyEditedControllers.contains(controller)) {
      return;
    }
    _canonicalValues[controller] = _parseLocalized(controller.text);
  }

  void _scheduleControllerFormatting(
    Iterable<MateoTextInputController> controllers,
  ) {
    final controllersToFormat = List.of(controllers);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final controller in controllersToFormat) {
        if (!widget.controllers.contains(controller)) continue;
        final canonical = _canonicalValues[controller] ?? '';
        _writeController(
          controller,
          canonical: canonical,
          canonicalSelection: canonical.length,
        );
      }
    });
  }

  MateoTextInputController get _activeController {
    for (final controller in widget.controllers) {
      if (controller.hasFocus) return controller;
    }

    return widget.controllers.first..focus();
  }

  bool _handleKeyPressed(MateoNumericKeypadKey key) {
    final controller = _activeController;
    final canonical =
        _canonicalValues[controller] ?? _parseLocalized(controller.text);
    final selection = _canonicalSelection(
      controller.value.selection,
      controller.text,
    );
    final editedValue = switch (key) {
      MateoNumericKeypadKey.backspace => _delete(
        canonical,
        selection.start,
        selection.end,
      ),
      MateoNumericKeypadKey.decimalSeparator => _insert(
        canonical,
        selection.start,
        selection.end,
        '.',
      ),
      _ => _insert(
        canonical,
        selection.start,
        selection.end,
        key.rawValue!,
      ),
    };

    if (editedValue == null) return _rejectChange();

    final normalized = _normalizeCanonical(
      editedValue.value,
      editedValue.selection,
    );
    if (!_isWithinDecimalLimit(normalized.value)) return _rejectChange();

    _canonicalValues[controller] = normalized.value;
    _writeController(
      controller,
      canonical: normalized.value,
      canonicalSelection: normalized.selection,
    );
    widget.onChanged?.call(
      normalized.value.isEmpty ? null : double.parse(normalized.value),
    );
    return true;
  }

  bool _rejectChange() {
    widget.onChangeRejected?.call();
    return false;
  }

  void _handleBackspacePressChanged(bool isPressed) {
    if (isPressed) {
      _startBackspaceRepeat();
    } else {
      _stopBackspaceRepeat();
    }
  }

  void _startBackspaceRepeat() {
    _backspaceRepeatTimer?.cancel();
    _didRepeatBackspace = false;
    _backspaceRepeatTimer = Timer(_backspaceRepeatDelay, () {
      if (!_handleKeyPressed(MateoNumericKeypadKey.backspace)) {
        _backspaceRepeatTimer = null;
        return;
      }

      _didRepeatBackspace = true;
      _backspaceRepeatTimer = Timer.periodic(
        _backspaceRepeatInterval,
        (timer) {
          if (_handleKeyPressed(MateoNumericKeypadKey.backspace)) return;
          timer.cancel();
          _backspaceRepeatTimer = null;
        },
      );
    });
  }

  void _stopBackspaceRepeat() {
    _backspaceRepeatTimer?.cancel();
    _backspaceRepeatTimer = null;
    scheduleMicrotask(() => _didRepeatBackspace = false);
  }

  ({int start, int end}) _canonicalSelection(
    TextSelection selection,
    String displayedValue,
  ) {
    if (!selection.isValid) {
      final end = _parseLocalized(displayedValue).length;
      return (start: end, end: end);
    }

    final base = _canonicalOffset(displayedValue, selection.baseOffset);
    final extent = _canonicalOffset(displayedValue, selection.extentOffset);
    return (start: math.min(base, extent), end: math.max(base, extent));
  }

  int _canonicalOffset(String displayedValue, int displayedOffset) {
    var canonicalOffset = 0;
    var index = 0;
    final limit = displayedOffset.clamp(0, displayedValue.length);

    while (index < limit) {
      if (displayedValue.startsWith(_decimalSeparator, index)) {
        canonicalOffset += 1;
        index += _decimalSeparator.length;
        continue;
      }

      final codeUnit = displayedValue.codeUnitAt(index);
      if (_westernDigit(codeUnit) != null ||
          _localizedDigit(codeUnit) != null) {
        canonicalOffset += 1;
      }
      index += 1;
    }
    return canonicalOffset;
  }

  ({String value, int selection})? _insert(
    String canonical,
    int selectionStart,
    int selectionEnd,
    String character,
  ) {
    final value = canonical.replaceRange(
      selectionStart,
      selectionEnd,
      character,
    );
    if (character == '.' && value.indexOf('.') != value.lastIndexOf('.')) {
      return null;
    }

    return (
      value: value,
      selection: selectionStart + character.length,
    );
  }

  ({String value, int selection})? _delete(
    String canonical,
    int selectionStart,
    int selectionEnd,
  ) {
    if (selectionStart != selectionEnd) {
      return (
        value: canonical.replaceRange(selectionStart, selectionEnd, ''),
        selection: selectionStart,
      );
    }
    if (selectionStart == 0) return null;

    return (
      value: canonical.replaceRange(selectionStart - 1, selectionStart, ''),
      selection: selectionStart - 1,
    );
  }

  ({String value, int selection}) _normalizeCanonical(
    String value,
    int selection,
  ) {
    if (value.isEmpty) return (value: '', selection: 0);

    var normalizedSelection = selection;
    final decimalIndex = value.indexOf('.');
    final integerEnd = decimalIndex < 0 ? value.length : decimalIndex;
    var integer = value.substring(0, integerEnd);
    final fraction = decimalIndex < 0
        ? null
        : value.substring(decimalIndex + 1);

    if (integer.isEmpty) {
      integer = '0';
      normalizedSelection += 1;
    }

    final removableZeroes = math.max(0, integer.length - 1);
    var removedZeroes = 0;
    while (removedZeroes < removableZeroes &&
        integer.codeUnitAt(removedZeroes) == 0x30) {
      removedZeroes += 1;
    }
    if (removedZeroes > 0) {
      integer = integer.substring(removedZeroes);
      normalizedSelection = math.max(
        0,
        normalizedSelection - removedZeroes,
      );
    }

    final normalized = fraction == null ? integer : '$integer.$fraction';
    return (
      value: normalized,
      selection: normalizedSelection.clamp(0, normalized.length),
    );
  }

  bool _isWithinDecimalLimit(String canonical) {
    final decimalIndex = canonical.indexOf('.');
    return decimalIndex < 0 ||
        canonical.length - decimalIndex - 1 <= widget.maxDecimals;
  }

  String _parseLocalized(String displayedValue) {
    if (displayedValue.isEmpty) return '';

    final buffer = StringBuffer();
    var sawDecimalSeparator = false;
    var index = 0;

    while (index < displayedValue.length) {
      if (displayedValue.startsWith(_decimalSeparator, index)) {
        if (!sawDecimalSeparator) {
          buffer.write('.');
          sawDecimalSeparator = true;
        }
        index += _decimalSeparator.length;
        continue;
      }
      if (_groupingSeparator.isNotEmpty &&
          displayedValue.startsWith(_groupingSeparator, index)) {
        index += _groupingSeparator.length;
        continue;
      }

      final codeUnit = displayedValue.codeUnitAt(index);
      final digit = _westernDigit(codeUnit) ?? _localizedDigit(codeUnit);
      if (digit != null) buffer.writeCharCode(0x30 + digit);
      index += 1;
    }

    return _normalizeCanonical(buffer.toString(), buffer.length).value;
  }

  int? _westernDigit(int codeUnit) {
    if (codeUnit < 0x30 || codeUnit > 0x39) return null;
    return codeUnit - 0x30;
  }

  int? _localizedDigit(int codeUnit) {
    final digit = codeUnit - _localeZeroCodeUnit;
    return digit >= 0 && digit <= 9 ? digit : null;
  }

  String _formatCanonical(String canonical) {
    if (canonical.isEmpty) return '';

    final decimalIndex = canonical.indexOf('.');
    final integer = decimalIndex < 0
        ? canonical
        : canonical.substring(0, decimalIndex);
    final fraction = decimalIndex < 0
        ? null
        : canonical.substring(decimalIndex + 1);
    final localizedInteger = _groupInteger(integer);

    return fraction == null
        ? localizedInteger
        : '$localizedInteger$_decimalSeparator$fraction';
  }

  String _groupInteger(String integer) {
    if (_rightmostGroupingSize == 0 ||
        integer.length <= _rightmostGroupingSize) {
      return integer;
    }

    final groups = <String>[];
    var end = integer.length;
    var groupSize = _rightmostGroupingSize;
    while (end > 0) {
      final start = math.max(0, end - groupSize);
      groups.add(integer.substring(start, end));
      end = start;
      groupSize = _repeatingGroupingSize;
    }
    return groups.reversed.join(_groupingSeparator);
  }

  void _writeController(
    MateoTextInputController controller, {
    required String canonical,
    required int canonicalSelection,
  }) {
    final displayedValue = _formatCanonical(canonical);
    final displayedSelection = _displayedOffset(
      displayedValue,
      canonicalSelection,
    );
    final nextValue = TextEditingValue(
      text: displayedValue,
      selection: TextSelection.collapsed(offset: displayedSelection),
    );
    if (controller.value == nextValue) return;

    _internallyEditedControllers.add(controller);
    controller.value = nextValue;
    _internallyEditedControllers.remove(controller);
  }

  int _displayedOffset(String displayedValue, int canonicalOffset) {
    if (canonicalOffset <= 0) return 0;

    var semanticCharacters = 0;
    var index = 0;
    while (index < displayedValue.length) {
      if (displayedValue.startsWith(_decimalSeparator, index)) {
        semanticCharacters += 1;
        index += _decimalSeparator.length;
      } else {
        final codeUnit = displayedValue.codeUnitAt(index);
        if (_westernDigit(codeUnit) != null) semanticCharacters += 1;
        index += 1;
      }
      if (semanticCharacters == canonicalOffset) return index;
    }
    return displayedValue.length;
  }

  String _visibleValue(MateoNumericKeypadKey key) {
    return key == MateoNumericKeypadKey.decimalSeparator
        ? _decimalSeparator
        : key.rawValue ?? '';
  }

  String _semanticLabel(
    BuildContext context,
    MateoNumericKeypadKey key,
  ) {
    final localizations = MaterialLocalizations.of(context);
    return switch (key) {
      MateoNumericKeypadKey.backspace => localizations.keyboardKeyBackspace,
      MateoNumericKeypadKey.decimalSeparator =>
        localizations.keyboardKeyNumpadDecimal,
      _ => key.rawValue!,
    };
  }

  Widget _buildKey(BuildContext context, MateoNumericKeypadKey key) {
    final foregroundColor = context.mateo.colorScheme.text.primary;
    final child = key == MateoNumericKeypadKey.backspace
        ? MateoIcon.chevronLeft(
            key: const Key('mateo_numeric_keypad_backspace_icon'),
            width: _backspaceIconSize,
            height: _backspaceIconSize,
            color: foregroundColor,
          )
        : Text(
            _visibleValue(key),
            key: Key('mateo_numeric_keypad_${key.name}_label'),
            style: TextStyle(
              color: foregroundColor,
              fontFamily: MateoTypography.fontFamily,
              fontSize: _numberFontSize,
              fontWeight: FontWeight.w500,
              letterSpacing: MateoTypography.letterSpacing,
            ),
          );

    return Semantics(
      button: true,
      label: _semanticLabel(context, key),
      onTap: () {
        _handleKeyPressed(key);
      },
      child: MateoTap(
        key: Key('mateo_numeric_keypad_${key.name}'),
        animation: MateoTapAnimationType.scale,
        onPressChanged: key == MateoNumericKeypadKey.backspace
            ? _handleBackspacePressChanged
            : null,
        onPressed: (animation) async {
          if (key == MateoNumericKeypadKey.backspace && _didRepeatBackspace) {
            return;
          }
          _handleKeyPressed(key);
        },
        child: Center(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaledTextHeight = MediaQuery.textScalerOf(context).scale(
      _numberFontSize,
    );
    final rowHeight = math.max(
      _minimumRowHeight,
      scaledTextHeight + _keyVerticalPadding * 2,
    );
    final keys = widget.variant.keys;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var row = 0; row < 4; row += 1)
            SizedBox(
              height: rowHeight,
              child: Row(
                children: [
                  for (var column = 0; column < 3; column += 1)
                    Expanded(
                      child: _buildKey(context, keys[row * 3 + column]),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
