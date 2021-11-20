import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/presentation/bloc/get_on_the_air_tv_shows_bloc.dart';
import 'package:watchnow/presentation/bloc/get_popular_tv_shows_bloc.dart';
import 'package:watchnow/presentation/bloc/get_top_rated_tv_shows_bloc.dart';
import 'package:watchnow/presentation/pages/popular_tv_shows_page.dart';
import 'package:watchnow/presentation/pages/search_tv_show_page.dart';
import 'package:watchnow/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';
import 'package:watchnow/presentation/widgets/center_text.dart';
import 'package:watchnow/presentation/widgets/loading.dart';
import 'package:watchnow/presentation/widgets/sub_heading.dart';

class TVShowPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-show';

  @override
  _TVShowPageState createState() => _TVShowPageState();
}

class _TVShowPageState extends State<TVShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
      ..read<GetOnTheAirTVShowsBloc>().add(GetOnTheAirTVShowsEvent())
      ..read<GetPopularTVShowsBloc>().add(GetPopularTVShowsEvent())
      ..read<GetTopRatedTVShowsBloc>().add(GetTopRatedTVShowsEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Show', style: heading6),
        actions: [
          IconButton(
            key: Key('search_icon_button'),
            onPressed: () {
              Navigator.pushNamed(context, SearchTVShowPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'On The Air',
                style: heading6,
              ),
              BlocBuilder<GetOnTheAirTVShowsBloc, BlocState>(
                  builder: (context, state) {
                if (state is LoadingState) {
                  return LoadingWidget(
                    keyValue: 'on_the_air_loading',
                    padding: EdgeInsets.symmetric(vertical: 82.5),
                  );
                } else if (state is TVShowsHasDataState) {
                  if (state.tvShows.isEmpty)
                    return CenterText(
                      keyValue: 'on_the_air_empty_container',
                      text: "On The Air TV Shows Is Empty",
                      padding: EdgeInsets.symmetric(vertical: 90),
                    );
                  else
                    return TVShowList(
                      'on_the_air_tv_shows_container',
                      'on_the_air_inkwell',
                      state.tvShows,
                    );
                } else if (state is ErrorState) {
                  return CenterText(
                    keyValue: 'on_the_air_error_container',
                    text: state.message,
                    padding: EdgeInsets.symmetric(vertical: 90),
                  );
                } else {
                  return Container(
                      key: Key('on_the_air_empty_state_container'));
                }
              }),
              SubHeading(
                'popular_sub_heading',
                'Popular',
                () =>
                    Navigator.pushNamed(context, PopularTVShowsPage.ROUTE_NAME),
              ),
              BlocBuilder<GetPopularTVShowsBloc, BlocState>(
                  builder: (context, state) {
                if (state is LoadingState) {
                  return LoadingWidget(
                    keyValue: 'popular_loading',
                    padding: EdgeInsets.symmetric(vertical: 82.5),
                  );
                } else if (state is TVShowsHasDataState) {
                  if (state.tvShows.isEmpty)
                    return CenterText(
                      keyValue: 'popular_empty_container',
                      text: "Popular TV Shows Is Empty",
                      padding: EdgeInsets.symmetric(vertical: 90),
                    );
                  else
                    return TVShowList(
                      'popular_tv_shows_container',
                      'popular_inkwell',
                      state.tvShows,
                    );
                } else if (state is ErrorState) {
                  return CenterText(
                    keyValue: 'popular_error_container',
                    text: state.message,
                    padding: EdgeInsets.symmetric(vertical: 90),
                  );
                } else {
                  return Container(key: Key('popular_empty_state_container'));
                }
              }),
              SubHeading(
                'top_rated_sub_heading',
                'Top Rated',
                () => Navigator.pushNamed(
                    context, TopRatedTVShowsPage.ROUTE_NAME),
              ),
              BlocBuilder<GetTopRatedTVShowsBloc, BlocState>(
                  builder: (context, state) {
                if (state is LoadingState) {
                  return LoadingWidget(
                    keyValue: 'top_rated_loading',
                    padding: EdgeInsets.symmetric(vertical: 82.5),
                  );
                } else if (state is TVShowsHasDataState) {
                  if (state.tvShows.isEmpty)
                    return CenterText(
                      keyValue: 'top_rated_empty_container',
                      text: "Top Rated TV Shows Is Empty",
                      padding: EdgeInsets.symmetric(vertical: 90),
                    );
                  else
                    return TVShowList(
                      'top_rated_tv_shows_container',
                      'top_rated_inkwell',
                      state.tvShows,
                    );
                } else if (state is ErrorState) {
                  return CenterText(
                    keyValue: 'top_rated_error_container',
                    text: state.message,
                    padding: EdgeInsets.symmetric(vertical: 90),
                  );
                } else {
                  return Container(key: Key('top_rated_empty_state_container'));
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class TVShowList extends StatelessWidget {
  final String containerKeyValue;
  final String inkWellKeyValue;
  final List<TVShow> tvShows;

  TVShowList(this.containerKeyValue, this.inkWellKeyValue, this.tvShows);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(containerKeyValue),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvShow = tvShows[index];
          return Container(
            padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            child: InkWell(
              key: Key(inkWellKeyValue),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TVShowDetailPage.ROUTE_NAME,
                  arguments: tvShow.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}
