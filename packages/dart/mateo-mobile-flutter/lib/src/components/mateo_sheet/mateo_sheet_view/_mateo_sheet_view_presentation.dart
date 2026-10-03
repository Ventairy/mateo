part of '../show_mateo_sheet.dart';

class _MateoSheetViewPresentation extends StatefulWidget {
  const _MateoSheetViewPresentation({
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
  }

  void _handleStackChange() {
    final opacity = widget.stackEntry.opacity;
    final covered = widget.stackEntry.covered;
    if (_opacity == opacity && _covered == covered) return;
    setState(() {
      _opacity = opacity;
      _covered = covered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity,
      child: ExcludeSemantics(
        excluding: _covered,
        child: ExcludeFocus(
          excluding: _covered,
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
    super.dispose();
  }
}
