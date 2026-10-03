part of 'base_mateo_view.dart';

class _ConditionalSurfaceBackground extends StatefulWidget {
  const _ConditionalSurfaceBackground({
    required this.listenable,
    required this.isVisible,
    required this.child,
  });

  final Listenable listenable;
  final bool Function() isVisible;
  final Widget child;

  @override
  State<_ConditionalSurfaceBackground> createState() => _ConditionalSurfaceBackgroundState();
}

class _ConditionalSurfaceBackgroundState extends State<_ConditionalSurfaceBackground> {
  late bool _visible;

  @override
  void initState() {
    super.initState();
    _visible = widget.isVisible();
    widget.listenable.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(_ConditionalSurfaceBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.listenable, widget.listenable)) {
      oldWidget.listenable.removeListener(_handleChange);
      widget.listenable.addListener(_handleChange);
    }
    _visible = widget.isVisible();
  }

  void _handleChange() {
    final visible = widget.isVisible();
    if (_visible == visible) return;
    setState(() => _visible = visible);
  }

  @override
  Widget build(BuildContext context) => _visible ? widget.child : const SizedBox.expand();

  @override
  void dispose() {
    widget.listenable.removeListener(_handleChange);
    super.dispose();
  }
}
