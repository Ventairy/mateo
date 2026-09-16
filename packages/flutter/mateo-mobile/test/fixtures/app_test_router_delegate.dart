import 'package:flutter/widgets.dart';

part '_app_test_page.dart';

/// A small page-based router used to exercise the app's routing contract.
class AppTestRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  /// Creates a router whose initial page displays [home].
  AppTestRouterDelegate({required this.home});

  /// The content of the initial page.
  final Widget home;

  bool _showDetails = false;

  /// The key for the router's navigator.
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// The current route name.
  @override
  Object get currentConfiguration => _showDetails ? 'details' : 'home';

  /// Pushes a second page through the delegate.
  void showDetails() {
    _showDetails = true;
    notifyListeners();
  }

  /// Resolves a route name restored by Flutter.
  @override
  Future<void> setNewRoutePath(Object configuration) async {
    _showDetails = configuration == 'details';
  }

  /// Builds the navigator and its current pages.
  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    pages: [
      _AppTestPage(key: const ValueKey('home'), child: home),
      if (_showDetails)
        const _AppTestPage(
          key: ValueKey('details'),
          child: Center(child: Text('Router details')),
        ),
    ],
    onDidRemovePage: (page) {
      if (page.key == const ValueKey('details')) {
        _showDetails = false;
        notifyListeners();
      }
    },
  );
}
