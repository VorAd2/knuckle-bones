import 'package:flutter/material.dart';

class MyDialog {
  static Future<bool> show({
    required BuildContext context,
    required String titleString,
    required String contentString,
    bool hasCancel = true,
    String mainActionString = 'Confirm',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(titleString),
        content: Text(contentString),
        actions: [
          if (hasCancel)
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: Text(mainActionString),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<void> alert({
    required BuildContext context,
    required String titleString,
    required String contentString,
  }) {
    return show(
      context: context,
      titleString: titleString,
      contentString: contentString,
      hasCancel: false,
      mainActionString: 'Ok',
    );
  }
}
