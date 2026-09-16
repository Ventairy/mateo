part of 'mateo_text_field.dart';

class _MateoTextControllerOwner {
  _MateoTextControllerOwner({MateoTextController? controller})
    : controller = controller ?? MateoTextController(),
      _ownsController = controller == null;

  MateoTextController controller;
  bool _ownsController;

  void updateController(MateoTextController? suppliedController) {
    if (suppliedController == controller || (suppliedController == null && _ownsController)) return;

    if (_ownsController) controller.dispose();
    controller = suppliedController ?? MateoTextController();
    _ownsController = suppliedController == null;
  }

  void dispose() {
    if (_ownsController) controller.dispose();
  }
}
