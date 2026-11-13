import 'package:flutter/widgets.dart';

class SheetLifecycleTestWidget extends StatefulWidget {
  const new({required this.onDeactivate, required this.child, super.key});

  final VoidCallback onDeactivate;
  final Widget child;

  @override
  State<SheetLifecycleTestWidget> createState() => _SheetLifecycleTestWidgetState();
}

class _SheetLifecycleTestWidgetState extends State<SheetLifecycleTestWidget> {
  @override
  void deactivate() {
    widget.onDeactivate();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
