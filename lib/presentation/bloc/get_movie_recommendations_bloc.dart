import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_movie_recommendations.dart';

class GetMovieRecommendationsBloc extends Bloc<BlocEvent, BlocState> {
  final GetMovieRecommendations _getMovieRecommendations;

  GetMovieRecommendationsBloc(this._getMovieRecommendations)
      : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetMovieRecommendationsEvent) {
      yield LoadingState();

      final result = await _getMovieRecommendations.execute(event.id);

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
