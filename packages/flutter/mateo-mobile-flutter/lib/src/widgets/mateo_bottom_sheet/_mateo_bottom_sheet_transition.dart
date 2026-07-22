part of 'mateo_bottom_sheet.dart';

class _MateoBottomSheetTransition extends SingleChildRenderObjectWidget {
  const _MateoBottomSheetTransition({
    required this.animation,
    required this.isInteractive,
    required super.child,
    super.key,
  });

  final Animation<double> animation;
  final ValueGetter<bool> isInteractive;

  @override
  _RenderMateoBottomSheetTransition createRenderObject(BuildContext context) {
    return _RenderMateoBottomSheetTransition(animation, isInteractive);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMateoBottomSheetTransition renderObject,
  ) {
    renderObject
      ..animation = animation
      ..isInteractive = isInteractive;
  }
}
