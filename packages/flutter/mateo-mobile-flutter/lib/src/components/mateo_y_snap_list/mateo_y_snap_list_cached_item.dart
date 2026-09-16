part of 'mateo_y_snap_list.dart';

final class _MateoYSnapListCardKey extends ValueKey<Object> {
  const _MateoYSnapListCardKey(super.value);
}

class _MateoYSnapListCardTickerMode extends StatefulWidget {
  const _MateoYSnapListCardTickerMode({
    required this.motionListenable,
    required this.isCurrent,
    required this.child,
    super.key,
  });

  final ValueListenable<bool> motionListenable;
  final bool isCurrent;
  final Widget child;

  @override
  State<_MateoYSnapListCardTickerMode> createState() => _MateoYSnapListCardTickerModeState();
}

class _MateoYSnapListCardTickerModeState extends State<_MateoYSnapListCardTickerMode> {
  @override
  void initState() {
    super.initState();
    widget.motionListenable.addListener(_handleMotionChanged);
  }

  @override
  void didUpdateWidget(covariant _MateoYSnapListCardTickerMode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.motionListenable, widget.motionListenable)) return;

    oldWidget.motionListenable.removeListener(_handleMotionChanged);
    widget.motionListenable.addListener(_handleMotionChanged);
  }

  @override
  void dispose() {
    widget.motionListenable.removeListener(_handleMotionChanged);
    super.dispose();
  }

  void _handleMotionChanged() {
    if (!widget.isCurrent) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TickerMode(
      enabled: widget.isCurrent || widget.motionListenable.value,
      child: widget.child,
    );
  }
}

@immutable
class _MateoYSnapListCachedItem<T> {
  const _MateoYSnapListCachedItem({
    required this.item,
    required this.itemKey,
    required this.index,
    required this.child,
  });

  final T item;
  final Object itemKey;
  final int index;
  final Widget child;
}
