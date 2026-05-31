import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import '../widgets/camera_actions_bar.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
    if (!mounted) {

      return;

    }
    if (picked == null) { Navigator.pop(context); return; }
    setState(() => _photo = File(picked.path));
  }

  Future<void> _saveAndContinue() async {
    if (_photo == null || _saving) {

      return;

    }
    setState(() => _saving = true);
    await Gal.putImage(_photo!.path);
    if (!mounted) {

      return;

    }
    setState(() => _saving = false);
    Navigator.pop(context, _photo);
    if (mounted) {
      AppSnackbar.success(context, S.of(context).photoSavedToGallery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _photo == null
          ? Center(child: CircularProgressIndicator(color: context.colors.primary))
          : Column(children: [
              _buildHeader(),
              Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(AppRadius.s16), child: Image.file(_photo!, fit: BoxFit.contain, width: double.infinity))),
              CameraActionsBar(onRetake: _openCamera, onSave: _saveAndContinue, saving: _saving),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ]),
    );
  }

  Widget _buildHeader() => Container(
        color: Colors.black,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close_rounded, size: 24.sp, color: context.colors.surface)),
              Text(S.of(context).photoCapture, style: getBoldStyle(color: context.colors.surface, fontSize: FontSize.s20)),
              const SizedBox(width: 24),
            ]),
          ),
        ]),
      );
}
