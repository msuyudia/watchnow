import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:watchnow/data/models/tv_show_model.dart';
import 'package:watchnow/data/models/tv_show_response.dart';

import '../../json_reader.dart';

void main() {
  final tTVShowModel = TVShowModel(
    id: 1,
    name: 'Name',
    overview: 'Overview',
    posterPath: '/path.jpg',
  );

  final tTVShowResponseModel =
      TVShowResponse(tvShowList: <TVShowModel>[tTVShowModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/on_the_air_tv_shows.json'));
      // act
      final result = TVShowResponse.fromJson(jsonMap);
      // assert
      expect(result, tTVShowResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTVShowResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            'id': 1,
            'name': 'Name',
            'overview': 'Overview',
            'poster_path': '/path.jpg',
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
