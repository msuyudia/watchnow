import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/entities/movie.dart';
import 'package:watchnow/presentation/bloc/get_now_playing_movies_bloc.dart';
import 'package:watchnow/presentation/bloc/get_popular_movies_bloc.dart';
import 'package:watchnow/presentation/bloc/get_top_rated_movies_bloc.dart';
import 'package:watchnow/presentation/pages/about_page.dart';
import 'package:watchnow/presentation/pages/home_movie_page.dart';
import 'package:watchnow/presentation/pages/movie_detail_page.dart';
import 'package:watchnow/presentation/pages/popular_movies_page.dart';
import 'package:watchnow/presentation/pages/search_movie_page.dart';
import 'package:watchnow/presentation/pages/top_rated_movies_page.dart';
import 'package:watchnow/presentation/pages/tv_show_page.dart';
import 'package:watchnow/presentation/pages/watchlist_movies_page.dart';
import 'package:watchnow/presentation/pages/watchlist_tv_shows_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetNowPlayingMoviesBloc extends MockBloc<BlocEvent, BlocState>
    implements GetNowPlayingMoviesBloc {}

class MockGetPopularMoviesBloc extends MockBloc<BlocEvent, BlocState>
    implements GetPopularMoviesBloc {}

class MockGetTopRatedMoviesBloc extends MockBloc<BlocEvent, BlocState>
    implements GetTopRatedMoviesBloc {}

void main() {
  late MockGetNowPlayingMoviesBloc mockGetNowPlayingMoviesBloc;
  late MockGetPopularMoviesBloc mockGetPopularMoviesBloc;
  late MockGetTopRatedMoviesBloc mockGetTopRatedMoviesBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetNowPlayingMoviesBloc = MockGetNowPlayingMoviesBloc();
    mockGetPopularMoviesBloc = MockGetPopularMoviesBloc();
    mockGetTopRatedMoviesBloc = MockGetTopRatedMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetNowPlayingMoviesBloc>.value(
          value: mockGetNowPlayingMoviesBloc,
        ),
        BlocProvider<GetPopularMoviesBloc>.value(
          value: mockGetPopularMoviesBloc,
        ),
        BlocProvider<GetTopRatedMoviesBloc>.value(
          value: mockGetTopRatedMoviesBloc,
        ),
      ],
      child: MaterialApp(
        home: HomeMoviePage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case TVShowPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => TVShowPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
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

  void nowPlayingMoviesEmptyState() async {
    whenListen(
      mockGetNowPlayingMoviesBloc,
      Stream.fromIterable([
        EmptyState(),
      ]),
      initialState: EmptyState(),
    );
  }

  void popularMoviesEmptyState() async {
    whenListen(
      mockGetPopularMoviesBloc,
      Stream.fromIterable([
        EmptyState(),
      ]),
      initialState: EmptyState(),
    );
  }

  void topRatedMoviesEmptyState() async {
    whenListen(
      mockGetTopRatedMoviesBloc,
      Stream.fromIterable([
        EmptyState(),
      ]),
      initialState: EmptyState(),
    );
  }

  group('Verify All Tap Action For All Tappable Widgets In Movie Page', () {
    testWidgets('Page should can be tap search icon button',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('search_icon_button')));
    });

    testWidgets('Page should can be tap movie page in navigation drawer',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
      final drawerFinder = find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle();
      await tester.tap(drawerFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('movies_list_tile')));
    });

    testWidgets('Page should can be tap tv show page in navigation drawer',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
      final drawerFinder = find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle();
      await tester.tap(drawerFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('tv_shows_list_tile')));
    });

    testWidgets(
        'Page should can be tap watchlist movies page in navigation drawer',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
      final drawerFinder = find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle();
      await tester.tap(drawerFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('watchlist_movies_list_tile')));
    });

    testWidgets(
        'Page should can be tap watchlist tv shows in navigation drawer',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
      final drawerFinder = find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle();
      await tester.tap(drawerFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('watchlist_tv_shows_list_tile')));
    });

    testWidgets('Page should can be tap about page in navigation drawer',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
      final drawerFinder = find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle();
      await tester.tap(drawerFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('about_list_tile')));
    });

    testWidgets('Page should can be tap see more in above popular list',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
      await tester.tap(find.byKey(Key('popular_sub_heading')));
    });

    testWidgets('Page should can be tap see more in above top rated list',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
      await tester.tap(find.byKey(Key('top_rated_sub_heading')));
    });

    testWidgets('Page should can be tap item movie in now playing list',
        (WidgetTester tester) async {
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      whenListen(
        mockGetNowPlayingMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetNowPlayingMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
      );

      expect(
        mockGetNowPlayingMoviesBloc.state,
        MoviesHasDataState(testMovieList),
      );

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
      await tester.tap(find.byKey(Key('now_playing_inkwell')));
    });

    testWidgets('Page should can be tap item movie in popular list',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      topRatedMoviesEmptyState();

      whenListen(
        mockGetPopularMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetPopularMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
      );

      expect(
        mockGetPopularMoviesBloc.state,
        MoviesHasDataState(testMovieList),
      );

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
      await tester.tap(find.byKey(Key('popular_inkwell')));
    });

    testWidgets('Page should can be tap item movie in top rated list',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();

      whenListen(
        mockGetTopRatedMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetTopRatedMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
      );

      expect(
        mockGetTopRatedMoviesBloc.state,
        MoviesHasDataState(testMovieList),
      );

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
      await tester.tap(find.byKey(Key('top_rated_inkwell')));
    });
  });

  group('Show All States Get Now Playing Movies', () {
    testWidgets('Page should display now playing movies empty state',
        (WidgetTester tester) async {
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();
      whenListen(
        mockGetNowPlayingMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetNowPlayingMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetNowPlayingMoviesBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(
          find.byKey(Key('now_playing_empty_state_container')), findsOneWidget);
    });

    testWidgets('Page should display now playing movies loading state',
        (WidgetTester tester) async {
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();
      whenListen(
        mockGetNowPlayingMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetNowPlayingMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetNowPlayingMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetNowPlayingMoviesBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('now_playing_loading')), findsOneWidget);
    });

    testWidgets('Page should display now playing movies error state',
        (WidgetTester tester) async {
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      whenListen(
        mockGetNowPlayingMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetNowPlayingMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetNowPlayingMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetNowPlayingMoviesBloc.state, ErrorState('Error message'));

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('now_playing_error_container')), findsOneWidget);
    });

    testWidgets('Page should display now playing movies is empty',
        (WidgetTester tester) async {
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      whenListen(
        mockGetNowPlayingMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetNowPlayingMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetNowPlayingMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
      );

      expect(
        mockGetNowPlayingMoviesBloc.state,
        MoviesHasDataState(<Movie>[]),
      );

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('now_playing_empty_container')), findsOneWidget);
    });

    testWidgets('Page should display now playing movies',
        (WidgetTester tester) async {
      popularMoviesEmptyState();
      topRatedMoviesEmptyState();

      whenListen(
        mockGetNowPlayingMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetNowPlayingMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetNowPlayingMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
      );

      expect(
        mockGetNowPlayingMoviesBloc.state,
        MoviesHasDataState(testMovieList),
      );

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('now_playing_movies_container')), findsOneWidget);
    });
  });

  group('Show All States Popular Movies', () {
    testWidgets('Page should display popular movies empty state',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      topRatedMoviesEmptyState();
      whenListen(
        mockGetPopularMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetPopularMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetPopularMoviesBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('popular_empty_state_container')), findsOneWidget);
    });

    testWidgets('Page should display popular movies loading state',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      topRatedMoviesEmptyState();
      whenListen(
        mockGetPopularMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetPopularMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetPopularMoviesBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('popular_loading')), findsOneWidget);
    });

    testWidgets('Page should display popular movies error state',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      topRatedMoviesEmptyState();

      whenListen(
        mockGetPopularMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetPopularMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetPopularMoviesBloc.state, ErrorState('Error message'));

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('popular_error_container')), findsOneWidget);
    });

    testWidgets('Page should display popular movies is empty',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      topRatedMoviesEmptyState();

      whenListen(
        mockGetPopularMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetPopularMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
      );

      expect(
        mockGetPopularMoviesBloc.state,
        MoviesHasDataState(<Movie>[]),
      );

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('popular_empty_container')), findsOneWidget);
    });

    testWidgets('Page should display popular movies',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      topRatedMoviesEmptyState();

      whenListen(
        mockGetPopularMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetPopularMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
      );

      expect(
        mockGetPopularMoviesBloc.state,
        MoviesHasDataState(testMovieList),
      );

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('popular_movies_container')), findsOneWidget);
    });
  });

  group('Show All States Top Rated Movies', () {
    testWidgets('Page should display top rated movies empty state',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();
      whenListen(
        mockGetTopRatedMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetTopRatedMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetTopRatedMoviesBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(
          find.byKey(Key('top_rated_empty_state_container')), findsOneWidget);
    });

    testWidgets('Page should display top rated movies loading state',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();
      whenListen(
        mockGetTopRatedMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTopRatedMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetTopRatedMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetTopRatedMoviesBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('top_rated_loading')), findsOneWidget);
    });

    testWidgets('Page should display top rated movies error state',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();

      whenListen(
        mockGetTopRatedMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTopRatedMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetTopRatedMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetTopRatedMoviesBloc.state, ErrorState('Error message'));

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('top_rated_error_container')), findsOneWidget);
    });

    testWidgets('Page should display top rated movies is empty',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();

      whenListen(
        mockGetTopRatedMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTopRatedMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetTopRatedMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
      );

      expect(
        mockGetTopRatedMoviesBloc.state,
        MoviesHasDataState(<Movie>[]),
      );

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('top_rated_empty_container')), findsOneWidget);
    });

    testWidgets('Page should display top rated movies',
        (WidgetTester tester) async {
      nowPlayingMoviesEmptyState();
      popularMoviesEmptyState();

      whenListen(
        mockGetTopRatedMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTopRatedMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetTopRatedMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
      );

      expect(
        mockGetTopRatedMoviesBloc.state,
        MoviesHasDataState(testMovieList),
      );

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(find.byKey(Key('top_rated_movies_container')), findsOneWidget);
    });
  });
}
