import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoGroupedList Golden Tests', () {
    goldenTest(
      'when rendering its rows, it should match the approved golden',
      fileName: 'mateo_grouped_list_states',
      whilePerforming: (tester) async {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 220));
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 360,
          height: 356,
        ),
        children: [
          GoldenTestScenario(
            name: 'rows',
            child: const _GroupedListGoldenHarness(),
          ),
        ],
      ),
    );
  });
}

class _GroupedListGoldenHarness extends StatelessWidget {
  const _GroupedListGoldenHarness();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mateoTestTheme,
      home: MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SizedBox(
              width: 336,
              height: 328,
              child: MateoGroupedList(
                children: [
                  for (var index = 0; index < 4; index++)
                    MateoGroupedListRow(
                      leading: DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? mateoTestPalette.neutral[12] : mateoTestPalette.green[9],
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox.square(
                          dimension: 42,
                          child: Icon(
                            index.isEven ? Icons.route_rounded : Icons.park_rounded,
                            size: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: index.isEven ? 'Rua Orindiuva 32' : 'Parque Ibirapuera',
                      description: index == 2 ? 'Jardim Elzinha' : 'Vila Mariana',
                      onPressed: (animation) async => animation,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
