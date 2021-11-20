import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/entities/genre.dart';
import 'package:watchnow/domain/entities/movie.dart';
import 'package:watchnow/domain/entities/movie_detail.dart';
import 'package:watchnow/presentation/bloc/get_movie_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_movie_recommendations_bloc.dart';
import 'package:watchnow/presentation/bloc/watchlist_movie_status_bloc.dart';
import 'package:watchnow/presentation/pages/movie_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetMovieDetailBloc extends MockBloc<BlocEvent, BlocState>
    implements GetMovieDetailBloc {}

class MockWatchlistMovieStatusBloc extends MockBloc<BlocEvent, BlocState>
    implements WatchlistMovieStatusBloc {}

class MockGetMovieRecommendationsBloc extends MockBloc<BlocEvent, BlocState>
    implements GetMovieRecommendationsBloc {}

void main() {
  late MockGetMovieDetailBloc mockGetMovieDetailBloc;
  late MockWatchlistMovieStatusBloc mockWatchlistMovieStatusBloc;
  late MockGetMovieRecommendationsBloc mockGetMovieRecommendationsBloc;

  setUpAll(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetMovieDetailBloc = MockGetMovieDetailBloc();
    mockWatchlistMovieStatusBloc = MockWatchlistMovieStatusBloc();
    mockGetMovieRecommendationsBloc = MockGetMovieRecommendationsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetMovieDetailBloc>.value(
          value: mockGetMovieDetailBloc,
        ),
        BlocProvider<WatchlistMovieStatusBloc>.value(
          value: mockWatchlistMovieStatusBloc,
        ),
        BlocProvider<GetMovieRecommendationsBloc>.value(
          value: mockGetMovieRecommendationsBloc,
        ),
      ],
      child: MaterialApp(
          home: body,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case MovieDetailPage.ROUTE_NAME:
                return MaterialPageRoute(
                  builder: (_) => MovieDetailPage(id: 1),
                );
              default:
                return MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                });
            }
          }),
    );
  }

  void initMovieDetail() async {
    whenListen(
      mockGetMovieDetailBloc,
      Stream.fromIterable([
        MovieDetailHasDataState(testMovieDetail),
      ]),
      initialState: MovieDetailHasDataState(testMovieDetail),
    );
  }

  void watchlistButtonEmptyState() async {
    whenListen(
      mockWatchlistMovieStatusBloc,
      Stream.fromIterable([
        EmptyState(),
      ]),
      initialState: EmptyState(),
    );
  }

  void initWatchlistButton(bool isAdded) async {
    whenListen(
      mockWatchlistMovieStatusBloc,
      Stream.fromIterable([
        InitWatchlistButtonState(isAdded),
      ]),
      initialState: InitWatchlistButtonState(isAdded),
    );
  }

  void movieRecommendationsEmptyState() async {
    whenListen(
      mockGetMovieRecommendationsBloc,
      Stream.fromIterable([
        EmptyState(),
      ]),
      initialState: EmptyState(),
    );
  }

  group('Show All Tap Action For All Tappable Widgets', () {
    testWidgets('Page should can be tap movie recommendation',
        (WidgetTester tester) async {
      initMovieDetail();
      watchlistButtonEmptyState();
      whenListen(
        mockGetMovieRecommendationsBloc,
        Stream.fromIterable([
          MoviesHasDataState(testMovieList),
        ]),
        initialState: MoviesHasDataState(testMovieList),
      );

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.tap(find.byKey(Key('inkwell_0')));
    });

    testWidgets('Page should can be tap add to watchlist',
        (WidgetTester tester) async {
      initMovieDetail();
      initWatchlistButton(false);
      movieRecommendationsEmptyState();

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.tap(find.byType(ElevatedButton));
    });

    testWidgets('Page should can be tap remove from watchlist',
        (WidgetTester tester) async {
      initMovieDetail();
      initWatchlistButton(true);
      movieRecommendationsEmptyState();

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.tap(find.byType(ElevatedButton));
    });
  });

  group('Show All States Get Movie Detail', () {
    testWidgets('Page should display movie detail empty state',
        (WidgetTester tester) async {
      whenListen(
        mockGetMovieDetailBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetMovieDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetMovieDetailBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byKey(Key('movie_detail_container_empty')), findsOneWidget);
    });

    testWidgets('Page should display movie detail loading',
        (WidgetTester tester) async {
      whenListen(
        mockGetMovieDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetMovieDetailBloc.state, EmptyState());

      await expectLater(
        mockGetMovieDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetMovieDetailBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byKey(Key('movie_detail_center_loading')), findsOneWidget);
    });

    testWidgets('Page should display movie detail error',
        (WidgetTester tester) async {
      whenListen(
        mockGetMovieDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetMovieDetailBloc.state, EmptyState());

      await expectLater(
        mockGetMovieDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetMovieDetailBloc.state, ErrorState('Error message'));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byKey(Key('movie_detail_center_error')), findsOneWidget);
    });

    testWidgets(
        'Page should display movie detail content with duration more than 1 hour',
        (WidgetTester tester) async {
      watchlistButtonEmptyState();

      movieRecommendationsEmptyState();

      whenListen(
        mockGetMovieDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MovieDetailHasDataState(testMovieDetail),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetMovieDetailBloc.state, EmptyState());

      await expectLater(
        mockGetMovieDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MovieDetailHasDataState(testMovieDetail),
        ]),
      );

      expect(
        mockGetMovieDetailBloc.state,
        MovieDetailHasDataState(testMovieDetail),
      );

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Page should can be tapped icon button',
        (WidgetTester tester) async {
      watchlistButtonEmptyState();

      movieRecommendationsEmptyState();

      whenListen(
        mockGetMovieDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MovieDetailHasDataState(testMovieDetail),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetMovieDetailBloc.state, EmptyState());

      await expectLater(
        mockGetMovieDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MovieDetailHasDataState(testMovieDetail),
        ]),
      );

      expect(mockGetMovieDetailBloc.state,
          MovieDetailHasDataState(testMovieDetail));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      await tester.tap(find.byType(IconButton));
    });

    testWidgets(
        'Page should display movie detail content with duration below 1 hour',
        (WidgetTester tester) async {
      final tMovieDetail = MovieDetail(
        adult: false,
        backdropPath: 'backdropPath',
        genres: [Genre(id: 1, name: 'Action')],
        id: 1,
        originalTitle: 'originalTitle',
        overview: 'overview',
        posterPath: 'posterPath',
        releaseDate: 'releaseDate',
        runtime: 59,
        title: 'title',
        voteAverage: 1,
        voteCount: 1,
      );

      watchlistButtonEmptyState();

      movieRecommendationsEmptyState();

      whenListen(
        mockGetMovieDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MovieDetailHasDataState(tMovieDetail),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetMovieDetailBloc.state, EmptyState());

      await expectLater(
        mockGetMovieDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MovieDetailHasDataState(tMovieDetail),
        ]),
      );

      expect(
          mockGetMovieDetailBloc.state, MovieDetailHasDataState(tMovieDetail));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byType(SafeArea), findsOneWidget);
    });
  });

  group('Show All States Watchlist Button', () {
    testWidgets('Page should display watchlist button empty state',
        (WidgetTester tester) async {
      initMovieDetail();
      movieRecommendationsEmptyState();

      whenListen(
        mockWatchlistMovieStatusBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockWatchlistMovieStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockWatchlistMovieStatusBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byKey(Key('elevated_button_save')), findsOneWidget);
      expect(find.byKey(Key('icon_add')), findsOneWidget);
    });

    testWidgets('Page should display watchlist button loading state',
        (WidgetTester tester) async {
      initMovieDetail();
      movieRecommendationsEmptyState();

      whenListen(
        mockWatchlistMovieStatusBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockWatchlistMovieStatusBloc.state, EmptyState());

      await expectLater(
        mockWatchlistMovieStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockWatchlistMovieStatusBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byKey(Key('elevated_button_loading')), findsOneWidget);
    });

    testWidgets('Page should display icon check watchlist button when init',
        (WidgetTester tester) async {
      initMovieDetail();
      movieRecommendationsEmptyState();

      whenListen(
        mockWatchlistMovieStatusBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          InitWatchlistButtonState(true),
        ]),
        initialState: EmptyState(),
      );

      expect(mockWatchlistMovieStatusBloc.state, EmptyState());

      await expectLater(
        mockWatchlistMovieStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          InitWatchlistButtonState(true),
        ]),
      );

      expect(
          mockWatchlistMovieStatusBloc.state, InitWatchlistButtonState(true));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byKey(Key('elevated_button_save')), findsOneWidget);
      expect(find.byKey(Key('icon_check')), findsOneWidget);
    });

    testWidgets('Page should display icon add watchlist button when init',
        (WidgetTester tester) async {
      initMovieDetail();
      movieRecommendationsEmptyState();

      whenListen(
        mockWatchlistMovieStatusBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          InitWatchlistButtonState(false),
        ]),
        initialState: EmptyState(),
      );

      expect(mockWatchlistMovieStatusBloc.state, EmptyState());

      await expectLater(
        mockWatchlistMovieStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          InitWatchlistButtonState(false),
        ]),
      );

      expect(
          mockWatchlistMovieStatusBloc.state, InitWatchlistButtonState(false));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byKey(Key('elevated_button_save')), findsOneWidget);
      expect(find.byKey(Key('icon_add')), findsOneWidget);
    });

    testWidgets('Page should display icon check watchlist button after tap',
        (WidgetTester tester) async {
      initMovieDetail();
      movieRecommendationsEmptyState();

      whenListen(
        mockWatchlistMovieStatusBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          WatchlistButtonState('Added to watchlist', true),
        ]),
        initialState: EmptyState(),
      );

      expect(mockWatchlistMovieStatusBloc.state, EmptyState());

      await expectLater(
        mockWatchlistMovieStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          WatchlistButtonState('Added to watchlist', true),
        ]),
      );

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      await tester.tap(find.byKey(Key('elevated_button_save')));

      expect(
        mockWatchlistMovieStatusBloc.state,
        WatchlistButtonState('Added to watchlist', true),
      );

      expect(find.byKey(Key('icon_check')), findsOneWidget);
    });

    testWidgets('Page should display icon add watchlist button after tap',
        (WidgetTester tester) async {
      initMovieDetail();
      movieRecommendationsEmptyState();

      whenListen(
        mockWatchlistMovieStatusBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          WatchlistButtonState('Removed from watchlist', false),
        ]),
        initialState: EmptyState(),
      );

      expect(mockWatchlistMovieStatusBloc.state, EmptyState());

      await expectLater(
        mockWatchlistMovieStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          WatchlistButtonState('Removed from watchlist', false),
        ]),
      );

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      await tester.tap(find.byKey(Key('elevated_button_save')));

      expect(
        mockWatchlistMovieStatusBloc.state,
        WatchlistButtonState('Removed from watchlist', false),
      );

      expect(find.byKey(Key('icon_add')), findsOneWidget);
    });
  });

  group('Show All States Movie Recommendations', () {
    testWidgets('Page should display movie recommendations empty state',
        (WidgetTester tester) async {
      initMovieDetail();

      watchlistButtonEmptyState();

      whenListen(
        mockGetMovieRecommendationsBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetMovieRecommendationsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetMovieRecommendationsBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byKey(Key('movie_recommendations_container_empty')),
          findsOneWidget);
    });

    testWidgets('Page should display movie recommendations loading state',
        (WidgetTester tester) async {
      initMovieDetail();

      watchlistButtonEmptyState();

      whenListen(
        mockGetMovieRecommendationsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetMovieRecommendationsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetMovieRecommendationsBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byKey(Key('movie_recommendations_center_loading')),
          findsOneWidget);
    });

    testWidgets('Page should display movie recommendations is empty',
        (WidgetTester tester) async {
      initMovieDetail();

      watchlistButtonEmptyState();

      whenListen(
        mockGetMovieRecommendationsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetMovieRecommendationsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
      );

      expect(
        mockGetMovieRecommendationsBloc.state,
        MoviesHasDataState(<Movie>[]),
      );

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(
        find.byKey(Key('movie_recommendations_center_empty')),
        findsOneWidget,
      );
    });

    testWidgets('Page should display movie recommendations has data state',
        (WidgetTester tester) async {
      initMovieDetail();

      watchlistButtonEmptyState();

      whenListen(
        mockGetMovieRecommendationsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetMovieRecommendationsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
      );

      expect(
        mockGetMovieRecommendationsBloc.state,
        MoviesHasDataState(testMovieList),
      );

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(
        find.byKey(Key('movie_recommendations_container')),
        findsOneWidget,
      );
    });

    testWidgets('Page should display movie recommendations error state',
        (WidgetTester tester) async {
      initMovieDetail();

      watchlistButtonEmptyState();

      whenListen(
        mockGetMovieRecommendationsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetMovieRecommendationsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(
        mockGetMovieRecommendationsBloc.state,
        ErrorState('Error message'),
      );

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(
        find.byKey(Key('movie_recommendations_center_error')),
        findsOneWidget,
      );
    });
  });
}
