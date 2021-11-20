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
import 'package:watchnow/domain/entities/tv_show_detail.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_recommendations_bloc.dart';
import 'package:watchnow/presentation/bloc/watchlist_tv_show_status_bloc.dart';
import 'package:watchnow/presentation/pages/season_detail_page.dart';

class TVShowDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-show-detail';

  final int id;

  TVShowDetailPage({required this.id});

  @override
  _TVShowDetailPageState createState() => _TVShowDetailPageState();
}

class _TVShowDetailPageState extends State<TVShowDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
      ..read<GetTVShowDetailBloc>().add(GetTVShowDetailEvent(widget.id))
      ..read<GetTVShowRecommendationsBloc>()
          .add(GetTVShowRecommendationsEvent(widget.id))
      ..read<WatchlistTVShowStatusBloc>()
          .add(GetWatchlistTVShowStatusEvent(widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetTVShowDetailBloc, BlocState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              key: Key('tv_show_detail_center_loading'),
              child: CircularProgressIndicator(),
            );
          } else if (state is TVShowDetailHasDataState) {
            final tvShow = state.tvShowDetail;
            return SafeArea(child: DetailContentTVShow(tvShow));
          } else if (state is ErrorState) {
            return Text(
              state.message,
              key: Key('tv_show_detail_center_error'),
            );
          } else {
            return Container(
              key: Key('tv_show_detail_container_empty'),
            );
          }
        },
      ),
    );
  }
}

class DetailContentTVShow extends StatelessWidget {
  final TVShowDetail tvShow;

  DetailContentTVShow(this.tvShow);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Container(
            padding: EdgeInsets.only(top: 20),
            child: Icon(Icons.error),
          ),
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
                              tvShow.name,
                              style: heading5,
                            ),
                            BlocBuilder<WatchlistTVShowStatusBloc, BlocState>(
                              builder: (context, state) {
                                if (state is LoadingState) {
                                  return _showLoadingWatchlistButton();
                                } else if (state is InitWatchlistButtonState) {
                                  return _showSaveWatchlistButton(
                                    context,
                                    state.isAdded,
                                  );
                                } else if (state is WatchlistButtonState) {
                                  return _showSaveWatchlistButton(
                                    context,
                                    state.isAddedWatchlist,
                                  );
                                } else {
                                  return _showSaveWatchlistButton(
                                    context,
                                    false,
                                  );
                                }
                              },
                            ),
                            Text(
                              _showGenres(tvShow.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvShow.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: yellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvShow.voteAverage / 2}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: heading6,
                            ),
                            Text(
                              tvShow.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: heading6,
                            ),
                            _seasons(),
                            Text(
                              'Recommendations',
                              style: heading6,
                            ),
                            BlocBuilder<GetTVShowRecommendationsBloc,
                                BlocState>(
                              builder: (context, state) {
                                if (state is LoadingState) {
                                  return Center(
                                    key: Key(
                                      'tv_show_recommendations_center_loading',
                                    ),
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is ErrorState) {
                                  return Center(
                                      key: Key(
                                        'tv_show_recommendations_center_error',
                                      ),
                                      child: Text(state.message));
                                } else if (state is TVShowsHasDataState) {
                                  if (state.tvShows.isEmpty)
                                    return Center(
                                      key: Key(
                                        'tv_show_recommendations_center_empty',
                                      ),
                                      child: Text(
                                        'TV Show Recommendations Is Empty',
                                      ),
                                    );
                                  else
                                    return Container(
                                      key: Key(
                                        'tv_show_recommendations_container',
                                      ),
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final tvShow = state.tvShows[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: InkWell(
                                              key: Key('tv_show_inkwell_' + index.toString()),
                                              onTap: () {
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  TVShowDetailPage.ROUTE_NAME,
                                                  arguments: tvShow.id,
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      '$BASE_IMAGE_URL${tvShow.posterPath}',
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
                                        itemCount: state.tvShows.length,
                                      ),
                                    );
                                } else {
                                  return Container(
                                    key: Key(
                                      'tv_show_recommendations_container_empty',
                                    ),
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

  Widget _seasons() => Container(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final season = tvShow.seasons[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                key: Key('season_inkwell_' + index.toString()),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SeasonDetailPage.ROUTE_NAME,
                    arguments: {
                      TV_SHOW_ID: tvShow.id,
                      SEASON_NUMBER: season.seasonNumber
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: '$BASE_IMAGE_URL${season.posterPath}',
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            );
          },
          itemCount: tvShow.seasons.length,
        ),
      );

  Widget _showSaveWatchlistButton(
    BuildContext context,
    bool isAddedWatchlist,
  ) =>
      ElevatedButton(
        key: Key('elevated_button_save'),
        onPressed: () {
          if (isAddedWatchlist) {
            context.read<WatchlistTVShowStatusBloc>().add(
                  RemoveWatchlistTVShowStatusEvent(
                    tvShow,
                  ),
                );
          } else {
            context.read<WatchlistTVShowStatusBloc>().add(
                  SaveWatchlistTVShowStatusEvent(
                    tvShow,
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
