import 'package:firefly_iii/model/transaction_accounts_model.dart';
import 'package:flutter/material.dart';

import '../../services/database.dart';
import '../../services/network_requests.dart';


class ManageTransactionAccountController extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final NetworkRequests _networkRequests = NetworkRequests();
  final TransactionAccountsModel account;

  ManageTransactionAccountController({required this.account});

  void saveAccount() {}
}