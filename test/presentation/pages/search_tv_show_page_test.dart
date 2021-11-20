import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/presentation/bloc/search_tv_show_bloc.dart';
import 'package:watchnow/presentation/pages/search_tv_show_page.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockSearchTVShowBloc extends MockBloc<BlocEvent, BlocState>
    implements SearchTVShowBloc {}

void main() {
  late MockSearchTVShowBloc mockSearchTVShowBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockSearchTVShowBloc = MockSearchTVShowBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchTVShowBloc>.value(
      value: mockSearchTVShowBloc,
      child: MaterialApp(
          home: body,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case TVShowDetailPage.ROUTE_NAME:
                return MaterialPageRoute(
                  builder: (_) => TVShowDetailPage(id: 1),
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

  testWidgets('Page should can be tap item tv show',
      (WidgetTester tester) async {
    whenListen(
      mockSearchTVShowBloc,
      Stream.fromIterable([
        TVShowsHasDataState(testTVShowList),
      ]),
      initialState: TVShowsHasDataState(testTVShowList),
    );

    await tester.pumpWidget(_makeTestableWidget(SearchTVShowPage()));
    await tester.tap(find.byType(InkWell));
  });

  group('Show All States Search TV Show Page', () {
    testWidgets('Page should display loading', (WidgetTester tester) async {
      whenListen(
        mockSearchTVShowBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockSearchTVShowBloc.state, EmptyState());

      await expectLater(
        mockSearchTVShowBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockSearchTVShowBloc.state, LoadingState());

      final center = find.byKey(Key('center_loading'));
      final loading = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(SearchTVShowPage()));

      expect(center, findsOneWidget);
      expect(loading, findsOneWidget);
    });

    testWidgets('Page should display tv show not found',
        (WidgetTester tester) async {
      whenListen(
        mockSearchTVShowBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockSearchTVShowBloc.state, EmptyState());

      await expectLater(
        mockSearchTVShowBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
      );

      expect(mockSearchTVShowBloc.state, TVShowsHasDataState(<TVShow>[]));

      final center = find.byKey(Key('center_empty'));

      await tester.pumpWidget(_makeTestableWidget(SearchTVShowPage()));

      await tester.enterText(find.byType(TextField), '');

      expect(center, findsOneWidget);
    });

    testWidgets('Page should display searched tv shows',
        (WidgetTester tester) async {
      whenListen(
        mockSearchTVShowBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: EmptyState(),
      );

      expect(mockSearchTVShowBloc.state, EmptyState());

      await expectLater(
        mockSearchTVShowBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
      );

      expect(mockSearchTVShowBloc.state, TVShowsHasDataState(testTVShowList));

      await tester.pumpWidget(_makeTestableWidget(SearchTVShowPage()));
      await tester.enterText(find.byType(TextField), 'gotham');

      final expanded = find.byType(Expanded);

      expect(expanded, findsOneWidget);
    });

    testWidgets('Page should display error', (WidgetTester tester) async {
      whenListen(
        mockSearchTVShowBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockSearchTVShowBloc.state, EmptyState());

      await expectLater(
        mockSearchTVShowBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockSearchTVShowBloc.state, ErrorState('Error message'));

      final centerError = find.byKey(Key('center_error'));

      await tester.pumpWidget(_makeTestableWidget(SearchTVShowPage()));

      expect(centerError, findsOneWidget);
    });

    testWidgets('Page should display empty', (WidgetTester tester) async {
      whenListen(
        mockSearchTVShowBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockSearchTVShowBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockSearchTVShowBloc.state, EmptyState());

      final container = find.byType(Container);

      await tester.pumpWidget(_makeTestableWidget(SearchTVShowPage()));

      expect(container, findsOneWidget);
    });
  });
}
