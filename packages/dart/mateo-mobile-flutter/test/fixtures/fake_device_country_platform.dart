import 'package:oh_my_flutter/src/device/device_locale/device_locale_platform.dart';
import 'package:oh_my_flutter/src/device/device_sim/device_sim_platform.dart';

final class FakeDeviceCountryPlatform extends DeviceSimPlatform implements DeviceLocalePlatform {
  FakeDeviceCountryPlatform(this._getCountry);

  final Future<String?> Function() _getCountry;

  int calls = 0;

  @override
  Future<String?> getCountry() {
    calls++;
    return _getCountry();
  }
}
