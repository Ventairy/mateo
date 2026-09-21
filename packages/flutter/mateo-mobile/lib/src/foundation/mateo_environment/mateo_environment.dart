import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart' show Country, DeviceLocale, DeviceSim;

part '_mateo_environment_provider.dart';

/// Provides runtime environment knowledge to Mateo components.
class MateoEnvironment extends StatefulWidget {
  /// Creates the environment for [child].
  const MateoEnvironment({required this.child, super.key});

  /// The subtree that can read Mateo's environment knowledge.
  final Widget child;

  /// Returns the likely phone country and rebuilds only when it changes.
  static Country? likelyPhoneCountryOf(BuildContext context) => InheritedModel.inheritFrom<_MateoEnvironmentProvider>(
    context,
    aspect: _MateoEnvironmentAspect.likelyPhoneCountry,
  )?.likelyPhoneCountry;

  @override
  State<MateoEnvironment> createState() => _MateoEnvironmentState();
}

class _MateoEnvironmentState extends State<MateoEnvironment> {
  Country? _likelyPhoneCountry;

  @override
  void initState() {
    super.initState();
    unawaited(_loadLikelyPhoneCountry());
  }

  Future<void> _loadLikelyPhoneCountry() async {
    final simCountry = await const DeviceSim().getCountry();
    if (_supportsPhoneNumbers(simCountry)) {
      _updateLikelyPhoneCountry(simCountry!);
      return;
    }

    final localeCountry = await const DeviceLocale().getCountry();
    if (_supportsPhoneNumbers(localeCountry)) {
      _updateLikelyPhoneCountry(localeCountry!);
    }
  }

  bool _supportsPhoneNumbers(Country? country) => country?.callingCode != null;

  void _updateLikelyPhoneCountry(Country country) {
    if (!mounted || _likelyPhoneCountry == country) return;
    setState(() => _likelyPhoneCountry = country);
  }

  @override
  Widget build(BuildContext context) => _MateoEnvironmentProvider(
    likelyPhoneCountry: _likelyPhoneCountry,
    child: widget.child,
  );
}
