part of 'mateo_toast.dart';

class _MateoToastEntry {
  const _MateoToastEntry({required this.entry});

  final OverlayEntry entry;

  void remove() {
    if (!entry.mounted) return;

    entry.remove();
  }
}
