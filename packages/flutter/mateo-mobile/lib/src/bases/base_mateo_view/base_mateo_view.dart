import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart' show MaybeSafeArea, MaybeSafeAreaHandle;

import 'mateo_view_scope.dart';

part '_mateo_view_footer_layout_data.dart';
part '_mateo_view_header_layout_data.dart';
part '_mateo_view_layout.dart';
part '_mateo_view_layout_data.dart';
part '_mateo_view_slot.dart';
part '_render_mateo_view_layout.dart';
part 'mateo_view_layout_scope.dart';

@internal
class BaseMateoView extends StatefulWidget {
  const BaseMateoView({
    required this.surface,
    required this.fitHeight,
    this.padding,
    this.header,
    this.footer,
    this.overlay,
    super.key,
  });

  final EdgeInsetsGeometry? padding;
  final bool fitHeight;
  final Widget surface;
  final Widget? header;
  final Widget? footer;
  final Widget? overlay;

  @override
  State<BaseMateoView> createState() => _BaseMateoViewState();
}

class _BaseMateoViewState extends State<BaseMateoView> {
  final _layoutData = _MateoViewLayoutData();

  @override
  void initState() {
    super.initState();
    if (widget.header != null) _layoutData.header = .new();
    if (widget.footer != null) _layoutData.footer = .new();
  }

  @override
  void didUpdateWidget(covariant BaseMateoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.footer != null) {
      _layoutData.footer ??= .new();
    } else {
      _layoutData.footer?.dispose();
      _layoutData.footer = null;
    }

    if (widget.header != null) {
      _layoutData.header ??= .new();
    } else {
      _layoutData.header?.dispose();
      _layoutData.header = null;
    }
  }

  @override
  void dispose() {
    _layoutData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding =
        widget.padding ?? MateoViewScope.paddingOf(context) ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    assert(padding.isNonNegative, 'padding must be nonnegative.');

    // Safe-area render transforms can change without changing the header size.
    // Subscribe here as well so the surface refreshes its measured clearance.
    MediaQuery.maybePaddingOf(context);
    MediaQuery.maybeSizeOf(context);
    MediaQuery.maybeDevicePixelRatioOf(context);

    final fitHeight = widget.fitHeight;
    final resolvedPadding = padding.resolve(Directionality.of(context));

    return MateoViewScope(
      child: MateoViewLayoutScope._(
        fitHeight: fitHeight,
        padding: resolvedPadding,
        layout: _layoutData,
        child: _MateoViewLayout(
          padding: resolvedPadding,
          layout: _layoutData,
          fitHeight: fitHeight,
          children: [
            LayoutId(
              id: _MateoViewSlot.surface,
              child: widget.surface,
            ),
            LayoutId(
              id: _MateoViewSlot.header,
              child: widget.header == null
                  ? const SizedBox.shrink()
                  : MaybeSafeArea(
                      bottom: false,
                      handle: _layoutData.header!.safeAreaHandle,
                      child: widget.header,
                    ),
            ),
            LayoutId(
              id: _MateoViewSlot.footer,
              child: widget.footer == null
                  ? const SizedBox.shrink()
                  : MaybeSafeArea(
                      top: false,
                      handle: _layoutData.footer!.safeAreaHandle,
                      child: widget.footer,
                    ),
            ),
            if (widget.overlay case final overlay?)
              LayoutId(
                id: _MateoViewSlot.overlay,
                child: PrimaryScrollController.none(child: overlay),
              ),
          ],
        ),
      ),
    );
  }
}
