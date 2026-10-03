import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/mateo_surface_obstruction.dart';

class ObstructionInsetsSource implements MateoSurfaceObstruction {
  ObstructionInsetsSource(EdgeInsets initialInsets) : insets = ValueNotifier(initialInsets);

  @override
  EdgeInsets get layoutInsets => insets.value;

  @override
  EdgeInsets resolvePaintInsets() => insets.value;

  @override
  void addListener(VoidCallback listener) => obstructionInsetsChanges.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => obstructionInsetsChanges.removeListener(listener);

  final ValueNotifier<EdgeInsets> insets;

  late final Listenable obstructionInsetsChanges = Listenable.merge([headerChanges, footerChanges]);

  final ChangeNotifier headerChanges = ChangeNotifier();
  final ChangeNotifier footerChanges = ChangeNotifier();

  void dispose() {
    insets.dispose();
    headerChanges.dispose();
    footerChanges.dispose();
  }
}
