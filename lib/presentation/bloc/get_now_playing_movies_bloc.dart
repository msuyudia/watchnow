import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_now_playing_movies.dart';

class GetNowPlayingMoviesBloc extends Bloc<BlocEvent, BlocState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  GetNowPlayingMoviesBloc(this._getNowPlayingMovies) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetNowPlayingMoviesEvent) {
      yield LoadingState();
      final result = await _getNowPlayingMovies.execute();

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
