import 'dart:developer';

import 'package:flutter/material.dart';

import '../../model/user_model.dart';
import '../../services/database.dart';

class MainPageController extends ChangeNotifier {
  ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);
  final DatabaseService _database = DatabaseService();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<UserModel?> instanceNotifier =
      ValueNotifier<UserModel?>(null);

  void changeIndex(int index) {
    scaffoldKey.currentState!.openEndDrawer();

    currentIndexNotifier.value = index;
    log('Index changed to $index');
    currentIndexNotifier.notifyListeners();
  }

  void toggleDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  Future<void> fetchInstanceName() async {
    final data = await _database.systemAccounts.selectTableBy(
      UserModel(isDefault: true),
      false,
    );
    if (data.isEmpty) {
      throw Exception('No instance found');
    } else {
      instanceNotifier.value = data.first;
    }
    instanceNotifier.notifyListeners();
  }

  MainPageController() {
    fetchInstanceName();
  }
}
