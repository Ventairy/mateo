part of 'mateo_edge_fade.dart';

/// The visual configuration of a single Mateo Mobile edge-fade gradient.
///
/// When [color] is `null` it resolves to `context.mateo.colors.background` at build time;
/// when [height] is `null` it resolves to a fraction of the viewport height.
///
/// See also:
///  * [MateoEdgeFade], the widget that renders this style.
@immutable
class MateoEdgeFadeStyle {
  /// Creates a Mateo Mobile edge-fade style.
  const MateoEdgeFadeStyle({this.color, this.height});

  /// Solid color the gradient fades from.
  ///
  /// When `null`, resolves to `context.mateo.colors.background` at build time.
  final Color? color;

  /// Height of the fade band, in logical pixels.
  ///
  /// When `null`, resolves to `1/7` of the device viewport height
  final double? height;

  static const double _defaultHeightFactor = 1 / 7;
  static const double _defaultMinHeight = 72;
  static const double _defaultMaxHeight = 120;

  /// Resolves `null` fields against [context], returning a fully concrete
  /// style. Used by [MateoEdgeFade] and by the hero flight shuttle so that
  /// runtime theme + viewport values are pinned before interpolation.
  MateoEdgeFadeStyle resolve(BuildContext context) {
    return MateoEdgeFadeStyle(
      color: color ?? Theme.of(context).scaffoldBackgroundColor,
      height:
          height ??
          (MediaQuery.sizeOf(context).height * _defaultHeightFactor).clamp(
            _defaultMinHeight,
            _defaultMaxHeight,
          ),
    );
  }

  /// Linearly interpolates between two styles.
  ///
  /// Both [a] and [b] must already be resolved (non-null `color`/`height`) —
  /// call [resolve] first. When either side is `null`, the other side wins
  /// (used by callers that treat an absent edge as a zero-height style).
  static MateoEdgeFadeStyle? lerp(
    MateoEdgeFadeStyle? a,
    MateoEdgeFadeStyle? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;

    return MateoEdgeFadeStyle(
      color: Color.lerp(a.color, b.color, t),
      height: lerpDouble(a.height, b.height, t),
    );
  }

  MateoEdgeFadeStyle copyWith({Color? color, double? height}) {
    return MateoEdgeFadeStyle(
      color: color ?? this.color,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MateoEdgeFadeStyle &&
      other.color == color &&
      other.height == height;

  @override
  int get hashCode => Object.hash(color, height);
}
