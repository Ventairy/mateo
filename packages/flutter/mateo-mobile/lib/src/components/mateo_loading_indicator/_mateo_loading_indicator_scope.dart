part of 'mateo_loading_indicator.dart';

class _MateoLoadingIndicatorScope extends InheritedWidget {
  const _MateoLoadingIndicatorScope({required this.progress, required this.semanticLabel, required super.child});

  final Animation<double>? progress;
  final String? semanticLabel;

  static _MateoLoadingIndicatorScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MateoLoadingIndicatorScope>();

    if (scope == null) {
      throw FlutterError('A MateoLoadingIndicatorPresentation must be mounted by MateoLoadingIndicator.');
    }

    return scope;
  }

  @override
  bool updateShouldNotify(_MateoLoadingIndicatorScope oldWidget) =>
      progress != oldWidget.progress || semanticLabel != oldWidget.semanticLabel;
}
