import 'package:permission_handler/permission_handler.dart';

enum AvailablePermissions { sms, storage, location }

abstract class PermissionManager {
  late final String permission;
  late final String reason;
  late final List<String> uses;

  Future<PermissionStatus> hasPermission();
  Future<bool> requestPermission();
}
