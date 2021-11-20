import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:watchnow/common/exception.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/data/datasources/tv_show_local_data_source.dart';
import 'package:watchnow/data/datasources/tv_show_remote_data_source.dart';
import 'package:watchnow/data/models/tv_show_table.dart';
import 'package:watchnow/domain/entities/episode_detail.dart';
import 'package:watchnow/domain/entities/season_detail.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/domain/entities/tv_show_detail.dart';
import 'package:watchnow/domain/repositories/tv_show_repository.dart';

class TVShowRepositoryImpl implements TVShowRepository {
  final TVShowRemoteDataSource remoteDataSource;
  final TVShowLocalDataSource localDataSource;

  TVShowRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TVShow>>> getOnTheAirTVShows() async {
    try {
      final result = await remoteDataSource.getOnTheAirTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on HandshakeException {
      return Left(HandshakeFailure('Failed to verify certificate'));
    }
  }

  @override
  Future<Either<Failure, List<TVShow>>> getPopularTVShows() async {
    try {
      final result = await remoteDataSource.getPopularTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on HandshakeException {
      return Left(HandshakeFailure('Failed to verify certificate'));
    }
  }

  @override
  Future<Either<Failure, List<TVShow>>> getTopRatedTVShows() async {
    try {
      final result = await remoteDataSource.getTopRatedTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on HandshakeException {
      return Left(HandshakeFailure('Failed to verify certificate'));
    }
  }

  @override
  Future<Either<Failure, TVShowDetail>> getTVShowDetail(int id) async {
    try {
      final result = await remoteDataSource.getTVShowDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on HandshakeException {
      return Left(HandshakeFailure('Failed to verify certificate'));
    }
  }

  @override
  Future<Either<Failure, SeasonDetail>> getSeasonDetail(
      int id, int seasonNumber) async {
    try {
      final result = await remoteDataSource.getSeasonDetail(id, seasonNumber);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on HandshakeException {
      return Left(HandshakeFailure('Failed to verify certificate'));
    }
  }

  @override
  Future<Either<Failure, EpisodeDetail>> getEpisodeDetail(
      int id, int seasonNumber, int episodeNumber) async {
    try {
      final result = await remoteDataSource.getEpisodeDetail(
          id, seasonNumber, episodeNumber);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on HandshakeException {
      return Left(HandshakeFailure('Failed to verify certificate'));
    }
  }

  @override
  Future<Either<Failure, List<TVShow>>> getTVShowRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getTVShowRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on HandshakeException {
      return Left(HandshakeFailure('Failed to verify certificate'));
    }
  }

  @override
  Future<Either<Failure, List<TVShow>>> searchTVShows(String query) async {
    try {
      final result = await remoteDataSource.searchTVShows(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on HandshakeException {
      return Left(HandshakeFailure('Failed to verify certificate'));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(
      TVShowDetail tvShowDetail) async {
    try {
      final result = await localDataSource
          .insertWatchlist(TVShowTable.fromEntity(tvShowDetail));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(
      TVShowDetail tvShowDetail) async {
    try {
      final result = await localDataSource
          .removeWatchlist(TVShowTable.fromEntity(tvShowDetail));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getTVShowById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<TVShow>>> getWatchlistTVShows() async {
    final result = await localDataSource.getWatchlistTVShows();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}
