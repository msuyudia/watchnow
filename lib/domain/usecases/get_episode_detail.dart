import 'package:dartz/dartz.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/entities/episode_detail.dart';
import 'package:watchnow/domain/repositories/tv_show_repository.dart';

class GetEpisodeDetail {
  final TVShowRepository repository;

  GetEpisodeDetail(this.repository);

  Future<Either<Failure, EpisodeDetail>> execute(
          int id, int seasonNumber, int episodeNumber) =>
      repository.getEpisodeDetail(id, seasonNumber, episodeNumber);
}
