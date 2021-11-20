import 'package:dartz/dartz.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/entities/tv_show_detail.dart';
import 'package:watchnow/domain/repositories/tv_show_repository.dart';

class RemoveWatchlistTVShow {
  final TVShowRepository repository;

  RemoveWatchlistTVShow(this.repository);

  Future<Either<Failure, String>> execute(TVShowDetail tvShow) =>
      repository.removeWatchlist(tvShow);
}
