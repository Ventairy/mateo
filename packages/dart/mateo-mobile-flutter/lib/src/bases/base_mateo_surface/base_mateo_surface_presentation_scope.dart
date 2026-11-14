import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@internal
class BaseMateoSurfacePresentationScope extends InheritedWidget {
  const new({required this.position, required super.child, super.key});

  final Animation<Offset> position;

  static Matrix4 settledTransformToScreen({required BuildContext context, required RenderBox viewport}) {
    final transform = viewport.getTransformTo(null);
    final element = context.getElementForInheritedWidgetOfExactType<BaseMateoSurfacePresentationScope>();
    if (element == null) return transform;
    final presentation = element.widget as BaseMateoSurfacePresentationScope;
    final bounds = element.findRenderObject();
    if (bounds is! RenderBox || !bounds.attached || !bounds.hasSize) return transform;
    final displacement = presentation.position.value.scale(bounds.size.width, bounds.size.height);
    final presentationToScreen = bounds.getTransformTo(null);
    final screenDisplacement =
        MatrixUtils.transformPoint(presentationToScreen, displacement) -
        MatrixUtils.transformPoint(presentationToScreen, Offset.zero);
    // Caret layout follows the resting surface, independently of its entrance.
    transform.storage[12] -= screenDisplacement.dx;
    transform.storage[13] -= screenDisplacement.dy;
    return transform;
  }

  @override
  bool updateShouldNotify(BaseMateoSurfacePresentationScope oldWidget) => position != oldWidget.position;
}
