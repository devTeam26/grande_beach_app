import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// A titled card for picking (and previewing/replacing/removing) a single
/// image, used for the ID card and personal photo on [VerificationScreen].
class UploadCard extends StatelessWidget {
  const UploadCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onPicked,
    required this.onRemove,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final File? image;
  final ValueChanged<File> onPicked;
  final VoidCallback onRemove;

  Future<void> _pickImage(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.takePhotoOption),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.chooseFromGalleryOption),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null || !context.mounted) return;

    if (source == ImageSource.camera) {
      final granted = await _ensureCameraPermission(context);
      if (!granted || !context.mounted) return;
    }

    try {
      final picked =
          await ImagePicker().pickImage(source: source, imageQuality: 85);
      if (picked != null) onPicked(File(picked.path));
    } on PlatformException catch (e) {
      // image_picker still throws this on some devices even after a
      // granted-looking permission_handler check (e.g. race with the OS
      // dialog) — fall back to the same settings prompt.
      if (e.code == 'camera_access_denied' && context.mounted) {
        await _showCameraPermissionDialog(context);
      }
    }
  }

  /// Requests camera permission, re-prompting the OS dialog while it's
  /// still deniable. Once permanently denied (or denied a second time on
  /// iOS, which never re-shows its own dialog), points the user to the
  /// app's system settings instead.
  Future<bool> _ensureCameraPermission(BuildContext context) async {
    var status = await Permission.camera.status;
    if (status.isGranted) return true;

    if (!status.isPermanentlyDenied) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) return true;
    if (context.mounted) await _showCameraPermissionDialog(context);
    return false;
  }

  Future<void> _showCameraPermissionDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(l10n.cameraPermissionDeniedTitle),
        content: Text(l10n.cameraPermissionDeniedMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              openAppSettings();
            },
            child: Text(
              l10n.openSettingsButton,
              style: const TextStyle(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 20,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          if (image != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                image!,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickImage(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryGold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      l10n.replaceImageButton,
                      style: const TextStyle(color: AppColors.primaryGold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRemove,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      l10n.removeImageButton,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ),
              ],
            ),
          ] else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(context),
                icon: const Icon(Icons.upload_rounded,
                    color: AppColors.primaryGold),
                label: Text(
                  l10n.uploadImageButton,
                  style: const TextStyle(color: AppColors.primaryGold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryGold),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
