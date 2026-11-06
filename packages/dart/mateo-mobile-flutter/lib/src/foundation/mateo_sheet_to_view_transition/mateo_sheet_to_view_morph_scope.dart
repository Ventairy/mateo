import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@internal
class MateoSheetToViewMorphScope extends InheritedWidget {
  const new({required super.child, super.key});

  static bool isPresent(BuildContext context) =>
      context.getElementForInheritedWidgetOfExactType<MateoSheetToViewMorphScope>() != null;

  @override
  bool updateShouldNotify(MateoSheetToViewMorphScope oldWidget) => false;
}
