import 'dart:io';

import 'package:eventklip/api/api_helper.dart';
import 'package:eventklip/api/client.dart';
import 'package:eventklip/api/endpoints.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/create_folder_model.dart';
import 'package:eventklip/models/create_qr_model.dart';
import 'package:eventklip/models/file_upload_model.dart';
import 'package:eventklip/models/file_upload_model.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mime/mime.dart';

abstract class IFolders {
  Future getFolders();

  Future createFolder(Map<String, dynamic> data);

  Future createQr(Map<String, dynamic> data);
}

@lazySingleton
class FoldersApi extends IFolders with ApiHelper {
  DioClient _dioClient = getIt.get<DioClient>();

  @override
  Future<List<FolderModel>> getFolders() async {
    final response = await _dioClient.get(
      ApiEndPoints.GET_FOLDERS,
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<FolderModel>(response,
        modelCreator: (json) => FolderModel.fromJson(json));
  }

  @override
  Future<CreateFolderModel> createFolder(Map<String, dynamic> data) async {
    final response = await _dioClient.post(
      ApiEndPoints.CREATE_FOLDER,
      data: data,
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<CreateFolderModel>(response,
        modelCreator: (json) => CreateFolderModel.fromJson(json));
  }

  @override
  Future<CreateQrModel> createQr(Map<String, dynamic> data) async {
    final response = await _dioClient.post(
      ApiEndPoints.CREATE_QR,
      data: data,
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<CreateQrModel>(response,
        modelCreator: (json) => CreateQrModel.fromJson(json));
  }

  Future<FileUploadModel> uploadFile(File file, String fileType,
      {ProgressCallback onSendProgress}) async {
    final response = await _dioClient.postMultiPart(
      fileType == "video" ? ApiEndPoints.POST_VIDEO : ApiEndPoints.POST_IMAGES,
      {},
      {"files": file},
      onSendProgress: onSendProgress,
    );
    return returnResponse<FileUploadModel>(
      response,
      modelCreator: (json) => FileUploadModel.fromJson(json),
    );
  }

  Future<FileUploadModel> createClientVideo(
      Map<String, dynamic> payload) async {
    final response = await _dioClient.post(
      ApiEndPoints.CREATE_CLIENT_VIDEOS,
      data: payload,
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<FileUploadModel>(
      response,
      modelCreator: (json) => FileUploadModel.fromJson(json),
    );
  }
}
