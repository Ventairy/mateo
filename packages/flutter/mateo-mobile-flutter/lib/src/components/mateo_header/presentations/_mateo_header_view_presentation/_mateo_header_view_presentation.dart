part of '../../mateo_header.dart';

@immutable
final class _MateoHeaderViewPresentation extends MateoHeaderPresentation {
  const _MateoHeaderViewPresentation({
    required this.title,
    this.leading,
    this.trailing,
    this.centerTitle = false,
    this.scrollController,
  }) : super._();

  static const EdgeInsetsGeometry _contentPadding = EdgeInsetsDirectional.only(start: 20, top: 12, end: 20);

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final bool centerTitle;
  final ScrollController? scrollController;

  @override
  bool get _isView => true;

  @override
  ScrollController? get _scrollController => scrollController;

  @override
  State<_MateoHeaderViewPresentation> createState() => _MateoHeaderViewPresentationState();
}

final class _MateoHeaderViewPresentationState extends State<_MateoHeaderViewPresentation> {
  @override
  Widget build(BuildContext context) {
    final inheritedTextStyle = DefaultTextStyle.of(context);
    return _MateoHeaderViewContent(
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
  }
}
