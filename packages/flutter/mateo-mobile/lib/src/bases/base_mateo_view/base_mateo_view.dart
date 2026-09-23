import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../../foundation/mateo_elevation.dart';
import '../../foundation/mateo_navigator_observer.dart';
import '../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';
import '../../foundation/mateo_sheet_to_view_transition/mateo_sheet_to_view_transition.dart';
import '../../foundation/mateo_view_animation/mateo_view_animation.dart';
import '../../theme/mateo_theme.dart';
import '../base_mateo_surface/mateo_surface_obstruction.dart';
import '../base_mateo_transform/base_mateo_transform.dart';
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
    this.surfacePresentation = const (
      color: null,
      elevation: null,
      shape: MateoRoundedShapeBorder(radius: 0),
    ),
    this.reserveHeaderSpace = true,
    this.avoidBottomInset = false,
    this.maintainBottomViewPadding = false,
    this.padding,
    this.header,
    this.footer,
    this.overlay,
    this.animation,
    super.key,
  });

  final EdgeInsetsGeometry? padding;
  final bool fitHeight;
  final bool avoidBottomInset;
  final bool maintainBottomViewPadding;
  final bool reserveHeaderSpace;
  final Widget surface;
  final ({
    Color? color,
    MateoElevation? elevation,
    MateoRoundedShapeBorder shape,
  })
  surfacePresentation;
  final Widget? header;
  final Widget? footer;
  final Widget? overlay;
  final MateoViewAnimation? animation;

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
    if (oldWidget.footer != null && widget.footer != null && !Widget.canUpdate(oldWidget.footer!, widget.footer!)) {
      final previousFooter = _layoutData.footer;
      _layoutData.footer = null;
      previousFooter?.dispose();
    }
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
    _layoutData
      ..updateBottomSafeAreaPadding(
        widget.maintainBottomViewPadding
            ? MediaQuery.maybeViewPaddingOf(context)?.bottom ?? 0
            : MediaQuery.maybePaddingOf(context)?.bottom ?? 0,
      )
      ..updateBottomInset(widget.avoidBottomInset ? MediaQuery.maybeViewInsetsOf(context)?.bottom ?? 0 : 0);
    MediaQuery.maybeSizeOf(context);
    MediaQuery.maybeDevicePixelRatioOf(context);

    final fitHeight = widget.fitHeight;
    final resolvedPadding = padding.resolve(Directionality.of(context));
    final surfaceColor = widget.surfacePresentation.color ?? MateoTheme.of(context).colorScheme.background;

    return MateoViewScope(
      child: MateoViewLayoutScope._(
        fitHeight: fitHeight,
        reserveHeaderSpace: widget.reserveHeaderSpace,
        padding: resolvedPadding,
        layout: _layoutData,
        child: _buildPresentation(
          context,
          surfaceColor: surfaceColor,
        ),
      ),
    );
  }

  Widget _buildPresentation(
    BuildContext context, {
    required Color surfaceColor,
  }) {
    final navigator = Navigator.maybeOf(context);
    final observer = navigator == null ? null : MorphNavigatorObserver.maybeOfNavigator(navigator);
    final automaticTarget = observer is MateoNavigatorObserver ? observer.sheetToViewMorphTarget : null;
    // Automatic flights retain content pixels while the covered view is not
    // interactive. Keep geometry and keyboard-driven clearance live at handoff.
    final content = MorphDescendant(
      key: const ValueKey('Mateo view transform content'),
      flightBehavior: .snapshot(changes: automaticTarget != null ? _layoutData : null),
      child: _buildContent(),
    );
    final shape = widget.surfacePresentation.shape;
    final presentation = DecoratedBox(
      decoration: ShapeDecoration(
        shape: shape,
        shadows: widget.surfacePresentation.elevation == null || widget.surfacePresentation.elevation!.level == 0
            ? const []
            : widget.surfacePresentation.elevation!.toShadowList(
                palette: MateoTheme.of(context).palette,
              ),
      ),
      child: Stack(
        fit: .passthrough,
        clipBehavior: .none,
        children: [
          Positioned.fill(
            child: _clipBackground(
              context,
              shape: shape,
              child: ColoredBox(color: surfaceColor),
            ),
          ),
          content,
        ],
      ),
    );
    return _buildTransform(
      context,
      presentation: presentation,
      content: content,
      color: surfaceColor,
      shape: shape,
      automaticTarget: automaticTarget,
    );
  }

  Widget _buildTransform(
    BuildContext context, {
    required Widget presentation,
    required Widget content,
    required Color color,
    required MateoRoundedShapeBorder shape,
    required MorphTarget? automaticTarget,
  }) {
    final candidates = <BaseMateoTransformCandidate>[
      if (automaticTarget != null)
        BaseMateoTransformCandidate.view(
          target: automaticTarget,
          shape: kSheetToViewTransformAnimation.shape?.border ?? shape,
          contentEffects: kSheetToViewTransformAnimation.contentEffects,
        ),
      ...switch (widget.animation) {
        null => <BaseMateoTransformCandidate>[],
        MateoViewAnimationTransform(
          :final target,
          shape: final animationShape,
          :final contentEffects,
        ) =>
          [
            BaseMateoTransformCandidate.view(
              target: BaseMateoTransformTargets(target).viewToView,
              shape: animationShape?.border ?? shape,
              contentEffects: contentEffects,
            ),
            BaseMateoTransformCandidate.view(
              target: BaseMateoTransformTargets(target).surfaceToView,
              shape: animationShape?.border ?? shape,
              contentEffects: contentEffects,
            ),
          ],
      },
    ];
    if (candidates.isEmpty) return presentation;

    return BaseMateoTransform(
      color: color,
      content: content,
      candidates: candidates,
      canMatch: (target, match) {
        if (automaticTarget == null || identical(target, automaticTarget)) {
          return true;
        }
        return !(automaticTarget.canMatch?.call(match) ?? false);
      },
      child: presentation,
    );
  }

  Widget _buildContent() {
    return _MateoViewLayout(
      layout: _layoutData,
      fitHeight: widget.fitHeight,
      reserveHeaderSpace: widget.reserveHeaderSpace,
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
          child: widget.footer == null ? const SizedBox.shrink() : _buildFooter(),
        ),
        if (widget.overlay case final overlay?)
          LayoutId(
            id: _MateoViewSlot.overlay,
            child: PrimaryScrollController.none(child: overlay),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    // Only the footer's safe-area owner receives the maintained padding.
    // Restore ambient media for authored content and keep its subtree stable.
    return Builder(
      builder: (context) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: widget.maintainBottomViewPadding
              ? media.copyWith(padding: media.padding.copyWith(bottom: media.viewPadding.bottom))
              : media,
          child: MaybeSafeArea(
            top: false,
            handle: _layoutData.footer!.safeAreaHandle,
            child: MediaQuery(data: media, child: widget.footer!),
          ),
        );
      },
    );
  }

  Widget _clipBackground(
    BuildContext context, {
    required MateoRoundedShapeBorder shape,
    required Widget child,
  }) {
    if (shape == const MateoRoundedShapeBorder(radius: 0)) {
      return ClipRect(child: child);
    }
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: shape,
        textDirection: Directionality.maybeOf(context),
      ),
      child: child,
    );
  }
}
