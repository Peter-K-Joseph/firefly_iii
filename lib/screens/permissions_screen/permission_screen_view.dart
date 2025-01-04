import 'package:firefly_iii/services/helpers/text_handler.dart';
import 'package:firefly_iii/services/permissions/base.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_screen_controller.dart';

class PermissionScreenView extends StatelessWidget {
  final Function? onPermissionGranted;
  final PermissionScreenController controller = PermissionScreenController();

  PermissionScreenView({super.key, this.onPermissionGranted});

  Widget _buildPermissionTile(
      PermissionManager permission, BuildContext context) {
    return ListTile(
      title:
          Text(TextHandler.capitalize(permission.permission.split('.').last)),
      subtitle: Text(permission.reason),
      trailing: FutureBuilder(
          future: permission.hasPermission(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return const Icon(Icons.error, color: Colors.red);
            }

            if (snapshot.data == PermissionStatus.granted) {
              return const Icon(Icons.check, color: Colors.green);
            }

            return const Text('Request');
          }),
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${TextHandler.capitalize(permission.permission.split('.').last)} Permission',
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Why do we need this permission?',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(permission.reason),
                  const Divider(),
                  Text(
                    'Where is this used?',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  for (var use in permission.uses) Text(use),
                ],
              ),
            );
          },
        );
      },
      onTap: () async {
        await permission.requestPermission();
        await controller.updatePermissions();
        if (onPermissionGranted != null) {
          onPermissionGranted!();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: controller.permissionsNotifier,
                builder: (context, permissions, child) {
                  return Column(
                    children: [
                      for (var permission in permissions) ...[
                        _buildPermissionTile(permission, context),
                        const Divider()
                      ],
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
