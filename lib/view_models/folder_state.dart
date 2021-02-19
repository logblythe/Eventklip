import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eventklip/api/folders_api.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/create_folder_model.dart';
import 'package:eventklip/models/create_qr_model.dart';
import 'package:eventklip/models/file_upload_model.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:video_player/video_player.dart';

class FolderState with ChangeNotifier {
  FoldersApi _foldersApi = getIt.get<FoldersApi>();
  bool _loading = false;
  bool _listView = false;
  List<FolderModel> _folders = [];
  Map<String, String> folderQrMap = {};

  FolderModel _selectedFolder;
  CreateFolderModel _createFolderModel;
  CreateQrModel _createQrModel;
  StreamController<FolderModel> _folderSelectionStream =
      StreamController.broadcast();

  bool get loading => _loading;

  bool get listView => _listView;

  bool get qrExists => false;

  List<FolderModel> get folders => _folders;

  CreateQrModel get createQrModel => _createQrModel;

  FolderModel get selectedFolder => _selectedFolder;

  Stream get folderSelectionStream => _folderSelectionStream.stream;

  FolderState() {
    getFolders();
  }

  Future<void> getFolders() async {
    _loading = true;
    notifyListeners();
    try {
      _folders = await _foldersApi.getFolders();
    } catch (e) {
      print('error $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> createFolder(String name, String description,
      {String parentFolder}) async {
    _loading = true;
    notifyListeners();
    final data = {
      "name": name,
      'description': description,
    };
    try {
      _createFolderModel = await _foldersApi.createFolder(data);
    } catch (e) {
      print('error $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> createQr(
    String folderId,
    int noOfScans,
    String expiryDate,
    int duration,
  ) async {
    _loading = true;
    notifyListeners();
    final data = {
      "eventId": folderId,
      "noOfScans": noOfScans,
      "expiryDate": expiryDate,
      "duration": duration,
    };
    try {
      _createQrModel = await _foldersApi.createQr(data);
      if (_createQrModel.success) {
        //todo get qr url in the response
        folderQrMap[folderId] =
            "https://fpeme3022zp1scl6q238xy71-wpengine.netdna-ssl.com/wp-content/uploads/2012/02/qr.png";
      }
    } catch (e) {
      print('error $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  uploadFile(String filePath, ProgressCallback onSendProgress) async {
    File file = File(filePath);
    String fileExtension = p.extension(filePath);
    int fileSize = await file.length();
    final controller = VideoPlayerController.file(file);
    await controller.initialize();
    int videoDuration = controller.value.duration.inSeconds;
    try {
      FileUploadModel uploadRes =
          await _foldersApi.uploadFile(file, onSendProgress: onSendProgress);
      // if (uploadRes.success) {
      //   final payload = {
      //     "id": uploadRes.fileId ?? "1a9cba6b-9650-47ce-a696-5638e0ccb234",
      //     "title": "some random title",
      //     "eventId": "1a9cba6b-9650-47ce-a696-5638e0ccb234",
      //     //todo inject the event id
      //     "fileLocation": uploadRes.fileUrl,
      //     "videoFormat": fileExtension,
      //     "videoSize": fileSize,
      //     "duration": videoDuration
      //   };
      //   final createRes = await _foldersApi.createClientVideo(payload);
      //   print('created $createRes');
      // }
    } catch (e) {
      print('error $e');
    }
  }

  void toggleListView() {
    _listView = !listView;
    notifyListeners();
  }

  void selectFolder(FolderModel folderModel) {
    _selectedFolder = folderModel;
    _folderSelectionStream.sink.add(folderModel);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _folderSelectionStream.close();
  }
}
