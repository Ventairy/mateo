part of '../mateo_menu.dart';

/// The content and appearance mounted by a Mateo menu.
@immutable
sealed class MateoMenuPresentation extends StatelessWidget {
  const MateoMenuPresentation._({required this.width, required this.density});

  /// Creates a list of options with a nonempty snapshot of [items].
  factory MateoMenuPresentation.options({
    required List<MateoMenuOptionsPresentationItem> items,
    MateoMenuDensity density,
    MateoMenuWidth width,
  }) = _MateoMenuOptionsPresentation;

  /// The horizontal sizing of the menu.
  final MateoMenuWidth width;

  /// The coordinated spacing of the menu.
  final MateoMenuDensity density;
}
