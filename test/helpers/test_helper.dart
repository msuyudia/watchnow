import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/data/datasources/db/database_helper.dart';
import 'package:watchnow/data/datasources/movie_local_data_source.dart';
import 'package:watchnow/data/datasources/movie_remote_data_source.dart';
import 'package:watchnow/data/datasources/tv_show_local_data_source.dart';
import 'package:watchnow/data/datasources/tv_show_remote_data_source.dart';
import 'package:watchnow/domain/repositories/movie_repository.dart';
import 'package:watchnow/domain/repositories/tv_show_repository.dart';

class FakeBlocEvent extends Fake implements BlocEvent {}

class FakeBlocState extends Fake implements BlocState {}

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  TVShowRepository,
  TVShowRemoteDataSource,
  TVShowLocalDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<IOClient>(as: #MockIOClient)
])
void main() {}
