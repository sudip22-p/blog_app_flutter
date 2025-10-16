import 'dart:io';
import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(File?)? onImageSelected;

  const ImagePickerWidget({super.key, this.onImageSelected});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      setState(() => _imageFile = file);
      widget.onImageSelected?.call(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: context.customTheme.outline,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.customTheme.outline),
          image: _imageFile != null
              ? DecorationImage(
                  image: FileImage(_imageFile!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 50,
                    color: context.customTheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add a cover image",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.customTheme.outline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Tap to choose from gallery",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.customTheme.outline,
                    ),
                  ),
                ],
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: context.customTheme.outline.withAlpha(128),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit,
                        size: 14,
                        color: context.customTheme.secondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Change",
                        style: TextStyle(
                          color: context.customTheme.contentSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
