import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/search_movies.dart';

class SearchMovieBloc extends Bloc<BlocEvent, BlocState> {
  final SearchMovies _searchMovies;

  SearchMovieBloc(this._searchMovies) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is SearchMovieEvent) {
      yield LoadingState();

      final result = await _searchMovies.execute(event.query);

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
