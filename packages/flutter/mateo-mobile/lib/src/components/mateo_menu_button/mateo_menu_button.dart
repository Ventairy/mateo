import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../bases/base_mateo_surface/mateo_surface_scope.dart';
import '../../foundation/mateo_surface_animation/mateo_surface_animation.dart';
import '../../foundation/mateo_transform_target/mateo_transform_target.dart';
import '../mateo_button/mateo_button.dart';
import '../mateo_menu/mateo_menu.dart';
import '../mateo_menu/overlay/show_mateo_menu.dart';
import '../mateo_menu/presentations/options_presentation/mateo_menu_options_presentation_item.dart';
import 'animation/mateo_menu_button_animation.dart';

/// A menu trigger using Mateo button presentation and press feedback.
///
/// Opens the configured menu and returns to the trigger when dismissed.
///
/// ```dart
/// MateoMenuButton(
///   buttonPresentation: const .label(label: 'Options', variant: .secondary),
///   animation: const .transform(),
///   menuPresentation: .options(items: const [MateoMenuOptionsPresentationItem(principal: Text('Details'))]),
///   onItemPressed: (item) {}
/// )
/// ```
///
/// See also:
///  * [MateoButtonPresentation], the content and treatment of the trigger.
///  * [MateoMenuPresentation], the content and treatment of the menu.
class MateoMenuButton extends StatefulWidget {
  /// Creates a menu trigger using [buttonPresentation] and [menuPresentation].
  const MateoMenuButton({
    required this.buttonPresentation,
    required this.menuPresentation,
    required this.animation,
    super.key,
    this.onItemPressed,
  });

  /// The content, treatment, and layout of the trigger button.
  final MateoButtonPresentation buttonPresentation;

  /// The content and appearance of the menu.
  final MateoMenuPresentation menuPresentation;

  /// The animation used to show and dismiss the menu.
  final MateoMenuButtonAnimation animation;

  /// The selection handler for menu options, or null to disable selection.
  final FutureOr<void> Function(MateoMenuOptionsPresentationItem item)? onItemPressed;

  /// Creates the state retaining the trigger's transform identity.
  @override
  State<MateoMenuButton> createState() => _MateoMenuButtonState();
}

class _MateoMenuButtonState extends State<MateoMenuButton> {
  MateoTransformTarget? _transformTarget;

  MateoTransformTarget _targetFor(Duration duration, Curve curve) {
    final target = _transformTarget;
    if (target != null && target.duration == duration && target.curve == curve) return target;
    return _transformTarget = MateoTransformTarget(duration: duration, curve: curve);
  }

  final GlobalKey _anchorKey = GlobalKey();
  bool _menuIsOpen = false;

  MateoSurfaceAnimation get _buttonSurfaceAnimation => switch (widget.animation) {
    MateoMenuButtonAnimationPop() => const .none(),
    MateoMenuButtonAnimationTransform(:final duration, :final curve, :final buttonContentEffects) => .transform(
      target: _targetFor(duration, curve),
      contentEffects: buttonContentEffects,
    ),
  };

  MateoSurfaceAnimation get _menuSurfaceAnimation => switch (widget.animation) {
    MateoMenuButtonAnimationPop(:final duration, :final curve) => .pop(duration: duration, curve: curve),
    MateoMenuButtonAnimationTransform(:final duration, :final curve, :final menuContentEffects) => .transform(
      target: _targetFor(duration, curve),
      contentEffects: menuContentEffects,
    ),
  };

  MateoMenuExitTransition? get _exitTransition => switch (widget.animation) {
    MateoMenuButtonAnimationPop(:final exitDuration, :final exitCurve) => (
      duration: exitDuration,
      builder: (context, animation, child) {
        final progress = animation.drive(CurveTween(curve: exitCurve));

        return FadeTransition(
          opacity: progress,
          child: ScaleTransition(
            scale: progress.drive(Tween<double>(begin: 0.95, end: 1)),
            child: child,
          ),
        );
      },
    ),
    MateoMenuButtonAnimationTransform() => null,
  };

  Offset _placeMenu(Rect anchorBounds, Size menuSize, Rect availableBounds) {
    // Keep the transform attached even when its trigger extends beyond the viewport.
    final fitBounds = switch (widget.animation) {
      MateoMenuButtonAnimationTransform() => availableBounds.expandToInclude(anchorBounds),
      MateoMenuButtonAnimationPop() => availableBounds,
    };

    final preferTop = anchorBounds.center.dy > availableBounds.center.dy;

    final directions = [
      if (preferTop) Alignment.topCenter else Alignment.bottomCenter,
      if (preferTop) Alignment.bottomCenter else Alignment.topCenter,
      Alignment.centerRight,
      Alignment.centerLeft,
    ];

    late Offset position;

    for (final direction in directions) {
      position = switch (widget.animation) {
        MateoMenuButtonAnimationPop() => _placeAdjacentMenu(anchorBounds, menuSize, availableBounds, direction),
        MateoMenuButtonAnimationTransform() =>
          anchorBounds.center -
              menuSize.center(Offset.zero) +
              Offset(
                direction.x * math.max(0, menuSize.width - anchorBounds.width) / 2,
                (direction.y == 0 ? (preferTop ? -1 : 1) : direction.y) * (menuSize.height - anchorBounds.height) / 2,
              ),
      };

      final rectangle = position & menuSize;

      if (rectangle.left >= fitBounds.left &&
          rectangle.top >= fitBounds.top &&
          rectangle.right <= fitBounds.right &&
          rectangle.bottom <= fitBounds.bottom) {
        return position;
      }
    }

    return position;
  }

  Offset _placeAdjacentMenu(Rect anchorBounds, Size menuSize, Rect availableBounds, Alignment direction) {
    const gap = 8.0;
    final centered = anchorBounds.center - menuSize.center(Offset.zero);
    final position =
        centered +
        Offset(
          direction.x * ((anchorBounds.width + menuSize.width) / 2 + gap),
          direction.y * ((anchorBounds.height + menuSize.height) / 2 + gap),
        );

    if (direction.x == 0 && menuSize.width <= availableBounds.width) {
      return Offset(position.dx.clamp(availableBounds.left, availableBounds.right - menuSize.width), position.dy);
    }
    if (direction.y == 0 && menuSize.height <= availableBounds.height) {
      return Offset(position.dx, position.dy.clamp(availableBounds.top, availableBounds.bottom - menuSize.height));
    }
    return position;
  }

  void _open() {
    if (_menuIsOpen || !mounted) return;
    _menuIsOpen = true;

    unawaited(_showMenu());
  }

  Future<void> _showMenu() async {
    try {
      await showMateoMenu(
        anchorContext: _anchorKey.currentContext!,
        surfaceAnimation: _menuSurfaceAnimation,
        exitTransition: _exitTransition,
        placement: _placeMenu,
        menu: MateoMenu(presentation: widget.menuPresentation, onItemPressed: widget.onItemPressed),
      );
    } finally {
      _menuIsOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaceAnimation = _buttonSurfaceAnimation;

    return KeyedSubtree(
      key: _anchorKey,
      child: MateoSurfaceScope(
        animation: surfaceAnimation,
        child: MateoButton(presentation: widget.buttonPresentation, onPressed: _open),
      ),
    );
  }
}
