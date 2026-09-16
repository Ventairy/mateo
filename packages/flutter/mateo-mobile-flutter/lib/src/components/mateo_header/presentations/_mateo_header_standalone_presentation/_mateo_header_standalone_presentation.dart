part of '../../mateo_header.dart';

@immutable
final class _MateoHeaderStandalonePresentation extends MateoHeaderPresentation {
  const _MateoHeaderStandalonePresentation({
    required this.title,
    this.leading,
    this.trailing,
    this.centerTitle = false,
    this.padding = _defaultPadding,
    this.scrollController,
  }) : super._();

  static const EdgeInsetsGeometry _defaultPadding = EdgeInsetsDirectional.only(start: 20, top: 12, end: 20);

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final bool centerTitle;
  final EdgeInsetsGeometry padding;
  final ScrollController? scrollController;

  @override
  bool get _isView => false;

  @override
  ScrollController? get _scrollController => scrollController;

  @override
  State<_MateoHeaderStandalonePresentation> createState() => _MateoHeaderStandalonePresentationState();
}

final class _MateoHeaderStandalonePresentationState extends State<_MateoHeaderStandalonePresentation> {
  @override
  Widget build(BuildContext context) {
    final inheritedTextStyle = DefaultTextStyle.of(context);
    final content = _MateoHeaderStandaloneContent(
      spacing: 16,
      centerTitle: widget.centerTitle,
      textDirection: Directionality.of(context),
      leading: widget.leading,
      trailing: widget.trailing,
      title: Semantics(
        namesRoute: switch (defaultTargetPlatform) {
          TargetPlatform.android || TargetPlatform.fuchsia || TargetPlatform.linux || TargetPlatform.windows => true,
          TargetPlatform.iOS || TargetPlatform.macOS => null,
        },
        header: true,
        child: DefaultTextStyle(
          key: const ValueKey('mateo_header_title'),
          textAlign: widget.centerTitle ? TextAlign.center : TextAlign.start,
          softWrap: inheritedTextStyle.softWrap,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textWidthBasis: inheritedTextStyle.textWidthBasis,
          textHeightBehavior: inheritedTextStyle.textHeightBehavior,
          style: inheritedTextStyle.style.merge(
            TextStyle(
              color: context.mateo.colorScheme.text.primary,
              fontFamily: MateoTypography.fontFamily,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: MateoTypography.letterSpacing,
            ),
          ),
          child: widget.title,
        ),
      ),
    );
    final maximumFadeExtent = _MateoHeaderBoundaryFade.resolveMaximumExtent(context);
    final scroll = _MateoHeaderPresentationScope.scrollOf(context);
    return SizedBox(
      width: double.infinity,
      child: Stack(
        key: const ValueKey('mateo_header_stack'),
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: maximumFadeExtent,
            child: SizedBox(
              key: const ValueKey('mateo_header_boundary_fade_maximum'),
              child: _MateoHeaderBoundaryReveal(
                key: const ValueKey('mateo_header_boundary_reveal'),
                repaint: scroll,
                maximumExtent: maximumFadeExtent,
                resolveExtent: scroll.resolveFadeExtent,
                child: _MateoHeaderBoundaryFade(
                  key: const ValueKey('mateo_header_boundary_fade'),
                  color: context.mateo.colorScheme.background,
                ),
              ),
            ),
          ),
          MaybeSafeArea(
            left: false,
            right: false,
            bottom: false,
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .removePadding(removeTop: true, removeBottom: true)
                  .removeViewInsets(removeBottom: true),
              child: SafeArea(
                top: false,
                bottom: false,
                child: Padding(
                  key: const ValueKey('mateo_header_content'),
                  padding: widget.padding,
                  child: content,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
