import 'package:firefly_iii/model/transaction_accounts_model.dart';
import 'package:firefly_iii/screens/manage_transaction_account/manage_transacc_controller.dart';
import 'package:flutter/material.dart';

class ManageTransactionAccountView extends StatelessWidget {
  late final ManageTransactionAccountController controller;
  final TransactionAccountsModel account;

  ManageTransactionAccountView({
    super.key,
    TransactionAccountsModel? account,
  }) : account = account ?? TransactionAccountsModel() {
    controller = ManageTransactionAccountController(account: this.account);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(account.name ?? 'New Account'),
        actions: [
          IconButton(
            icon: Icon(account.id != null ? Icons.save : Icons.add),
            onPressed: () {
              controller.saveAccount();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Text('Manage Transaction Account'),
          ],
        ),
      ),
    );
  }
}
