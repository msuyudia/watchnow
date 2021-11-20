import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/injection.dart' as di;
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
import 'package:watchnow/presentation/pages/about_page.dart';
import 'package:watchnow/presentation/pages/episode_detail_page.dart';
import 'package:watchnow/presentation/pages/home_movie_page.dart';
import 'package:watchnow/presentation/pages/movie_detail_page.dart';
import 'package:watchnow/presentation/pages/popular_movies_page.dart';
import 'package:watchnow/presentation/pages/popular_tv_shows_page.dart';
import 'package:watchnow/presentation/pages/search_movie_page.dart';
import 'package:watchnow/presentation/pages/search_tv_show_page.dart';
import 'package:watchnow/presentation/pages/season_detail_page.dart';
import 'package:watchnow/presentation/pages/top_rated_movies_page.dart';
import 'package:watchnow/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';
import 'package:watchnow/presentation/pages/tv_show_page.dart';
import 'package:watchnow/presentation/pages/watchlist_movies_page.dart';
import 'package:watchnow/presentation/pages/watchlist_tv_shows_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<GetNowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<GetPopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<GetTopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<SearchMovieBloc>()),
        BlocProvider(create: (_) => di.locator<GetWatchlistMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<GetMovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieStatusBloc>()),
        BlocProvider(create: (_) => di.locator<GetMovieRecommendationsBloc>()),
        BlocProvider(create: (_) => di.locator<GetOnTheAirTVShowsBloc>()),
        BlocProvider(create: (_) => di.locator<GetPopularTVShowsBloc>()),
        BlocProvider(create: (_) => di.locator<GetTopRatedTVShowsBloc>()),
        BlocProvider(create: (_) => di.locator<SearchTVShowBloc>()),
        BlocProvider(create: (_) => di.locator<GetWatchlistTVShowsBloc>()),
        BlocProvider(create: (_) => di.locator<GetTVShowDetailBloc>()),
        BlocProvider(create: (_) => di.locator<GetSeasonDetailBloc>()),
        BlocProvider(create: (_) => di.locator<GetEpisodeDetailBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTVShowStatusBloc>()),
        BlocProvider(create: (_) => di.locator<GetTVShowRecommendationsBloc>()),
      ],
      child: MaterialApp(
        title: 'Watch Now',
        theme: ThemeData.dark().copyWith(
          colorScheme: colorScheme,
          primaryColor: primaryColor,
          accentColor: secondaryColor,
          scaffoldBackgroundColor: primaryColor,
          textTheme: textTheme,
        ),
        home: HomeMoviePage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case TVShowPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => TVShowPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case PopularTVShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTVShowsPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case TopRatedTVShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTVShowsPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TVShowDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVShowDetailPage(id: id),
                settings: settings,
              );
            case SeasonDetailPage.ROUTE_NAME:
              final tvShowDetail = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => SeasonDetailPage(tvShowDetail: tvShowDetail),
                settings: settings,
              );
            case EpisodeDetailPage.ROUTE_NAME:
              final seasonDetail = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => EpisodeDetailPage(seasonDetail: seasonDetail),
                settings: settings,
              );
            case SearchMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
            case SearchTVShowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTVShowPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTVShowsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTVShowsPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
