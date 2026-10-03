part of '../../../../show_mateo_sheet.dart';

class _MateoHandleSheetViewHeaderPresentation extends MateoSheetViewHeaderPresentation {
  const _MateoHandleSheetViewHeaderPresentation() : super._();

  @override
  Widget build(BuildContext context) => InteractiveSwipeDismissHandle(
    child: BaseMateoViewHeader(
      principal: Center(
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: MateoTheme.of(context).colorScheme.sheet.handle,
            shape: const MateoRoundedShapeBorder.capsule(),
          ),
          child: const SizedBox(width: 50, height: 7),
        ),
      ),
    ),
  );
}
