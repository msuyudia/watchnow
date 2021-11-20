import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_top_rated_movies.dart';

class GetTopRatedMoviesBloc extends Bloc<BlocEvent, BlocState> {
  final GetTopRatedMovies _getTopRatedMovies;

  GetTopRatedMoviesBloc(this._getTopRatedMovies) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetTopRatedMoviesEvent) {
      yield LoadingState();
      final result = await _getTopRatedMovies.execute();

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
