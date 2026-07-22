part of 'mateo_widget_transition.dart';

class _MateoWidgetTransitionEntry {
  _MateoWidgetTransitionEntry(this.widget, this.key)
    : globalKey = GlobalKey(debugLabel: 'mateo_wt_entry');

  Widget widget;
  final _MateoWidgetTransitionKey key;
  final GlobalKey globalKey;
}
