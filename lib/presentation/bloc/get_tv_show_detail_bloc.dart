import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_tv_show_detail.dart';

class GetTVShowDetailBloc extends Bloc<BlocEvent, BlocState> {
  final GetTVShowDetail _getTVShowDetail;

  GetTVShowDetailBloc(this._getTVShowDetail) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetTVShowDetailEvent) {
      yield LoadingState();
      final result = await _getTVShowDetail.execute(event.id);

      yield* result.fold(
        (failure) async* {
          yield ErrorState(failure.message);
        },
        (data) async* {
          yield TVShowDetailHasDataState(data);
        },
      );
    }
  }
}
