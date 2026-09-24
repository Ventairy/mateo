part of '../../mateo_menu.dart';

class _MateoMenuOptionsPresentationRow extends StatelessWidget {
  const _MateoMenuOptionsPresentationRow({
    required this.item,
    required this.density,
    required this.topInset,
    required this.bottomInset,
    required this.textStyles,
    required this.leadingColor,
    required this.singleLineHeight,
    required this.onPressed,
  });

  final MateoMenuOptionsPresentationItem item;
  final MateoMenuDensity density;
  final double topInset;
  final double bottomInset;
  final ({TextStyle principal, TextStyle supporting}) textStyles;
  final Color leadingColor;
  final double? singleLineHeight;
  final FutureOr<void> Function()? onPressed;

  static const double _supportingGap = 2;

  double get _minimumHeight => switch (density) {
    .compact => 48,
    .standard => 56,
  };

  double get _leadingGap => switch (density) {
    .compact => 12,
    .standard => 16,
  };

  double get _trailingPadding =>
      density.horizontalPadding +
      switch (density) {
        .compact => 12,
        .standard => 16,
      };

  double get _iconSize => switch (density) {
    .compact => 30,
    .standard => 38,
  };

  double get _iconSizeWithBackground => switch (density) {
    .compact => 34,
    .standard => 48,
  };

  @override
  Widget build(BuildContext context) {
    return MateoPress(
      animation: .scaleFade,
      onPressed: onPressed == null ? null : (_) => onPressed!(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 48, minHeight: _minimumHeight + topInset + bottomInset),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            density.horizontalPadding,
            topInset,
            _trailingPadding,
            bottomInset,
          ),
          child: Opacity(
            opacity: onPressed == null ? 0.5 : 1,
            child: _MateoMenuOptionsRow(
              hasSupporting: item.supporting != null,
              singleLineHeight: singleLineHeight,
              children: [
                if (item.leading != null)
                  MateoIconScope(
                    size: _iconSize,
                    sizeWithBackground: _iconSizeWithBackground,
                    color: leadingColor,
                    child: item.leading!,
                  ),
                if (item.leading != null && (item.principal != null || item.supporting != null))
                  SizedBox(width: _leadingGap),
                if (item.principal != null || item.supporting != null)
                  Expanded(
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .start,
                      children: [
                        if (item.principal != null)
                          DefaultTextStyle(
                            style: textStyles.principal,
                            textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
                            child: item.principal!,
                          ),
                        if (item.principal != null && item.supporting != null) const SizedBox(height: _supportingGap),
                        if (item.supporting != null)
                          DefaultTextStyle(
                            style: textStyles.supporting,
                            textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: item.principal != null,
                            ),
                            child: item.supporting!,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
