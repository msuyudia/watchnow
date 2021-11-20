import 'package:dartz/dartz.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/entities/movie.dart';
import 'package:watchnow/domain/repositories/movie_repository.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() =>
      repository.getNowPlayingMovies();
}
