part of 'app_test_router_delegate.dart';

class _AppTestPage extends Page<void> {
  const _AppTestPage({required this.child, super.key});

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) => PageRouteBuilder<void>(
    settings: this,
    transitionDuration: .zero,
    reverseTransitionDuration: .zero,
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );
}
