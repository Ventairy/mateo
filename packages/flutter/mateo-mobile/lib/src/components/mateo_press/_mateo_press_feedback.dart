part of 'mateo_press.dart';

class _MateoPressFeedback extends StatefulWidget {
  const _MateoPressFeedback({required this.animation, required this.type, required this.child});

  final Animation<double> animation;
  final MateoPressAnimationType type;
  final Widget child;

  @override
  State<_MateoPressFeedback> createState() => _MateoPressFeedbackState();
}

class _MateoPressFeedbackState extends State<_MateoPressFeedback> {
  CurvedAnimation? _scaleCurve;
  CurvedAnimation? _opacityCurve;
  Animation<double> _scale = const AlwaysStoppedAnimation(1);
  Animation<double> _opacity = const AlwaysStoppedAnimation(1);

  @override
  void initState() {
    super.initState();
    _configureAnimations();
  }

  @override
  void didUpdateWidget(covariant _MateoPressFeedback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation || widget.type != oldWidget.type) _configureAnimations();
  }

  void _configureAnimations() {
    final type = widget.type;
    _scaleCurve?.dispose();
    _opacityCurve?.dispose();
    _scaleCurve = null;
    _opacityCurve = null;
    _scale = const AlwaysStoppedAnimation(1);
    _opacity = const AlwaysStoppedAnimation(1);

    if (type.pressedScale != 1) {
      _scaleCurve = CurvedAnimation(
        parent: widget.animation,
        curve: type.pressCurve,
        reverseCurve: type.releaseScaleCurve,
      );
      _scale = Tween<double>(begin: 1, end: type.pressedScale).animate(_scaleCurve!);
    }

    if (type.pressedOpacity != 1) {
      _opacityCurve = CurvedAnimation(
        parent: widget.animation,
        curve: type.pressCurve,
        reverseCurve: type.releaseOpacityCurve,
      );
      _opacity = Tween<double>(begin: 1, end: type.pressedOpacity).animate(_opacityCurve!);
    }
  }

  @override
  void dispose() {
    _opacityCurve?.dispose();
    _scaleCurve?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep the child in a stable subtree across style changes. Identity
    // animations retain no opacity layer or active ticker.
    return _MateoPressScale(
      scale: _scale,
      child: _MateoPressFade(opacity: _opacity, child: widget.child),
    );
  }
}
