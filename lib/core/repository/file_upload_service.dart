import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:yemekhane_app/core/models/upload_media_result.dart';

class FileUploadService {
  // Singleton instance
  static final FileUploadService _instance = FileUploadService._internal();

  // Dio instance
  final Dio _dio = Dio();

  // Private constructor
  FileUploadService._internal();

  // Factory constructor to access the singleton instance
  factory FileUploadService() {
    return _instance;
  }

  /// File upload function
  Future<ResponseModel?> uploadFile(File file) async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
        ),
      });
      print("test");

      Response response = await _dio.post(
        "http://192.168.158.47:3001/predict",
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data', 'Accept': '*/*'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Result: ${response.data}");
        return ResponseModel.fromJson(response.data);
      } else {
        print("Error: ${response.statusCode} - ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("An error occurred during file upload: $e");
      return null;
    }
  }
}
