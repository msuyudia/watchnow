import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_tv_show_recommendations.dart';

class GetTVShowRecommendationsBloc extends Bloc<BlocEvent, BlocState> {
  final GetTVShowRecommendations _getTVShowRecommendations;

  GetTVShowRecommendationsBloc(this._getTVShowRecommendations)
      : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetTVShowRecommendationsEvent) {
      yield LoadingState();

      final result = await _getTVShowRecommendations.execute(event.id);

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
