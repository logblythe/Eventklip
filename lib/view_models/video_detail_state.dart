import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/add_comment_payload.dart';
import 'package:eventklip/models/comment_model.dart';
import 'package:eventklip/models/failure.dart';
import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/services/movie_service.dart';
import 'package:eventklip/utils/duration_formatter.dart';
import 'package:flutter/material.dart';

class VideoDetailState with ChangeNotifier {
  MovieService _movieService = getIt.get<MovieService>();
  String videoId;

  List<VideoDetails> _relatedVideos;
  FetchStatus _relatedVideoFetchStatus = FetchStatus.idle;
  String _relatedMoviesError;

  List<VideoDetails> get relatedVideos => _relatedVideos;

  FetchStatus get fetchStatus => _relatedVideoFetchStatus;

  String get relatedMoviesError => _relatedMoviesError;

  List<Comment> _comments;
  FetchStatus _status = FetchStatus.idle;
  String _errorMessage;

  List<Comment> get comments => _comments;

  FetchStatus get status => _status;

  String get errorMessage => _errorMessage;

  int _duration = 0;
  int _currentPosition = 0;

  String get duration => _duration != null ? durationFormatter(_duration) : "";

  String get currentPosition => durationFormatter(_currentPosition);

  VideoDetailState(this.videoId) {
    _getRelatedVideos();
    getComments();
    _createView();
  }

  _createView(){
    _movieService.createView(videoId, null);
  }
  _getRelatedVideos() async {
    _relatedVideoFetchStatus = FetchStatus.loading;
    notifyListeners();
    try {
      _relatedVideos = await _movieService.getRelatedMovies(videoId);
      _relatedVideoFetchStatus = FetchStatus.loaded;
    } catch (e) {
      _relatedVideoFetchStatus = FetchStatus.error;
      _relatedMoviesError = (e as Failure).message;
    }
    notifyListeners();
    return _relatedVideoFetchStatus == FetchStatus.loaded;
  }

  getComments() async {
    _status = FetchStatus.loading;
    print("Getting comments");
    notifyListeners();
    try {
      _comments = await _movieService.getCommentsForVideoId(videoId);
      _status = FetchStatus.loaded;
    } catch (e) {
      _status = FetchStatus.error;
      _errorMessage = (e as Failure).message;
    }
    notifyListeners();
    return _status == FetchStatus.loaded;
  }

  addComment(AddCommentPayload commentPayload) async {
    _status = FetchStatus.loading;
    notifyListeners();
    try {
      await _movieService.addCommentForVideoId(commentPayload);
      await getComments();
      _status = FetchStatus.loaded;
    } catch (e) {
      _status = FetchStatus.error;
      _errorMessage = (e as Failure).message;
    }
    notifyListeners();
    return _status == FetchStatus.loaded;
  }

  Future<void> editComment(
    AddCommentPayload commentPayload,
  ) async {
    _status = FetchStatus.loading;
    notifyListeners();
    try {
      await _movieService.editComment(commentPayload);
      await getComments();
      _status = FetchStatus.loaded;
    } catch (e) {
      _status = FetchStatus.error;
      _errorMessage = (e as Failure).message;
    }
    notifyListeners();
    return _status == FetchStatus.loaded;
  }

  Future<void> deleteComment(String commentId) async {
    _status = FetchStatus.loading;
    notifyListeners();
    try {
      await _movieService.deleteComment(commentId: commentId);
      await getComments();
      _status = FetchStatus.loaded;
    } catch (e) {
      _status = FetchStatus.error;
      _errorMessage = (e as Failure).message;
    }
    notifyListeners();
    return _status == FetchStatus.loaded;
  }

  void reset(String videoId) {
    this.videoId=videoId;
    _createView();
    _getRelatedVideos();
    getComments();
  }

  void setDuration(int duration) {
    _duration = duration;
    notifyListeners();
  }

  void setCurrentPosition(int currentPosition) {
    _currentPosition = currentPosition;
    notifyListeners();
  }
}

enum FetchStatus { loaded, loading, idle, error }
