import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_season_detail.dart';

class GetSeasonDetailBloc extends Bloc<BlocEvent, BlocState> {
  final GetSeasonDetail _getSeasonDetail;

  GetSeasonDetailBloc(this._getSeasonDetail) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetSeasonDetailEvent) {
      yield LoadingState();
      final result = await _getSeasonDetail.execute(
        event.id,
        event.seasonNumber,
      );

      yield* result.fold(
        (failure) async* {
          yield ErrorState(failure.message);
        },
        (data) async* {
          yield SeasonDetailHasDataState(data);
        },
      );
    }
  }
}
