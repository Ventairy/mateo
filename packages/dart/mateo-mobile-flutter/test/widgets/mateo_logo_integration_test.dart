import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/logo_test_helpers.dart';

void main() {
  for (final (size, labelArtworkSize, iconArtworkSize) in [
    (MateoButtonSize.mini, 16.0, 22.0),
    (MateoButtonSize.small, 20.0, 26.0),
    (MateoButtonSize.standard, 24.0, 30.0),
  ]) {
    testWidgets('when a ${size.name} labeled button has logos, it should size both supporting slots', (tester) async {
      await tester.pumpWidget(
        logoHost(
          MateoLogoScope(
            size: 80,
            child: MateoButton(
              presentation: .label(
                label: 'Open',
                size: size,
                leadingIcon: const MateoLogo(.telegram),
                trailingIcon: const MateoLogo(.whatsapp),
              ),
              onPressed: () {},
            ),
          ),
        ),
      );
      for (final element in find.byType(MateoLogo).evaluate()) {
        expect(tester.getSize(find.byWidget(element.widget)), Size.square(labelArtworkSize));
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('when a ${size.name} icon button contains a logo, it should match a neighboring icon button', (
      tester,
    ) async {
      await tester.pumpWidget(
        logoHost(
          MateoLogoScope(
            size: 80,
            child: Row(
              mainAxisSize: .min,
              children: [
                MateoButton(
                  presentation: .icon(icon: const MateoLogo(.telegram), size: size, semanticLabel: 'Telegram'),
                  onPressed: () {},
                ),
                MateoButton(
                  presentation: .icon(icon: const MateoIcon(.cross), size: size, semanticLabel: 'Close'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(MateoLogo)), Size.square(iconArtworkSize));
      expect(tester.getSize(find.byType(MateoIcon)), Size.square(iconArtworkSize));
      expect(tester.takeException(), isNull);
    });
  }

  for (final (density, artworkSize) in [(MateoMenuDensity.compact, 30.0), (MateoMenuDensity.standard, 38.0)]) {
    testWidgets('when a ${density.name} menu has wrapped logos, it should size them like unbacked icons', (
      tester,
    ) async {
      await tester.pumpWidget(
        logoHost(
          MateoLogoScope(
            size: 80,
            child: MateoMenu(
              presentation: .options(
                density: density,
                items: const [
                  MateoMenuOptionsPresentationItem(
                    leading: Padding(padding: .all(2), child: MateoLogo(.telegram)),
                    principal: Text('Telegram'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(MateoLogo)), Size.square(artworkSize));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('when a toast replaces its status icon with a logo, it should supply the toast size', (tester) async {
    await tester.pumpWidget(
      logoHost(
        const MateoLogoScope(
          size: 80,
          child: MateoToast(message: 'Shared on Telegram', status: .success, icon: MateoLogo(.telegram)),
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoLogo)), const Size.square(28));
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a component supplies a default, it should preserve an explicit logo size', (tester) async {
    await tester.pumpWidget(
      logoHost(
        MateoButton(
          presentation: const .label(label: 'Telegram', leadingIcon: MateoLogo(.telegram, size: 18)),
          onPressed: () {},
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoLogo)), const Size.square(18));
    expect(tester.takeException(), isNull);
  });
}
