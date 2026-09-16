part of '../../mateo_page.dart';

final _mateoWhiteByAlpha = List<Color?>.filled(256, null, growable: false);

Color _mateoWhiteWithAlpha(int alpha) {
  return _mateoWhiteByAlpha[alpha] ??= Color(
    (alpha << 24) | 0x00FFFFFF,
  );
}
