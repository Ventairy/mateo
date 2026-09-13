part of 'mateo_rounded_convex_evaluator.dart';

// One reusable path workspace per isolate. Its borrowed coordinates are copied
// into an owned Flutter Path before another operation can reuse the workspace.
final class _MateoRoundedConvexNativePath implements ffi.Finalizable {
  _MateoRoundedConvexNativePath() {
    _handle = _mateoPathCreate();
    _count = _mateoAllocate(1, ffi.sizeOf<ffi.Int32>()).cast();
    if (_handle == ffi.nullptr || _count == ffi.nullptr) {
      if (_handle != ffi.nullptr) _mateoPathDestroy(_handle);
      if (_count != ffi.nullptr) _mateoRelease(_count.cast());
      throw StateError('Cannot allocate a native path workspace.');
    }
    _retained = _mateoPathRetainedBytes(_handle);
    try {
      _mateoBufferFinalizer.attach(this, _count.cast(), detach: _countToken, externalSize: 4);
      _finalizer.attach(this, _handle, detach: _handleToken, externalSize: _retained);
    } catch (_) {
      _mateoBufferFinalizer.detach(_countToken);
      _mateoRelease(_count.cast());
      _mateoPathDestroy(_handle);
      rethrow;
    }
  }

  static final shared = _MateoRoundedConvexNativePath();
  static final _finalizer = ffi.NativeFinalizer(ffi.Native.addressOf(_mateoPathDestroy));
  late final ffi.Pointer<ffi.Void> _handle;
  late final ffi.Pointer<ffi.Int32> _count;
  ffi.Pointer<ffi.Double> _input = ffi.nullptr;
  var _capacity = 0;
  late int _retained;
  Object _handleToken = Object();
  final Object _countToken = Object();
  Object _inputToken = Object();

  Path path(Float64List points, Rect rect, {double tolerance = .01}) {
    if (points.length > _capacity) {
      final next = _mateoAllocate(points.length, ffi.sizeOf<ffi.Double>()).cast<ffi.Double>();
      if (next == ffi.nullptr) throw StateError('Cannot allocate native path input.');
      final replacement = Object();
      try {
        _mateoBufferFinalizer.attach(this, next.cast(), detach: replacement, externalSize: points.length * 8);
      } catch (_) {
        _mateoRelease(next.cast());
        rethrow;
      }
      if (_input != ffi.nullptr) {
        _mateoBufferFinalizer.detach(_inputToken);
        _mateoRelease(_input.cast());
      }
      _input = next;
      _capacity = points.length;
      _inputToken = replacement;
    }
    _input.asTypedList(points.length).setAll(0, points);
    return nativePath(_input, points.length ~/ 2, rect, tolerance: tolerance);
  }

  Path nativePath(ffi.Pointer<ffi.Double> points, int count, Rect rect, {double tolerance = .01}) {
    final output = _mateoPathPrepare(
      _handle,
      points,
      count,
      rect.left,
      rect.top,
      rect.width,
      rect.height,
      tolerance,
      _count,
    );
    final actual = _mateoPathRetainedBytes(_handle);
    if (actual != _retained) {
      final replacement = Object();
      _finalizer.attach(this, _handle, detach: replacement, externalSize: actual);
      _finalizer.detach(_handleToken);
      _handleToken = replacement;
      _retained = actual;
    }
    if (output == ffi.nullptr || _count.value < 0) throw StateError('Cannot prepare a native path.');
    final coordinates = output.asTypedList(_count.value * 2);
    return Path()..addPolygon([
      for (var i = 0; i < coordinates.length; i += 2) Offset(coordinates[i], coordinates[i + 1]),
    ], true);
  }
}
