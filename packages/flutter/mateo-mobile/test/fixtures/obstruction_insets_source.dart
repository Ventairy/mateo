import 'package:flutter/widgets.dart';

class ObstructionInsetsSource {
  ObstructionInsetsSource(EdgeInsets initialInsets) : insets = ValueNotifier(initialInsets);

  EdgeInsets get obstructionInsets => insets.value;

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
