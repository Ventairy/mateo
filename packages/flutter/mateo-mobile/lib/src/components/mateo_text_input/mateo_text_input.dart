import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../bases/base_mateo_edge_fade/base_mateo_edge_fade.dart';
import '../../bases/base_mateo_edge_fade/mateo_edge_fade_band.dart';
import '../../bases/base_mateo_edge_fade/mateo_edge_fade_profile.dart';
import '../../foundation/mateo_elevation.dart';
import '../../theme/mateo_theme.dart';
import '../../theme/mateo_typography.dart';
import '../mateo_icon/mateo_icon.dart';
import '../mateo_press/mateo_press.dart';
import '../mateo_surface/mateo_surface.dart';
import 'mateo_text_input_size.dart';
import 'mateo_text_input_variant.dart';

part '_mateo_text_input_presentation_scope.dart';
part 'presentations/_mateo_search_text_input_presentation.dart';
part 'presentations/_mateo_search_text_input_fade_profile.dart';
part 'presentations/_mateo_text_input_selection_overflow.dart';
part 'presentations/mateo_text_input_presentation.dart';

/// A Mateo text input with a presentation-owned appearance.
///
/// ```dart
/// MateoTextInput(
///   placeholder: 'Search places',
///   presentation: const .search(variant: .filled),
///   onChanged: (value) {},
/// )
/// ```
class MateoTextInput extends StatefulWidget {
  /// Creates an input using [presentation].
  const MateoTextInput({
    required this.placeholder,
    required this.presentation,
    this.controller,
    this.focusNode,
    this.autofocus = true,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  /// The prompt shown when the input is empty.
  final String placeholder;

  /// The input's content layout and visual treatment.
  final MateoTextInputPresentation presentation;

  /// The value and selection controller, owned and disposed by the caller.
  ///
  /// When omitted, the input manages its own controller.
  final TextEditingController? controller;

  /// The focus node, owned and disposed by the caller.
  ///
  /// When omitted, the input manages its own focus node.
  final FocusNode? focusNode;

  /// Whether to request focus when mounted. Defaults to true.
  ///
  /// Disabled inputs do not request focus.
  final bool autofocus;

  /// The callback for user edits, or null to disable the input.
  ///
  /// Programmatic controller changes do not invoke this callback.
  final ValueChanged<String>? onChanged;

  /// The callback invoked when the keyboard submits the entered value.
  final ValueChanged<String>? onSubmitted;

  @override
  State<MateoTextInput> createState() => _MateoTextInputState();
}

class _MateoTextInputState extends State<MateoTextInput> {
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;

  TextEditingController get _controller => widget.controller ?? (_ownedController ??= TextEditingController());
  FocusNode get _focusNode => widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  void _clear() {
    if (widget.onChanged == null || _controller.text.isEmpty) return;
    _controller.clear();
    widget.onChanged!('');
  }

  @override
  void didUpdateWidget(MateoTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != null && widget.controller == null) {
      _controller.value = oldWidget.controller!.value;
    }
  }

  @override
  void dispose() {
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _MateoTextInputPresentationScope(
    controller: _controller,
    focusNode: _focusNode,
    autofocus: widget.autofocus,
    placeholder: widget.placeholder,
    onChanged: widget.onChanged,
    onSubmitted: widget.onSubmitted,
    onClear: _clear,
    child: widget.presentation,
  );
}
