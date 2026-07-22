import 'package:flutter/widgets.dart';

import '../mateo_hero.dart';
import 'mateo_hero_page_route.dart';

/// A [Page] subclass that creates a [MateoHeroPageRoute] for hero transitions
/// between screens.
///
/// ## What it provides
///
/// Using [MateoHeroPage] as the destination page in a navigation operation
/// enables:
///
///  * **Transparent route compositing** — the source route stays visible
///    beneath the hero flight overlay, so the shared element can be seen
///    moving across the original background.
///  * **Reduced-motion support** — when [MediaQuery.disableAnimationsOf]
///    reports `true`, both [transitionDuration] and
///    [reverseTransitionDuration] are overridden to [Duration.zero],
///    disabling all hero animations and showing the destination immediately.
///
/// ## Usage
///
/// Use [MateoHeroPage] in your `pageBuilder` callback:
///
/// ```dart
/// Navigator.of(context).push(
///   PageRouteBuilder(
///     pageBuilder: (context, animation, secondaryAnimation) =>
///         MateoHeroPage(
///           builder: (_) => const DetailScreen(item: item),
///         ),
///   ),
/// );
/// ```
///
/// Or with [showGeneralDialog] / [Navigator.push]:
///
/// ```dart
/// Navigator.of(context).push(
///   MateoHeroPageRoute(
///     builder: (_) => const DetailScreen(item: item),
///     transitionDuration: const Duration(milliseconds: 560),
///     reverseTransitionDuration: const Duration(milliseconds: 430),
///   ),
/// );
/// ```
///
/// See also:
///  * [MateoHeroPageRoute], the route created by this page that manages hero
///    animations and the interactive-pop API.
///  * [MateoHero], the hero widget that flies between the source route and
///    this page.
class MateoHeroPage extends Page<void> {
  /// Creates a [MateoHeroPage].
  ///
  /// The [builder] is called by [MateoHeroPageRoute.buildPage] to produce the
  /// destination content.
  const MateoHeroPage({
    required this.builder,
    this.transitionDuration = defaultTransitionDuration,
    this.reverseTransitionDuration = defaultReverseTransitionDuration,
    super.key,
  });

  @visibleForTesting
  static const defaultTransitionDuration = Duration(milliseconds: 560);

  @visibleForTesting
  static const defaultReverseTransitionDuration = Duration(milliseconds: 430);

  /// Called by [MateoHeroPageRoute] to build the page content.
  ///
  /// The [BuildContext] is the route's context and has access to [Navigator],
  /// [MediaQuery], and [MateoHeroPageRoute.maybeOf].
  final WidgetBuilder builder;

  /// The duration of the forward hero transition.
  ///
  /// Automatically overridden to [Duration.zero] when
  /// [MediaQuery.disableAnimationsOf] returns `true`.
  final Duration transitionDuration;

  /// The duration of the reverse hero transition (pop).
  ///
  /// Automatically overridden to [Duration.zero] when
  /// [MediaQuery.disableAnimationsOf] returns `true`.
  final Duration reverseTransitionDuration;

  @override
  Route<void> createRoute(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return MateoHeroPageRoute(
      builder: builder,
      transitionDuration: disableAnimations
          ? Duration.zero
          : transitionDuration,
      reverseTransitionDuration: disableAnimations
          ? Duration.zero
          : reverseTransitionDuration,
      settings: this,
    );
  }
}
