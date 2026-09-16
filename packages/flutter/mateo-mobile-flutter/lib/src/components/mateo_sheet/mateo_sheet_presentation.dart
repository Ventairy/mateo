part of 'mateo_sheet.dart';

/// The layout, drag behavior, and motion of a Mateo sheet.
///
/// Use [MateoSheetPresentation.bottom] for content anchored to the bottom of
/// the current navigator. Presentations can be reused across sheet openings.
@immutable
sealed class MateoSheetPresentation extends StatefulWidget {
  const MateoSheetPresentation._({super.key});

  const factory MateoSheetPresentation.bottom({
    bool draggable,
    bool resistance,
    bool avoidKeyboardInset,
    Key? key,
  }) = _MateoBottomSheetPresentation;

  bool get draggable;
  bool get resistance;
  bool get avoidKeyboardInset;

  Duration get _morphDuration;
  Duration get _entranceDuration;
  Duration get _dismissDuration;
  Curve get _settleCurve;
  Curve _stackExitCurve(bool interactive);
  Curve get _stackReturnCurve;
  Curve get _barrierCurve;
  Color _scrim(BuildContext context);

  Widget _build(_MateoSheetRoute<dynamic> route);
  Widget _buildModalBarrier(_MateoSheetRoute<dynamic> route);
}
