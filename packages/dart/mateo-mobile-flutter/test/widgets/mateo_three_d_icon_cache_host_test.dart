import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/src/components/mateo_icon/mateo_icon.dart' show MateoThreeDIconCacheHost;
import 'package:mateo_mobile/src/gen/three_d_icons.g.dart';

void main() {
  for (final dispose in [false, true]) {
    testWidgets(
      'when ${dispose ? 'the app disposes' : 'memory pressure arrives'}, it should release the isolated 3D icon cache',
      (tester) async {
        late BuildContext context;
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(devicePixelRatio: 2),
            child: MateoThreeDIconCacheHost(
              child: Builder(
                builder: (value) {
                  context = value;
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );
        await tester.pump();
        final cache = MateoThreeDIconCacheHost.cacheOf(context)!;
        await tester.runAsync(
          () => $ThreeDIconsCache.precachePencil(
            context,
            width: 112,
            height: 112,
            package: 'mateo_mobile',
            imageCache: cache,
          ),
        );
        final loaded = cache.currentSize;
        if (dispose) {
          await tester.pumpWidget(const SizedBox.shrink());
        } else {
          tester.binding.handleMemoryPressure();
          await tester.pump();
        }
        expect((loaded, cache.currentSize, cache.pendingImageCount, cache.maximumSizeBytes), (1, 0, 0, 8388608));
      },
    );
  }
}
