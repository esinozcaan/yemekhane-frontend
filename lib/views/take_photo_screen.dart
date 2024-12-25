import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:yemekhane_app/core/models/upload_media_result.dart';
import 'package:yemekhane_app/core/repository/file_upload_service.dart';

class TakePhotoScreen extends StatefulWidget {
  const TakePhotoScreen({super.key});

  @override
  State<TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  final fileUploadService = FileUploadService();

  Future<void> takePhoto(PhotoCameraState state) async {
    await state.takePhoto().then((value) async {
      try {
        context.loaderOverlay.show(); // Show loading indicator

        // Upload the captured photo file
        ResponseModel? result =
            await fileUploadService.uploadFile(File(value.path!));

        context.loaderOverlay.hide(); // Hide loading indicator

        if (result != null) {
          // Navigate to DetailScreen with the backend response
          context.push("/detail", extra: result);
        } else {
          throw Exception("Fotoğraf yüklenirken bir hata oluştu.");
        }
      } catch (err) {
        context.loaderOverlay.hide(); // Ensure loader is hidden
        _showErrorDialog(err.toString());
      }
    }).catchError((err) {
      _showErrorDialog(err.toString());
    });
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
        title: const Text('Kamera'),
        centerTitle: false,
      ),
      body: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photo(mirrorFrontCamera: true),
        previewFit: CameraPreviewFit.contain,
        previewAlignment: Alignment.topCenter,
        sensorConfig:
            SensorConfig.single(aspectRatio: CameraAspectRatios.ratio_16_9),
        topActionsBuilder: (state) => const SizedBox.shrink(),
        middleContentBuilder: (state) => const SizedBox.shrink(),
        bottomActionsBuilder: (state) => Container(
          height: 200,
          color: Colors.white,
          child: AwesomeBottomActions(
            state: state,
            left: AwesomeFlashButton(
              theme: AwesomeTheme(
                  buttonTheme: AwesomeButtonTheme(
                      backgroundColor: const Color(0xffF5F5F5),
                      foregroundColor: Colors.black)),
              state: state,
            ),
            right: AwesomeCameraSwitchButton(
              state: state,
              scale: 1.0,
              theme: AwesomeTheme(
                  buttonTheme: AwesomeButtonTheme(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0xffF5F5F5),
              )),
              onSwitchTap: (state) {
                state.switchCameraSensor(
                  aspectRatio: state.sensorConfig.aspectRatio,
                );
              },
            ),
            captureButton: InkWell(
              onTap: () => state.when(
                onPhotoMode: (photoState) => takePhoto(photoState),
              ),
              child: Image.asset('assets/images/take_photo_icon.png'),
            ),
          ),
        ),
      ),
    );
  }
}
