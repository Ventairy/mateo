import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A consumer override that supplies left-to-right widget localization.
class AppTestWidgetsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  /// Creates the consumer delegate.
  const AppTestWidgetsDelegate();

  /// Whether this delegate supports [locale].
  @override
  bool isSupported(Locale locale) => true;

  /// The consumer's widget localization for [locale].
  @override
  Future<WidgetsLocalizations> load(Locale locale) => SynchronousFuture(const DefaultWidgetsLocalizations());

  /// Whether the localization needs to be reloaded.
  @override
  bool shouldReload(AppTestWidgetsDelegate old) => false;
}
