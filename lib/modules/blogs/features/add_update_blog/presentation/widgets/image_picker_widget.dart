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
        height: 240,
        decoration: BoxDecoration(
          color: context.customTheme.surface,
          borderRadius: AppBorderRadius.chipBorderRadius,
          border: Border.all(color: context.customTheme.outline),
          image: _imageFile != null
              ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.fill)
              : null,
        ),
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: AppSpacing.xxxlg,
                    color: context.customTheme.primary,
                  ),

                  AppGaps.gapH16,

                  Text(
                    "Add a cover image",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.customTheme.contentPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  AppGaps.gapH4,

                  Text(
                    "Tap to choose from gallery",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.customTheme.contentPrimary,
                    ),
                  ),
                ],
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.all(AppSpacing.xs),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.customTheme.secondary,
                    borderRadius: AppBorderRadius.mediumBorderRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit,
                        size: AppSpacing.lg,
                        color: Colors.white,
                      ),

                      AppGaps.gapW8,

                      Text(
                        "Change",
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
