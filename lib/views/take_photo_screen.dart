import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:yemekhane_app/core/repository/file_upload_service.dart';

class TakePhotoScreen extends StatefulWidget {
  const TakePhotoScreen({super.key});

  @override
  State<TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  var fileUploadService = FileUploadService();

  void takePhoto(PhotoCameraState state) async {
    await state.takePhoto().then((value) async {
      try {
        context.loaderOverlay.show();

        Map<String, int>? result =
            await fileUploadService.uploadFile(File(value.path!));
        context.loaderOverlay.hide();
        if (result != null) {
          context.push("/detail", extra: result);
        } else {
          throw Exception("Fotoğraf yüklenirken hata oluştu.");
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kamera'),
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
