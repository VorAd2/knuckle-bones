import 'package:flutter/material.dart';

class MyDialog {
  static void show({
    required BuildContext context,
    required String titleString,
    required String contentString,
    required VoidCallback onConfirm,
    bool hasCancel = true,
    String mainActionString = 'Confirm',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(titleString),
        content: Text(contentString),
        actions: [
          if (hasCancel)
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onConfirm();
            },
            child: Text(mainActionString),
          ),
        ],
      ),
    );
  }
}
