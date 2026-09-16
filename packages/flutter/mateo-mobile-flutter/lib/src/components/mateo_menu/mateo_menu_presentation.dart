part of 'mateo_menu_button.dart';

/// The complete visual presentation and opening interaction of a Mateo menu.
@immutable
sealed class MateoMenuPresentation extends StatefulWidget {
  const MateoMenuPresentation._({super.key});

  /// Creates an action menu that transforms its trigger into an expanded surface.
  const factory MateoMenuPresentation.action() = _MateoActionMenuPresentation;

  /// Creates a context menu that opens from the trigger toward the best available edge.
  const factory MateoMenuPresentation.context() = _MateoContextMenuPresentation;

  Color _barrierColor(BuildContext context);

  Duration get _openDuration;
  Duration get _closeDuration;
  Curve get _openCurve;
  Curve get _barrierCurve;

  Widget _buildMenu(_MateoMenuSession session);
  Widget _buildModalBarrier(_MateoMenuRoute route);
}
