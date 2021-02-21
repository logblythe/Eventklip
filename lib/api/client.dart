import 'dart:io';

import 'package:eventklip/api/endpoints.dart';
import 'package:eventklip/models/failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';

@singleton
class DioClient {
  final String baseUrl = ApiEndPoints.BASE_URL;

  Dio _dio = Dio();

  DioClient() {
    _dio
      ..httpClientAdapter
      ..options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: true,
          requestBody: true));
    }
  }

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      handleError(e);
    }
  }

  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      var response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      handleError(e);
    }
  }

  Future<dynamic> postMultiPart(
      String url, Map<String, dynamic> data, Map<String, File> files,
      {ProgressCallback onSendProgress}) async {
    try {
      Map<String, MultipartFile> fileMap = {};
      for (MapEntry fileEntry in files.entries) {
        File file = fileEntry.value;
        String fileName = basename(file.path);
        fileMap[fileEntry.key] = MultipartFile(
          file.openRead(),
          await file.length(),
          filename: fileName,
        );
      }
      data.addAll(fileMap);
      var formData = FormData.fromMap(data);
      var response = await post(url,
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
          onSendProgress: onSendProgress);
      return response;
    } catch (e) {
      handleError(e);
    }
  }

  /* Future<Response> sendFile(String url, File file) async {
    var len = await file.length();
    var response = await post(
      url,
      data: file.openRead(),
      options: Options(headers: {
        Headers.contentLengthHeader: len,
      } // set content-length
          ),
    );
    return response;
  }*/

  //handles Dio Error. that is not handled by the request and throws as Failure.
  Future handleError(e) {
    print(e);
    if (e is DioError) {
      if (e.response == null) {
        throw Failure(statusCode: 0, message: "Please check your connectivity");
      }
      switch (e.response.statusCode) {
        case 400:
          throw Failure(message: "Http 400.Bad request.", statusCode: 400);
          break;
        case 403:
          throw Failure(message: e.response.data.toString(), statusCode: 403);
        case 404:
          throw Failure(message: "Resource not found", statusCode: 404);
        case 500:
          throw Failure(
              message: "500 Server Error ${e.message}",
              statusCode: e.response.statusCode);
        default:
          throw Failure(
              message: "Something went wrong ${e.message}",
              statusCode: e.response.statusCode);
      }
    }
    throw e;
  }
}
