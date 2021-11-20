import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_watchlist_movies.dart';

class GetWatchlistMoviesBloc extends Bloc<BlocEvent, BlocState> {
  final GetWatchlistMovies _getWatchlistMovies;

  GetWatchlistMoviesBloc(this._getWatchlistMovies) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetWatchlistMoviesEvent) {
      yield LoadingState();

      final result = await _getWatchlistMovies.execute();

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
