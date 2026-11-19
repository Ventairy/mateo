part of 'mateo_text.dart';

class _MateoTextPresentationScope extends InheritedWidget {
  const new({required this.data, required this.semanticsLabel, required super.child});

  final String data;
  final String? semanticsLabel;

  static _MateoTextPresentationScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MateoTextPresentationScope>()!;

  @override
  bool updateShouldNotify(_MateoTextPresentationScope oldWidget) =>
      data != oldWidget.data || semanticsLabel != oldWidget.semanticsLabel;
}
