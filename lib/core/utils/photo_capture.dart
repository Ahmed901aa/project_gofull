import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

final ImagePicker _picker = ImagePicker();

/// Takes a photo, falling back to the photo library when the camera can't be
/// used.
///
/// Two very different situations both end here:
///  * the iOS Simulator has no camera hardware at all, so every capture in
///    development fails, and
///  * on a real device the user can decline camera access.
///
/// image_picker reports both as a `PlatformException`, and on iOS its plugin
/// also throws up its own untranslated "Error / Camera not available." alert.
/// Left unhandled that dead-ends the towing flow — the Continue button stays
/// disabled with no way forward, which is exactly what happens on a simulator.
///
/// Falling back to the library keeps the flow moving and makes the towing
/// screens testable without a physical phone. Returns null when the user
/// simply cancelled, so callers can tell "declined" from "failed".
Future<File?> capturePhoto(
  BuildContext context, {
  ImageSource source = ImageSource.camera,
  int imageQuality = 90,
  double? maxWidth,
}) async {
  Future<XFile?> pick(ImageSource s) => _picker.pickImage(
        source: s,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
      );

  try {
    final shot = await pick(source);
    return shot == null ? null : File(shot.path);
  } catch (_) {
    // Camera unusable. The library is the only other source, so there is
    // nothing to retry when that was already the request.
    if (source != ImageSource.camera) {
      if (context.mounted) {
        AppSnackbar.error(context, S.of(context).photoCaptureFailed);
      }
      return null;
    }
  }

  if (!context.mounted) return null;
  AppSnackbar.warning(context, S.of(context).cameraUnavailableUseGallery);

  try {
    final shot = await pick(ImageSource.gallery);
    return shot == null ? null : File(shot.path);
  } catch (_) {
    if (context.mounted) {
      AppSnackbar.error(context, S.of(context).photoCaptureFailed);
    }
    return null;
  }
}
