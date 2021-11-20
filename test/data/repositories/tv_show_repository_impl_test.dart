import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/exception.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/data/models/episode_detail_model.dart';
import 'package:watchnow/data/models/episode_model.dart';
import 'package:watchnow/data/models/genre_model.dart';
import 'package:watchnow/data/models/season_detail_model.dart';
import 'package:watchnow/data/models/season_model.dart';
import 'package:watchnow/data/models/tv_show_detail_model.dart';
import 'package:watchnow/data/models/tv_show_model.dart';
import 'package:watchnow/data/repositories/tv_show_repository_impl.dart';
import 'package:watchnow/domain/entities/tv_show.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVShowRepositoryImpl repository;
  late MockTVShowRemoteDataSource mockRemoteDataSource;
  late MockTVShowLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVShowRemoteDataSource();
    mockLocalDataSource = MockTVShowLocalDataSource();
    repository = TVShowRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTVShowModel = TVShowModel(
    id: 60708,
    name: "Gotham",
    overview:
        "Everyone knows the name Commissioner Gordon. He is one of the crime world's greatest foes, a man whose reputation is synonymous with law and order. But what is known of Gordon's story and his rise from rookie detective to Police Commissioner? What did it take to navigate the multiple layers of corruption that secretly ruled Gotham City, the spawning ground of the world's most iconic villains? And what circumstances created them – the larger-than-life personas who would become Catwoman, The Penguin, The Riddler, Two-Face and The Joker?",
    posterPath: '/4XddcRDtnNjYmLRMYpbrhFxsbuq.jpg',
  );

  final tTVShow = TVShow(
    id: 60708,
    name: "Gotham",
    overview:
        "Everyone knows the name Commissioner Gordon. He is one of the crime world's greatest foes, a man whose reputation is synonymous with law and order. But what is known of Gordon's story and his rise from rookie detective to Police Commissioner? What did it take to navigate the multiple layers of corruption that secretly ruled Gotham City, the spawning ground of the world's most iconic villains? And what circumstances created them – the larger-than-life personas who would become Catwoman, The Penguin, The Riddler, Two-Face and The Joker?",
    posterPath: '/4XddcRDtnNjYmLRMYpbrhFxsbuq.jpg',
  );

  final tTVShowModelList = <TVShowModel>[tTVShowModel];
  final tTVShowList = <TVShow>[tTVShow];

  group('On The Air TV Shows', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getOnTheAirTVShows())
          .thenAnswer((_) async => tTVShowModelList);
      // act
      final result = await repository.getOnTheAirTVShows();
      // assert
      verify(mockRemoteDataSource.getOnTheAirTVShows());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVShowList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getOnTheAirTVShows())
          .thenThrow(ServerException());
      // act
      final result = await repository.getOnTheAirTVShows();
      // assert
      verify(mockRemoteDataSource.getOnTheAirTVShows());
      expect(result,
          equals(Left(ServerFailure('Failed to connect to the server'))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getOnTheAirTVShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getOnTheAirTVShows();
      // assert
      verify(mockRemoteDataSource.getOnTheAirTVShows());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });

    test('should return connection failure when verify certificate is failed',
        () async {
      // arrange
      when(mockRemoteDataSource.getOnTheAirTVShows())
          .thenThrow(HandshakeException());
      // act
      final result = await repository.getOnTheAirTVShows();
      // assert
      verify(mockRemoteDataSource.getOnTheAirTVShows());
      expect(result,
          equals(Left(HandshakeFailure('Failed to verify certificate'))));
    });
  });

  group('Popular TV Shows', () {
    test('should return tv show list when call to data source is success',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTVShows())
          .thenAnswer((_) async => tTVShowModelList);
      // act
      final result = await repository.getPopularTVShows();
      // assert
      final resultList = result.getOrElse(() => []);
      verify(mockRemoteDataSource.getPopularTVShows());
      expect(resultList, tTVShowList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTVShows())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTVShows();
      // assert
      verify(mockRemoteDataSource.getPopularTVShows());
      expect(result, Left(ServerFailure('Failed to connect to the server')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTVShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTVShows();
      // assert
      verify(mockRemoteDataSource.getPopularTVShows());
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });

    test('should return connection failure when verify certificate is failed',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTVShows())
          .thenThrow(HandshakeException());
      // act
      final result = await repository.getPopularTVShows();
      // assert
      verify(mockRemoteDataSource.getPopularTVShows());
      expect(result,
          equals(Left(HandshakeFailure('Failed to verify certificate'))));
    });
  });

  group('Top Rated TV Shows', () {
    test('should return tv show list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTVShows())
          .thenAnswer((_) async => tTVShowModelList);
      // act
      final result = await repository.getTopRatedTVShows();
      // assert
      final resultList = result.getOrElse(() => []);
      verify(mockRemoteDataSource.getTopRatedTVShows());
      expect(resultList, tTVShowList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTVShows())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTVShows();
      // assert
      verify(mockRemoteDataSource.getTopRatedTVShows());
      expect(result, Left(ServerFailure('Failed to connect to the server')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTVShows())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTVShows();
      // assert
      verify(mockRemoteDataSource.getTopRatedTVShows());
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });

    test('should return connection failure when verify certificate is failed',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTVShows())
          .thenThrow(HandshakeException());
      // act
      final result = await repository.getTopRatedTVShows();
      // assert
      verify(mockRemoteDataSource.getTopRatedTVShows());
      expect(result,
          equals(Left(HandshakeFailure('Failed to verify certificate'))));
    });
  });

  group('Get TV Show Detail', () {
    final tId = 1;
    final tTVShowResponse = TVShowDetailModel(
      id: 1,
      posterPath: 'posterPath',
      name: "name",
      genres: [
        GenreModel(id: 18, name: 'Drama'),
        GenreModel(id: 80, name: 'Crime'),
        GenreModel(id: 10765, name: 'Sci-Fi & Fantasy'),
      ],
      voteAverage: 7.6,
      overview: 'overview',
      seasons: [
        SeasonModel(
          posterPath: '/ggEVcCvtCcfSgYIeVubCBJXse7X.jpg',
          name: 'Season 1',
          seasonNumber: 1,
        ),
        SeasonModel(
          posterPath: '/a47zOXSfa6clj9Vb5Xv2sZg7W3R.jpg',
          name: 'Season 2',
          seasonNumber: 2,
        ),
        SeasonModel(
          posterPath: '/rUCkSHEBOMg4JECWZN2fjsVIOrm.jpg',
          name: 'Season 3',
          seasonNumber: 3,
        ),
        SeasonModel(
          posterPath: '/6lyumyfM0lx8AApPEqgEKv5lnUy.jpg',
          name: 'Season 4',
          seasonNumber: 4,
        ),
        SeasonModel(
          posterPath: '/4XddcRDtnNjYmLRMYpbrhFxsbuq.jpg',
          name: 'Season 5',
          seasonNumber: 5,
        ),
      ],
    );

    test(
        'should return TV Show data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVShowDetail(tId))
          .thenAnswer((_) async => tTVShowResponse);
      // act
      final result = await repository.getTVShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTVShowDetail(tId));
      expect(result, equals(Right(testTVShowDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVShowDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTVShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTVShowDetail(tId));
      expect(result,
          equals(Left(ServerFailure('Failed to connect to the server'))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVShowDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTVShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTVShowDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });

    test('should return connection failure when verify certificate is failed',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVShowDetail(tId))
          .thenThrow(HandshakeException());
      // act
      final result = await repository.getTVShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTVShowDetail(tId));
      expect(result,
          equals(Left(HandshakeFailure('Failed to verify certificate'))));
    });
  });

  group('Get Season Detail', () {
    final tId = 1;
    final tSeasonNumber = 1;
    final tSeasonResponse = SeasonDetailModel(
      posterPath: '/ggEVcCvtCcfSgYIeVubCBJXse7X.jpg',
      name: 'Season 1',
      overview:
          "A new recruit in Captain Sarah Essen's Gotham City Police Department, Detective James Gordon is paired with Harvey Bullock to solve one of Gotham's highest-profile cases: the murder of Thomas and Martha Wayne. During his investigation, Gordon meets the Waynes' son Bruce, now in the care of his butler Alfred Pennyworth, which further compels Gordon to catch the mysterious killer. Along the way, Gordon must confront mobstress Fish Mooney, mafia led by Carmine Falcone, as well as many of Gotham's future villains such as Selina Kyle, Edward Nygma, and Oswald Cobblepot. Eventually, Gordon is forced to form an unlikely friendship with Wayne, one that will help shape the boy's future in his destiny of becoming a crusader.",
      episodes: [
        EpisodeModel(
          stillPath: '/yQKuW0jqdVy5ENGlvcKsB82IWwY.jpg',
          name: 'Pilot',
          voteAverage: 7.235,
          episodeNumber: 1,
        ),
        EpisodeModel(
          stillPath: '/aNr0SSWvVYOsZWfkgB8XGKjzlJv.jpg',
          name: 'Pilot',
          voteAverage: 7.235,
          episodeNumber: 2,
        ),
        EpisodeModel(
          stillPath: '/dXMWKaQlIcFibGMUGIzPj7Io7hn.jpg',
          name: 'Pilot',
          voteAverage: 7.235,
          episodeNumber: 3,
        ),
        EpisodeModel(
          stillPath: '/gL4HWIoQKG5kRQCC1YOrW4fCJbn.jpg',
          name: 'Pilot',
          voteAverage: 7.235,
          episodeNumber: 4,
        ),
        EpisodeModel(
          stillPath: '/4a77nHzrTD57leSW549e08RBLpi.jpg',
          name: 'Pilot',
          voteAverage: 7.235,
          episodeNumber: 5,
        ),
      ],
      seasonNumber: 1,
    );

    test(
        'should return Season data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber))
          .thenAnswer((_) async => tSeasonResponse);
      // act
      final result = await repository.getSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber));
      expect(result, equals(Right(testSeasonDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber))
          .thenThrow(ServerException());
      // act
      final result = await repository.getSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber));
      expect(result,
          equals(Left(ServerFailure('Failed to connect to the server'))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });

    test('should return connection failure when verify certificate is failed',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber))
          .thenThrow(HandshakeException());
      // act
      final result = await repository.getSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber));
      expect(result,
          equals(Left(HandshakeFailure('Failed to verify certificate'))));
    });
  });

  group('Get Episode Detail', () {
    final tId = 1;
    final tSeasonNumber = 1;
    final tEpisodeNumber = 1;
    final tEpisodeResponse = EpisodeDetailModel(
      id: 975968,
      stillPath: '/yQKuW0jqdVy5ENGlvcKsB82IWwY.jpg',
      name: 'Pilot',
      voteAverage: 7.235,
      overview:
          'Detective James Gordon performs his work in the dangerously corrupt city of Gotham, which consistently teeters between good and evil.',
    );

    test(
        'should return Season data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getEpisodeDetail(
              tId, tSeasonNumber, tEpisodeNumber))
          .thenAnswer((_) async => tEpisodeResponse);
      // act
      final result =
          await repository.getEpisodeDetail(tId, tSeasonNumber, tEpisodeNumber);
      // assert
      verify(mockRemoteDataSource.getEpisodeDetail(
          tId, tSeasonNumber, tEpisodeNumber));
      expect(result, equals(Right(testEpisodeDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getEpisodeDetail(
              tId, tSeasonNumber, tEpisodeNumber))
          .thenThrow(ServerException());
      // act
      final result =
          await repository.getEpisodeDetail(tId, tSeasonNumber, tEpisodeNumber);
      // assert
      verify(mockRemoteDataSource.getEpisodeDetail(
          tId, tSeasonNumber, tEpisodeNumber));
      expect(result,
          equals(Left(ServerFailure('Failed to connect to the server'))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getEpisodeDetail(
              tId, tSeasonNumber, tEpisodeNumber))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result =
          await repository.getEpisodeDetail(tId, tSeasonNumber, tEpisodeNumber);
      // assert
      verify(mockRemoteDataSource.getEpisodeDetail(
          tId, tSeasonNumber, tEpisodeNumber));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });

    test('should return connection failure when verify certificate is failed',
        () async {
      // arrange
      when(mockRemoteDataSource.getEpisodeDetail(
              tId, tSeasonNumber, tEpisodeNumber))
          .thenThrow(HandshakeException());
      // act
      final result = await repository.getEpisodeDetail(
          tId, tSeasonNumber, tEpisodeNumber); // assert
      verify(mockRemoteDataSource.getEpisodeDetail(
          tId, tSeasonNumber, tEpisodeNumber));
      expect(result,
          equals(Left(HandshakeFailure('Failed to verify certificate'))));
    });
  });

  group('Get TV Show Recommendations', () {
    final tTVShowList = <TVShowModel>[];
    final tId = 1;

    test('should return data (tv show list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVShowRecommendations(tId))
          .thenAnswer((_) async => tTVShowList);
      // act
      final result = await repository.getTVShowRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVShowRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTVShowList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVShowRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTVShowRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVShowRecommendations(tId));
      expect(result,
          equals(Left(ServerFailure('Failed to connect to the server'))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVShowRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTVShowRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVShowRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });

    test('should return connection failure when verify certificate is failed',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVShowRecommendations(tId))
          .thenThrow(HandshakeException());
      // act
      final result = await repository.getTVShowRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVShowRecommendations(tId));
      expect(result,
          equals(Left(HandshakeFailure('Failed to verify certificate'))));
    });
  });

  group('Seach TV Shows', () {
    final tQuery = 'gotham';

    test('should return tv show list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTVShows(tQuery))
          .thenAnswer((_) async => tTVShowModelList);
      // act
      final result = await repository.searchTVShows(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      verify(repository.searchTVShows(tQuery));
      expect(resultList, tTVShowList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTVShows(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTVShows(tQuery);
      // assert
      verify(repository.searchTVShows(tQuery));
      expect(result, Left(ServerFailure('Failed to connect to the server')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTVShows(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTVShows(tQuery);
      // assert
      verify(repository.searchTVShows(tQuery));
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });

    test('should return connection failure when verify certificate is failed',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTVShows(tQuery))
          .thenThrow(HandshakeException());
      // act
      final result = await repository.searchTVShows(tQuery);
      // assert
      verify(repository.searchTVShows(tQuery));
      expect(result,
          equals(Left(HandshakeFailure('Failed to verify certificate'))));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTVShowTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTVShowDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTVShowTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTVShowDetail);
      // assert
      verify(repository.saveWatchlist(testTVShowDetail));
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTVShowTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testTVShowDetail);
      // assert
      verify(repository.removeWatchlist(testTVShowDetail));
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTVShowTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTVShowDetail);
      // assert
      verify(repository.removeWatchlist(testTVShowDetail));
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTVShowById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      verify(repository.isAddedToWatchlist(tId));
      expect(result, false);
    });
  });

  group('get watchlist tv shows', () {
    test('should return list of TV Shows', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTVShows())
          .thenAnswer((_) async => [testTVShowTable]);
      // act
      final result = await repository.getWatchlistTVShows();
      // assert
      final resultList = result.getOrElse(() => []);
      verify(repository.getWatchlistTVShows());
      expect(resultList, [testTVShowWatchlist]);
    });
  });
}
