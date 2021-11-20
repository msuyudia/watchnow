import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/search_tv_shows.dart';

class SearchTVShowBloc extends Bloc<BlocEvent, BlocState> {
  final SearchTVShows _searchTVShows;

  SearchTVShowBloc(this._searchTVShows) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is SearchTVShowEvent) {
      yield LoadingState();

      final result = await _searchTVShows.execute(event.query);

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
