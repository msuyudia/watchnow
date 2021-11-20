import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_top_rated_tv_shows.dart';

class GetTopRatedTVShowsBloc extends Bloc<BlocEvent, BlocState> {
  final GetTopRatedTVShows _getTopRatedTVShows;

  GetTopRatedTVShowsBloc(this._getTopRatedTVShows) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetTopRatedTVShowsEvent) {
      yield LoadingState();

      final result = await _getTopRatedTVShows.execute();

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
