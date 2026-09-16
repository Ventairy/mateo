part of 'base_mateo_view.dart';

final class _MateoViewFooterLayoutData {
  final MaybeSafeAreaHandle safeAreaHandle = MaybeSafeAreaHandle();
  final ValueNotifier<double> _height = ValueNotifier(0);
  late final Listenable changes = Listenable.merge([_height, safeAreaHandle]);

  double get height => _height.value;
  set height(double value) => _height.value = value;

  double get topOffset => safeAreaHandle.adjustedBounds?.top ?? 0;

  void dispose() {
    _height.dispose();
    safeAreaHandle.dispose();
  }
}
