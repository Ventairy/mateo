part of '../mateo_text_input_purpose.dart';

final class _CodeTextInputFormatter extends TextInputFormatter {
  const _CodeTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;
    final normalizedText = newValue.text.replaceAll(' ', '').toUpperCase();
    if (normalizedText == newValue.text) return newValue;

    int normalizedOffset(int offset) =>
        offset < 0 ? offset : newValue.text.substring(0, offset).replaceAll(' ', '').toUpperCase().length;

    return newValue.copyWith(
      text: normalizedText,
      selection: newValue.selection.copyWith(
        baseOffset: normalizedOffset(newValue.selection.baseOffset),
        extentOffset: normalizedOffset(newValue.selection.extentOffset),
      ),
      composing: newValue.composing.isValid
          ? TextRange.collapsed(normalizedOffset(newValue.composing.start))
          : newValue.composing,
    );
  }
}
