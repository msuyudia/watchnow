import 'package:equatable/equatable.dart';
import 'package:watchnow/domain/entities/movie_detail.dart';
import 'package:watchnow/domain/entities/tv_show_detail.dart';

abstract class BlocEvent extends Equatable {
  const BlocEvent();
}

class GetNowPlayingMoviesEvent extends BlocEvent {
  GetNowPlayingMoviesEvent();

  @override
  List<Object> get props => [];
}

class GetPopularMoviesEvent extends BlocEvent {
  GetPopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class GetTopRatedMoviesEvent extends BlocEvent {
  GetTopRatedMoviesEvent();

  @override
  List<Object> get props => [];
}

class GetWatchlistMoviesEvent extends BlocEvent {
  GetWatchlistMoviesEvent();

  @override
  List<Object> get props => [];
}

class GetMovieRecommendationsEvent extends BlocEvent {
  final int id;

  GetMovieRecommendationsEvent(this.id);

  @override
  List<Object> get props => [id];
}

class GetWatchlistMovieStatusEvent extends BlocEvent {
  final int id;

  GetWatchlistMovieStatusEvent(this.id);

  @override
  List<Object> get props => [id];
}

class SaveWatchlistMovieStatusEvent extends BlocEvent {
  final MovieDetail movieDetail;

  SaveWatchlistMovieStatusEvent(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class RemoveWatchlistMovieStatusEvent extends BlocEvent {
  final MovieDetail movieDetail;

  RemoveWatchlistMovieStatusEvent(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class GetMovieDetailEvent extends BlocEvent {
  final int id;

  GetMovieDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

class SearchMovieEvent extends BlocEvent {
  final String query;

  SearchMovieEvent(this.query);

  @override
  List<Object> get props => [query];
}

class GetOnTheAirTVShowsEvent extends BlocEvent {
  GetOnTheAirTVShowsEvent();

  @override
  List<Object> get props => [];
}

class GetPopularTVShowsEvent extends BlocEvent {
  GetPopularTVShowsEvent();

  @override
  List<Object> get props => [];
}

class GetTopRatedTVShowsEvent extends BlocEvent {
  GetTopRatedTVShowsEvent();

  @override
  List<Object> get props => [];
}

class GetWatchlistTVShowsEvent extends BlocEvent {
  GetWatchlistTVShowsEvent();

  @override
  List<Object> get props => [];
}

class GetTVShowRecommendationsEvent extends BlocEvent {
  final int id;

  GetTVShowRecommendationsEvent(this.id);

  @override
  List<Object> get props => [id];
}

class GetWatchlistTVShowStatusEvent extends BlocEvent {
  final int id;

  GetWatchlistTVShowStatusEvent(this.id);

  @override
  List<Object> get props => [id];
}

class SaveWatchlistTVShowStatusEvent extends BlocEvent {
  final TVShowDetail tvShowDetail;

  SaveWatchlistTVShowStatusEvent(this.tvShowDetail);

  @override
  List<Object> get props => [tvShowDetail];
}

class RemoveWatchlistTVShowStatusEvent extends BlocEvent {
  final TVShowDetail tvShowDetail;

  RemoveWatchlistTVShowStatusEvent(this.tvShowDetail);

  @override
  List<Object> get props => [tvShowDetail];
}

class GetTVShowDetailEvent extends BlocEvent {
  final int id;

  GetTVShowDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

class GetSeasonDetailEvent extends BlocEvent {
  final int id;
  final int seasonNumber;

  GetSeasonDetailEvent(this.id, this.seasonNumber);

  @override
  List<Object> get props => [id, seasonNumber];
}

class GetEpisodeDetailEvent extends BlocEvent {
  final int id;
  final int seasonNumber;
  final int episodeNumber;

  GetEpisodeDetailEvent(this.id, this.seasonNumber, this.episodeNumber);

  @override
  List<Object> get props => [id, seasonNumber, episodeNumber];
}

class SearchTVShowEvent extends BlocEvent {
  final String query;

  SearchTVShowEvent(this.query);

  @override
  List<Object> get props => [query];
}
