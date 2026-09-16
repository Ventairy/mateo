part of '../mateo_view.dart';

final class _MateoViewFrame extends StatefulWidget {
  const _MateoViewFrame({
    required this.surface,
    required this.header,
    required this.footer,
    required this.overlay,
    required this.padding,
    required this.keyboardViewportBehavior,
    required this.reserveLeadingExtent,
    required this.reserveTrailingExtent,
    this.managedScrollController,
  });

  final MateoSurface surface;
  final Widget? header;
  final Widget? footer;
  final Widget? overlay;
  final EdgeInsetsGeometry? padding;
  final MateoSurfaceKeyboardViewportBehavior keyboardViewportBehavior;
  final bool reserveLeadingExtent;
  final bool reserveTrailingExtent;
  final ScrollController? managedScrollController;

  @override
  State<_MateoViewFrame> createState() => _MateoViewFrameState();
}

class _MateoViewFrameState extends State<_MateoViewFrame> {
  final GlobalKey _viewKey = GlobalKey();
  late final MateoHeaderConnection _headerConnection = MateoHeaderConnection(onFadeChanged: _ignoreHeaderFadeChange);
  _MateoViewSafeAreaGeometry? _safeAreaGeometry;
  _MateoViewSafeAreaGeometry? _paintSafeAreaGeometry;
  _MateoViewSafeAreaGeometry? _pendingSafeAreaGeometry;
  bool _safeAreaUpdateScheduled = false;

  void _ignoreHeaderFadeChange() {}

  void _handleSafeAreaGeometryChanged(
    _MateoViewSafeAreaGeometry geometry,
  ) {
    _paintSafeAreaGeometry = geometry;
    final current = _safeAreaGeometry;
    if (current?.inputs == geometry.inputs &&
        current?.insets == geometry.insets &&
        current?.bottomKeyboardInset == geometry.bottomKeyboardInset) {
      return;
    }
    _pendingSafeAreaGeometry = geometry;
    if (_safeAreaUpdateScheduled) return;
    _safeAreaUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _safeAreaUpdateScheduled = false;
      final pending = _pendingSafeAreaGeometry;
      _pendingSafeAreaGeometry = null;
      if (!mounted || pending == null) return;
      final resolved = _safeAreaGeometry;
      if (resolved?.inputs == pending.inputs &&
          resolved?.insets == pending.insets &&
          resolved?.bottomKeyboardInset == pending.bottomKeyboardInset) {
        return;
      }
      setState(() => _safeAreaGeometry = pending);
    });
  }

  _MateoViewSafeAreaGeometry? _geometryForInputs(
    _MateoViewSafeAreaInputs inputs,
  ) {
    final resolved = _safeAreaGeometry;
    if (resolved == null) return null;
    if (resolved.inputs == inputs) return resolved;
    if (resolved.inputs.viewSize != inputs.viewSize) return null;
    return _MateoViewSafeAreaGeometry.resolve(
      inputs: inputs,
      viewBounds: resolved.viewBounds,
    );
  }

  EdgeInsets _effectiveSafeInsets({
    required _MateoViewSafeAreaInputs inputs,
    required bool fillsView,
  }) {
    if (fillsView) return inputs.availableInsets;
    final resolved = _geometryForInputs(inputs);
    return EdgeInsets.only(
      top: resolved?.insets.top ?? 0,
      bottom: resolved?.insets.bottom ?? 0,
    );
  }

  double _effectiveKeyboardInset({
    required _MateoViewSafeAreaInputs inputs,
    required bool fillsView,
  }) {
    if (fillsView) return inputs.viewInsets.bottom;
    return _geometryForInputs(inputs)?.bottomKeyboardInset ?? 0;
  }

  EdgeInsets _effectivePaintSafeInsets({
    required _MateoViewSafeAreaInputs inputs,
    required EdgeInsets layoutInsets,
    required double layoutKeyboardInset,
    required bool fillsView,
  }) {
    if (fillsView) {
      return EdgeInsets.only(
        top: layoutInsets.top,
        bottom: layoutInsets.bottom + layoutKeyboardInset,
      );
    }
    final painted = _paintSafeAreaGeometry;
    return EdgeInsets.only(
      top: painted != null && painted.inputs.hasSameTopGeometryAs(inputs) ? painted.insets.top : layoutInsets.top,
      bottom: painted != null && painted.inputs.hasSameBottomGeometryAs(inputs)
          ? painted.insets.bottom + painted.bottomKeyboardInset
          : layoutInsets.bottom + layoutKeyboardInset,
    );
  }

  EdgeInsets _effectivePaddingOverridePaintInsets({
    required _MateoViewSafeAreaInputs inputs,
    required double layoutKeyboardInset,
    required bool fillsView,
  }) {
    if (fillsView) return EdgeInsets.only(bottom: layoutKeyboardInset);
    final painted = _paintSafeAreaGeometry;
    return EdgeInsets.only(
      bottom: painted != null && painted.inputs.hasSameBottomGeometryAs(inputs)
          ? painted.bottomKeyboardInset
          : layoutKeyboardInset,
    );
  }

  Widget _buildSlot({
    required BuildContext context,
    required Widget child,
    required bool top,
    required EdgeInsets layoutSafeInsets,
    required double layoutKeyboardInset,
    required _MateoViewSafeAreaInputs safeAreaInputs,
    required EdgeInsets? paddingOverride,
    required bool fillsView,
  }) {
    Widget slot = MediaQuery(
      data: MediaQuery.of(context)
          .removePadding(
            removeLeft: paddingOverride != null,
            removeTop: true,
            removeRight: paddingOverride != null,
            removeBottom: true,
          )
          .removeViewInsets(removeBottom: true),
      child: SafeArea(
        top: false,
        bottom: false,
        left: paddingOverride == null,
        right: paddingOverride == null,
        child: Padding(
          padding: paddingOverride == null
              ? top
                    ? MateoHeaderScope.contentPadding
                    : _MateoViewSlotSpacing.footerPadding
              : EdgeInsets.only(
                  left: paddingOverride.left,
                  right: paddingOverride.right,
                ),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
    if (top) {
      slot = MateoHeaderScope(
        connection: _headerConnection,
        managedScrollController: widget.managedScrollController,
        child: slot,
      );
    }
    return _MateoViewSafeAreaPaintCompensator(
      top: top,
      layoutInsets: EdgeInsets.only(
        top: layoutSafeInsets.top,
        bottom: layoutSafeInsets.bottom + layoutKeyboardInset,
      ),
      paintInsets: () => paddingOverride == null
          ? _effectivePaintSafeInsets(
              inputs: safeAreaInputs,
              layoutInsets: layoutSafeInsets,
              layoutKeyboardInset: layoutKeyboardInset,
              fillsView: fillsView,
            )
          : _effectivePaddingOverridePaintInsets(
              inputs: safeAreaInputs,
              layoutKeyboardInset: layoutKeyboardInset,
              fillsView: fillsView,
            ),
      child: PrimaryScrollController.none(child: slot),
    );
  }

  @override
  void dispose() {
    _headerConnection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final safeAreaInputs = _MateoViewSafeAreaInputs(
      viewSize: mediaQueryData.size,
      padding: mediaQueryData.padding,
      viewPadding: mediaQueryData.viewPadding,
      viewInsets: mediaQueryData.viewInsets,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutSize = constraints.biggest;
        final fillsView =
            layoutSize.width >= safeAreaInputs.viewSize.width && layoutSize.height >= safeAreaInputs.viewSize.height;
        final safeInsets = _effectiveSafeInsets(
          inputs: safeAreaInputs,
          fillsView: fillsView,
        );
        final keyboardInset = _effectiveKeyboardInset(
          inputs: safeAreaInputs,
          fillsView: fillsView,
        );
        final paddingOverride = widget.padding?.resolve(
          Directionality.of(context),
        );
        final layoutInsets = paddingOverride ?? safeInsets;
        final paintLayoutInsets = paddingOverride == null ? safeInsets : EdgeInsets.zero;
        return _MateoViewSafeAreaObserver(
          inputs: safeAreaInputs,
          onChanged: _handleSafeAreaGeometryChanged,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: CustomMultiChildLayout(
              key: _viewKey,
              delegate: _MateoViewLayoutDelegate(
                topSafeInset: layoutInsets.top,
                bottomSafeInset: layoutInsets.bottom,
                bottomInset: keyboardInset,
                keyboardViewportBehavior: widget.keyboardViewportBehavior,
                paddingOverride: paddingOverride,
                reserveLeadingExtent: widget.reserveLeadingExtent,
                reserveTrailingExtent: widget.reserveTrailingExtent,
              ),
              children: [
                LayoutId(
                  id: _MateoViewLayoutId.surface,
                  child: widget.surface,
                ),
                if (widget.header case final header?)
                  LayoutId(
                    id: _MateoViewLayoutId.header,
                    child: _buildSlot(
                      context: context,
                      child: header,
                      top: true,
                      layoutSafeInsets: paintLayoutInsets,
                      layoutKeyboardInset: keyboardInset,
                      safeAreaInputs: safeAreaInputs,
                      paddingOverride: paddingOverride,
                      fillsView: fillsView,
                    ),
                  ),
                if (widget.footer case final footer?)
                  LayoutId(
                    id: _MateoViewLayoutId.footer,
                    child: _buildSlot(
                      context: context,
                      child: footer,
                      top: false,
                      layoutSafeInsets: paintLayoutInsets,
                      layoutKeyboardInset: keyboardInset,
                      safeAreaInputs: safeAreaInputs,
                      paddingOverride: paddingOverride,
                      fillsView: fillsView,
                    ),
                  ),
                if (widget.overlay case final overlay?)
                  LayoutId(
                    id: _MateoViewLayoutId.overlay,
                    child: PrimaryScrollController.none(child: overlay),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
