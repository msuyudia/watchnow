import 'package:dartz/dartz.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/domain/repositories/tv_show_repository.dart';

class GetPopularTVShows {
  final TVShowRepository repository;

  GetPopularTVShows(this.repository);

  Future<Either<Failure, List<TVShow>>> execute() =>
      repository.getPopularTVShows();
}
