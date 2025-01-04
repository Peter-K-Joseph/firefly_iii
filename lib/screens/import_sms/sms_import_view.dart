import 'package:firefly_iii/screens/import_sms/sms_import_controller.dart';
import 'package:firefly_iii/services/helpers/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/permissions/message_permission.dart';
import '../permissions_screen/permission_screen_view.dart';

class SmsImportView extends StatelessWidget {
  final SmsImportController _controller = SmsImportController();
  final Function toggleDrawer;

  SmsImportView({super.key, required this.toggleDrawer});

  Widget _permissionCheck() {
    final MessagePermission permission = MessagePermission();
    return FutureBuilder(
        future: permission.hasPermission(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Container(
              width: MediaQuery.of(context).size.width - 20,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Check Permission',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'An error occurred while checking permission. ${UserPreferences.enableDebug ? snapshot.error.toString() : ''}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          }

          if (snapshot.data == PermissionStatus.denied) {
            return Container(
              width: MediaQuery.of(context).size.width - 20,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              decoration: BoxDecoration(
                color: Colors.orange[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Check Permission',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Application does not have sufficient permission to read SMS. Please grant permission to continue.',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      Expanded(child: SizedBox()),
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PermissionScreenView(),
                            ),
                          );
                        },
                        child: const Text('Grant Permission'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          }

          return smsImporter();
        });
  }

  Widget smsImporter() {
    return FutureBuilder(
      future: _controller.getSms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null) {
          return const Center(
            child: Text('No SMS found'),
          );
        }
        return Column(
          children: [
            for (var sms in snapshot.data!) Text(sms.toString()),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import SMS'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => toggleDrawer(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _permissionCheck(),
          ],
        ),
      ),
    );
  }
}
