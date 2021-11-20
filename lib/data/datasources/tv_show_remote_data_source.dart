import 'dart:convert';

import 'package:http/io_client.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/common/exception.dart';
import 'package:watchnow/data/models/episode_detail_model.dart';
import 'package:watchnow/data/models/season_detail_model.dart';
import 'package:watchnow/data/models/tv_show_detail_model.dart';
import 'package:watchnow/data/models/tv_show_model.dart';
import 'package:watchnow/data/models/tv_show_response.dart';

abstract class TVShowRemoteDataSource {
  Future<List<TVShowModel>> getOnTheAirTVShows();

  Future<List<TVShowModel>> getPopularTVShows();

  Future<List<TVShowModel>> getTopRatedTVShows();

  Future<TVShowDetailModel> getTVShowDetail(int id);

  Future<SeasonDetailModel> getSeasonDetail(int tvShowId, int seasonNumber);

  Future<EpisodeDetailModel> getEpisodeDetail(
      int tvShowId, int seasonNumber, episodeNumber);

  Future<List<TVShowModel>> getTVShowRecommendations(int id);

  Future<List<TVShowModel>> searchTVShows(String query);
}

class TVShowRemoteDataSourceImpl implements TVShowRemoteDataSource {
  final Future<IOClient> ioClient;

  TVShowRemoteDataSourceImpl({required this.ioClient});

  @override
  Future<List<TVShowModel>> getOnTheAirTVShows() async {
    final response =
        await ioClient.then((value) => value.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')));

    if (response.statusCode == 200) {
      return TVShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TVShowDetailModel> getTVShowDetail(int id) async {
    final response = await ioClient.then((value) => value.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY')));

    if (response.statusCode == 200) {
      return TVShowDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVShowModel>> getTVShowRecommendations(int id) async {
    final response = await ioClient
        .then((value) => value.get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY')));

    if (response.statusCode == 200) {
      return TVShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVShowModel>> getPopularTVShows() async {
    final response =
        await ioClient.then((value) => value.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')));

    if (response.statusCode == 200) {
      return TVShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVShowModel>> getTopRatedTVShows() async {
    final response =
        await ioClient.then((value) => value.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')));

    if (response.statusCode == 200) {
      return TVShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVShowModel>> searchTVShows(String query) async {
    final response = await ioClient
        .then((value) => value.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query')));

    if (response.statusCode == 200) {
      return TVShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SeasonDetailModel> getSeasonDetail(
    int tvShowId,
    int seasonNumber,
  ) async {
    final response = await ioClient
        .then((value) => value.get(Uri.parse('$BASE_URL/tv/$tvShowId/season/$seasonNumber?$API_KEY')));

    if (response.statusCode == 200) {
      return SeasonDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<EpisodeDetailModel> getEpisodeDetail(
      int tvShowId, int seasonNumber, episodeNumber) async {
    final response = await ioClient.then((value) => value.get(Uri.parse(
        '$BASE_URL/tv/$tvShowId/season/$seasonNumber/episode/$episodeNumber?$API_KEY')));

    if (response.statusCode == 200) {
      return EpisodeDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
