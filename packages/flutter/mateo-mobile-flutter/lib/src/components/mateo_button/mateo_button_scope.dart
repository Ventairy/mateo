part of 'mateo_button.dart';

@internal
final class MateoButtonScope extends InheritedWidget {
  const MateoButtonScope({
    required this.backgroundBuilder,
    required super.child,
    super.key,
  });

  final Widget Function(MateoButtonState state, Widget child) backgroundBuilder;

  static MateoButtonScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MateoButtonScope>();

  @override
  bool updateShouldNotify(MateoButtonScope oldWidget) => !identical(backgroundBuilder, oldWidget.backgroundBuilder);
}
