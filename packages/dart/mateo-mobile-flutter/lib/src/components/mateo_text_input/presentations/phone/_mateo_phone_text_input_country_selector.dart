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
  // Keep one locale's catalog available to other phone inputs in this process.
  static Locale? _sharedCatalogLocale;
  static _MateoPhoneCountryCatalog? _sharedCatalog;
  static Future<_MateoPhoneCountryCatalog>? _sharedCatalogFuture;
  bool _pickerOpeningOrOpen = false;
  bool _deferRoutePushForPress = false;
  int _pressGeneration = 0;
  Locale? _cachedCatalogLocale;
  Future<_MateoPhoneCountryCatalog>? _cachedCatalogFuture;
  bool _cachedCatalogReady = false;
  Locale? _scheduledCatalogLocale;

  static Future<_MateoPhoneCountryCatalog> _loadCatalog(Locale locale) =>
      Isolate.run(() => _MateoPhoneCountryPicker.createCatalog(locale));

  Future<_MateoPhoneCountryCatalog> _catalogFor(Locale locale) {
    if (_cachedCatalogLocale == locale) return _cachedCatalogFuture!;
    _cachedCatalogLocale = locale;
    final sharedCatalog = _sharedCatalogLocale == locale ? _sharedCatalog : null;
    final sharedFuture = _sharedCatalogLocale == locale ? _sharedCatalogFuture : null;
    _cachedCatalogReady = sharedCatalog != null;
    final future = _cachedCatalogFuture = sharedCatalog != null
        ? Future.value(sharedCatalog)
        : sharedFuture ?? _loadCatalog(locale);
    if (sharedCatalog == null && sharedFuture == null) {
      _sharedCatalogLocale = locale;
      _sharedCatalogFuture = future;
      _sharedCatalog = null;
      future
          .then<void>(
            (catalog) {
              if (!identical(_sharedCatalogFuture, future)) return;
              _sharedCatalog = catalog;
              _sharedCatalogFuture = null;
            },
            onError: (Object _, StackTrace _) {
              if (!identical(_sharedCatalogFuture, future)) return;
              _sharedCatalogLocale = null;
              _sharedCatalog = null;
              _sharedCatalogFuture = null;
            },
          )
          .ignore();
    }
    future
        .then<void>(
          (_) {
            if (identical(_cachedCatalogFuture, future)) _cachedCatalogReady = true;
          },
          onError: (Object _, StackTrace _) {
            if (!identical(_cachedCatalogFuture, future)) return;
            _cachedCatalogLocale = null;
            _cachedCatalogFuture = null;
            _cachedCatalogReady = false;
          },
        )
        .ignore();
    return future;
  }

  void _scheduleCatalogPreload() {
    if (widget.onChanged == null) return;
    final locale = Localizations.localeOf(Navigator.of(context).context);
    if (_scheduledCatalogLocale == locale) return;
    _scheduledCatalogLocale = locale;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.onChanged == null) return;
      final currentLocale = Localizations.localeOf(Navigator.of(context).context);
      if (currentLocale == locale) _catalogFor(locale).ignore();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleCatalogPreload();
  }

  @override
  void didUpdateWidget(_MateoPhoneTextInputCountrySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onChanged == null && widget.onChanged != null) {
      _scheduledCatalogLocale = null;
      _scheduleCatalogPreload();
    }
  }

  void _handlePressChanged(bool pressed) {
    if (!mounted) return;
    if (!pressed) {
      if (_deferRoutePushForPress) {
        final releasedGeneration = _pressGeneration;
        WidgetsBinding.instance.endOfFrame.then((_) {
          if (mounted && releasedGeneration == _pressGeneration) _deferRoutePushForPress = false;
        }).ignore();
      }
      return;
    }
    if (_pickerOpeningOrOpen || widget.onChanged == null) return;
    _pressGeneration++;
    final locale = Localizations.localeOf(Navigator.of(context).context);
    _catalogFor(locale).ignore();
    _deferRoutePushForPress = !_cachedCatalogReady;
  }

  Future<void> _showCountryPicker({required bool deferRoutePush}) async {
    if (_pickerOpeningOrOpen || widget.onChanged == null) return;
    _pickerOpeningOrOpen = true;

    try {
      var locale = Localizations.localeOf(Navigator.of(context).context);
      var catalogFuture = _catalogFor(locale);
      if (deferRoutePush) {
        await WidgetsBinding.instance.endOfFrame;
        if (!mounted || widget.onChanged == null) return;
        final settledLocale = Localizations.localeOf(Navigator.of(context).context);
        if (settledLocale != locale) {
          locale = settledLocale;
          catalogFuture = _catalogFor(locale);
        }
      }

      final readyCatalog = _sharedCatalogLocale == locale ? _sharedCatalog : null;
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
              child: FutureBuilder<_MateoPhoneCountryCatalog>(
                future: catalogFuture,
                initialData: readyCatalog,
                builder: (context, snapshot) => _MateoPhoneCountryPicker(
                  selectedCountry: widget.country,
                  query: query,
                  catalogLocale: locale,
                  catalog: snapshot.hasError ? _MateoPhoneCountryPicker.createCatalog(locale) : snapshot.data,
                ),
              ),
            ),
          ),
        );
      } finally {
        query.dispose();
      }

      if (!mounted || selectedCountry == null) return;
      widget.onChanged?.call(selectedCountry);
    } finally {
      _pickerOpeningOrOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final countryName = widget.country.displayName(Localizations.localeOf(context));
    final translations = mateoTranslationsOf(context).textInput.phone;

    return TextFieldTapRegion(
      child: MateoPress(
        semanticLabel: translations.changeCountryAccessibilityLabel(country: countryName),
        onPressChanged: widget.onChanged != null ? _handlePressChanged : null,
        onPressed: widget.onChanged != null
            ? (_) {
                final deferRoutePush =
                    _deferRoutePushForPress &&
                    _cachedCatalogReady &&
                    _cachedCatalogLocale == Localizations.localeOf(Navigator.of(context).context);
                _deferRoutePushForPress = false;
                return _showCountryPicker(deferRoutePush: deferRoutePush);
              }
            : null,
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
