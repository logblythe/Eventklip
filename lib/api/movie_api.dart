import 'package:eventklip/api/api_helper.dart';
import 'package:eventklip/api/client.dart';
import 'package:eventklip/api/endpoints.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/interface/i_movie.dart';
import 'package:eventklip/models/add_comment_payload.dart';
import 'package:eventklip/models/basic_server_response.dart';
import 'package:eventklip/models/comment_model.dart';
import 'package:eventklip/models/homemovie_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MovieApi extends IMovie with ApiHelper {
  DioClient _dioClient = getIt.get<DioClient>();

  @override
  Future<HomeMovieModel> getMovies() async {
    final response = await _dioClient.get(
      ApiEndPoints.GET_MOVIES,
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<HomeMovieModel>(response,
        modelCreator: (json) => HomeMovieModel.fromJson(json));
  }

  Future<List<VideoDetails>> getRelatedMovies(String videoId) async {
    final response = await _dioClient.get(
      ApiEndPoints.GET_RELATED_MOVIES,
      queryParameters: {"videoId": videoId},
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<VideoDetails>(response,
        modelCreator: (json) => VideoDetails.fromJson(json));
  }

  Future<BasicServerResponse> createView(
      String videoId, String watchTime) async {
    final data = {"videoId": videoId, "watchTime": watchTime};
    final response = await _dioClient.post(
      ApiEndPoints.CREATE_VIEW,
      data: data,
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<BasicServerResponse>(response,
        modelCreator: (json) => BasicServerResponse.fromJson(json));
  }

  Future<List<Comment>> getCommentsForVideoId(String videoId) async {
    final response = await _dioClient.get(
      ApiEndPoints.GET_COMMENTS,
      queryParameters: {"videoId": videoId},
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<Comment>(response,
        modelCreator: (json) => Comment.fromJson(json));
  }

  Future<BasicServerResponse> addCommentForVideoId(
      AddCommentPayload payload) async {
    final response = await _dioClient.post(
      ApiEndPoints.ADD_COMMENT,
      data: payload.toJson(),
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<BasicServerResponse>(response,
        modelCreator: (json) => BasicServerResponse.fromJson(json));
  }

  Future<BasicServerResponse> editComment(AddCommentPayload payload) async {
    final response = await _dioClient.post(
      ApiEndPoints.EDIT_COMMENT,
      data: payload.toJson(),
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<BasicServerResponse>(response,
        modelCreator: (json) => BasicServerResponse.fromJson(json));
  }

  Future<BasicServerResponse> deleteComment(
      {@required String commentId}) async {
    final response = await _dioClient.post(
      ApiEndPoints.DELETE_COMMENT,
      queryParameters: {"commentId": commentId},
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<BasicServerResponse>(response,
        modelCreator: (json) => BasicServerResponse.fromJson(json));
  }

  Future<List<VideoDetails>> getSearchResults(String query) async {
    final response = await _dioClient.get(
      ApiEndPoints.GET_SEARCH_RESULTS,
      queryParameters: {"term": query},
      options: Options(headers: await getDefaultHeader(authenticate: true)),
    );
    return returnResponse<VideoDetails>(response,
        modelCreator: (json) => VideoDetails.fromJson(json));
  }
}
