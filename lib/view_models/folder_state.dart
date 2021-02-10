import 'dart:async';

import 'package:eventklip/api/folders_api.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/create_folder_model.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:flutter/material.dart';

class FolderState with ChangeNotifier {
  FoldersApi _foldersApi = getIt.get<FoldersApi>();
  bool _loading = false;
  bool _listView = false;
  List<FolderModel> _folders = [];
  FolderModel _selectedFolder;
  StreamController<FolderModel> _folderSelectionStream =
      StreamController.broadcast();

  bool get loading => _loading;

  bool get listView => _listView;

  List<FolderModel> get folders => _folders;

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
      CreateFolderModel response = await _foldersApi.createFolder(data);
      print('response $response');
    } catch (e) {
      print('error $e');
    } finally {
      _loading = false;
      notifyListeners();
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
