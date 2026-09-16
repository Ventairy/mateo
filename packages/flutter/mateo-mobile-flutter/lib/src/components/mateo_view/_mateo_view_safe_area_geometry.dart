part of '../mateo_view.dart';

@immutable
final class _MateoViewSafeAreaInputs {
  const _MateoViewSafeAreaInputs({
    required this.viewSize,
    required this.padding,
    required this.viewPadding,
    required this.viewInsets,
  });

  final Size viewSize;
  final EdgeInsets padding;
  final EdgeInsets viewPadding;
  final EdgeInsets viewInsets;

  EdgeInsets get availableInsets {
    return EdgeInsets.only(
      top: math.min(padding.top, viewPadding.top),
      bottom: math.min(
        padding.bottom,
        math.max(0, viewPadding.bottom - viewInsets.bottom),
      ),
    );
  }

  bool hasSameTopGeometryAs(_MateoViewSafeAreaInputs other) {
    return viewSize == other.viewSize && padding.top == other.padding.top && viewPadding.top == other.viewPadding.top;
  }

  bool hasSameBottomGeometryAs(_MateoViewSafeAreaInputs other) {
    return viewSize == other.viewSize &&
        padding.bottom == other.padding.bottom &&
        viewPadding.bottom == other.viewPadding.bottom &&
        viewInsets.bottom == other.viewInsets.bottom;
  }

  @override
  bool operator ==(Object other) {
    return other is _MateoViewSafeAreaInputs &&
        other.viewSize == viewSize &&
        other.padding == padding &&
        other.viewPadding == viewPadding &&
        other.viewInsets == viewInsets;
  }

  @override
  int get hashCode => Object.hash(
    viewSize,
    padding,
    viewPadding,
    viewInsets,
  );
}

final class _MateoViewSafeAreaGeometry {
  const _MateoViewSafeAreaGeometry({
    required this.inputs,
    required this.viewBounds,
    required this.insets,
    required this.bottomKeyboardInset,
  });

  factory _MateoViewSafeAreaGeometry.resolve({
    required _MateoViewSafeAreaInputs inputs,
    required Rect viewBounds,
  }) {
    final availableInsets = inputs.availableInsets;
    final intersectsViewHorizontally = viewBounds.right > 0 && viewBounds.left < inputs.viewSize.width;
    final top = intersectsViewHorizontally
        ? _minimumOverlap(
            minimum: viewBounds.top,
            maximum: viewBounds.bottom,
            safeMinimum: availableInsets.top,
          )
        : 0.0;
    final bottom = intersectsViewHorizontally
        ? _maximumOverlap(
            minimum: viewBounds.top,
            maximum: viewBounds.bottom,
            viewMaximum: inputs.viewSize.height,
            safeMaximum: inputs.viewSize.height - availableInsets.bottom,
          )
        : 0.0;
    final bottomKeyboardInset = intersectsViewHorizontally
        ? _maximumOverlap(
            minimum: viewBounds.top,
            maximum: viewBounds.bottom,
            viewMaximum: inputs.viewSize.height,
            safeMaximum: inputs.viewSize.height - inputs.viewInsets.bottom,
          )
        : 0.0;
    return _MateoViewSafeAreaGeometry(
      inputs: inputs,
      viewBounds: viewBounds,
      insets: EdgeInsets.only(top: top, bottom: bottom),
      bottomKeyboardInset: bottomKeyboardInset,
    );
  }

  final _MateoViewSafeAreaInputs inputs;
  final Rect viewBounds;
  final EdgeInsets insets;
  final double bottomKeyboardInset;

  static double _minimumOverlap({
    required double minimum,
    required double maximum,
    required double safeMinimum,
  }) {
    if (safeMinimum <= 0 || minimum >= safeMinimum || maximum <= 0) return 0;
    if (minimum < 0) return safeMinimum;
    return safeMinimum - minimum;
  }

  static double _maximumOverlap({
    required double minimum,
    required double maximum,
    required double viewMaximum,
    required double safeMaximum,
  }) {
    if (safeMaximum >= viewMaximum || maximum <= safeMaximum || minimum >= viewMaximum) return 0;
    if (maximum > viewMaximum) return viewMaximum - safeMaximum;
    return maximum - safeMaximum;
  }
}
