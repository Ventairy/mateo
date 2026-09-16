part of '../mateo_surface.dart';

/// A semantic animation performed by a [MateoSurface].
///
/// Surface animation configuration stays independent from route shells and
/// does not expose the underlying transition engine.
@immutable
final class MateoSurfaceAnimation {
  /// Creates a matched-geometry transition between surfaces sharing [id].
  ///
  /// The departing endpoint supplies [duration] and [curve] when matching
  /// endpoints differ. An omitted [duration] follows the inherited Morph or
  /// route timeline. Differing content crossfades at the transition midpoint.
  const MateoSurfaceAnimation.matchedGeometry({
    required this.id,
    this.target,
    this.duration,
    this.curve,
  });

  /// Stable identifier shared by the matching surface endpoints.
  final Object id;

  /// The appearance shared with siblings that animate beside this surface.
  ///
  /// When supplied, retain this target across rebuilds and pass the same
  /// instance to each associated [MorphSibling]. Its tag must equal [id].
  /// When omitted, the surface owns its target.
  final MorphTarget? target;

  /// Optional independent duration supplied by the departing endpoint.
  final Duration? duration;

  /// Optional curve supplied by the departing endpoint.
  final Curve? curve;
}
