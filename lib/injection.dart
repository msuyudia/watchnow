import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';
import 'package:watchnow/data/datasources/db/database_helper.dart';
import 'package:watchnow/data/datasources/movie_local_data_source.dart';
import 'package:watchnow/data/datasources/movie_remote_data_source.dart';
import 'package:watchnow/data/datasources/tv_show_local_data_source.dart';
import 'package:watchnow/data/datasources/tv_show_remote_data_source.dart';
import 'package:watchnow/data/repositories/movie_repository_impl.dart';
import 'package:watchnow/data/repositories/tv_show_repository_impl.dart';
import 'package:watchnow/domain/repositories/movie_repository.dart';
import 'package:watchnow/domain/repositories/tv_show_repository.dart';
import 'package:watchnow/domain/usecases/get_episode_detail.dart';
import 'package:watchnow/domain/usecases/get_movie_detail.dart';
import 'package:watchnow/domain/usecases/get_movie_recommendations.dart';
import 'package:watchnow/domain/usecases/get_now_playing_movies.dart';
import 'package:watchnow/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:watchnow/domain/usecases/get_popular_movies.dart';
import 'package:watchnow/domain/usecases/get_popular_tv_shows.dart';
import 'package:watchnow/domain/usecases/get_season_detail.dart';
import 'package:watchnow/domain/usecases/get_top_rated_movies.dart';
import 'package:watchnow/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:watchnow/domain/usecases/get_tv_show_detail.dart';
import 'package:watchnow/domain/usecases/get_tv_show_recommendations.dart';
import 'package:watchnow/domain/usecases/get_watchlist_movie_status.dart';
import 'package:watchnow/domain/usecases/get_watchlist_movies.dart';
import 'package:watchnow/domain/usecases/get_watchlist_tv_show_status.dart';
import 'package:watchnow/domain/usecases/get_watchlist_tv_shows.dart';
import 'package:watchnow/domain/usecases/remove_watchlist_movie.dart';
import 'package:watchnow/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:watchnow/domain/usecases/save_watchlist_movie.dart';
import 'package:watchnow/domain/usecases/save_watchlist_tv_show.dart';
import 'package:watchnow/domain/usecases/search_movies.dart';
import 'package:watchnow/domain/usecases/search_tv_shows.dart';
import 'package:watchnow/presentation/bloc/get_episode_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_movie_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_movie_recommendations_bloc.dart';
import 'package:watchnow/presentation/bloc/get_now_playing_movies_bloc.dart';
import 'package:watchnow/presentation/bloc/get_on_the_air_tv_shows_bloc.dart';
import 'package:watchnow/presentation/bloc/get_popular_movies_bloc.dart';
import 'package:watchnow/presentation/bloc/get_popular_tv_shows_bloc.dart';
import 'package:watchnow/presentation/bloc/get_season_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_top_rated_movies_bloc.dart';
import 'package:watchnow/presentation/bloc/get_top_rated_tv_shows_bloc.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_recommendations_bloc.dart';
import 'package:watchnow/presentation/bloc/get_watchlist_movies_bloc.dart';
import 'package:watchnow/presentation/bloc/get_watchlist_tv_shows_bloc.dart';
import 'package:watchnow/presentation/bloc/search_movie_bloc.dart';
import 'package:watchnow/presentation/bloc/search_tv_show_bloc.dart';
import 'package:watchnow/presentation/bloc/watchlist_movie_status_bloc.dart';
import 'package:watchnow/presentation/bloc/watchlist_tv_show_status_bloc.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(() => GetNowPlayingMoviesBloc(locator()));
  locator.registerFactory(() => GetPopularMoviesBloc(locator()));
  locator.registerFactory(() => GetTopRatedMoviesBloc(locator()));
  locator.registerFactory(() => SearchMovieBloc(locator()));
  locator.registerFactory(() => GetWatchlistMoviesBloc(locator()));
  locator.registerFactory(() => GetMovieDetailBloc(locator()));
  locator.registerFactory(() => GetMovieRecommendationsBloc(locator()));
  locator.registerFactory(() => WatchlistMovieStatusBloc(
        locator(),
        locator(),
        locator(),
      ));
  locator.registerFactory(() => GetOnTheAirTVShowsBloc(locator()));
  locator.registerFactory(() => GetPopularTVShowsBloc(locator()));
  locator.registerFactory(() => GetTopRatedTVShowsBloc(locator()));
  locator.registerFactory(() => SearchTVShowBloc(locator()));
  locator.registerFactory(() => GetWatchlistTVShowsBloc(locator()));
  locator.registerFactory(() => GetTVShowDetailBloc(locator()));
  locator.registerFactory(() => GetSeasonDetailBloc(locator()));
  locator.registerFactory(() => GetEpisodeDetailBloc(locator()));
  locator.registerFactory(() => GetTVShowRecommendationsBloc(locator()));
  locator.registerFactory(() => WatchlistTVShowStatusBloc(
        locator(),
        locator(),
        locator(),
      ));

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListMovieStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetOnTheAirTVShows(locator()));
  locator.registerLazySingleton(() => GetPopularTVShows(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVShows(locator()));
  locator.registerLazySingleton(() => GetTVShowDetail(locator()));
  locator.registerLazySingleton(() => GetSeasonDetail(locator()));
  locator.registerLazySingleton(() => GetEpisodeDetail(locator()));
  locator.registerLazySingleton(() => GetTVShowRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTVShows(locator()));
  locator.registerLazySingleton(() => GetWatchListTVShowStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTVShow(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTVShow(locator()));
  locator.registerLazySingleton(() => GetWatchlistTVShows(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TVShowRepository>(
    () => TVShowRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(ioClient: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<TVShowRemoteDataSource>(
      () => TVShowRemoteDataSourceImpl(ioClient: locator()));
  locator.registerLazySingleton<TVShowLocalDataSource>(
      () => TVShowLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton<Future<IOClient>>(() async {
    final securityContext = SecurityContext(withTrustedRoots: false);
    final sslCert = await rootBundle.load('certificates/certificate.pem');
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    HttpClient client = HttpClient(context: securityContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(client);
  });
}
