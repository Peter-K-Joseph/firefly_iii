import 'package:firefly_iii/model/enums.dart';
import 'package:flutter/material.dart';

import '../login/login_view.dart';
import '../main_page/main_page_view.dart';
import 'init_controller.dart';

class InitView extends StatelessWidget {
  final controller = InitController();

  InitView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.init().then((route) {
        switch (route) {
          case InitialRoute.login:
            // ignore: use_build_context_synchronously
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginView(),
              ),
            );
            break;
          case InitialRoute.home:
            // ignore: use_build_context_synchronously
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MainPageView(),
              ),
            );
            break;
          default:
        }
      });
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder<double?>(
              valueListenable: controller.progress,
              builder: (context, progress, child) {
                return CircularProgressIndicator(
                  value: progress,
                );
              },
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<String>(
              valueListenable: controller.title,
              builder: (context, title, child) {
                return Text(title);
              },
            ),
          ],
        ),
      ),
    );
  }
}
