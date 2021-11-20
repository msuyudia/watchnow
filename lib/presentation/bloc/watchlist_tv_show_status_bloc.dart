import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_watchlist_tv_show_status.dart';
import 'package:watchnow/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:watchnow/domain/usecases/save_watchlist_tv_show.dart';

class WatchlistTVShowStatusBloc extends Bloc<BlocEvent, BlocState> {
  final GetWatchListTVShowStatus _getWatchListTVShowStatus;
  final SaveWatchlistTVShow _saveWatchlistTVShow;
  final RemoveWatchlistTVShow _removeWatchlistTVShow;

  WatchlistTVShowStatusBloc(
    this._getWatchListTVShowStatus,
    this._saveWatchlistTVShow,
    this._removeWatchlistTVShow,
  ) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetWatchlistTVShowStatusEvent) {
      yield LoadingState();

      final result = await _getWatchListTVShowStatus.execute(event.id);

      yield InitWatchlistButtonState(result);
    }

    if (event is SaveWatchlistTVShowStatusEvent) {
      yield LoadingState();

      final result = await _saveWatchlistTVShow.execute(event.tvShowDetail);

      yield* result.fold(
        (failure) async* {
          yield WatchlistButtonState(failure.message, false);
        },
        (message) async* {
          yield WatchlistButtonState(message, true);
        },
      );
    }

    if (event is RemoveWatchlistTVShowStatusEvent) {
      yield LoadingState();

      final result = await _removeWatchlistTVShow.execute(event.tvShowDetail);

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
