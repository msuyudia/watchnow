import 'package:dartz/dartz.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/entities/movie_detail.dart';
import 'package:watchnow/domain/repositories/movie_repository.dart';

class RemoveWatchlistMovie {
  final MovieRepository repository;

  RemoveWatchlistMovie(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) =>
      repository.removeWatchlist(movie);
}
