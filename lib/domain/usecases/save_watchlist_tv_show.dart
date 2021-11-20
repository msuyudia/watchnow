import 'package:dartz/dartz.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/entities/tv_show_detail.dart';
import 'package:watchnow/domain/repositories/tv_show_repository.dart';

class SaveWatchlistTVShow {
  final TVShowRepository repository;

  SaveWatchlistTVShow(this.repository);

  Future<Either<Failure, String>> execute(TVShowDetail tvShow) =>
      repository.saveWatchlist(tvShow);
}
