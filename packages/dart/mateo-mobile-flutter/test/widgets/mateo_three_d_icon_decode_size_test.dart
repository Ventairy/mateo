import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/components/mateo_icon/mateo_icon.dart' show MateoThreeDIconCacheHost;
import 'package:mateo_mobile/src/gen/three_d_icons.g.dart';

void main() {
  for (final scenario in [
    (size: 48.0, pixelRatio: 1.0, background: false),
    (size: 104.0, pixelRatio: 2.0, background: false),
    (size: 124.0, pixelRatio: 3.0, background: true),
  ]) {
    testWidgets(
      'when a ${scenario.size}px 3D icon renders at ${scenario.pixelRatio}x with background ${scenario.background}, it should decode at its displayed artwork size',
      (tester) async {
        final palette = MateoPalette();
        await tester.pumpWidget(
          Directionality(
            textDirection: .ltr,
            child: MediaQuery(
              data: MediaQueryData(devicePixelRatio: scenario.pixelRatio),
              child: Center(
                child: MateoIcon(
                  .magnifyingGlass,
                  style: .threeD,
                  size: scenario.size,
                  backgroundColor: scenario.background ? palette.white : null,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final provider = tester.widget<Image>(find.byType(Image)).image as ResizeImage;
        final expectedPixels = (scenario.size * scenario.pixelRatio * (scenario.background ? 0.65 : 1)).ceil();
        expect((provider.width, provider.height), (expectedPixels, expectedPixels));
      },
    );

    testWidgets(
      'when preloading a ${scenario.size}px 3D icon at ${scenario.pixelRatio}x with background ${scenario.background}, it should reuse the decoded artwork synchronously',
      (tester) async {
        imageCache.clear();
        addTearDown(imageCache.clear);
        final icon = MateoIcon(
          .magnifyingGlass,
          style: .threeD,
          backgroundColor: scenario.background ? MateoPalette().white : null,
        );
        late BuildContext preloadContext;
        Widget host(Widget child) => Directionality(
          textDirection: .ltr,
          child: MediaQuery(
            data: MediaQueryData(devicePixelRatio: scenario.pixelRatio),
            child: MateoThreeDIconCacheHost(
              child: MateoIconScope(
                size: scenario.size,
                child: Center(child: child),
              ),
            ),
          ),
        );
        await tester.pumpWidget(
          host(
            Builder(
              builder: (context) {
                preloadContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        final isolated = MateoThreeDIconCacheHost.cacheOf(preloadContext)!;
        final size = scenario.size * (scenario.background ? 0.65 : 1);
        await tester.runAsync(
          () => $ThreeDIconsCache.precacheMagnifyingGlass(
            preloadContext,
            width: size,
            height: size,
            package: 'mateo_mobile',
            imageCache: isolated,
          ),
        );
        imageCache.clear();
        await tester.pumpWidget(host(icon));
        await tester.pumpAndSettle();
        final provider = tester.widget<Image>(find.byType(Image)).image;
        final stream = provider.resolve(createLocalImageConfiguration(tester.element(find.byType(Image))));
        var synchronous = false;
        final listener = ImageStreamListener((image, synchronousCall) {
          synchronous = synchronousCall;
          image.dispose();
        });
        stream
          ..addListener(listener)
          ..removeListener(listener);
        expect((synchronous, isolated.currentSize, imageCache.currentSize), (true, 1, 0));
      },
    );
  }
}
