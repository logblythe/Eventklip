import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eventklip/api/folders_api.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/file_upload_model.dart';
import 'package:eventklip/models/question.dart';
import 'package:eventklip/screens/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class QrUserState extends ChangeNotifier {
  FoldersApi _foldersApi = getIt.get<FoldersApi>();
  bool _loading = false;
  List<Question> _questions=[];

  bool get loading => _loading;

  List<Question> get questions => _questions;

  QrUserState() {
    init();
  }

  void init() async {
    fetchQuestions();
  }

  createClientVideo(Map<String, dynamic> payload) {
    return _foldersApi.createClientVideo(payload);
  }

  createAnswerVideo(Map<String, dynamic> payload) {
    return _foldersApi.createAnswerVideo(payload);
  }

  Future<FileUploadModel> uploadFile(
      String filePath, ProgressCallback onSendProgress) async {
    File file = File(filePath);
    List<String> mimeDetails = lookupMimeType(filePath).split("/");
    String fileType = mimeDetails.first;
    FileUploadModel uploadRes;
    try {
      uploadRes = await _foldersApi.uploadFile(
        file,
        fileType,
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      print('error $e');
    }
    return uploadRes;
  }

  Future<FileUploadModel> saveFile(
      String filePath, ProgressCallback onSendProgress) async {
    String fileName = basename(filePath);
    File file = File(filePath);
    int fileSize = await file.length();
    List<String> mimeDetails = lookupMimeType(filePath).split("/");
    String fileType = mimeDetails.first;
    String fileExtension = mimeDetails.last;
    String videoDuration = "0";
    if (fileType == "video") {
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      videoDuration = controller.value.duration.inSeconds.toString();
    }
    FileUploadModel uploadRes = await uploadFile(filePath, onSendProgress);
    FileUploadModel createRes;
    if (uploadRes.success) {
      final user = await SharedPreferenceHelper.getUser();
      final payload = {
        "id": uploadRes.fileId,
        "title": fileName,
        "eventId": user.eventId,
        "fileLocation": uploadRes.fileUrl,
        "videoFormat": fileExtension,
        "videoSize": fileSize,
        "duration": videoDuration
      };
      createRes = await _foldersApi.createClientVideo(payload);
    }
    return createRes;
  }

  Future<void> fetchQuestions() async {
    final user = await SharedPreferenceHelper.getUser();
    _loading = true;
    notifyListeners();
    try {
      _questions = await _foldersApi
          .getQuestionsForEventId("63a4e04f-8815-41e9-87f8-b8753990ff31");
      // _questions = await _foldersApi.getQuestionsForEventId(user.id);
      _questions.sort((a, b) {
        return b.lastModifiedDate.compareTo(a.lastModifiedDate);
      });
    } catch (e) {} finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<FileUploadModel> postAnswer(
    String filePath,
    int selectedQuestionIndex,
    ProgressCallback callback,
  ) async {
    String fileName = basename(filePath);
    File file = File(filePath);
    int fileSize = await file.length();
    List<String> mimeDetails = lookupMimeType(filePath).split("/");
    String fileType = mimeDetails.first;
    String fileExtension = mimeDetails.last;
    String videoDuration = "0";
    if (fileType == "video") {
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      videoDuration = controller.value.duration.inSeconds.toString();
    }
    FileUploadModel uploadRes = await uploadFile(filePath, callback);
    FileUploadModel createRes;
    if (uploadRes.success) {
      final payload = {
        "id": uploadRes.fileId,
        "title": fileName,
        "questionId": questions[selectedQuestionIndex].id,
        "fileLocation": uploadRes.fileUrl,
        "videoFormat": fileExtension,
        "videoSize": fileSize,
        "duration": videoDuration
      };
      createRes = await _foldersApi.createAnswerVideo(payload);
    }
    return createRes;
  }

  void updateQuestion(int selectedQuestionIndex) {
    questions[selectedQuestionIndex].isAnswered = true;
    notifyListeners();

  }
}
