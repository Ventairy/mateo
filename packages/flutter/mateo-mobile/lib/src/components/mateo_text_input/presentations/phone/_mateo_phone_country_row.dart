part of '../../mateo_text_input.dart';

class _MateoPhoneCountryRow extends StatelessWidget {
  const _MateoPhoneCountryRow({
    required this.country,
    required this.selected,
    this.name,
    this.onPressed,
  });

  static const _minimumHeight = 64.0;
  static const _flagSize = 42.0;
  static const _contentGap = 18.0;

  final Country country;
  final String? name;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = MateoTheme.of(context);
    final translations = mateoTranslationsOf(context).textInput.phone;
    final name = this.name;
    final content = MateoPress(
      semanticLabel: name == null
          ? null
          : selected
          ? translations.countrySelectedAccessibilityLabel(country: name)
          : '$name, +${country.callingCode}',
      animation: .scaleFade,
      onPressed: onPressed == null ? null : (_) => onPressed!(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _minimumHeight, minWidth: 48),
        child: Row(
          children: [
            MateoCountryFlag(country: country, size: _flagSize),
            const SizedBox(width: _contentGap),
            Expanded(
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  if (name == null)
                    SizedBox(
                      height: 20.625,
                      child: Align(
                        alignment: .centerLeft,
                        child: Container(
                          width: 110 + (country.index % 4) * 20,
                          height: 14,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.skeleton.bone,
                            borderRadius: const BorderRadius.all(Radius.circular(7)),
                          ),
                        ),
                      ),
                    )
                  else
                    Text(
                      name,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: TextStyle(
                        fontFamily: MateoTypography.fontFamily,
                        letterSpacing: MateoTypography.letterSpacing,
                        fontSize: 16.5,
                        height: 1.25,
                        fontWeight: .w600,
                        color: theme.colorScheme.text.primary,
                      ),
                    ),
                  Text(
                    '+${country.callingCode}',
                    style: TextStyle(
                      fontFamily: MateoTypography.fontFamily,
                      letterSpacing: MateoTypography.letterSpacing,
                      fontSize: 15,
                      height: 1.25,
                      fontWeight: .w500,
                      color: theme.colorScheme.text.tertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 12),
              MateoIcon(
                .checkmark,
                size: 26,
                color: theme.colorScheme.onAccent,
                backgroundColor: theme.colorScheme.accent,
              ),
              const SizedBox(width: 11),
            ],
          ],
        ),
      ),
    );
    if (name == null) return ExcludeSemantics(child: content);
    return Semantics(selected: selected, child: content);
  }
}
