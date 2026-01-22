import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knuckle_bones/core/presentation/widgets/image_picker_sheet.dart';

class ProfileAvatar extends StatelessWidget {
  final ValueNotifier<File?> imageFileNotifier;
  final bool isEditing;
  final Function(ImageSource) onPickImage;
  final VoidCallback onRemoveImage;

  const ProfileAvatar({
    super.key,
    required this.imageFileNotifier,
    required this.isEditing,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: imageFileNotifier,
      builder: (_, file, _) {
        final imageProvider = file != null ? FileImage(file) : null;
        return CircleAvatar(
          radius: 70,
          backgroundImage: imageProvider,
          backgroundColor: cs.primaryContainer,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (file == null)
                Icon(
                  Icons.person,
                  size: 70,
                  color: cs.onPrimaryContainer.withAlpha(127),
                ),
              if (isEditing)
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.edit,
                    size: 40,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: isEditing
                      ? () {
                          ImagePickerSheet.show(
                            context: context,
                            onPick: onPickImage,
                            onRemove: file == null ? null : onRemoveImage,
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
