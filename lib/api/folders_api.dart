import 'dart:io';

import 'package:eventklip/api/api_helper.dart';
import 'package:eventklip/api/client.dart';
import 'package:eventklip/api/endpoints.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/basic_server_response.dart';
import 'package:eventklip/models/client_media.dart';
import 'package:eventklip/models/create_folder_model.dart';
import 'package:eventklip/models/create_qr_model.dart';
import 'package:eventklip/models/file_upload_model.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:dio/dio.dart';
import 'package:eventklip/models/question.dart';
import 'package:injectable/injectable.dart';

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

  Future<FileUploadModel> createAnswerVideo(
      Map<String, dynamic> payload) async {
    final response = await _dioClient.post(
      ApiEndPoints.CREATE_ANSWER_VIDEOS,
      data: payload,
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<FileUploadModel>(
      response,
      modelCreator: (json) => FileUploadModel.fromJson(json),
    );
  }

  Future<List<ClientMedia>> getAdminVideos(String eventId) async {
    final response = await _dioClient.get(
      ApiEndPoints.GET_ADMIN_VIDEOS,
      queryParameters: {"EventId": eventId},
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<ClientMedia>(
      response,
      modelCreator: (json) => ClientMedia.fromJson(json),
    );
  }

  Future<List<Question>> getQuestionsForEventId(String id) async {
    final response = await _dioClient.get(
      ApiEndPoints.GET_QUESTIONS_FOR_EVENT,
      queryParameters: {"EventId": id},
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<Question>(
      response,
      modelCreator: (json) => Question.fromJson(json),
    );
  }

  Future<BasicServerResponse> postQuestionsForEventId(Question question) async {
    final response = await _dioClient.post(
      ApiEndPoints.POST_QUESTIONS_FOR_EVENT,
      data: question.toJson(),
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<BasicServerResponse>(
      response,
      modelCreator: (json) => BasicServerResponse.fromJson(json),
    );
  }

  Future<BasicServerResponse> updateQuestionsForEventId(
      Question question) async {
    final response = await _dioClient.post(
      ApiEndPoints.UPDATE_QUESTIONS_FOR_EVENT,
      data: question.toJson(),
      queryParameters: {"QuestionId": question.id},
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<BasicServerResponse>(
      response,
      modelCreator: (json) => BasicServerResponse.fromJson(json),
    );
  }

  Future<BasicServerResponse> deleteQuestions(String questionId) async {
    final response = await _dioClient.post(
      ApiEndPoints.DELETE_QUESTION,
      queryParameters: {"QuestionId": questionId},
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<BasicServerResponse>(
      response,
      modelCreator: (json) => BasicServerResponse.fromJson(json),
    );
  }

}
