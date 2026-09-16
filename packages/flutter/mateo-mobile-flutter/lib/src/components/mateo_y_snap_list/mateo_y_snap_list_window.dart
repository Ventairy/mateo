part of 'mateo_y_snap_list.dart';

@immutable
class _MateoYSnapListWindow<T> {
  const _MateoYSnapListWindow({
    required this.previousCard,
    required this.currentCard,
    required this.nextCard,
    required this.paginationCard,
    required this.terminalCard,
  });

  final _MateoYSnapListCachedItem<T>? previousCard;
  final _MateoYSnapListCachedItem<T>? currentCard;
  final _MateoYSnapListCachedItem<T>? nextCard;
  final Widget? paginationCard;
  final Widget? terminalCard;
}
