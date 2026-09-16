/// @docImport '../mateo_surface.dart';
library;

import 'package:flutter/material.dart';
import 'package:mateo_mobile_old/src/components/mateo_tap/mateo_tap.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile_old/src/theme/mateo_typography.dart';

part 'mateo_grouped_list_row.dart';
part 'mateo_grouped_list_types.dart';

/// A static list that presents related rows on one rounded surface.
///
/// [MateoGroupedList] accepts a complete, intentionally compact set of
/// [children] and sizes itself to their combined height. It does not own a
/// scrolling viewport or incremental-loading behavior. Place it in a scrolling
/// parent, such as a scrollable [MateoSurface], when the surrounding screen
/// should scroll. This component is not intended for very long collections.
///
/// The consumer owns when children are added, replaced, or removed. The grouped
/// list owns only its rounded surface, dividers, and row presentation.
///
/// ```dart
/// MateoGroupedList(
///   children: [
///     for (final place in places)
///       MateoGroupedListRow(
///         leading: PlaceIcon(place: place),
///         title: place.name,
///         description: place.neighborhood,
///       ),
///   ],
/// )
/// ```
///
/// See also:
///  * [MateoGroupedListRow], the row shape accepted by [children].
class MateoGroupedList extends StatelessWidget {
  /// Creates a static list of grouped rows.
  ///
  /// The [children] are displayed in order.
  const MateoGroupedList({
    required this.children,
    super.key,
  });

  /// Complete ordered set of grouped rows.
  ///
  /// Keep this collection compact. The component accepts already-created
  /// widgets and leaves collection updates and loading decisions to the
  /// consumer.
  final List<MateoGroupedListRow> children;

  static const _borderRadius = BorderRadius.all(Radius.circular(36));
  static const _surfacePadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 8,
  );

  Widget _buildRow(BuildContext context, int index) {
    final row = children[index];
    Widget child = row;

    if (index + 1 < children.length) {
      child = Stack(
        children: [
          row,
        ],
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _borderRadius,
      clipBehavior: Clip.antiAlias,
      child: ColoredBox(
        color: Colors.transparent,
        child: Padding(
          padding: _surfacePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < children.length; index++) _buildRow(context, index),
            ],
          ),
        ),
      ),
    );
  }
}
