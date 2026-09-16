import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  final goldenConfig = AlchemistConfig.current();
  AlchemistConfig.runWithConfig(
    config: goldenConfig.copyWith(
      ciGoldensConfig: goldenConfig.ciGoldensConfig.copyWith(
        obscureText: false,
      ),
    ),
    run: () {
      group('MateoMessageBubble Golden Tests', () {
        goldenTest(
          'when rendering text states, it should match the approved golden',
          fileName: 'mateo_message_bubble_states',
          whilePerforming: (tester) async {
            await tester.pumpAndSettle();
            return null;
          },
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints.tightFor(
              width: 240,
              height: 150,
            ),
            children: [
              GoldenTestScenario(
                name: 'incoming single line',
                child: _BubbleScenario(
                  message: Text('Hey there 👋'),
                  direction: MateoMessageDirection.incoming,
                ),
              ),
              GoldenTestScenario(
                name: 'outgoing single line',
                child: _BubbleScenario(
                  message: Text('Hello! ✨'),
                  direction: MateoMessageDirection.outgoing,
                ),
              ),
              GoldenTestScenario(
                name: 'incoming multiline',
                child: _BubbleScenario(
                  message: Text('Can you help me with\nthis little detail?'),
                  direction: MateoMessageDirection.incoming,
                ),
              ),
              GoldenTestScenario(
                name: 'outgoing enlarged text',
                child: _BubbleScenario(
                  message: Text('Absolutely 👍🏽'),
                  direction: MateoMessageDirection.outgoing,
                  textScaleFactor: 1.8,
                ),
              ),
              GoldenTestScenario(
                name: 'incoming typing',
                child: _BubbleScenario(
                  direction: MateoMessageDirection.incoming,
                  isTyping: true,
                ),
              ),
              GoldenTestScenario(
                name: 'outgoing typing',
                child: _BubbleScenario(
                  direction: MateoMessageDirection.outgoing,
                  isTyping: true,
                ),
              ),
              GoldenTestScenario(
                name: 'incoming custom content',
                child: _BubbleScenario(
                  message: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 18),
                      SizedBox(width: 8),
                      Text('Custom'),
                    ],
                  ),
                  direction: MateoMessageDirection.incoming,
                ),
              ),
            ],
          ),
        );

        late GlobalKey<_TransitionBubbleScenarioState> forwardKey;
        late GlobalKey<_TransitionBubbleScenarioState> reverseKey;
        goldenTest(
          'when morphing in both directions, it should match the approved frame',
          fileName: 'mateo_message_bubble_transition',
          whilePerforming: (tester) async {
            forwardKey.currentState!.enableAnimations();
            reverseKey.currentState!.enableAnimations();
            await tester.pump();
            forwardKey.currentState!.setTyping(false);
            reverseKey.currentState!.setTyping(true);
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 180));
            return null;
          },
          builder: () {
            forwardKey = GlobalKey<_TransitionBubbleScenarioState>();
            reverseKey = GlobalKey<_TransitionBubbleScenarioState>();
            return GoldenTestGroup(
              scenarioConstraints: const BoxConstraints.tightFor(
                width: 240,
                height: 180,
              ),
              children: [
                GoldenTestScenario(
                  name: 'typing to incoming message',
                  child: _TransitionBubbleScenario(
                    key: forwardKey,
                    initialTyping: true,
                    message: Text('A helpful answer that wraps.'),
                    direction: MateoMessageDirection.incoming,
                  ),
                ),
                GoldenTestScenario(
                  name: 'outgoing message to typing',
                  child: _TransitionBubbleScenario(
                    key: reverseKey,
                    initialTyping: false,
                    message: Text('A helpful answer that wraps.'),
                    direction: MateoMessageDirection.outgoing,
                  ),
                ),
              ],
            );
          },
        );
      });
    },
  );
}

class _TransitionBubbleScenario extends StatefulWidget {
  const _TransitionBubbleScenario({
    required this.initialTyping,
    required this.message,
    required this.direction,
    super.key,
  });

  final bool initialTyping;
  final Widget message;
  final MateoMessageDirection direction;

  @override
  State<_TransitionBubbleScenario> createState() => _TransitionBubbleScenarioState();
}

class _TransitionBubbleScenarioState extends State<_TransitionBubbleScenario> {
  late bool _isTyping = widget.initialTyping;
  bool _animationsEnabled = false;

  void enableAnimations() => setState(() => _animationsEnabled = true);

  void setTyping(bool value) => setState(() => _isTyping = value);

  @override
  Widget build(BuildContext context) => Theme(
    data: mateoTestTheme,
    child: MediaQuery(
      data: MediaQuery.of(context).copyWith(
        disableAnimations: !_animationsEnabled,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 190),
          child: MateoMessageBubble(
            message: widget.message,
            direction: widget.direction,
            isTyping: _isTyping,
          ),
        ),
      ),
    ),
  );
}

class _BubbleScenario extends StatelessWidget {
  const _BubbleScenario({
    required this.direction,
    this.message,
    this.textScaleFactor = 1,
    this.isTyping = false,
  });

  final Widget? message;
  final MateoMessageDirection direction;
  final double textScaleFactor;
  final bool isTyping;

  @override
  Widget build(BuildContext context) => Theme(
    data: mateoTestTheme,
    child: MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScaleFactor),
        disableAnimations: isTyping,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 190),
          child: MateoMessageBubble(
            message: message,
            direction: direction,
            isTyping: isTyping,
          ),
        ),
      ),
    ),
  );
}
