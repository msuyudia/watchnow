import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_episode_detail.dart';

class GetEpisodeDetailBloc extends Bloc<BlocEvent, BlocState> {
  final GetEpisodeDetail _getEpisodeDetail;

  GetEpisodeDetailBloc(this._getEpisodeDetail) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetEpisodeDetailEvent) {
      yield LoadingState();
      final result = await _getEpisodeDetail.execute(
        event.id,
        event.seasonNumber,
        event.episodeNumber,
      );

      yield* result.fold(
        (failure) async* {
          yield ErrorState(failure.message);
        },
        (data) async* {
          yield EpisodeDetailHasDataState(data);
        },
      );
    }
  }
}
