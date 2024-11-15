import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class MultipartConverter {
  Future<MultipartFile> imageToMultipartConverter(File file) async {
    final String fileName = basename(file.path);
    final String fileType = fileName.split('.').last; // Extract file extension
    final List<int> fileBytes = await file.readAsBytes();

    return MultipartFile.fromBytes(
      fileBytes,
      filename: fileName,
      contentType: MediaType('image', fileType), // Set correct content type
    );
  }
}
