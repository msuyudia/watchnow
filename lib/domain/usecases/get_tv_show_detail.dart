import 'package:dartz/dartz.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/entities/tv_show_detail.dart';
import 'package:watchnow/domain/repositories/tv_show_repository.dart';

class GetTVShowDetail {
  final TVShowRepository repository;

  GetTVShowDetail(this.repository);

  Future<Either<Failure, TVShowDetail>> execute(int id) =>
      repository.getTVShowDetail(id);
}
