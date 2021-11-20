import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/entities/movie.dart';
import 'package:watchnow/presentation/bloc/get_top_rated_movies_bloc.dart';
import 'package:watchnow/presentation/pages/movie_detail_page.dart';
import 'package:watchnow/presentation/pages/top_rated_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetTopRatedMoviesBloc extends MockBloc<BlocEvent, BlocState>
    implements GetTopRatedMoviesBloc {}

void main() {
  late MockGetTopRatedMoviesBloc mockGetTopRatedMoviesBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetTopRatedMoviesBloc = MockGetTopRatedMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetTopRatedMoviesBloc>.value(
      value: mockGetTopRatedMoviesBloc,
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

  testWidgets('Page should can be tap item movie', (WidgetTester tester) async {
    whenListen(
      mockGetTopRatedMoviesBloc,
      Stream.fromIterable([
        MoviesHasDataState(testMovieList),
      ]),
      initialState: MoviesHasDataState(testMovieList),
    );

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
    await tester.tap(find.byType(InkWell));
  });

  group('Show All States Top Rated Movies Page', () {
    testWidgets('Page should display loading', (WidgetTester tester) async {
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

      final center = find.byType(Center);
      final loading = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      expect(center, findsOneWidget);
      expect(loading, findsOneWidget);
    });

    testWidgets('Page should display top rated movies empty',
        (WidgetTester tester) async {
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

      expect(mockGetTopRatedMoviesBloc.state, MoviesHasDataState(<Movie>[]));

      final centerEmpty = find.byKey(Key('center_empty'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      expect(centerEmpty, findsOneWidget);
    });

    testWidgets('Page should display top rated movies',
        (WidgetTester tester) async {
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
          mockGetTopRatedMoviesBloc.state, MoviesHasDataState(testMovieList));

      final listView = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      expect(listView, findsOneWidget);
    });

    testWidgets('Page should display error', (WidgetTester tester) async {
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

      final centerError = find.byKey(Key('center_error'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      expect(centerError, findsOneWidget);
    });

    testWidgets('Page should display empty', (WidgetTester tester) async {
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

      final empty = find.byType(Container);

      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      expect(empty, findsOneWidget);
    });
  });
}
