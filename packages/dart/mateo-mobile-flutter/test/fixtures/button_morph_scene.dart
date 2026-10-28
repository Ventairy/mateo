import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

class ButtonMorphScene {
  final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
  final navigator = GlobalKey<NavigatorState>();
  final target = MorphTarget(tag: #headerBackButton);

  Widget get app => MateoApp(theme: theme, navigatorKey: navigator, home: _page(incoming: false));

  Widget _page({required bool incoming}) => MateoView(
    header: .new(
      leading: Morph(
        targets: [target],
        child: MateoButton(
          key: ValueKey(incoming ? 'destination_back' : 'source_back'),
          presentation: const .icon(icon: MateoIcon(.arrowLeft), semanticLabel: 'Back'),
          onPressed: incoming ? () => navigator.currentState!.pop() : () {},
        ),
      ),
    ),
    surface: .new(
      child: Center(child: MateoText(incoming ? 'Choose an action' : 'Your name', presentation: const .interface())),
    ),
  );

  void push() => navigator.currentState!.push<void>(
    MateoPage<void>(
      transition: const .push(direction: .left),
      child: _page(incoming: true),
    ).createRoute(navigator.currentContext!),
  );

  List<({Color? color, double height, double? elevation})> appearances(WidgetTester tester) {
    final surfaces = find.descendant(of: find.byType(MateoButton), matching: find.byType(MateoSurface));
    return [
      for (final element in surfaces.evaluate())
        (
          color: (element.widget as MateoSurface).color,
          height: tester.getSize(find.byWidget(element.widget)).height,
          elevation: (element.widget as MateoSurface).elevation?.level,
        ),
    ];
  }
}
