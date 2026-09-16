import 'package:flutter/foundation.dart';

@internal
@immutable
class MateoEdgeFadeProfile {
  MateoEdgeFadeProfile({required List<double> stops, required List<double> visibility})
    : stops = List.unmodifiable(stops),
      visibility = List.unmodifiable(visibility) {
    if (this.stops.length < 2 || this.stops.length != this.visibility.length) {
      throw ArgumentError('Stops and visibility must have matching lengths of at least two.');
    }
    if (this.stops.first != 0 || this.stops.last != 1) {
      throw ArgumentError('Stops must begin at zero and end at one.');
    }
    for (var index = 0; index < this.stops.length; index++) {
      final stop = this.stops[index];
      final value = this.visibility[index];
      if (!stop.isFinite || stop < 0 || stop > 1 || (index > 0 && stop <= this.stops[index - 1])) {
        throw ArgumentError('Stops must be finite and strictly increasing within zero and one.');
      }
      if (!value.isFinite || value < 0 || value > 1) {
        throw ArgumentError('Visibility must be finite and within zero and one.');
      }
    }
  }

  final List<double> stops;
  final List<double> visibility;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoEdgeFadeProfile && listEquals(stops, other.stops) && listEquals(visibility, other.visibility);

  @override
  int get hashCode => Object.hash(Object.hashAll(stops), Object.hashAll(visibility));
}
