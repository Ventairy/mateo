import 'dart:math' as math;

import 'package:flutter/widgets.dart';

part 'presentations/mateo_loading_indicator_presentation.dart';
part '_mateo_loading_indicator_scope.dart';
part 'presentations/_mateo_circular_loading_indicator_presentation.dart';
part 'presentations/_mateo_dots_loading_indicator_presentation.dart';
part '_mateo_circular_loading_indicator_painter.dart';
part '_mateo_dots_loading_indicator_painter.dart';

/// An indication that work with unmeasured progress is continuing.
///
/// Place it beside the content or action that is waiting.
///
/// ```dart
/// MateoLoadingIndicator(presentation: .dots(color: foreground), semanticLabel: 'Saving')
/// ```
///
/// See [loading indicator guidance](https://github.com/Ventairy/mateo/blob/main/design-system/mobile/loading-indicator.md).
class MateoLoadingIndicator extends StatefulWidget {
  /// Creates a loading indicator using [presentation].
  const MateoLoadingIndicator({required this.presentation, this.semanticLabel, super.key});

  /// The visual form and appearance of the activity.
  final MateoLoadingIndicatorPresentation presentation;

  /// The localized description of the work, when context alone is insufficient.
  final String? semanticLabel;

  /// Creates the state coordinating animation eligibility.
  @override
  State<MateoLoadingIndicator> createState() => _MateoLoadingIndicatorState();
}

class _MateoLoadingIndicatorState extends State<MateoLoadingIndicator>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller = AnimationController(vsync: this);
  late bool _active;

  @override
  void initState() {
    super.initState();
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _active = lifecycle == null || lifecycle == .resumed;
    WidgetsBinding.instance.addObserver(this);
  }

  void _synchronizeAnimation() {
    _controller.duration = widget.presentation._duration;
    if (!_active || (MediaQuery.maybeDisableAnimationsOf(context) ?? false) || !TickerMode.valuesOf(context).enabled) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _synchronizeAnimation();
  }

  @override
  void didUpdateWidget(MateoLoadingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.presentation.runtimeType != oldWidget.presentation.runtimeType) _controller.reset();
    _synchronizeAnimation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == .resumed;
    _synchronizeAnimation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _MateoLoadingIndicatorScope(
    progress: (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ? null : _controller,
    semanticLabel: widget.semanticLabel,
    child: widget.presentation,
  );
}
