import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class PhotoPickerSection extends StatefulWidget {
  const PhotoPickerSection({super.key});

  @override
  State<PhotoPickerSection> createState() => _PhotoPickerSectionState();
}

class _PhotoPickerSectionState extends State<PhotoPickerSection> {
  final List<File?> _photos = [null, null, null];
  final _picker = ImagePicker();

  Future<void> _pickPhoto(int index) async {
    final picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (picked == null || !mounted) return;
    setState(() => _photos[index] = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) => _buildSlot(i)),
    );
  }

  Widget _buildSlot(int index) {
    final photo = _photos[index];
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: index < 2 ? Insets.s16 : 0),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _pickPhoto(index),
          child: Container(
            height: 88,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: photo != null ? AppColors.primary : const Color(0xFFEFF0F1)),
            ),
            clipBehavior: Clip.hardEdge,
            child: photo != null
                ? Stack(children: [
                    Positioned.fill(child: Image.file(photo, fit: BoxFit.cover)),
                    Positioned(
                      top: 4.h, right: 4.w,
                      child: Container(
                        width: 22.w, height: 22.w,
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.s16)),
                        child: Icon(Icons.edit_outlined, color: AppColors.white, size: 12.sp),
                      ),
                    ),
                  ])
                : Center(child: Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 32.sp)),
          ),
        ),
      ),
    );
  }
}
