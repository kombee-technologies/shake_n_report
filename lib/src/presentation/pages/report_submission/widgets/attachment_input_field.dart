import 'dart:io' show Platform, File;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shake_n_report/src/core/constants/my_constants.dart';

class AttachmentInputField extends StatelessWidget {
  final List<XFile> attachments;
  final int maxAttachments;
  final VoidCallback onAddAttachment;
  final ValueChanged<int> onRemoveAttachment;
  final bool isSubmitting;

  const AttachmentInputField({
    required this.attachments,
    required this.maxAttachments,
    required this.onAddAttachment,
    required this.onRemoveAttachment,
    required this.isSubmitting,
    super.key,
  });

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        <Permission, PermissionStatus>{};
    final List<Permission> permissionsToRequest = <Permission>[];

    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+
        permissionsToRequest
          ..add(Permission.photos)
          ..add(Permission.videos);
      } else {
        // Android 12 and below
        permissionsToRequest.add(Permission.storage);
      }
    } else if (Platform.isIOS) {
      permissionsToRequest
          .add(Permission.photos); // Covers both images and videos on iOS
    }

    if (permissionsToRequest.isNotEmpty) {
      statuses = await permissionsToRequest.request();
    } else {
      return true; // No specific permissions needed for this platform/version (e.g. web)
    }

    bool allGranted = true;
    statuses.forEach((Permission permission, PermissionStatus status) {
      if (status != PermissionStatus.granted &&
          status != PermissionStatus.limited) {
        allGranted = false;
      }
    });

    return allGranted;
  }

  Future<void> _showPermissionDialog(BuildContext context) async =>
      showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button!
        builder: (BuildContext dialogContext) => AlertDialog(
          title: const Text('Permission Required'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'This app needs permission to access your photos and videos to attach them.'),
                Text('Please grant access in app settings.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Attachments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                icon: const Icon(Icons.attach_file),
                label: const Text('Add'),
                onPressed:
                    (attachments.length < maxAttachments && !isSubmitting)
                        ? () async {
                            final bool granted = await _requestPermissions();
                            if (granted) {
                              onAddAttachment();
                            } else {
                              if (context.mounted) {
                                _showPermissionDialog(context);
                              }
                            }
                          }
                        : null,
              ),
            ],
          ),
          Text(
            'Max $maxAttachments files (images/videos).',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          if (attachments.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('No attachments added yet.',
                  style: TextStyle(color: Colors.grey)),
            )
          else
            SizedBox(
              height: 120, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: attachments.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, top: 4.0, bottom: 4.0),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius:
                              BorderRadius.circular(MyConstants.borderRadius),
                          color: Colors.grey.shade200,
                        ),
                        // attachment.type == AttachmentType.image
                        child: Image.file(
                          File(attachments[index].path),
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) =>
                              const Center(
                            child: Icon(Icons.broken_image,
                                color: Colors.redAccent, size: 40),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                        child: InkWell(
                          onTap: (isSubmitting)
                              ? null
                              : () => onRemoveAttachment(index),
                          borderRadius: BorderRadius.circular(12),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.close,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
}
