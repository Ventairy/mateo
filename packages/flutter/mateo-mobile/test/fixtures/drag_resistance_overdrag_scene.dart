import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

class DragResistanceOverdragScene extends StatefulWidget {
  const DragResistanceOverdragScene({required this.onDismiss, this.scrollController, super.key});

  final VoidCallback onDismiss;
  final ScrollController? scrollController;

  @override
  State<DragResistanceOverdragScene> createState() => _DragResistanceOverdragSceneState();
}

class _DragResistanceOverdragSceneState extends State<DragResistanceOverdragScene> {
  Offset? _overdrag;
  int? _pointer;

  void _endPointer(PointerEvent event) {
    if (event.pointer != _pointer) return;
    _pointer = null;
    // The outer listener runs after the inner gesture owner's terminal zero.
    // Both updates reach the driven widget in a single build.
    setState(() => _overdrag = null);
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: (event) => _pointer ??= event.pointer,
    onPointerUp: _endPointer,
    onPointerCancel: _endPointer,
    child: InteractiveSwipeDismiss(
      onOverdrag: (offset) => setState(() => _overdrag = offset),
      onDismiss: () {
        widget.onDismiss();
        return false;
      },
      child: MateoDragResistance.driven(
        resistance: const .only(top: 6, left: 6, right: 6),
        dragOffset: _overdrag,
        child: SizedBox(
          key: const ValueKey('overdrag-content'),
          width: 200,
          height: 300,
          child: widget.scrollController == null
              ? ColoredBox(
                  color: MateoThemeData.light(
                    accentColor: const Color(0xFF4A5CFF),
                    onAccent: MateoPalette().white,
                  ).colorScheme.accent,
                )
              : ListView(
                  controller: widget.scrollController,
                  children: const [SizedBox(height: 900)],
                ),
        ),
      ),
    ),
  );
}
