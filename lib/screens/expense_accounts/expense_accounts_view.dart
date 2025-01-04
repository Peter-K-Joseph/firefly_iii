import 'package:flutter/material.dart';
import '../../model/transaction_accounts_model.dart';
import '../manage_transaction_account/manage_transacc_view.dart';
import 'expense_account_controller.dart';
import '../../services/helpers/text_handler.dart';

class ExpenseAccountsView extends StatelessWidget {
  final ExpenseAccountController controller = ExpenseAccountController();
  final Function toggleDrawer;

  ExpenseAccountsView({super.key, required this.toggleDrawer});

  void showAccountDetails(
      List<TransactionAccountsModel> accounts, BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Account Details',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              for (var account in accounts)
                ListTile(
                  title: Text(TextHandler.capitalize(account.type!)),
                  subtitle: Text(
                      'Balance: ${account.currencySymbol}${account.currentBalance}'),
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ManageTransactionAccountView(
                          account: account,
                        ),
                      ),
                    )
                  },
                  leading: const Icon(Icons.account_balance),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchAllAccounts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Accounts'),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => toggleDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 5),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: TextField(
                onChanged: (query) {
                  controller.searchQuery.value = query;
                  controller.applySearchFilter();
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    gapPadding: 5,
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            // RefreshIndicator with Lazy Loading
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchAllAccounts();
                },
                child: ValueListenableBuilder<
                    List<MapEntry<String, List<TransactionAccountsModel>>>>(
                  valueListenable: controller.paginatedData,
                  builder: (context, data, child) {
                    if (controller.isFetchingData.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        final isEndOfPage = scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !controller.isLoadingMore.value &&
                            controller.searchQuery.value.isEmpty;

                        isEndOfPage ? controller.loadMore() : null;
                        return false;
                      },
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final entry = data[index];
                          final key = entry.key;
                          final value = entry.value;

                          final Map<String, int> dataMap = {};
                          for (var element in value) {
                            dataMap[element.type!] =
                                dataMap.containsKey(element.type)
                                    ? dataMap[element.type]! + 1
                                    : 1;
                          }

                          final subtitle = dataMap.entries
                              .map((e) =>
                                  '${e.value} ${TextHandler.capitalize(e.key)}')
                              .join(', ');

                          return Column(
                            children: [
                              ListTile(
                                onLongPress: () {
                                  showAccountDetails(value, context);
                                },
                                title: Text(key),
                                subtitle: Text(subtitle),
                                subtitleTextStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                leading:
                                    const Icon(Icons.account_balance_wallet),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            // Pagination and Loading Indicator
            ValueListenableBuilder(
              valueListenable: controller.isLoadingMore,
              builder: (context, isLoading, child) {
                return isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
