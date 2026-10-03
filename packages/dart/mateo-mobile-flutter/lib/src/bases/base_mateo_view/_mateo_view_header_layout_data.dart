part of 'base_mateo_view.dart';

final class _MateoViewHeaderLayoutData {
  final MaybeSafeAreaHandle safeAreaHandle = MaybeSafeAreaHandle();
  final ValueNotifier<double> _height = ValueNotifier(0);
  late final Listenable changes = Listenable.merge([_height, safeAreaHandle]);

  double get height => _height.value;
  set height(double value) => _height.value = value;

  double get bottomOffset => (safeAreaHandle.adjustedBounds?.bottom ?? height).clamp(0, double.infinity);

  void dispose() {
    _height.dispose();
    safeAreaHandle.dispose();
  }
}
