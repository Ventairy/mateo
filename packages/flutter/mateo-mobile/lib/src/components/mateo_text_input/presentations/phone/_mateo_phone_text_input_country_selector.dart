part of '../../mateo_text_input.dart';

class _MateoPhoneTextInputCountrySelector extends StatefulWidget {
  const _MateoPhoneTextInputCountrySelector({
    required this.country,
    required this.size,
    required this.textStyle,
    required this.onChanged,
  });

  final Country country;
  final MateoTextInputSize size;
  final TextStyle textStyle;
  final ValueChanged<Country>? onChanged;

  @override
  State<_MateoPhoneTextInputCountrySelector> createState() => _MateoPhoneTextInputCountrySelectorState();
}

class _MateoPhoneTextInputCountrySelectorState extends State<_MateoPhoneTextInputCountrySelector> {
  static const _disabledFlagOpacity = 0.65;
  static const _flagCallingCodeGap = 6.0;
  static const _callingCodeTrailingPadding = 4.0;

  Future<void> _showCountryPicker() async {
    final query = ValueNotifier('');
    Country? selectedCountry;

    try {
      selectedCountry = await showMateoSheet<Country>(
        context: context,
        avoidBottomInset: true,
        shouldDismiss: (source) => source != .drag && source != .tapOutside,
        view: MateoSheetView(
          header: MateoSheetViewHeader(
            presentation: .custom(
              principal: Builder(
                builder: (context) => MateoTextInput(
                  autofocus: true,
                  placeholder: mateoTranslationsOf(context).textInput.phone.searchCountries,
                  presentation: const .search(variant: MateoTextInputVariant.filled, size: .small),
                  onChanged: (value) => query.value = value,
                ),
              ),
              trailing: Builder(
                builder: (context) => MateoButton(
                  presentation: .icon(
                    icon: const MateoIcon(.cross),
                    variant: .primary.base,
                    semanticLabel: mateoTranslationsOf(context).textInput.phone.closeCountryPickerAccessibilityLabel,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
          surface: MateoSheetViewSurface(
            edgeEffect: .fade(),
            child: _MateoPhoneCountryPicker(
              selectedCountry: widget.country,
              query: query,
            ),
          ),
        ),
      );
    } finally {
      query.dispose();
    }

    if (!mounted || selectedCountry == null) return;
    widget.onChanged?.call(selectedCountry);
  }

  @override
  Widget build(BuildContext context) {
    final countryName = widget.country.displayName(Localizations.localeOf(context));
    final translations = mateoTranslationsOf(context).textInput.phone;

    return TextFieldTapRegion(
      child: MateoPress(
        semanticLabel: translations.changeCountryAccessibilityLabel(country: countryName),
        onPressed: widget.onChanged != null ? (_) => _showCountryPicker() : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: widget.size.height, minWidth: 48),
          child: Row(
            mainAxisSize: .min,
            children: [
              Opacity(
                opacity: widget.onChanged == null ? _disabledFlagOpacity : 1,
                child: MateoCountryFlag(country: widget.country, size: widget.size.leadingIconSize),
              ),
              const SizedBox(width: _flagCallingCodeGap),
              Padding(
                padding: const EdgeInsets.only(right: _callingCodeTrailingPadding),
                child: Text('+${widget.country.callingCode}', style: widget.textStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
