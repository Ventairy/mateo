import 'package:flutter_test/flutter_test.dart';
import 'package:record_use/record_use.dart';

import '../../hook/three_d_icon_usage_recordings.dart';

void main() {
  const library = Library('package:mateo_mobile/src/components/mateo_icon/mateo_icon.dart');
  const iconClass = Class('MateoIcon', library);
  const icon = EnumConstant(definition: Enum('MateoIconData', library), index: 0, name: 'magnifyingGlass');
  const style = EnumConstant(
    definition: Enum('MateoIconStyle', Library('package:mateo_mobile/src/components/mateo_icon/mateo_icon_style.dart')),
    index: 1,
    name: 'threeD',
  );
  const usage = InstanceConstantReference(
    instanceConstant: InstanceConstant(
      definition: iconClass,
      fields: {
        'icon': icon,
        'style': style,
        'size': DoubleConstant(104),
        'backgroundColor': NullConstant(),
      },
    ),
    loadingUnit: LoadingUnit('main'),
  );
  test('when constant widgets are selected indirectly, it should retain and deduplicate their full configuration', () {
    final recordings = Recordings(
      calls: {},
      instances: {
        iconClass: [usage, usage],
      },
    );
    expect(ThreeDIconUsageRecordings.extract(recordings).map((value) => value.toJson()).toList(), [
      {'icon': 'magnifyingGlass', 'size': 104.0, 'background': false},
    ]);
  });
  test('when a constructor size is unknown, it should avoid guessing a preload size', () {
    final recordings = Recordings(
      calls: {},
      instances: {
        iconClass: [
          const InstanceCreationReference(
            definition: Constructor('', iconClass),
            positionalArguments: [icon],
            namedArguments: {'style': style, 'size': NonConstant(), 'backgroundColor': NullConstant()},
            loadingUnit: LoadingUnit('main'),
          ),
        ],
      },
    );
    expect(ThreeDIconUsageRecordings.extract(recordings), isEmpty);
  });
  for (final scenario in [
    (styleName: 'threeD', size: 124, background: true, count: 1),
    (styleName: 'svg', size: 124, background: false, count: 0),
    (styleName: 'threeD', size: 0, background: false, count: 0),
  ]) {
    test(
      'when ${scenario.styleName} has size ${scenario.size} and background ${scenario.background}, it should record only preparable bitmap usages',
      () {
        final recordings = Recordings(
          calls: {},
          instances: {
            iconClass: [
              InstanceCreationReference(
                definition: const Constructor('', iconClass),
                positionalArguments: const [icon],
                namedArguments: {
                  'style': EnumConstant(
                    definition: const Enum(
                      'MateoIconStyle',
                      Library('package:mateo_mobile/src/components/mateo_icon/mateo_icon_style.dart'),
                    ),
                    index: 1,
                    name: scenario.styleName,
                  ),
                  'size': IntConstant(scenario.size),
                  'backgroundColor': scenario.background
                      ? const UnsupportedConstant('A constant Color')
                      : const NullConstant(),
                },
                loadingUnit: const LoadingUnit('main'),
              ),
            ],
          },
        );
        final usages = ThreeDIconUsageRecordings.extract(recordings);
        expect(
          (usages.length, usages.firstOrNull?.artworkSize),
          (scenario.count, scenario.count == 0 ? null : 124 * 0.65),
        );
      },
    );
  }
  test('when no recordings exist, it should leave decoding lazy', () {
    expect(ThreeDIconUsageRecordings.extract(null), isEmpty);
  });
}
