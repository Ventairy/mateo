part of 'mateo_select.dart';

/// The visual treatment of a Mateo selection control.
///
/// The presentation owns the closed control's colors. Its expanded menu uses
/// the shared theme menu colors independently of this presentation.
@immutable
sealed class MateoSelectPresentation extends StatefulWidget {
  const MateoSelectPresentation._({super.key});

  /// Creates a select with a subtle gray background.
  const factory MateoSelectPresentation.neutral({MateoSelectVariantColorScheme? colorScheme}) =
      _MateoNeutralSelectPresentation;

  /// Creates a select with a transparent background.
  const factory MateoSelectPresentation.ghost({MateoSelectVariantColorScheme? colorScheme}) =
      _MateoGhostSelectPresentation;

  /// Optional complete color override for the closed control.
  MateoSelectVariantColorScheme? get colorScheme;
}
