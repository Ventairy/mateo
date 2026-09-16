import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/material.dart';
import 'package:mateo_mobile_old/src/components/mateo_circular_loading_indicator/mateo_circular_loading_indicator.dart';
import 'package:mateo_mobile_old/src/components/mateo_dots_loading_indicator/mateo_dots_loading_indicator.dart';
import 'package:mateo_mobile_old/src/components/mateo_tap/mateo_tap.dart';
import 'package:mateo_mobile_old/src/foundation/mateo_elevation.dart';
import 'package:mateo_mobile_old/src/theme/mateo_color_scheme/mateo_color_scheme.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile_old/src/theme/mateo_typography.dart';

part 'mateo_button_alignment.dart';
part 'mateo_button_builders.dart';
part 'mateo_button_fit.dart';
part 'mateo_button_presentation.dart';
part '_mateo_button_owner.dart';
part '_mateo_button_presentation_scope.dart';
part 'mateo_button_scope.dart';
part 'mateo_button_state.dart';
part 'mateo_button_variant.dart';
part 'mateo_icon_button_icon_state.dart';
part 'mateo_primary_button_variant.dart';
part 'mateo_secondary_button_variant.dart';
part 'mateo_tertiary_button_variant.dart';
part 'presentations/_mateo_icon_button_presentation.dart';
part 'presentations/_mateo_label_button_presentation.dart';

/// An action button for the Mateo Mobile design system.
///
/// When [onPressed] returns a [Future], the button briefly shows a
/// loading indicator while that future is still pending. Synchronous callbacks
/// keep the button feeling instant and do not enter the loading state.
/// The [presentation] owns the button's content, color, spacing, and layout.
/// Its variant resolves a [MateoButtonColorScheme] from the active
/// Mateo theme unless it provides a color scheme directly.
///
/// Set [isLoading] to `true` to show the loading indicator immediately
/// without requiring a press — useful for external loading state.
///
/// ```dart
/// MateoButton(
///   presentation: const MateoButtonPresentation.label(
///     label: 'Ver oportunidades',
///     variant: MateoButtonVariant.primary,
///   ),
///   onPressed: () {},
/// )
/// ```
class MateoButton extends StatefulWidget {
  /// Creates a Mateo Mobile button.
  ///
  /// The [presentation] supplies every reusable visual and layout property.
  /// [onPressed] and [isLoading] remain on the widget because they own behavior
  /// and runtime state.
  ///
  /// ```dart
  /// MateoButton(
  ///   presentation: const MateoButtonPresentation.label(
  ///     label: 'Salvar agora',
  ///     variant: MateoButtonVariant.primary,
  ///   ),
  ///   onPressed: () async {
  ///     await Future<void>.delayed(const Duration(seconds: 2));
  ///   },
  /// )
  /// ```
  const MateoButton({
    required this.presentation,
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  /// Returns the visible button surface bounds inside [bounds].
  @internal
  static Rect surfaceRect(MateoButtonPresentation presentation, Rect bounds) {
    final size = presentation._buttonSize;
    return size == null ? bounds : Rect.fromCenter(center: bounds.center, width: size, height: size);
  }

  /// Reusable content, color, spacing, and layout for this button.
  final MateoButtonPresentation presentation;

  /// Called when the button is pressed.
  ///
  /// If the callback returns a [Future], the button swaps its label for the
  /// loading indicator while that future is pending. Synchronous
  /// callbacks keep the current immediate feedback and do not enter the
  /// loading state.
  ///
  /// When null, the button renders disabled and ignores pointer input.
  final FutureOr<void> Function()? onPressed;

  /// Whether the button is manually placed in the loading state.
  ///
  /// When `true`, the button shows the loading indicator with the same
  /// animation used when [onPressed] returns a pending [Future].
  /// Unlike the future-based loading, there is no debounce delay — the
  /// animation begins immediately.
  ///
  /// When `false`, the button exits the loading state only if no
  /// [onPressed] future is still pending. This allows the prop and the
  /// future-based loading to overlap without flickering.
  ///
  /// The loading state works in any button state (including disabled)
  /// and uses the state-appropriate colors. While loading, the button
  /// is not interactive.
  ///
  /// ```dart
  /// MateoButton(
  ///   presentation: const MateoButtonPresentation.label(
  ///     label: 'Salvar agora',
  ///     variant: MateoButtonVariant.primary,
  ///   ),
  ///   isLoading: true,
  ///   onPressed: () {},
  /// )
  /// ```
  final bool isLoading;

  @override
  State<MateoButton> createState() => _MateoButtonState();
}

class _MateoButtonState extends State<MateoButton> with SingleTickerProviderStateMixin implements _MateoButtonOwner {
  static const Duration _loadingDelay = Duration(milliseconds: 50);

  late final AnimationController _contentOpacityController;
  final GlobalKey<State<StatefulWidget>> _loadingIndicatorKey = GlobalKey();
  int _presentationRevision = 0;

  @override
  bool isPressed = false;
  @override
  bool isLoading = false;
  bool isPendingPress = false;
  @override
  bool showLoadingIndicator = false;
  @override
  bool showTransitionOverlay = false;
  int loadingGeneration = 0;

  @override
  Animation<double> get contentOpacity => _contentOpacityController;

  @override
  Key get loadingIndicatorKey => _loadingIndicatorKey;

  @override
  bool get isEnabled => widget.onPressed != null;

  @override
  bool get isInteractive => isEnabled && !isPendingPress && !widget.isLoading && !isLoading;

  @override
  void initState() {
    super.initState();
    _contentOpacityController = AnimationController(
      duration: widget.presentation._contentTransitionDuration,
      value: 1,
      vsync: this,
    );
    if (widget.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) enterLoadingFromParam();
      });
    }
  }

  @override
  void didUpdateWidget(covariant MateoButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _presentationRevision++;
    if (widget.presentation._contentTransitionDuration != oldWidget.presentation._contentTransitionDuration) {
      _contentOpacityController.duration = widget.presentation._contentTransitionDuration;
    }
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        enterLoadingFromParam();
      } else {
        exitLoadingFromParam();
      }
    }
  }

  @override
  void dispose() {
    _contentOpacityController.dispose();
    super.dispose();
  }

  void _updateOwner(VoidCallback update) {
    if (!mounted) return;
    setState(() {
      update();
      _presentationRevision++;
    });
  }

  @override
  void updatePressed({required bool pressed}) => _updateOwner(() => isPressed = pressed);

  @override
  Future<void> handlePressed() async {
    final result = widget.onPressed!();
    if (result is! Future<void>) return;
    if (!mounted) return;

    final generation = loadingGeneration + 1;
    loadingGeneration = generation;
    _updateOwner(() => isPendingPress = true);
    if (!isLoading) {
      unawaited(
        enterLoading(
          generation: generation,
          isPending: () => isPendingPress,
          delay: _loadingDelay,
        ),
      );
    }

    try {
      await result;
    } finally {
      if (mounted) _updateOwner(() => isPendingPress = false);
      await maybeExitLoading(generation: generation);
    }
  }

  Future<void> enterLoading({
    required int generation,
    required bool Function() isPending,
    required Duration? delay,
  }) async {
    if (delay != null) await Future<void>.delayed(delay);
    if (!mounted || loadingGeneration != generation || !isPending() || isLoading) return;

    _contentOpacityController
      ..stop(canceled: false)
      ..value = 1;
    _updateOwner(() => isLoading = true);
    if (MediaQuery.disableAnimationsOf(context)) {
      _updateOwner(() => showLoadingIndicator = true);
      return;
    }
    await _contentOpacityController.reverse();
    if (!mounted || loadingGeneration != generation || !isPending() || showLoadingIndicator) return;
    _updateOwner(() => showLoadingIndicator = true);
  }

  Future<void> restoreContentAfterLoading({required int generation}) async {
    if (!mounted || loadingGeneration != generation || !isLoading) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _updateOwner(() {
        isLoading = false;
        showLoadingIndicator = false;
        showTransitionOverlay = false;
      });
      return;
    }

    _contentOpacityController
      ..stop(canceled: false)
      ..value = 0;
    _updateOwner(() => showTransitionOverlay = true);
    await Future<void>.delayed(widget.presentation._contentTransitionDuration * 3 ~/ 4);
    if (!mounted || loadingGeneration != generation) return;
    _updateOwner(() {
      showTransitionOverlay = false;
      showLoadingIndicator = false;
    });
    _contentOpacityController.stop(canceled: false);
    await _contentOpacityController.forward();
    if (!mounted || loadingGeneration != generation) return;
    _updateOwner(() => isLoading = false);
  }

  Future<void> maybeExitLoading({required int generation}) async {
    if (widget.isLoading || isPendingPress) return;
    await restoreContentAfterLoading(generation: generation);
  }

  void enterLoadingFromParam() {
    if (isLoading) return;
    final generation = loadingGeneration + 1;
    loadingGeneration = generation;
    unawaited(
      enterLoading(
        generation: generation,
        isPending: () => widget.isLoading,
        delay: null,
      ),
    );
  }

  void exitLoadingFromParam() {
    unawaited(maybeExitLoading(generation: loadingGeneration));
  }

  @override
  Widget build(BuildContext context) => _MateoButtonPresentationScope(
    owner: this,
    revision: _presentationRevision,
    child: widget.presentation,
  );
}
