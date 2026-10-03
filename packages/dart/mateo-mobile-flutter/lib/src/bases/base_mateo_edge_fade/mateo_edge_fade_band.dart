import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'mateo_edge_fade_profile.dart';

@internal
@immutable
class MateoEdgeFadeBand {
  MateoEdgeFadeBand.top({required this.extent, required this.profile}) : edge = .up {
    _validateExtent();
  }

  MateoEdgeFadeBand.bottom({required this.extent, required this.profile}) : edge = .down {
    _validateExtent();
  }

  MateoEdgeFadeBand.left({required this.extent, required this.profile}) : edge = .left {
    _validateExtent();
  }

  MateoEdgeFadeBand.right({required this.extent, required this.profile}) : edge = .right {
    _validateExtent();
  }

  final double extent;
  final MateoEdgeFadeProfile profile;
  final AxisDirection edge;

  void _validateExtent() {
    if (!extent.isFinite || extent < 0) {
      throw ArgumentError.value(extent, 'extent', 'Must be finite and nonnegative.');
    }
  }
}
