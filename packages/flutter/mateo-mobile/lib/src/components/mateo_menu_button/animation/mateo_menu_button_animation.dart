import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import '../../../foundation/mateo_surface_animation/mateo_surface_animation.dart';

part 'mateo_menu_button_animation_pop.dart';
part 'mateo_menu_button_animation_transform.dart';

/// An animation style connecting a menu button to its menu.
@immutable
sealed class MateoMenuButtonAnimation {
  const MateoMenuButtonAnimation._();

  /// Transforms the button into the menu panel.
  const factory MateoMenuButtonAnimation.transform() = MateoMenuButtonAnimationTransform;

  /// Pops a separate menu beside the visible trigger.
  const factory MateoMenuButtonAnimation.pop() = MateoMenuButtonAnimationPop;
}
