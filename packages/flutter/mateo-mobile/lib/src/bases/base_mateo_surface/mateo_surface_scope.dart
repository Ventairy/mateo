import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';
import '../../foundation/mateo_surface_animation/mateo_surface_animation.dart';

@internal
class MateoSurfaceScope extends InheritedWidget {
  const MateoSurfaceScope({required super.child, this.animation = const .none(), this.shape, super.key});

  final MateoSurfaceAnimation animation;
  final MateoRoundedShapeBorder? shape;

  static ({MateoSurfaceAnimation animation, MateoRoundedShapeBorder? shape}) of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MateoSurfaceScope>();
    return (animation: scope?.animation ?? const .none(), shape: scope?.shape);
  }

  @override
  bool updateShouldNotify(MateoSurfaceScope oldWidget) => animation != oldWidget.animation || shape != oldWidget.shape;
}
