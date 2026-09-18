part of 'show_mateo_sheet.dart';

class _MateoSheetStackEntry extends ChangeNotifier {
  _MateoSheetStackEntry({required this.source, required TickerProvider vsync, required bool reducedMotion})
    : _returnController = AnimationController(
        vsync: vsync,
        value: 1,
        duration: reducedMotion ? Duration.zero : const Duration(milliseconds: 440),
      ) {
    _returnController.addListener(changed);
  }

  final MateoSheetSource source;
  final AnimationController _returnController;
  Rect? _returnFrame;
  double _returnDepth = 0;
  double get _returnProgress => Curves.easeOutCubic.transform(_returnController.value);

  void restore() {
    final currentFrame = frame;
    final currentDepth = depth;
    _next?.removeListener(changed);
    _departing?.removeListener(changed);
    _next = null;
    _departing = null;
    _returnFrame = currentFrame;
    _returnDepth = currentDepth;
    _returnController.forward(from: 0);
  }

  _MateoSheetStackEntry? _next;
  _MateoSheetStackEntry? _departing;
  Size _size = Size.zero;
  Size _availableSize = Size.infinite;
  Size get availableSize => _availableSize;
  set availableSize(Size value) {
    if (_availableSize == value) return;
    _availableSize = value;
    changed();
  }

  double progress = 0;
  double dismissProgress = 0;
  bool covered = false;
  bool _disposed = false;
  bool _notificationScheduled = false;

  _MateoSheetStackEntry? get next => _next;
  set next(_MateoSheetStackEntry? value) {
    if (identical(value, _next)) return;
    _departing?.removeListener(changed);
    _departing = value != null && _next != null && _next!.coverage > 0 ? _next : null;
    _next?.removeListener(changed);
    _departing?.addListener(changed);
    _next = value;
    _next?.addListener(changed);
    changed();
  }

  Size get size => _size;

  set size(Size value) {
    if (_size == value) return;
    _size = value;
    changed();
  }

  // Ease the stack into the incoming sheet's travel while retaining its clock
  // and soft landing. Apply drag restoration afterward so it stays direct.
  double get coverage => math.pow(progress, 2.5).toDouble() * (1 - dismissProgress.clamp(0.0, 1.0));

  double get depth {
    final restoringDepth = _returnDepth * (1 - _returnProgress);
    final departingDepth = _departing == null
        ? restoringDepth
        : restoringDepth + _departing!.coverage * (1 + _departing!.depth - restoringDepth);
    final next = _next;
    return next == null ? departingDepth : departingDepth + next.coverage * (1 + next.depth - departingDepth);
  }

  double get opacity => (3 - depth).clamp(0.0, 1.0);

  Rect get frame {
    final natural = Rect.lerp(_returnFrame ?? _restingFrame, _restingFrame, _returnProgress)!;
    return _frameBehind(_next, _frameBehind(_departing, natural));
  }

  // Frames share an origin at the source edge, independently of content size.
  Rect get _restingFrame => switch (source) {
    .bottom => Rect.fromLTWH(0, -_size.height, _size.width, _size.height),
  };

  Rect _coveredFrame(Rect front) {
    switch (source) {
      case .bottom:
        final width = math.max<double>(0, front.width - source._stackCrossAxisInset * 2);
        final top = math.max(-availableSize.height, front.top - source._stackEdgeGap);
        return Rect.fromLTWH((_size.width - width) / 2, top, width, -top);
    }
  }

  Rect _frameBehind(_MateoSheetStackEntry? next, Rect resting) {
    if (next == null || next._size.isEmpty) return resting;
    final covered = _coveredFrame(next.frame);
    return Rect.lerp(resting, covered, next.coverage)!;
  }

  void changed() {
    if (_disposed) return;
    if (_next?.progress == 1 && _departing != null) {
      _departing!.removeListener(changed);
      _departing = null;
    }
    // Geometry is measured during layout; notify widgets after that frame.
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      if (_notificationScheduled) return;
      _notificationScheduled = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _notificationScheduled = false;
        if (!_disposed) notifyListeners();
      });
      return;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _returnController.dispose();
    _departing?.removeListener(changed);
    _next?.removeListener(changed);
    super.dispose();
  }
}
