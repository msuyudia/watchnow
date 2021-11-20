import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/domain/entities/genre.dart';
import 'package:watchnow/domain/entities/movie_detail.dart';
import 'package:watchnow/presentation/bloc/get_movie_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_movie_recommendations_bloc.dart';
import 'package:watchnow/presentation/bloc/watchlist_movie_status_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/movie-detail';

  final int id;

  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
        ..read<GetMovieDetailBloc>().add(GetMovieDetailEvent(widget.id))
        ..read<GetMovieRecommendationsBloc>()
            .add(GetMovieRecommendationsEvent(widget.id))
        ..read<WatchlistMovieStatusBloc>()
            .add(GetWatchlistMovieStatusEvent(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetMovieDetailBloc, BlocState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
                key: Key('movie_detail_center_loading'),
                child: CircularProgressIndicator());
          } else if (state is MovieDetailHasDataState) {
            final movie = state.movieDetail;
            return SafeArea(child: DetailContent(movie));
          } else if (state is ErrorState) {
            return Center(
              key: Key('movie_detail_center_error'),
              child: Text(state.message),
            );
          } else {
            return Container(
              key: Key('movie_detail_container_empty'),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;

  DetailContent(this.movie);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Container(
              padding: EdgeInsets.only(top: 20), child: Icon(Icons.error)),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: heading5,
                            ),
                            BlocBuilder<WatchlistMovieStatusBloc, BlocState>(
                              builder: (context, state) {
                                if (state is LoadingState) {
                                  return _showLoadingWatchlistButton();
                                } else if (state is InitWatchlistButtonState) {
                                  return _showSaveWatchlistButton(
                                      context, state.isAdded);
                                } else if (state is WatchlistButtonState) {
                                  return _showSaveWatchlistButton(
                                      context, state.isAddedWatchlist);
                                } else {
                                  return _showSaveWatchlistButton(
                                      context, false);
                                }
                              },
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: yellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage / 2}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: heading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: heading6,
                            ),
                            BlocBuilder<GetMovieRecommendationsBloc, BlocState>(
                              builder: (context, state) {
                                if (state is LoadingState) {
                                  return Center(
                                    key: Key(
                                      'movie_recommendations_center_loading',
                                    ),
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is ErrorState) {
                                  return Center(
                                      key: Key(
                                        'movie_recommendations_center_error',
                                      ),
                                      child: Text(state.message));
                                } else if (state is MoviesHasDataState) {
                                  if (state.movies.isNotEmpty) {
                                    return Container(
                                      key: Key(
                                        'movie_recommendations_container',
                                      ),
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final movie = state.movies[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: InkWell(
                                              key: Key('inkwell_' + index.toString()),
                                              onTap: () {
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  MovieDetailPage.ROUTE_NAME,
                                                  arguments: movie.id,
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: state.movies.length,
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      key: Key(
                                        'movie_recommendations_center_empty',
                                      ),
                                      child: Text(
                                        'Movie Recommendations Is Empty',
                                      ),
                                    );
                                  }
                                } else {
                                  return Container(
                                    key: Key(
                                        'movie_recommendations_container_empty'),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Widget _showSaveWatchlistButton(
          BuildContext context, bool isAddedWatchlist) =>
      ElevatedButton(
        key: Key('elevated_button_save'),
        onPressed: () {
          if (isAddedWatchlist) {
            context.read<WatchlistMovieStatusBloc>().add(
                  RemoveWatchlistMovieStatusEvent(
                    movie,
                  ),
                );
          } else {
            context.read<WatchlistMovieStatusBloc>().add(
                  SaveWatchlistMovieStatusEvent(
                    movie,
                  ),
                );
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isAddedWatchlist
                ? Icon(
                    Icons.check,
                    key: Key('icon_check'),
                  )
                : Icon(
                    Icons.add,
                    key: Key('icon_add'),
                  ),
            Text('Watchlist'),
          ],
        ),
      );

  Widget _showLoadingWatchlistButton() => ElevatedButton(
        key: Key('elevated_button_loading'),
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Watchlist'),
          ],
        ),
      );
}
