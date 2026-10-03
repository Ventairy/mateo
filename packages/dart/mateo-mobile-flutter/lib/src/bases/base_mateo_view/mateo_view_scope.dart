import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@internal
class MateoViewScope extends InheritedWidget {
  const MateoViewScope({required super.child, this.padding, super.key});

  final EdgeInsetsGeometry? padding;

  static EdgeInsetsGeometry? paddingOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MateoViewScope>()?.padding;

  @override
  bool updateShouldNotify(MateoViewScope oldWidget) => padding != oldWidget.padding;
}
