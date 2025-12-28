import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaHelper {
  static final _imagePicker = ImagePicker();

  static Future<File?> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    return pickedFile == null ? null : File(pickedFile.path);
  }
}
