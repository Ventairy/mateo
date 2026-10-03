part of 'show_mateo_sheet.dart';

class _MateoSheetDrag extends StatefulWidget {
  const _MateoSheetDrag({
    required this.child,
    required this.from,
    required this.canStartDrag,
    required this.onDismiss,
    required this.onPositionChanged,
  });

  final Widget child;
  final MateoSheetSource from;
  final bool Function() canStartDrag;
  final FutureOr<bool> Function() onDismiss;
  final void Function(Offset offset, double directionalFraction) onPositionChanged;

  @override
  State<_MateoSheetDrag> createState() => _MateoSheetDragState();
}

class _MateoSheetDragState extends State<_MateoSheetDrag> {
  Offset? _overdrag;
  int? _pointer;

  void _endPointer(PointerEvent event) {
    if (!mounted || _pointer != event.pointer) return;
    _pointer = null;
    setState(() => _overdrag = null);
  }

  void _updateOverdrag(Offset offset) {
    if (!mounted) return;
    setState(() => _overdrag = offset);
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: (event) => _pointer ??= event.pointer,
    onPointerUp: _endPointer,
    onPointerCancel: _endPointer,
    child: InteractiveSwipeDismiss(
      canStartDrag: widget.canStartDrag,
      direction: widget.from._dismissDirection,
      dragConfig: .new(
        dismissFraction: 0.05,
        sensitivity: 1,
        returnCurve: widget.from._curve,
        returnDuration: widget.from._duration,
      ),
      onDismiss: widget.onDismiss,
      onPositionChanged: widget.onPositionChanged,
      onOverdrag: _updateOverdrag,
      child: MateoDragResistance.driven(
        resistance: const .all(6),
        dragOffset: _overdrag,
        child: widget.child,
      ),
    ),
  );
}
