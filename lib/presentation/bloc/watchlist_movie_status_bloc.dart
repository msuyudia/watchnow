import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_watchlist_movie_status.dart';
import 'package:watchnow/domain/usecases/remove_watchlist_movie.dart';
import 'package:watchnow/domain/usecases/save_watchlist_movie.dart';

class WatchlistMovieStatusBloc extends Bloc<BlocEvent, BlocState> {
  final GetWatchListMovieStatus _getWatchlistMovieStatus;
  final SaveWatchlistMovie _saveWatchlistMovie;
  final RemoveWatchlistMovie _removeWatchlistMovie;

  WatchlistMovieStatusBloc(
    this._getWatchlistMovieStatus,
    this._saveWatchlistMovie,
    this._removeWatchlistMovie,
  ) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetWatchlistMovieStatusEvent) {
      yield LoadingState();

      final result = await _getWatchlistMovieStatus.execute(event.id);

      yield InitWatchlistButtonState(result);
    }

    if (event is SaveWatchlistMovieStatusEvent) {
      yield LoadingState();

      final result = await _saveWatchlistMovie.execute(event.movieDetail);

      yield* result.fold(
        (failure) async* {
          yield WatchlistButtonState(failure.message, false);
        },
        (message) async* {
          yield WatchlistButtonState(message, true);
        },
      );
    }

    if (event is RemoveWatchlistMovieStatusEvent) {
      yield LoadingState();

      final result = await _removeWatchlistMovie.execute(event.movieDetail);

      yield* result.fold(
        (failure) async* {
          yield WatchlistButtonState(failure.message, true);
        },
        (message) async* {
          yield WatchlistButtonState(message, false);
        },
      );
    }
  }
}
