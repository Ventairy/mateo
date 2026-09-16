import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mateo_mobile_old/src/components/mateo_button/mateo_button.dart';
import 'package:mateo_mobile_old/src/components/mateo_tap/mateo_tap.dart';
import 'package:mateo_mobile_old/src/foundation/mateo_elevation.dart';
import 'package:mateo_mobile_old/src/theme/mateo_color_scheme/mateo_color_scheme.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile_old/src/theme/mateo_typography.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

part '_mateo_menu_route.dart';
part '_mateo_menu_session.dart';
part 'mateo_menu_item.dart';
part 'mateo_menu_item_state.dart';
part 'mateo_menu_presentation.dart';
part 'presentations/_mateo_action_menu_presentation/_mateo_action_menu_content.dart';
part 'presentations/_mateo_action_menu_presentation/_mateo_action_menu_item.dart';
part 'presentations/_mateo_action_menu_presentation/_mateo_action_menu_layout.dart';
part 'presentations/_mateo_action_menu_presentation/_mateo_action_menu_presentation.dart';
part 'presentations/_mateo_action_menu_presentation/_render_mateo_action_menu_layout.dart';
part 'presentations/_mateo_context_menu_presentation/_mateo_context_menu_content.dart';
part 'presentations/_mateo_context_menu_presentation/_mateo_context_menu_content_layout.dart';
part 'presentations/_mateo_context_menu_presentation/_mateo_context_menu_item.dart';
part 'presentations/_mateo_context_menu_presentation/_mateo_context_menu_layout.dart';
part 'presentations/_mateo_context_menu_presentation/_mateo_context_menu_presentation.dart';
part 'presentations/_mateo_context_menu_presentation/_mateo_context_menu_reveal_transition.dart';
part 'presentations/_mateo_context_menu_presentation/_render_mateo_context_menu_content_layout.dart';
part 'presentations/_mateo_context_menu_presentation/_render_mateo_context_menu_layout.dart';
part 'presentations/_mateo_context_menu_presentation/_render_mateo_context_menu_reveal_transition.dart';

/// A Mateo button that opens a short action or context menu.
///
/// Uses [MateoButton] for its trigger and [menuPresentation] for its opening interaction.
/// The menu owns its appearance independently through [menuPresentation].
/// Menus do not scroll; supply a short item list that fits the available space.
///
/// Tapping the scrim, pressing system Back, or pressing Escape closes the menu.
/// Selecting an enabled item also starts closing and passes that item a
/// future that completes when the button has been restored.
///
/// The [items] list must contain at least one item. It is copied when this
/// widget is created and snapshotted again for each open session.
///
/// ```dart
/// MateoMenuButton(
///   menuPresentation: const MateoMenuPresentation.action(),
///   buttonPresentation: const MateoButtonPresentation.label(
///     label: 'More',
///     variant: MateoButtonVariant.secondary,
///   ),
///   items: [
///     MateoMenuItem(
///       title: 'Duplicate',
///       onPressed: (closeAnimation) async {
///         await closeAnimation;
///       },
///     ),
///   ],
/// )
/// ```
///
/// See also:
///  * [MateoMenuItem], the content and behavior of one menu item.
///  * [MateoButton], the trigger used by this component.
class MateoMenuButton extends StatefulWidget {
  /// Creates a Mateo menu button.
  ///
  /// The [items] list must not be empty. Button presentation properties are
  /// forwarded to the internal [MateoButton].
  MateoMenuButton({
    required List<MateoMenuItem> items,
    required this.buttonPresentation,
    required this.menuPresentation,
    super.key,
  }) : assert(
         items.isNotEmpty,
         'MateoMenuButton requires at least one item.',
       ),
       items = List<MateoMenuItem>.unmodifiable(items);

  /// Items shown in the open menu in their supplied order.
  final List<MateoMenuItem> items;

  /// Reusable content, color, spacing, and layout for the trigger button.
  final MateoButtonPresentation buttonPresentation;

  /// Independent appearance, spacing, and sizing of the menu.
  final MateoMenuPresentation menuPresentation;

  @override
  State<MateoMenuButton> createState() => _MateoMenuButtonState();
}

class _MateoMenuButtonState extends State<MateoMenuButton> {
  final _triggerFocus = FocusNode(debugLabel: 'MateoMenuButton trigger');
  final ValueNotifier<Rect> _triggerBounds = ValueNotifier(Rect.zero);
  _MateoMenuRoute? _route;
  FocusNode? _previousFocus;
  ModalRoute<void>? _sourceRoute;

  Object get _morphTag => _morphTagValue;
  final _morphTagValue = Object();
  late final MorphTarget _morphTarget = MorphTarget(tag: _morphTag);

  Rect _measureTrigger() {
    final trigger = context.findRenderObject()! as RenderBox;
    final overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final bounds = trigger.localToGlobal(Offset.zero, ancestor: overlay) & trigger.size;
    return MateoButton.surfaceRect(widget.buttonPresentation, bounds);
  }

  void _open() {
    if (_route != null) return;
    final navigator = Navigator.of(context);
    _triggerBounds.value = _measureTrigger();
    _previousFocus = FocusManager.instance.primaryFocus;
    _sourceRoute = ModalRoute.of(context);
    final route = _MateoMenuRoute(
      items: widget.items,
      presentation: widget.menuPresentation,
      triggerBounds: _triggerBounds,
      morphTag: _morphTag,
      barrierColor: widget.menuPresentation._barrierColor(context),
      textDirection: Directionality.of(context),
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      disableAnimations: MediaQuery.disableAnimationsOf(context),
    );
    setState(() => _route = route);
    navigator.push<void>(route);
    _trackTrigger(route);
    unawaited(
      route.completed.whenComplete(() {
        if (!mounted || !identical(_route, route)) return;
        setState(() => _route = null);
        _restoreFocus();
      }),
    );
  }

  void _trackTrigger(_MateoMenuRoute route) {
    // Observe frames without scheduling new ones while the trigger is still.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !identical(_route, route) || route.navigator == null) return;
      _triggerBounds.value = _measureTrigger();
      _trackTrigger(route);
    });
  }

  void _restoreFocus() {
    final focus = _previousFocus;
    final sourceRoute = _sourceRoute;
    _previousFocus = null;
    _sourceRoute = null;
    if (focus?.context != null && (sourceRoute == null || sourceRoute.isCurrent)) focus!.requestFocus();
  }

  void _removeMenu() {
    final route = _route;
    _route = null;
    if (route != null) route.navigator?.removeRoute(route);
    _restoreFocus();
  }

  Widget _buildTrigger(_MateoMenuRoute? route) {
    final child = MateoButton(
      presentation: widget.buttonPresentation,
      onPressed: _open,
    );
    final presentation = widget.menuPresentation;
    return MateoButtonScope(
      backgroundBuilder: (buttonState, buttonChild) => Morph(
        key: const ValueKey('mateo_menu_button_source_surface'),
        target: _morphTarget,
        duration: presentation._openDuration,
        curve: presentation._openCurve,
        onReceived: route?.sourceReturned,
        child: Container(
          key: const ValueKey('mateo_menu_button_source_background'),
          decoration: BoxDecoration(
            color: buttonState.backgroundColor,
            borderRadius: buttonState.borderRadius,
            boxShadow: MateoElevation.toShadows(
              elevation: buttonState.elevation,
              palette: context.mateo.palette,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: MorphDescendant(
            flightBehavior: MorphDescendantFlightBehavior.snapshot,
            child: buttonChild,
          ),
        ),
      ),
      child: child,
    );
  }

  @override
  void didUpdateWidget(MateoMenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!Widget.canUpdate(oldWidget.menuPresentation, widget.menuPresentation)) _removeMenu();
  }

  @override
  void dispose() {
    _removeMenu();
    _triggerBounds.dispose();
    _triggerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final route = _route;
    return Focus(
      focusNode: _triggerFocus,
      child: Semantics(
        key: const Key('mateo_menu_button_source_semantics'),
        expanded: route != null,
        child: ExcludeSemantics(
          excluding: route != null,
          child: IgnorePointer(
            ignoring: route != null,
            child: _buildTrigger(route),
          ),
        ),
      ),
    );
  }
}
