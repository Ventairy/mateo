import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@internal
abstract interface class MateoSurfaceCaretClient {
  bool get isCaretActive;
  EditableTextState? get caretEditor;
}
