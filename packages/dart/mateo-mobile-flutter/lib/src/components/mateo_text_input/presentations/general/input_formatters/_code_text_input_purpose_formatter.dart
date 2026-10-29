part of '../mateo_text_input_purpose.dart';

final class _CodeTextInputFormatter extends TextInputFormatter {
  const _CodeTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;
    final uppercaseText = newValue.text.toUpperCase();
    if (uppercaseText == newValue.text) return newValue;

    int uppercaseOffset(int offset) => offset < 0 ? offset : newValue.text.substring(0, offset).toUpperCase().length;

    return newValue.copyWith(
      text: uppercaseText,
      selection: newValue.selection.copyWith(
        baseOffset: uppercaseOffset(newValue.selection.baseOffset),
        extentOffset: uppercaseOffset(newValue.selection.extentOffset),
      ),
      composing: newValue.composing.isValid
          ? TextRange.collapsed(uppercaseOffset(newValue.composing.start))
          : newValue.composing,
    );
  }
}
