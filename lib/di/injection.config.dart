// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../api/auth_api.dart';
import '../services/authentication_service.dart';
import '../services/app/video_controller_service.dart';
import '../api/client.dart';
import '../api/movie_api.dart';
import '../services/movie_service.dart';
import '../services/stripe_service.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<AuthApi>(() => AuthApi());
  gh.lazySingleton<AuthenticationService>(() => AuthenticationService());
  gh.lazySingleton<CachedVideoControllerService>(
      () => CachedVideoControllerService());
  gh.lazySingleton<MovieApi>(() => MovieApi());
  gh.lazySingleton<MovieService>(() => MovieService());
  gh.lazySingleton<StripeService>(() => StripeService());

  // Eager singletons must be registered in the right order
  gh.singleton<DioClient>(DioClient());
  return get;
}
