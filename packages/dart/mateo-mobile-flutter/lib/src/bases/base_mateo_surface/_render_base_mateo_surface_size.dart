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
    if (_width is MateoSurfaceWidthFill && !constraints.hasBoundedWidth) {
      throw FlutterError(
        'MateoSurfaceWidth.fill() requires a finite parent width. Constrain the width or use .fit() or .custom(...).',
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
        MateoSurfaceWidthFill() => constraints.maxWidth,
        MateoSurfaceWidthCustom(:final value) => value,
      },

      height: switch (_height) {
        MateoSurfaceHeightFit() => null,
        MateoSurfaceHeightFill() => constraints.maxHeight,
        MateoSurfaceHeightCustom(:final value) => value,
      },
    );
  }

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
    _ => super.computeMinIntrinsicHeight(width),
  };

  @override
  double computeMaxIntrinsicHeight(double width) => switch (_height) {
    MateoSurfaceHeightCustom(:final value) => value,
    _ => super.computeMaxIntrinsicHeight(width),
  };
}
