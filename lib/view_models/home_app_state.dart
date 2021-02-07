import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/failure.dart';
import 'package:eventklip/models/homemovie_model.dart';
import 'package:eventklip/screens/shared_preferences.dart';
import 'package:eventklip/services/authentication_service.dart';
import 'package:eventklip/services/movie_service.dart';
import 'package:eventklip/services/stripe_service.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/view_models/video_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeAppState with ChangeNotifier {
  MovieService _movieService = getIt.get<MovieService>();
  AuthenticationService _authService=getIt.get<AuthenticationService>();
  StripeService _stripeService = getIt.get<StripeService>();
  HomeMovieModel _homeMovieModel;

  HomeMovieModel get homeMovieModel => _homeMovieModel;
  List<ApplicationGroups> get groups => _homeMovieModel.applicationGroups;
  List<VideoDetails> get videos => _homeMovieModel.videoDetails;

  List<VideoDetails> upcomingMovies;
  FetchStatus movieFetchStatus = FetchStatus.idle;
  Failure upcomingMoviesError;

  HomeAppState() {
    init();
    _stripeService.payWithNewCard(amount: "100",currency: "usd");
  }

  Future<bool> fetchMovies() async {
    movieFetchStatus = FetchStatus.loading;
    notifyListeners();
    try {
      _homeMovieModel = await _movieService.getMovies();
      movieFetchStatus = FetchStatus.loaded;
      notifyListeners();
    } catch (e) {
      movieFetchStatus = FetchStatus.error;
      upcomingMoviesError = (e as Failure);
      if(upcomingMoviesError.statusCode!=401){
        notifyListeners();
      }
    }
    return movieFetchStatus == FetchStatus.loaded;
  }

  void init() async{
    final success = await fetchMovies();
    if (!success) {
      if (upcomingMoviesError.statusCode == 401) {
        final storage = FlutterSecureStorage();
        String email = await storage.read(key: USER_EMAIL);
        String password = await storage.read(key: PASSWORD);
        final authToken = await _authService.authenticate(email, password);
        await SharedPreferenceHelper.saveToken(authToken.accessToken);
        final profile = await _authService.getUserProfile();
        if (profile.isPasswordUpdated) {
          await SharedPreferenceHelper.setUserProfile(profile);
          await SharedPreferenceHelper.setIsLoggedIn();
          final storage = FlutterSecureStorage();
          await storage.write(key: USER_EMAIL, value: email);
          await storage.write(key: PASSWORD, value: password);
        }
        await fetchMovies();
      }
    }

  }
}

