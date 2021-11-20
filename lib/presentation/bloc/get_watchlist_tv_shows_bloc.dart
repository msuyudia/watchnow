import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_watchlist_tv_shows.dart';

class GetWatchlistTVShowsBloc extends Bloc<BlocEvent, BlocState> {
  final GetWatchlistTVShows _getWatchlistTVShows;

  GetWatchlistTVShowsBloc(this._getWatchlistTVShows) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetWatchlistTVShowsEvent) {
      yield LoadingState();

      final result = await _getWatchlistTVShows.execute();

      yield* result.fold(
        (failure) async* {
          yield ErrorState(failure.message);
        },
        (data) async* {
          yield TVShowsHasDataState(data);
        },
      );
    }
  }
}
