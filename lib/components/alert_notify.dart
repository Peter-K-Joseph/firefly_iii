import 'package:flutter/material.dart';

class AlertNotifier extends StatelessWidget {
  final String text;
  final String type;
  const AlertNotifier({super.key, required this.type, required this.text});

  @override
  Widget build(BuildContext context) {
    var colors = {
      "success": Colors.green[500],
      "error": const Color.fromARGB(255, 255, 78, 78),
      "warning": Colors.orange[800],
      "info": Colors.blue[500],
    };

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colors[type],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
