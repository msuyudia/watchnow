import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/usecases/get_movie_detail.dart';

class GetMovieDetailBloc extends Bloc<BlocEvent, BlocState> {
  final GetMovieDetail _getMovieDetail;

  GetMovieDetailBloc(this._getMovieDetail) : super(EmptyState());

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetMovieDetailEvent) {
      yield LoadingState();
      final result = await _getMovieDetail.execute(event.id);

      yield* result.fold(
        (failure) async* {
          yield ErrorState(failure.message);
        },
        (data) async* {
          yield MovieDetailHasDataState(data);
        },
      );
    }
  }
}
