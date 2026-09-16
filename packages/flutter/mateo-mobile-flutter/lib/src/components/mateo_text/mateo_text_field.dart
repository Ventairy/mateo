import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';
import 'package:mateo_mobile_old/src/foundation/mateo_elevation.dart';

part '_mateo_text_controller_owner.dart';
part '_mateo_text_field_owner.dart';
part '_mateo_text_field_scope.dart';
part 'mateo_text_field_presentation.dart';
part 'mateo_text_field_variant.dart';
part 'presentations/_mateo_search_text_field_presentation/_mateo_search_text_field_presentation.dart';
part 'presentations/_mateo_search_text_field_presentation/_mateo_search_text_field_surface.dart';
part 'presentations/_mateo_search_text_field_presentation/_mateo_search_text_selection_painter.dart';

/// A typography-led search field for input flows.
///
/// The required [presentation] defines the visual treatment while the field preserves
/// the platform's native editing, selection, keyboard, autofill, focus, and
/// accessibility behavior. The field remains single-line. When [onChanged] is
/// null, the field is disabled.
///
/// ```dart
/// MateoTextField(
///   placeholder: 'Search places',
///   presentation: MateoTextFieldPresentation.search(variant: .floating),
///   textInputAction: TextInputAction.search,
///   onChanged: (value) {},
/// )
/// ```
class MateoTextField extends StatefulWidget {
  /// Creates a Mateo single-line text field for mobile.
  const MateoTextField({
    required this.placeholder,
    required this.presentation,
    super.key,
    this.onChanged,
    this.controller,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
    this.maxLength,
    this.scrollPadding = const EdgeInsets.all(20),
    this.editable = true,
    this.unfocusOnTapOutside = true,
  }) : assert(maxLength == null || maxLength > 0, 'maxLength must be greater than zero when provided.'),
       assert(keyboardType != TextInputType.multiline, 'MateoTextField does not support multiline keyboard input.'),
       assert(textInputAction != TextInputAction.newline, 'MateoTextField does not support newline input actions.');

  /// Text shown while the field has no entered value.
  final String placeholder;

  /// Visual style applied to the text input.
  final MateoTextFieldPresentation presentation;

  /// Callback invoked whenever the entered value changes.
  ///
  /// When null, the input is disabled and cannot receive focus or edits.
  final ValueChanged<String>? onChanged;

  /// Controller that owns the field's value, selection, and focus.
  ///
  /// The consuming application owns and disposes this controller.
  final MateoTextController? controller;

  /// Whether the input requests focus when it first appears.
  final bool autofocus;

  /// Keyboard configuration requested from the current mobile platform.
  final TextInputType? keyboardType;

  /// Keyboard action shown for completing or advancing from the input.
  ///
  /// When null, [presentation] supplies its default action.
  final TextInputAction? textInputAction;

  /// Callback invoked when the platform submits the entered value.
  final ValueChanged<String>? onSubmitted;

  /// Autofill hints that describe the value expected by the input.
  final Iterable<String>? autofillHints;

  /// Maximum number of characters the person can enter.
  ///
  /// When provided, the input shows its variant's character counter after the
  /// first character and rejects additional characters after this limit. When
  /// null, the input has no character limit or counter.
  final int? maxLength;

  /// Space kept around the caret when an ancestor scrolls the input into view.
  ///
  /// Increase the bottom inset when content overlays the input, such as an
  /// action button positioned above the keyboard.
  final EdgeInsets scrollPadding;

  /// Whether user input can change the text.
  ///
  /// When false, user-originated text changes are rejected.
  /// The [controller] can still update the value programmatically.
  final bool editable;

  /// Whether tapping outside the input removes focus and closes its keyboard.
  final bool unfocusOnTapOutside;

  @override
  State<MateoTextField> createState() => _MateoTextFieldState();
}

class _MateoTextFieldState extends State<MateoTextField> implements _MateoTextFieldOwner {
  late final _MateoTextControllerOwner _textControllerOwner;
  late bool _hasText;
  late bool _hasFocus;
  int _presentationRevision = 0;

  MateoTextField get _input => widget;
  MateoTextController get _textController => _textControllerOwner.controller;

  @override
  MateoTextField get input => _input;

  @override
  MateoTextController get textController => _textController;

  @override
  bool get hasText => _hasText;

  @override
  bool get hasFocus => _hasFocus;

  @override
  void initState() {
    super.initState();
    _textControllerOwner = _MateoTextControllerOwner(controller: widget.controller);
    _hasText = _textController.text.isNotEmpty;
    _hasFocus = _textController.hasFocus;
    _textController.addListener(_handleEditingChanged);
  }

  @override
  void didUpdateWidget(covariant MateoTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldController = _textController;
    // The old controller must be detached before ownership can dispose it.
    // ignore: cascade_invocations
    oldController.removeListener(_handleEditingChanged);
    _textControllerOwner.updateController(widget.controller);
    final newController = _textController;
    // The replacement controller must be attached after the ownership swap.
    // ignore: cascade_invocations
    newController.addListener(_handleEditingChanged);

    if (oldController != newController) {
      _hasText = newController.text.isNotEmpty;
      _hasFocus = newController.hasFocus;
    }
    _presentationRevision++;
  }

  @override
  void dispose() {
    _textController.removeListener(_handleEditingChanged);
    _textControllerOwner.dispose();
    super.dispose();
  }

  void _handleEditingChanged() {
    final hasText = _textController.text.isNotEmpty;
    final hasFocus = _textController.hasFocus;
    if (hasText == _hasText && hasFocus == _hasFocus) return;

    setState(() {
      _hasText = hasText;
      _hasFocus = hasFocus;
      _presentationRevision++;
    });
  }

  @override
  void clear() {
    _textController
      ..focus()
      ..clear();
    _input.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) => _MateoTextFieldScope(
    owner: this,
    revision: _presentationRevision,
    child: widget.presentation,
  );
}
