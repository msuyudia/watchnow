import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_on_the_air_tv_shows.dart';

class GetOnTheAirTVShowsBloc extends Bloc<BlocEvent, BlocState> {
  final GetOnTheAirTVShows _getOnTheAirTVShows;

  GetOnTheAirTVShowsBloc(this._getOnTheAirTVShows) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetOnTheAirTVShowsEvent) {
      yield LoadingState();
      final result = await _getOnTheAirTVShows.execute();

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
