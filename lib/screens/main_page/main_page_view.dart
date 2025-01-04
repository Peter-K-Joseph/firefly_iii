import 'package:firefly_iii/screens/home_page/home_page_view.dart';
import 'package:flutter/material.dart';

import '../../model/sidebar.dart';
import '../../model/user_model.dart';
import '../expense_accounts/accounts_view.dart';
import '../import_sms/sms_import_view.dart';
import 'main_page_controller.dart';

class MainPageView extends StatelessWidget {
  final _controller = MainPageController();
  late final List<SideDrawerOptionsModel> drawer;

  MainPageView({super.key}) {
    drawer = [
      SideDrawerOptionsModel(
        label: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        page: HomePageView(
          toggleDrawer: _controller.toggleDrawer,
        ),
      ),
      SideDrawerOptionsModel(
        label: 'Accounts',
        icon: Icons.account_balance_wallet_outlined,
        activeIcon: Icons.account_balance_wallet,
        page: AccountsView(
          toggleDrawer: _controller.toggleDrawer,
        ),
      ),
      SideDrawerOptionsModel(
        label: 'Import',
        icon: Icons.import_export_outlined,
        activeIcon: Icons.import_export,
        page: SmsImportView(
          toggleDrawer: _controller.toggleDrawer,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _controller.scaffoldKey,
      body: ValueListenableBuilder<int>(
        valueListenable: _controller.currentIndexNotifier,
        builder: (context, index, child) {
          if (drawer.length <= index) {
            return const Center(
              child: Text('Page not found'),
            );
          }
          return drawer[index].page;
        },
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
                  child: Text(
                    'Firefly III',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: _controller.instanceNotifier,
                    builder: (context, UserModel? instance, child) {
                      String? domain = instance?.link;
                      if (domain != null) {
                        domain = domain.split('//').last;
                        domain = domain.split('/').first;
                      }
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(28, 0, 28, 10),
                        child: Text(
                          instance == null
                              ? 'Fetching account information'
                              : 'Connected to ${instance.name} as ${instance.email} at $domain',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      );
                    }),
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 8, 28, 10),
                  child: Divider(),
                ),
                for (var i = 0; i < drawer.length; i++)
                  ValueListenableBuilder<int>(
                    valueListenable: _controller.currentIndexNotifier,
                    builder: (context, index, child) {
                      return InkWell(
                        onTap: () => _controller.changeIndex(i),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                          padding: const EdgeInsets.fromLTRB(28, 8, 28, 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: index == i
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: index == i
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.3)
                                      : Colors.transparent,
                                ),
                                child: Icon(
                                  index == i
                                      ? drawer[i].activeIcon
                                      : drawer[i].icon,
                                  color: index == i
                                      ? Theme.of(context).primaryColor
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                drawer[i].label,
                                style: TextStyle(
                                  color: index == i
                                      ? Theme.of(context).primaryColor
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
