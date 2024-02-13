import 'package:device_info_plus/device_info_plus.dart';

class HomeService {
  //service class encapsulate the logic of getting device info
  Future<String> getDeviceInfo() async{
    var deviceInfo = await DeviceInfoPlugin().deviceInfo;

    String deviceInfoData;

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
    } else {
      // on web
      var browserName = (deviceInfo as WebBrowserInfo).browserName;
      var platform = deviceInfo.platform;
      // eg: Web chrome Win32
      deviceInfoData = 'Web ${browserName.name} $platform';
    }

    return deviceInfoData;
  }
}
