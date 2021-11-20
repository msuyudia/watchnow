import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/common/exception.dart';
import 'package:watchnow/data/datasources/tv_show_remote_data_source.dart';
import 'package:watchnow/data/models/episode_detail_model.dart';
import 'package:watchnow/data/models/season_detail_model.dart';
import 'package:watchnow/data/models/tv_show_detail_model.dart';
import 'package:watchnow/data/models/tv_show_response.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TVShowRemoteDataSourceImpl dataSource;
  late Future<MockIOClient> mockIOClient;

  setUp(() {
    mockIOClient = Future.value(MockIOClient());
    dataSource = TVShowRemoteDataSourceImpl(ioClient: mockIOClient);
  });

  group('get On The Air TV Show', () {
    final tTVShowList = TVShowResponse.fromJson(
            json.decode(readJson('dummy_data/on_the_air_tv_shows.json')))
        .tvShowList;

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      await mockIOClient.then((value) =>
          when(value.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
              .thenAnswer((_) async => http.Response(
                    readJson('dummy_data/on_the_air_tv_shows.json'),
                    200,
                    headers: {
                      HttpHeaders.contentTypeHeader:
                          'application/json; charset=utf-8',
                    },
                  )));
      // act
      final result = await dataSource.getOnTheAirTVShows();
      // assert
      await expectLater(result, equals(tTVShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      try {
        // arrange
        await mockIOClient.then((value) =>
            when(value.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
                .thenAnswer((_) async => http.Response('Not Found', 404)));
        // act
        await dataSource.getOnTheAirTVShows();
      } catch (e) {
        // call
        expect(e, isInstanceOf<ServerException>());
      }
    });
  });

  group('get Popular TV Shows', () {
    final tTVShowList = TVShowResponse.fromJson(
            json.decode(readJson('dummy_data/popular_tv_shows.json')))
        .tvShowList;

    test('should return list of tv shows when response is success (200)',
        () async {
      // arrange
      await mockIOClient.then((value) =>
          when(value.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async => http.Response(
                    readJson('dummy_data/popular_tv_shows.json'),
                    200,
                    headers: {
                      HttpHeaders.contentTypeHeader:
                          'application/json; charset=utf-8',
                    },
                  )));
      // act
      final result = await dataSource.getPopularTVShows();
      // assert
      await expectLater(result, equals(tTVShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      try {
        // arrange
        await mockIOClient.then((value) =>
            when(value.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
                .thenAnswer((_) async => http.Response('Not Found', 404)));
        // act
        await dataSource.getPopularTVShows();
      } catch (e) {
        // assert
        expect(e, isInstanceOf<ServerException>());
      }
    });
  });

  group('get Top Rated TV Shows', () {
    final tTVShowList = TVShowResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated_tv_shows.json')))
        .tvShowList;

    test('should return list of tv shows when response is success (200)',
        () async {
      // arrange
      await mockIOClient.then((value) =>
          when(value.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
              .thenAnswer((_) async => http.Response(
                    readJson('dummy_data/top_rated_tv_shows.json'),
                    200,
                    headers: {
                      HttpHeaders.contentTypeHeader:
                          'application/json; charset=utf-8',
                    },
                  )));
      // act
      final result = await dataSource.getTopRatedTVShows();
      // assert
      await expectLater(result, equals(tTVShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      try {
        // arrange
        await mockIOClient.then((value) =>
            when(value.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
                .thenAnswer((_) async => http.Response('Not Found', 404)));
        // act
        await dataSource.getTopRatedTVShows();
      } catch (e) {
        // assert
        expect(e, isInstanceOf<ServerException>());
      }
    });
  });

  group('get tv show detail', () {
    final tId = 1;
    final tTVShowDetail = TVShowDetailModel.fromJson(
        json.decode(readJson('dummy_data/tv_show_detail.json')));

    test('should return list of tv show detail when response is success (200)',
        () async {
      // arrange
      await mockIOClient.then((value) =>
          when(value.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
              .thenAnswer((_) async => http.Response(
                    readJson('dummy_data/tv_show_detail.json'),
                    200,
                    headers: {
                      HttpHeaders.contentTypeHeader:
                          'application/json; charset=utf-8',
                    },
                  )));
      // act
      final result = await dataSource.getTVShowDetail(tId);
      // assert
      await expectLater(result, equals(tTVShowDetail));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      try {
        // arrange
        await mockIOClient.then((value) =>
            when(value.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
                .thenAnswer((_) async => http.Response('Not Found', 404)));
        // act
        await dataSource.getTVShowDetail(tId);
      } catch (e) {
        // assert
        expect(e, isInstanceOf<ServerException>());
      }
    });
  });

  group('get season detail', () {
    final tId = 1;
    final tSeasonNumber = 1;
    final tSeasonDetail = SeasonDetailModel.fromJson(
        json.decode(readJson('dummy_data/season_detail.json')));

    test('should return list of tv show detail when response is success (200)',
        () async {
      // arrange
      await mockIOClient.then((value) => when(value.get(
              Uri.parse('$BASE_URL/tv/$tId/season/$tSeasonNumber?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                readJson('dummy_data/season_detail.json'),
                200,
                headers: {
                  HttpHeaders.contentTypeHeader:
                      'application/json; charset=utf-8',
                },
              )));
      // act
      final result = await dataSource.getSeasonDetail(tId, tSeasonNumber);
      // assert
      await expectLater(result, equals(tSeasonDetail));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      try {
        // arrange
        await mockIOClient.then((value) => when(value.get(
                Uri.parse('$BASE_URL/tv/$tId/season/$tSeasonNumber?$API_KEY')))
            .thenAnswer((_) async => http.Response('Not Found', 404)));
        // act
        await dataSource.getSeasonDetail(tId, tSeasonNumber);
      } catch (e) {
        // assert
        expect(e, isInstanceOf<ServerException>());
      }
    });
  });

  group('get episode detail', () {
    final tId = 1;
    final tSeasonNumber = 1;
    final tEpisodeNumber = 1;
    final tEpisodeDetail = EpisodeDetailModel.fromJson(
        json.decode(readJson('dummy_data/episode_detail.json')));

    test('should return list of tv show detail when response is success (200)',
        () async {
      // arrange
      await mockIOClient.then((value) => when(value.get(Uri.parse(
              '$BASE_URL/tv/$tId/season/$tSeasonNumber/episode/$tEpisodeNumber?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                readJson('dummy_data/episode_detail.json'),
                200,
                headers: {
                  HttpHeaders.contentTypeHeader:
                      'application/json; charset=utf-8',
                },
              )));
      // act
      final result =
          await dataSource.getEpisodeDetail(tId, tSeasonNumber, tEpisodeNumber);
      // assert
      await expectLater(result, equals(tEpisodeDetail));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      try {
        // arrange
        await mockIOClient.then((value) => when(value.get(Uri.parse(
                '$BASE_URL/tv/$tId/season/$tSeasonNumber/episode/$tEpisodeNumber?$API_KEY')))
            .thenAnswer((_) async => http.Response('Not Found', 404)));
        // act
        await dataSource.getEpisodeDetail(tId, tSeasonNumber, tEpisodeNumber);
      } catch (e) {
        // assert
        expect(e, isInstanceOf<ServerException>());
      }
    });
  });

  group('get tv show recommendations', () {
    final tTVShowList = TVShowResponse.fromJson(
            json.decode(readJson('dummy_data/tv_show_recommendations.json')))
        .tvShowList;
    final tId = 1;

    test('should return list of tv shows when response is success (200)',
        () async {
      // arrange
      await mockIOClient.then((value) => when(value
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                readJson('dummy_data/tv_show_recommendations.json'),
                200,
                headers: {
                  HttpHeaders.contentTypeHeader:
                      'application/json; charset=utf-8',
                },
              )));
      // act
      final result = await dataSource.getTVShowRecommendations(tId);
      // assert
      await expectLater(result, equals(tTVShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      try {
        // arrange
        await mockIOClient.then((value) => when(value
                .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
            .thenAnswer((_) async => http.Response('Not Found', 404)));
        // act
        await dataSource.getTVShowRecommendations(tId);
      } catch (e) {
        // assert
        expect(e, isInstanceOf<ServerException>());
      }
    });
  });

  group('search tv shows', () {
    final tSearchResult = TVShowResponse.fromJson(
            json.decode(readJson('dummy_data/search_gotham_tv_show.json')))
        .tvShowList;
    final tQuery = 'Gotham';

    test('should return list of tv shows when response is success (200)',
        () async {
      // arrange
      await mockIOClient.then((value) => when(value
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
                readJson('dummy_data/search_gotham_tv_show.json'),
                200,
                headers: {
                  HttpHeaders.contentTypeHeader:
                      'application/json; charset=utf-8',
                },
              )));
      // act
      final result = await dataSource.searchTVShows(tQuery);
      // assert
      await expectLater(result, equals(tSearchResult));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      try {
        // arrange
        await mockIOClient.then((value) => when(value
                .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
            .thenAnswer((_) async => http.Response('Not Found', 404)));
        // act
        await dataSource.searchTVShows(tQuery);
      } catch (e) {
        // assert
        expect(e, isInstanceOf<ServerException>());
      }
    });
  });
}
