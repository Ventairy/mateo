part of 'mateo_text_input.dart';

class _MateoTextInputPresentationScope extends InheritedWidget {
  const _MateoTextInputPresentationScope({
    required this.controller,
    required this.focusNode,
    required this.autofocus,
    required this.placeholder,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required super.child,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback onClear;

  bool get enabled => onChanged != null;

  static _MateoTextInputPresentationScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MateoTextInputPresentationScope>();
    if (scope == null) throw FlutterError('A MateoTextInputPresentation must be mounted by MateoTextInput.');
    return scope;
  }

  @override
  bool updateShouldNotify(_MateoTextInputPresentationScope oldWidget) =>
      controller != oldWidget.controller ||
      focusNode != oldWidget.focusNode ||
      autofocus != oldWidget.autofocus ||
      placeholder != oldWidget.placeholder ||
      onChanged != oldWidget.onChanged ||
      onSubmitted != oldWidget.onSubmitted ||
      onClear != oldWidget.onClear;
}
