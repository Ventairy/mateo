part of 'mateo_color_scheme.dart';

/// Scrollbar roles for Mateo Mobile scroll surfaces.
///
/// This group exists so scrollbar chrome can be themed independently from
/// general borders or controls while still remaining part of the semantic color
/// contract.
@immutable
class MateoScrollbarColorScheme {
  /// Creates scrollbar roles for Mateo Mobile scroll surfaces.
  const MateoScrollbarColorScheme({
    required this.thumb,
    required this.track,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoScrollbarColorScheme.lerp(
    MateoScrollbarColorScheme a,
    MateoScrollbarColorScheme b,
    double t,
  ) {
    return MateoScrollbarColorScheme(
      thumb: Color.lerp(a.thumb, b.thumb, t)!,
      track: Color.lerp(a.track, b.track, t)!,
    );
  }

  /// Thumb color for the resting scrollbar handle.
  final Color thumb;

  /// Track color behind the scrollbar thumb.
  final Color track;

  /// {@macro mateo_color_scheme_copy_with}
  MateoScrollbarColorScheme copyWith({
    Color? thumb,
    Color? track,
  }) {
    return MateoScrollbarColorScheme(
      thumb: thumb ?? this.thumb,
      track: track ?? this.track,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoScrollbarColorScheme &&
          thumb == other.thumb &&
          track == other.track;

  @override
  int get hashCode => Object.hash(thumb, track);
}
