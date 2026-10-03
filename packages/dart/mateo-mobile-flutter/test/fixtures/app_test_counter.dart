import 'package:flutter/widgets.dart';

/// A restorable counter for verifying app state preservation.
class AppTestCounter extends StatefulWidget {
  /// Creates the test counter.
  const AppTestCounter({super.key});

  /// Creates the counter's state.
  @override
  State<AppTestCounter> createState() => _AppTestCounterState();
}

class _AppTestCounterState extends State<AppTestCounter> with RestorationMixin {
  final _count = RestorableInt(0);

  @override
  String get restorationId => 'counter';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_count, 'count');
  }

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
    child: GestureDetector(
      onTap: () => setState(() => _count.value++),
      child: Text('Count: ${_count.value}'),
    ),
  );
}
