import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/components/mateo_menu/overlay/show_mateo_menu.dart';

import 'surface_transform_test_widgets.dart';

class MenuOverlayGoldenScene extends StatefulWidget {
  const MenuOverlayGoldenScene({required this.anchorTop, this.direction = .ltr, this.width = .fit, super.key});
  final double anchorTop;
  final TextDirection direction;
  final MateoMenuWidth width;

  @override
  State<MenuOverlayGoldenScene> createState() => _MenuOverlayGoldenSceneState();
}

class _MenuOverlayGoldenSceneState extends State<MenuOverlayGoldenScene> {
  final MateoNavigatorObserver _navigatorObserver = MateoNavigatorObserver();
  bool _opened = false;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: widget.direction,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(360, 480)),
      child: MateoTheme(
        data: surfaceTransformTheme,
        child: Navigator(
          observers: [_navigatorObserver],
          onGenerateRoute: (_) => PageRouteBuilder<void>(
            pageBuilder: (context, _, _) => ColoredBox(
              color: surfaceTransformTheme.colorScheme.background,
              child: Stack(
                children: [
                  Positioned(
                    top: widget.anchorTop,
                    left: widget.direction == TextDirection.ltr ? 24 : null,
                    right: widget.direction == TextDirection.rtl ? 24 : null,
                    child: KeyedSubtree(
                      child: Builder(
                        builder: (anchorContext) {
                          if (!_opened) {
                            _opened = true;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted) return;
                              unawaited(
                                showMateoMenu(
                                  surfaceAnimation: const .none(),
                                  placement: (anchor, size, bounds) => Offset(
                                    widget.direction == TextDirection.rtl ? bounds.right - size.width : bounds.left,
                                    anchor.center.dy > bounds.center.dy ? anchor.top - size.height : anchor.bottom,
                                  ),

                                  anchorContext: anchorContext,
                                  menu: MateoMenu(
                                    presentation: .options(
                                      width: widget.width,
                                      items: const [
                                        MateoMenuOptionsPresentationItem(
                                          principal: Text('View details'),
                                          supporting: Text('More about this item'),
                                        ),
                                        MateoMenuOptionsPresentationItem(
                                          leading: MateoIcon(.paperPlaneUpRight),
                                          principal: Text('Share'),
                                        ),
                                      ],
                                    ),
                                    onItemPressed: (_) {},
                                  ),
                                ),
                              );
                            });
                          }
                          return MateoButton(
                            presentation: const .label(label: 'Options', variant: .secondary, width: .fit),
                            onPressed: () {},
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
