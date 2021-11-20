import 'package:dartz/dartz.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/domain/repositories/tv_show_repository.dart';

class GetOnTheAirTVShows {
  final TVShowRepository repository;

  GetOnTheAirTVShows(this.repository);

  Future<Either<Failure, List<TVShow>>> execute() =>
      repository.getOnTheAirTVShows();
}
