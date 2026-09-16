part of 'mateo_color_scheme.dart';

/// Semantic colors for the two Mateo menu presentations.
@immutable
class MateoMenusColorScheme {
  /// Creates semantic colors for action and context menus.
  const MateoMenusColorScheme({required this.action, required this.context});

  /// Interpolates both menu presentation color schemes.
  factory MateoMenusColorScheme.lerp(MateoMenusColorScheme a, MateoMenusColorScheme b, double t) =>
      MateoMenusColorScheme(
        action: MateoMenuColorScheme.lerp(a.action, b.action, t),
        context: MateoMenuColorScheme.lerp(a.context, b.context, t),
      );

  /// Colors used by an action menu.
  final MateoMenuColorScheme action;

  /// Colors used by a context menu.
  final MateoMenuColorScheme context;

  /// Returns a copy with the supplied presentation schemes replaced.
  MateoMenusColorScheme copyWith({MateoMenuColorScheme? action, MateoMenuColorScheme? context}) =>
      MateoMenusColorScheme(
        action: action ?? this.action,
        context: context ?? this.context,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MateoMenusColorScheme && action == other.action && context == other.context;

  @override
  int get hashCode => Object.hash(action, context);
}
