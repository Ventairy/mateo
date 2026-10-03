import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

part '_render_layout_counter.dart';

class LayoutCounter extends SingleChildRenderObjectWidget {
  const LayoutCounter({required this.onLayout, required super.child, super.key});

  final VoidCallback onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderLayoutCounter(onLayout);
}
