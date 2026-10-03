import 'package:flutter/foundation.dart';

import 'mateo_edge_effect_side.dart';
import 'mateo_edge_effect_type.dart';

/// A declaration of a Mateo edge treatment and the sides receiving it.
///
/// This value describes intent; it does not paint an effect. The component
/// interpreting it owns the treatment's sizing, adaptation, and rendering.
///
/// ```dart
/// final effect = MateoEdgeEffect.fade(at: [.top]);
/// ```
@immutable
final class MateoEdgeEffect {
  /// Creates a declaration with no edge treatment and no selected sides.
  const MateoEdgeEffect.none() : type = .none, at = const {};

  /// Creates a fade declaration for [at], defaulting to both vertical sides.
  ///
  /// Copies the selection into an unmodifiable set. Duplicates collapse and
  /// order has no meaning. An explicitly empty selection stays empty.
  /// This constructor is non-const so later input mutations cannot change it.
  MateoEdgeEffect.fade({Iterable<MateoEdgeEffectSide> at = const [.top, .bottom]})
    : type = .fade,
      at = Set.unmodifiable(at);

  /// The treatment selected by the constructor.
  final MateoEdgeEffectType type;

  /// The immutable, unordered set of sides selected for the treatment.
  final Set<MateoEdgeEffectSide> at;

  /// Whether [other] declares the same treatment and unordered side selection.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MateoEdgeEffect && type == other.type && setEquals(at, other.at);

  /// The hash of the treatment and unordered side selection.
  @override
  int get hashCode => Object.hash(type, Object.hashAllUnordered(at));
}
