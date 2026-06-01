import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class PhotoPickerSection extends StatefulWidget {
  const PhotoPickerSection({super.key});
  @override
  State<PhotoPickerSection> createState() => _PhotoPickerSectionState();
}

class _PhotoPickerSectionState extends State<PhotoPickerSection> {
  File? _photo; // both camera and gallery results go here (middle slot)
  final _picker = ImagePicker();

  Future<void> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 90);
    if (picked == null || !mounted) {

      return;

    }
    setState(() => _photo = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    // RTL Row: children[0]=right, children[1]=middle, children[2]=left
    return Row(
      children: [
        // RIGHT — camera button (always)
        _buildButton(icon: Icons.add_a_photo_outlined, onTap: () => _pick(ImageSource.camera), borderColor: context.colors.border, iconColor: context.colors.primary),
        SizedBox(width: Insets.s12),
        // MIDDLE — photo result (from camera or gallery)
        _buildPhotoSlot(),
        SizedBox(width: Insets.s12),
        // LEFT — gallery button (always)
        _buildButton(icon: Icons.photo_library_outlined, onTap: () => _pick(ImageSource.gallery), borderColor: context.colors.border, iconColor: context.colors.textSecondary),
      ],
    );
  }

  Widget _buildButton({required IconData icon, required VoidCallback onTap, Color? borderColor, Color? iconColor}) => Expanded(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: _slotBox(
        borderColor: borderColor ?? context.colors.primary,
        child: Icon(icon, color: iconColor ?? context.colors.primary, size: 28.sp),
      ),
    ),
  );

  Widget _buildPhotoSlot() => Expanded(
    child: _slotBox(
      borderColor: _photo != null ? context.colors.primary : context.colors.border,
      child: _photo != null
          ? Stack(children: [
              Positioned.fill(child: Image.file(_photo!, fit: BoxFit.cover)),
              PositionedDirectional(
                top: 4.h, end: 4.w,
                child: _badge(color: context.colors.primary, icon: Icons.edit_outlined, onTap: () => _pick(ImageSource.camera)),
              ),
              PositionedDirectional(
                top: 4.h, start: 4.w,
                child: _badge(color: context.colors.error, icon: Icons.close_rounded, onTap: () => setState(() => _photo = null)),
              ),
            ])
          : Icon(Icons.image_outlined, color: context.colors.border, size: 28.sp),
    ),
  );

  Widget _badge({required Color color, required IconData icon, required VoidCallback onTap}) =>
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 22.w, height: 22.w,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.s16)),
        child: Icon(icon, color: context.colors.surface, size: 12.sp),
      ),
    );

  Widget _slotBox({required Color borderColor, required Widget child}) => Container(
    height: 88,
    decoration: BoxDecoration(
      color: context.colors.inputFill,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderColor),
    ),
    clipBehavior: Clip.hardEdge,
    child: Center(child: child),
  );
}
