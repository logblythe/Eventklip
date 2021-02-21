import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eventklip/api/folders_api.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/file_upload_model.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class QrUserState extends ChangeNotifier {
  FoldersApi _foldersApi = getIt.get<FoldersApi>();

  Future<FileUploadModel> uploadFile(
      String filePath, ProgressCallback onSendProgress) async {
    String fileName = basename(filePath);
    File file = File(filePath);
    int fileSize = await file.length();
    List<String> mimeDetails = lookupMimeType(filePath).split("/");
    String fileType = mimeDetails.first;
    String fileExtension = mimeDetails.last;
    String videoDuration ="0";
    if (fileType == "video") {
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      videoDuration = controller.value.duration.inSeconds.toString();
    }
    FileUploadModel uploadRes;
    try {
      uploadRes = await _foldersApi.uploadFile(
        file,
        fileType,
        onSendProgress: onSendProgress,
      );
      if (uploadRes.success) {
        final payload = {
          "id": uploadRes.fileId,
          "title": fileName,
          "eventId": "1a9cba6b-9650-47ce-a696-5638e0ccb234",
          //todo inject the event id
          "fileLocation": uploadRes.fileUrl,
          "videoFormat": fileExtension,
          "videoSize": fileSize,
          "duration": videoDuration
        };
        // final createRes = await _foldersApi.createClientVideo(payload);
        // print('created $createRes');
      }
    } catch (e) {
      print('error $e');
    }
    return uploadRes;
  }
}
