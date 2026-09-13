part of 'mateo_rounded_convex_evaluator.dart';

// Native handles own copied numeric inputs. Painting consumes borrowed output
// synchronously, while a retained border captures its exact coordinates lazily.
final class _MateoNativeKernel implements ffi.Finalizable {
  _MateoNativeKernel.rounded(
    MateoRoundedConvexDescription a,
    MateoRoundedConvexDescription b,
    MateoRoundedConvexEndpoint pa,
    MateoRoundedConvexEndpoint pb,
  ) : this._(a, b, pa, pb, true);

  _MateoNativeKernel.physical(
    MateoRoundedConvexDescription a,
    MateoRoundedConvexDescription b,
    MateoRoundedConvexEndpoint pa,
    MateoRoundedConvexEndpoint pb,
  ) : this._(a, b, pa, pb, false);

  _MateoNativeKernel._(
    MateoRoundedConvexDescription a,
    MateoRoundedConvexDescription b,
    MateoRoundedConvexEndpoint pa,
    MateoRoundedConvexEndpoint pb,
    this.roundsCorners,
  ) {
    final allocations = <ffi.Pointer<ffi.Void>>[];
    ffi.Pointer<ffi.Double> allocate(int count) {
      final pointer = _mateoAllocate(count, ffi.sizeOf<ffi.Double>());
      if (pointer == ffi.nullptr) throw StateError('Native allocation failed.');
      allocations.add(pointer);
      return pointer.cast();
    }

    ffi.Pointer<ffi.Double> describe(MateoRoundedConvexDescription d) {
      if (d.turns.length != 512 || d.speeds.length != 512 || d.spacings.length != 256) {
        throw ArgumentError('A prepared contour needs 512 intervals and 256 locations.');
      }
      final pointer = allocate(1283);
      pointer.asTypedList(1283)
        ..[0] = d.width
        ..[1] = d.height
        ..[2] = d.angle
        ..setRange(3, 515, d.turns)
        ..setRange(515, 1027, d.speeds)
        ..setRange(1027, 1283, d.spacings);
      return pointer;
    }

    ffi.Pointer<ffi.Double> outline(MateoRoundedConvexEndpoint endpoint) {
      final pointer = allocate(endpoint.points.length * 2);
      final values = pointer.asTypedList(endpoint.points.length * 2);
      for (var i = 0; i < endpoint.points.length; i++) {
        values[2 * i] = endpoint.points[i].dx;
        values[2 * i + 1] = endpoint.points[i].dy;
      }
      return pointer;
    }

    try {
      final da = roundsCorners ? describe(a) : ffi.nullptr.cast<ffi.Double>();
      final db = roundsCorners ? describe(b) : ffi.nullptr.cast<ffi.Double>();
      final ea = outline(pa);
      final eb = outline(pb);
      _count = _mateoAllocate(1, ffi.sizeOf<ffi.Int32>()).cast();
      if (_count == ffi.nullptr) throw StateError('Native allocation failed.');
      _handle = roundsCorners
          ? _mateoCreateChecked(
              da,
              1283,
              db,
              1283,
              ea,
              pa.points.length,
              pa.points.length * 2,
              eb,
              pb.points.length,
              pb.points.length * 2,
              1,
            )
          : _mateoCreatePhysicalChecked(
              a.width,
              a.height,
              b.width,
              b.height,
              ea,
              pa.points.length,
              pa.points.length * 2,
              eb,
              pb.points.length,
              pb.points.length * 2,
            );
      if (_handle == ffi.nullptr) {
        _mateoRelease(_count.cast());
        throw StateError(_errorMessage());
      }
      _attach();
    } finally {
      allocations.forEach(_mateoRelease);
    }
  }

  _MateoNativeKernel._fromHandle(this._handle, this.roundsCorners) {
    _count = _mateoAllocate(1, ffi.sizeOf<ffi.Int32>()).cast();
    if (_count == ffi.nullptr) {
      _mateoDestroy(_handle);
      throw StateError('Native allocation failed.');
    }
    _attach();
  }

  void _attach() {
    retainedBytes = _mateoRetainedBytes(_handle);
    try {
      _mateoBufferFinalizer.attach(this, _count.cast(), detach: _countToken, externalSize: 4);
      _finalizer.attach(this, _handle, detach: _kernelToken, externalSize: retainedBytes);
    } catch (_) {
      _mateoBufferFinalizer.detach(_countToken);
      _mateoRelease(_count.cast());
      _mateoDestroy(_handle);
      rethrow;
    }
  }

  // This creates an independent owner and output buffer. The native gate
  // declines reuse for dimensions or movement maps outside the audited range.
  _MateoNativeKernel? reversed() {
    final handle = _mateoReverse(_handle);
    if (handle == ffi.nullptr) return null;
    return _MateoNativeKernel._fromHandle(handle, roundsCorners);
  }

  static final _finalizer = ffi.NativeFinalizer(ffi.Native.addressOf(_mateoDestroy));
  final bool roundsCorners;
  late int retainedBytes;
  late final ffi.Pointer<ffi.Void> _handle;
  late final ffi.Pointer<ffi.Int32> _count;
  Object _kernelToken = Object();
  final Object _countToken = Object();
  double? _lastProgress;
  ffi.Pointer<ffi.Double>? _lastFrame;
  int _lastFrameCount = 0;

  static String _errorMessage() {
    final bytes = _mateoError();
    final result = <int>[];
    for (var i = 0; i < 512 && bytes[i] != 0; i++) {
      result.add(bytes[i]);
    }
    return String.fromCharCodes(result);
  }

  void _refreshRetainedBytes() {
    final actual = _mateoRetainedBytes(_handle);
    if (actual == retainedBytes) return;
    // Register the replacement first so failed accounting leaves destruction
    // registered. Finalizable keeps this owner alive until this call returns.
    final replacement = Object();
    _finalizer.attach(this, _handle, detach: replacement, externalSize: actual);
    _finalizer.detach(_kernelToken);
    _kernelToken = replacement;
    retainedBytes = actual;
    _preparedPairs.trim();
  }

  ffi.Pointer<ffi.Double> _readFrame(double t) {
    if (t == _lastProgress) return _lastFrame!;
    // A failed native call may also have reused its output storage.
    _lastProgress = null;
    _lastFrame = null;
    _lastFrameCount = 0;
    final pointer = _mateoFrame(_handle, t, _count);
    _refreshRetainedBytes();
    if (pointer == ffi.nullptr || _count.value < 3) throw StateError(_errorMessage());
    _lastProgress = t;
    _lastFrame = pointer;
    _lastFrameCount = _count.value;
    return pointer;
  }

  Float64List frame(double t) {
    final pointer = _readFrame(t);
    return Float64List.fromList(pointer.asTypedList(_lastFrameCount * 2));
  }

  Path framePath(double t, Rect rect) {
    return _MateoRoundedConvexNativePath.shared.nativePath(
      _readFrame(t),
      _lastFrameCount,
      rect,
      tolerance: roundsCorners ? .01 : 0,
    );
  }

  ({Float64List points, Path path}) frameWithPath(double t, Rect rect) {
    final pointer = _readFrame(t);
    final path = _MateoRoundedConvexNativePath.shared.nativePath(
      pointer,
      _lastFrameCount,
      rect,
      tolerance: roundsCorners ? .01 : 0,
    );
    return (points: Float64List.fromList(pointer.asTypedList(_lastFrameCount * 2)), path: path);
  }
}
