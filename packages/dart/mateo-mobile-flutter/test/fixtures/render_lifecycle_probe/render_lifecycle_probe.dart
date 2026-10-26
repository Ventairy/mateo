import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

part '_render_lifecycle_probe.dart';

class RenderLifecycleProbe extends SingleChildRenderObjectWidget {
  const RenderLifecycleProbe({required this.onAttach, required this.onDetach, required super.child, super.key});

  final VoidCallback onAttach;
  final VoidCallback onDetach;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderLifecycleProbe(onAttach: onAttach, onDetach: onDetach);
}
