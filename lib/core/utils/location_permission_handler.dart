import 'package:permission_handler/permission_handler.dart';

class LocationPermissionHandler {
  static Future<bool> requestLocationPermission() async {
    PermissionStatus permission = await Permission.location.request();
    return permission.isGranted;
  }
}
