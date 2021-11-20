import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/domain/entities/season_detail.dart';
import 'package:watchnow/presentation/bloc/get_season_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_recommendations_bloc.dart';
import 'package:watchnow/presentation/pages/episode_detail_page.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';

class SeasonDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/season-detail';

  final Map<String, dynamic> tvShowDetail;

  SeasonDetailPage({required this.tvShowDetail});

  @override
  _SeasonDetailPageState createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context
        ..read<GetSeasonDetailBloc>().add(
          GetSeasonDetailEvent(
            widget.tvShowDetail[TV_SHOW_ID],
            widget.tvShowDetail[SEASON_NUMBER],
          ),
        )
        ..read<GetTVShowRecommendationsBloc>().add(
          GetTVShowRecommendationsEvent(
            widget.tvShowDetail[TV_SHOW_ID],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetSeasonDetailBloc, BlocState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              key: Key('season_detail_center_loading'),
              child: CircularProgressIndicator(),
            );
          } else if (state is SeasonDetailHasDataState) {
            return SafeArea(
              child: DetailContentSeason(
                widget.tvShowDetail[TV_SHOW_ID],
                state.seasonDetail,
              ),
            );
          } else if (state is ErrorState) {
            return Text(
              state.message,
              key: Key('season_detail_center_error'),
            );
          } else {
            return Container(
              key: Key('season_detail_container_empty'),
            );
          }
        },
      ),
    );
  }
}

class DetailContentSeason extends StatelessWidget {
  final int tvShowId;
  final SeasonDetail season;

  DetailContentSeason(this.tvShowId, this.season);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${season.posterPath}',
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
                              season.name,
                              style: heading5,
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: _totalRating(),
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: yellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${_totalRating()}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: heading6,
                            ),
                            Text(
                              season.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Episodes',
                              style: heading6,
                            ),
                            _episodes(),
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
                                    child: Text(state.message),
                                  );
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

  double _totalRating() {
    if (season.episodes.isEmpty)
      return 0;
    else {
      double stars = 0;
      season.episodes.map((episode) => stars += episode.voteAverage);
      return (stars / season.episodes.length) / 2;
    }
  }

  Widget _episodes() => Container(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final episode = season.episodes[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                key: Key('episode_inkwell_' + index.toString()),
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    EpisodeDetailPage.ROUTE_NAME,
                    arguments: {
                      TV_SHOW_ID: tvShowId,
                      SEASON_NUMBER: season.seasonNumber,
                      EPISODE_NUMBER: episode.episodeNumber
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: '$BASE_IMAGE_URL${episode.stillPath}',
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            );
          },
          itemCount: season.episodes.length,
        ),
      );
}
