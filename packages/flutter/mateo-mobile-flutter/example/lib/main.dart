import 'package:flutter/material.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() => runApp(const MateoExample());

/// A compact gallery for the public Mateo Mobile components.
class MateoExample extends StatelessWidget {
  /// Creates the Mateo Mobile component gallery.
  const MateoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MateoApp(
      title: 'Mateo component gallery',
      theme: MateoTheme.adaptive(
        accentColor: const Color(0xFFFF4A4B),
        onAccent: const Color(0xFFFFFFFF),
      ),
      home: MateoView(
        header: const MateoHeader(
          presentation: MateoHeaderPresentation.view(
            title: Text('Mateo component gallery'),
          ),
        ),
        surface: MateoSurface.scrollable(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                MateoButton(
                  presentation: const MateoButtonPresentation.label(
                    label: 'Primary',
                    variant: MateoButtonVariant.primary,
                  ),
                  onPressed: () {},
                ),
                const MateoButton(
                  presentation: MateoButtonPresentation.label(
                    label: 'Disabled',
                    variant: MateoButtonVariant.secondary,
                  ),
                ),
                const MateoDotsLoadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
