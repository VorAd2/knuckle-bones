import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSheet {
  static void show({
    required BuildContext context,
    required Function(ImageSource) onPick,
    VoidCallback? onRemove,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalContext) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(modalContext).pop();
                  onPick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(modalContext).pop();
                  onPick(ImageSource.camera);
                },
              ),
              if (onRemove != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(modalContext).pop();
                    onRemove();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
