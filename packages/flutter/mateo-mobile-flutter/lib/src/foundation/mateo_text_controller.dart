import 'package:flutter/widgets.dart';

/// A controller for reading, editing, and focusing Mateo text inputs.
///
/// Create one controller for each input and dispose it when the owning widget
/// is removed.
///
/// ```dart
/// final controller = MateoTextController(text: 'Initial value');
///
/// controller.focus();
/// controller.clear();
/// controller.dispose();
/// ```
class MateoTextController extends TextEditingController {
  /// Creates a controller with optional initial [text].
  MateoTextController({super.text}) {
    focusNode.addListener(_notifyFocusChanged);
  }

  /// Focus node paired with this text controller.
  final FocusNode focusNode = FocusNode();

  /// Whether the input currently has keyboard focus.
  bool get hasFocus => focusNode.hasFocus;

  /// Requests keyboard focus for the input.
  void focus() => focusNode.requestFocus();

  /// Removes keyboard focus from the input.
  void unfocus() => focusNode.unfocus();

  void _notifyFocusChanged() => notifyListeners();

  /// Releases the text and focus resources owned by this controller.
  @override
  void dispose() {
    focusNode
      ..removeListener(_notifyFocusChanged)
      ..dispose();
    super.dispose();
  }
}
