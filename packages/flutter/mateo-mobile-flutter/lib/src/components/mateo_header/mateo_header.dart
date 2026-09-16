/// @docImport '../mateo_view.dart';
library;

import 'dart:math' as math;

import 'package:flutter/foundation.dart' show defaultTargetPlatform, immutable, internal;
import 'package:flutter/rendering.dart'
    show
        BoxHitTestResult,
        BoxParentData,
        ChildLayoutHelper,
        ChildLayouter,
        PaintingContext,
        PipelineOwner,
        RenderProxyBox,
        TransformLayer;
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile_old/src/theme/mateo_typography.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

part '_mateo_header_scroll_observer.dart';
part '_mateo_header_presentation_scope.dart';
part 'presentations/_mateo_header_standalone_presentation/_mateo_header_standalone_presentation.dart';
part 'presentations/_mateo_header_standalone_presentation/_mateo_header_boundary_fade.dart';
part 'presentations/_mateo_header_standalone_presentation/_mateo_header_boundary_reveal.dart';
part 'presentations/_mateo_header_standalone_presentation/_mateo_header_standalone_content.dart';
part 'presentations/_mateo_header_standalone_presentation/_mateo_header_standalone_slot.dart';
part 'presentations/_mateo_header_standalone_presentation/_render_mateo_header_boundary_reveal.dart';
part 'presentations/_mateo_header_standalone_presentation/_render_mateo_header_standalone_content.dart';
part 'presentations/_mateo_header_view_presentation/_mateo_header_view_presentation.dart';
part 'presentations/_mateo_header_view_presentation/_mateo_header_view_content.dart';
part 'presentations/_mateo_header_view_presentation/_mateo_header_view_slot.dart';
part 'presentations/_mateo_header_view_presentation/_render_mateo_header_view_content.dart';
part 'mateo_header_connection.dart';
part 'mateo_header_presentation.dart';
part 'mateo_header_scope.dart';

/// A compact Mateo header that floats above moving view content.
///
/// The [presentation] declares whether the header coordinates with a Mateo view
/// or owns its safe-area placement, padding, scroll position, and top edge fade.
///
/// With [MateoHeaderPresentation.view], a [MateoView] owns safe-area placement
/// and slot spacing. Its surface supplies the managed scroll position and owns
/// the boundary effect beneath the fixed header. Custom header widgets receive
/// the same view coordination.
///
/// ## Accessibility
///
/// The title is exposed as a semantic header. Android also announces it as the
/// route name, while iOS keeps the platform's navigation announcement
/// behavior. The optional controls in [presentation] own their labels and
/// action semantics.
///
/// ```dart
/// const MateoHeader(
///   presentation: MateoHeaderPresentation.view(
///     title: Text('Location'),
///     leading: MyBackButton(),
///     trailing: MyActions(),
///   ),
/// )
/// ```
///
/// See also:
///  * [MateoView], the full-bleed view with a fixed header slot.
///  * [MateoHeaderPresentation.standalone], the presentation for a header that
///    owns its placement and top boundary effect.
class MateoHeader extends StatefulWidget {
  /// Creates the compact header described by [presentation].
  ///
  /// The [presentation] establishes the header's controls, title alignment,
  /// layout, and scroll coordination.
  ///
  /// The inherited [Widget.key] controls this header's identity in the widget
  /// tree.
  const MateoHeader({
    required this.presentation,
    super.key,
  });

  /// The header's complete visual and scroll-coordination configuration.
  final MateoHeaderPresentation presentation;

  /// The state that connects the header to its scroll position.
  @override
  State<MateoHeader> createState() => _MateoHeaderState();
}

class _MateoHeaderState extends State<MateoHeader> {
  final _scroll = _MateoHeaderScrollObserver();
  MateoHeaderConnection? _viewConnection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _connectToViewAndScroll();
  }

  @override
  void didUpdateWidget(MateoHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    _connectToViewAndScroll();
  }

  void _connectToViewAndScroll() {
    final scope = widget.presentation._isView ? MateoHeaderScope.maybeOf(context) : null;
    if (widget.presentation._isView && scope == null) {
      throw FlutterError.fromParts([
        ErrorSummary('MateoHeaderPresentation.view() requires a Mateo view.'),
        ErrorDescription(
          'Place this MateoHeader in the header slot of MateoView, or use '
          'MateoHeaderPresentation.standalone().',
        ),
      ]);
    }

    final controller = scope?.managedScrollController ?? widget.presentation._scrollController;
    _scroll.observe(controller, controller == null ? null : ScrollNotificationObserver.maybeOf(context));
    if (!identical(_viewConnection, scope?.connection)) {
      _viewConnection?._disconnect(_scroll);
      _viewConnection = scope?.connection;
      _viewConnection?._connect(_scroll);
    }
  }

  @override
  void deactivate() {
    _viewConnection?._disconnect(_scroll);
    _viewConnection = null;
    super.deactivate();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _MateoHeaderPresentationScope(
    scroll: _scroll,
    child: widget.presentation,
  );
}
