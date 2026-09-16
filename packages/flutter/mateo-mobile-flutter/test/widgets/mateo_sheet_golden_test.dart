import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('MateoSheet Golden Tests', () {
    goldenTest(
      'when showing compact information, it should match the approved golden',
      fileName: 'mateo_sheet_compact',
      whilePerforming: (tester) async {
        await tester.tap(find.byKey(_SheetGoldenApp.openButtonKey));
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'compact resting',
            child: _SheetGoldenApp(child: _CompactContent()),
          ),
        ],
      ),
    );

    goldenTest(
      'when showing maximum-height information, it should match the approved golden',
      fileName: 'mateo_sheet_maximum_height',
      whilePerforming: (tester) async {
        await tester.tap(find.byKey(_SheetGoldenApp.openButtonKey));
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'maximum-height scrollable',
            child: _SheetGoldenApp(child: _LongContent()),
          ),
        ],
      ),
    );

    goldenTest(
      'when showing compact information above the Android bottom safe area, it should match the approved golden',
      fileName: 'mateo_sheet_android_safe_area',
      whilePerforming: (tester) async {
        await tester.tap(find.byKey(_SheetGoldenApp.openButtonKey));
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'Android bottom safe area',
            child: _SheetGoldenApp(
              platform: TargetPlatform.android,
              mediaQueryData: const MediaQueryData(
                size: Size(400, 800),
                padding: EdgeInsets.only(bottom: 48),
                viewPadding: EdgeInsets.only(bottom: 48),
                systemGestureInsets: EdgeInsets.only(bottom: 48),
              ),
              child: _CompactContent(),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when showing compact information with device corner information, it should match the approved concentric-corner golden',
      fileName: 'mateo_sheet_iphone_concentric_corners',
      whilePerforming: (tester) async {
        await tester.tap(find.byKey(_SheetGoldenApp.openButtonKey));
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'iPhone concentric corners',
            child: _SheetGoldenApp(
              platform: TargetPlatform.iOS,
              mediaQueryData: const MediaQueryData(
                size: Size(400, 800),
                viewPadding: EdgeInsets.only(top: 62, bottom: 34),
                displayCornerRadii: BorderRadius.all(
                  Radius.circular(62),
                ),
              ),
              child: _CompactContent(),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when dragging compact information downward, it should match the approved golden',
      fileName: 'mateo_sheet_partial_drag',
      whilePerforming: (tester) async {
        await tester.tap(find.byKey(_SheetGoldenApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_SheetGoldenApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(0, 70));
        await tester.pump();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'partial downward drag',
            child: _SheetGoldenApp(child: _CompactContent()),
          ),
        ],
      ),
    );

    goldenTest(
      'when dragging compact information sideways, it should match the approved resisted golden',
      fileName: 'mateo_sheet_resisted_drag',
      whilePerforming: (tester) async {
        await tester.tap(find.byKey(_SheetGoldenApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_SheetGoldenApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(120, 0));
        await tester.pump();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'resisted sideways drag',
            child: _SheetGoldenApp(child: _CompactContent()),
          ),
        ],
      ),
    );

    goldenTest(
      'when dragging non-scrollable information upward, it should match the approved top-resistance golden',
      fileName: 'mateo_sheet_top_resistance',
      whilePerforming: (tester) async {
        await tester.tap(find.byKey(_SheetGoldenApp.openButtonKey));
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_SheetGoldenApp.surfaceKey)),
        );
        await gesture.moveBy(const Offset(0, -120));
        await tester.pump();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'top resistance',
            child: _SheetGoldenApp(child: _CompactContent()),
          ),
        ],
      ),
    );
  });
}

class _SheetGoldenApp extends StatelessWidget {
  const _SheetGoldenApp({
    required this.child,
    this.platform,
    this.mediaQueryData,
  });

  static const openButtonKey = Key('open_sheet_golden');
  static const surfaceKey = Key('mateo_sheet_surface');

  final Widget child;
  final TargetPlatform? platform;
  final MediaQueryData? mediaQueryData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MateoTheme.light(
        accentColor: const Color(0xFF4A5CFF),
        onAccent: const Color(0xFFFFFFFF),
      ).lightTheme.copyWith(platform: platform),
      builder: (context, child) {
        final data = mediaQueryData;
        if (data == null) return child ?? const SizedBox.shrink();

        return MediaQuery(data: data, child: child ?? const SizedBox.shrink());
      },
      home: Builder(
        builder: (context) => Scaffold(
          body: Stack(
            children: [
              const Positioned.fill(child: _BackgroundContent()),
              Center(
                child: FilledButton(
                  key: openButtonKey,
                  onPressed: () => MateoSheet.show<void>(
                    context,
                    presentation: const MateoSheetPresentation.bottom(),
                    child: child,
                  ),
                  child: const Text('Ver detalhes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundContent extends StatelessWidget {
  const _BackgroundContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Oportunidades perto de voce',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          for (var index = 0; index < 5; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: context.mateo.palette.neutral[3],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CompactContent extends StatelessWidget {
  const _CompactContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Ajuda em evento hoje',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Vila Madalena · R\$ 180',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        MateoButton(
          presentation: MateoButtonPresentation.label(
            label: 'Tenho interesse',
            variant: MateoButtonVariant.primary,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _LongContent extends StatelessWidget {
  const _LongContent();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 18,
      separatorBuilder: (context, index) => Divider(color: context.mateo.palette.neutral[6]),
      itemBuilder: (context, index) => SizedBox(
        height: 64,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Informacao ${index + 1}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
