import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mateo_mobile_old/src/components/mateo_tap/mateo_tap.dart';
import 'package:mateo_mobile_old/src/icons/mateo_icons.dart';
import 'package:mateo_mobile_old/src/theme/mateo_color_scheme/mateo_color_scheme.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile_old/src/theme/mateo_typography.dart';

part '_mateo_select_owner.dart';
part '_mateo_select_scope.dart';
part 'mateo_select_option.dart';
part 'mateo_select_presentation.dart';
part 'mateo_select_state.dart';
part 'mateo_select_types.dart';
part 'presentations/_mateo_neutral_select_presentation/_mateo_neutral_select_presentation.dart';
part 'presentations/_mateo_neutral_select_presentation/_mateo_neutral_select_menu.dart';
part 'presentations/_mateo_neutral_select_presentation/_mateo_neutral_select_menu_placement.dart';
part 'presentations/_mateo_neutral_select_presentation/_mateo_neutral_select_option_content.dart';
part 'presentations/_mateo_neutral_select_presentation/_mateo_neutral_select_options.dart';
part 'presentations/_mateo_neutral_select_presentation/_mateo_neutral_select_surface.dart';
part 'presentations/_mateo_neutral_select_presentation/_mateo_neutral_select_surface_clipper.dart';
part 'presentations/_mateo_neutral_select_presentation/_mateo_neutral_select_surface_painter.dart';
part 'presentations/_mateo_neutral_select_presentation/_mateo_neutral_select_trigger.dart';
part 'presentations/_mateo_ghost_select_presentation/_mateo_ghost_select_presentation.dart';
part 'presentations/_mateo_ghost_select_presentation/_mateo_ghost_select_menu.dart';
part 'presentations/_mateo_ghost_select_presentation/_mateo_ghost_select_menu_placement.dart';
part 'presentations/_mateo_ghost_select_presentation/_mateo_ghost_select_option_content.dart';
part 'presentations/_mateo_ghost_select_presentation/_mateo_ghost_select_options.dart';
part 'presentations/_mateo_ghost_select_presentation/_mateo_ghost_select_surface.dart';
part 'presentations/_mateo_ghost_select_presentation/_mateo_ghost_select_surface_clipper.dart';
part 'presentations/_mateo_ghost_select_presentation/_mateo_ghost_select_surface_painter.dart';
part 'presentations/_mateo_ghost_select_presentation/_mateo_ghost_select_trigger.dart';

/// A selection control that expands its current option into an option menu.
///
/// [MateoSelect] owns its selected value after applying [initialValue]. Opening the
/// control preserves the supplied [options] order while the current option
/// travels from the closed face to its matching row. Pressing an option closes
/// the menu and invokes [onSelected]. Choosing a different option also updates
/// the closed face.
///
/// Values identify options across rebuilds and must be unique under `==`. If a
/// selected value disappears from a rebuilt [options] list, selection falls back
/// to the current [initialValue].
///
/// Opening expands the closed surface while its selected option travels into
/// the menu. Selecting another option reverses that motion from the option's
/// current position while the remaining options fade. The transition resolves
/// immediately when the platform requests reduced motion.
///
/// The menu stays within the phone's safe area, avoids the software keyboard,
/// and scrolls when its contents exceed the available height.
///
/// Tapping outside the menu, pressing the system back action, or pressing
/// Escape dismisses it without changing selection. While open, the menu blocks
/// interaction and semantics behind it, then returns focus to the closed
/// control when it closes.
///
/// ```dart
/// MateoSelect<String>(
///   initialValue: 'fixed',
///   presentation: const MateoSelectPresentation.neutral(),
///   onSelected: (value, animation) async {
///     await animation; // Optional: continue after the menu closes.
///   },
///   options: [
///     MateoSelectOption(
///       value: 'fixed',
///       title: 'Fixed price',
///       iconBuilder: (state) => Icon(
///         Icons.attach_money,
///         size: state.iconSize,
///         color: state.recommendedIconColor,
///       ),
///     ),
///     MateoSelectOption(
///       value: 'range',
///       title: 'Range',
///       iconBuilder: (state) => Icon(
///         Icons.swap_horiz,
///         size: state.iconSize,
///         color: state.recommendedIconColor,
///       ),
///     ),
///   ],
/// )
/// ```
///
/// See also:
///  * [MateoSelectOption], the value and content for one option.
///  * [MateoSelectPresentation], the closed control presentation.
class MateoSelect<T> extends StatefulWidget {
  /// Creates a Mateo selection control.
  ///
  /// The [options] list must contain at least two options with unique values, and
  /// exactly one option value must equal [initialValue]. Build the control below
  /// a [ModalRoute] so system back can dismiss its open menu before the
  /// surrounding route.
  MateoSelect({
    required List<MateoSelectOption<T>> options,
    required this.initialValue,
    required this.presentation,
    required this.onSelected,
    super.key,
  }) : assert(
         options.length >= 2,
         'MateoSelect requires at least two options.',
       ),
       assert(
         _valuesAreUnique(options),
         'MateoSelect requires every option value to be unique.',
       ),
       assert(
         _matchCount(options, initialValue) == 1,
         'MateoSelect requires initialValue to match exactly one option value.',
       ),
       options = List<MateoSelectOption<T>>.unmodifiable(options);

  /// Options available for selection.
  ///
  /// Options are displayed in this order. Values must remain unique under
  /// `==`. Rebuilt option instances retain the current selection when their
  /// value still matches it. The supplied list is copied so later mutations do
  /// not change this widget instance.
  final List<MateoSelectOption<T>> options;

  /// Value selected when this control is first created.
  ///
  /// Changing [initialValue] does not replace an existing selection. It is used
  /// again only if the selected value disappears from a rebuilt [options] list.
  final T initialValue;

  /// Visual treatment and optional closed-control color override.
  final MateoSelectPresentation presentation;

  /// Callback invoked once as an option selection starts closing the menu.
  ///
  /// Receives the selected value and an animation future. Await the future to
  /// continue after the menu is removed, or act immediately without awaiting it.
  /// Reopening keeps the future pending until the menu closes. Disposal also
  /// completes it. Choosing the current value still invokes this callback;
  /// dismissing without choosing an option does not. Closing never waits for
  /// the callback's returned future.
  final FutureOr<void> Function(T value, Future<void> animation) onSelected;

  static bool _valuesAreUnique<T>(List<MateoSelectOption<T>> options) {
    for (var index = 0; index < options.length; index += 1) {
      for (var comparison = index + 1; comparison < options.length; comparison += 1) {
        if (options[index].value == options[comparison].value) return false;
      }
    }
    return true;
  }

  static int _matchCount<T>(List<MateoSelectOption<T>> options, T value) =>
      options.where((option) => option.value == value).length;

  @override
  State<MateoSelect<T>> createState() => _MateoSelectState<T>();
}

class _MateoSelectState<T> extends State<MateoSelect<T>> implements _MateoSelectOwner {
  late T _selectedValue;
  int _presentationRevision = 0;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant MateoSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.options.any((option) => option.value == _selectedValue)) {
      _selectedValue = widget.initialValue;
    }
    _presentationRevision++;
  }

  @override
  List<MateoSelectOption<dynamic>> get presentationOptions => widget.options;

  @override
  Object? get selectedValue => _selectedValue;

  @override
  MateoSelectOption<dynamic> get selectedOption =>
      widget.options.singleWhere((option) => option.value == _selectedValue);

  @override
  ValueChanged<Future<void>> commitSelection(MateoSelectOption<dynamic> option) {
    final typedOption = option as MateoSelectOption<T>;
    final onSelected = widget.onSelected;
    if (typedOption.value != _selectedValue) {
      setState(() {
        _selectedValue = typedOption.value;
        _presentationRevision++;
      });
    }
    return (animation) => unawaited(Future<void>.sync(() => onSelected(typedOption.value, animation)));
  }

  @override
  Widget build(BuildContext context) => _MateoSelectScope(
    owner: this,
    revision: _presentationRevision,
    child: widget.presentation,
  );
}
