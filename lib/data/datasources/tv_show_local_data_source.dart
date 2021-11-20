import 'package:watchnow/common/exception.dart';
import 'package:watchnow/data/datasources/db/database_helper.dart';
import 'package:watchnow/data/models/tv_show_table.dart';

abstract class TVShowLocalDataSource {
  Future<String> insertWatchlist(TVShowTable movie);

  Future<String> removeWatchlist(TVShowTable movie);

  Future<TVShowTable?> getTVShowById(int id);

  Future<List<TVShowTable>> getWatchlistTVShows();
}

class TVShowLocalDataSourceImpl implements TVShowLocalDataSource {
  final DatabaseHelper databaseHelper;

  TVShowLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TVShowTable tvShow) async {
    try {
      await databaseHelper.insertTVShowWatchlist(tvShow);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TVShowTable movie) async {
    try {
      await databaseHelper.removeTVShowWatchlist(movie);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVShowTable?> getTVShowById(int id) async {
    final result = await databaseHelper.getTVShowById(id);
    if (result != null) {
      return TVShowTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVShowTable>> getWatchlistTVShows() async {
    final result = await databaseHelper.getWatchlistTVShows();
    return result.map((data) => TVShowTable.fromMap(data)).toList();
  }
}
