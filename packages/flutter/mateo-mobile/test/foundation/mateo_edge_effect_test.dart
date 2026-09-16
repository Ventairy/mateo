import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  test('when no treatment is declared, it should select no sides', () {
    const effect = MateoEdgeEffect.none();
    expect(effect.type, MateoEdgeEffectType.none);
    expect(effect.at, isEmpty);
    expect(() => effect.at.add(.top), throwsUnsupportedError);
  });

  test('when fade sides are omitted, it should select both vertical sides', () {
    final effect = MateoEdgeEffect.fade();
    expect(effect.type, MateoEdgeEffectType.fade);
    expect(effect.at, {MateoEdgeEffectSide.top, MateoEdgeEffectSide.bottom});
  });

  test('when one side is selected, it should retain only that side', () {
    for (final side in MateoEdgeEffectSide.values) {
      final effect = MateoEdgeEffect.fade(at: [side]);
      expect(effect.type, MateoEdgeEffectType.fade);
      expect(effect.at, {side});
    }
  });

  test('when the selection is explicitly empty, it should remain a fade with no sides', () {
    final effect = MateoEdgeEffect.fade(at: const []);
    expect(effect.type, MateoEdgeEffectType.fade);
    expect(effect.at, isEmpty);
    expect(effect, isNot(const MateoEdgeEffect.none()));
  });

  test('when sides are repeated, it should collapse duplicates', () {
    final effect = MateoEdgeEffect.fade(at: const [.bottom, .top, .bottom, .top]);
    expect(effect.at, {MateoEdgeEffectSide.top, MateoEdgeEffectSide.bottom});
  });

  test('when the supplied collection changes, it should preserve the copied selection', () {
    final sides = <MateoEdgeEffectSide>[.top];
    final effect = MateoEdgeEffect.fade(at: sides);
    sides
      ..clear()
      ..add(.bottom);
    expect(effect.at, {MateoEdgeEffectSide.top});
  });

  test('when an iterable is supplied, it should capture its current elements', () {
    final sides = <MateoEdgeEffectSide>[.bottom, .top];
    final effect = MateoEdgeEffect.fade(at: sides.where((side) => side == .bottom));
    sides.clear();
    expect(effect.at, {MateoEdgeEffectSide.bottom});
  });

  test('when the exposed fade selection is mutated, it should reject changes', () {
    final effect = MateoEdgeEffect.fade(at: const [.top]);
    expect(() => effect.at.add(.bottom), throwsUnsupportedError);
    expect(() => effect.at.remove(MateoEdgeEffectSide.top), throwsUnsupportedError);
    expect(effect.at, {MateoEdgeEffectSide.top});
  });

  test('when selections differ only in order or duplicates, it should have equal values and hashes', () {
    final first = MateoEdgeEffect.fade(at: const [.top, .bottom]);
    final second = MateoEdgeEffect.fade(at: const [.bottom, .top, .bottom]);
    expect(first, second);
    expect(second, first);
    expect(first.hashCode, second.hashCode);
    expect({first, second}, hasLength(1));
    expect(first, isNot(MateoEdgeEffect.fade(at: const [.top])));
    expect(first, isNot('fade'));
    expect(MateoEdgeEffect.fade(at: const []), MateoEdgeEffect.fade(at: const []));
  });
}
