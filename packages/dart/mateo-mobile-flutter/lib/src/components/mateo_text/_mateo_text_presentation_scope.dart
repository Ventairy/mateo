part of 'mateo_text.dart';

class _MateoTextPresentationScope extends InheritedWidget {
  const _MateoTextPresentationScope({required this.text, required super.child});

  final MateoText text;

  static MateoText of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MateoTextPresentationScope>()!.text;

  @override
  bool updateShouldNotify(_MateoTextPresentationScope oldWidget) => text != oldWidget.text;
}
