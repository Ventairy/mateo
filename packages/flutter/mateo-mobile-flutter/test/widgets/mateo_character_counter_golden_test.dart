import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('MateoCharacterCounter Golden Tests', () {
    late GlobalKey<_CharacterCounterFrameState> rejectedKey;

    goldenTest(
      'when rendering character-counter variants, it should match the approved golden',
      fileName: 'mateo_character_counter_states',
      whilePerforming: (tester) async {
        rejectedKey.currentState!.attemptLimitExceeded();
        await tester.pump();
        return null;
      },
      builder: () {
        rejectedKey = GlobalKey<_CharacterCounterFrameState>();
        return GoldenTestGroup(
          scenarioConstraints: const BoxConstraints.tightFor(width: 180, height: 80),
          children: [
            GoldenTestScenario(
              name: 'floating',
              child: _CharacterCounterFrame(
                text: 'Pagamento',
                variant: MateoCharacterCounterVariant.floating,
              ),
            ),
            GoldenTestScenario(
              name: 'text',
              child: _CharacterCounterFrame(
                text: 'Pagamento',
                variant: MateoCharacterCounterVariant.text,
              ),
            ),
            GoldenTestScenario(
              name: 'custom geometry',
              child: _CharacterCounterFrame(
                text: 'Pagamento',
                variant: MateoCharacterCounterVariant.floating,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                fontSize: 15,
              ),
            ),
            GoldenTestScenario(
              name: 'limit feedback',
              child: _CharacterCounterFrame(
                key: rejectedKey,
                text: 'a' * 50,
                variant: MateoCharacterCounterVariant.floating,
              ),
            ),
          ],
        );
      },
    );
  });
}

class _CharacterCounterFrame extends StatefulWidget {
  const _CharacterCounterFrame({
    required this.text,
    required this.variant,
    this.padding,
    this.fontSize,
    super.key,
  });

  final String text;
  final MateoCharacterCounterVariant variant;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  @override
  State<_CharacterCounterFrame> createState() => _CharacterCounterFrameState();
}

class _CharacterCounterFrameState extends State<_CharacterCounterFrame> {
  late final MateoTextController _controller;

  void attemptLimitExceeded() => _controller.text = 'a' * 51;

  @override
  void initState() {
    super.initState();
    _controller = MateoTextController(text: widget.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MateoCharacterCounter(
        textController: _controller,
        limit: 50,
        variant: widget.variant,
        padding: widget.padding,
        fontSize: widget.fontSize,
      ),
    );
  }
}
