import 'package:firefly_iii/services/permissions/base.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../model/messages_model.dart';

class MessagePermission extends PermissionManager {
  MessagePermission() {
    super.permission = Permission.sms.toString();
    super.reason = 'We need access to your SMS to read and import transactions';
    super.uses = [
      'To read and import transactions from your SMS',
      'To detect transactions from your SMS ontime',
    ];
  }

  @override
  Future<PermissionStatus> hasPermission() async {
    var status = await Permission.sms.status;

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
    var status = await Permission.sms.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      status = await Permission.sms.request();
      return status.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }

  Future<List<MessagesModel>> getMessages() async {
    const platform = MethodChannel('in.nuvie.firefly_iii/sms');
    try {
      final List<MessagesModel> finalList = [];
      final List<dynamic> smsList = await platform.invokeMethod('getSms');
      for (final sms in smsList) {
        finalList.add(MessagesModel.fromJson(sms.cast<String, dynamic>()));
      }
      return finalList;
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }
}
