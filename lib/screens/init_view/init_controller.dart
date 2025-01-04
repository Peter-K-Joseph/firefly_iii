import 'package:firefly_iii/model/user_model.dart';
import 'package:firefly_iii/services/database.dart';
import 'package:flutter/material.dart';

import '../../model/enums.dart';

class InitController extends ChangeNotifier {
  final DatabaseService _database = DatabaseService();
  final ValueNotifier<double?> progress = ValueNotifier(null);
  final ValueNotifier<String> title = ValueNotifier('Initializing');

  Future<InitialRoute> init() async {
    progress.value = 0.0;
    title.value = 'Welcome to Firefly III';

    await _database.waitUntilInitialised();

    final account = (await _database.systemAccounts.selectTableBy(
      UserModel(isDefault: true),
      true,
    ))
        .firstOrNull;

    if (account != null) {
      progress.value = 1.0;
      title.value = 'Logged In';
      notifyListeners();
      return InitialRoute.home;
    }

    progress.value = null;
    title.value = 'Starting First Time Setup';
    notifyListeners();
    return InitialRoute.login;
  }
}
