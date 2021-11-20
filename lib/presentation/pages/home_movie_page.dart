import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/domain/entities/movie.dart';
import 'package:watchnow/presentation/bloc/get_now_playing_movies_bloc.dart';
import 'package:watchnow/presentation/bloc/get_popular_movies_bloc.dart';
import 'package:watchnow/presentation/bloc/get_top_rated_movies_bloc.dart';
import 'package:watchnow/presentation/pages/about_page.dart';
import 'package:watchnow/presentation/pages/movie_detail_page.dart';
import 'package:watchnow/presentation/pages/popular_movies_page.dart';
import 'package:watchnow/presentation/pages/search_movie_page.dart';
import 'package:watchnow/presentation/pages/top_rated_movies_page.dart';
import 'package:watchnow/presentation/pages/tv_show_page.dart';
import 'package:watchnow/presentation/pages/watchlist_movies_page.dart';
import 'package:watchnow/presentation/pages/watchlist_tv_shows_page.dart';
import 'package:watchnow/presentation/widgets/center_text.dart';
import 'package:watchnow/presentation/widgets/loading.dart';
import 'package:watchnow/presentation/widgets/sub_heading.dart';

class HomeMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/home';

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
      ..read<GetNowPlayingMoviesBloc>().add(GetNowPlayingMoviesEvent())
      ..read<GetPopularMoviesBloc>().add(GetPopularMoviesEvent())
      ..read<GetTopRatedMoviesBloc>().add(GetTopRatedMoviesEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: Image.asset('assets/ic_launcher.png'),
              accountName: Text('M Suyudi Alrajak', style: subtitle),
              accountEmail: Text('m.suyudi.a@gmail.com', style: bodyText),
            ),
            ListTile(
              key: Key('movies_list_tile'),
              leading: Icon(Icons.movie),
              title: Text('Movies', style: bodyText),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              key: Key('tv_shows_list_tile'),
              leading: Icon(Icons.tv_outlined),
              title: Text('TV Shows', style: bodyText),
              onTap: () {
                Navigator.pushNamed(context, TVShowPage.ROUTE_NAME);
              },
            ),
            ListTile(
              key: Key('watchlist_movies_list_tile'),
              leading: Icon(Icons.save_alt),
              title: Text('My Watchlist Movies', style: bodyText),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              key: Key('watchlist_tv_shows_list_tile'),
              leading: Icon(Icons.download_for_offline),
              title: Text('My Watchlist TV Shows', style: bodyText),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTVShowsPage.ROUTE_NAME);
              },
            ),
            ListTile(
              key: Key('about_list_tile'),
              leading: Icon(Icons.info_outline),
              title: Text('About', style: bodyText),
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Watch Now', style: heading6),
        actions: [
          IconButton(
            key: Key('search_icon_button'),
            onPressed: () {
              Navigator.pushNamed(context, SearchMoviePage.ROUTE_NAME);
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
                'Now Playing',
                style: heading6,
              ),
              BlocBuilder<GetNowPlayingMoviesBloc, BlocState>(
                  builder: (context, state) {
                if (state is LoadingState) {
                  return LoadingWidget(
                    keyValue: 'now_playing_loading',
                    padding: EdgeInsets.symmetric(vertical: 82.5),
                  );
                } else if (state is MoviesHasDataState) {
                  if (state.movies.isEmpty)
                    return CenterText(
                      keyValue: 'now_playing_empty_container',
                      text: "Now Playing Movies Is Empty",
                      padding: EdgeInsets.symmetric(vertical: 90),
                    );
                  else
                    return MovieList(
                      'now_playing_movies_container',
                      'now_playing_inkwell',
                      state.movies,
                    );
                } else if (state is ErrorState) {
                  return CenterText(
                    keyValue: 'now_playing_error_container',
                    text: state.message,
                    padding: EdgeInsets.symmetric(vertical: 90),
                  );
                } else {
                  return Container(
                      key: Key('now_playing_empty_state_container'));
                }
              }),
              SubHeading(
                'popular_sub_heading',
                'Popular',
                () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<GetPopularMoviesBloc, BlocState>(
                  builder: (context, state) {
                if (state is LoadingState) {
                  return LoadingWidget(
                    keyValue: 'popular_loading',
                    padding: EdgeInsets.symmetric(vertical: 82.5),
                  );
                } else if (state is MoviesHasDataState) {
                  if (state.movies.isEmpty)
                    return CenterText(
                      keyValue: 'popular_empty_container',
                      text: "Popular Movies Is Empty",
                      padding: EdgeInsets.symmetric(vertical: 90),
                    );
                  else
                    return MovieList(
                      'popular_movies_container',
                      'popular_inkwell',
                      state.movies,
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
                () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<GetTopRatedMoviesBloc, BlocState>(
                  builder: (context, state) {
                if (state is LoadingState) {
                  return LoadingWidget(
                    keyValue: 'top_rated_loading',
                    padding: EdgeInsets.symmetric(vertical: 82.5),
                  );
                } else if (state is MoviesHasDataState) {
                  if (state.movies.isEmpty)
                    return CenterText(
                      keyValue: 'top_rated_empty_container',
                      text: 'Top Rated Movies Is Empty',
                    );
                  else
                    return MovieList(
                      'top_rated_movies_container',
                      'top_rated_inkwell',
                      state.movies,
                    );
                } else if (state is ErrorState) {
                  return CenterText(
                    keyValue: 'top_rated_error_container',
                    text: state.message,
                    padding: EdgeInsets.symmetric(vertical: 82.5),
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

class MovieList extends StatelessWidget {
  final String keyContainerValue;
  final String keyInkWellValue;
  final List<Movie> movies;

  MovieList(this.keyContainerValue, this.keyInkWellValue, this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(keyContainerValue),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            child: InkWell(
              key: Key(keyInkWellValue),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
