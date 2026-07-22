library;

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';

part 'mateo_radar_pulse_step.dart';
part 'mateo_radar_pulse_painter.dart';

/// A pulse of expanding rings that emanate from behind a child widget.
///
/// `MateoRadarPulse` wraps [child] and draws a continuous sequence of translucent
/// rings that start at the child's size and expand outward to [maxScale]× while
/// fading. The rings are drawn behind the child, so the child always sits on
/// top of the pulse — the pulse appears to come from behind the child. The
/// widget does not paint any background of its own; the child is in charge of
/// its own opacity.
///
/// The widget sizes itself to the [child] (layout is transparent to the child),
/// and the rings overflow visually via `Clip.none`. The pulse respects
/// [MediaQuery.disableAnimationsOf] and renders a static snapshot when reduced
/// motion is enabled.
///
/// When placed inside a keep-alive list item that scrolls off-screen, the pulse
/// continues animating until the item is disposed. Avoid wrapping [MateoRadarPulse] in
/// [AutomaticKeepAlive] for off-screen items, or pause it manually, to save
/// CPU/GPU on low-end devices.
///
/// ```dart
/// MateoRadarPulse(
///   child: Icon(Icons.bolt_rounded, size: 48, color: Colors.white),
/// )
/// ```
///
/// To customize the per-ring appearance, pass [steps] with custom
/// [MateoRadarPulseStep.color], [MateoRadarPulseStep.borderRadius], and [MateoRadarPulseStep.alpha]
/// values:
///
/// ```dart
/// MateoRadarPulse(
///   steps: const [
///     MateoRadarPulseStep(color: Color(0xFF4A5CFF), alpha: 0.6),
///     MateoRadarPulseStep(color: Color(0xFF00A896), alpha: 0.2),
///   ],
///   child: Icon(Icons.bolt_rounded, size: 48, color: Colors.white),
/// )
/// ```
class MateoRadarPulse extends StatefulWidget {
  /// Creates a Mateo Mobile pulse widget around [child].
  ///
  /// Requires at least one [steps] entry (enforced by `assert` in debug mode).
  /// [maxScale] must be greater than `1.0` so the rings can expand beyond the
  /// child bounds.
  const MateoRadarPulse({
    required this.child,
    super.key,
    this.steps = const [MateoRadarPulseStep(), MateoRadarPulseStep()],
    this.duration = const Duration(milliseconds: 1600),
    this.maxScale = 1.5,
  }) : assert(
         steps.length > 0,
         'MateoRadarPulse requires at least one step, but steps is empty.',
       ),
       assert(
         maxScale > 1,
         'maxScale must be greater than 1.0 so the pulse can expand beyond the child.',
       );

  /// The widget rendered at the center of the pulse.
  ///
  /// The widget sizes itself to this child; the expanding rings are drawn
  /// around the child's edges and overflow beyond its bounds.
  final Widget child;

  /// Visual layers for the pulse sequence.
  ///
  /// The number of rings equals the length of this list. Each ring uses the
  /// corresponding step's [MateoRadarPulseStep.color] (or the theme primary when
  /// `null`) and [MateoRadarPulseStep.borderRadius]. Rings are drawn behind the child
  /// and are staggered in time so a ripple effect is always visible.
  final List<MateoRadarPulseStep> steps;

  /// Duration of one full pulse cycle.
  final Duration duration;

  /// Maximum scale of each expanding ring relative to the child size.
  ///
  /// Must be greater than `1.0`. At this scale the ring reaches its largest
  /// extent and its alpha reaches zero (fully transparent). Defaults to `1.5`.
  final double maxScale;

  @override
  State<MateoRadarPulse> createState() => _MateoRadarPulseState();
}

class _MateoRadarPulseState extends State<MateoRadarPulse>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _syncControllerState();
  }

  @override
  void didUpdateWidget(covariant MateoRadarPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      _syncControllerState();
    }
  }

  void _syncControllerState() {
    final disabled = MediaQuery.disableAnimationsOf(context);

    if (disabled) {
      if (_controller.isAnimating) _controller.stop();
    } else if (!_controller.isAnimating) {
      unawaited(_controller.repeat());
    }
  }

  Widget _buildRings(
    Color primary, {
    required bool animated,
    required double progress,
    Widget? staticChild,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _RadarPulseRingPainter(
                steps: widget.steps,
                progress: progress,
                animated: animated,
                maxScale: widget.maxScale,
                primary: primary,
              ),
            ),
          ),
        ),
        staticChild ?? RepaintBoundary(child: widget.child),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.mateo.palette.primary[9];
    final disabled = MediaQuery.disableAnimationsOf(context);

    if (disabled) return _buildRings(primary, animated: false, progress: 0);

    return AnimatedBuilder(
      animation: _controller,
      child: RepaintBoundary(child: widget.child),
      builder: (context, staticChild) => _buildRings(
        primary,
        animated: true,
        progress: _controller.value,
        staticChild: staticChild,
      ),
    );
  }
}
