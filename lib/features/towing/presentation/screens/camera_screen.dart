import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _photo;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openCamera());
  }

  Future<void> _openCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 90);
    if (!mounted) return;
    if (picked == null) { Navigator.pop(context); return; }
    setState(() => _photo = File(picked.path));
  }

  Future<void> _saveAndContinue() async {
    if (_photo == null || _saving) return;
    setState(() => _saving = true);
    await ImageGallerySaver.saveFile(_photo!.path);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pop(context, _photo);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حفظ الصورة في المعرض', style: getRegularStyle(color: AppColors.white, fontSize: FontSize.s14), textAlign: TextAlign.right),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _photo == null ? _buildLoading() : _buildPreview(),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator(color: AppColors.primary));

  Widget _buildPreview() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s16),
            child: Image.file(_photo!, fit: BoxFit.contain, width: double.infinity),
          ),
        ),
        _buildActions(),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }

  Widget _buildHeader() => Container(
    color: Colors.black,
    child: Column(children: [
      SizedBox(height: MediaQuery.of(context).padding.top),
      Padding(
        padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close_rounded, size: 24.sp, color: AppColors.white)),
          Text('صورة السيارة', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s20)),
          const SizedBox(width: 24),
        ]),
      ),
    ]),
  );

  Widget _buildActions() => Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
      boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
    ),
    padding: EdgeInsets.all(Insets.s16),
    child: Row(children: [
      Expanded(
        child: SizedBox(
          height: 48.h,
          child: OutlinedButton.icon(
            onPressed: _openCamera,
            icon: Icon(Icons.camera_alt_outlined, size: 20.sp, color: AppColors.primary),
            label: Text('إعادة التصوير', style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s16)),
            style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16))),
          ),
        ),
      ),
      SizedBox(width: Insets.s12),
      Expanded(
        child: SizedBox(
          height: 48.h,
          child: ElevatedButton(
            onPressed: _saving ? null : _saveAndContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF54867C),
              disabledBackgroundColor: AppColors.neutral600,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
              elevation: 0,
            ),
            child: _saving
                ? SizedBox(width: 20.w, height: 20.w, child: const CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                : Text('حفظ ومتابعة', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
          ),
        ),
      ),
    ]),
  );
}
