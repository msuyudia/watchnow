import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_popular_movies.dart';

class GetPopularMoviesBloc extends Bloc<BlocEvent, BlocState> {
  final GetPopularMovies _getPopularMovies;

  GetPopularMoviesBloc(this._getPopularMovies) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetPopularMoviesEvent) {
      yield LoadingState();
      final result = await _getPopularMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield ErrorState(failure.message);
        },
        (data) async* {
          yield MoviesHasDataState(data);
        },
      );
    }
  }
}
