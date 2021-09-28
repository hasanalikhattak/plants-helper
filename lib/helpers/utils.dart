import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

Future<String> getDeviceUID() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (GetPlatform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.androidId!;
  } else if (GetPlatform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor!;
  }
  return "";
}

Future<loc.LocationData?> getUserCurrentLocation() async { // Added location package to pubspec yaml
  if (await Permission.locationWhenInUse.request().isGranted) {
    loc.Location location = new loc.Location();
    return await location.getLocation();
  } else{
    return loc.LocationData.fromMap({"latitude": 0.0, "longitude": 0.0});
  }
}