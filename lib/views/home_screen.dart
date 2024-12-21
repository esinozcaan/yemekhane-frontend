import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yemekhane_app/core/models/upload_media_result.dart';
import 'package:yemekhane_app/core/strings.dart';

import '../core/repository/file_upload_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var fileUploadService = FileUploadService();
  void onTakePhoto() async {
    try {
      PermissionStatus cameraPerm = await Permission.camera.request();
      PermissionStatus micPerm = await Permission.microphone.request();

      if (cameraPerm != PermissionStatus.permanentlyDenied &&
          micPerm != PermissionStatus.permanentlyDenied) {
        context.push('/takePhoto');
      } else {
        throw Exception(AppStrings.permissionErrText);
      }
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              alignment: Alignment.center,
              height: 250,
              width: 250,
              child: Text(
                err.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> onSelectGallery() async {
    try {
      PermissionStatus galleryPerm = await Permission.photos.request();
      if (galleryPerm.isLimited || galleryPerm.isGranted) {
        final imagePicker = ImagePicker();
        final pickedFile =
            await imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          print(pickedFile.name);
          UploadMediaResult? result =
              await fileUploadService.uploadFile(File(pickedFile.path));
          context.push("/detail", extra: result);
        }
      } else {
        throw Exception(AppStrings.permissionErrText);
      }
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              alignment: Alignment.center,
              height: 250,
              width: 250,
              child: Text(
                err.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.home),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: onTakePhoto,
              child: Text(AppStrings.takePhoto),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: onSelectGallery,
              child: Text(AppStrings.selectGallery),
            ),
          ],
        ),
      ),
    );
  }
}
