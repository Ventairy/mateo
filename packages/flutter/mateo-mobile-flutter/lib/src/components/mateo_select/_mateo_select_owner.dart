part of 'mateo_select.dart';

abstract interface class _MateoSelectOwner {
  List<MateoSelectOption<dynamic>> get presentationOptions;
  Object? get selectedValue;
  MateoSelectOption<dynamic> get selectedOption;
  ValueChanged<Future<void>> commitSelection(MateoSelectOption<dynamic> option);
}
