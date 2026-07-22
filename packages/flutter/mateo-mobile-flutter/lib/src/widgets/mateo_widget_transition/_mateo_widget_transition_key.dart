part of 'mateo_widget_transition.dart';

@immutable
class _MateoWidgetTransitionKey {
  const _MateoWidgetTransitionKey(this.type, this.key);

  final Type type;
  final Key? key;

  @override
  bool operator ==(Object other) =>
      other is _MateoWidgetTransitionKey &&
      other.type == type &&
      other.key == key;

  @override
  int get hashCode => Object.hash(type, key);
}
