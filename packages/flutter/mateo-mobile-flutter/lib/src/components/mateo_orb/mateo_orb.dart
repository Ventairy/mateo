import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mateo_mobile_old/src/components/mateo_orb/mateo_orb_color_scheme.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';

part '_mateo_orb_painter.dart';

/// A softly lit circular orb with fluid, smoke-like shading.
///
/// [MateoOrb] provides a generic visual that can stand in for a profile image
/// or add an ambient focal point to a composition. Its surface combines
/// directional sphere lighting with a procedural fluid field.
///
/// When [animate] is `false`, the orb holds a deterministic resting frame.
/// When animation is enabled, the fluid field drifts continuously without a
/// visible repeating boundary. System reduced-motion settings keep the current
/// frame still.
///
/// When [size] is omitted, the orb uses the largest circle permitted by its
/// parent. If neither axis is bounded, it uses a 48 logical-pixel fallback.
///
/// ```dart
/// const MateoOrb(size: 48)
/// ```
class MateoOrb extends StatefulWidget {
  /// Creates a softly lit circular orb.
  ///
  /// The optional [size] is the orb diameter in logical pixels. It must be
  /// finite and non-negative when supplied. When omitted, the parent
  /// constraints determine the diameter.
  ///
  /// The optional [colorScheme] replaces both orb colors. When omitted, the
  /// active Mateo palette supplies accent step 9 for the surface and neutral
  /// step 1 for the vapor.
  const MateoOrb({
    super.key,
    this.size,
    this.colorScheme,
    this.animate = false,
  }) : assert(
         size == null || (size >= 0 && size < double.infinity),
         'size must be finite and non-negative, but got $size.',
       );

  static const double _fallbackSize = 48;
  static const Duration _timeSegmentDuration = Duration(seconds: 1);
  static const String _shaderAsset = 'packages/mateo_mobile_old/shaders/mateo_orb.frag';
  static const String _localShaderAsset = 'shaders/mateo_orb.frag';

  /// The optional diameter of the orb in logical pixels.
  ///
  /// When omitted, the largest bounded parent dimension that keeps the orb
  /// circular is used. If both dimensions are unbounded, the orb uses 48
  /// logical pixels.
  final double? size;

  /// Complete color scheme used by this orb.
  ///
  /// When omitted, the active Mateo palette supplies the surface and vapor
  /// colors.
  final MateoOrbColorScheme? colorScheme;

  /// Whether the fluid shading moves continuously.
  ///
  /// Defaults to `false`. System reduced-motion settings, an inactive app, or
  /// a disabled [TickerMode] pause motion while preserving the visible phase.
  final bool animate;

  /// The mutable state that owns the shader and fluid animation.
  @override
  State<MateoOrb> createState() => _MateoOrbState();
}

class _MateoOrbState extends State<MateoOrb> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static ui.FragmentProgram? _program;
  static var _didReportShaderLoadError = false;

  late final AnimationController _controller;
  late bool _applicationIsActive;
  ui.FragmentShader? _shader;
  var _previousControllerValue = 0.0;
  var _completedTimeSegments = 0;

  double get _elapsedSeconds => _completedTimeSegments + _controller.value;

  @override
  void initState() {
    super.initState();

    final initialLifecycleState = WidgetsBinding.instance.lifecycleState;
    _applicationIsActive = initialLifecycleState == null || initialLifecycleState == AppLifecycleState.resumed;

    _controller = AnimationController(
      vsync: this,
      duration: MateoOrb._timeSegmentDuration,
    )..addListener(_trackContinuousTime);

    WidgetsBinding.instance.addObserver(this);
    unawaited(_loadShader());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _synchronizeAnimation();
  }

  @override
  void didUpdateWidget(covariant MateoOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate) _synchronizeAnimation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _applicationIsActive = false;
        _controller.stop();
      case AppLifecycleState.resumed:
        _applicationIsActive = true;
        _synchronizeAnimation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _shader?.dispose();
    super.dispose();
  }

  Future<void> _loadShader() async {
    try {
      final program = _program ?? await _loadProgram();
      _program ??= program;
      if (!mounted) return;

      setState(() => _shader = program.fragmentShader());
    } catch (error, stackTrace) {
      if (_didReportShaderLoadError) return;
      _didReportShaderLoadError = true;
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'mateo_mobile_old',
          context: ErrorDescription(
            'while loading the MateoOrb fragment shader',
          ),
        ),
      );
    }
  }

  static Future<ui.FragmentProgram> _loadProgram() async {
    try {
      return await ui.FragmentProgram.fromAsset(MateoOrb._shaderAsset);
    } on Exception {
      return ui.FragmentProgram.fromAsset(MateoOrb._localShaderAsset);
    }
  }

  void _trackContinuousTime() {
    final currentValue = _controller.value;
    if (currentValue < _previousControllerValue) {
      _completedTimeSegments++;
    }
    _previousControllerValue = currentValue;
  }

  void _synchronizeAnimation() {
    final shouldAnimate =
        widget.animate &&
        _applicationIsActive &&
        !MediaQuery.disableAnimationsOf(context) &&
        TickerMode.valuesOf(context).enabled;

    if (!shouldAnimate) {
      _controller.stop();
      return;
    }

    if (!_controller.isAnimating) _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.mateo.palette;
    final colorScheme =
        widget.colorScheme ??
        MateoOrbColorScheme(
          background: palette.accent[9],
          smoke: palette.neutral[1],
        );
    final painter = _MateoOrbPainter(
      background: colorScheme.background,
      smoke: colorScheme.smoke,
      shader: _shader,
      time: _controller,
      timeInSeconds: () => _elapsedSeconds,
    );
    final paintedOrb = RepaintBoundary(
      child: CustomPaint(painter: painter),
    );

    return _buildLayout(paintedOrb);
  }

  Widget _buildLayout(Widget child) {
    final requestedSize = widget.size;
    if (requestedSize != null) return _buildSizedOrb(requestedSize, child);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth ? constraints.maxWidth : double.infinity;
        final height = constraints.hasBoundedHeight ? constraints.maxHeight : double.infinity;
        final availableSize = math.min(width, height);
        final resolvedSize = availableSize.isFinite ? availableSize : MateoOrb._fallbackSize;

        return _buildSizedOrb(resolvedSize, child);
      },
    );
  }

  Widget _buildSizedOrb(double size, Widget child) {
    return Align(
      widthFactor: 1,
      heightFactor: 1,
      child: SizedBox.square(dimension: size, child: child),
    );
  }
}
