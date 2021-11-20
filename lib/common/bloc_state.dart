import 'package:equatable/equatable.dart';
import 'package:watchnow/domain/entities/episode_detail.dart';
import 'package:watchnow/domain/entities/movie.dart';
import 'package:watchnow/domain/entities/movie_detail.dart';
import 'package:watchnow/domain/entities/season_detail.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/domain/entities/tv_show_detail.dart';

abstract class BlocState extends Equatable {
  const BlocState();

  @override
  List<Object> get props => [];
}

class EmptyState extends BlocState {}

class LoadingState extends BlocState {}

class ErrorState extends BlocState {
  final String message;

  ErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistButtonState extends BlocState {
  final String message;
  final bool isAddedWatchlist;

  WatchlistButtonState(this.message, this.isAddedWatchlist);

  @override
  List<Object> get props => [message];
}

class InitWatchlistButtonState extends BlocState {
  final bool isAdded;

  InitWatchlistButtonState(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}

class MoviesHasDataState extends BlocState {
  final List<Movie> movies;

  MoviesHasDataState(this.movies);

  @override
  List<Object> get props => [movies];
}

class MovieDetailHasDataState extends BlocState {
  final MovieDetail movieDetail;

  MovieDetailHasDataState(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class TVShowsHasDataState extends BlocState {
  final List<TVShow> tvShows;

  TVShowsHasDataState(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}

class TVShowDetailHasDataState extends BlocState {
  final TVShowDetail tvShowDetail;

  TVShowDetailHasDataState(this.tvShowDetail);

  @override
  List<Object> get props => [tvShowDetail];
}

class SeasonDetailHasDataState extends BlocState {
  final SeasonDetail seasonDetail;

  SeasonDetailHasDataState(this.seasonDetail);

  @override
  List<Object> get props => [seasonDetail];
}

class EpisodeDetailHasDataState extends BlocState {
  final EpisodeDetail episodeDetail;

  EpisodeDetailHasDataState(this.episodeDetail);

  @override
  List<Object> get props => [episodeDetail];
}
