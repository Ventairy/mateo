import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoOrbit Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved goldens',
      fileName: 'mateo_orbit_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 400,
        ),
        children: [
          GoldenTestScenario(
            name: '4 items upright',
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(child: MateoOrbit(items: _fourOrbitItems)),
            ),
          ),
          GoldenTestScenario(
            name: '6 items upright',
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(child: MateoOrbit(items: _sixOrbitItems)),
            ),
          ),
          GoldenTestScenario(
            name: '8 items upright',
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(child: MateoOrbit(items: _eightOrbitItems)),
            ),
          ),
          GoldenTestScenario(
            name: 'rotateItems spin',
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoOrbit(rotateItems: true, items: _fourOrbitItems),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'custom radius',
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoOrbit(radius: 60, items: _fourOrbitItems),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'counterclockwise',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoOrbit(
                  direction: MateoOrbitDirection.counterclockwise,
                  items: _fourOrbitItems,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'initial angle offset',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoOrbit(initialAngle: 0.75, items: _fourOrbitItems),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'different item sizes',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoOrbit(
                  items: [
                    MateoOrbitItem(
                      child: _goldenChip(
                        Icons.bolt_rounded,
                        mateoTestColorScheme.buttons.primary.background,
                      ),
                      size: Size(64, 64),
                    ),
                    MateoOrbitItem(
                      child: _goldenChip(
                        Icons.restaurant_rounded,
                        mateoTestColorScheme.buttons.success.background,
                      ),
                      size: Size(48, 48),
                    ),
                    MateoOrbitItem(
                      child: _goldenChip(
                        Icons.delivery_dining_rounded,
                        mateoTestColorScheme.toast.info.background,
                      ),
                      size: Size(32, 48),
                    ),
                    MateoOrbitItem(
                      child: _goldenChip(
                        Icons.cleaning_services_rounded,
                        mateoTestColorScheme.toast.warning.icon,
                      ),
                      size: Size(56, 40),
                    ),
                    MateoOrbitItem(
                      child: _goldenChip(
                        Icons.handyman_rounded,
                        mateoTestColorScheme.buttons.secondary.foreground,
                      ),
                      size: Size(48, 32),
                    ),
                    MateoOrbitItem(
                      child: _goldenChip(
                        Icons.local_laundry_service_rounded,
                        mateoTestColorScheme.text.profit,
                      ),
                      size: const Size(64, 64),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'padding inset',
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoOrbit(padding: 30, items: _fourOrbitItems),
              ),
            ),
          ),
        ],
      ),
    );
  });
}

final _fourOrbitItems = [
  MateoOrbitItem(
    child: _goldenChip(
      Icons.bolt_rounded,
      mateoTestColorScheme.buttons.primary.background,
    ),
    size: Size(56, 56),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.restaurant_rounded,
      mateoTestColorScheme.buttons.success.background,
    ),
    size: Size(56, 56),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.delivery_dining_rounded,
      mateoTestColorScheme.toast.info.background,
    ),
    size: Size(56, 56),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.cleaning_services_rounded,
      mateoTestColorScheme.toast.warning.icon,
    ),
    size: const Size(56, 56),
  ),
];

final _sixOrbitItems = [
  MateoOrbitItem(
    child: _goldenChip(
      Icons.bolt_rounded,
      mateoTestColorScheme.buttons.primary.background,
    ),
    size: Size(48, 48),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.restaurant_rounded,
      mateoTestColorScheme.buttons.success.background,
    ),
    size: Size(48, 48),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.delivery_dining_rounded,
      mateoTestColorScheme.toast.info.background,
    ),
    size: Size(48, 48),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.cleaning_services_rounded,
      mateoTestColorScheme.toast.warning.icon,
    ),
    size: Size(48, 48),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.handyman_rounded,
      mateoTestColorScheme.buttons.secondary.foreground,
    ),
    size: Size(48, 48),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.local_laundry_service_rounded,
      mateoTestColorScheme.text.profit,
    ),
    size: const Size(48, 48),
  ),
];

final _eightOrbitItems = [
  MateoOrbitItem(
    child: _goldenChip(
      Icons.bolt_rounded,
      mateoTestColorScheme.buttons.primary.background,
    ),
    size: Size(40, 40),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.restaurant_rounded,
      mateoTestColorScheme.buttons.success.background,
    ),
    size: Size(40, 40),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.delivery_dining_rounded,
      mateoTestColorScheme.toast.info.background,
    ),
    size: Size(40, 40),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.cleaning_services_rounded,
      mateoTestColorScheme.toast.warning.icon,
    ),
    size: Size(40, 40),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.handyman_rounded,
      mateoTestColorScheme.buttons.secondary.foreground,
    ),
    size: Size(40, 40),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.local_laundry_service_rounded,
      mateoTestColorScheme.text.profit,
    ),
    size: Size(40, 40),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.pets_rounded,
      mateoTestColorScheme.buttons.danger.background,
    ),
    size: Size(40, 40),
  ),
  MateoOrbitItem(
    child: _goldenChip(
      Icons.directions_bike_rounded,
      mateoTestColorScheme.map.administrativeLabel,
    ),
    size: const Size(40, 40),
  ),
];

Widget _goldenChip(IconData icon, Color color) {
  return Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: mateoTestColorScheme.buttons.floating.shadow,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Icon(icon, color: mateoTestColorScheme.background, size: 24),
  );
}

class _GoldenFrame extends StatelessWidget {
  const _GoldenFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: mateoTestColorScheme.background,
      child: Padding(padding: const EdgeInsets.all(24), child: child),
    );
  }
}
