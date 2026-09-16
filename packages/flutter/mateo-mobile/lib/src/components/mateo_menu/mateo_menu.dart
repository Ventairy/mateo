import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../theme/mateo_theme.dart';
import '../../theme/mateo_typography.dart';
import '../mateo_icon/mateo_icon_scope.dart';
import '../mateo_press/mateo_press.dart';
import '../mateo_surface/mateo_surface.dart';
import 'mateo_menu_density.dart';
import 'mateo_menu_width.dart';
import 'presentations/options_presentation/mateo_menu_options_presentation_item.dart';

part '_mateo_menu_presentation_scope.dart';
part 'presentations/mateo_menu_presentation.dart';
part 'presentations/options_presentation/_mateo_menu_options_presentation_row.dart';
part 'presentations/options_presentation/_mateo_menu_options_row.dart';
part 'presentations/options_presentation/_render_mateo_menu_options_row.dart';
part 'presentations/options_presentation/_mateo_menu_options_presentation.dart';

/// A Mateo menu that displays the supplied presentation.
///
/// ```dart
/// MateoMenu(
///   presentation: .options(
///     items: const [MateoMenuOptionsPresentationItem(principal: Text('View details'))],
///   ),
///   onItemPressed: (item) {},
/// )
/// ```
class MateoMenu extends StatelessWidget {
  /// Creates an inline menu using [presentation].
  const MateoMenu({required this.presentation, this.onItemPressed, super.key});

  /// The content and appearance of the menu.
  final MateoMenuPresentation presentation;

  /// The selection handler, or null to disable all options.
  final FutureOr<void> Function(MateoMenuOptionsPresentationItem item)? onItemPressed;

  /// Builds the menu using its presentation.
  @override
  Widget build(BuildContext context) => _MateoMenuPresentationScope(
    onItemPressed: onItemPressed,
    child: presentation,
  );
}
