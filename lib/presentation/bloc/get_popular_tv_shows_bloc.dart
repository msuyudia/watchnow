import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_popular_tv_shows.dart';

class GetPopularTVShowsBloc extends Bloc<BlocEvent, BlocState> {
  final GetPopularTVShows _getPopularTVShows;

  GetPopularTVShowsBloc(this._getPopularTVShows) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetPopularTVShowsEvent) {
      yield LoadingState();
      final result = await _getPopularTVShows.execute();

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
