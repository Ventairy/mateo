part of 'mateo_select.dart';

/// An option displayed by a [MateoSelect].
///
/// The [value] identifies this option across rebuilds. [iconBuilder] and
/// [title] form the always-visible content, while [description] adds supporting
/// text only in the open menu. [title] must not be empty; when
/// supplied, [description] must not be empty either.
@immutable
class MateoSelectOption<T> {
  /// Creates an option for a Mateo selection control.
  const MateoSelectOption({
    required this.value,
    required this.title,
    required this.iconBuilder,
    this.description,
  }) : assert(
         title != '',
         'MateoSelectOption requires a non-empty title.',
       ),
       assert(
         description == null || description != '',
         'MateoSelectOption description must be null or non-empty.',
       );

  /// Stable value that identifies this option under `==`.
  final T value;

  /// Non-empty visible title and accessibility label for this option.
  final String title;

  /// Optional non-empty supporting text shown beneath [title] in the open menu.
  final String? description;

  /// Builder for the complete icon visual in the current select presentation.
  ///
  /// The select may invoke this builder for its closed face, open row, and
  /// animated flight. Build declaratively and avoid side effects.
  final MateoSelectIconBuilder iconBuilder;
}
