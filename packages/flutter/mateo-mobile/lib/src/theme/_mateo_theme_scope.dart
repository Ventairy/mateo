part of 'mateo_theme.dart';

class _MateoThemeScope extends InheritedWidget {
  const _MateoThemeScope({required this.data, required super.child});

  final MateoThemeData data;

  @override
  bool updateShouldNotify(_MateoThemeScope oldWidget) => data != oldWidget.data;
}
