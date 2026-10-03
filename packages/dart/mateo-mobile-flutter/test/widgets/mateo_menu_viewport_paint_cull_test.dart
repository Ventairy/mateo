import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

class _PaintRecorder {
  final Map<int, int> paints = <int, int>{};
  int mounted = 0;
  int disposed = 0;
}

class _PaintProbe extends StatefulWidget {
  const _PaintProbe({required this.index, required this.recorder});

  final int index;
  final _PaintRecorder recorder;

  @override
  State<_PaintProbe> createState() => _PaintProbeState();
}

class _PaintProbeState extends State<_PaintProbe> {
  @override
  void initState() {
    super.initState();
    widget.recorder.mounted++;
  }

  @override
  void dispose() {
    widget.recorder.disposed++;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _CountingPainter(index: widget.index, recorder: widget.recorder),
    child: const MateoIcon(.paperPlaneUpRight),
  );
}

class _CountingPainter extends CustomPainter {
  const _CountingPainter({required this.index, required this.recorder});

  final int index;
  final _PaintRecorder recorder;

  @override
  void paint(Canvas canvas, Size size) {
    recorder.paints[index] = (recorder.paints[index] ?? 0) + 1;
  }

  @override
  bool shouldRepaint(covariant _CountingPainter oldDelegate) =>
      index != oldDelegate.index || !identical(recorder, oldDelegate.recorder);
}

void main() {
  testWidgets('transform menu keeps the complete row paint path', (tester) async {
    final recorder = _PaintRecorder();
    await tester.pumpWidget(
      MateoApp(
        theme: MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: const Color(0xFFFFFFFF)),
        home: Center(
          child: MateoMenuButton(
            animation: const .transform(),
            buttonPresentation: const .label(label: 'Options', variant: .secondary, width: .fit),
            menuPresentation: .options(
              items: List.generate(
                20,
                (index) => MateoMenuOptionsPresentationItem(
                  leading: _PaintProbe(index: index, recorder: recorder),
                  principal: Text('Option ${index + 1}'),
                  supporting: const Text('A supporting detail'),
                ),
              ),
            ),
            onItemPressed: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    recorder.paints.clear();
    await tester.tap(find.byType(MateoMenuButton));
    await tester.pumpAndSettle();

    expect(find.byType(MateoMenu), findsOneWidget);
    expect(recorder.paints.keys.toSet(), Set<int>.from(Iterable<int>.generate(20)));
  });

  testWidgets('tall pop menu skips offscreen paint while keeping rows mounted and selectable', (tester) async {
    final semantics = tester.ensureSemantics();
    addTearDown(() {
      tester.view.resetPhysicalSize();
    });
    final recorder = _PaintRecorder();
    final items = List.generate(
      20,
      (index) => MateoMenuOptionsPresentationItem(
        leading: _PaintProbe(index: index, recorder: recorder),
        principal: Text('Option ${index + 1}'),
        supporting: const Text('A supporting detail'),
      ),
    );
    MateoMenuOptionsPresentationItem? selected;
    final pixelRatio = tester.view.devicePixelRatio;
    tester.view.physicalSize = Size(800 * pixelRatio, 600 * pixelRatio);

    await tester.pumpWidget(
      MateoApp(
        theme: MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: const Color(0xFFFFFFFF)),
        home: Center(
          child: MateoMenuButton(
            animation: const .pop(),
            buttonPresentation: const .label(label: 'Options', variant: .secondary, width: .fit),
            menuPresentation: .options(items: items),
            onItemPressed: (item) => selected = item,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    recorder.paints.clear();
    await tester.tap(find.byType(MateoMenuButton));
    await tester.pumpAndSettle();

    expect(tester.getRect(find.byType(MateoMenu)).height, greaterThan(600));
    expect(recorder.mounted, 20);
    expect(recorder.disposed, 0);
    expect(recorder.paints.length, greaterThan(0));
    expect(recorder.paints.length, lessThan(20));
    expect(find.text('Option 1'), findsOneWidget);
    final initiallyVisible = recorder.paints.keys.toList()..sort();

    recorder.paints.clear();
    tester.view.physicalSize = Size(2000 * pixelRatio, 2000 * pixelRatio);
    await tester.pumpAndSettle();
    expect(recorder.mounted, 20);
    expect(recorder.disposed, 0);
    expect(recorder.paints.keys, containsAll(<int>[0, 19]));

    recorder.paints.clear();
    tester.view.physicalSize = Size(800 * pixelRatio, 600 * pixelRatio);
    await tester.pumpAndSettle();
    expect(recorder.mounted, 20);
    expect(recorder.disposed, 0);
    final selectedIndex = initiallyVisible[initiallyVisible.length ~/ 2];
    final visibleLabel = find.text('Option ${selectedIndex + 1}');
    expect(tester.getSemantics(visibleLabel).label, contains('Option ${selectedIndex + 1}'));
    await tester.tap(visibleLabel);
    await tester.pumpAndSettle();
    expect(selected, same(items[selectedIndex]));
    expect(find.byType(MateoMenu), findsNothing);
    semantics.dispose();
  });
}
