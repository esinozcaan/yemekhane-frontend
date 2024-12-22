import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yemekhane_app/core/models/upload_media_result.dart';
import 'package:yemekhane_app/core/strings.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
          context.loaderOverlay.show();
          print(pickedFile.name);
          Map<String, int>? result =
              await fileUploadService.uploadFile(File(pickedFile.path));
          context.loaderOverlay.hide();
          if (result != null) {
            context.push("/detail", extra: result);
          }
        }
      } else {
        throw Exception(AppStrings.permissionErrText);
      }
    } catch (err) {
      context.loaderOverlay.hide();
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
        title: Text(
          AppStrings.home,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 92, 70, 5),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/aa.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.welcome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onTakePhoto,
                    child: Text(AppStrings.takePhoto),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onSelectGallery,
                    child: Text(AppStrings.selectGallery),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
