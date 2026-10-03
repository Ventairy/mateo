import 'package:flutter/widgets.dart';

/// Records navigator events without a mocking dependency.
class AppTestNavigatorObserver extends NavigatorObserver {
  /// The routes observed entering the stack.
  final List<Route<dynamic>> pushed = [];

  /// The routes observed leaving the stack.
  final List<Route<dynamic>> popped = [];

  /// Records the pushed [route].
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => pushed.add(route);

  /// Records the popped [route].
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => popped.add(route);
}
