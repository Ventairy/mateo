import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

/// Opens a details page with Mateo's complete route integration.
void openDetails(BuildContext context, Widget details) {
  Navigator.of(context).push(
    MateoPage<void>(transition: const .wash(), child: details).createRoute(context),
  );
}

/// A route that uses Mateo motion with application-owned navigation behavior.
///
/// This example supports programmatic navigation. Applications adding interactive
/// back gestures must connect them to the route's gesture lifecycle themselves.
/// MateoPage already provides that integration for its supported gestures.
class ExamplePageRoute<T> extends PageRoute<T> {
  /// Creates an application-owned route for [child].
  ExamplePageRoute({
    required this.child,
    required this.transition,
    required this.disableAnimations,
    super.settings,
  }) : _builder = MateoPageTransitionsBuilder(transition: transition);

  /// The page content.
  final Widget child;

  /// The Mateo transition configuration.
  final MateoPageTransition transition;

  /// Whether the route should use immediate presentation.
  ///
  /// Supply MediaQuery.disableAnimationsOf(context) when constructing the route.
  final bool disableAnimations;

  final MateoPageTransitionsBuilder _builder;

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => disableAnimations ? .zero : _builder.transitionDuration;

  @override
  Duration get reverseTransitionDuration => disableAnimations ? .zero : _builder.reverseTransitionDuration;

  @override
  DelegatedTransitionBuilder? get delegatedTransition => _builder.delegatedTransition;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      Semantics(scopesRoute: true, explicitChildNodes: true, child: child);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => _builder.buildTransitions(this, context, animation, secondaryAnimation, child);
}
