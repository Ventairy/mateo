import 'package:flutter/material.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() => runApp(const MateoExample());

/// A compact gallery for the public Mateo Mobile components.
class MateoExample extends StatelessWidget {
  /// Creates the Mateo Mobile component gallery.
  const MateoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MateoApp(
      title: 'Mateo component gallery',
      color: const (
        primary: Color(0xFFFF4A4B),
        onPrimary: Color(0xFFFFFFFF),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Mateo component gallery')),
        body: Center(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              MateoButton(
                label: 'Primary',
                variant: MateoButtonVariant.primary,
                onPressed: () {},
              ),
              const MateoButton(
                label: 'Disabled',
                variant: MateoButtonVariant.secondary,
              ),
              const MateoDotsLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
