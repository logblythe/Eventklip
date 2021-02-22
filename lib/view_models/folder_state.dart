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
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class FolderState with ChangeNotifier {
  FoldersApi _foldersApi = getIt.get<FoldersApi>();
  bool _loading = false;
  List<FolderModel> _folders = [];
  Map<String, String> folderQrMap = {};

  FolderModel _selectedFolder;
  CreateFolderModel _createFolderModel;
  CreateQrModel _createQrModel;
  StreamController<FolderModel> _folderSelectionStream =
      StreamController.broadcast();

  bool get loading => _loading;


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
      _folders.sort((a, b) {
        return b.createdDate.compareTo(a.createdDate);
      });
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
