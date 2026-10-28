part of 'base_mateo_surface.dart';

class _RenderBaseMateoSurfaceSize extends RenderProxyBox {
  _RenderBaseMateoSurfaceSize({required this._width, required this._height});

  MateoSurfaceWidth _width;
  MateoSurfaceWidth get width => _width;
  set width(MateoSurfaceWidth value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  MateoSurfaceHeight _height;
  MateoSurfaceHeight get height => _height;

  set height(MateoSurfaceHeight value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  BoxConstraints _childConstraints(BoxConstraints constraints) {
    if (_width case MateoSurfaceWidthFill(maxWidth: null) when !constraints.hasBoundedWidth) {
      throw FlutterError(
        'MateoSurfaceWidth.fill() requires a finite parent width or maxWidth. Constrain the width, supply maxWidth, or use .fit() or .custom(...).',
      );
    }
    if (_height is MateoSurfaceHeightFill && !constraints.hasBoundedHeight) {
      throw FlutterError(
        'MateoSurfaceHeight.fill() requires a finite parent height. Constrain the height or use .fit() or .custom(...).',
      );
    }
    return constraints.tighten(
      width: switch (_width) {
        MateoSurfaceWidthFit() => null,
        MateoSurfaceWidthFill(:final maxWidth) =>
          maxWidth == null ? constraints.maxWidth : constraints.constrainWidth(maxWidth),
        MateoSurfaceWidthCustom(:final value) => value,
      },

      height: switch (_height) {
        MateoSurfaceHeightFit() => null,
        MateoSurfaceHeightFill() => constraints.maxHeight,
        MateoSurfaceHeightCustom(:final value) => value,
      },
    );
  }

  double _intrinsicChildWidth(double availableWidth) => switch (_width) {
    MateoSurfaceWidthFit() => availableWidth,
    MateoSurfaceWidthFill(:final maxWidth) =>
      maxWidth == null ? availableWidth : availableWidth.clamp(0, maxWidth).toDouble(),
    MateoSurfaceWidthCustom(:final value) => value.clamp(0, availableWidth).toDouble(),
  };

  @override
  Size computeDryLayout(BoxConstraints constraints) => child!.getDryLayout(_childConstraints(constraints));

  @override
  double? computeDryBaseline(BoxConstraints constraints, TextBaseline baseline) =>
      child!.getDryBaseline(_childConstraints(constraints), baseline);

  @override
  void performLayout() {
    child!.layout(_childConstraints(constraints), parentUsesSize: true);
    size = child!.size;
  }

  @override
  double computeMinIntrinsicWidth(double height) => switch (_width) {
    MateoSurfaceWidthCustom(:final value) => value,
    _ => super.computeMinIntrinsicWidth(height),
  };

  @override
  double computeMaxIntrinsicWidth(double height) => switch (_width) {
    MateoSurfaceWidthCustom(:final value) => value,
    _ => super.computeMaxIntrinsicWidth(height),
  };

  @override
  double computeMinIntrinsicHeight(double width) => switch (_height) {
    MateoSurfaceHeightCustom(:final value) => value,
    MateoSurfaceHeightFit() || MateoSurfaceHeightFill() => super.computeMinIntrinsicHeight(_intrinsicChildWidth(width)),
  };

  @override
  double computeMaxIntrinsicHeight(double width) => switch (_height) {
    MateoSurfaceHeightCustom(:final value) => value,
    MateoSurfaceHeightFit() || MateoSurfaceHeightFill() => super.computeMaxIntrinsicHeight(_intrinsicChildWidth(width)),
  };
}
