import 'package:dartz/dartz.dart';
import 'package:watchnow/domain/entities/movie.dart';
import 'package:watchnow/domain/repositories/movie_repository.dart';
import 'package:watchnow/common/failure.dart';

class GetWatchlistMovies {
  final MovieRepository repository;

  GetWatchlistMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() => repository.getWatchlistMovies();
}
