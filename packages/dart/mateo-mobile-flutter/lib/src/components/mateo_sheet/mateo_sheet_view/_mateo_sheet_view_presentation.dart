part of '../show_mateo_sheet.dart';

class _MateoSheetViewPresentation extends StatefulWidget {
  const new({
    required this.stackEntry,
    required this.color,
    required this.dimColor,
    required this.child,
  });

  final _MateoSheetStackEntry stackEntry;
  final Color color;
  final Color dimColor;
  final Widget child;

  @override
  State<_MateoSheetViewPresentation> createState() => _MateoSheetViewPresentationState();
}

class _MateoSheetViewPresentationState extends State<_MateoSheetViewPresentation> {
  final _contentFocusNode = FocusNode(canRequestFocus: false, skipTraversal: true);
  late double _opacity;
  late bool _covered;

  @override
  void initState() {
    super.initState();
    _readPresentation();
    widget.stackEntry.addListener(_handleStackChange);
  }

  @override
  void didUpdateWidget(_MateoSheetViewPresentation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.stackEntry, widget.stackEntry)) {
      _readPresentation();
      return;
    }
    oldWidget.stackEntry.removeListener(_handleStackChange);
    _readPresentation();
    widget.stackEntry.addListener(_handleStackChange);
  }

  void _readPresentation() {
    _opacity = widget.stackEntry.opacity;
    _covered = widget.stackEntry.covered;
    _contentFocusNode.descendantsAreFocusable = !_covered;
  }

  void _handleStackChange() {
    final opacity = widget.stackEntry.opacity;
    final covered = widget.stackEntry.covered;
    if (_opacity == opacity && _covered == covered) return;
    // Re-enable focus during the pop, before the previous input disconnects.
    if (!covered) _contentFocusNode.descendantsAreFocusable = true;
    setState(() {
      _opacity = opacity;
      _covered = covered;
    });
  }

  @override
  Widget build(BuildContext context) {
    _contentFocusNode.descendantsAreFocusable = !_covered;
    return Opacity(
      opacity: _opacity,
      child: ExcludeSemantics(
        excluding: _covered,
        child: Focus.withExternalFocusNode(
          focusNode: _contentFocusNode,
          includeSemantics: false,
          child: IgnorePointer(
            ignoring: _covered,
            child: _MateoSheetFrame(
              stackEntry: widget.stackEntry,
              color: widget.color,
              dimColor: widget.dimColor,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.stackEntry.removeListener(_handleStackChange);
    _contentFocusNode.dispose();
    super.dispose();
  }
}
