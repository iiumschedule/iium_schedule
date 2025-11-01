import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

///service class encapsulate the logic of getting device info
class HomeService {
  /// Get the device information
  Future<String?> getDeviceInfo() async {
    var deviceInfo = await DeviceInfoPlugin().deviceInfo;

    String? deviceInfoData;

    // check device info is android, windows or web
    if (deviceInfo is AndroidDeviceInfo) {
      var androidVersion = deviceInfo.version;
      // eg: Android 11 (30)
      deviceInfoData =
          'Android ${androidVersion.release} (${androidVersion.sdkInt})';
    } else if (deviceInfo is WindowsDeviceInfo) {
      var windowsVersion = deviceInfo.displayVersion;
      // eg: Windows 22H2
      deviceInfoData = 'Windows $windowsVersion';
    } else if (deviceInfo is MacOsDeviceInfo) {
      var macVersion = deviceInfo.osRelease;
      // eg: MacOS 13.4.1
      deviceInfoData = 'MacOS $macVersion';
    }

    return deviceInfoData;
  }

  /// Get the package (app) info
  Future<String> getPackageInfo() async {
    var packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
