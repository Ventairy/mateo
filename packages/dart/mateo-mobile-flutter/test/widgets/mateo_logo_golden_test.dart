import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/logo_test_helpers.dart';
import '../fixtures/surface_transform_test_widgets.dart';

Widget _appearance(Widget child) => MateoTheme(
  data: surfaceTransformTheme,
  child: ColoredBox(color: surfaceTransformTheme.palette.white, child: child),
);

Future<void> main() async {
  await goldenTest(
    'when logos share icon frames in either direction, it should retain brand colors and optical balance',
    fileName: 'mateo_logo_catalog',
    pumpBeforeTest: settleLogoImages,
    builder: () => _appearance(
      GoldenTestGroup(
        columns: 2,
        children: [
          for (final size in [16.0, 20.0, 24.0, 28.0])
            for (final direction in TextDirection.values)
              GoldenTestScenario(
                name: '${size.toInt()}px / ${direction.name}',
                child: Directionality(
                  textDirection: direction,
                  child: Padding(
                    padding: const .all(16),
                    child: MateoLogoScope(
                      size: size,
                      child: Row(
                        mainAxisSize: .min,
                        spacing: 10,
                        children: [
                          for (final logo in MateoLogoData.values) MateoLogo(logo),
                          for (final icon in [MateoIconData.circle, MateoIconData.heart, MateoIconData.envelope])
                            MateoIcon(icon, size: size),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    ),
  );

  await goldenTest(
    'when buttons contain logos, it should coordinate sizes and preserve the existing disabled and loading states',
    fileName: 'mateo_logo_buttons',
    pumpBeforeTest: settleLogoImages,
    builder: () => _appearance(
      GoldenTestGroup(
        columns: 3,
        children: [
          for (final size in MateoButtonSize.values)
            for (final state in ['Ready', 'Disabled', 'Loading'])
              GoldenTestScenario(
                name: '${size.name} / $state',
                child: Directionality(
                  textDirection: .ltr,
                  child: Padding(
                    padding: const .all(16),
                    child: SizedBox(
                      width: 290,
                      height: 64,
                      child: Row(
                        spacing: 16,
                        children: [
                          Expanded(
                            child: MateoButton(
                              presentation: .label(
                                label: 'Instagram',
                                size: size,
                                variant: .secondary,
                                leadingIcon: const MateoLogo(.instagram),
                                trailingIcon: const MateoIcon(.arrowRight),
                              ),
                              onPressed: state == 'Disabled' ? null : () {},
                              isLoading: state == 'Loading',
                            ),
                          ),
                          MateoButton(
                            presentation: .icon(
                              icon: const MateoLogo(.whatsapp),
                              size: size,
                              variant: .secondary,
                              semanticLabel: 'WhatsApp',
                            ),
                            onPressed: state == 'Disabled' ? null : () {},
                            isLoading: state == 'Loading',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    ),
  );

  await goldenTest(
    'when menus and toasts contain logos, it should provide their contextual size without tinting',
    fileName: 'mateo_logo_menu_toast',
    pumpBeforeTest: settleLogoImages,
    builder: () => _appearance(
      GoldenTestGroup(
        columns: 3,
        children: [
          for (final density in MateoMenuDensity.values)
            GoldenTestScenario(
              name: '${density.name} menu',
              child: Directionality(
                textDirection: .ltr,
                child: Padding(
                  padding: const .all(16),
                  child: MateoMenu(
                    presentation: .options(
                      density: density,
                      items: const [
                        MateoMenuOptionsPresentationItem(
                          leading: MateoLogo(.googleMessages),
                          principal: MateoText('Google Messages', presentation: .interface()),
                        ),
                        MateoMenuOptionsPresentationItem(
                          leading: MateoLogo(.phoneByGoogle),
                          principal: MateoText('Phone by Google', presentation: .interface()),
                        ),
                        MateoMenuOptionsPresentationItem(
                          leading: MateoLogo(.cataqui),
                          principal: MateoText('Cataquí', presentation: .interface()),
                        ),
                      ],
                    ),
                    onItemPressed: (_) {},
                  ),
                ),
              ),
            ),
          GoldenTestScenario(
            name: 'Toast',
            child: const Directionality(
              textDirection: .ltr,
              child: Padding(
                padding: .all(16),
                child: MateoToast(message: 'Sent with Gmail', status: .success, icon: MateoLogo(.gmail)),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
