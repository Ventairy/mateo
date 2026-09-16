part of 'mateo_color_scheme.dart';

/// Semantic colors for one Mateo menu presentation.
@immutable
class MateoMenuColorScheme {
  /// Creates the complete color contract for one menu.
  const MateoMenuColorScheme({
    required this.background,
    required this.title,
    required this.titleDisabled,
    required this.description,
    required this.descriptionDisabled,
    required this.icon,
    required this.iconDisabled,
    required this.scrim,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoMenuColorScheme.lerp(
    MateoMenuColorScheme a,
    MateoMenuColorScheme b,
    double t,
  ) => MateoMenuColorScheme(
    background: Color.lerp(a.background, b.background, t)!,
    title: Color.lerp(a.title, b.title, t)!,
    titleDisabled: Color.lerp(a.titleDisabled, b.titleDisabled, t)!,
    description: Color.lerp(a.description, b.description, t)!,
    descriptionDisabled: Color.lerp(a.descriptionDisabled, b.descriptionDisabled, t)!,
    icon: Color.lerp(a.icon, b.icon, t)!,
    iconDisabled: Color.lerp(a.iconDisabled, b.iconDisabled, t)!,
    scrim: Color.lerp(a.scrim, b.scrim, t)!,
  );

  /// Menu surface color.
  final Color background;

  /// Enabled item-title color.
  final Color title;

  /// Disabled item-title color.
  final Color titleDisabled;

  /// Enabled item-description color.
  final Color description;

  /// Disabled item-description color.
  final Color descriptionDisabled;

  /// Recommended enabled item-icon color.
  final Color icon;

  /// Recommended disabled item-icon color.
  final Color iconDisabled;

  /// Modal barrier color shown behind the menu.
  final Color scrim;

  /// {@macro mateo_color_scheme_copy_with}
  MateoMenuColorScheme copyWith({
    Color? background,
    Color? title,
    Color? titleDisabled,
    Color? description,
    Color? descriptionDisabled,
    Color? icon,
    Color? iconDisabled,
    Color? scrim,
  }) => MateoMenuColorScheme(
    background: background ?? this.background,
    title: title ?? this.title,
    titleDisabled: titleDisabled ?? this.titleDisabled,
    description: description ?? this.description,
    descriptionDisabled: descriptionDisabled ?? this.descriptionDisabled,
    icon: icon ?? this.icon,
    iconDisabled: iconDisabled ?? this.iconDisabled,
    scrim: scrim ?? this.scrim,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoMenuColorScheme &&
          background == other.background &&
          title == other.title &&
          titleDisabled == other.titleDisabled &&
          description == other.description &&
          descriptionDisabled == other.descriptionDisabled &&
          icon == other.icon &&
          iconDisabled == other.iconDisabled &&
          scrim == other.scrim;

  @override
  int get hashCode => Object.hash(
    background,
    title,
    titleDisabled,
    description,
    descriptionDisabled,
    icon,
    iconDisabled,
    scrim,
  );
}
