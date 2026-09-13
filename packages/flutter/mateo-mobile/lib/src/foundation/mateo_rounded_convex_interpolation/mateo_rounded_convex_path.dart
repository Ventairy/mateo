import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart' show internal;

/// Removes only native rounding dents from an already convex frame polygon.
///
/// This is not a validator or a repair path for concave input borders. Input
/// borders are validated before interpolation, in endpoint preparation.
@internal
final class MateoRoundedConvexPathBuilder {
  Float32List _input = Float32List(0);
  Float32List _output = Float32List(0);
  Uint32List _indices = Uint32List(0);
  final Float32List _arithmetic = Float32List(6);

  /// Native vertices, borrowed until the next call on this builder.
  Float32List prepare(Float64List points, Rect rect) {
    if (_input.length < points.length) {
      _input = Float32List(points.length);
      _output = Float32List(points.length);
      _indices = Uint32List(points.length ~/ 2 + 1);
    }
    var start = 0;
    for (var i = 0; i < points.length; i += 2) {
      _input[i] = rect.left + (points[i] + .5) * rect.width;
      _input[i + 1] = rect.top + (points[i + 1] + .5) * rect.height;
      if (_input[i] < _input[start] || (_input[i] == _input[start] && _input[i + 1] < _input[start + 1])) start = i;
    }
    final count = points.length ~/ 2;
    var retained = 0;
    for (var j = 0; j <= count; j++) {
      final index = (start + 2 * j) % points.length;
      if (retained > 0 && _same(_indices[retained - 1], index)) continue;
      // The input is cyclically ordered and convex before rounding. Starting
      // at a support extreme lets a single Graham scan remove rounding dents
      // and redundant straight vertices without sorting or another curve fit.
      while (retained >= 2 && _cross(_indices[retained - 2], _indices[retained - 1], index) <= 0) {
        retained--;
      }
      _indices[retained++] = index;
    }
    if (retained > 1 && _same(_indices[retained - 1], _indices[0])) retained--;
    for (var i = 0; i < retained; i++) {
      final index = _indices[i];
      _output[2 * i] = _input[index];
      _output[2 * i + 1] = _input[index + 1];
    }
    return Float32List.sublistView(_output, 0, retained * 2);
  }

  bool _same(int a, int b) => _input[a] == _input[b] && _input[a + 1] == _input[b + 1];

  double _cross(int a, int b, int c) {
    final ax = _input[b] - _input[a];
    final ay = _input[b + 1] - _input[a + 1];
    final bx = _input[c] - _input[b];
    final by = _input[c + 1] - _input[b + 1];
    _arithmetic[0] = ax;
    _arithmetic[1] = ay;
    _arithmetic[2] = bx;
    _arithmetic[3] = by;
    _arithmetic[4] = _arithmetic[0] * _arithmetic[3];
    _arithmetic[5] = _arithmetic[1] * _arithmetic[2];
    final first = _arithmetic[4];
    final second = _arithmetic[5];
    // Very small or large paths still need representable geometry when later
    // requested at ordinary bounds; binary32 cross products can under/overflow.
    if (!first.isFinite || !second.isFinite || (first == 0 && ax * by != 0) || (second == 0 && ay * bx != 0)) {
      return ax * by - ay * bx;
    }
    _arithmetic[4] = first - second;
    return _arithmetic[4];
  }
}
