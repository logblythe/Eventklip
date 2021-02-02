import 'package:eventklip/api/movie_api.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/add_comment_payload.dart';
import 'package:eventklip/models/basic_server_response.dart';
import 'package:eventklip/models/comment_model.dart';
import 'package:eventklip/models/homemovie_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MovieService {
  MovieApi _movieApi = getIt.get<MovieApi>();

  Future<HomeMovieModel> getMovies() {
    return _movieApi.getMovies();
  }

  Future<List<VideoDetails>> getRelatedMovies(String videoId) {
    return _movieApi.getRelatedMovies(videoId);
  }

  Future<BasicServerResponse> createView(String videoId,String watchTime) {
    return _movieApi.createView(videoId,watchTime);
  }

  Future<List<VideoDetails>> getSearchResults(String query) {
    return _movieApi.getSearchResults(query);
  }

  Future<List<Comment>> getCommentsForVideoId(String videoId) {
    return _movieApi.getCommentsForVideoId(videoId);
  }

  Future<BasicServerResponse> addCommentForVideoId(AddCommentPayload payload) {
    return _movieApi.addCommentForVideoId(payload);
  }

  Future<BasicServerResponse> editComment(AddCommentPayload payload) {
    return _movieApi.editComment(payload);
  }

  Future<BasicServerResponse> deleteComment({@required String commentId}) {
    return _movieApi.deleteComment(commentId: commentId);
  }
}
