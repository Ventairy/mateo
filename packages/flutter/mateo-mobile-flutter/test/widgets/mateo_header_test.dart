import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../test_app.dart';

void main() {
  group('MateoHeader', () {
    testWidgets('when standalone padding is customized, it should replace the default content inset', (tester) async {
      await _pumpHeader(
        tester,
        padding: const EdgeInsetsDirectional.only(start: 8, top: 4, end: 12),
        leading: const SizedBox.square(
          key: ValueKey('custom-padding-leading'),
          dimension: 44,
        ),
      );

      expect(tester.getTopLeft(find.byKey(const ValueKey('custom-padding-leading'))), const Offset(8, 4));
      expect(tester.getSize(find.byType(MateoHeader)).height, 48);
    });

    testWidgets('when view presentation has no Mateo view, it should explain the placement requirement', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: mateoTestTheme,
          home: const Scaffold(
            body: MateoHeader(
              presentation: .view(title: Text('Header')),
            ),
          ),
        ),
      );

      expect(
        tester.takeException(),
        isA<FlutterError>().having(
          (error) => error.toString(),
          'message',
          contains('MateoHeaderPresentation.view() requires a Mateo view'),
        ),
      );
    });

    testWidgets('when standalone presentation is nested in a Mateo view, it should keep standalone ownership', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: mateoTestTheme,
          home: const MateoView(
            header: MateoHeader(
              presentation: .standalone(title: Text('Header')),
            ),
            surface: MateoSurface(
              boundaryEffect: MateoBoundaryEffect.fade(),
              child: SizedBox.expand(),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(_headerBoundaryFade, findsOneWidget);
      expect(_surfaceBoundaryFade('top'), findsOneWidget);
      expect(_surfaceBoundaryFade('bottom'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('when presentation changes in a Mateo view, it should add or remove its standalone fade', (
      tester,
    ) async {
      final useViewPresentation = ValueNotifier(true);
      addTearDown(useViewPresentation.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: mateoTestTheme,
          home: ValueListenableBuilder(
            valueListenable: useViewPresentation,
            builder: (context, coordinatesWithView, child) {
              return MateoView(
                header: MateoHeader(
                  presentation: coordinatesWithView
                      ? const .view(title: Text('Header'))
                      : const .standalone(title: Text('Header')),
                ),
                surface: const MateoSurface(
                  boundaryEffect: MateoBoundaryEffect.fade(),
                  child: SizedBox.expand(),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      expect(_headerBoundaryFade, findsNothing);

      useViewPresentation.value = false;
      await tester.pump();
      await tester.pump();

      expect(_headerBoundaryFade, findsOneWidget);

      useViewPresentation.value = true;
      await tester.pump();
      await tester.pump();

      expect(_headerBoundaryFade, findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when leading content is 44px tall, it should add 12px top padding',
      (tester) async {
        await _pumpHeader(
          tester,
          leading: const SizedBox.square(
            key: ValueKey('leading'),
            dimension: 44,
          ),
        );

        expect(tester.getSize(find.byType(MateoHeader)).height, 56);
      },
    );

    testWidgets(
      'when leading content is taller, it should preserve 12px top padding',
      (tester) async {
        await _pumpHeader(
          tester,
          leading: const SizedBox(
            key: ValueKey('leading'),
            width: 44,
            height: 68,
          ),
        );

        expect(tester.getSize(find.byType(MateoHeader)).height, 80);
      },
    );

    testWidgets(
      'when trailing content is tallest, it should determine the header height',
      (tester) async {
        await _pumpHeader(
          tester,
          leading: const SizedBox.square(dimension: 44),
          trailing: const SizedBox(
            key: ValueKey('tall-trailing'),
            width: 44,
            height: 68,
          ),
        );

        expect(tester.getSize(find.byType(MateoHeader)).height, 80);
        expect(
          tester.getCenter(find.byKey(const ValueKey('tall-trailing'))).dy,
          tester.getCenter(find.byType(MateoHeader)).dy + 6,
        );
      },
    );

    testWidgets(
      'when leading content is omitted, it should pad the title intrinsic height',
      (tester) async {
        await _pumpHeader(tester);

        expect(
          tester.getSize(find.byType(MateoHeader)).height,
          tester
                  .getSize(
                    find.byKey(const ValueKey('mateo_header_title')),
                  )
                  .height +
              12,
        );
      },
    );

    testWidgets(
      'when leading content is present, it should inset content and separate the title by 16px',
      (tester) async {
        await _pumpHeader(
          tester,
          leading: const SizedBox.square(
            key: ValueKey('leading'),
            dimension: 44,
          ),
        );

        final leadingRect = tester.getRect(find.byKey(const ValueKey('leading')));
        final titleRect = tester.getRect(
          find.byKey(const ValueKey('mateo_header_title')),
        );

        expect(leadingRect.left, 20);
        expect(titleRect.left - leadingRect.right, 16);
        expect(titleRect.center.dy, leadingRect.center.dy);
      },
    );

    testWidgets(
      'when trailing content is present, it should inset it and separate it from the title by 16px',
      (tester) async {
        await _pumpHeader(
          tester,
          trailing: const SizedBox.square(
            key: ValueKey('trailing'),
            dimension: 44,
          ),
        );

        final headerRect = tester.getRect(find.byType(MateoHeader));
        final titleRect = tester.getRect(
          find.byKey(const ValueKey('mateo_header_title')),
        );
        final trailingRect = tester.getRect(find.byKey(const ValueKey('trailing')));

        expect(headerRect.right - trailingRect.right, 20);
        expect(trailingRect.left - titleRect.right, 16);
        expect(titleRect.center.dy, trailingRect.center.dy);
      },
    );

    testWidgets(
      'when title text changes length, it should preserve the available title width',
      (tester) async {
        const leading = SizedBox.square(
          key: ValueKey('stable-width-leading'),
          dimension: 44,
        );
        const trailing = SizedBox.square(
          key: ValueKey('stable-width-trailing'),
          dimension: 52,
        );
        await _pumpHeader(
          tester,
          title: const Text('Short'),
          leading: leading,
          trailing: trailing,
        );
        final shortTitleWidth = tester
            .getSize(
              find.byKey(const ValueKey('mateo_header_title')),
            )
            .width;

        await _pumpHeader(
          tester,
          title: const Text('A considerably longer view title'),
          leading: leading,
          trailing: trailing,
        );
        await tester.pumpAndSettle();

        expect(
          tester
              .getSize(
                find.byKey(const ValueKey('mateo_header_title')),
              )
              .width,
          shortTitleWidth,
        );
      },
    );

    testWidgets(
      'when centerTitle is enabled, it should center the title against the complete header width',
      (tester) async {
        await _pumpHeader(
          tester,
          centerTitle: true,
          leading: const SizedBox.square(
            key: ValueKey('centered-leading'),
            dimension: 44,
          ),
        );

        expect(
          tester.getCenter(find.byKey(const ValueKey('mateo_header_title'))).dx,
          closeTo(tester.getCenter(find.byType(MateoHeader)).dx, 0.01),
        );
      },
    );

    testWidgets(
      'when a centered title changes length, it should preserve its symmetric title width',
      (tester) async {
        const leading = SizedBox.square(
          key: ValueKey('stable-centered-width-leading'),
          dimension: 44,
        );
        await _pumpHeader(
          tester,
          title: const Text('Short'),
          centerTitle: true,
          leading: leading,
        );
        final shortTitleWidth = tester
            .getSize(
              find.byKey(const ValueKey('mateo_header_title')),
            )
            .width;

        await _pumpHeader(
          tester,
          title: const Text('A considerably longer centered view title'),
          centerTitle: true,
          leading: leading,
        );
        await tester.pumpAndSettle();

        expect(
          tester
              .getSize(
                find.byKey(const ValueKey('mateo_header_title')),
              )
              .width,
          shortTitleWidth,
        );
      },
    );

    testWidgets(
      'when centerTitle is enabled, it should reserve equal space beside the title lane',
      (tester) async {
        await _pumpHeader(
          tester,
          centerTitle: true,
          leading: const SizedBox.square(
            key: ValueKey('symmetric-leading'),
            dimension: 44,
          ),
        );

        final headerRect = tester.getRect(find.byType(MateoHeader));
        final titleRect = tester.getRect(
          find.byKey(const ValueKey('mateo_header_title')),
        );

        expect(
          (titleRect.left - headerRect.left, headerRect.right - titleRect.right),
          (80, 80),
        );
      },
    );

    testWidgets(
      'when centered controls are asymmetric, it should reserve the larger obstruction on both sides',
      (tester) async {
        await _pumpHeader(
          tester,
          centerTitle: true,
          leading: const SizedBox.square(
            key: ValueKey('asymmetric-leading'),
            dimension: 44,
          ),
          trailing: const SizedBox(
            key: ValueKey('asymmetric-trailing'),
            width: 72,
            height: 44,
          ),
        );

        final headerRect = tester.getRect(find.byType(MateoHeader));
        final titleRect = tester.getRect(
          find.byKey(const ValueKey('mateo_header_title')),
        );
        final trailingRect = tester.getRect(
          find.byKey(const ValueKey('asymmetric-trailing')),
        );

        expect(titleRect.center.dx, closeTo(headerRect.center.dx, 0.01));
        expect(
          (titleRect.left - headerRect.left, headerRect.right - titleRect.right),
          (108, 108),
        );
        expect(titleRect.right, lessThanOrEqualTo(trailingRect.left - 16));
      },
    );

    testWidgets(
      'when a centered title is long, it should stay clear of the leading control',
      (tester) async {
        tester.view
          ..devicePixelRatio = 1
          ..physicalSize = const Size(320, 640);
        addTearDown(tester.view.reset);
        await _pumpHeader(
          tester,
          title: const Text('A deliberately long centered Mateo view title'),
          centerTitle: true,
          leading: const SizedBox.square(
            key: ValueKey('long-title-leading'),
            dimension: 44,
          ),
        );

        final leadingRect = tester.getRect(find.byKey(const ValueKey('long-title-leading')));
        final titleRect = tester.getRect(find.byKey(const ValueKey('mateo_header_title')));
        expect(titleRect.left, greaterThanOrEqualTo(leadingRect.right + 16));
        expect(titleRect.right, lessThanOrEqualTo(300));
      },
    );

    testWidgets(
      'when centered controls are asymmetric in right-to-left layout, it should mirror their symmetric lane',
      (
        tester,
      ) async {
        await _pumpHeader(
          tester,
          centerTitle: true,
          textDirection: TextDirection.rtl,
          leading: const SizedBox.square(key: ValueKey('rtl-centered-leading'), dimension: 44),
          trailing: const SizedBox(key: ValueKey('rtl-centered-trailing'), width: 72, height: 44),
        );

        final header = tester.getRect(find.byType(MateoHeader));
        final title = tester.getRect(find.byKey(const ValueKey('mateo_header_title')));
        final leading = tester.getRect(find.byKey(const ValueKey('rtl-centered-leading')));
        final trailing = tester.getRect(find.byKey(const ValueKey('rtl-centered-trailing')));

        expect(leading.right, header.right - 20);
        expect(trailing.left, header.left + 20);
        expect((title.left - header.left, header.right - title.right), (108, 108));
        expect(title.center.dx, header.center.dx);
        expect(title.left - trailing.right, 16);
      },
    );

    testWidgets('when header content is measured dry, it should preserve live size and child positions', (
      tester,
    ) async {
      await _pumpHeader(
        tester,
        centerTitle: true,
        title: const AspectRatio(aspectRatio: 4),
        leading: const SizedBox.square(key: ValueKey('dry-layout-leading'), dimension: 44),
        trailing: const SizedBox(key: ValueKey('dry-layout-trailing'), width: 72, height: 68),
      );
      final content = tester.renderObject<RenderBox>(
        find.descendant(
          of: find.byType(MateoHeader),
          matching: find.byWidgetPredicate(
            (widget) => widget is SlottedMultiChildRenderObjectWidget<Object?, RenderBox>,
          ),
        ),
      );
      final liveSize = content.size;
      final liveTitle = tester.getRect(find.byKey(const ValueKey('mateo_header_title')));
      final liveLeading = tester.getRect(find.byKey(const ValueKey('dry-layout-leading')));
      final liveTrailing = tester.getRect(find.byKey(const ValueKey('dry-layout-trailing')));

      expect(content.getDryLayout(content.constraints), liveSize);
      final narrowSize = content.getDryLayout(BoxConstraints.tightFor(width: liveSize.width / 2));

      expect(narrowSize.width, liveSize.width / 2);
      expect(narrowSize.height, lessThan(liveSize.height));
      expect(content.size, liveSize);
      expect(tester.getRect(find.byKey(const ValueKey('mateo_header_title'))), liveTitle);
      expect(tester.getRect(find.byKey(const ValueKey('dry-layout-leading'))), liveLeading);
      expect(tester.getRect(find.byKey(const ValueKey('dry-layout-trailing'))), liveTrailing);
      expect(content.debugNeedsLayout, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when centered obstructions exhaust the header, it should clamp the title lane to zero',
      (tester) async {
        tester.view
          ..devicePixelRatio = 1
          ..physicalSize = const Size(100, 200);
        addTearDown(tester.view.reset);
        await _pumpHeader(
          tester,
          centerTitle: true,
          leading: const SizedBox.square(
            key: ValueKey('exhausted-leading'),
            dimension: 44,
          ),
          trailing: const SizedBox.square(
            key: ValueKey('exhausted-trailing'),
            dimension: 44,
          ),
        );

        expect(
          tester
              .getSize(
                find.byKey(const ValueKey('mateo_header_title')),
              )
              .width,
          0,
        );
      },
    );

    testWidgets(
      'when centerTitle is enabled in right-to-left layout, it should center the title against the complete header width',
      (tester) async {
        await _pumpHeader(
          tester,
          centerTitle: true,
          textDirection: TextDirection.rtl,
          leading: const SizedBox.square(
            key: ValueKey('centered-rtl-leading'),
            dimension: 44,
          ),
        );

        expect(
          tester.getCenter(find.byKey(const ValueKey('mateo_header_title'))).dx,
          closeTo(tester.getCenter(find.byType(MateoHeader)).dx, 0.01),
        );
      },
    );

    testWidgets(
      'when leading content is omitted, it should align the title to the 20px inset',
      (tester) async {
        await _pumpHeader(tester);

        expect(
          tester
              .getTopLeft(
                find.byKey(const ValueKey('mateo_header_title')),
              )
              .dx,
          20,
        );
      },
    );

    testWidgets(
      'when horizontal cutouts exist, it should place standalone content inside them',
      (tester) async {
        await _pumpHeader(
          tester,
          safeLeft: 44,
          safeRight: 10,
          leading: const SizedBox.square(
            key: ValueKey('safe-leading'),
            dimension: 44,
          ),
          trailing: const SizedBox.square(
            key: ValueKey('safe-trailing'),
            dimension: 44,
          ),
        );

        expect(tester.getTopLeft(find.byKey(const ValueKey('safe-leading'))).dx, 64);
        expect(
          tester.getTopRight(find.byKey(const ValueKey('safe-trailing'))).dx,
          tester.view.physicalSize.width / tester.view.devicePixelRatio - 30,
        );
        expect(
          tester.getBottomRight(find.byKey(const ValueKey('mateo_header_title'))).dx,
          lessThanOrEqualTo(tester.view.physicalSize.width / tester.view.devicePixelRatio - 30),
        );
      },
    );

    testWidgets(
      'when directionality is right to left, it should mirror the leading layout',
      (tester) async {
        await _pumpHeader(
          tester,
          textDirection: TextDirection.rtl,
          leading: const SizedBox.square(
            key: ValueKey('leading'),
            dimension: 44,
          ),
        );

        final leadingRect = tester.getRect(find.byKey(const ValueKey('leading')));
        final titleRect = tester.getRect(
          find.byKey(const ValueKey('mateo_header_title')),
        );

        expect(
          leadingRect.right,
          tester.getSize(find.byType(MateoHeader)).width - 20,
        );
        expect(leadingRect.left - titleRect.right, 16);
      },
    );

    testWidgets(
      'when directionality is right to left, it should mirror the trailing layout',
      (tester) async {
        await _pumpHeader(
          tester,
          textDirection: TextDirection.rtl,
          trailing: const SizedBox.square(
            key: ValueKey('rtl-trailing'),
            dimension: 44,
          ),
        );

        final trailingRect = tester.getRect(find.byKey(const ValueKey('rtl-trailing')));
        final titleRect = tester.getRect(
          find.byKey(const ValueKey('mateo_header_title')),
        );

        expect(trailingRect.left, 20);
        expect(titleRect.left - trailingRect.right, 16);
      },
    );

    testWidgets(
      'when rendered, it should use Mateo header typography and truncation',
      (tester) async {
        await _pumpHeader(tester);

        final title = tester.widget<RichText>(
          find.descendant(
            of: find.byKey(const ValueKey('mateo_header_title')),
            matching: find.byType(RichText),
          ),
        );
        final style = title.text.style!;

        expect(style.fontFamily, MateoTypography.fontFamily);
        expect(style.fontSize, 17);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.color, mateoTestColorScheme.text.primary);
        expect(style.letterSpacing, MateoTypography.letterSpacing);
        expect(title.maxLines, 1);
        expect(title.overflow, TextOverflow.ellipsis);
      },
    );

    testWidgets(
      'when title text supplies a partial style, it should preserve it and inherit the remaining Mateo defaults',
      (tester) async {
        await _pumpHeader(
          tester,
          title: const Text(
            'Custom color',
            style: TextStyle(color: Colors.red),
          ),
        );

        final title = tester.widget<RichText>(
          find.descendant(
            of: find.byKey(const ValueKey('mateo_header_title')),
            matching: find.byType(RichText),
          ),
        );
        final style = title.text.style!;

        expect(style.color, Colors.red);
        expect(style.fontFamily, MateoTypography.fontFamily);
        expect(style.fontSize, 17);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.letterSpacing, MateoTypography.letterSpacing);
      },
    );

    testWidgets(
      'when title text supplies behavior and style, it should not override them',
      (tester) async {
        await _pumpHeader(
          tester,
          title: const Text(
            'Custom title behavior',
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
        );

        final title = tester.widget<RichText>(
          find.descendant(
            of: find.byKey(const ValueKey('mateo_header_title')),
            matching: find.byType(RichText),
          ),
        );
        final style = title.text.style!;

        expect(title.textAlign, TextAlign.end);
        expect(title.maxLines, 2);
        expect(title.overflow, TextOverflow.fade);
        expect(style.fontSize, 22);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.color, mateoTestColorScheme.text.primary);
      },
    );

    testWidgets(
      'when title is not text, it should render the custom widget in the title slot',
      (tester) async {
        await _pumpHeader(
          tester,
          title: const SizedBox(
            key: ValueKey('custom-title'),
            width: 80,
            height: 32,
            child: Icon(Icons.location_on),
          ),
        );

        expect(find.byKey(const ValueKey('custom-title')), findsOneWidget);
        expect(
          tester.getSize(find.byKey(const ValueKey('custom-title'))).height,
          32,
        );
        expect(find.byIcon(Icons.location_on), findsOneWidget);
      },
    );

    testWidgets(
      'when centerTitle is disabled, it should align text to the directional start',
      (tester) async {
        await _pumpHeader(tester);

        expect(
          tester
              .widget<RichText>(
                find.descendant(
                  of: find.byKey(const ValueKey('mateo_header_title')),
                  matching: find.byType(RichText),
                ),
              )
              .textAlign,
          TextAlign.start,
        );
      },
    );

    testWidgets(
      'when centerTitle is enabled, it should align text to the center of its lane',
      (tester) async {
        await _pumpHeader(tester, centerTitle: true);

        expect(
          tester
              .widget<RichText>(
                find.descendant(
                  of: find.byKey(const ValueKey('mateo_header_title')),
                  matching: find.byType(RichText),
                ),
              )
              .textAlign,
          TextAlign.center,
        );
      },
    );

    testWidgets(
      'when exposed to assistive technology, it should identify the title as the platform route header',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          await _pumpHeader(tester);

          final data = tester.getSemantics(find.byKey(const ValueKey('mateo_header_title'))).getSemanticsData();
          expect(find.semantics.byLabel('Header'), findsOneWidget);
          expect(data.flagsCollection.isHeader, isTrue);
          expect(
            data.flagsCollection.namesRoute,
            defaultTargetPlatform == TargetPlatform.android,
          );
        } finally {
          semantics.dispose();
        }
      },
      variant: TargetPlatformVariant(<TargetPlatform>{
        TargetPlatform.android,
        TargetPlatform.iOS,
      }),
    );

    testWidgets(
      'when a top safe inset exists, it should move only the content below it',
      (tester) async {
        await _pumpHeader(
          tester,
          safeTop: 30,
          leading: const SizedBox.square(
            key: ValueKey('leading'),
            dimension: 44,
          ),
        );

        expect(
          tester.getTopLeft(_headerBoundaryFade).dy,
          0,
        );
        expect(
          tester.getTopLeft(find.byKey(const ValueKey('mateo_header_content'))).dy,
          30,
        );
        expect(tester.getTopLeft(find.byKey(const ValueKey('leading'))).dy, 42);
        expect(tester.getSize(find.byType(MateoHeader)).height, 56);
        expect(_fadeExtent(tester), _maximumFadeExtent(tester));
      },
    );

    testWidgets(
      'when no scroll controller is supplied, it should render the full resolved fade',
      (tester) async {
        await _pumpHeader(tester);

        expect(_fadeExtent(tester), _maximumFadeExtent(tester));
      },
    );

    testWidgets(
      'when a controller is unattached, it should render a zero-extent fade',
      (tester) async {
        final controller = ScrollController();
        addTearDown(controller.dispose);

        await _pumpHeader(
          tester,
          scrollController: controller,
        );

        expect(_fadeExtent(tester), 0);
      },
    );

    testWidgets(
      'when a controller has multiple clients, it should follow the notifying vertical position',
      (tester) async {
        final controller = ScrollController();
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          MaterialApp(
            theme: mateoTestTheme,
            home: Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          key: const ValueKey('first-shared-scrollable'),
                          controller: controller,
                          itemExtent: 50,
                          itemCount: 30,
                          itemBuilder: (context, index) => Text('First $index'),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          key: const ValueKey('second-shared-scrollable'),
                          controller: controller,
                          itemExtent: 50,
                          itemCount: 30,
                          itemBuilder: (context, index) => Text('Second $index'),
                        ),
                      ),
                    ],
                  ),
                  MateoHeader(
                    presentation: .standalone(
                      title: const Text('Header'),
                      scrollController: controller,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pump();

        expect(controller.positions, hasLength(2));
        expect(_fadeExtent(tester), 0);

        await tester.drag(
          find.byKey(const ValueKey('first-shared-scrollable')),
          const Offset(0, -80),
        );
        await tester.pump();

        expect(_fadeExtent(tester), greaterThan(0));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when coordinated through wrappers with multiple clients, it should follow the notifying position',
      (tester) async {
        final controller = ScrollController();
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          MaterialApp(
            theme: mateoTestTheme,
            home: MateoView(
              surface: MateoSurface(
                boundaryEffect: const MateoBoundaryEffect.fade(bottom: false),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        key: const ValueKey('first-coordinated-scrollable'),
                        controller: controller,
                        itemExtent: 50,
                        itemCount: 30,
                        itemBuilder: (context, index) => Text('First $index'),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        key: const ValueKey('second-coordinated-scrollable'),
                        controller: controller,
                        itemExtent: 50,
                        itemCount: 30,
                        itemBuilder: (context, index) => Text('Second $index'),
                      ),
                    ),
                  ],
                ),
              ),
              header: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: MateoHeader(
                  presentation: .view(
                    title: const Text('Header'),
                    scrollController: controller,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(controller.positions, hasLength(2));
        expect(_fadeExtent(tester), 0);

        await tester.drag(
          find.byKey(const ValueKey('second-coordinated-scrollable')),
          const Offset(0, -80),
        );
        await tester.pump();

        expect(_fadeExtent(tester), greaterThan(0));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when content scrolls, it should expand rapidly from zero to the maximum extent',
      (tester) async {
        final controller = ScrollController();
        addTearDown(controller.dispose);

        await _pumpScrollableHeader(tester, controller: controller);
        expect(_fadeExtent(tester), 0);

        controller.jumpTo(60);
        await tester.pump();
        final maximumExtent = _maximumFadeExtent(tester);
        final remaining = 1 - 60 / maximumExtent;
        final remainingSquared = remaining * remaining;
        final remainingFourth = remainingSquared * remainingSquared;
        expect(
          _fadeExtent(tester),
          closeTo(maximumExtent * (1 - remainingFourth * remainingFourth), 0.001),
        );

        controller.jumpTo(120);
        await tester.pump();
        expect(_fadeExtent(tester), maximumExtent);

        controller.jumpTo(240);
        await tester.pump();
        expect(_fadeExtent(tester), maximumExtent);
      },
    );

    testWidgets(
      'when a controller starts scrolled, it should paint the initial fade without a rebuild',
      (tester) async {
        final controller = ScrollController(initialScrollOffset: 60);
        addTearDown(controller.dispose);

        await _pumpScrollableHeader(tester, controller: controller);

        final maximumExtent = _maximumFadeExtent(tester);
        final remaining = 1 - 60 / maximumExtent;
        final remainingSquared = remaining * remaining;
        final remainingFourth = remainingSquared * remainingSquared;
        expect(
          _fadeExtent(tester),
          closeTo(maximumExtent * (1 - remainingFourth * remainingFourth), 0.001),
        );
      },
    );

    testWidgets(
      'when content dimensions shrink, it should refresh the fade from observed metrics',
      (tester) async {
        final controller = ScrollController();
        final itemCount = ValueNotifier(20);
        addTearDown(controller.dispose);
        addTearDown(itemCount.dispose);
        await tester.pumpWidget(
          MaterialApp(
            theme: mateoTestTheme,
            home: Scaffold(
              body: Stack(
                children: [
                  ValueListenableBuilder(
                    valueListenable: itemCount,
                    builder: (context, count, child) => ListView.builder(
                      controller: controller,
                      itemExtent: 60,
                      itemCount: count,
                      itemBuilder: (context, index) => Text('Item $index'),
                    ),
                  ),
                  MateoHeader(
                    presentation: .standalone(
                      title: const Text('Header'),
                      scrollController: controller,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pump();
        controller.jumpTo(120);
        await tester.pump();
        expect(_fadeExtent(tester), _maximumFadeExtent(tester));

        itemCount.value = 1;
        await tester.pump();
        await tester.pump();

        expect(controller.offset, 0);
        expect(_fadeExtent(tester), 0);
      },
    );

    testWidgets(
      'when reversed content dimensions change at the same offset, it should refresh the physical top fade',
      (tester) async {
        final controller = ScrollController();
        final itemCount = ValueNotifier(12);
        addTearDown(controller.dispose);
        addTearDown(itemCount.dispose);
        await tester.pumpWidget(
          MaterialApp(
            theme: mateoTestTheme,
            home: Scaffold(
              body: Stack(
                children: [
                  ValueListenableBuilder(
                    valueListenable: itemCount,
                    builder: (context, count, child) => ListView.builder(
                      reverse: true,
                      controller: controller,
                      itemExtent: 60,
                      itemCount: count,
                      itemBuilder: (context, index) => Text('Item $index'),
                    ),
                  ),
                  MateoHeader(
                    presentation: .standalone(
                      title: const Text('Header'),
                      scrollController: controller,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pump();
        final initialExtent = _fadeExtent(tester);

        itemCount.value = 11;
        await tester.pump();
        await tester.pump();

        expect(controller.offset, 0);
        expect(_fadeExtent(tester), allOf(greaterThan(0), lessThan(initialExtent)));
      },
    );

    testWidgets(
      'when the fade overflows the header, it should not change layout or block content beneath it',
      (tester) async {
        var tapCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            theme: mateoTestTheme,
            home: Scaffold(
              body: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => tapCount++,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: MateoHeader(
                      presentation: .standalone(title: Text('Header')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(
          tester.getSize(find.byType(MateoHeader)).height,
          lessThan(120),
        );
        await tester.tapAt(const Offset(160, 100));
        await tester.pump();
        expect(tapCount, 1);
      },
    );

    testWidgets(
      'when controllers are replaced, it should detach from the previous controller',
      (tester) async {
        final fixtureKey = GlobalKey<_ControllerReplacementFixtureState>();
        await tester.pumpWidget(
          MaterialApp(
            theme: mateoTestTheme,
            home: Scaffold(
              body: _ControllerReplacementFixture(key: fixtureKey),
            ),
          ),
        );

        final state = fixtureKey.currentState!;
        expect(state.firstController.hasListeners, isTrue);

        state.useSecondController();
        await tester.pump();

        expect(state.firstController.hasListeners, isFalse);
        expect(state.secondController.hasListeners, isTrue);
      },
    );

    testWidgets(
      'when slots are supplied, it should not add Morph wrappers',
      (tester) async {
        await _pumpHeader(
          tester,
          title: const Text('Header', key: ValueKey('title')),
          leading: const SizedBox.square(
            key: ValueKey('leading'),
            dimension: 44,
          ),
          trailing: const SizedBox.square(
            key: ValueKey('trailing'),
            dimension: 44,
          ),
        );

        for (final key in const [
          ValueKey('leading'),
          ValueKey('title'),
          ValueKey('trailing'),
        ]) {
          expect(
            find.ancestor(of: find.byKey(key), matching: find.byType(Morph)),
            findsNothing,
          );
        }
        expect(find.byType(Morph), findsNothing);
      },
    );

    testWidgets(
      'when callers wrap slots in Morph, it should preserve their wrappers',
      (tester) async {
        await _pumpHeader(
          tester,
          title: const Morph(
            tag: 'title',
            child: Text('Header'),
          ),
          leading: const Morph(
            tag: 'leading',
            child: SizedBox.square(dimension: 44),
          ),
          trailing: const Morph(
            tag: 'trailing',
            child: SizedBox.square(dimension: 44),
          ),
        );

        expect(
          find.byType(Morph).evaluate().map((element) => (element.widget as Morph).tag),
          containsAll(const ['leading', 'title', 'trailing']),
        );
        expect(find.byType(Morph), findsNWidgets(3));
      },
    );
  });
}

double _fadeExtent(WidgetTester tester) {
  final fade = _headerBoundaryFade.evaluate().isEmpty ? _surfaceBoundaryFade('top') : _headerBoundaryFade;
  return (tester.getBottomLeft(fade).dy - tester.getTopLeft(fade).dy).abs();
}

double _maximumFadeExtent(WidgetTester tester) {
  if (_headerBoundaryFade.evaluate().isEmpty) {
    return tester.getSize(_surfaceBoundaryFade('top')).height;
  }
  return tester
      .getSize(
        find.byKey(const ValueKey('mateo_header_boundary_fade_maximum')),
      )
      .height;
}

final Finder _headerBoundaryFade = find.byKey(
  const ValueKey('mateo_header_boundary_fade'),
);

Finder _surfaceBoundaryFade(String position) {
  return find.byKey(ValueKey('mateo_surface_boundary_fade_$position'));
}

Future<void> _pumpHeader(
  WidgetTester tester, {
  Widget title = const Text('Header'),
  Widget? leading,
  Widget? trailing,
  bool centerTitle = false,
  ScrollController? scrollController,
  EdgeInsetsGeometry? padding,
  TextDirection textDirection = TextDirection.ltr,
  double safeTop = 0,
  double safeLeft = 0,
  double safeRight = 0,
  Key? headerKey,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: mateoTestTheme,
      home: MediaQuery(
        data: MediaQueryData(
          size: tester.view.physicalSize / tester.view.devicePixelRatio,
          devicePixelRatio: tester.view.devicePixelRatio,
          padding: EdgeInsets.only(left: safeLeft, top: safeTop, right: safeRight),
        ),
        child: Directionality(
          textDirection: textDirection,
          child: Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: MateoHeader(
                presentation: padding == null
                    ? MateoHeaderPresentation.standalone(
                        title: title,
                        leading: leading,
                        trailing: trailing,
                        centerTitle: centerTitle,
                        scrollController: scrollController,
                      )
                    : MateoHeaderPresentation.standalone(
                        title: title,
                        leading: leading,
                        trailing: trailing,
                        centerTitle: centerTitle,
                        padding: padding,
                        scrollController: scrollController,
                      ),
                key: headerKey,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _pumpScrollableHeader(
  WidgetTester tester, {
  required ScrollController controller,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: mateoTestTheme,
      home: Scaffold(
        body: Stack(
          children: [
            ListView.builder(
              controller: controller,
              itemExtent: 60,
              itemCount: 20,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
            MateoHeader(
              presentation: .standalone(
                title: const Text('Header'),
                scrollController: controller,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ControllerReplacementFixture extends StatefulWidget {
  const _ControllerReplacementFixture({super.key});

  @override
  State<_ControllerReplacementFixture> createState() => _ControllerReplacementFixtureState();
}

class _ControllerReplacementFixtureState extends State<_ControllerReplacementFixture> {
  final firstController = ScrollController();
  final secondController = ScrollController();
  late ScrollController _activeController = firstController;

  void useSecondController() {
    setState(() => _activeController = secondController);
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          controller: _activeController,
          itemExtent: 60,
          itemCount: 20,
          itemBuilder: (context, index) => Text('Item $index'),
        ),
        MateoHeader(
          presentation: .standalone(
            title: const Text('Header'),
            scrollController: _activeController,
          ),
        ),
      ],
    );
  }
}
