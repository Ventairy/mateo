part of '../mateo_toast.dart';

@immutable
final class _MateoInfoToastPresentation extends MateoToastPresentation {
  const _MateoInfoToastPresentation({this.iconBuilder}) : super._();

  final MateoToastIconBuilder? iconBuilder;

  static const double _iconSize = 30;
  static const double _iconTextGap = 12;
  static const double _contentPaddingLeft = 14;
  static const double _contentPaddingRight = 26;
  static const int _maxLines = 2;

  bool _isUsingTwoLines(
    BuildContext context,
    BoxConstraints constraints,
    TextStyle textStyle,
    String message,
  ) {
    if (!constraints.hasBoundedWidth) return false;

    final maxTextWidth = constraints.maxWidth - _iconSize - _iconTextGap - _contentPaddingLeft - _contentPaddingRight;
    if (maxTextWidth <= 0) return true;

    final textPainter = TextPainter(
      maxLines: _maxLines,
      text: TextSpan(text: message, style: textStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: maxTextWidth);

    final usesTwoLines = textPainter.computeLineMetrics().length > 1;
    textPainter.dispose();
    return usesTwoLines;
  }

  Widget _buildIcon(Color iconColor) {
    final iconBuilder = this.iconBuilder;
    if (iconBuilder != null) {
      return iconBuilder(
        MateoToastState(iconSize: _iconSize, iconColor: iconColor),
      );
    }

    return MateoIcon.circleInfo(
      key: const Key('mateo_toast_default_icon_info'),
      width: _iconSize,
      height: _iconSize,
      color: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final message = _MateoToastPresentationScope.messageOf(context);
    final colors = context.mateo.colorScheme.toast.info;
    final textStyle = TextStyle(
      color: colors.foreground,
      decoration: TextDecoration.none,
      fontFamily: MateoTypography.fontFamily,
      fontWeight: FontWeight.w600,
      letterSpacing: MateoTypography.letterSpacing,
      fontSize: 14.5,
    );
    final decoration = BoxDecoration(
      color: colors.background,
      borderRadius: const BorderRadius.all(Radius.circular(999)),
      boxShadow: MateoElevation.toShadows(elevation: 2, palette: context.mateo.palette),
    );

    return Semantics(
      liveRegion: true,
      label: message,
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final usesTwoLines = _isUsingTwoLines(
            context,
            constraints,
            textStyle,
            message,
          );

          return DecoratedBox(
            key: const Key('mateo_toast_surface'),
            decoration: decoration,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                usesTwoLines ? 18 : _contentPaddingLeft,
                _contentPaddingLeft,
                _contentPaddingRight,
                _contentPaddingLeft,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox.square(
                      key: const Key('mateo_toast_icon_box'),
                      dimension: _iconSize,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: _buildIcon(colors.icon),
                      ),
                    ),
                  ),
                  const SizedBox(width: _iconTextGap),
                  Flexible(
                    child: Text(
                      message,
                      key: const Key('mateo_toast_message'),
                      maxLines: _maxLines,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
