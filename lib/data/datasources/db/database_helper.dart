import 'dart:async';

import 'package:watchnow/data/models/movie_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watchnow/data/models/tv_show_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tableMovieWatchlist = 'movie_watchlist';
  static const String _tableTVShowWatchlist = 'tv_show_watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/watchnow.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tableMovieWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE  $_tableTVShowWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertMovieWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tableMovieWatchlist, movie.toJson());
  }

  Future<int> removeMovieWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tableMovieWatchlist,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> insertTVShowWatchlist(TVShowTable tvShow) async {
    final db = await database;
    return await db!.insert(_tableTVShowWatchlist, tvShow.toJson());
  }

  Future<int> removeTVShowWatchlist(TVShowTable tvShow) async {
    final db = await database;
    return await db!.delete(
      _tableTVShowWatchlist,
      where: 'id = ?',
      whereArgs: [tvShow.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tableMovieWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tableMovieWatchlist);

    return results;
  }

  Future<Map<String, dynamic>?> getTVShowById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tableTVShowWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTVShows() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tableTVShowWatchlist);

    return results;
  }
}
