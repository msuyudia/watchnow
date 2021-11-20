import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/domain/usecases/get_watchlist_tv_show_status.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListTVShowStatus usecase;
  late MockTVShowRepository mockTVShowRepository;

  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = GetWatchListTVShowStatus(mockTVShowRepository);
  });

  test('should get watchlist tv show status from repository', () async {
    // arrange
    when(mockTVShowRepository.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
