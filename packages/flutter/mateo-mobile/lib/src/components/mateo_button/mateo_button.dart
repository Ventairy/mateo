import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/mateo_elevation.dart';
import '../../theme/color_scheme/mateo_color_scheme.dart';
import '../../theme/mateo_theme.dart';
import '../../theme/mateo_typography.dart';
import '../mateo_icon/mateo_icon_scope.dart';
import '../mateo_loading_indicator/mateo_loading_indicator.dart';
import '../mateo_press/mateo_press.dart';
import '../mateo_surface/mateo_surface.dart';
import 'mateo_button_alignment.dart';
import 'mateo_button_size.dart';
import 'mateo_button_width.dart';
import 'variants/mateo_button_variant.dart';

part '_mateo_button_presentation_scope.dart';
part 'presentations/_mateo_fitted_label_button_content.dart';
part 'presentations/_mateo_fitted_label_button_content_parent_data.dart';
part 'presentations/_mateo_icon_button_presentation.dart';
part 'presentations/_mateo_label_button_presentation.dart';
part 'presentations/_render_mateo_fitted_label_button_content.dart';
part 'presentations/mateo_button_presentation.dart';

/// A button from Mateo mobile design system
///
/// Synchronous actions respond immediately. Pending asynchronous actions show
/// loading
///
/// ```dart
/// MateoButton(
///   presentation: const .label(label: 'Save changes', variant: .primary),
///   onPressed: saveChanges,
/// )
/// ```
///
/// See also:
///  * [MateoButtonPresentation], the content and treatment of the button.
class MateoButton extends StatefulWidget {
  /// Creates an action using [presentation].
  const MateoButton({required this.presentation, super.key, this.onPressed, this.isLoading = false});

  /// The content, treatment, and layout of this action.
  final MateoButtonPresentation presentation;

  /// The action to run, or null when the button is unavailable.
  ///
  /// Returning a future prevents repeated activation until it completes.
  /// Errors propagate to the caller's zone after loading is cleared.
  final FutureOr<void> Function()? onPressed;

  /// Whether external work requires immediate loading feedback.
  ///
  /// Clearing this does not interrupt an action that is still pending. Loading
  /// retains the action's name and prevents activation, even when no callback
  /// is supplied.
  final bool isLoading;

  @override
  State<MateoButton> createState() => _MateoButtonState();
}

class _MateoButtonState extends State<MateoButton> {
  Timer? _loadingDelay;
  bool _pending = false;
  bool _showAsyncLoading = false;

  bool get _interactive => widget.onPressed != null && !_pending && !widget.isLoading;

  @override
  void didUpdateWidget(MateoButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Once activity is visible, overlapping manual work must not hide a
    // pending action just because its initial delay has not elapsed yet.
    if (widget.isLoading && _pending) _showAsyncLoading = true;
  }

  Future<void> _activate() async {
    if (!_interactive) return;
    // Lock before invoking application code, including reentrant callbacks.
    _pending = true;
    try {
      final result = widget.onPressed!();
      if (result is! Future<void>) return;
      if (mounted) {
        setState(() {});
        _loadingDelay = Timer(const Duration(milliseconds: 50), () {
          if (mounted) setState(() => _showAsyncLoading = true);
        });
      }
      await result;
    } finally {
      _loadingDelay?.cancel();
      _loadingDelay = null;
      if (mounted && (_showAsyncLoading || _pending)) {
        setState(() {
          _pending = false;
          _showAsyncLoading = false;
        });
      } else {
        _pending = false;
      }
    }
  }

  @override
  void dispose() {
    _loadingDelay?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _MateoButtonPresentationScope(
    enabled: widget.onPressed != null,
    interactive: _interactive,
    loading: widget.isLoading || _showAsyncLoading,
    onPressed: _activate,
    child: widget.presentation,
  );
}
