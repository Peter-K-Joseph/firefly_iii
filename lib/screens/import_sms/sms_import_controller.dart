import 'package:firefly_iii/model/messages_model.dart';
import 'package:firefly_iii/services/permissions/message_permission.dart';
import 'package:flutter/material.dart';

class SmsImportController extends ChangeNotifier {
  ValueNotifier<List<MessagesModel>> smsList =
      ValueNotifier<List<MessagesModel>>([]);
  final MessagePermission _messagePermission = MessagePermission();

  void _updateSmsList(List<MessagesModel> sms) {
    smsList.value = sms;
    smsList.notifyListeners();
  }

  Future<List<MessagesModel>> getSms() async {
    final List<MessagesModel> sms = await _messagePermission.getMessages();
    _updateSmsList(sms);
    return sms;
  }
}
