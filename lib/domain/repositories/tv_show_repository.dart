import 'package:dartz/dartz.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/entities/episode_detail.dart';
import 'package:watchnow/domain/entities/season_detail.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/domain/entities/tv_show_detail.dart';

abstract class TVShowRepository {
  Future<Either<Failure, List<TVShow>>> getOnTheAirTVShows();

  Future<Either<Failure, List<TVShow>>> getPopularTVShows();

  Future<Either<Failure, List<TVShow>>> getTopRatedTVShows();

  Future<Either<Failure, TVShowDetail>> getTVShowDetail(int id);

  Future<Either<Failure, SeasonDetail>> getSeasonDetail(
    int id,
    int seasonNumber,
  );

  Future<Either<Failure, EpisodeDetail>> getEpisodeDetail(
    int id,
    int seasonNumber,
    int episodeNumber,
  );

  Future<Either<Failure, List<TVShow>>> getTVShowRecommendations(int id);

  Future<Either<Failure, List<TVShow>>> searchTVShows(String query);

  Future<Either<Failure, String>> saveWatchlist(TVShowDetail tvShow);

  Future<Either<Failure, String>> removeWatchlist(TVShowDetail tvShow);

  Future<bool> isAddedToWatchlist(int id);

  Future<Either<Failure, List<TVShow>>> getWatchlistTVShows();
}
