part of 'mateo_environment.dart';

enum _MateoEnvironmentAspect { likelyPhoneCountry }

class _MateoEnvironmentProvider extends InheritedModel<_MateoEnvironmentAspect> {
  const _MateoEnvironmentProvider({
    required this.likelyPhoneCountry,
    required super.child,
  });

  final Country? likelyPhoneCountry;

  @override
  bool updateShouldNotify(_MateoEnvironmentProvider oldWidget) => oldWidget.likelyPhoneCountry != likelyPhoneCountry;

  @override
  bool updateShouldNotifyDependent(
    _MateoEnvironmentProvider oldWidget,
    Set<_MateoEnvironmentAspect> dependencies,
  ) =>
      dependencies.contains(_MateoEnvironmentAspect.likelyPhoneCountry) &&
      oldWidget.likelyPhoneCountry != likelyPhoneCountry;
}
