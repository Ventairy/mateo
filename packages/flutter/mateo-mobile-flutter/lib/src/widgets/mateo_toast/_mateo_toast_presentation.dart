part of 'mateo_toast.dart';

class _MateoToastPresentation {
  const _MateoToastPresentation({required this.entry});

  final OverlayEntry entry;

  void remove() {
    if (!entry.mounted) return;

    entry.remove();
  }
}
