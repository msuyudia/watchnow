import 'package:watchnow/domain/repositories/tv_show_repository.dart';

class GetWatchListTVShowStatus {
  final TVShowRepository repository;

  GetWatchListTVShowStatus(this.repository);

  Future<bool> execute(int id) async => repository.isAddedToWatchlist(id);
}
