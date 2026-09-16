import 'package:flutter/material.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

final mateoTestTheme = MateoTheme.light(
  accentColor: const Color(0xFF4A5CFF),
  onAccent: const Color(0xFFFFFFFF),
).lightTheme;
final mateoTestThemeData = mateoTestTheme.extension<MateoThemeData>()!;
final mateoTestColorScheme = mateoTestThemeData.colorScheme;
final mateoTestPalette = mateoTestThemeData.palette;

/// Shared test wrapper that provides a [MaterialApp] with [MateoTheme] for
/// widget tests in the `mateo_mobile_old` package.
///
/// Use this instead of defining per-file `_TestApp` variants.
class TestApp extends StatelessWidget {
  const TestApp({
    required this.child,
    super.key,
    this.debugShowCheckedModeBanner = false,
    this.theme,
  });

  final Widget child;
  final bool debugShowCheckedModeBanner;
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      theme: theme ?? mateoTestTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }
}
