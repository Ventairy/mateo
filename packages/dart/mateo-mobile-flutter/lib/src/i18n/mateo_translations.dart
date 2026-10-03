import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../gen/i18n/translations.g.dart';

@internal
Translations mateoTranslationsOf(BuildContext context) {
  final locale = Localizations.localeOf(context);

  if (!AppLocale.values.any((supported) => supported.languageCode == locale.languageCode)) {
    return AppLocale.en.buildSync();
  }

  return AppLocaleUtils.parseLocaleParts(
    languageCode: locale.languageCode,
    scriptCode: locale.scriptCode,
    countryCode: locale.countryCode,
  ).buildSync();
}
