import 'package:firefly_iii/services/permissions/base.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPersmission extends PermissionManager {
  LocationPersmission() {
    super.permission = Permission.location.toString();
    super.reason =
        'We need access to your location to get your current location';
    super.uses = [
      'To populate the location field in the transaction form',
    ];
  }

  @override
  Future<PermissionStatus> hasPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      return PermissionStatus.granted;
    } else if (status.isDenied) {
      return PermissionStatus.denied;
    } else if (status.isPermanentlyDenied) {
      return PermissionStatus.permanentlyDenied;
    }
    return PermissionStatus.denied;
  }

  @override
  Future<bool> requestPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      status = await Permission.location.request();
      return status.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }
}
