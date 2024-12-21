import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../models/upload_media_result.dart';

class FileUploadService {
  // Özel bir static örnek
  static final FileUploadService _instance = FileUploadService._internal();

  // Dio örneği
  final Dio _dio = Dio();

  // Özel bir constructor
  FileUploadService._internal();

  // Singleton örneğe erişim
  factory FileUploadService() {
    return _instance;
  }

  /// Ortak dosya yükleme fonksiyonu
  Future<UploadMediaResult?> uploadFile(File file) async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
        ),
      });

      Response response = await _dio.post(
        "http://192.168.158.47:3001/predict",
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data', 'Accept': '*/*'},
        ),
      );

      // Gelen yanıtı UploadMediaResult modeline dönüştür
      if (response.statusCode == 200 && response.data != null) {
        return UploadMediaResult.fromJson(response.data);
      } else {
        print("Hata: ${response.statusCode} - ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("Dosya yükleme sırasında bir hata oluştu: $e");
      return null;
    }
  }
}
