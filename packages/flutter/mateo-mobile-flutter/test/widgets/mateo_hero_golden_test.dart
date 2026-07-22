import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoHero Golden Tests', () {
    goldenTest(
      'when rendering the text variant at rest, it should match the approved golden',
      fileName: 'mateo_hero_text_resting',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'text_resting',
            child: const SizedBox(
              width: 300,
              child: MateoHeroText(
                'Vendedora de Loja',
                tag: 'test-text',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'text_with_padding',
            child: const SizedBox(
              width: 300,
              child: MateoHeroText(
                'Servente de Obra',
                tag: 'test-text-padded',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                padding: EdgeInsets.all(12),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'text_with_overflow',
            child: const SizedBox(
              width: 200,
              child: MateoHeroText(
                'Ajudante de Carga e Descarga em Supermercado',
                tag: 'test-text-overflow',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when rendering the box variant at rest, it should match the approved golden',
      fileName: 'mateo_hero_background_resting',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'box_with_child',
            child: SizedBox(
              width: 300,
              height: 100,
              child: MateoHeroBackground(
                tag: 'test-box-with-child',
                decoration: BoxDecoration(
                  color: mateoTestColorScheme.buttons.primary.background,
                  borderRadius: BorderRadius.circular(38),
                ),
                padding: EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mateo',
                    style: TextStyle(
                      color: mateoTestColorScheme.background,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'box_decoration_only',
            child: SizedBox(
              width: 300,
              height: 80,
              child: MateoHeroBackground(
                tag: 'test-box-decoration',
                decoration: BoxDecoration(
                  color: mateoTestColorScheme.buttons.secondary.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: mateoTestColorScheme.buttons.primary.background,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'box_with_top_edge_fade',
            child: SizedBox(
              width: 300,
              height: 100,
              child: MateoHeroBackground(
                tag: 'test-box-fade-top',
                decoration: BoxDecoration(
                  color: mateoTestColorScheme.buttons.primary.background,
                ),
                edgeFade: MateoHeroEdgeFade(top: MateoEdgeFadeStyle()),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Top Fade',
                    style: TextStyle(
                      color: mateoTestColorScheme.background,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'box_with_both_edge_fades',
            child: SizedBox(
              width: 300,
              height: 100,
              child: MateoHeroBackground(
                tag: 'test-box-fade-both',
                decoration: BoxDecoration(
                  color: mateoTestColorScheme.buttons.primary.background,
                ),
                edgeFade: MateoHeroEdgeFade.vertical,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Both Fades',
                    style: TextStyle(
                      color: mateoTestColorScheme.background,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when rendering the group variant at rest, it should match the approved golden',
      fileName: 'mateo_hero_group_resting',
      builder: () => GoldenTestGroup(
        columnWidthBuilder: (_) => FixedColumnWidth(300),
        children: [
          GoldenTestScenario(
            name: 'group_resting',
            child: SizedBox(
              width: 300,
              child: MateoHeroGroup(
                tag: 'test-group',
                heroes: [
                  MateoHeroText(
                    '1 dia atrás',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: mateoTestColorScheme.text.disabled,
                    ),
                    padding: EdgeInsets.only(bottom: 6),
                  ),
                  MateoHeroText(
                    'Separador de Mercadorias',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  MateoHeroText(
                    r'R$2.200/mês',
                    style: TextStyle(
                      fontSize: 25,
                      color: mateoTestColorScheme.toast.success.icon,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  });
}
