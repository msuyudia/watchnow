import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/entities/movie.dart';
import 'package:watchnow/presentation/bloc/search_movie_bloc.dart';
import 'package:watchnow/presentation/pages/movie_detail_page.dart';
import 'package:watchnow/presentation/pages/search_movie_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockSearchMovieBloc extends MockBloc<BlocEvent, BlocState>
    implements SearchMovieBloc {}

void main() {
  late MockSearchMovieBloc mockSearchMovieBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockSearchMovieBloc = MockSearchMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchMovieBloc>.value(
      value: mockSearchMovieBloc,
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
      mockSearchMovieBloc,
      Stream.fromIterable([
        MoviesHasDataState(testMovieList),
      ]),
      initialState: MoviesHasDataState(testMovieList),
    );

    await tester.pumpWidget(_makeTestableWidget(SearchMoviePage()));
    await tester.tap(find.byType(InkWell));
  });

  group('Show All States Search Movie Page', () {
    testWidgets('Page should display loading', (WidgetTester tester) async {
      whenListen(
        mockSearchMovieBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockSearchMovieBloc.state, EmptyState());

      await expectLater(
        mockSearchMovieBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockSearchMovieBloc.state, LoadingState());

      final center = find.byKey(Key('center_loading'));
      final loading = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(SearchMoviePage()));

      expect(center, findsOneWidget);
      expect(loading, findsOneWidget);
    });

    testWidgets('Page should display movie not found',
        (WidgetTester tester) async {
      whenListen(
        mockSearchMovieBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockSearchMovieBloc.state, EmptyState());

      await expectLater(
        mockSearchMovieBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
      );

      expect(mockSearchMovieBloc.state, MoviesHasDataState(<Movie>[]));

      final center = find.byKey(Key('center_empty'));

      await tester.pumpWidget(_makeTestableWidget(SearchMoviePage()));

      await tester.enterText(find.byType(TextField), '');

      expect(center, findsOneWidget);
    });

    testWidgets('Page should display searched movies',
        (WidgetTester tester) async {
      whenListen(
        mockSearchMovieBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
        initialState: EmptyState(),
      );

      expect(mockSearchMovieBloc.state, EmptyState());

      await expectLater(
        mockSearchMovieBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
      );

      expect(mockSearchMovieBloc.state, MoviesHasDataState(testMovieList));

      await tester.pumpWidget(_makeTestableWidget(SearchMoviePage()));
      await tester.enterText(find.byType(TextField), 'spider-man');

      final expanded = find.byType(Expanded);

      expect(expanded, findsOneWidget);
    });

    testWidgets('Page should display error', (WidgetTester tester) async {
      whenListen(
        mockSearchMovieBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockSearchMovieBloc.state, EmptyState());

      await expectLater(
        mockSearchMovieBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockSearchMovieBloc.state, ErrorState('Error message'));

      final centerError = find.byKey(Key('center_error'));

      await tester.pumpWidget(_makeTestableWidget(SearchMoviePage()));

      expect(centerError, findsOneWidget);
    });

    testWidgets('Page should display empty', (WidgetTester tester) async {
      whenListen(
        mockSearchMovieBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockSearchMovieBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockSearchMovieBloc.state, EmptyState());

      final container = find.byType(Container);

      await tester.pumpWidget(_makeTestableWidget(SearchMoviePage()));

      expect(container, findsOneWidget);
    });
  });
}
