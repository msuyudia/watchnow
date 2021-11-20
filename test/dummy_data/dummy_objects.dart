import 'package:watchnow/data/models/movie_table.dart';
import 'package:watchnow/data/models/tv_show_table.dart';
import 'package:watchnow/domain/entities/episode.dart';
import 'package:watchnow/domain/entities/episode_detail.dart';
import 'package:watchnow/domain/entities/genre.dart';
import 'package:watchnow/domain/entities/movie.dart';
import 'package:watchnow/domain/entities/movie_detail.dart';
import 'package:watchnow/domain/entities/season.dart';
import 'package:watchnow/domain/entities/season_detail.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/domain/entities/tv_show_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  overview: 'overview',
  posterPath: 'posterPath',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTVShow = TVShow(
  id: 60708,
  name: "Gotham",
  overview:
      "Everyone knows the name Commissioner Gordon. He is one of the crime world's greatest foes, a man whose reputation is synonymous with law and order. But what is known of Gordon's story and his rise from rookie detective to Police Commissioner? What did it take to navigate the multiple layers of corruption that secretly ruled Gotham City, the spawning ground of the world's most iconic villains? And what circumstances created them – the larger-than-life personas who would become Catwoman, The Penguin, The Riddler, Two-Face and The Joker?",
  posterPath: '/4XddcRDtnNjYmLRMYpbrhFxsbuq.jpg',
);

final testTVShowList = [testTVShow];

final testTVShowDetail = TVShowDetail(
  id: 1,
  posterPath: 'posterPath',
  name: "name",
  genres: [
    Genre(id: 18, name: 'Drama'),
    Genre(id: 80, name: 'Crime'),
    Genre(id: 10765, name: 'Sci-Fi & Fantasy'),
  ],
  voteAverage: 7.6,
  overview: 'overview',
  seasons: [
    Season(
      posterPath: '/ggEVcCvtCcfSgYIeVubCBJXse7X.jpg',
      name: 'Season 1',
      seasonNumber: 1,
    ),
    Season(
      posterPath: '/a47zOXSfa6clj9Vb5Xv2sZg7W3R.jpg',
      name: 'Season 2',
      seasonNumber: 2,
    ),
    Season(
      posterPath: '/rUCkSHEBOMg4JECWZN2fjsVIOrm.jpg',
      name: 'Season 3',
      seasonNumber: 3,
    ),
    Season(
      posterPath: '/6lyumyfM0lx8AApPEqgEKv5lnUy.jpg',
      name: 'Season 4',
      seasonNumber: 4,
    ),
    Season(
      posterPath: '/4XddcRDtnNjYmLRMYpbrhFxsbuq.jpg',
      name: 'Season 5',
      seasonNumber: 5,
    ),
  ],
);

final testSeasonDetail = SeasonDetail(
  posterPath: '/ggEVcCvtCcfSgYIeVubCBJXse7X.jpg',
  name: 'Season 1',
  overview:
      "A new recruit in Captain Sarah Essen's Gotham City Police Department, Detective James Gordon is paired with Harvey Bullock to solve one of Gotham's highest-profile cases: the murder of Thomas and Martha Wayne. During his investigation, Gordon meets the Waynes' son Bruce, now in the care of his butler Alfred Pennyworth, which further compels Gordon to catch the mysterious killer. Along the way, Gordon must confront mobstress Fish Mooney, mafia led by Carmine Falcone, as well as many of Gotham's future villains such as Selina Kyle, Edward Nygma, and Oswald Cobblepot. Eventually, Gordon is forced to form an unlikely friendship with Wayne, one that will help shape the boy's future in his destiny of becoming a crusader.",
  episodes: [
    Episode(
      stillPath: '/yQKuW0jqdVy5ENGlvcKsB82IWwY.jpg',
      name: 'Pilot',
      voteAverage: 7.235,
      episodeNumber: 1,
    ),
    Episode(
      stillPath: '/aNr0SSWvVYOsZWfkgB8XGKjzlJv.jpg',
      name: 'Pilot',
      voteAverage: 7.235,
      episodeNumber: 2,
    ),
    Episode(
      stillPath: '/dXMWKaQlIcFibGMUGIzPj7Io7hn.jpg',
      name: 'Pilot',
      voteAverage: 7.235,
      episodeNumber: 3,
    ),
    Episode(
      stillPath: '/gL4HWIoQKG5kRQCC1YOrW4fCJbn.jpg',
      name: 'Pilot',
      voteAverage: 7.235,
      episodeNumber: 4,
    ),
    Episode(
      stillPath: '/4a77nHzrTD57leSW549e08RBLpi.jpg',
      name: 'Pilot',
      voteAverage: 7.235,
      episodeNumber: 5,
    ),
  ],
  seasonNumber: 1,
);

final testEpisodeDetail = EpisodeDetail(
  id: 975968,
  stillPath: '/yQKuW0jqdVy5ENGlvcKsB82IWwY.jpg',
  name: 'Pilot',
  voteAverage: 7.235,
  overview:
      'Detective James Gordon performs his work in the dangerously corrupt city of Gotham, which consistently teeters between good and evil.',
);

final testTVShowTable = TVShowTable(
  id: 1,
  name: 'name',
  overview: 'overview',
  posterPath: 'posterPath',
);

final testTVShowWatchlist = TVShow(
  id: 1,
  name: 'name',
  overview: 'overview',
  posterPath: 'posterPath',
);

final testTVShowMap = {
  'id': 1,
  'name': 'name',
  'overview': 'overview',
  'posterPath': 'posterPath',
};
