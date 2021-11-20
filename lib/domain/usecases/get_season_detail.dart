import 'package:dartz/dartz.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/entities/season_detail.dart';
import 'package:watchnow/domain/repositories/tv_show_repository.dart';

class GetSeasonDetail {
  final TVShowRepository repository;

  GetSeasonDetail(this.repository);

  Future<Either<Failure, SeasonDetail>> execute(int id, int seasonNumber) =>
      repository.getSeasonDetail(id, seasonNumber);
}
