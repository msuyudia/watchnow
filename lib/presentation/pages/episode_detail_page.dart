import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/domain/entities/episode_detail.dart';
import 'package:watchnow/presentation/bloc/get_episode_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_recommendations_bloc.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';

class EpisodeDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/episode-detail';

  final Map<String, dynamic> seasonDetail;

  EpisodeDetailPage({required this.seasonDetail});

  @override
  _EpisodeDetailPageState createState() => _EpisodeDetailPageState();
}

class _EpisodeDetailPageState extends State<EpisodeDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context
        ..read<GetEpisodeDetailBloc>().add(
          GetEpisodeDetailEvent(
            widget.seasonDetail[TV_SHOW_ID],
            widget.seasonDetail[SEASON_NUMBER],
            widget.seasonDetail[EPISODE_NUMBER],
          ),
        )
        ..read<GetTVShowRecommendationsBloc>().add(
          GetTVShowRecommendationsEvent(
            widget.seasonDetail[TV_SHOW_ID],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetEpisodeDetailBloc, BlocState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              key: Key('episode_detail_center_loading'),
              child: CircularProgressIndicator(),
            );
          } else if (state is EpisodeDetailHasDataState) {
            return SafeArea(
              child: DetailContentEpisode(
                widget.seasonDetail[TV_SHOW_ID],
                widget.seasonDetail[SEASON_NUMBER],
                state.episodeDetail,
              ),
            );
          } else if (state is ErrorState) {
            return Text(
              state.message,
              key: Key('episode_detail_center_error'),
            );
          } else {
            return Container(
              key: Key('episode_detail_container_empty'),
            );
          }
        },
      ),
    );
  }
}

class DetailContentEpisode extends StatelessWidget {
  final int tvShowId;
  final int seasonId;
  final EpisodeDetail episode;

  DetailContentEpisode(this.tvShowId, this.seasonId, this.episode);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          key: Key('banner'),
          imageUrl: '$BASE_IMAGE_URL${episode.stillPath}',
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
                              episode.name,
                              style: heading5,
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: episode.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: yellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${episode.voteAverage / 2}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: heading6,
                            ),
                            Text(
                              episode.overview,
                            ),
                            SizedBox(height: 16),
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
}
