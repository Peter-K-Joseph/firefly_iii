import 'package:firefly_iii/services/permissions/base.dart';
import 'package:firefly_iii/services/permissions/message_permission.dart';
import 'package:flutter/material.dart';

import '../../services/permissions/location_persmission.dart';

class PermissionScreenController {
  final ValueNotifier<List<PermissionManager>> permissionsNotifier =
      ValueNotifier<List<PermissionManager>>([
    LocationPersmission(),
    MessagePermission(),
  ]);

  Future<void> updatePermissions() async {
    permissionsNotifier.value = [
      LocationPersmission(),
      MessagePermission(),
    ];
  }
}
