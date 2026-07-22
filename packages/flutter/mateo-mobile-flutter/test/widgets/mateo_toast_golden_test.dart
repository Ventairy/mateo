import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoToast Golden Tests', () {
    goldenTest(
      'when rendering error states, it should match the approved goldens',
      fileName: 'mateo_toast_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: BoxConstraints.tightFor(width: 390, height: 260),
        children: [
          GoldenTestScenario(
            name: 'error',
            child: _ToastGoldenFrame(
              child: MateoToast(message: 'Nao foi possivel carregar agora'),
            ),
          ),
          GoldenTestScenario(
            name: 'long error',
            child: _ToastGoldenFrame(
              child: MateoToast(
                message: List.filled(
                  10,
                  'Tente novamente em alguns segundos',
                ).join(' '),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'strong shadow',
            child: _ToastGoldenFrame(
              backgroundColor:
                  mateoTestColorScheme.buttons.secondary.background,
              child: MateoToast(message: 'O mapa perdeu a conexao'),
            ),
          ),
          GoldenTestScenario(
            name: 'custom padding',
            child: _ToastGoldenFrame(
              padding: EdgeInsets.fromLTRB(54, 48, 20, 16),
              child: MateoToast(message: 'uh lala'),
            ),
          ),
          GoldenTestScenario(
            name: 'custom icon',
            child: _ToastGoldenFrame(
              child: MateoToast(
                message: 'Com icone personalizado',
                iconBuilder: _buildTestCustomIcon,
              ),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildTestCustomIcon(MateoToastState state) {
  return SizedBox(
    key: const Key('mateo_toast_custom_icon'),
    width: state.iconSize,
    height: state.iconSize,
    child: Icon(Icons.warning, color: state.iconColor, size: state.iconSize),
  );
}

class _ToastGoldenFrame extends StatelessWidget {
  _ToastGoldenFrame({
    required this.child,
    Color? backgroundColor,
    this.padding = EdgeInsets.zero,
  }) : backgroundColor = backgroundColor ?? mateoTestColorScheme.background;

  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Padding(
        padding: padding,
        child: Align(alignment: Alignment.topCenter, child: child),
      ),
    );
  }
}
