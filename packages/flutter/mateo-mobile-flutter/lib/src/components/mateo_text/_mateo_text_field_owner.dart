part of 'mateo_text_field.dart';

abstract interface class _MateoTextFieldOwner {
  MateoTextField get input;
  MateoTextController get textController;
  bool get hasText;
  bool get hasFocus;

  void clear();
}
