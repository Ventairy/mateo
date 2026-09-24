import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@internal
class MateoMenuPopOverlayScope extends InheritedWidget {
  const MateoMenuPopOverlayScope({required super.child, super.key});

  static bool exists(BuildContext context) => context.getInheritedWidgetOfExactType<MateoMenuPopOverlayScope>() != null;

  @override
  bool updateShouldNotify(MateoMenuPopOverlayScope oldWidget) => false;
}
