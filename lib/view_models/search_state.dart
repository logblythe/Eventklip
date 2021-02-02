import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/failure.dart';
import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/services/movie_service.dart';
import 'package:eventklip/view_models/video_detail_state.dart';
import 'package:flutter/material.dart';

class SearchState with ChangeNotifier {
  MovieService _movieService = getIt.get<MovieService>();
  List<VideoDetails> _movies = List<VideoDetails>();
  FetchStatus fetchStatus = FetchStatus.idle;

  bool get hasError => fetchStatus == FetchStatus.error;

  bool get isLoading => fetchStatus == FetchStatus.loading;

  List<VideoDetails> get movies => _movies;
  String searchError;
  String queryText="";
  SearchState() {
    getRecentSearches();
  }

  Future<bool> searchMovies(String query, {int page}) async {
    queryText=query;
    fetchStatus = FetchStatus.loading;
    notifyListeners();
    try {
      _movies = await _movieService.getSearchResults(query);
      fetchStatus = FetchStatus.loaded;
    } catch (e) {
      print(e);
      fetchStatus = FetchStatus.error;
      searchError = (e as Failure).message;
    }
    notifyListeners();
    return fetchStatus == FetchStatus.loaded;
  }

  void getRecentSearches() {}
}
