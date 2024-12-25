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
  final fileUploadService = FileUploadService();

  Future<void> _handlePermissions(Permission permission) async {
    PermissionStatus status = await permission.request();
    if (status.isPermanentlyDenied) {
      throw Exception(AppStrings.permissionErrText);
    }
  }

  void onTakePhoto() async {
    try {
      // Request permissions for camera and microphone
      await _handlePermissions(Permission.camera);
      await _handlePermissions(Permission.microphone);

      // Navigate to the photo capture screen
      context.push('/takePhoto');
    } catch (err) {
      _showErrorDialog(err.toString());
    }
  }

  Future<void> onSelectGallery() async {
    try {
      // Request permission for gallery access
      await _handlePermissions(Permission.photos);

      final imagePicker = ImagePicker();
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        context.loaderOverlay.show(); // Show loading indicator

        ResponseModel? result =
            await fileUploadService.uploadFile(File(pickedFile.path));

        context.loaderOverlay.hide(); // Hide loading indicator

        if (result != null) {
          // Navigate to the detail screen with the backend response
          context.push("/detail", extra: result);
        } else {
          throw Exception("Galeri seçimi sırasında bir hata oluştu.");
        }
      }
    } catch (err) {
      context.loaderOverlay.hide(); // Ensure loader is hidden
      _showErrorDialog(err.toString());
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            height: 250,
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Hata',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tamam'),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                    style: const TextStyle(
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
